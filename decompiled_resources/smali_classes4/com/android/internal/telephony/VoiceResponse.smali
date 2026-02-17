.class public Lcom/android/internal/telephony/VoiceResponse;
.super Landroid/hardware/radio/voice/IRadioVoiceResponse$Stub;
.source "VoiceResponse.java"


# instance fields
.field private final mRil:Lcom/android/internal/telephony/RIL;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/RIL;)V
    .locals 0

    .line 32
    invoke-direct {p0}, Landroid/hardware/radio/voice/IRadioVoiceResponse$Stub;-><init>()V

    .line 33
    iput-object p1, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    return-void
.end method


# virtual methods
.method public acceptCallResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 50
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public acknowledgeRequest(I)V
    .locals 0

    .line 43
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RIL;->processRequestAck(I)V

    return-void
.end method

.method public cancelPendingUssdResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 57
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public conferenceResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 64
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public dialResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 71
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public emergencyDialResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 78
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public exitEmergencyCallbackModeResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 85
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public explicitCallTransferResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 92
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public getCallForwardStatusResponse(Landroid/hardware/radio/RadioResponseInfo;[Landroid/hardware/radio/voice/CallForwardInfo;)V
    .locals 6

    .line 102
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 104
    array-length v1, p2

    new-array v1, v1, [Lcom/android/internal/telephony/CallForwardInfo;

    const/4 v2, 0x0

    .line 105
    :goto_0
    array-length v3, p2

    if-ge v2, v3, :cond_0

    .line 106
    new-instance v3, Lcom/android/internal/telephony/CallForwardInfo;

    invoke-direct {v3}, Lcom/android/internal/telephony/CallForwardInfo;-><init>()V

    aput-object v3, v1, v2

    .line 107
    aget-object v4, p2, v2

    iget v5, v4, Landroid/hardware/radio/voice/CallForwardInfo;->status:I

    iput v5, v3, Lcom/android/internal/telephony/CallForwardInfo;->status:I

    .line 108
    iget v5, v4, Landroid/hardware/radio/voice/CallForwardInfo;->reason:I

    iput v5, v3, Lcom/android/internal/telephony/CallForwardInfo;->reason:I

    .line 109
    iget v5, v4, Landroid/hardware/radio/voice/CallForwardInfo;->serviceClass:I

    iput v5, v3, Lcom/android/internal/telephony/CallForwardInfo;->serviceClass:I

    .line 110
    iget v5, v4, Landroid/hardware/radio/voice/CallForwardInfo;->toa:I

    iput v5, v3, Lcom/android/internal/telephony/CallForwardInfo;->toa:I

    .line 111
    iget-object v5, v4, Landroid/hardware/radio/voice/CallForwardInfo;->number:Ljava/lang/String;

    iput-object v5, v3, Lcom/android/internal/telephony/CallForwardInfo;->number:Ljava/lang/String;

    .line 112
    iget v4, v4, Landroid/hardware/radio/voice/CallForwardInfo;->timeSeconds:I

    iput v4, v3, Lcom/android/internal/telephony/CallForwardInfo;->timeSeconds:I

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 114
    :cond_0
    iget p2, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez p2, :cond_1

    .line 115
    iget-object p2, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2, v1}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 117
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, v1}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_2
    return-void
.end method

