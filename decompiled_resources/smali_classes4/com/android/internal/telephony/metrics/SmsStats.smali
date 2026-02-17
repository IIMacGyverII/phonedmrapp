.class public Lcom/android/internal/telephony/metrics/SmsStats;
.super Ljava/lang/Object;
.source "SmsStats.java"


# static fields
.field private static final NO_NETWORK_ERROR_3GPP:I = 0x14b

.field private static final NO_NETWORK_ERROR_3GPP2:I = 0x42

.field private static final RANDOM:Ljava/util/Random;

.field private static final TAG:Ljava/lang/String; = "SmsStats"


# instance fields
.field private final mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

.field private final mPhone:Lcom/android/internal/telephony/Phone;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 81
    new-instance v0, Ljava/util/Random;

    invoke-direct {v0}, Ljava/util/Random;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/metrics/SmsStats;->RANDOM:Ljava/util/Random;

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 1

    .line 83
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 79
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getMetricsCollector()Lcom/android/internal/telephony/metrics/MetricsCollector;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getAtomsStorage()Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    .line 84
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mPhone:Lcom/android/internal/telephony/Phone;

    return-void
.end method

.method private getCarrierId()I
    .locals 3

    .line 351
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 352
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneType()I

    move-result v1

    const/4 v2, 0x5

    if-ne v1, v2, :cond_0

    .line 353
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 355
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result p0

    return p0
.end method

.method private getIncomingDefaultProto(ZI)Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;
    .locals 2

    .line 200
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;-><init>()V

    .line 201
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/SmsStats;->getSmsFormat(Z)I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsFormat:I

    .line 202
    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/metrics/SmsStats;->getSmsTech(IZ)I

    move-result p1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsTech:I

    .line 203
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/SmsStats;->getRat(I)I

    move-result p1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->rat:I

    const/4 p1, 0x0

    .line 204
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsType:I

    const/4 p2, 0x1

    .line 205
    iput p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->totalParts:I

    .line 206
    iput p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->receivedParts:I

    .line 207
    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->blocked:Z

    .line 208
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->error:I

    .line 209
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getIsRoaming()Z

    move-result p1

    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->isRoaming:Z

    .line 210
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getPhoneId()I

    move-result p1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->simSlotIndex:I

    .line 211
    invoke-static {}, Lcom/android/internal/telephony/metrics/SimSlotState;->isMultiSim()Z

    move-result p1

    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->isMultiSim:Z

    .line 212
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getPhoneId()I

    move-result p1

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/SimSlotState;->isEsim(I)Z

    move-result p1

    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->isEsim:Z

    .line 213
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getCarrierId()I

    move-result p0

    iput p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->carrierId:I

    .line 216
    sget-object p0, Lcom/android/internal/telephony/metrics/SmsStats;->RANDOM:Ljava/util/Random;

    invoke-virtual {p0}, Ljava/util/Random;->nextLong()J

    move-result-wide p0

    iput-wide p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->messageId:J

    return-object v0
.end method

.method private static getIncomingSmsError(I)I
    .locals 3

    const/4 v0, -0x1

    if-eq p0, v0, :cond_2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_2

    const/4 v1, 0x3

    if-eq p0, v1, :cond_1

    const/4 v2, 0x4

    if-eq p0, v2, :cond_0

    return v0

    :cond_0
    return v1

    :cond_1
    const/4 p0, 0x2

    return p0

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method private static getIncomingSmsError(Z)I
    .locals 0

    if-eqz p0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method private getIsRoaming()Z
    .locals 0

    .line 346
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 347
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getRoaming()Z

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private getOutgoingDefaultProto(ZZJZJ)Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;
    .locals 3

    .line 223
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;-><init>()V

    .line 224
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/SmsStats;->getSmsFormat(Z)I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->smsFormat:I

    .line 225
    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/metrics/SmsStats;->getSmsTech(ZZ)I

    move-result p1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->smsTech:I

    .line 226
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/SmsStats;->getRat(Z)I

    move-result p1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->rat:I

    const/4 p1, 0x1

    .line 227
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->sendResult:I

    const/4 p1, 0x0

    if-eqz p2, :cond_0

    move p2, p1

    goto :goto_0

    :cond_0
    const/4 p2, -0x1

    .line 228
    :goto_0
    iput p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->errorCode:I

    .line 229
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getIsRoaming()Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->isRoaming:Z

    .line 230
    iput-boolean p5, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->isFromDefaultApp:Z

    .line 231
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getPhoneId()I

    move-result p2

    iput p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->simSlotIndex:I

    .line 232
    invoke-static {}, Lcom/android/internal/telephony/metrics/SimSlotState;->isMultiSim()Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->isMultiSim:Z

    .line 233
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getPhoneId()I

    move-result p2

    invoke-static {p2}, Lcom/android/internal/telephony/metrics/SimSlotState;->isEsim(I)Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->isEsim:Z

    .line 234
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getCarrierId()I

    move-result p0

    iput p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->carrierId:I

    const-wide/16 v1, 0x0

    cmp-long p0, p3, v1

    if-eqz p0, :cond_1

    goto :goto_1

    .line 236
    :cond_1
    sget-object p0, Lcom/android/internal/telephony/metrics/SmsStats;->RANDOM:Ljava/util/Random;

    invoke-virtual {p0}, Ljava/util/Random;->nextLong()J

    move-result-wide p3

    :goto_1
    iput-wide p3, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->messageId:J

    .line 239
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->retryId:I

    .line 240
    iput-wide p6, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->intervalMillis:J

    return-object v0
