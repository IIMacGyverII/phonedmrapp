.class public Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
.super Ljava/lang/Object;
.source "SmsSessionEventBuilder.java"


# instance fields
.field mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;


# direct methods
.method public constructor <init>(I)V
    .locals 1

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 27
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    .line 34
    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->type:I

    return-void
.end method


# virtual methods
.method public build()Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;
    .locals 0

    .line 30
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    return-object p0
.end method

.method public setBlocked(Z)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 110
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->blocked:Z

    return-object p0
.end method

.method public setCellBroadcastMessage(Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 98
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->cellBroadcastMessage:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;

    return-object p0
.end method

.method public setDataCalls([Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 83
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->dataCalls:[Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;

    return-object p0
.end method

.method public setDelay(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 38
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->delay:I

    return-object p0
.end method

.method public setErrorCode(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 48
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->errorCode:I

    return-object p0
.end method

.method public setFormat(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 93
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->format:I

    return-object p0
.end method

.method public setImsCapabilities(Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 78
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->imsCapabilities:Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;

    return-object p0
.end method

.method public setImsConnectionState(Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 73
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->imsConnectionState:Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;

    return-object p0
.end method

.method public setImsServiceErrno(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 58
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->imsError:I

    return-object p0
.end method

.method public setIncompleteSms(Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 104
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->incompleteSms:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;

    return-object p0
.end method

.method public setMessageId(J)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 122
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-wide p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->messageId:J

    return-object p0
.end method

.method public setRilErrno(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 53
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->error:I

    return-object p0
.end method

.method public setRilRequestId(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 88
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->rilRequestId:I

    return-object p0
.end method

.method public setServiceState(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 68
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    return-object p0
.end method

.method public setSettings(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 63
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->settings:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;

    return-object p0
.end method

.method public setSmsType(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 116
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->smsType:I

    return-object p0
.end method

.method public setTech(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;
    .locals 1

    .line 43
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->mEvent:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->tech:I

    return-object p0
.end method
