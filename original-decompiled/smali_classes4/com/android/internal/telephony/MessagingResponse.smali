.class public Lcom/android/internal/telephony/MessagingResponse;
.super Landroid/hardware/radio/messaging/IRadioMessagingResponse$Stub;
.source "MessagingResponse.java"


# instance fields
.field private final mRil:Lcom/android/internal/telephony/RIL;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/RIL;)V
    .locals 0

    .line 33
    invoke-direct {p0}, Landroid/hardware/radio/messaging/IRadioMessagingResponse$Stub;-><init>()V

    .line 34
    iput-object p1, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    return-void
.end method

.method private responseSms(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V
    .locals 8

    .line 39
    iget-object v0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 42
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {v1}, Lcom/android/internal/telephony/RIL;->getOutgoingSmsMessageId(Landroid/os/Message;)J

    move-result-wide v6

    .line 43
    new-instance v1, Lcom/android/internal/telephony/SmsResponse;

    iget v3, p2, Landroid/hardware/radio/messaging/SendSmsResult;->messageRef:I

    iget-object v4, p2, Landroid/hardware/radio/messaging/SendSmsResult;->ackPDU:Ljava/lang/String;

    iget v5, p2, Landroid/hardware/radio/messaging/SendSmsResult;->errorCode:I

    move-object v2, v1

    invoke-direct/range {v2 .. v7}, Lcom/android/internal/telephony/SmsResponse;-><init>(ILjava/lang/String;IJ)V

    .line 44
    iget p2, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez p2, :cond_0

    .line 45
    iget-object p2, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2, v1}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 47
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, v1}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method


# virtual methods
.method public acknowledgeIncomingGsmSmsWithPduResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 65
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public acknowledgeLastIncomingCdmaSmsResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 72
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public acknowledgeLastIncomingGsmSmsResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 79
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public acknowledgeRequest(I)V
    .locals 0

    .line 58
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RIL;->processRequestAck(I)V

    return-void
.end method

.method public deleteSmsOnRuimResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 86
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public deleteSmsOnSimResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 93
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public getCdmaBroadcastConfigResponse(Landroid/hardware/radio/RadioResponseInfo;[Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;)V
    .locals 7

    .line 102
    iget-object v0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 106
    array-length v1, p2

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-nez v1, :cond_0

    const/16 p2, 0x5e

    new-array v1, p2, [I

    const/16 v4, 0x1f

    aput v4, v1, v2

    move v4, v3

    :goto_0
    if-ge v4, p2, :cond_2

    .line 121
    div-int/lit8 v5, v4, 0x3

    aput v5, v1, v4

    add-int/lit8 v5, v4, 0x1

    .line 122
    aput v3, v1, v5

    add-int/lit8 v5, v4, 0x2

    .line 123
    aput v2, v1, v5

    add-int/lit8 v4, v4, 0x3

    goto :goto_0

    :cond_0
    mul-int/lit8 v4, v1, 0x3

    add-int/2addr v4, v3

    .line 128
    new-array v4, v4, [I

    .line 130
    aput v1, v4, v2

    .line 131
    :goto_1
    array-length v1, p2

    if-ge v2, v1, :cond_1

    .line 133
    aget-object v1, p2, v3

    iget v5, v1, Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;->serviceCategory:I

    aput v5, v4, v3

    add-int/lit8 v5, v3, 0x1

    .line 134
    iget v6, v1, Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;->language:I

    aput v6, v4, v5

    add-int/lit8 v5, v3, 0x2

    .line 135
    iget-boolean v1, v1, Landroid/hardware/radio/messaging/CdmaBroadcastSmsConfigInfo;->selected:Z

    aput v1, v4, v5

    add-int/lit8 v2, v2, 0x1

    add-int/lit8 v3, v3, 0x3

    goto :goto_1

    :cond_1
    move-object v1, v4

    .line 138
    :cond_2
    iget p2, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez p2, :cond_3

    .line 139
    iget-object p2, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2, v1}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 141
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, v1}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_4
    return-void
.end method

.method public getGsmBroadcastConfigResponse(Landroid/hardware/radio/RadioResponseInfo;[Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;)V
    .locals 12

    .line 151
    iget-object v0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 154
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 155
    array-length v2, p2

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_0

    aget-object v4, p2, v3

    .line 156
    new-instance v11, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;

    iget v6, v4, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->fromServiceId:I

    iget v7, v4, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->toServiceId:I

    iget v8, v4, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->fromCodeScheme:I

    iget v9, v4, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->toCodeScheme:I

    iget-boolean v10, v4, Landroid/hardware/radio/messaging/GsmBroadcastSmsConfigInfo;->selected:Z

    move-object v5, v11

    invoke-direct/range {v5 .. v10}, Lcom/android/internal/telephony/gsm/SmsBroadcastConfigInfo;-><init>(IIIIZ)V

    invoke-virtual {v1, v11}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 159
    :cond_0
    iget p2, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez p2, :cond_1

    .line 160
    iget-object p2, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2, v1}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 162
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, v1}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_2
    return-void
.end method

.method public getInterfaceHash()Ljava/lang/String;
    .locals 0

    const-string p0, "5237ec5f500627b6b844b155e356e603157f9ba6"

    return-object p0
.end method

.method public getInterfaceVersion()I
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public getSmscAddressResponse(Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/String;)V
    .locals 1

    .line 171
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1, p2}, Lcom/android/internal/telephony/RadioResponse;->responseString(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/String;)V

    return-void
.end method

.method public reportSmsMemoryStatusResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 178
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public sendCdmaSmsExpectMoreResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V
    .locals 0

    .line 187
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/MessagingResponse;->responseSms(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V

    return-void
.end method

.method public sendCdmaSmsResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V
    .locals 0

    .line 196
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/MessagingResponse;->responseSms(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V

    return-void
.end method

.method public sendImsSmsResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V
    .locals 0

    .line 205
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/MessagingResponse;->responseSms(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V

    return-void
.end method

.method public sendSmsExpectMoreResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V
    .locals 0

    .line 214
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/MessagingResponse;->responseSms(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V

    return-void
.end method

.method public sendSmsResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V
    .locals 0

    .line 223
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/MessagingResponse;->responseSms(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/messaging/SendSmsResult;)V

    return-void
.end method

.method public setCdmaBroadcastActivationResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 230
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setCdmaBroadcastConfigResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 237
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setGsmBroadcastActivationResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 244
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setGsmBroadcastConfigResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 251
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setSmscAddressResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 258
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x2

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public writeSmsToRuimResponse(Landroid/hardware/radio/RadioResponseInfo;I)V
    .locals 2

    .line 266
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    new-array v0, v0, [I

    const/4 v1, 0x0

    aput p2, v0, v1

    const/4 p2, 0x2

    invoke-static {p2, p0, p1, v0}, Lcom/android/internal/telephony/RadioResponse;->responseInts(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;[I)V

    return-void
.end method

.method public writeSmsToSimResponse(Landroid/hardware/radio/RadioResponseInfo;I)V
    .locals 2

    .line 274
    iget-object p0, p0, Lcom/android/internal/telephony/MessagingResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    new-array v0, v0, [I

    const/4 v1, 0x0

    aput p2, v0, v1

    const/4 p2, 0x2

    invoke-static {p2, p0, p1, v0}, Lcom/android/internal/telephony/RadioResponse;->responseInts(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;[I)V

    return-void
.end method