.end method

.method private static getOutgoingSmsError(I)I
    .locals 1

    const/4 v0, 0x1

    if-eq p0, v0, :cond_0

    const/4 v0, 0x2

    if-eq p0, v0, :cond_0

    const/4 v0, 0x3

    if-eq p0, v0, :cond_0

    const/4 v0, 0x4

    if-eq p0, v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    return v0
.end method

.method private getPhoneId()I
    .locals 3

    .line 308
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 309
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneType()I

    move-result v1

    const/4 v2, 0x5

    if-ne v1, v2, :cond_0

    .line 310
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 312
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    return p0
.end method

.method private getRat(I)I
    .locals 2

    const/4 v0, 0x0

    const/4 v1, 0x2

    if-ne p1, v1, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x1

    if-ne p1, v1, :cond_1

    move v0, v1

    .line 329
    :cond_1
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/SmsStats;->getRat(Z)I

    move-result p0

    return p0
.end method

.method private getRat(Z)I
    .locals 1

    if-eqz p1, :cond_0

    .line 334
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getImsRegistrationTech()I

    move-result p1

    const/4 v0, 0x1

    if-ne p1, v0, :cond_0

    const/16 p0, 0x12

    return p0

    .line 340
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/SmsStats;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 342
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getVoiceNetworkType()I

    move-result p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private getServiceState()Landroid/telephony/ServiceState;
    .locals 3

    .line 317
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 318
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneType()I

    move-result v1

    const/4 v2, 0x5

    if-ne v1, v2, :cond_0

    .line 319
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 321
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 322
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method private static getSmsFormat(Z)I
    .locals 0

    if-eqz p0, :cond_0

    const/4 p0, 0x2

    return p0

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method private getSmsTech(IZ)I
    .locals 2

    const/4 v0, 0x0

    const/4 v1, 0x2

    if-ne p1, v1, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x1

    if-ne p1, v1, :cond_1

    move v0, v1

    .line 256
    :cond_1
    invoke-direct {p0, v0, p2}, Lcom/android/internal/telephony/metrics/SmsStats;->getSmsTech(ZZ)I

    move-result p0

    return p0
.end method

.method private getSmsTech(ZZ)I
    .locals 0

    if-eqz p1, :cond_0

    const/4 p0, 0x3

    return p0

    :cond_0
    if-eqz p2, :cond_1

    const/4 p0, 0x2

    return p0

    :cond_1
    const/4 p0, 0x1

    return p0
.end method