.method public getCallWaitingResponse(Landroid/hardware/radio/RadioResponseInfo;ZI)V
    .locals 2

    .line 131
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    new-array v0, v0, [I

    const/4 v1, 0x0

    aput p2, v0, v1

    const/4 p2, 0x1

    aput p3, v0, p2

    const/4 p2, 0x6

    invoke-static {p2, p0, p1, v0}, Lcom/android/internal/telephony/RadioResponse;->responseInts(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;[I)V

    return-void
.end method

.method public getClipResponse(Landroid/hardware/radio/RadioResponseInfo;I)V
    .locals 2

    .line 140
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    new-array v0, v0, [I

    const/4 v1, 0x0

    aput p2, v0, v1

    const/4 p2, 0x6

    invoke-static {p2, p0, p1, v0}, Lcom/android/internal/telephony/RadioResponse;->responseInts(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;[I)V

    return-void
.end method

.method public getClirResponse(Landroid/hardware/radio/RadioResponseInfo;II)V
    .locals 2

    .line 149
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    new-array v0, v0, [I

    const/4 v1, 0x0

    aput p2, v0, v1

    const/4 p2, 0x1

    aput p3, v0, p2

    const/4 p2, 0x6

    invoke-static {p2, p0, p1, v0}, Lcom/android/internal/telephony/RadioResponse;->responseInts(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;[I)V

    return-void
.end method

.method public getCurrentCallsResponse(Landroid/hardware/radio/RadioResponseInfo;[Landroid/hardware/radio/voice/Call;)V
    .locals 7

    .line 158
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 161
    array-length v1, p2

    .line 162
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2, v1}, Ljava/util/ArrayList;-><init>(I)V

    const/4 v3, 0x0

    move v4, v3

    :goto_0
    if-ge v4, v1, :cond_1

    .line 165
    aget-object v5, p2, v4

    invoke-static {v5}, Lcom/android/internal/telephony/RILUtils;->convertToDriverCall(Landroid/hardware/radio/voice/Call;)Lcom/android/internal/telephony/DriverCall;

    move-result-object v5

    .line 166
    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 167
    iget-boolean v5, v5, Lcom/android/internal/telephony/DriverCall;->isVoicePrivacy:Z

    if-eqz v5, :cond_0

    .line 168
    iget-object v5, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object v5, v5, Lcom/android/internal/telephony/BaseCommands;->mVoicePrivacyOnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v5}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 169
    iget-object v5, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const-string v6, "InCall VoicePrivacy is enabled"

    invoke-virtual {v5, v6}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    goto :goto_1

    .line 171
    :cond_0
    iget-object v5, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object v5, v5, Lcom/android/internal/telephony/BaseCommands;->mVoicePrivacyOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v5}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 172
    iget-object v5, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const-string v6, "InCall VoicePrivacy is disabled"

    invoke-virtual {v5, v6}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 176
    :cond_1
    invoke-static {v2}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    if-nez v1, :cond_2

    .line 177
    iget-object p2, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p2, p2, Lcom/android/internal/telephony/RIL;->mTestingEmergencyCall:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p2, v3}, Ljava/util/concurrent/atomic/AtomicBoolean;->getAndSet(Z)Z

    move-result p2

    if-eqz p2, :cond_2

    .line 178
    iget-object p2, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object v1, p2, Lcom/android/internal/telephony/BaseCommands;->mEmergencyCallbackModeRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz v1, :cond_2

    const-string v1, "responseCurrentCalls: call ended, testing emergency call, notify ECM Registrants"

    .line 179
    invoke-virtual {p2, v1}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    .line 181
    iget-object p2, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p2, p2, Lcom/android/internal/telephony/BaseCommands;->mEmergencyCallbackModeRegistrant:Lcom/android/internal/telephony/Registrant;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    .line 185
    :cond_2
    iget p2, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez p2, :cond_3

    .line 186
    iget-object p2, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2, v2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 188
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, v2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_4
    return-void
.end method

.method public getInterfaceHash()Ljava/lang/String;
    .locals 0

    const-string p0, "e9ffc70247a89e6c1e526c6334c37da46f33ebea"

    return-object p0
.end method

.method public getInterfaceVersion()I
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public getLastCallFailCauseResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/voice/LastCallFailCauseInfo;)V
    .locals 3

    .line 201
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 204
    new-instance v1, Lcom/android/internal/telephony/LastCallFailCause;

    invoke-direct {v1}, Lcom/android/internal/telephony/LastCallFailCause;-><init>()V

    .line 205
    iget v2, p2, Landroid/hardware/radio/voice/LastCallFailCauseInfo;->causeCode:I

    iput v2, v1, Lcom/android/internal/telephony/LastCallFailCause;->causeCode:I

    .line 206
    iget-object p2, p2, Landroid/hardware/radio/voice/LastCallFailCauseInfo;->vendorCause:Ljava/lang/String;

    iput-object p2, v1, Lcom/android/internal/telephony/LastCallFailCause;->vendorCause:Ljava/lang/String;

    .line 207
    iget p2, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez p2, :cond_0

    .line 208
    iget-object p2, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2, v1}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 210
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, v1}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

.method public getMuteResponse(Landroid/hardware/radio/RadioResponseInfo;Z)V
    .locals 2

    .line 219
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    new-array v0, v0, [I

    const/4 v1, 0x0

    aput p2, v0, v1

    const/4 p2, 0x6

    invoke-static {p2, p0, p1, v0}, Lcom/android/internal/telephony/RadioResponse;->responseInts(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;[I)V

    return-void
.end method

.method public getPreferredVoicePrivacyResponse(Landroid/hardware/radio/RadioResponseInfo;Z)V
    .locals 2

    .line 228
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    new-array v0, v0, [I

    const/4 v1, 0x0

    aput p2, v0, v1

    const/4 p2, 0x6

    invoke-static {p2, p0, p1, v0}, Lcom/android/internal/telephony/RadioResponse;->responseInts(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;[I)V

    return-void
.end method

.method public getTtyModeResponse(Landroid/hardware/radio/RadioResponseInfo;I)V
    .locals 2

    .line 236
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    new-array v0, v0, [I

    const/4 v1, 0x0

    aput p2, v0, v1

    const/4 p2, 0x6

    invoke-static {p2, p0, p1, v0}, Lcom/android/internal/telephony/RadioResponse;->responseInts(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;[I)V

    return-void
.end method

.method public handleStkCallSetupRequestFromSimResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 243
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public hangupConnectionResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 250
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public hangupForegroundResumeBackgroundResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 257
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public hangupWaitingOrBackgroundResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 264
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public isVoNrEnabledResponse(Landroid/hardware/radio/RadioResponseInfo;Z)V
    .locals 3

    .line 272
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 275
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v1, :cond_0

    .line 276
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 278
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p2

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

.method public rejectCallResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 286
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public sendBurstDtmfResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 293
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public sendCdmaFeatureCodeResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 300
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public sendDtmfResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 307
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public sendUssdResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 314
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public separateConnectionResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 321
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setCallForwardResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 328
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setCallWaitingResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 335
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setClirResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 342
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setMuteResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 349
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setPreferredVoicePrivacyResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 356
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setTtyModeResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 363
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setVoNrEnabledResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 370
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public startDtmfResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 377
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public stopDtmfResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 384
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public switchWaitingOrHoldingAndActiveResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 391
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x6

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method
