.class public Lcom/android/internal/telephony/RadioDataProxy;
.super Lcom/android/internal/telephony/RadioServiceProxy;
.source "RadioDataProxy.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "RadioDataProxy"


# instance fields
.field private volatile mDataProxy:Landroid/hardware/radio/data/IRadioData;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 40
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioServiceProxy;-><init>()V

    const/4 v0, 0x0

    .line 42
    iput-object v0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    return-void
.end method


# virtual methods
.method public allocatePduSessionId(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 88
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 89
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 90
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1}, Landroid/hardware/radio/data/IRadioData;->allocatePduSessionId(I)V

    goto :goto_0

    .line 92
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->allocatePduSessionId(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public cancelHandover(II)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 103
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 104
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 105
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/data/IRadioData;->cancelHandover(II)V

    goto :goto_0

    .line 107
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->cancelHandover(II)V

    :cond_2
    :goto_0
    return-void
.end method

.method public clear()V
    .locals 1

    .line 69
    invoke-super {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->clear()V

    const/4 v0, 0x0

    .line 70
    iput-object v0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    return-void
.end method

.method public deactivateDataCall(III)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 119
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 120
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 121
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/data/IRadioData;->deactivateDataCall(III)V

    goto :goto_1

    .line 122
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_2:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 123
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_2/IRadio;

    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_2/IRadio;->deactivateDataCall_1_2(III)V

    goto :goto_1

    .line 126
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    const/4 v0, 0x2

    if-ne p3, v0, :cond_3

    const/4 p3, 0x1

    goto :goto_0

    :cond_3
    const/4 p3, 0x0

    :goto_0
    invoke-interface {p0, p1, p2, p3}, Landroid/hardware/radio/V1_0/IRadio;->deactivateDataCall(IIZ)V

    :goto_1
    return-void
.end method

.method public getAidl()Landroid/hardware/radio/data/IRadioData;
    .locals 0

    .line 61
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    return-object p0
.end method

.method public getDataCallList(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 137
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 138
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 139
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1}, Landroid/hardware/radio/data/IRadioData;->getDataCallList(I)V

    goto :goto_0

    .line 140
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 141
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getDataCallList_1_6(I)V

    goto :goto_0

    .line 143
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_0/IRadio;->getDataCallList(I)V

    :goto_0
    return-void
.end method

.method public getSlicingConfig(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 153
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 154
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 155
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1}, Landroid/hardware/radio/data/IRadioData;->getSlicingConfig(I)V

    goto :goto_0

    .line 157
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1}, Landroid/hardware/radio/V1_6/IRadio;->getSlicingConfig(I)V

    :cond_2
    :goto_0
    return-void
.end method

.method public isEmpty()Z
    .locals 1

    .line 79
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    if-nez v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public releasePduSessionId(II)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 168
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 169
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 170
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/data/IRadioData;->releasePduSessionId(II)V

    goto :goto_0

    .line 172
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->releasePduSessionId(II)V

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

    .line 182
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 183
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 184
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0}, Landroid/hardware/radio/data/IRadioData;->responseAcknowledgement()V

    goto :goto_0

    .line 186
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0}, Landroid/hardware/radio/V1_0/IRadio;->responseAcknowledgement()V

    :goto_0
    return-void
.end method

.method public setAidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/data/IRadioData;)V
    .locals 0

    .line 50
    iput-object p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    .line 51
    iput-object p2, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    const/4 p1, 0x1

    .line 52
    iput-boolean p1, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mIsAidl:Z

    const-string p0, "RadioDataProxy"

    const-string p1, "AIDL initialized"

    .line 53
    invoke-static {p0, p1}, Landroid/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public setDataAllowed(IZ)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 197
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 198
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 199
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/data/IRadioData;->setDataAllowed(IZ)V

    goto :goto_0

    .line 201
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_0/IRadio;->setDataAllowed(IZ)V

    :goto_0
    return-void
.end method

