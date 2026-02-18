.class public Lcom/android/internal/telephony/RadioNetworkProxy;
.super Lcom/android/internal/telephony/RadioServiceProxy;
.source "RadioNetworkProxy.java"


# static fields
.field private static final INDICATION_FILTERS_ALL_AIDL:I = 0x7f

.field private static final INDICATION_FILTERS_ALL_V1_0:I = 0x7

.field private static final INDICATION_FILTERS_ALL_V1_2:I = 0x1f

.field private static final INDICATION_FILTERS_ALL_V1_5:I = 0x7f

.field private static final TAG:Ljava/lang/String; = "RadioNetworkProxy"


# instance fields
.field private volatile mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;


# direct methods
.method public static synthetic $r8$lambda$GRSJKqsnhNQDnaP_JhudHSNgagk(I)[Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->lambda$startNetworkScan$1(I)[Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$nK6ky9mBjfF8NrQdxtndeij3lnQ(I)[Landroid/hardware/radio/network/RadioAccessSpecifier;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->lambda$startNetworkScan$2(I)[Landroid/hardware/radio/network/RadioAccessSpecifier;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$pSAYVRji9CpozVraZAkQS3MUYiM(I)[Landroid/hardware/radio/network/RadioAccessSpecifier;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->lambda$setSystemSelectionChannels$0(I)[Landroid/hardware/radio/network/RadioAccessSpecifier;

    move-result-object p0

    return-object p0
.end method

.method public constructor <init>()V
    .locals 1

    .line 39
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioServiceProxy;-><init>()V

    const/4 v0, 0x0

    .line 41
    iput-object v0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    return-void
.end method

.method private static synthetic lambda$setSystemSelectionChannels$0(I)[Landroid/hardware/radio/network/RadioAccessSpecifier;
    .locals 0

    .line 654
    new-array p0, p0, [Landroid/hardware/radio/network/RadioAccessSpecifier;

    return-object p0
.end method

.method private static synthetic lambda$startNetworkScan$1(I)[Ljava/lang/String;
    .locals 0

    .line 686
    new-array p0, p0, [Ljava/lang/String;

    return-object p0
.end method

.method private static synthetic lambda$startNetworkScan$2(I)[Landroid/hardware/radio/network/RadioAccessSpecifier;
    .locals 0

    .line 701
    new-array p0, p0, [Landroid/hardware/radio/network/RadioAccessSpecifier;

    return-object p0
.end method


# virtual methods
.method public clear()V
    .locals 1

    .line 90
    invoke-super {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->clear()V

    const/4 v0, 0x0

    .line 91
    iput-object v0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    return-void
.end method

.method public getAidl()Landroid/hardware/radio/network/IRadioNetwork;
    .locals 0

    .line 82
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    return-object p0
.end method

.method public getAllowedNetworkTypesBitmap(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 109
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 110
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 111
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getAllowedNetworkTypesBitmap(I)V

    goto :goto_0

    .line 112
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 113
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getAllowedNetworkTypesBitmap(I)V

    goto :goto_0

    .line 114
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 115
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_4/IRadio;

    .line 116
    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_4/IRadio;->getPreferredNetworkTypeBitmap(I)V

    goto :goto_0

    .line 118
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getPreferredNetworkType(I)V

    :goto_0
    return-void
.end method

.method public getAvailableBandModes(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 128
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 129
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 130
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getAvailableBandModes(I)V

    goto :goto_0

    .line 132
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getAvailableBandModes(I)V

    :goto_0
    return-void
.end method

.method public getAvailableNetworks(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 142
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 143
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 144
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getAvailableNetworks(I)V

    goto :goto_0

    .line 146
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getAvailableNetworks(I)V

    :goto_0
    return-void
.end method

.method public getBarringInfo(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 156
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 157
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 158
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getBarringInfo(I)V

    goto :goto_0

    .line 160
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_5/IRadio;->getBarringInfo(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public getCdmaRoamingPreference(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 170
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 171
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 172
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getCdmaRoamingPreference(I)V

    goto :goto_0

    .line 174
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getCdmaRoamingPreference(I)V

    :goto_0
    return-void
.end method

.method public getCellInfoList(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 184
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 185
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 186
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getCellInfoList(I)V

    goto :goto_0

    .line 187
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 188
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getCellInfoList_1_6(I)V

    goto :goto_0

    .line 190
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getCellInfoList(I)V

    :goto_0
    return-void
.end method

.method public getDataRegistrationState(ILcom/android/internal/telephony/HalVersion;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 202
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 203
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 204
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getDataRegistrationState(I)V

    goto :goto_0

    :cond_1
    if-eqz p2, :cond_2

    .line 205
    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    .line 206
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    .line 207
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 208
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getDataRegistrationState_1_6(I)V

    goto :goto_0

    :cond_3
    if-eqz p2, :cond_4

    .line 209
    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    .line 210
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p2

    if-eqz p2, :cond_5

    :cond_4
    iget-object p2, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    .line 211
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p2

    if-eqz p2, :cond_5

    .line 212
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_5/IRadio;->getDataRegistrationState_1_5(I)V

    goto :goto_0

    .line 214
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getDataRegistrationState(I)V

    :goto_0
    return-void
.end method

.method public getImsRegistrationState(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 224
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 225
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 226
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getImsRegistrationState(I)V

    goto :goto_0

    .line 228
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getImsRegistrationState(I)V

    :goto_0
    return-void
.end method

.method public getNetworkSelectionMode(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 238
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 239
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 240
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getNetworkSelectionMode(I)V

    goto :goto_0

    .line 242
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getNetworkSelectionMode(I)V

    :goto_0
    return-void
.end method

.method public getOperator(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 252
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 253
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 254
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getOperator(I)V

    goto :goto_0

    .line 256
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getOperator(I)V

    :goto_0
    return-void
.end method

.method public getSignalStrength(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 266
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 267
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 268
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getSignalStrength(I)V

    goto :goto_0

    .line 269
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 270
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getSignalStrength_1_6(I)V

    goto :goto_0

    .line 271
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 272
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_4/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_4/IRadio;->getSignalStrength_1_4(I)V

    goto :goto_0

    .line 274
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getSignalStrength(I)V

    :goto_0
    return-void
.end method

.method public getSystemSelectionChannels(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 284
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 285
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 286
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getSystemSelectionChannels(I)V

    goto :goto_0

    .line 288
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getSystemSelectionChannels(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public getUsageSetting(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 811
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 812
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 813
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getUsageSetting(I)V

    :cond_1
    return-void
.end method

.method public getVoiceRadioTechnology(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 298
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 299
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 300
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getVoiceRadioTechnology(I)V

    goto :goto_0

    .line 302
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getVoiceRadioTechnology(I)V

    :goto_0
    return-void
.end method

.method public getVoiceRegistrationState(ILcom/android/internal/telephony/HalVersion;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 314
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 315
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 316
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->getVoiceRegistrationState(I)V

    goto :goto_0

    :cond_1
    if-eqz p2, :cond_2

    .line 317
    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    .line 318
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    .line 319
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 320
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    .line 321
    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getVoiceRegistrationState_1_6(I)V

    goto :goto_0

    :cond_3
    if-eqz p2, :cond_4

    .line 322
    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    .line 323
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p2

    if-eqz p2, :cond_5

    :cond_4
    iget-object p2, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    .line 324
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p2

    if-eqz p2, :cond_5

    .line 325
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    .line 326
    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_5/IRadio;->getVoiceRegistrationState_1_5(I)V

    goto :goto_0

    .line 328
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getVoiceRegistrationState(I)V

    :goto_0
    return-void
.end method

.method public isEmpty()Z
    .locals 1

    .line 100
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isNrDualConnectivityEnabled(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 338
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 339
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 340
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->isNrDualConnectivityEnabled(I)V

    goto :goto_0

    .line 342
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->isNrDualConnectivityEnabled(I)V

    :cond_2
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

    .line 352
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 353
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 354
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0}, Landroid/hardware/radio/network/IRadioNetwork;->responseAcknowledgement()V

    goto :goto_0

    .line 356
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0}, Landroid/hardware/radio/V1_0/IRadio;->responseAcknowledgement()V

    :goto_0
    return-void
.end method

.method public setAidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/network/IRadioNetwork;)V
    .locals 0

    .line 71
    iput-object p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    .line 72
    iput-object p2, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    const/4 p1, 0x1

    .line 73
    iput-boolean p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mIsAidl:Z

    const-string p0, "RadioNetworkProxy"

    const-string p1, "AIDL initialized"

    .line 74
    invoke-static {p0, p1}, Landroid/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public setAllowedNetworkTypesBitmap(II)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 368
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 369
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 370
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    .line 371
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessFamilyAidl(I)I

    move-result p2

    .line 370
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setAllowedNetworkTypesBitmap(II)V

    goto :goto_0

    .line 373
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    .line 374
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessFamily(I)I

    move-result p2

    .line 373
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->setAllowedNetworkTypesBitmap(II)V

    :cond_2
    :goto_0
    return-void
.end method

.method public setBandMode(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 402
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 403
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 404
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setBandMode(II)V

    goto :goto_0

    .line 406
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setBandMode(II)V

    :goto_0
    return-void
.end method

.method public setBarringPassword(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 420
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 421
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 422
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/network/IRadioNetwork;->setBarringPassword(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 424
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/V1_0/IRadio;->setBarringPassword(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public setCdmaRoamingPreference(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 435
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 436
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 437
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setCdmaRoamingPreference(II)V

    goto :goto_0

    .line 439
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setCdmaRoamingPreference(II)V

    :goto_0
    return-void
.end method

.method public setCellInfoListRate(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 450
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 451
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 452
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setCellInfoListRate(II)V

    goto :goto_0

    .line 454
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setCellInfoListRate(II)V

    :goto_0
    return-void
.end method

.method public setIndicationFilter(II)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 465
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 466
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 467
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    and-int/lit8 p2, p2, 0x7f

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setIndicationFilter(II)V

    goto :goto_0

    .line 468
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 469
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    and-int/lit8 p2, p2, 0x7f

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_5/IRadio;->setIndicationFilter_1_5(II)V

    goto :goto_0

    .line 471
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_2:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 472
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_2/IRadio;

    and-int/lit8 p2, p2, 0x1f

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_2/IRadio;->setIndicationFilter_1_2(II)V

    goto :goto_0

    .line 475
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    and-int/lit8 p2, p2, 0x7

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setIndicationFilter(II)V

    :goto_0
    return-void
.end method

.method public setLinkCapacityReportingCriteria(IIII[I[II)V
    .locals 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    move-object v0, p0

    .line 497
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_4

    iget-object v1, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v2, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_2:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v1

    if-eqz v1, :cond_0

    goto/16 :goto_1

    .line 498
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 499
    iget-object v2, v0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    .line 501
    invoke-static/range {p7 .. p7}, Lcom/android/internal/telephony/RILUtils;->convertToHalAccessNetworkAidl(I)I

    move-result v9

    move v3, p1

    move v4, p2

    move v5, p3

    move v6, p4

    move-object v7, p5

    move-object/from16 v8, p6

    .line 499
    invoke-interface/range {v2 .. v9}, Landroid/hardware/radio/network/IRadioNetwork;->setLinkCapacityReportingCriteria(IIII[I[II)V

    goto :goto_0

    .line 502
    :cond_1
    iget-object v1, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v2, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 503
    iget-object v0, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    move-object v1, v0

    check-cast v1, Landroid/hardware/radio/V1_5/IRadio;

    .line 505
    invoke-static {p5}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([I)Ljava/util/ArrayList;

    move-result-object v6

    .line 506
    invoke-static/range {p6 .. p6}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([I)Ljava/util/ArrayList;

    move-result-object v7

    .line 507
    invoke-static/range {p7 .. p7}, Lcom/android/internal/telephony/RILUtils;->convertToHalAccessNetwork(I)I

    move-result v8

    move v2, p1

    move v3, p2

    move v4, p3

    move v5, p4

    .line 503
    invoke-interface/range {v1 .. v8}, Landroid/hardware/radio/V1_5/IRadio;->setLinkCapacityReportingCriteria_1_5(IIIILjava/util/ArrayList;Ljava/util/ArrayList;I)V

    goto :goto_0

    :cond_2
    const/4 v1, 0x6

    move/from16 v2, p7

    if-eq v2, v1, :cond_3

    .line 512
    iget-object v0, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    move-object v1, v0

    check-cast v1, Landroid/hardware/radio/V1_2/IRadio;

    .line 514
    invoke-static {p5}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([I)Ljava/util/ArrayList;

    move-result-object v6

    .line 515
    invoke-static/range {p6 .. p6}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([I)Ljava/util/ArrayList;

    move-result-object v7

    .line 516
    invoke-static/range {p7 .. p7}, Lcom/android/internal/telephony/RILUtils;->convertToHalAccessNetwork(I)I

    move-result v8

    move v2, p1

    move v3, p2

    move v4, p3

    move v5, p4

    .line 512
    invoke-interface/range {v1 .. v8}, Landroid/hardware/radio/V1_2/IRadio;->setLinkCapacityReportingCriteria(IIIILjava/util/ArrayList;Ljava/util/ArrayList;I)V

    :goto_0
    return-void

    .line 510
    :cond_3
    new-instance v1, Ljava/lang/RuntimeException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "NGRAN unsupported on IRadio version: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v1

    :cond_4
    :goto_1
    return-void
.end method

.method public setLocationUpdates(IZ)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 528
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 529
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 530
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setLocationUpdates(IZ)V

    goto :goto_0

    .line 532
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setLocationUpdates(IZ)V

    :goto_0
    return-void
.end method

.method public setNetworkSelectionModeAutomatic(I)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 542
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 543
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 544
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->setNetworkSelectionModeAutomatic(I)V

    goto :goto_0

    .line 546
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->setNetworkSelectionModeAutomatic(I)V

    :goto_0
    return-void
.end method

.method public setNetworkSelectionModeManual(ILjava/lang/String;I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 559
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 560
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 561
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    .line 562
    invoke-static {p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalAccessNetworkAidl(I)I

    move-result p3

    .line 561
    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/network/IRadioNetwork;->setNetworkSelectionModeManual(ILjava/lang/String;I)V

    goto :goto_0

    .line 563
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 564
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    .line 565
    invoke-static {p3}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessNetworks(I)I

    move-result p3

    .line 564
    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_5/IRadio;->setNetworkSelectionModeManual_1_5(ILjava/lang/String;I)V

    goto :goto_0

    .line 567
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setNetworkSelectionModeManual(ILjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public setNrDualConnectivityState(IB)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 579
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 580
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 581
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setNrDualConnectivityState(IB)V

    goto :goto_0

    .line 583
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->setNrDualConnectivityState(IB)V

    :cond_2
    :goto_0
    return-void
.end method

.method public setPreferredNetworkTypeBitmap(II)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 386
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 387
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 388
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_4/IRadio;

    .line 389
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessFamily(I)I

    move-result p2

    .line 388
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_4/IRadio;->setPreferredNetworkTypeBitmap(II)V

    goto :goto_0

    .line 391
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setPreferredNetworkType(II)V

    :cond_2
    :goto_0
    return-void
.end method

.method public setSignalStrengthReportingCriteria(ILjava/util/List;)V
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/List<",
            "Landroid/telephony/SignalThresholdInfo;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 596
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_4

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_2:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_3

    .line 597
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 599
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v0

    new-array v0, v0, [Landroid/hardware/radio/network/SignalThresholdInfo;

    const/4 v1, 0x0

    .line 600
    :goto_0
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 602
    invoke-interface {p2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/SignalThresholdInfo;

    .line 601
    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertToHalSignalThresholdInfoAidl(Landroid/telephony/SignalThresholdInfo;)Landroid/hardware/radio/network/SignalThresholdInfo;

    move-result-object v2

    aput-object v2, v0, v1

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 604
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/network/IRadioNetwork;->setSignalStrengthReportingCriteria(I[Landroid/hardware/radio/network/SignalThresholdInfo;)V

    goto :goto_3

    .line 605
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 606
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_1
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_4

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/SignalThresholdInfo;

    .line 607
    iget-object v1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast v1, Landroid/hardware/radio/V1_5/IRadio;

    .line 609
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertToHalSignalThresholdInfo(Landroid/telephony/SignalThresholdInfo;)Landroid/hardware/radio/V1_5/SignalThresholdInfo;

    move-result-object v2

    .line 611
    invoke-virtual {v0}, Landroid/telephony/SignalThresholdInfo;->getRadioAccessNetworkType()I

    move-result v0

    .line 610
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertToHalAccessNetwork(I)I

    move-result v0

    .line 608
    invoke-interface {v1, p1, v2, v0}, Landroid/hardware/radio/V1_5/IRadio;->setSignalStrengthReportingCriteria_1_5(ILandroid/hardware/radio/V1_5/SignalThresholdInfo;I)V

    goto :goto_1

    .line 614
    :cond_3
    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_2
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_4

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/SignalThresholdInfo;

    .line 615
    iget-object v1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    move-object v2, v1

    check-cast v2, Landroid/hardware/radio/V1_2/IRadio;

    .line 617
    invoke-virtual {v0}, Landroid/telephony/SignalThresholdInfo;->getHysteresisMs()I

    move-result v4

    .line 618
    invoke-virtual {v0}, Landroid/telephony/SignalThresholdInfo;->getHysteresisDb()I

    move-result v5

    .line 620
    invoke-virtual {v0}, Landroid/telephony/SignalThresholdInfo;->getThresholds()[I

    move-result-object v1

    .line 619
    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([I)Ljava/util/ArrayList;

    move-result-object v6

    .line 622
    invoke-virtual {v0}, Landroid/telephony/SignalThresholdInfo;->getRadioAccessNetworkType()I

    move-result v0

    .line 621
    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertToHalAccessNetwork(I)I

    move-result v7

    move v3, p1

    .line 616
    invoke-interface/range {v2 .. v7}, Landroid/hardware/radio/V1_2/IRadio;->setSignalStrengthReportingCriteria(IIILjava/util/ArrayList;I)V

    goto :goto_2

    :cond_4
    :goto_3
    return-void
.end method

.method public setSuppServiceNotifications(IZ)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 634
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 635
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 636
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setSuppServiceNotifications(IZ)V

    goto :goto_0

    .line 638
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setSuppServiceNotifications(IZ)V

    :goto_0
    return-void
.end method

.method public setSystemSelectionChannels(ILjava/util/List;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/List<",
            "Landroid/telephony/RadioAccessSpecifier;",
            ">;)V"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 650
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_3

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_3:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_0

    .line 651
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 652
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    .line 653
    invoke-interface {p2}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v1, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda2;

    invoke-direct {v1}, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda2;-><init>()V

    invoke-interface {p2, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v1, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda3;

    invoke-direct {v1}, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda3;-><init>()V

    .line 654
    invoke-interface {p2, v1}, Ljava/util/stream/Stream;->toArray(Ljava/util/function/IntFunction;)[Ljava/lang/Object;

    move-result-object p2

    check-cast p2, [Landroid/hardware/radio/network/RadioAccessSpecifier;

    .line 652
    invoke-interface {p0, p1, v0, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setSystemSelectionChannels(IZ[Landroid/hardware/radio/network/RadioAccessSpecifier;)V

    goto :goto_0

    .line 655
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 656
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    .line 657
    invoke-interface {p2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    invoke-interface {p2}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v1, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda4;

    invoke-direct {v1}, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda4;-><init>()V

    .line 658
    invoke-interface {p2, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v1, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda5;

    invoke-direct {v1}, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda5;-><init>()V

    .line 659
    invoke-static {v1}, Ljava/util/stream/Collectors;->toCollection(Ljava/util/function/Supplier;)Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {p2, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/util/ArrayList;

    .line 656
    invoke-interface {p0, p1, v0, p2}, Landroid/hardware/radio/V1_5/IRadio;->setSystemSelectionChannels_1_5(IZLjava/util/ArrayList;)V

    goto :goto_0

    .line 661
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_3/IRadio;

    .line 662
    invoke-interface {p2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    invoke-interface {p2}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v1, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda6;

    invoke-direct {v1}, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda6;-><init>()V

    .line 663
    invoke-interface {p2, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v1, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda5;

    invoke-direct {v1}, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda5;-><init>()V

    .line 664
    invoke-static {v1}, Ljava/util/stream/Collectors;->toCollection(Ljava/util/function/Supplier;)Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {p2, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/util/ArrayList;

    .line 661
    invoke-interface {p0, p1, v0, p2}, Landroid/hardware/radio/V1_3/IRadio;->setSystemSelectionChannels(IZLjava/util/ArrayList;)V

    :cond_3
    :goto_0
    return-void
.end method

.method public setUsageSetting(II)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 825
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 826
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 827
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->setUsageSetting(II)V

    :cond_1
    return-void
.end method

.method public startNetworkScan(ILandroid/telephony/NetworkScanRequest;Lcom/android/internal/telephony/HalVersion;Landroid/os/Message;)V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 677
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_e

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_4

    .line 678
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    const/4 v1, 0x6

    const/4 v2, 0x0

    const/4 v3, 0x0

    if-eqz v0, :cond_3

    .line 679
    new-instance p3, Landroid/hardware/radio/network/NetworkScanRequest;

    invoke-direct {p3}, Landroid/hardware/radio/network/NetworkScanRequest;-><init>()V

    .line 681
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getScanType()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/network/NetworkScanRequest;->type:I

    .line 682
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getSearchPeriodicity()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/network/NetworkScanRequest;->interval:I

    .line 683
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getMaxSearchTime()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/network/NetworkScanRequest;->maxSearchTime:I

    .line 684
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getIncrementalResultsPeriodicity()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/network/NetworkScanRequest;->incrementalResultsPeriodicity:I

    .line 685
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getIncrementalResults()Z

    move-result v0

    iput-boolean v0, p3, Landroid/hardware/radio/network/NetworkScanRequest;->incrementalResults:Z

    .line 686
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getPlmns()Ljava/util/ArrayList;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v4, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda0;

    invoke-direct {v4}, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {v0, v4}, Ljava/util/stream/Stream;->toArray(Ljava/util/function/IntFunction;)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Ljava/lang/String;

    iput-object v0, p3, Landroid/hardware/radio/network/NetworkScanRequest;->mccMncs:[Ljava/lang/String;

    .line 687
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 689
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getSpecifiers()[Landroid/telephony/RadioAccessSpecifier;

    move-result-object p2

    array-length v4, p2

    :goto_0
    if-ge v3, v4, :cond_2

    aget-object v5, p2, v3

    .line 691
    invoke-static {v5}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessSpecifierAidl(Landroid/telephony/RadioAccessSpecifier;)Landroid/hardware/radio/network/RadioAccessSpecifier;

    move-result-object v5

    if-nez v5, :cond_1

    .line 694
    invoke-static {v1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p0

    .line 693
    invoke-static {p4, v2, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 695
    invoke-virtual {p4}, Landroid/os/Message;->sendToTarget()V

    return-void

    .line 698
    :cond_1
    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 700
    :cond_2
    invoke-virtual {v0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object p2

    new-instance p4, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda1;

    invoke-direct {p4}, Lcom/android/internal/telephony/RadioNetworkProxy$$ExternalSyntheticLambda1;-><init>()V

    invoke-interface {p2, p4}, Ljava/util/stream/Stream;->toArray(Ljava/util/function/IntFunction;)[Ljava/lang/Object;

    move-result-object p2

    check-cast p2, [Landroid/hardware/radio/network/RadioAccessSpecifier;

    iput-object p2, p3, Landroid/hardware/radio/network/NetworkScanRequest;->specifiers:[Landroid/hardware/radio/network/RadioAccessSpecifier;

    .line 702
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/network/IRadioNetwork;->startNetworkScan(ILandroid/hardware/radio/network/NetworkScanRequest;)V

    goto/16 :goto_4

    :cond_3
    if-eqz p3, :cond_4

    .line 703
    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    .line 704
    invoke-virtual {p3, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p3

    if-eqz p3, :cond_7

    :cond_4
    iget-object p3, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    .line 705
    invoke-virtual {p3, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p3

    if-eqz p3, :cond_7

    .line 706
    new-instance p3, Landroid/hardware/radio/V1_5/NetworkScanRequest;

    invoke-direct {p3}, Landroid/hardware/radio/V1_5/NetworkScanRequest;-><init>()V

    .line 708
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getScanType()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_5/NetworkScanRequest;->type:I

    .line 709
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getSearchPeriodicity()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_5/NetworkScanRequest;->interval:I

    .line 710
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getMaxSearchTime()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_5/NetworkScanRequest;->maxSearchTime:I

    .line 711
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getIncrementalResultsPeriodicity()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_5/NetworkScanRequest;->incrementalResultsPeriodicity:I

    .line 712
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getIncrementalResults()Z

    move-result v0

    iput-boolean v0, p3, Landroid/hardware/radio/V1_5/NetworkScanRequest;->incrementalResults:Z

    .line 713
    iget-object v0, p3, Landroid/hardware/radio/V1_5/NetworkScanRequest;->mccMncs:Ljava/util/ArrayList;

    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getPlmns()Ljava/util/ArrayList;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    .line 714
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getSpecifiers()[Landroid/telephony/RadioAccessSpecifier;

    move-result-object p2

    array-length v0, p2

    :goto_1
    if-ge v3, v0, :cond_6

    aget-object v4, p2, v3

    .line 716
    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessSpecifier15(Landroid/telephony/RadioAccessSpecifier;)Landroid/hardware/radio/V1_5/RadioAccessSpecifier;

    move-result-object v4

    if-nez v4, :cond_5

    .line 719
    invoke-static {v1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p0

    .line 718
    invoke-static {p4, v2, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 720
    invoke-virtual {p4}, Landroid/os/Message;->sendToTarget()V

    return-void

    .line 723
    :cond_5
    iget-object v5, p3, Landroid/hardware/radio/V1_5/NetworkScanRequest;->specifiers:Ljava/util/ArrayList;

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 725
    :cond_6
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/V1_5/IRadio;->startNetworkScan_1_5(ILandroid/hardware/radio/V1_5/NetworkScanRequest;)V

    goto/16 :goto_4

    .line 727
    :cond_7
    iget-object p3, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_2:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p3, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p3

    if-eqz p3, :cond_b

    .line 728
    new-instance p3, Landroid/hardware/radio/V1_2/NetworkScanRequest;

    invoke-direct {p3}, Landroid/hardware/radio/V1_2/NetworkScanRequest;-><init>()V

    .line 730
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getScanType()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_2/NetworkScanRequest;->type:I

    .line 731
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getSearchPeriodicity()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_2/NetworkScanRequest;->interval:I

    .line 732
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getMaxSearchTime()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_2/NetworkScanRequest;->maxSearchTime:I

    .line 733
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getIncrementalResultsPeriodicity()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_2/NetworkScanRequest;->incrementalResultsPeriodicity:I

    .line 734
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getIncrementalResults()Z

    move-result v0

    iput-boolean v0, p3, Landroid/hardware/radio/V1_2/NetworkScanRequest;->incrementalResults:Z

    .line 735
    iget-object v0, p3, Landroid/hardware/radio/V1_2/NetworkScanRequest;->mccMncs:Ljava/util/ArrayList;

    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getPlmns()Ljava/util/ArrayList;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    .line 737
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getSpecifiers()[Landroid/telephony/RadioAccessSpecifier;

    move-result-object p2

    array-length v0, p2

    :goto_2
    if-ge v3, v0, :cond_9

    aget-object v4, p2, v3

    .line 739
    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessSpecifier11(Landroid/telephony/RadioAccessSpecifier;)Landroid/hardware/radio/V1_1/RadioAccessSpecifier;

    move-result-object v4

    if-nez v4, :cond_8

    .line 742
    invoke-static {v1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p0

    .line 741
    invoke-static {p4, v2, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 743
    invoke-virtual {p4}, Landroid/os/Message;->sendToTarget()V

    return-void

    .line 746
    :cond_8
    iget-object v5, p3, Landroid/hardware/radio/V1_2/NetworkScanRequest;->specifiers:Ljava/util/ArrayList;

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_2

    .line 749
    :cond_9
    iget-object p2, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object p4, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p2, p4}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p2

    if-eqz p2, :cond_a

    .line 750
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_4/IRadio;

    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/V1_4/IRadio;->startNetworkScan_1_4(ILandroid/hardware/radio/V1_2/NetworkScanRequest;)V

    goto :goto_4

    .line 753
    :cond_a
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_2/IRadio;

    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/V1_2/IRadio;->startNetworkScan_1_2(ILandroid/hardware/radio/V1_2/NetworkScanRequest;)V

    goto :goto_4

    .line 757
    :cond_b
    new-instance p3, Landroid/hardware/radio/V1_1/NetworkScanRequest;

    invoke-direct {p3}, Landroid/hardware/radio/V1_1/NetworkScanRequest;-><init>()V

    .line 759
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getScanType()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_1/NetworkScanRequest;->type:I

    .line 760
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getSearchPeriodicity()I

    move-result v0

    iput v0, p3, Landroid/hardware/radio/V1_1/NetworkScanRequest;->interval:I

    .line 761
    invoke-virtual {p2}, Landroid/telephony/NetworkScanRequest;->getSpecifiers()[Landroid/telephony/RadioAccessSpecifier;

    move-result-object p2

    array-length v0, p2

    :goto_3
    if-ge v3, v0, :cond_d

    aget-object v4, p2, v3

    .line 763
    invoke-static {v4}, Lcom/android/internal/telephony/RILUtils;->convertToHalRadioAccessSpecifier11(Landroid/telephony/RadioAccessSpecifier;)Landroid/hardware/radio/V1_1/RadioAccessSpecifier;

    move-result-object v4

    if-nez v4, :cond_c

    .line 766
    invoke-static {v1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p0

    .line 765
    invoke-static {p4, v2, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 767
    invoke-virtual {p4}, Landroid/os/Message;->sendToTarget()V

    return-void

    .line 770
    :cond_c
    iget-object v5, p3, Landroid/hardware/radio/V1_1/NetworkScanRequest;->specifiers:Ljava/util/ArrayList;

    invoke-virtual {v5, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_3

    .line 772
    :cond_d
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_1/IRadio;

    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/V1_1/IRadio;->startNetworkScan(ILandroid/hardware/radio/V1_1/NetworkScanRequest;)V

    :cond_e
    :goto_4
    return-void
.end method

.method public stopNetworkScan(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 782
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 783
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 784
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1}, Landroid/hardware/radio/network/IRadioNetwork;->stopNetworkScan(I)V

    goto :goto_0

    .line 786
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_1/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_1/IRadio;->stopNetworkScan(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public supplyNetworkDepersonalization(ILjava/lang/String;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 797
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioNetworkProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 798
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 799
    iget-object p0, p0, Lcom/android/internal/telephony/RadioNetworkProxy;->mNetworkProxy:Landroid/hardware/radio/network/IRadioNetwork;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/network/IRadioNetwork;->supplyNetworkDepersonalization(ILjava/lang/String;)V

    goto :goto_0

    .line 801
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->supplyNetworkDepersonalization(ILjava/lang/String;)V

    :goto_0
    return-void
.end method
