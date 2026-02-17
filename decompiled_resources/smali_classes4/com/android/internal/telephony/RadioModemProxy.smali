.class public Lcom/android/internal/telephony/RadioModemProxy;
.super Lcom/android/internal/telephony/RadioServiceProxy;
.source "RadioModemProxy.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RadioModemProxy"


# instance fields
.field private volatile mModemProxy:Landroid/hardware/radio/modem/IRadioModem;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 26
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioServiceProxy;-><init>()V

    const/4 v0, 0x0

    .line 28
    iput-object v0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    return-void
.end method


# virtual methods
.method public clear()V
    .locals 1

    .line 56
    invoke-super {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->clear()V

    const/4 v0, 0x0

    .line 57
    iput-object v0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    return-void
.end method

.method public enableModem(IZ)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 76
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_3:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 77
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 78
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/modem/IRadioModem;->enableModem(IZ)V

    goto :goto_0

    .line 80
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_3/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_3/IRadio;->enableModem(IZ)V

    :cond_2
    :goto_0
    return-void
.end method

.method public getAidl()Landroid/hardware/radio/modem/IRadioModem;
    .locals 0

    .line 48
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    return-object p0
.end method

.method public getBasebandVersion(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 90
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 91
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 92
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1}, Landroid/hardware/radio/modem/IRadioModem;->getBasebandVersion(I)V

    goto :goto_0

    .line 94
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getBasebandVersion(I)V

    :goto_0
    return-void
.end method

.method public getDeviceIdentity(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 104
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 105
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 106
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1}, Landroid/hardware/radio/modem/IRadioModem;->getDeviceIdentity(I)V

    goto :goto_0

    .line 108
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getDeviceIdentity(I)V

    :goto_0
    return-void
.end method

.method public getHardwareConfig(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 118
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 119
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 120
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1}, Landroid/hardware/radio/modem/IRadioModem;->getHardwareConfig(I)V

    goto :goto_0

    .line 122
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getHardwareConfig(I)V

    :goto_0
    return-void
.end method

.method public getModemActivityInfo(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 132
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 133
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 134
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1}, Landroid/hardware/radio/modem/IRadioModem;->getModemActivityInfo(I)V

    goto :goto_0

    .line 136
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getModemActivityInfo(I)V

    :goto_0
    return-void
.end method

.method public getModemStackStatus(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 146
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_3:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 147
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 148
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1}, Landroid/hardware/radio/modem/IRadioModem;->getModemStackStatus(I)V

    goto :goto_0

    .line 150
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_3/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_3/IRadio;->getModemStackStatus(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public getRadioCapability(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 160
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 161
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 162
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1}, Landroid/hardware/radio/modem/IRadioModem;->getRadioCapability(I)V

    goto :goto_0

    .line 164
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getRadioCapability(I)V

    :goto_0
    return-void
.end method

.method public isEmpty()Z
    .locals 1

    .line 66
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public nvReadItem(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 175
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 176
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 177
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/modem/IRadioModem;->nvReadItem(II)V

    goto :goto_0

    .line 179
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->nvReadItem(II)V

    :goto_0
    return-void
.end method

.method public nvResetConfig(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 190
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 191
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 192
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalResetNvTypeAidl(I)I

    move-result p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/modem/IRadioModem;->nvResetConfig(II)V

    goto :goto_0

    .line 194
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalResetNvType(I)I

    move-result p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->nvResetConfig(II)V

    :goto_0
    return-void
.end method

.method public nvWriteCdmaPrl(I[B)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 205
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 206
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 207
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/modem/IRadioModem;->nvWriteCdmaPrl(I[B)V

    goto :goto_0

    .line 209
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([B)Ljava/util/ArrayList;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->nvWriteCdmaPrl(ILjava/util/ArrayList;)V

    :goto_0
    return-void
.end method

.method public nvWriteItem(IILjava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 221
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 222
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 223
    new-instance v0, Landroid/hardware/radio/modem/NvWriteItem;

    invoke-direct {v0}, Landroid/hardware/radio/modem/NvWriteItem;-><init>()V

    .line 225
    iput p2, v0, Landroid/hardware/radio/modem/NvWriteItem;->itemId:I

    .line 226
    iput-object p3, v0, Landroid/hardware/radio/modem/NvWriteItem;->value:Ljava/lang/String;

    .line 227
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/modem/IRadioModem;->nvWriteItem(ILandroid/hardware/radio/modem/NvWriteItem;)V

    goto :goto_0

    .line 229
    :cond_1
    new-instance v0, Landroid/hardware/radio/V1_0/NvWriteItem;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/NvWriteItem;-><init>()V

    .line 231
    iput p2, v0, Landroid/hardware/radio/V1_0/NvWriteItem;->itemId:I

    .line 232
    iput-object p3, v0, Landroid/hardware/radio/V1_0/NvWriteItem;->value:Ljava/lang/String;

    .line 233
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->nvWriteItem(ILandroid/hardware/radio/V1_0/NvWriteItem;)V

    :goto_0
    return-void
.end method

.method public requestShutdown(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 243
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 244
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 245
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1}, Landroid/hardware/radio/modem/IRadioModem;->requestShutdown(I)V

    goto :goto_0

    .line 247
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->requestShutdown(I)V

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

    .line 257
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 258
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 259
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0}, Landroid/hardware/radio/modem/IRadioModem;->responseAcknowledgement()V

    goto :goto_0

    .line 261
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0}, Landroid/hardware/radio/V1_0/IRadio;->responseAcknowledgement()V

    :goto_0
    return-void
.end method

.method public sendDeviceState(IIZ)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 274
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 275
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 276
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/modem/IRadioModem;->sendDeviceState(IIZ)V

    goto :goto_0

    .line 278
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_0/IRadio;->sendDeviceState(IIZ)V

    :goto_0
    return-void
.end method

.method public setAidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/modem/IRadioModem;)V
    .locals 0

    .line 37
    iput-object p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    .line 38
    iput-object p2, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    const/4 p1, 0x1

    .line 39
    iput-boolean p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mIsAidl:Z

    const-string p0, "RadioModemProxy"

    const-string p1, "AIDL initialized"

    .line 40
    invoke-static {p0, p1}, Landroid/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public setRadioCapability(ILcom/android/internal/telephony/RadioCapability;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 290
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 291
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 292
    new-instance v0, Landroid/hardware/radio/modem/RadioCapability;

    invoke-direct {v0}, Landroid/hardware/radio/modem/RadioCapability;-><init>()V

    .line 294
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getSession()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/modem/RadioCapability;->session:I

    .line 295
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getPhase()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/modem/RadioCapability;->phase:I

    .line 296
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getRadioAccessFamily()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessFamilyAidl(I)I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/modem/RadioCapability;->raf:I

    .line 297
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getLogicalModemUuid()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/modem/RadioCapability;->logicalModemUuid:Ljava/lang/String;

    .line 298
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getStatus()I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/modem/RadioCapability;->status:I

    .line 299
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/modem/IRadioModem;->setRadioCapability(ILandroid/hardware/radio/modem/RadioCapability;)V

    goto :goto_0

    .line 301
    :cond_1
    new-instance v0, Landroid/hardware/radio/V1_0/RadioCapability;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/RadioCapability;-><init>()V

    .line 303
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getSession()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/RadioCapability;->session:I

    .line 304
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getPhase()I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/RadioCapability;->phase:I

    .line 305
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getRadioAccessFamily()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessFamily(I)I

    move-result v1

    iput v1, v0, Landroid/hardware/radio/V1_0/RadioCapability;->raf:I

    .line 306
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getLogicalModemUuid()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertNullToEmptyString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/hardware/radio/V1_0/RadioCapability;->logicalModemUuid:Ljava/lang/String;

    .line 307
    invoke-virtual {p2}, Lcom/android/internal/telephony/RadioCapability;->getStatus()I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/V1_0/RadioCapability;->status:I

    .line 308
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->setRadioCapability(ILandroid/hardware/radio/V1_0/RadioCapability;)V

    :goto_0
    return-void
.end method

.method public setRadioPower(IZZZ)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 325
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioModemProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 326
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 327
    iget-object p0, p0, Lcom/android/internal/telephony/RadioModemProxy;->mModemProxy:Landroid/hardware/radio/modem/IRadioModem;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/modem/IRadioModem;->setRadioPower(IZZZ)V

    goto :goto_0

    .line 328
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 329
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/V1_6/IRadio;->setRadioPower_1_6(IZZZ)V

    goto :goto_0

    .line 331
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 332
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/V1_5/IRadio;->setRadioPower_1_5(IZZZ)V

    goto :goto_0

    .line 335
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setRadioPower(IZ)V

    :goto_0
    return-void
.end method
