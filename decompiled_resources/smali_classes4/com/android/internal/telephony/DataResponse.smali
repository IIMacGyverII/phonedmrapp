.class public Lcom/android/internal/telephony/DataResponse;
.super Landroid/hardware/radio/data/IRadioDataResponse$Stub;
.source "DataResponse.java"


# instance fields
.field private final mRil:Lcom/android/internal/telephony/RIL;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/RIL;)V
    .locals 0

    .line 35
    invoke-direct {p0}, Landroid/hardware/radio/data/IRadioDataResponse$Stub;-><init>()V

    .line 36
    iput-object p1, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    return-void
.end method


# virtual methods
.method public acknowledgeRequest(I)V
    .locals 0

    .line 46
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RIL;->processRequestAck(I)V

    return-void
.end method

.method public allocatePduSessionIdResponse(Landroid/hardware/radio/RadioResponseInfo;I)V
    .locals 3

    .line 54
    iget-object v0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x1

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 56
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v1, :cond_0

    .line 57
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 59
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

.method public cancelHandoverResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 67
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public deactivateDataCallResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 74
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public getDataCallListResponse(Landroid/hardware/radio/RadioResponseInfo;[Landroid/hardware/radio/data/SetupDataCallResult;)V
    .locals 2

    .line 83
    iget-object v0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x1

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 87
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertHalDataCallResultList([Landroid/hardware/radio/data/SetupDataCallResult;)Ljava/util/ArrayList;

    move-result-object p2

    .line 88
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v1, :cond_0

    .line 89
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {v1, p2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 91
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

.method public getInterfaceHash()Ljava/lang/String;
    .locals 0

    const-string p0, "6d7a86008ea4fe79ced2a86b526a92618eb4c84a"

    return-object p0
.end method

.method public getInterfaceVersion()I
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public getSlicingConfigResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/data/SlicingConfig;)V
    .locals 2

    .line 101
    iget-object v0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x1

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 104
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertHalSlicingConfig(Landroid/hardware/radio/data/SlicingConfig;)Landroid/telephony/data/NetworkSlicingConfig;

    move-result-object p2

    .line 105
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v1, :cond_0

    .line 106
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {v1, p2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 108
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

.method public releasePduSessionIdResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 116
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setDataAllowedResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 123
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setDataProfileResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 130
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setDataThrottlingResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 137
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setInitialAttachApnResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 144
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public setupDataCallResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/data/SetupDataCallResult;)V
    .locals 2

    .line 153
    iget-object v0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x1

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 156
    invoke-static {p2}, Lcom/android/internal/telephony/RILUtils;->convertHalDataCallResult(Landroid/hardware/radio/data/SetupDataCallResult;)Landroid/telephony/data/DataCallResponse;

    move-result-object p2

    .line 157
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v1, :cond_0

    .line 158
    iget-object v1, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {v1, p2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V

    .line 160
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

.method public startHandoverResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 1

    .line 168
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v0, 0x1

    invoke-static {v0, p0, p1}, Lcom/android/internal/telephony/RadioResponse;->responseVoid(ILcom/android/internal/telephony/RIL;Landroid/hardware/radio/RadioResponseInfo;)V

    return-void
.end method

.method public startKeepaliveResponse(Landroid/hardware/radio/RadioResponseInfo;Landroid/hardware/radio/data/KeepaliveStatus;)V
    .locals 4

    .line 178
    iget-object v0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x1

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    const/4 v2, 0x0

    .line 183
    :try_start_0
    iget v3, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-eqz v3, :cond_3

    const/4 p2, 0x6

    if-eq v3, p2, :cond_2

    const/16 p2, 0x2a

    if-eq v3, p2, :cond_1

    .line 204
    new-instance p2, Lcom/android/internal/telephony/data/KeepaliveStatus;

    const/4 v1, 0x3

    invoke-direct {p2, v1}, Lcom/android/internal/telephony/data/KeepaliveStatus;-><init>(I)V

    goto :goto_1

    .line 201
    :cond_1
    new-instance p2, Lcom/android/internal/telephony/data/KeepaliveStatus;

    const/4 v1, 0x2

    invoke-direct {p2, v1}, Lcom/android/internal/telephony/data/KeepaliveStatus;-><init>(I)V

    goto :goto_1

    .line 198
    :cond_2
    new-instance p2, Lcom/android/internal/telephony/data/KeepaliveStatus;

    invoke-direct {p2, v1}, Lcom/android/internal/telephony/data/KeepaliveStatus;-><init>(I)V

    goto :goto_1

    .line 185
    :cond_3
    iget v3, p2, Landroid/hardware/radio/data/KeepaliveStatus;->code:I

    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->convertHalKeepaliveStatusCode(I)I

    move-result v3

    if-gez v3, :cond_4

    .line 188
    new-instance p2, Lcom/android/internal/telephony/data/KeepaliveStatus;

    invoke-direct {p2, v1}, Lcom/android/internal/telephony/data/KeepaliveStatus;-><init>(I)V

    move-object v2, p2

    goto :goto_0

    .line 190
    :cond_4
    new-instance v1, Lcom/android/internal/telephony/data/KeepaliveStatus;

    iget p2, p2, Landroid/hardware/radio/data/KeepaliveStatus;->sessionHandle:I

    invoke-direct {v1, p2, v3}, Lcom/android/internal/telephony/data/KeepaliveStatus;-><init>(II)V

    move-object v2, v1

    .line 195
    :goto_0
    iget-object p2, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {p2, v2}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-object p2, v2

    .line 209
    :goto_1
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    return-void

    :catchall_0
    move-exception p2

    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, v2}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    .line 210
    throw p2
.end method

.method public stopKeepaliveResponse(Landroid/hardware/radio/RadioResponseInfo;)V
    .locals 3

    .line 217
    iget-object v0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x1

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processResponse(ILandroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    const/4 v1, 0x0

    .line 221
    :try_start_0
    iget v2, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    if-nez v2, :cond_1

    .line 222
    iget-object v2, v0, Lcom/android/internal/telephony/RILRequest;->mResult:Landroid/os/Message;

    invoke-static {v2, v1}, Lcom/android/internal/telephony/RadioResponse;->sendMessageResponse(Landroid/os/Message;Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 227
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, v1}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    return-void

    :catchall_0
    move-exception v2

    iget-object p0, p0, Lcom/android/internal/telephony/DataResponse;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p0, v0, p1, v1}, Lcom/android/internal/telephony/RIL;->processResponseDone(Lcom/android/internal/telephony/RILRequest;Landroid/hardware/radio/RadioResponseInfo;Ljava/lang/Object;)V

    .line 228
    throw v2
.end method
