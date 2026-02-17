.class public Lcom/android/internal/telephony/metrics/ServiceStateStats;
.super Ljava/lang/Object;
.source "ServiceStateStats.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "ServiceStateStats"


# instance fields
.field private final mLastState:Ljava/util/concurrent/atomic/AtomicReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/atomic/AtomicReference<",
            "Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;",
            ">;"
        }
    .end annotation
.end field

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;


# direct methods
.method public static synthetic $r8$lambda$S5R0teoz3MA4LKEGoFOnkzr82PM(Lcom/android/internal/telephony/metrics/ServiceStateStats;JLcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->lambda$onImsVoiceRegistrationChanged$1(JLcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$mvaWOusOpVIC_oCumIqAMc64XFg(JLcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->lambda$conclude$0(JLcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    move-result-object p0

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 5

    .line 48
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 43
    new-instance v0, Ljava/util/concurrent/atomic/AtomicReference;

    new-instance v1, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    const/4 v2, 0x0

    const-wide/16 v3, 0x0

    invoke-direct {v1, v2, v3, v4}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;-><init>(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;J)V

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mLastState:Ljava/util/concurrent/atomic/AtomicReference;

    .line 49
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 50
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getMetricsCollector()Lcom/android/internal/telephony/metrics/MetricsCollector;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getAtomsStorage()Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    return-void
.end method

.method private addServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;J)V
    .locals 1

    const/4 v0, 0x0

    .line 105
    invoke-direct {p0, p1, p2, p3, v0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->addServiceStateAndSwitch(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;JLcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V

    return-void
.end method

.method private addServiceStateAndSwitch(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;JLcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V
    .locals 3

    .line 112
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->-$$Nest$fgetmServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    .line 116
    :cond_0
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->-$$Nest$fgetmTimestamp(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)J

    move-result-wide v0

    cmp-long v0, p2, v0

    if-ltz v0, :cond_1

    .line 117
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->-$$Nest$fgetmServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->copyOf(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object v0

    .line 118
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->-$$Nest$fgetmTimestamp(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)J

    move-result-wide v1

    sub-long/2addr p2, v1

    iput-wide p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->totalTimeMillis:J

    .line 119
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {p0, v0, p4}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addCellularServiceStateAndCellularDataServiceSwitch(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V

    goto :goto_0

    .line 121
    :cond_1
    sget-object p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->TAG:Ljava/lang/String;

    const-string p1, "addServiceState: durationMillis<0"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method private static copyOf(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;
    .locals 3

    .line 206
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;-><init>()V

    .line 207
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRat:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRat:I

    .line 208
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    .line 209
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRoamingType:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRoamingType:I

    .line 210
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRoamingType:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRoamingType:I

    .line 211
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEndc:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEndc:Z

    .line 212
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->simSlotIndex:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->simSlotIndex:I

    .line 213
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isMultiSim:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isMultiSim:Z

    .line 214
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->carrierId:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->carrierId:I

    .line 215
    iget-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->totalTimeMillis:J

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->totalTimeMillis:J

    .line 216
    iget-boolean p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEmergencyOnly:Z

    iput-boolean p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEmergencyOnly:Z

    return-object v0
.end method

.method static getBand(Landroid/telephony/ServiceState;)I
    .locals 5

    const/4 v0, 0x0

    if-nez p0, :cond_0

    .line 168
    sget-object p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->TAG:Ljava/lang/String;

    const-string v1, "getBand: serviceState=null"

    invoke-static {p0, v1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    .line 171
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getChannelNumber()I

    move-result v1

    .line 173
    invoke-static {p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getRat(Landroid/telephony/ServiceState;)I

    move-result p0

    const/4 v2, 0x1

    if-eq p0, v2, :cond_3

    const/4 v2, 0x2

    if-eq p0, v2, :cond_3

    const/4 v2, 0x3

    if-eq p0, v2, :cond_2

    const/16 v2, 0xd

    if-eq p0, v2, :cond_1

    const/16 v2, 0x13

    if-eq p0, v2, :cond_1

    const/16 v2, 0xf

    if-eq p0, v2, :cond_2

    const/16 v2, 0x10

    if-eq p0, v2, :cond_3

    packed-switch p0, :pswitch_data_0

    .line 192
    sget-object v2, Lcom/android/internal/telephony/metrics/ServiceStateStats;->TAG:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "getBand: unknown WWAN RAT "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    move v2, v0

    goto :goto_0

    .line 189
    :cond_1
    invoke-static {v1}, Landroid/telephony/AccessNetworkUtils;->getOperatingBandForEarfcn(I)I

    move-result v2

    goto :goto_0

    .line 185
    :cond_2
    :pswitch_0
    invoke-static {v1}, Landroid/telephony/AccessNetworkUtils;->getOperatingBandForUarfcn(I)I

    move-result v2

    goto :goto_0

    .line 178
    :cond_3
    invoke-static {v1}, Landroid/telephony/AccessNetworkUtils;->getOperatingBandForArfcn(I)I

    move-result v2

    :goto_0
    const/4 v3, -0x1

    if-ne v2, v3, :cond_4

    .line 197
    sget-object v2, Lcom/android/internal/telephony/metrics/ServiceStateStats;->TAG:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "getBand: band invalid for rat="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " ch="

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :cond_4
    return v2

    :pswitch_data_0
    .packed-switch 0x8
        :pswitch_0
        :pswitch_0
        :pswitch_0
    .end packed-switch
.end method

.method static getBand(Lcom/android/internal/telephony/Phone;)I
    .locals 0

    .line 158
    invoke-static {p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getServiceStateForPhone(Lcom/android/internal/telephony/Phone;)Landroid/telephony/ServiceState;

    move-result-object p0

    .line 159
    invoke-static {p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getBand(Landroid/telephony/ServiceState;)I

    move-result p0

    return p0
.end method

.method static getDataRat(Landroid/telephony/ServiceState;)I
    .locals 2

    const/4 v0, 0x2

    const/4 v1, 0x1

    .line 277
    invoke-virtual {p0, v0, v1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 280
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 281
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private getDataServiceSwitch(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;
    .locals 1

    if-eqz p1, :cond_0

    .line 129
    iget-boolean p0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isMultiSim:Z

    iget-boolean v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isMultiSim:Z

    if-ne p0, v0, :cond_0

    iget p0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->carrierId:I

    iget v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->carrierId:I

    if-ne p0, v0, :cond_0

    iget p0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    iget v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    if-eq p0, v0, :cond_0

    .line 133
    new-instance p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    invoke-direct {p0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;-><init>()V

    .line 134
    iget p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    iput p1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->ratFrom:I

    .line 135
    iget p1, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    iput p1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->ratTo:I

    .line 136
    iget-boolean p1, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isMultiSim:Z

    iput-boolean p1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->isMultiSim:Z

    .line 137
    iget p1, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->simSlotIndex:I

    iput p1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->simSlotIndex:I

    .line 138
    iget p1, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->carrierId:I

    iput p1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->carrierId:I

    const/4 p1, 0x1

    .line 139
    iput p1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->switchCount:I

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static getRat(Landroid/telephony/ServiceState;)I
    .locals 1

    .line 267
    invoke-static {p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getDataRat(Landroid/telephony/ServiceState;)I

    move-result v0

    if-nez v0, :cond_0

    .line 269
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getVoiceNetworkType()I

    move-result v0

    :cond_0
    return v0
.end method

.method private static getServiceStateForPhone(Lcom/android/internal/telephony/Phone;)Landroid/telephony/ServiceState;
    .locals 0

    .line 149
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 150
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method static getVoiceRat(Lcom/android/internal/telephony/Phone;Landroid/telephony/ServiceState;)I
    .locals 3

    const/4 v0, 0x0

    if-nez p1, :cond_0

    return v0

    .line 239
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/imsphone/ImsPhone;

    const/4 v1, 0x1

    if-eqz p0, :cond_4

    .line 241
    invoke-virtual {p0}, Lcom/android/internal/telephony/imsphone/ImsPhone;->getImsStats()Lcom/android/internal/telephony/metrics/ImsStats;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/ImsStats;->getImsVoiceRadioTech()I

    move-result p0

    if-eqz p0, :cond_4

    const/16 v2, 0x12

    if-eq p0, v2, :cond_2

    .line 246
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getDataRat(Landroid/telephony/ServiceState;)I

    move-result p1

    if-eqz p1, :cond_1

    goto :goto_0

    :cond_1
    move v1, v0

    :cond_2
    :goto_0
    if-eqz v1, :cond_3

    move v0, p0

    :cond_3
    return v0

    .line 253
    :cond_4
    invoke-virtual {p1, v1, v1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_5

    .line 256
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result p1

    if-eqz p1, :cond_5

    .line 257
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v0

    :cond_5
    return v0
.end method

.method private static isEmergencyOnly(Landroid/telephony/ServiceState;)Z
    .locals 2

    const/4 v0, 0x1

    .line 287
    invoke-virtual {p0, v0, v0}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 290
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->isEmergencyEnabled()Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private static isEndc(Landroid/telephony/ServiceState;)Z
    .locals 3

    .line 294
    invoke-static {p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getDataRat(Landroid/telephony/ServiceState;)I

    move-result v0

    const/4 v1, 0x0

    const/16 v2, 0xd

    if-eq v0, v2, :cond_0

    return v1

    .line 297
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getNrState()I

    move-result p0

    const/4 v0, 0x3

    if-eq p0, v0, :cond_1

    const/4 v0, 0x2

    if-ne p0, v0, :cond_2

    :cond_1
    const/4 v1, 0x1

    :cond_2
    return v1
.end method

.method private static isModemOff(Landroid/telephony/ServiceState;)Z
    .locals 1

    .line 228
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getVoiceRegState()I

    move-result p0

    const/4 v0, 0x3

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$conclude$0(JLcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;
    .locals 1

    .line 58
    new-instance v0, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    invoke-static {p2}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->-$$Nest$fgetmServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object p2

    invoke-direct {v0, p2, p0, p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;-><init>(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;J)V

    return-object v0
.end method

.method private synthetic lambda$onImsVoiceRegistrationChanged$1(JLcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;
    .locals 1

    .line 68
    invoke-static {p3}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->-$$Nest$fgetmServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object v0

    if-nez v0, :cond_0

    .line 69
    new-instance p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    const/4 p3, 0x0

    invoke-direct {p0, p3, p1, p2}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;-><init>(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;J)V

    return-object p0

    .line 71
    :cond_0
    invoke-static {p3}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->-$$Nest$fgetmServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object p3

    invoke-static {p3}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->copyOf(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object p3

    .line 72
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 73
    invoke-static {p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getServiceStateForPhone(Lcom/android/internal/telephony/Phone;)Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getVoiceRat(Lcom/android/internal/telephony/Phone;Landroid/telephony/ServiceState;)I

    move-result p0

    iput p0, p3, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRat:I

    .line 74
    new-instance p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    invoke-direct {p0, p3, p1, p2}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;-><init>(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;J)V

    return-object p0
.end method


# virtual methods
.method public conclude()V
    .locals 4

    .line 55
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getTimeMillis()J

    move-result-wide v0

    .line 56
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mLastState:Ljava/util/concurrent/atomic/AtomicReference;

    new-instance v3, Lcom/android/internal/telephony/metrics/ServiceStateStats$$ExternalSyntheticLambda1;

    invoke-direct {v3, v0, v1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$$ExternalSyntheticLambda1;-><init>(J)V

    .line 57
    invoke-virtual {v2, v3}, Ljava/util/concurrent/atomic/AtomicReference;->getAndUpdate(Ljava/util/function/UnaryOperator;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    .line 59
    invoke-direct {p0, v2, v0, v1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->addServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;J)V

    return-void
.end method

.method protected getTimeMillis()J
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 304
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    return-wide v0
.end method

.method public onImsVoiceRegistrationChanged()V
    .locals 4

    .line 64
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getTimeMillis()J

    move-result-wide v0

    .line 65
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mLastState:Ljava/util/concurrent/atomic/AtomicReference;

    new-instance v3, Lcom/android/internal/telephony/metrics/ServiceStateStats$$ExternalSyntheticLambda0;

    invoke-direct {v3, p0, v0, v1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/metrics/ServiceStateStats;J)V

    .line 66
    invoke-virtual {v2, v3}, Ljava/util/concurrent/atomic/AtomicReference;->getAndUpdate(Ljava/util/function/UnaryOperator;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    .line 76
    invoke-direct {p0, v2, v0, v1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->addServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;J)V

    return-void
.end method

.method public onServiceStateChanged(Landroid/telephony/ServiceState;)V
    .locals 4

    .line 81
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getTimeMillis()J

    move-result-wide v0

    .line 82
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->isModemOff(Landroid/telephony/ServiceState;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 84
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mLastState:Ljava/util/concurrent/atomic/AtomicReference;

    new-instance v2, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    const/4 v3, 0x0

    invoke-direct {v2, v3, v0, v1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;-><init>(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;J)V

    invoke-virtual {p1, v2}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    invoke-direct {p0, p1, v0, v1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->addServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;J)V

    goto :goto_0

    .line 86
    :cond_0
    new-instance v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    invoke-direct {v2}, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;-><init>()V

    .line 87
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v3, p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getVoiceRat(Lcom/android/internal/telephony/Phone;Landroid/telephony/ServiceState;)I

    move-result v3

    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRat:I

    .line 88
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getDataRat(Landroid/telephony/ServiceState;)I

    move-result v3

    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    .line 89
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getVoiceRoamingType()I

    move-result v3

    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRoamingType:I

    .line 90
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getDataRoamingType()I

    move-result v3

    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRoamingType:I

    .line 91
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->isEndc(Landroid/telephony/ServiceState;)Z

    move-result v3

    iput-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEndc:Z

    .line 92
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->simSlotIndex:I

    .line 93
    invoke-static {}, Lcom/android/internal/telephony/metrics/SimSlotState;->isMultiSim()Z

    move-result v3

    iput-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isMultiSim:Z

    .line 94
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v3

    iput v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->carrierId:I

    .line 95
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->isEmergencyOnly(Landroid/telephony/ServiceState;)Z

    move-result p1

    iput-boolean p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEmergencyOnly:Z

    .line 97
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats;->mLastState:Ljava/util/concurrent/atomic/AtomicReference;

    new-instance v3, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    invoke-direct {v3, v2, v0, v1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;-><init>(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;J)V

    .line 98
    invoke-virtual {p1, v3}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;

    .line 99
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->-$$Nest$fgetmServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object v3

    .line 100
    invoke-direct {p0, v3, v2}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getDataServiceSwitch(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    move-result-object v2

    .line 99
    invoke-direct {p0, p1, v0, v1, v2}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->addServiceStateAndSwitch(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;JLcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V

    :goto_0
    return-void
.end method
