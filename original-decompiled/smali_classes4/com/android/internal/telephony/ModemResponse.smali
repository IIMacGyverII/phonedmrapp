.class public Lcom/android/internal/telephony/ModemResponse;
.super Landroid/hardware/radio/modem/IRadioModemResponse$Stub;
.source "ModemResponse.java"


# instance fields
.field private final mRil:Lcom/android/internal/telephony/RIL;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/RIL;)V
    .locals 0

    .line 36
    invoke-direct {p0}, Landroid/hardware/radio/modem/IRadioModemResponse$Stub;-><init>()V

    .line 37
    iput-object p1, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    return-void
.end method


# virtual methods
.method public acknowledgeRequest(I)V
    .locals 0

    .line 47
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RIL;->processRequestAck(I)V

    return-void
.end method

.method public enableModemResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 54
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x3

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public getBasebandVersionResponse(Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/String;)V
    .locals 1

    .line 62
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x3

    invoke-static {v0, p0, p1, p2}, Lcom/android/internal/telephony/RadioResponse;->responseString(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/String;)V

    return-void
.end method

.method public getDeviceIdentityResponse(Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 74
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x4

    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    aput-object p2, v0, v1

    const/4 p2, 0x1

    aput-object p3, v0, p2

    const/4 p2, 0x2

    aput-object p4, v0, p2

    const/4 p2, 0x3

    aput-object p5, v0, p2

    invoke-static {p2, p0, p1, v0}, Lcom/android/internal/telephony/RadioResponse;->responseStrings(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;[Ljava/lang/String;)V

    return-void
.end method

.method public getHardwareConfigResponse(Landroid/hardware/radio/RadioResponseInfo;[Landroid/hardware/radio/modem/HardwareConfig;)V
    .locals 2

    .line 84
    iget-object v0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 87
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertHalHardwareConfigList([Landroid/hardware/radio/modem/HardwareConfig;)Ljava/util/ArrayList;

    move-result-object p2

    .line 88
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v1, :cond_0

    .line 89
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {v1, p2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 91
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

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

.method public getModemActivityInfoResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/modem/ActivityStatsInfo;)V
    .locals 13

    .line 101
    iget-object v0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 106
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    const/4 v2, 0x0

    if-nez v1, :cond_2

    .line 107
    iget v6, p2, Landroid/hardware/radio/modem/ActivityStatsInfo;->sleepModeTimeMs:I

    .line 108
    iget v7, p2, Landroid/hardware/radio/modem/ActivityStatsInfo;->idleModeTimeMs:I

    .line 109
    iget-object v1, p2, Landroid/hardware/radio/modem/ActivityStatsInfo;->techSpecificInfo:[Landroid/hardware/radio/modem/ActivityStatsTechSpecificInfo;

    array-length v1, v1

    .line 110
    new-array v8, v1, [Landroid/telephony/ActivityStatsTechSpecificInfo;

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_1

    .line 112
    iget-object v4, p2, Landroid/hardware/radio/modem/ActivityStatsInfo;->techSpecificInfo:[Landroid/hardware/radio/modem/ActivityStatsTechSpecificInfo;

    aget-object v4, v4, v3

    iget v5, v4, Landroid/hardware/radio/modem/ActivityStatsTechSpecificInfo;->rat:I

    .line 113
    iget v4, v4, Landroid/hardware/radio/modem/ActivityStatsTechSpecificInfo;->frequencyRange:I

    .line 114
    invoke-static {}, Landroid/telephony/ModemActivityInfo;->getNumTxPowerLevels()I

    move-result v9

    new-array v9, v9, [I

    .line 115
    iget-object v10, p2, Landroid/hardware/radio/modem/ActivityStatsInfo;->techSpecificInfo:[Landroid/hardware/radio/modem/ActivityStatsTechSpecificInfo;

    aget-object v10, v10, v3

    iget v10, v10, Landroid/hardware/radio/modem/ActivityStatsTechSpecificInfo;->rxModeTimeMs:I

    move v11, v2

    .line 116
    :goto_1
    invoke-static {}, Landroid/telephony/ModemActivityInfo;->getNumTxPowerLevels()I

    move-result v12

    if-ge v11, v12, :cond_0

    .line 117
    iget-object v12, p2, Landroid/hardware/radio/modem/ActivityStatsInfo;->techSpecificInfo:[Landroid/hardware/radio/modem/ActivityStatsTechSpecificInfo;

    aget-object v12, v12, v3

    iget-object v12, v12, Landroid/hardware/radio/modem/ActivityStatsTechSpecificInfo;->txmModetimeMs:[I

    aget v12, v12, v11

    aput v12, v9, v11

    add-int/lit8 v11, v11, 0x1

    goto :goto_1

    .line 119
    :cond_0
    new-instance v11, Landroid/telephony/ActivityStatsTechSpecificInfo;

    invoke-direct {v11, v5, v4, v9, v10}, Landroid/telephony/ActivityStatsTechSpecificInfo;-><init>(II[II)V

    aput-object v11, v8, v3

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 125
    :cond_1
    new-instance p2, Landroid/telephony/ModemActivityInfo;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v4

    move-object v3, p2

    invoke-direct/range {v3 .. v8}, Landroid/telephony/ModemActivityInfo;-><init>(JII[Landroid/telephony/ActivityStatsTechSpecificInfo;)V

    goto :goto_2

    :cond_2
    const/4 p2, 0x1

    new-array v8, p2, [Landroid/telephony/ActivityStatsTechSpecificInfo;

    .line 129
    new-instance p2, Landroid/telephony/ActivityStatsTechSpecificInfo;

    .line 130
    invoke-static {}, Landroid/telephony/ModemActivityInfo;->getNumTxPowerLevels()I

    move-result v1

    new-array v1, v1, [I

    invoke-direct {p2, v2, v2, v1, v2}, Landroid/telephony/ActivityStatsTechSpecificInfo;-><init>(II[II)V

    aput-object p2, v8, v2

    .line 131
    new-instance p2, Landroid/telephony/ModemActivityInfo;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v4

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-object v3, p2

    invoke-direct/range {v3 .. v8}, Landroid/telephony/ModemActivityInfo;-><init>(JII[Landroid/telephony/ActivityStatsTechSpecificInfo;)V

    .line 132
    iput v2, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    .line 134
    :goto_2
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {v1, p2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 135
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_3
    return-void
.end method

.method public getModemStackStatusResponse(Landroid/hardware/radio/RadioResponseInfo;Z)V
    .locals 3

    .line 144
    iget-object v0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 147
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v1, :cond_0

    .line 148
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 150
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p2

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

.method public getRadioCapabilityResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/modem/RadioCapability;)V
    .locals 3

    .line 160
    iget-object v0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 163
    iget-object v1, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-static {p2, v1}, Lcom/android/internal/telephony/RILUtils;->convertHalRadioCapability(Landroid/hardware/radio/modem/RadioCapability;Lcom/android/internal/telephony/RIL;)Lcom/android/internal/telephony/RadioCapability;

    move-result-object p2

    .line 164
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    const/4 v2, 0x6

    if-eq v1, v2, :cond_0

    const/4 v2, 0x2

    if-ne v1, v2, :cond_1

    .line 167
    :cond_0
    iget-object p2, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p2}, Lcom/android/internal/telephony/RIL;->makeStaticRadioCapability()Lcom/android/internal/telephony/RadioCapability;

    move-result-object p2

    const/4 v1, 0x0

    .line 168
    iput v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    .line 170
    :cond_1
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v1, :cond_2

    .line 171
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {v1, p2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 173
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_3
    return-void
.end method

.method public nvReadItemResponse(Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/String;)V
    .locals 1

    .line 182
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x3

    invoke-static {v0, p0, p1, p2}, Lcom/android/internal/telephony/RadioResponse;->responseString(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/String;)V

    return-void
.end method

.method public nvResetConfigResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 189
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x3

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public nvWriteCdmaPrlResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 196
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x3

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public nvWriteItemResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 203
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x3

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public requestShutdownResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 210
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x3

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public sendDeviceStateResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 217
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x3

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setRadioCapabilityResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/modem/RadioCapability;)V
    .locals 2

    .line 226
    iget-object v0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 229
    iget-object v1, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-static {p2, v1}, Lcom/android/internal/telephony/RILUtils;->convertHalRadioCapability(Landroid/hardware/radio/modem/RadioCapability;Lcom/android/internal/telephony/RIL;)Lcom/android/internal/telephony/RadioCapability;

    move-result-object p2

    .line 230
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v1, :cond_0

    .line 231
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {v1, p2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 233
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

.method public setRadioPowerResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 2

    .line 241
    iget-object v0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x3

    invoke-static {v1, v0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    .line 242
    iget-object p0, p0, Lcom/android/internal/telephony/ModemResponse;->mRil:Lcom/android/internal/telephony/RIL;

    iget p1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    iput p1, p0, Lcom/android/internal/telephony/RIL;->mLastRadioPowerResult:I

    const/16 p0, 0x46

    if-ne p1, p0, :cond_0

    const-string p0, "316f3801-fa21-4954-a42f-0041eada3b32"

    .line 245
    invoke-static {p0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object p0

    const-string p1, "RF HW damaged"

    .line 244
    invoke-static {p0, p1}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const/16 p0, 0x47

    if-ne p1, p0, :cond_1

    const-string p0, "316f3801-fa21-4954-a42f-0041eada3b33"

    .line 249
    invoke-static {p0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object p0

    const-string p1, "No RF calibration data"

    .line 248
    invoke-static {p0, p1}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    const/4 p0, 0x1

    if-eq p1, p0, :cond_2

    if-eqz p1, :cond_2

    const-string p0, "316f3801-fa21-4954-a42f-0041eada3b31"

    .line 254
    invoke-static {p0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object p0

    const-string p1, "Radio power failure"

    .line 253
    invoke-static {p0, p1}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;)V

    :cond_2
    :goto_0
    return-void
.end method
