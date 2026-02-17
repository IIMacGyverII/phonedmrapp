.class public Lcom/android/internal/telephony/RadioMessagingProxy;
.super Lcom/android/internal/telephony/RadioServiceProxy;
.source "RadioMessagingProxy.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RadioMessagingProxy"


# instance fields
.field private volatile mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;


# direct methods
.method public static synthetic $r8$lambda$jqvdUTPlGAljc2g2kZcEsGGZrEA(I)[Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->lambda$setCdmaBroadcastConfig$0(I)[Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;

    move-result-object p0

    return-object p0
.end method

.method public constructor <init>()V
    .locals 1

    .line 31
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioServiceProxy;-><init>()V

    const/4 v0, 0x0

    .line 33
    iput-object v0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    return-void
.end method

.method private static synthetic lambda$setCdmaBroadcastConfig$0(I)[Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;
    .locals 0

    .line 403
    new-array p0, p0, [Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;

    return-object p0
.end method


# virtual methods
.method public acknowledgeIncomingGsmSmsWithPdu(IZLjava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 83
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 84
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 85
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/messaging/IRadioMessaging;->acknowledgeIncomingGsmSmsWithPdu(IZLjava/lang/String;)V

    goto :goto_0

    .line 87
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_0/IRadio;->acknowledgeIncomingGsmSmsWithPdu(IZLjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public acknowledgeLastIncomingCdmaSms(IZI)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 100
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 101
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 102
    new-instance v0, Landroid/hardware/radio/messaging/CdmaSmsAck;

    invoke-direct {v0}, Landroid/hardware/radio/messaging/CdmaSmsAck;-><init>()V

    .line 104
    iput-boolean p2, v0, Landroid/hardware/radio/messaging/CdmaSmsAck;->errorClass:Z

    .line 105
    iput p3, v0, Landroid/hardware/radio/messaging/CdmaSmsAck;->smsCauseCode:I

    .line 106
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/messaging/IRadioMessaging;->acknowledgeLastIncomingCdmaSms(ILandroid/hardware/radio/messaging/CdmaSmsAck;)V

    goto :goto_0

    .line 108
    :cond_1
    new-instance v0, Landroid/hardware/radio/V1_0/CdmaSmsAck;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/CdmaSmsAck;-><init>()V

    xor-int/lit8 p2, p2, 0x1

    .line 110
    iput p2, v0, Landroid/hardware/radio/V1_0/CdmaSmsAck;->errorClass:I

    .line 111
    iput p3, v0, Landroid/hardware/radio/V1_0/CdmaSmsAck;->smsCauseCode:I

    .line 112
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->acknowledgeLastIncomingCdmaSms(ILandroid/hardware/radio/V1_0/CdmaSmsAck;)V

    :goto_0
    return-void
.end method

.method public acknowledgeLastIncomingGsmSms(IZI)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 125
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 126
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 127
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/messaging/IRadioMessaging;->acknowledgeLastIncomingGsmSms(IZI)V

    goto :goto_0

    .line 129
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_0/IRadio;->acknowledgeLastIncomingGsmSms(IZI)V

    :goto_0
    return-void
.end method

.method public clear()V
    .locals 1

    .line 61
    invoke-super {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->clear()V

    const/4 v0, 0x0

    .line 62
    iput-object v0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    return-void
.end method

.method public deleteSmsOnRuim(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 140
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 141
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 142
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->deleteSmsOnRuim(II)V

    goto :goto_0

    .line 144
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->deleteSmsOnRuim(II)V

    :goto_0
    return-void
.end method

.method public deleteSmsOnSim(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 155
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 156
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 157
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->deleteSmsOnSim(II)V

    goto :goto_0

    .line 159
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->deleteSmsOnSim(II)V

    :goto_0
    return-void
.end method

.method public getAidl()Landroid/hardware/radio/messaging/IRadioMessaging;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    return-object p0
.end method

.method public getCdmaBroadcastConfig(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 169
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 170
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 171
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1}, Landroid/hardware/radio/messaging/IRadioMessaging;->getCdmaBroadcastConfig(I)V

    goto :goto_0

    .line 173
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getCdmaBroadcastConfig(I)V

    :goto_0
    return-void
.end method

.method public getGsmBroadcastConfig(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 183
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 184
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 185
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1}, Landroid/hardware/radio/messaging/IRadioMessaging;->getGsmBroadcastConfig(I)V

    goto :goto_0

    .line 187
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getGsmBroadcastConfig(I)V

    :goto_0
    return-void
.end method

.method public getSmscAddress(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 197
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 198
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 199
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1}, Landroid/hardware/radio/messaging/IRadioMessaging;->getSmscAddress(I)V

    goto :goto_0

    .line 201
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getSmscAddress(I)V

    :goto_0
    return-void
.end method

.method public isEmpty()Z
    .locals 1

    .line 71
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public reportSmsMemoryStatus(IZ)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 212
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 213
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 214
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->reportSmsMemoryStatus(IZ)V

    goto :goto_0

    .line 216
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->reportSmsMemoryStatus(IZ)V

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

    .line 226
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 227
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 228
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0}, Landroid/hardware/radio/messaging/IRadioMessaging;->responseAcknowledgement()V

    goto :goto_0

    .line 230
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0}, Landroid/hardware/radio/V1_0/IRadio;->responseAcknowledgement()V

    :goto_0
    return-void
.end method

.method public sendCdmaSms(I[B)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 241
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 242
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 243
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessageAidl([B)Landroid/hardware/radio/messaging/CdmaSmsMessage;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->sendCdmaSms(ILandroid/hardware/radio/messaging/CdmaSmsMessage;)V

    goto :goto_0

    .line 244
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 245
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    .line 246
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessage([B)Landroid/hardware/radio/V1_0/CdmaSmsMessage;

    move-result-object p2

    .line 245
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->sendCdmaSms_1_6(ILandroid/hardware/radio/V1_0/CdmaSmsMessage;)V

    goto :goto_0

    .line 248
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessage([B)Landroid/hardware/radio/V1_0/CdmaSmsMessage;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->sendCdmaSms(ILandroid/hardware/radio/V1_0/CdmaSmsMessage;)V

    :goto_0
    return-void
.end method

.method public sendCdmaSmsExpectMore(I[B)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 259
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 260
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 261
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    .line 262
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessageAidl([B)Landroid/hardware/radio/messaging/CdmaSmsMessage;

    move-result-object p2

    .line 261
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->sendCdmaSmsExpectMore(ILandroid/hardware/radio/messaging/CdmaSmsMessage;)V

    goto :goto_0

    .line 263
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 264
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    .line 265
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessage([B)Landroid/hardware/radio/V1_0/CdmaSmsMessage;

    move-result-object p2

    .line 264
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->sendCdmaSmsExpectMore_1_6(ILandroid/hardware/radio/V1_0/CdmaSmsMessage;)V

    goto :goto_0

    .line 266
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 267
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    .line 268
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessage([B)Landroid/hardware/radio/V1_0/CdmaSmsMessage;

    move-result-object p2

    .line 267
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_5/IRadio;->sendCdmaSmsExpectMore(ILandroid/hardware/radio/V1_0/CdmaSmsMessage;)V

    goto :goto_0

    .line 270
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessage([B)Landroid/hardware/radio/V1_0/CdmaSmsMessage;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->sendCdmaSms(ILandroid/hardware/radio/V1_0/CdmaSmsMessage;)V

    :goto_0
    return-void
.end method

.method public sendImsSms(ILjava/lang/String;Ljava/lang/String;[BII)V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 288
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 289
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_4

    .line 290
    new-instance v0, Landroid/hardware/radio/messaging/ImsSmsMessage;

    invoke-direct {v0}, Landroid/hardware/radio/messaging/ImsSmsMessage;-><init>()V

    .line 292
    iput v2, v0, Landroid/hardware/radio/messaging/ImsSmsMessage;->tech:I

    int-to-byte p5, p5

    if-lt p5, v1, :cond_1

    move p5, v1

    goto :goto_0

    :cond_1
    move p5, v2

    .line 293
    :goto_0
    iput-boolean p5, v0, Landroid/hardware/radio/messaging/ImsSmsMessage;->retry:Z

    .line 294
    iput p6, v0, Landroid/hardware/radio/messaging/ImsSmsMessage;->messageRef:I

    if-eqz p3, :cond_2

    new-array p5, v1, [Landroid/hardware/radio/messaging/GsmSmsMessage;

    .line 297
    invoke-static {p2, p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalGsmSmsMessageAidl(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/messaging/GsmSmsMessage;

    move-result-object p2

    aput-object p2, p5, v2

    iput-object p5, v0, Landroid/hardware/radio/messaging/ImsSmsMessage;->gsmMessage:[Landroid/hardware/radio/messaging/GsmSmsMessage;

    new-array p2, v2, [Landroid/hardware/radio/messaging/CdmaSmsMessage;

    .line 298
    iput-object p2, v0, Landroid/hardware/radio/messaging/ImsSmsMessage;->cdmaMessage:[Landroid/hardware/radio/messaging/CdmaSmsMessage;

    :cond_2
    if-eqz p4, :cond_3

    new-array p2, v2, [Landroid/hardware/radio/messaging/GsmSmsMessage;

    .line 301
    iput-object p2, v0, Landroid/hardware/radio/messaging/ImsSmsMessage;->gsmMessage:[Landroid/hardware/radio/messaging/GsmSmsMessage;

    new-array p2, v1, [Landroid/hardware/radio/messaging/CdmaSmsMessage;

    .line 303
    invoke-static {p4}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessageAidl([B)Landroid/hardware/radio/messaging/CdmaSmsMessage;

    move-result-object p3

    aput-object p3, p2, v2

    iput-object p2, v0, Landroid/hardware/radio/messaging/ImsSmsMessage;->cdmaMessage:[Landroid/hardware/radio/messaging/CdmaSmsMessage;

    .line 305
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/messaging/IRadioMessaging;->sendImsSms(ILandroid/hardware/radio/messaging/ImsSmsMessage;)V

    goto :goto_2

    .line 307
    :cond_4
    new-instance v0, Landroid/hardware/radio/V1_0/ImsSmsMessage;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/ImsSmsMessage;-><init>()V

    .line 309
    iput v2, v0, Landroid/hardware/radio/V1_0/ImsSmsMessage;->tech:I

    int-to-byte p5, p5

    if-lt p5, v1, :cond_5

    goto :goto_1

    :cond_5
    move v1, v2

    .line 310
    :goto_1
    iput-boolean v1, v0, Landroid/hardware/radio/V1_0/ImsSmsMessage;->retry:Z

    .line 311
    iput p6, v0, Landroid/hardware/radio/V1_0/ImsSmsMessage;->messageRef:I

    if-eqz p3, :cond_6

    .line 313
    iget-object p5, v0, Landroid/hardware/radio/V1_0/ImsSmsMessage;->gsmMessage:Ljava/util/ArrayList;

    invoke-static {p2, p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalGsmSmsMessage(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/V1_0/GsmSmsMessage;

    move-result-object p2

    invoke-virtual {p5, p2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_6
    if-eqz p4, :cond_7

    .line 316
    iget-object p2, v0, Landroid/hardware/radio/V1_0/ImsSmsMessage;->cdmaMessage:Ljava/util/ArrayList;

    invoke-static {p4}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessage([B)Landroid/hardware/radio/V1_0/CdmaSmsMessage;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 318
    :cond_7
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->sendImsSms(ILandroid/hardware/radio/V1_0/ImsSmsMessage;)V

    :goto_2
    return-void
.end method

.method public sendSms(ILjava/lang/String;Ljava/lang/String;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 331
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 332
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 333
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-static {p2, p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalGsmSmsMessageAidl(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/messaging/GsmSmsMessage;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->sendSms(ILandroid/hardware/radio/messaging/GsmSmsMessage;)V

    goto :goto_0

    .line 334
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 335
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    .line 336
    invoke-static {p2, p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalGsmSmsMessage(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/V1_0/GsmSmsMessage;

    move-result-object p2

    .line 335
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->sendSms_1_6(ILandroid/hardware/radio/V1_0/GsmSmsMessage;)V

    goto :goto_0

    .line 338
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-static {p2, p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalGsmSmsMessage(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/V1_0/GsmSmsMessage;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->sendSms(ILandroid/hardware/radio/V1_0/GsmSmsMessage;)V

    :goto_0
    return-void
.end method

.method public sendSmsExpectMore(ILjava/lang/String;Ljava/lang/String;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 351
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 352
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 353
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    .line 354
    invoke-static {p2, p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalGsmSmsMessageAidl(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/messaging/GsmSmsMessage;

    move-result-object p2

    .line 353
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->sendSmsExpectMore(ILandroid/hardware/radio/messaging/GsmSmsMessage;)V

    goto :goto_0

    .line 355
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 356
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    .line 357
    invoke-static {p2, p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalGsmSmsMessage(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/V1_0/GsmSmsMessage;

    move-result-object p2

    .line 356
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->sendSmsExpectMore_1_6(ILandroid/hardware/radio/V1_0/GsmSmsMessage;)V

    goto :goto_0

    .line 359
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-static {p2, p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalGsmSmsMessage(Ljava/lang/String;Ljava/lang/String;)Landroid/hardware/radio/V1_0/GsmSmsMessage;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->sendSMSExpectMore(ILandroid/hardware/radio/V1_0/GsmSmsMessage;)V

    :goto_0
    return-void
.end method

.method public setAidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/messaging/IRadioMessaging;)V
    .locals 0

    .line 42
    iput-object p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    .line 43
    iput-object p2, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    const/4 p1, 0x1

    .line 44
    iput-boolean p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mIsAidl:Z

    const-string p0, "RadioMessagingProxy"

    const-string p1, "AIDL initialized"

    .line 45
    invoke-static {p0, p1}, Landroid/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public setCdmaBroadcastActivation(IZ)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 371
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 372
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 373
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->setCdmaBroadcastActivation(IZ)V

    goto :goto_0

    .line 375
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setCdmaBroadcastActivation(IZ)V

    :goto_0
    return-void
.end method

.method public setCdmaBroadcastConfig(I[Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;)V
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 387
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 388
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_3

    .line 389
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 391
    array-length v2, p2

    :goto_0
    if-ge v1, v2, :cond_2

    aget-object v3, p2, v1

    .line 392
    invoke-virtual {v3}, Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;->getFromServiceCategory()I

    move-result v4

    :goto_1
    invoke-virtual {v3}, Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;->getToServiceCategory()I

    move-result v5

    if-gt v4, v5, :cond_1

    .line 394
    new-instance v5, Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;

    invoke-direct {v5}, Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;-><init>()V

    .line 396
    iput v4, v5, Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;->serviceCategory:I

    .line 397
    invoke-virtual {v3}, Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;->getLanguage()I

    move-result v6

    iput v6, v5, Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;->language:I

    .line 398
    invoke-virtual {v3}, Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;->isSelected()Z

    move-result v6

    iput-boolean v6, v5, Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;->selected:Z

    .line 399
    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 402
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-virtual {v0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v0, Lcom/android/internal/telephony/RadioMessagingProxy$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/RadioMessagingProxy$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {p2, v0}, Ljava/util/stream/Stream;->toArray(Ljava/util/function/IntFunction;)[Ljava/lang/Object;

    move-result-object p2

    check-cast p2, [Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->setCdmaBroadcastConfig(I[Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;)V

    goto :goto_4

    .line 405
    :cond_3
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 407
    array-length v2, p2

    :goto_2
    if-ge v1, v2, :cond_5

    aget-object v3, p2, v1

    .line 408
    invoke-virtual {v3}, Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;->getFromServiceCategory()I

    move-result v4

    :goto_3
    invoke-virtual {v3}, Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;->getToServiceCategory()I

    move-result v5

    if-gt v4, v5, :cond_4

    .line 410
    new-instance v5, Landroid/hardware/radio/V1_0/CdmaBroadcastSmsConfigInfo;

    invoke-direct {v5}, Landroid/hardware/radio/V1_0/CdmaBroadcastSmsConfigInfo;-><init>()V

    .line 412
    iput v4, v5, Landroid/hardware/radio/V1_0/CdmaBroadcastSmsConfigInfo;->serviceCategory:I

    .line 413
    invoke-virtual {v3}, Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;->getLanguage()I

    move-result v6

    iput v6, v5, Landroid/hardware/radio/V1_0/CdmaBroadcastSmsConfigInfo;->language:I

    .line 414
    invoke-virtual {v3}, Lcom/android/internal/telephony/cdma/CdmaSmsBroadcastConfigInfo;->isSelected()Z

    move-result v6

    iput-boolean v6, v5, Landroid/hardware/radio/V1_0/CdmaBroadcastSmsConfigInfo;->selected:Z

    .line 415
    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v4, v4, 0x1

    goto :goto_3

    :cond_4
    add-int/lit8 v1, v1, 0x1

    goto :goto_2

    .line 418
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->setCdmaBroadcastConfig(ILjava/util/ArrayList;)V

    :goto_4
    return-void
.end method

.method public setGsmBroadcastActivation(IZ)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 430
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 431
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 432
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->setGsmBroadcastActivation(IZ)V

    goto :goto_0

    .line 434
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setGsmBroadcastActivation(IZ)V

    :goto_0
    return-void
.end method

.method public setGsmBroadcastConfig(I[Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 446
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 447
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 448
    array-length v0, p2

    new-array v0, v0, [Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;

    .line 452
    :goto_0
    array-length v2, p2

    if-ge v1, v2, :cond_1

    .line 453
    new-instance v2, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;

    invoke-direct {v2}, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;-><init>()V

    .line 454
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->getFromServiceId()I

    move-result v3

    iput v3, v2, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->fromServiceId:I

    .line 455
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->getToServiceId()I

    move-result v3

    iput v3, v2, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->toServiceId:I

    .line 456
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->getFromCodeScheme()I

    move-result v3

    iput v3, v2, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->fromCodeScheme:I

    .line 457
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->getToCodeScheme()I

    move-result v3

    iput v3, v2, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->toCodeScheme:I

    .line 458
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->isSelected()Z

    move-result v3

    iput-boolean v3, v2, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->selected:Z

    .line 459
    aput-object v2, v0, v1

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 461
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/messaging/IRadioMessaging;->setGsmBroadcastConfig(I[Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;)V

    goto :goto_2

    .line 463
    :cond_2
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 466
    :goto_1
    array-length v2, p2

    if-ge v1, v2, :cond_3

    .line 467
    new-instance v2, Landroid/hardware/radio/V1_0/GsmBroadcastSmsConfigInfo;

    invoke-direct {v2}, Landroid/hardware/radio/V1_0/GsmBroadcastSmsConfigInfo;-><init>()V

    .line 468
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->getFromServiceId()I

    move-result v3

    iput v3, v2, Landroid/hardware/radio/V1_0/GsmBroadcastSmsConfigInfo;->fromServiceId:I

    .line 469
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->getToServiceId()I

    move-result v3

    iput v3, v2, Landroid/hardware/radio/V1_0/GsmBroadcastSmsConfigInfo;->toServiceId:I

    .line 470
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->getFromCodeScheme()I

    move-result v3

    iput v3, v2, Landroid/hardware/radio/V1_0/GsmBroadcastSmsConfigInfo;->fromCodeScheme:I

    .line 471
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->getToCodeScheme()I

    move-result v3

    iput v3, v2, Landroid/hardware/radio/V1_0/GsmBroadcastSmsConfigInfo;->toCodeScheme:I

    .line 472
    aget-object v3, p2, v1

    invoke-virtual {v3}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;->isSelected()Z

    move-result v3

    iput-boolean v3, v2, Landroid/hardware/radio/V1_0/GsmBroadcastSmsConfigInfo;->selected:Z

    .line 473
    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 475
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->setGsmBroadcastConfig(ILjava/util/ArrayList;)V

    :goto_2
    return-void
.end method

.method public setSmscAddress(ILjava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 486
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 487
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 488
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/messaging/IRadioMessaging;->setSmscAddress(ILjava/lang/String;)V

    goto :goto_0

    .line 490
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setSmscAddress(ILjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public writeSmsToRuim(II[B)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 506
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 507
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 508
    new-instance v0, Landroid/hardware/radio/messaging/CdmaSmsWriteArgs;

    invoke-direct {v0}, Landroid/hardware/radio/messaging/CdmaSmsWriteArgs;-><init>()V

    .line 510
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalSmsWriteArgsStatusAidl(I)I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/messaging/CdmaSmsWriteArgs;->status:I

    .line 511
    invoke-static {p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessageAidl([B)Landroid/hardware/radio/messaging/CdmaSmsMessage;

    move-result-object p2

    iput-object p2, v0, Landroid/hardware/radio/messaging/CdmaSmsWriteArgs;->message:Landroid/hardware/radio/messaging/CdmaSmsMessage;

    .line 512
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/messaging/IRadioMessaging;->writeSmsToRuim(ILandroid/hardware/radio/messaging/CdmaSmsWriteArgs;)V

    goto :goto_0

    .line 514
    :cond_1
    new-instance v0, Landroid/hardware/radio/V1_0/CdmaSmsWriteArgs;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/CdmaSmsWriteArgs;-><init>()V

    .line 516
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalSmsWriteArgsStatus(I)I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/V1_0/CdmaSmsWriteArgs;->status:I

    .line 517
    invoke-static {p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalCdmaSmsMessage([B)Landroid/hardware/radio/V1_0/CdmaSmsMessage;

    move-result-object p2

    iput-object p2, v0, Landroid/hardware/radio/V1_0/CdmaSmsWriteArgs;->message:Landroid/hardware/radio/V1_0/CdmaSmsMessage;

    .line 518
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->writeSmsToRuim(ILandroid/hardware/radio/V1_0/CdmaSmsWriteArgs;)V

    :goto_0
    return-void
.end method

.method public writeSmsToSim(IILjava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 536
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioMessagingProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 537
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 538
    new-instance v0, Landroid/hardware/radio/messaging/SmsWriteArgs;

    invoke-direct {v0}, Landroid/hardware/radio/messaging/SmsWriteArgs;-><init>()V

    .line 540
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalSmsWriteArgsStatusAidl(I)I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/messaging/SmsWriteArgs;->status:I

    .line 541
    iput-object p3, v0, Landroid/hardware/radio/messaging/SmsWriteArgs;->smsc:Ljava/lang/String;

    .line 542
    iput-object p4, v0, Landroid/hardware/radio/messaging/SmsWriteArgs;->pdu:Ljava/lang/String;

    .line 543
    iget-object p0, p0, Lcom/android/internal/telephony/RadioMessagingProxy;->mMessagingProxy:Landroid/hardware/radio/messaging/IRadioMessaging;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/messaging/IRadioMessaging;->writeSmsToSim(ILandroid/hardware/radio/messaging/SmsWriteArgs;)V

    goto :goto_0

    .line 545
    :cond_1
    new-instance v0, Landroid/hardware/radio/V1_0/SmsWriteArgs;

    invoke-direct {v0}, Landroid/hardware/radio/V1_0/SmsWriteArgs;-><init>()V

    .line 547
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalSmsWriteArgsStatus(I)I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/V1_0/SmsWriteArgs;->status:I

    .line 548
    iput-object p3, v0, Landroid/hardware/radio/V1_0/SmsWriteArgs;->smsc:Ljava/lang/String;

    .line 549
    iput-object p4, v0, Landroid/hardware/radio/V1_0/SmsWriteArgs;->pdu:Ljava/lang/String;

    .line 550
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_0/IRadio;->writeSmsToSim(ILandroid/hardware/radio/V1_0/SmsWriteArgs;)V

    :goto_0
    return-void
.end method
