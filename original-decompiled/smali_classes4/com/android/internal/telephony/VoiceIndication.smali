.class public Lcom/android/internal/telephony/VoiceIndication;
.super Landroid/hardware/radio/voice/IRadioVoiceIndication$Stub;
.source "VoiceIndication.java"


# instance fields
.field private final mRil:Lcom/android/internal/telephony/RIL;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/RIL;)V
    .locals 0

    .line 52
    invoke-direct {p0}, Landroid/hardware/radio/voice/IRadioVoiceIndication$Stub;-><init>()V

    .line 53
    iput-object p1, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    return-void
.end method


# virtual methods
.method public callRing(IZLandroid/hardware/radio/voice/CdmaSignalInfoRecord;)V
    .locals 2

    .line 66
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    const/4 p1, 0x0

    if-nez p2, :cond_0

    const/4 p2, 0x4

    new-array p2, p2, [C

    const/4 v0, 0x0

    .line 74
    iget-boolean v1, p3, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->isPresent:Z

    int-to-char v1, v1

    aput-char v1, p2, v0

    const/4 v0, 0x1

    .line 75
    iget-byte v1, p3, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->signalType:B

    int-to-char v1, v1

    aput-char v1, p2, v0

    const/4 v0, 0x2

    .line 76
    iget-byte v1, p3, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->alertPitch:B

    int-to-char v1, v1

    aput-char v1, p2, v0

    const/4 v0, 0x3

    .line 77
    iget-byte p3, p3, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->signal:B

    int-to-char p3, p3

    aput-char p3, p2, v0

    .line 78
    iget-object p3, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/RIL;->writeMetricsCallRing([C)V

    goto :goto_0

    :cond_0
    move-object p2, p1

    .line 81
    :goto_0
    iget-object p3, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x3fa

    invoke-virtual {p3, v0, p2}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 83
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mRingRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz p0, :cond_1

    .line 84
    new-instance p3, Landroid/os/AsyncResult;

    invoke-direct {p3, p1, p2, p1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant(Landroid/os/AsyncResult;)V

    :cond_1
    return-void
.end method

.method public callStateChanged(I)V
    .locals 2

    .line 93
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 95
    iget-object p1, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x3e9

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RIL;->unsljLog(I)V

    .line 97
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mCallStateRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    return-void
.end method

.method public cdmaCallWaiting(ILandroid/hardware/radio/voice/CdmaCallWaiting;)V
    .locals 2

    .line 107
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 111
    new-instance p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;

    invoke-direct {p1}, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;-><init>()V

    .line 112
    iget-object v0, p2, Landroid/hardware/radio/voice/CdmaCallWaiting;->number:Ljava/lang/String;

    iput-object v0, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->number:Ljava/lang/String;

    .line 113
    iget v0, p2, Landroid/hardware/radio/voice/CdmaCallWaiting;->numberPresentation:I

    invoke-static {v0}, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->presentationFromCLIP(I)I

    move-result v0

    iput v0, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->numberPresentation:I

    .line 115
    iget-object v1, p2, Landroid/hardware/radio/voice/CdmaCallWaiting;->name:Ljava/lang/String;

    iput-object v1, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->name:Ljava/lang/String;

    .line 116
    iput v0, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->namePresentation:I

    .line 117
    iget-object v0, p2, Landroid/hardware/radio/voice/CdmaCallWaiting;->signalInfoRecord:Landroid/hardware/radio/voice/CdmaSignalInfoRecord;

    iget-boolean v1, v0, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->isPresent:Z

    iput v1, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->isPresent:I

    .line 118
    iget-byte v1, v0, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->signalType:B

    iput v1, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->signalType:I

    .line 119
    iget-byte v1, v0, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->alertPitch:B

    iput v1, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->alertPitch:I

    .line 120
    iget-byte v0, v0, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->signal:B

    iput v0, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->signal:I

    .line 121
    iget v0, p2, Landroid/hardware/radio/voice/CdmaCallWaiting;->numberType:I

    iput v0, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->numberType:I

    .line 122
    iget p2, p2, Landroid/hardware/radio/voice/CdmaCallWaiting;->numberPlan:I

    iput p2, p1, Lcom/android/internal/telephony/cdma/CdmaCallWaitingNotification;->numberPlan:I

    .line 124
    iget-object p2, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x401

    invoke-virtual {p2, v0, p1}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 126
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mCallWaitingInfoRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance p2, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method public cdmaInfoRec(I[Landroid/hardware/radio/voice/CdmaInformationRecord;)V
    .locals 10

    .line 137
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    const/4 p1, 0x0

    move v0, p1

    .line 139
    :goto_0
    array-length v1, p2

    if-ge v0, v1, :cond_0

    .line 140
    aget-object v1, p2, v0

    .line 141
    iget v3, v1, Landroid/hardware/radio/voice/CdmaInformationRecord;->name:I

    packed-switch v3, :pswitch_data_0

    .line 219
    :pswitch_0
    new-instance p0, Ljava/lang/RuntimeException;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "RIL_UNSOL_CDMA_INFO_REC: unsupported record. Got "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 220
    invoke-static {v3}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;->idToString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 210
    :pswitch_1
    iget-object v1, v1, Landroid/hardware/radio/voice/CdmaInformationRecord;->audioCtrl:[Landroid/hardware/radio/voice/CdmaT53AudioControlInfoRecord;

    aget-object v1, v1, p1

    .line 211
    new-instance v2, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaT53AudioControlInfoRec;

    iget-byte v3, v1, Landroid/hardware/radio/voice/CdmaT53AudioControlInfoRecord;->upLink:B

    iget-byte v1, v1, Landroid/hardware/radio/voice/CdmaT53AudioControlInfoRecord;->downLink:B

    invoke-direct {v2, v3, v1}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaT53AudioControlInfoRec;-><init>(II)V

    .line 215
    new-instance v1, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;-><init>(Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaT53AudioControlInfoRec;)V

    goto/16 :goto_1

    .line 203
    :pswitch_2
    new-instance v2, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaT53ClirInfoRec;

    iget-object v1, v1, Landroid/hardware/radio/voice/CdmaInformationRecord;->clir:[Landroid/hardware/radio/voice/CdmaT53ClirInfoRecord;

    aget-object v1, v1, p1

    iget-byte v1, v1, Landroid/hardware/radio/voice/CdmaT53ClirInfoRecord;->cause:B

    invoke-direct {v2, v1}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaT53ClirInfoRec;-><init>(I)V

    .line 205
    new-instance v1, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;-><init>(Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaT53ClirInfoRec;)V

    goto/16 :goto_1

    .line 191
    :pswitch_3
    iget-object v1, v1, Landroid/hardware/radio/voice/CdmaInformationRecord;->lineCtrl:[Landroid/hardware/radio/voice/CdmaLineControlInfoRecord;

    aget-object v1, v1, p1

    .line 193
    new-instance v2, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaLineControlInfoRec;

    iget-byte v3, v1, Landroid/hardware/radio/voice/CdmaLineControlInfoRecord;->lineCtrlPolarityIncluded:B

    iget-byte v4, v1, Landroid/hardware/radio/voice/CdmaLineControlInfoRecord;->lineCtrlToggle:B

    iget-byte v5, v1, Landroid/hardware/radio/voice/CdmaLineControlInfoRecord;->lineCtrlReverse:B

    iget-byte v1, v1, Landroid/hardware/radio/voice/CdmaLineControlInfoRecord;->lineCtrlPowerDenial:B

    invoke-direct {v2, v3, v4, v5, v1}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaLineControlInfoRec;-><init>(IIII)V

    .line 199
    new-instance v1, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;-><init>(Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaLineControlInfoRec;)V

    goto :goto_1

    .line 176
    :pswitch_4
    iget-object v1, v1, Landroid/hardware/radio/voice/CdmaInformationRecord;->redir:[Landroid/hardware/radio/voice/CdmaRedirectingNumberInfoRecord;

    aget-object v1, v1, p1

    .line 178
    new-instance v9, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaRedirectingNumberInfoRec;

    iget-object v2, v1, Landroid/hardware/radio/voice/CdmaRedirectingNumberInfoRecord;->redirectingNumber:Landroid/hardware/radio/voice/CdmaNumberInfoRecord;

    iget-object v3, v2, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->number:Ljava/lang/String;

    iget-byte v4, v2, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->numberType:B

    iget-byte v5, v2, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->numberPlan:B

    iget-byte v6, v2, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->pi:B

    iget-byte v7, v2, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->si:B

    iget v8, v1, Landroid/hardware/radio/voice/CdmaRedirectingNumberInfoRecord;->redirectingReason:I

    move-object v2, v9

    invoke-direct/range {v2 .. v8}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaRedirectingNumberInfoRec;-><init>(Ljava/lang/String;IIIII)V

    .line 186
    new-instance v1, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;

    invoke-direct {v1, v9}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;-><init>(Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaRedirectingNumberInfoRec;)V

    goto :goto_1

    .line 165
    :pswitch_5
    iget-object v1, v1, Landroid/hardware/radio/voice/CdmaInformationRecord;->signal:[Landroid/hardware/radio/voice/CdmaSignalInfoRecord;

    aget-object v1, v1, p1

    .line 167
    new-instance v2, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaSignalInfoRec;

    .line 169
    iget-boolean v3, v1, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->isPresent:Z

    iget-byte v4, v1, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->signalType:B

    iget-byte v5, v1, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->alertPitch:B

    iget-byte v1, v1, Landroid/hardware/radio/voice/CdmaSignalInfoRecord;->signal:B

    invoke-direct {v2, v3, v4, v5, v1}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaSignalInfoRec;-><init>(IIII)V

    .line 171
    new-instance v1, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;-><init>(Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaSignalInfoRec;)V

    goto :goto_1

    .line 155
    :pswitch_6
    iget-object v1, v1, Landroid/hardware/radio/voice/CdmaInformationRecord;->number:[Landroid/hardware/radio/voice/CdmaNumberInfoRecord;

    aget-object v1, v1, p1

    .line 157
    new-instance v9, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaNumberInfoRec;

    iget-object v4, v1, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->number:Ljava/lang/String;

    iget-byte v5, v1, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->numberType:B

    iget-byte v6, v1, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->numberPlan:B

    iget-byte v7, v1, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->pi:B

    iget-byte v8, v1, Landroid/hardware/radio/voice/CdmaNumberInfoRecord;->si:B

    move-object v2, v9

    invoke-direct/range {v2 .. v8}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaNumberInfoRec;-><init>(ILjava/lang/String;IIII)V

    .line 161
    new-instance v1, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;

    invoke-direct {v1, v9}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;-><init>(Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaNumberInfoRec;)V

    goto :goto_1

    .line 146
    :pswitch_7
    new-instance v2, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaDisplayInfoRec;

    iget-object v1, v1, Landroid/hardware/radio/voice/CdmaInformationRecord;->display:[Landroid/hardware/radio/voice/CdmaDisplayInfoRecord;

    aget-object v1, v1, p1

    iget-object v1, v1, Landroid/hardware/radio/voice/CdmaDisplayInfoRecord;->alphaBuf:Ljava/lang/String;

    invoke-direct {v2, v3, v1}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaDisplayInfoRec;-><init>(ILjava/lang/String;)V

    .line 149
    new-instance v1, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/cdma/CdmaInformationRecords;-><init>(Lcom/android/internal/telephony/cdma/CdmaInformationRecords$CdmaDisplayInfoRec;)V

    .line 223
    :goto_1
    iget-object v2, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v3, 0x403

    invoke-virtual {v2, v3, v1}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 224
    iget-object v2, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/RIL;->notifyRegistrantsCdmaInfoRec(Lcom/android/internal/telephony/cdma/CdmaInformationRecords;)V

    add-int/lit8 v0, v0, 0x1

    goto/16 :goto_0

    :cond_0
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_7
        :pswitch_6
        :pswitch_6
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_7
        :pswitch_2
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public cdmaOtaProvisionStatus(II)V
    .locals 2

    .line 234
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    const/4 p1, 0x1

    new-array p1, p1, [I

    const/4 v0, 0x0

    aput p2, p1, v0

    .line 238
    iget-object p2, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x402

    invoke-virtual {p2, v0, p1}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 240
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mOtaProvisionRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance p2, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method public currentEmergencyNumberList(I[Landroid/hardware/radio/voice/EmergencyNumber;)V
    .locals 12

    .line 251
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 253
    new-instance p1, Ljava/util/ArrayList;

    array-length v0, p2

    invoke-direct {p1, v0}, Ljava/util/ArrayList;-><init>(I)V

    .line 254
    array-length v0, p2

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_0

    aget-object v2, p2, v1

    .line 255
    new-instance v11, Landroid/telephony/emergency/EmergencyNumber;

    iget-object v4, v2, Landroid/hardware/radio/voice/EmergencyNumber;->number:Ljava/lang/String;

    iget-object v3, v2, Landroid/hardware/radio/voice/EmergencyNumber;->mcc:Ljava/lang/String;

    .line 256
    invoke-static {v3}, Lcom/android/internal/telephony/MccTable;->countryCodeForMcc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    iget-object v6, v2, Landroid/hardware/radio/voice/EmergencyNumber;->mnc:Ljava/lang/String;

    iget v7, v2, Landroid/hardware/radio/voice/EmergencyNumber;->categories:I

    iget-object v3, v2, Landroid/hardware/radio/voice/EmergencyNumber;->urns:[Ljava/lang/String;

    .line 257
    invoke-static {v3}, Lcom/android/internal/telephony/RILUtils;->primitiveArrayToArrayList([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v8

    iget v9, v2, Landroid/hardware/radio/voice/EmergencyNumber;->sources:I

    const/4 v10, 0x0

    move-object v3, v11

    invoke-direct/range {v3 .. v10}, Landroid/telephony/emergency/EmergencyNumber;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/util/List;II)V

    .line 259
    invoke-interface {p1, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 262
    :cond_0
    iget-object p2, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x44e

    invoke-virtual {p2, v0, p1}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 265
    iget-object p2, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {p2, p1}, Lcom/android/internal/telephony/BaseCommands;->cacheEmergencyNumberListIndication(Ljava/util/List;)V

    .line 268
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mEmergencyNumberListRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance p2, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method public enterEmergencyCallbackMode(I)V
    .locals 2

    .line 278
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 280
    iget-object p1, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x400

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RIL;->unsljLog(I)V

    .line 282
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mEmergencyCallbackModeRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz p0, :cond_0

    .line 283
    invoke-virtual {p0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public exitEmergencyCallbackMode(I)V
    .locals 2

    .line 293
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 295
    iget-object p1, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x409

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RIL;->unsljLog(I)V

    .line 297
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mExitEmergencyCallbackModeRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

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

.method public indicateRingbackTone(IZ)V
    .locals 2

    .line 306
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 308
    iget-object p1, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    const/16 v1, 0x405

    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/RIL;->unsljLogvRet(ILjava/lang/Object;)V

    .line 310
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mRingbackToneRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance p1, Landroid/os/AsyncResult;

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p2

    const/4 v0, 0x0

    invoke-direct {p1, v0, p2, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method public onSupplementaryServiceIndication(ILandroid/hardware/radio/voice/StkCcUnsolSsResult;)V
    .locals 6

    .line 321
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 324
    new-instance p1, Lcom/android/internal/telephony/gsm/SsData;

    invoke-direct {p1}, Lcom/android/internal/telephony/gsm/SsData;-><init>()V

    .line 326
    iget v0, p2, Landroid/hardware/radio/voice/StkCcUnsolSsResult;->serviceType:I

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/gsm/SsData;->ServiceTypeFromRILInt(I)Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    move-result-object v0

    iput-object v0, p1, Lcom/android/internal/telephony/gsm/SsData;->serviceType:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    .line 327
    iget v0, p2, Landroid/hardware/radio/voice/StkCcUnsolSsResult;->requestType:I

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/gsm/SsData;->RequestTypeFromRILInt(I)Lcom/android/internal/telephony/gsm/SsData$RequestType;

    move-result-object v0

    iput-object v0, p1, Lcom/android/internal/telephony/gsm/SsData;->requestType:Lcom/android/internal/telephony/gsm/SsData$RequestType;

    .line 328
    iget v0, p2, Landroid/hardware/radio/voice/StkCcUnsolSsResult;->teleserviceType:I

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/gsm/SsData;->TeleserviceTypeFromRILInt(I)Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    move-result-object v0

    iput-object v0, p1, Lcom/android/internal/telephony/gsm/SsData;->teleserviceType:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    .line 329
    iget v0, p2, Landroid/hardware/radio/voice/StkCcUnsolSsResult;->serviceClass:I

    iput v0, p1, Lcom/android/internal/telephony/gsm/SsData;->serviceClass:I

    .line 330
    iget v0, p2, Landroid/hardware/radio/voice/StkCcUnsolSsResult;->result:I

    iput v0, p1, Lcom/android/internal/telephony/gsm/SsData;->result:I

    .line 332
    iget-object v0, p1, Lcom/android/internal/telephony/gsm/SsData;->serviceType:Lcom/android/internal/telephony/gsm/SsData$ServiceType;

    invoke-virtual {v0}, Lcom/android/internal/telephony/gsm/SsData$ServiceType;->isTypeCF()Z

    move-result v0

    const-string v1, " : "

    const/4 v2, 0x0

    if-eqz v0, :cond_0

    iget-object v0, p1, Lcom/android/internal/telephony/gsm/SsData;->requestType:Lcom/android/internal/telephony/gsm/SsData$RequestType;

    invoke-virtual {v0}, Lcom/android/internal/telephony/gsm/SsData$RequestType;->isTypeInterrogation()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 333
    iget-object p2, p2, Landroid/hardware/radio/voice/StkCcUnsolSsResult;->cfData:[Landroid/hardware/radio/voice/CfData;

    aget-object p2, p2, v2

    .line 334
    iget-object v0, p2, Landroid/hardware/radio/voice/CfData;->cfInfo:[Landroid/hardware/radio/voice/CallForwardInfo;

    array-length v0, v0

    .line 335
    new-array v3, v0, [Lcom/android/internal/telephony/CallForwardInfo;

    iput-object v3, p1, Lcom/android/internal/telephony/gsm/SsData;->cfInfo:[Lcom/android/internal/telephony/CallForwardInfo;

    :goto_0
    if-ge v2, v0, :cond_1

    .line 338
    iget-object v3, p2, Landroid/hardware/radio/voice/CfData;->cfInfo:[Landroid/hardware/radio/voice/CallForwardInfo;

    aget-object v3, v3, v2

    .line 339
    iget-object v4, p1, Lcom/android/internal/telephony/gsm/SsData;->cfInfo:[Lcom/android/internal/telephony/CallForwardInfo;

    new-instance v5, Lcom/android/internal/telephony/CallForwardInfo;

    invoke-direct {v5}, Lcom/android/internal/telephony/CallForwardInfo;-><init>()V

    aput-object v5, v4, v2

    .line 340
    iget-object v4, p1, Lcom/android/internal/telephony/gsm/SsData;->cfInfo:[Lcom/android/internal/telephony/CallForwardInfo;

    aget-object v4, v4, v2

    iget v5, v3, Landroid/hardware/radio/voice/CallForwardInfo;->status:I

    iput v5, v4, Lcom/android/internal/telephony/CallForwardInfo;->status:I

    .line 341
    iget v5, v3, Landroid/hardware/radio/voice/CallForwardInfo;->reason:I

    iput v5, v4, Lcom/android/internal/telephony/CallForwardInfo;->reason:I

    .line 342
    iget v5, v3, Landroid/hardware/radio/voice/CallForwardInfo;->serviceClass:I

    iput v5, v4, Lcom/android/internal/telephony/CallForwardInfo;->serviceClass:I

    .line 343
    iget v5, v3, Landroid/hardware/radio/voice/CallForwardInfo;->toa:I

    iput v5, v4, Lcom/android/internal/telephony/CallForwardInfo;->toa:I

    .line 344
    iget-object v5, v3, Landroid/hardware/radio/voice/CallForwardInfo;->number:Ljava/lang/String;

    iput-object v5, v4, Lcom/android/internal/telephony/CallForwardInfo;->number:Ljava/lang/String;

    .line 345
    iget v3, v3, Landroid/hardware/radio/voice/CallForwardInfo;->timeSeconds:I

    iput v3, v4, Lcom/android/internal/telephony/CallForwardInfo;->timeSeconds:I

    .line 346
    iget-object v3, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "[SS Data] CF Info "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p1, Lcom/android/internal/telephony/gsm/SsData;->cfInfo:[Lcom/android/internal/telephony/CallForwardInfo;

    aget-object v5, v5, v2

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 349
    :cond_0
    iget-object p2, p2, Landroid/hardware/radio/voice/StkCcUnsolSsResult;->ssInfo:[Landroid/hardware/radio/voice/SsInfoData;

    aget-object p2, p2, v2

    .line 350
    iget-object v0, p2, Landroid/hardware/radio/voice/SsInfoData;->ssInfo:[I

    array-length v0, v0

    .line 351
    new-array v3, v0, [I

    iput-object v3, p1, Lcom/android/internal/telephony/gsm/SsData;->ssInfo:[I

    :goto_1
    if-ge v2, v0, :cond_1

    .line 353
    iget-object v3, p1, Lcom/android/internal/telephony/gsm/SsData;->ssInfo:[I

    iget-object v4, p2, Landroid/hardware/radio/voice/SsInfoData;->ssInfo:[I

    aget v4, v4, v2

    aput v4, v3, v2

    .line 354
    iget-object v3, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "[SS Data] SS Info "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p1, Lcom/android/internal/telephony/gsm/SsData;->ssInfo:[I

    aget v5, v5, v2

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/RIL;->riljLog(Ljava/lang/String;)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 358
    :cond_1
    iget-object p2, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x413

    invoke-virtual {p2, v0, p1}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 360
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mSsRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz p0, :cond_2

    .line 361
    new-instance p2, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant(Landroid/os/AsyncResult;)V

    :cond_2
    return-void
.end method

.method public onUssd(IILjava/lang/String;)V
    .locals 3

    .line 373
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 375
    iget-object p1, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/16 v2, 0x3ee

    invoke-virtual {p1, v2, v0}, Lcom/android/internal/telephony/RIL;->unsljLogMore(ILjava/lang/String;)V

    const/4 p1, 0x2

    new-array p1, p1, [Ljava/lang/String;

    .line 378
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const/4 v0, 0x0

    aput-object p2, p1, v0

    const/4 p2, 0x1

    aput-object p3, p1, p2

    .line 379
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mUSSDRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz p0, :cond_0

    .line 380
    new-instance p2, Landroid/os/AsyncResult;

    const/4 p3, 0x0

    invoke-direct {p2, p3, p1, p3}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant(Landroid/os/AsyncResult;)V

    :cond_0
    return-void
.end method

.method public resendIncallMute(I)V
    .locals 2

    .line 389
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 391
    iget-object p1, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x406

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RIL;->unsljLog(I)V

    .line 393
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mResendIncallMuteRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    return-void
.end method

.method public srvccStateNotify(II)V
    .locals 2

    .line 402
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    const/4 p1, 0x1

    new-array p1, p1, [I

    const/4 v0, 0x0

    aput p2, p1, v0

    .line 406
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v1, 0x40f

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 408
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/RIL;->writeMetricsSrvcc(I)V

    .line 409
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mSrvccStateRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance p2, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p2, v0, p1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants(Landroid/os/AsyncResult;)V

    return-void
.end method

.method public stkCallControlAlphaNotify(ILjava/lang/String;)V
    .locals 2

    .line 418
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 420
    iget-object p1, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/16 v0, 0x414

    invoke-virtual {p1, v0, p2}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 422
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mCatCcAlphaRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz p0, :cond_0

    .line 423
    new-instance p1, Landroid/os/AsyncResult;

    const/4 v0, 0x0

    invoke-direct {p1, v0, p2, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant(Landroid/os/AsyncResult;)V

    :cond_0
    return-void
.end method

.method public stkCallSetup(IJ)V
    .locals 2

    .line 433
    iget-object v0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    const/4 v1, 0x6

    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/RIL;->processIndication(II)V

    .line 435
    iget-object p1, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    const/16 v1, 0x3f7

    invoke-virtual {p1, v1, v0}, Lcom/android/internal/telephony/RIL;->unsljLogRet(ILjava/lang/Object;)V

    .line 437
    iget-object p0, p0, Lcom/android/internal/telephony/VoiceIndication;->mRil:Lcom/android/internal/telephony/RIL;

    iget-object p0, p0, Lcom/android/internal/telephony/BaseCommands;->mCatCallSetUpRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz p0, :cond_0

    .line 438
    new-instance p1, Landroid/os/AsyncResult;

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p2

    const/4 p3, 0x0

    invoke-direct {p1, p3, p2, p3}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant(Landroid/os/AsyncResult;)V

    :cond_0
    return-void
.end method