.method private varargs loge(Ljava/lang/String;[Ljava/lang/Object;)V
    .locals 3

    .line 359
    sget-object v0, Lcom/android/internal/telephony/metrics/SmsStats;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "["

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1, p2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public onDroppedIncomingMultipartSms(ZII)V
    .locals 1

    const/4 v0, 0x0

    .line 89
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingDefaultProto(ZI)Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    move-result-object p1

    .line 92
    iput v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsTech:I

    .line 93
    iput v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->rat:I

    const/4 v0, 0x1

    .line 94
    iput v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->error:I

    .line 95
    iput p3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->totalParts:I

    .line 96
    iput p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->receivedParts:I

    .line 97
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addIncomingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V

    return-void
.end method

.method public onIncomingSmsError(ZII)V
    .locals 0

    .line 138
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingDefaultProto(ZI)Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    move-result-object p1

    .line 139
    invoke-static {p3}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingSmsError(I)I

    move-result p2

    iput p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->error:I

    .line 140
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addIncomingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V

    return-void
.end method

.method public onIncomingSmsPP(IZ)V
    .locals 1

    const/4 v0, 0x0

    .line 117
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingDefaultProto(ZI)Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    move-result-object p1

    const/4 v0, 0x1

    .line 118
    iput v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsType:I

    .line 119
    invoke-static {p2}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingSmsError(Z)I

    move-result p2

    iput p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->error:I

    .line 120
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addIncomingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V

    return-void
.end method

.method public onIncomingSmsSuccess(ZIIZJ)V
    .locals 0

    .line 127
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingDefaultProto(ZI)Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    move-result-object p1

    .line 128
    iput p3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->totalParts:I

    .line 129
    iput p3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->receivedParts:I

    .line 130
    iput-boolean p4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->blocked:Z

    .line 131
    iput-wide p5, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->messageId:J

    .line 132
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addIncomingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V

    return-void
.end method

.method public onIncomingSmsTypeZero(I)V
    .locals 1

    const/4 v0, 0x0

    .line 110
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingDefaultProto(ZI)Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    move-result-object p1

    const/4 v0, 0x3

    .line 111
    iput v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsType:I

    .line 112
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addIncomingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V

    return-void
.end method

.method public onIncomingSmsVoicemail(ZI)V
    .locals 0

    .line 103
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingDefaultProto(ZI)Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    move-result-object p1

    const/4 p2, 0x2

    .line 104
    iput p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsType:I

    .line 105
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addIncomingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V

    return-void
.end method

.method public onIncomingSmsWapPush(IIIJ)V
    .locals 1

    const/4 v0, 0x0

    .line 146
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingDefaultProto(ZI)Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    move-result-object p1

    const/4 v0, 0x4

    .line 147
    iput v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsType:I

    .line 148
    iput p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->totalParts:I

    .line 149
    iput p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->receivedParts:I

    .line 150
    invoke-static {p3}, Lcom/android/internal/telephony/metrics/SmsStats;->getIncomingSmsError(I)I

    move-result p2

    iput p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->error:I

    .line 151
    iput-wide p4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->messageId:J

    .line 152
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/SmsStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addIncomingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V

    return-void
.end method

.method public onOutgoingSms(ZZZIIJZJ)V
    .locals 10

    move v0, p4

    move v1, p5

    move-object v2, p0

    move v3, p2

    move v4, p1

    move-wide/from16 v5, p6

    move/from16 v7, p8

    move-wide/from16 v8, p9

    .line 168
    invoke-direct/range {v2 .. v9}, Lcom/android/internal/telephony/metrics/SmsStats;->getOutgoingDefaultProto(ZZJZJ)Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    move-result-object v2

    const/4 v3, 0x2

    const/4 v4, 0x3

    const/16 v5, 0x65

    if-eqz p1, :cond_3

    .line 173
    iput v0, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->errorCode:I

    if-eqz p3, :cond_1

    const/4 v0, 0x4

    .line 175
    iput v0, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->sendResult:I

    :cond_0
    :goto_0
    move-object v0, p0

    goto :goto_3

    :cond_1
    if-ne v0, v5, :cond_2

    .line 177
    iput v4, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->sendResult:I

    goto :goto_0

    :cond_2
    if-eqz v0, :cond_0

    .line 179
    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->sendResult:I

    goto :goto_0

    :cond_3
    if-ne v0, v5, :cond_4

    .line 184
    iput v4, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->sendResult:I

    goto :goto_1

    :cond_4
    if-eqz v0, :cond_5

    .line 186
    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->sendResult:I

    .line 188
    :cond_5
    :goto_1
    iput v1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->errorCode:I

    const/16 v3, 0x64

    if-ne v0, v3, :cond_0

    const/4 v0, -0x1

    if-ne v1, v0, :cond_0

    if-eqz p2, :cond_6

    const/16 v0, 0x42

    goto :goto_2

    :cond_6
    const/16 v0, 0x14b

    .line 191
    :goto_2
    iput v0, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->errorCode:I

    goto :goto_0

    .line 194
    :goto_3
    iget-object v0, v0, Lcom/android/internal/telephony/metrics/SmsStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addOutgoingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;)V

    return-void
.end method

.method public onOutgoingSms(ZZZIJZJ)V
    .locals 11

    const/4 v5, -0x1

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move-wide/from16 v6, p5

    move/from16 v8, p7

    move-wide/from16 v9, p8

    .line 159
    invoke-virtual/range {v0 .. v10}, Lcom/android/internal/telephony/metrics/SmsStats;->onOutgoingSms(ZZZIIJZJ)V

    return-void
.end method