.method public setDataProfile(I[Landroid/telephony/data/DataProfile;Z)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 214
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 215
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 216
    array-length p3, p2

    new-array p3, p3, [Landroid/hardware/radio/data/DataProfileInfo;

    .line 218
    :goto_0
    array-length v0, p2

    if-ge v1, v0, :cond_1

    .line 219
    aget-object v0, p2, v1

    invoke-static {v0}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/data/DataProfileInfo;

    move-result-object v0

    aput-object v0, p3, v1

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 221
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/data/IRadioData;->setDataProfile(I[Landroid/hardware/radio/data/DataProfileInfo;)V

    goto/16 :goto_4

    .line 222
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v2, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 223
    new-instance p3, Ljava/util/ArrayList;

    invoke-direct {p3}, Ljava/util/ArrayList;-><init>()V

    .line 224
    array-length v0, p2

    :goto_1
    if-ge v1, v0, :cond_3

    aget-object v2, p2, v1

    .line 225
    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile15(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_5/DataProfileInfo;

    move-result-object v2

    invoke-virtual {p3, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 227
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/V1_5/IRadio;->setDataProfile_1_5(ILjava/util/ArrayList;)V

    goto :goto_4

    .line 228
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v2, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 229
    new-instance p3, Ljava/util/ArrayList;

    invoke-direct {p3}, Ljava/util/ArrayList;-><init>()V

    .line 230
    array-length v0, p2

    :goto_2
    if-ge v1, v0, :cond_5

    aget-object v2, p2, v1

    .line 231
    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile14(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_4/DataProfileInfo;

    move-result-object v2

    invoke-virtual {p3, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_2

    .line 233
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_4/IRadio;

    invoke-interface {p0, p1, p3}, Landroid/hardware/radio/V1_4/IRadio;->setDataProfile_1_4(ILjava/util/ArrayList;)V

    goto :goto_4

    .line 235
    :cond_6
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 236
    array-length v2, p2

    :goto_3
    if-ge v1, v2, :cond_8

    aget-object v3, p2, v1

    .line 237
    invoke-virtual {v3}, Landroid/telephony/data/DataProfile;->isPersistent()Z

    move-result v4

    if-eqz v4, :cond_7

    .line 238
    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile10(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_0/DataProfileInfo;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_7
    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    .line 241
    :cond_8
    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result p2

    if-nez p2, :cond_9

    .line 242
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-interface {p0, p1, v0, p3}, Landroid/hardware/radio/V1_0/IRadio;->setDataProfile(ILjava/util/ArrayList;Z)V

    :cond_9
    :goto_4
    return-void
.end method

.method public setDataThrottling(IBJ)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 257
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 258
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 259
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/data/IRadioData;->setDataThrottling(IBJ)V

    goto :goto_0

    .line 261
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1, p2, p3, p4}, Landroid/hardware/radio/V1_6/IRadio;->setDataThrottling(IBJ)V

    :cond_2
    :goto_0
    return-void
.end method

.method public setInitialAttachApn(ILandroid/telephony/data/DataProfile;Z)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 275
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 276
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 277
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/data/DataProfileInfo;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/data/IRadioData;->setInitialAttachApn(ILandroid/hardware/radio/data/DataProfileInfo;)V

    goto :goto_0

    .line 278
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 279
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_5/IRadio;

    .line 280
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile15(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_5/DataProfileInfo;

    move-result-object p2

    .line 279
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_5/IRadio;->setInitialAttachApn_1_5(ILandroid/hardware/radio/V1_5/DataProfileInfo;)V

    goto :goto_0

    .line 281
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 282
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_4/IRadio;

    .line 283
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile14(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_4/DataProfileInfo;

    move-result-object p2

    .line 282
    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_4/IRadio;->setInitialAttachApn_1_4(ILandroid/hardware/radio/V1_4/DataProfileInfo;)V

    goto :goto_0

    .line 285
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile10(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_0/DataProfileInfo;

    move-result-object v0

    .line 286
    invoke-virtual {p2}, Landroid/telephony/data/DataProfile;->isPersistent()Z

    move-result p2

    .line 285
    invoke-interface {p0, p1, v0, p2, p3}, Landroid/hardware/radio/V1_0/IRadio;->setInitialAttachApn(ILandroid/hardware/radio/V1_0/DataProfileInfo;ZZ)V

    :goto_0
    return-void
.end method

.method public setupDataCall(IIILandroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;ILandroid/telephony/data/NetworkSliceInfo;Landroid/telephony/data/TrafficDescriptor;Z)V
    .locals 23
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    move-object/from16 v0, p0

    .line 314
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    return-void

    .line 315
    :cond_0
    new-instance v10, Ljava/util/ArrayList;

    invoke-direct {v10}, Ljava/util/ArrayList;-><init>()V

    .line 316
    new-instance v9, Ljava/util/ArrayList;

    invoke-direct {v9}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x0

    if-eqz p8, :cond_2

    .line 319
    invoke-virtual/range {p8 .. p8}, Landroid/net/LinkProperties;->getAddresses()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/net/InetAddress;

    .line 320
    invoke-virtual {v3}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v10, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 322
    :cond_1
    invoke-virtual/range {p8 .. p8}, Landroid/net/LinkProperties;->getDnsServers()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    new-array v2, v2, [Ljava/lang/String;

    move v3, v1

    .line 323
    :goto_1
    invoke-virtual/range {p8 .. p8}, Landroid/net/LinkProperties;->getDnsServers()Ljava/util/List;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v4

    if-ge v3, v4, :cond_3

    .line 324
    invoke-virtual/range {p8 .. p8}, Landroid/net/LinkProperties;->getDnsServers()Ljava/util/List;

    move-result-object v4

    invoke-interface {v4, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/net/InetAddress;

    invoke-virtual {v4}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v9, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 325
    invoke-virtual/range {p8 .. p8}, Landroid/net/LinkProperties;->getDnsServers()Ljava/util/List;

    move-result-object v4

    invoke-interface {v4, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/net/InetAddress;

    invoke-virtual {v4}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v2, v3

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_2
    new-array v2, v1, [Ljava/lang/String;

    :cond_3
    move-object/from16 v18, v2

    .line 330
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v2

    if-eqz v2, :cond_4

    .line 332
    new-instance v1, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {v1}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    .line 333
    invoke-virtual/range {p4 .. p4}, Landroid/telephony/data/DataProfile;->getType()I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/DataProfile$Builder;->setType(I)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    .line 334
    invoke-virtual/range {p4 .. p4}, Landroid/telephony/data/DataProfile;->isPreferred()Z

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/DataProfile$Builder;->setPreferred(Z)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    move-object/from16 v2, p11

    .line 335
    invoke-virtual {v1, v2}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    .line 336
    invoke-virtual/range {p4 .. p4}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    .line 337
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object v1

    .line 338
    iget-object v11, v0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-static {v1}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/data/DataProfileInfo;

    move-result-object v14

    .line 339
    invoke-static/range {p8 .. p8}, Lcom/android/internal/telephony/RILUtils;->convertToHalLinkProperties(Landroid/net/LinkProperties;)[Landroid/hardware/radio/data/LinkAddress;

    move-result-object v17

    .line 340
    invoke-static/range {p10 .. p10}, Lcom/android/internal/telephony/RILUtils;->convertToHalSliceInfoAidl(Landroid/telephony/data/NetworkSliceInfo;)Landroid/hardware/radio/data/SliceInfo;

    move-result-object v20

    move/from16 v12, p1

    move/from16 v13, p3

    move/from16 v15, p6

    move/from16 v16, p7

    move/from16 v19, p9

    move/from16 v21, p12

    .line 338
    invoke-interface/range {v11 .. v21}, Landroid/hardware/radio/data/IRadioData;->setupDataCall(IILandroid/hardware/radio/data/DataProfileInfo;ZI[Landroid/hardware/radio/data/LinkAddress;[Ljava/lang/String;ILandroid/hardware/radio/data/SliceInfo;Z)V

    goto/16 :goto_2

    :cond_4
    move-object/from16 v2, p11

    .line 342
    iget-object v3, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v4, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v3

    if-eqz v3, :cond_5

    .line 343
    iget-object v0, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    move-object v11, v0

    check-cast v11, Landroid/hardware/radio/V1_6/IRadio;

    .line 344
    invoke-static/range {p4 .. p4}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile15(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_5/DataProfileInfo;

    move-result-object v14

    .line 345
    invoke-static/range {p8 .. p8}, Lcom/android/internal/telephony/RILUtils;->convertToHalLinkProperties15(Landroid/net/LinkProperties;)Ljava/util/ArrayList;

    move-result-object v17

    .line 346
    invoke-static/range {p10 .. p10}, Lcom/android/internal/telephony/RILUtils;->convertToHalSliceInfo(Landroid/telephony/data/NetworkSliceInfo;)Landroid/hardware/radio/V1_6/OptionalSliceInfo;

    move-result-object v20

    .line 347
    invoke-static/range {p11 .. p11}, Lcom/android/internal/telephony/RILUtils;->convertToHalTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/hardware/radio/V1_6/OptionalTrafficDescriptor;

    move-result-object v21

    move/from16 v12, p1

    move/from16 v13, p3

    move/from16 v15, p6

    move/from16 v16, p7

    move-object/from16 v18, v9

    move/from16 v19, p9

    move/from16 v22, p12

    .line 343
    invoke-interface/range {v11 .. v22}, Landroid/hardware/radio/V1_6/IRadio;->setupDataCall_1_6(IILandroid/hardware/radio/V1_5/DataProfileInfo;ZILjava/util/ArrayList;Ljava/util/ArrayList;ILandroid/hardware/radio/V1_6/OptionalSliceInfo;Landroid/hardware/radio/V1_6/OptionalTrafficDescriptor;Z)V

    goto/16 :goto_2

    .line 349
    :cond_5
    iget-object v2, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v3, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v2

    if-eqz v2, :cond_6

    .line 350
    iget-object v0, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast v0, Landroid/hardware/radio/V1_5/IRadio;

    .line 351
    invoke-static/range {p4 .. p4}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile15(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_5/DataProfileInfo;

    move-result-object v3

    .line 352
    invoke-static/range {p8 .. p8}, Lcom/android/internal/telephony/RILUtils;->convertToHalLinkProperties15(Landroid/net/LinkProperties;)Ljava/util/ArrayList;

    move-result-object v6

    move/from16 v1, p1

    move/from16 v2, p3

    move/from16 v4, p6

    move/from16 v5, p7

    move-object v7, v9

    .line 350
    invoke-interface/range {v0 .. v7}, Landroid/hardware/radio/V1_5/IRadio;->setupDataCall_1_5(IILandroid/hardware/radio/V1_5/DataProfileInfo;ZILjava/util/ArrayList;Ljava/util/ArrayList;)V

    goto/16 :goto_2

    .line 354
    :cond_6
    iget-object v2, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v3, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_4:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v2

    if-eqz v2, :cond_7

    .line 355
    iget-object v0, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    move-object v2, v0

    check-cast v2, Landroid/hardware/radio/V1_4/IRadio;

    .line 356
    invoke-static/range {p4 .. p4}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile14(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_4/DataProfileInfo;

    move-result-object v5

    move/from16 v3, p1

    move/from16 v4, p3

    move/from16 v6, p6

    move/from16 v7, p7

    move-object v8, v10

    .line 355
    invoke-interface/range {v2 .. v9}, Landroid/hardware/radio/V1_4/IRadio;->setupDataCall_1_4(IILandroid/hardware/radio/V1_4/DataProfileInfo;ZILjava/util/ArrayList;Ljava/util/ArrayList;)V

    goto :goto_2

    .line 358
    :cond_7
    iget-object v2, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v3, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_2:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v2

    if-eqz v2, :cond_8

    .line 359
    iget-object v0, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    move-object v2, v0

    check-cast v2, Landroid/hardware/radio/V1_2/IRadio;

    .line 360
    invoke-static/range {p4 .. p4}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile10(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_0/DataProfileInfo;

    move-result-object v5

    .line 361
    invoke-virtual/range {p4 .. p4}, Landroid/telephony/data/DataProfile;->isPersistent()Z

    move-result v6

    move/from16 v3, p1

    move/from16 v4, p3

    move/from16 v7, p6

    move/from16 v8, p5

    move-object v0, v9

    move/from16 v9, p7

    move-object v11, v0

    .line 359
    invoke-interface/range {v2 .. v11}, Landroid/hardware/radio/V1_2/IRadio;->setupDataCall_1_2(IILandroid/hardware/radio/V1_0/DataProfileInfo;ZZZILjava/util/ArrayList;Ljava/util/ArrayList;)V

    goto :goto_2

    .line 369
    :cond_8
    invoke-static/range {p2 .. p2}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object v2

    if-eqz v2, :cond_9

    .line 371
    invoke-interface {v2}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v2

    if-eqz v2, :cond_9

    .line 373
    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v1

    :cond_9
    move v4, v1

    .line 376
    iget-object v2, v0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    .line 377
    invoke-static/range {p4 .. p4}, Lcom/android/internal/telephony/RILUtils;->convertToHalDataProfile10(Landroid/telephony/data/DataProfile;)Landroid/hardware/radio/V1_0/DataProfileInfo;

    move-result-object v5

    .line 378
    invoke-virtual/range {p4 .. p4}, Landroid/telephony/data/DataProfile;->isPersistent()Z

    move-result v6

    move/from16 v3, p1

    move/from16 v7, p6

    move/from16 v8, p5

    .line 376
    invoke-interface/range {v2 .. v8}, Landroid/hardware/radio/V1_0/IRadio;->setupDataCall(IILandroid/hardware/radio/V1_0/DataProfileInfo;ZZZ)V

    :goto_2
    return-void
.end method

.method public startHandover(II)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 389
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 390
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 391
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/data/IRadioData;->startHandover(II)V

    goto :goto_0

    .line 393
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_6/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_6/IRadio;->startHandover(II)V

    :cond_2
    :goto_0
    return-void
.end method

.method public startKeepalive(IILandroid/net/KeepalivePacketData;ILandroid/os/Message;)V
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 408
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_8

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_5

    .line 409
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    const/16 v1, 0x2c

    const/4 v2, 0x0

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-eqz v0, :cond_5

    .line 410
    new-instance v0, Landroid/hardware/radio/data/KeepaliveRequest;

    invoke-direct {v0}, Landroid/hardware/radio/data/KeepaliveRequest;-><init>()V

    .line 412
    iput p2, v0, Landroid/hardware/radio/data/KeepaliveRequest;->cid:I

    .line 414
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getDstAddress()Ljava/net/InetAddress;

    move-result-object p2

    instance-of p2, p2, Ljava/net/Inet4Address;

    if-eqz p2, :cond_1

    .line 415
    iput v4, v0, Landroid/hardware/radio/data/KeepaliveRequest;->type:I

    goto :goto_0

    .line 416
    :cond_1
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getDstAddress()Ljava/net/InetAddress;

    move-result-object p2

    instance-of p2, p2, Ljava/net/Inet6Address;

    if-eqz p2, :cond_4

    .line 417
    iput v3, v0, Landroid/hardware/radio/data/KeepaliveRequest;->type:I

    .line 425
    :goto_0
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getSrcAddress()Ljava/net/InetAddress;

    move-result-object p2

    .line 426
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getDstAddress()Ljava/net/InetAddress;

    move-result-object p5

    .line 427
    invoke-virtual {p2}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object v1

    array-length v1, v1

    new-array v2, v1, [B

    move v3, v4

    :goto_1
    if-ge v3, v1, :cond_2

    .line 429
    invoke-virtual {p2}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object v5

    aget-byte v5, v5, v3

    aput-byte v5, v2, v3

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 431
    :cond_2
    iput-object v2, v0, Landroid/hardware/radio/data/KeepaliveRequest;->sourceAddress:[B

    .line 432
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getSrcPort()I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/data/KeepaliveRequest;->sourcePort:I

    .line 433
    invoke-virtual {p5}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object p2

    array-length p2, p2

    new-array v1, p2, [B

    :goto_2
    if-ge v4, p2, :cond_3

    .line 435
    invoke-virtual {p5}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object v2

    aget-byte v2, v2, v4

    aput-byte v2, v1, v4

    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    .line 437
    :cond_3
    iput-object v1, v0, Landroid/hardware/radio/data/KeepaliveRequest;->destinationAddress:[B

    .line 438
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getDstPort()I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/data/KeepaliveRequest;->destinationPort:I

    .line 439
    iput p4, v0, Landroid/hardware/radio/data/KeepaliveRequest;->maxKeepaliveIntervalMillis:I

    .line 441
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/data/IRadioData;->startKeepalive(ILandroid/hardware/radio/data/KeepaliveRequest;)V

    goto :goto_4

    .line 420
    :cond_4
    invoke-static {v1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p0

    .line 419
    invoke-static {p5, v2, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 421
    invoke-virtual {p5}, Landroid/os/Message;->sendToTarget()V

    return-void

    .line 443
    :cond_5
    new-instance v0, Landroid/hardware/radio/V1_1/KeepaliveRequest;

    invoke-direct {v0}, Landroid/hardware/radio/V1_1/KeepaliveRequest;-><init>()V

    .line 446
    iput p2, v0, Landroid/hardware/radio/V1_1/KeepaliveRequest;->cid:I

    .line 448
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getDstAddress()Ljava/net/InetAddress;

    move-result-object p2

    instance-of p2, p2, Ljava/net/Inet4Address;

    if-eqz p2, :cond_6

    .line 449
    iput v4, v0, Landroid/hardware/radio/V1_1/KeepaliveRequest;->type:I

    goto :goto_3

    .line 450
    :cond_6
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getDstAddress()Ljava/net/InetAddress;

    move-result-object p2

    instance-of p2, p2, Ljava/net/Inet6Address;

    if-eqz p2, :cond_7

    .line 451
    iput v3, v0, Landroid/hardware/radio/V1_1/KeepaliveRequest;->type:I

    .line 459
    :goto_3
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getSrcAddress()Ljava/net/InetAddress;

    move-result-object p2

    .line 460
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getDstAddress()Ljava/net/InetAddress;

    move-result-object p5

    .line 462
    invoke-virtual {p2}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object p2

    iget-object v1, v0, Landroid/hardware/radio/V1_1/KeepaliveRequest;->sourceAddress:Ljava/util/ArrayList;

    .line 461
    invoke-static {p2, v1}, Lcom/android/internal/telephony/RILUtils;->appendPrimitiveArrayToArrayList([BLjava/util/ArrayList;)V

    .line 463
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getSrcPort()I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/V1_1/KeepaliveRequest;->sourcePort:I

    .line 465
    invoke-virtual {p5}, Ljava/net/InetAddress;->getAddress()[B

    move-result-object p2

    iget-object p5, v0, Landroid/hardware/radio/V1_1/KeepaliveRequest;->destinationAddress:Ljava/util/ArrayList;

    .line 464
    invoke-static {p2, p5}, Lcom/android/internal/telephony/RILUtils;->appendPrimitiveArrayToArrayList([BLjava/util/ArrayList;)V

    .line 466
    invoke-virtual {p3}, Landroid/net/KeepalivePacketData;->getDstPort()I

    move-result p2

    iput p2, v0, Landroid/hardware/radio/V1_1/KeepaliveRequest;->destinationPort:I

    .line 467
    iput p4, v0, Landroid/hardware/radio/V1_1/KeepaliveRequest;->maxKeepaliveIntervalMillis:I

    .line 469
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_1/IRadio;

    invoke-interface {p0, p1, v0}, Landroid/hardware/radio/V1_1/IRadio;->startKeepalive(ILandroid/hardware/radio/V1_1/KeepaliveRequest;)V

    :goto_4
    return-void

    .line 454
    :cond_7
    invoke-static {v1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p0

    .line 453
    invoke-static {p5, v2, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 455
    invoke-virtual {p5}, Landroid/os/Message;->sendToTarget()V

    :cond_8
    :goto_5
    return-void
.end method

.method public stopKeepalive(II)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 480
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioDataProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mHalVersion:Lcom/android/internal/telephony/HalVersion;

    sget-object v1, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 481
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioServiceProxy;->isAidl()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 482
    iget-object p0, p0, Lcom/android/internal/telephony/RadioDataProxy;->mDataProxy:Landroid/hardware/radio/data/IRadioData;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/data/IRadioData;->stopKeepalive(II)V

    goto :goto_0

    .line 484
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/RadioServiceProxy;->mRadioProxy:Landroid/hardware/radio/V1_0/IRadio;

    check-cast p0, Landroid/hardware/radio/V1_1/IRadio;

    invoke-interface {p0, p1, p2}, Landroid/hardware/radio/V1_1/IRadio;->stopKeepalive(II)V

    :cond_2
    :goto_0
    return-void
.end method
