.class public Lcom/android/internal/telephony/metrics/DataCallSessionStats;
.super Ljava/lang/Object;
.source "DataCallSessionStats.java"


# static fields
.field private static final RANDOM:Ljava/util/Random;

.field private static final SIZE_LIMIT_HANDOVER_FAILURE_CAUSES:I = 0xf

.field private static final TAG:Ljava/lang/String; = "DataCallSessionStats"


# instance fields
.field private final mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

.field private mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private mStartTime:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 61
    new-instance v0, Ljava/util/Random;

    invoke-direct {v0}, Ljava/util/Random;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->RANDOM:Ljava/util/Random;

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 1

    .line 63
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 59
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getMetricsCollector()Lcom/android/internal/telephony/metrics/MetricsCollector;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getAtomsStorage()Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    .line 64
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    return-void
.end method

.method private static convertMillisToMinutes(J)J
    .locals 2

    long-to-double p0, p0

    const-wide v0, 0x40ed4c0000000000L    # 60000.0

    div-double/2addr p0, v0

    .line 243
    invoke-static {p0, p1}, Ljava/lang/Math;->round(D)J

    move-result-wide p0

    return-wide p0
.end method

.method private static copyOf(Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;
    .locals 3

    .line 247
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;-><init>()V

    .line 248
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->dimension:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->dimension:I

    .line 249
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isMultiSim:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isMultiSim:Z

    .line 250
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isEsim:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isEsim:Z

    .line 251
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->apnTypeBitmask:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->apnTypeBitmask:I

    .line 252
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->carrierId:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->carrierId:I

    .line 253
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isRoaming:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isRoaming:Z

    .line 254
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratAtEnd:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratAtEnd:I

    .line 255
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->oosAtEnd:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->oosAtEnd:Z

    .line 256
    iget-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    .line 257
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isOpportunistic:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isOpportunistic:Z

    .line 258
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ipType:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ipType:I

    .line 259
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->setupFailed:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->setupFailed:Z

    .line 260
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->failureCause:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->failureCause:I

    .line 261
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->suggestedRetryMillis:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->suggestedRetryMillis:I

    .line 262
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->deactivateReason:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->deactivateReason:I

    .line 263
    iget-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->durationMinutes:J

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->durationMinutes:J

    .line 264
    iget-boolean v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ongoing:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ongoing:Z

    .line 265
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->bandAtEnd:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->bandAtEnd:I

    .line 266
    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->handoverFailureCauses:[I

    array-length v1, p0

    invoke-static {p0, v1}, Ljava/util/Arrays;->copyOf([II)[I

    move-result-object p0

    iput-object p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->handoverFailureCauses:[I

    return-object v0
.end method

.method private endDataCallSession()V
    .locals 2

    .line 233
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->getIsOos()Z

    move-result v1

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->oosAtEnd:Z

    .line 234
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ongoing:Z

    .line 237
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getMetricsCollector()Lcom/android/internal/telephony/metrics/MetricsCollector;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->unregisterOngoingDataCallStat(Lcom/android/internal/telephony/metrics/DataCallSessionStats;)V

    .line 238
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addDataCallSession(Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)V

    const/4 v0, 0x0

    .line 239
    iput-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    return-void
.end method

.method private getDefaultProto(I)Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;
    .locals 3

    .line 273
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;-><init>()V

    .line 274
    sget-object v1, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->RANDOM:Ljava/util/Random;

    invoke-virtual {v1}, Ljava/util/Random;->nextInt()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->dimension:I

    .line 275
    invoke-static {}, Lcom/android/internal/telephony/metrics/SimSlotState;->isMultiSim()Z

    move-result v1

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isMultiSim:Z

    .line 276
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/SimSlotState;->isEsim(I)Z

    move-result v1

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isEsim:Z

    .line 277
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->apnTypeBitmask:I

    .line 278
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result p1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->carrierId:I

    .line 279
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->getIsRoaming()Z

    move-result p1

    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isRoaming:Z

    const/4 p1, 0x0

    .line 280
    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->oosAtEnd:Z

    const-wide/16 v1, 0x0

    .line 281
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    .line 282
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->getIsOpportunistic()Z

    move-result p0

    iput-boolean p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isOpportunistic:Z

    .line 283
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ipType:I

    .line 284
    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->setupFailed:Z

    .line 285
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->failureCause:I

    .line 286
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->suggestedRetryMillis:I

    .line 287
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->deactivateReason:I

    .line 288
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->durationMinutes:J

    const/4 p0, 0x1

    .line 289
    iput-boolean p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ongoing:Z

    new-array p0, p1, [I

    .line 290
    iput-object p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->handoverFailureCauses:[I

    return-object v0
.end method

.method private getIsOos()Z
    .locals 2

    .line 307
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 309
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    const/4 v0, 0x1

    const/4 v1, 0x0

    if-eqz p0, :cond_1

    .line 311
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result p0

    if-ne p0, v0, :cond_1

    goto :goto_1

    :cond_1
    move v0, v1

    :goto_1
    return v0
.end method

.method private getIsOpportunistic()Z
    .locals 1

    .line 302
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 303
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/SubscriptionController;->isOpportunistic(I)Z

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private getIsRoaming()Z
    .locals 0

    .line 295
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 297
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    if-eqz p0, :cond_1

    .line 298
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getRoaming()Z

    move-result p0

    goto :goto_1

    :cond_1
    const/4 p0, 0x0

    :goto_1
    return p0
.end method

.method private varargs loge(Ljava/lang/String;[Ljava/lang/Object;)V
    .locals 3

    .line 320
    sget-object v0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "["

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

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

.method private varargs logi(Ljava/lang/String;[Ljava/lang/Object;)V
    .locals 3

    .line 316
    sget-object v0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "["

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

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

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public declared-synchronized conclude()V
    .locals 5

    monitor-enter p0

    .line 220
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    if-eqz v0, :cond_0

    .line 221
    invoke-static {v0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->copyOf(Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    move-result-object v0

    .line 222
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->getTimeMillis()J

    move-result-wide v1

    .line 223
    iget-wide v3, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mStartTime:J

    sub-long v3, v1, v3

    invoke-static {v3, v4}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->convertMillisToMinutes(J)J

    move-result-wide v3

    iput-wide v3, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->durationMinutes:J

    .line 224
    iput-wide v1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mStartTime:J

    .line 225
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    const-wide/16 v2, 0x0

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    const/4 v2, 0x0

    new-array v2, v2, [I

    .line 226
    iput-object v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->handoverFailureCauses:[I

    .line 227
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mAtomsStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->addDataCallSession(Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 229
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method protected getTimeMillis()J
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 325
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    return-wide v0
.end method

.method public declared-synchronized onDataCallDisconnected(I)V
    .locals 5

    monitor-enter p0

    .line 163
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    if-nez v0, :cond_0

    const-string p1, "onDataCallDisconnected: no DataCallSession atom has been initiated."

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/Object;

    .line 164
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->logi(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 165
    monitor-exit p0

    return-void

    .line 167
    :cond_0
    :try_start_1
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->failureCause:I

    .line 168
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->getTimeMillis()J

    move-result-wide v1

    iget-wide v3, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mStartTime:J

    sub-long/2addr v1, v3

    invoke-static {v1, v2}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->convertMillisToMinutes(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->durationMinutes:J

    .line 169
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->endDataCallSession()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 170
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onDrsOrRatChanged(I)V
    .locals 5

    monitor-enter p0

    .line 199
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    if-eqz v0, :cond_2

    if-eqz p1, :cond_2

    .line 200
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratAtEnd:I

    if-eq v1, p1, :cond_0

    .line 201
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    .line 202
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratAtEnd:I

    :cond_0
    const/16 v1, 0x12

    if-ne p1, v1, :cond_1

    const/4 p1, 0x0

    goto :goto_0

    .line 208
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getBand(Lcom/android/internal/telephony/Phone;)I

    move-result p1

    :goto_0
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->bandAtEnd:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 210
    :cond_2
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onHandoverFailure(I)V
    .locals 4

    monitor-enter p0

    .line 179
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    if-eqz v0, :cond_2

    iget-object v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->handoverFailureCauses:[I

    array-length v1, v0

    const/16 v2, 0xf

    if-ge v1, v2, :cond_2

    .line 183
    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget v3, v0, v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-ne p1, v3, :cond_0

    .line 184
    monitor-exit p0

    return-void

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 186
    :cond_1
    :try_start_1
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    array-length v2, v0

    add-int/lit8 v2, v2, 0x1

    invoke-static {v0, v2}, Ljava/util/Arrays;->copyOf([II)[I

    move-result-object v2

    iput-object v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->handoverFailureCauses:[I

    .line 188
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    iget-object v1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->handoverFailureCauses:[I

    array-length v0, v0

    aput p1, v1, v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 190
    :cond_2
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onSetupDataCall(I)V
    .locals 2

    monitor-enter p0

    .line 69
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->getDefaultProto(I)Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    .line 70
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->getTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mStartTime:J

    .line 71
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getMetricsCollector()Lcom/android/internal/telephony/metrics/MetricsCollector;

    move-result-object p1

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerOngoingDataCallStat(Lcom/android/internal/telephony/metrics/DataCallSessionStats;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 72
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized onSetupDataCallResponse(Landroid/telephony/data/DataCallResponse;IIII)V
    .locals 3

    monitor-enter p0

    .line 91
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    const-string p1, "onSetupDataCallResponse: no DataCallSession atom has been initiated."

    new-array p2, v1, [Ljava/lang/Object;

    .line 92
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 93
    monitor-exit p0

    return-void

    :cond_0
    if-eqz p2, :cond_2

    .line 97
    :try_start_1
    iput p2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratAtEnd:I

    const/16 v2, 0x12

    if-ne p2, v2, :cond_1

    goto :goto_0

    .line 101
    :cond_1
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {p2}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getBand(Lcom/android/internal/telephony/Phone;)I

    move-result v1

    :goto_0
    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->bandAtEnd:I

    .line 105
    :cond_2
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    iget v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->apnTypeBitmask:I

    if-nez v0, :cond_3

    .line 106
    iput p3, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->apnTypeBitmask:I

    .line 109
    :cond_3
    iput p4, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ipType:I

    .line 110
    iput p5, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->failureCause:I

    if-eqz p1, :cond_4

    .line 113
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getRetryDurationMillis()J

    move-result-wide p3

    const-wide/32 v0, 0x7fffffff

    invoke-static {p3, p4, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide p3

    long-to-int p1, p3

    iput p1, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->suggestedRetryMillis:I

    if-eqz p5, :cond_4

    .line 116
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    const/4 p2, 0x1

    iput-boolean p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->setupFailed:Z

    .line 117
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->endDataCallSession()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 120
    :cond_4
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized setDeactivateDataCallReason(I)V
    .locals 3

    monitor-enter p0

    .line 130
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->mDataCallSession:Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    const-string p1, "setDeactivateDataCallReason: no DataCallSession atom has been initiated."

    new-array v0, v1, [Ljava/lang/Object;

    .line 131
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->loge(Ljava/lang/String;[Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 132
    monitor-exit p0

    return-void

    :cond_0
    const/4 v2, 0x1

    if-eq p1, v2, :cond_3

    const/4 v2, 0x2

    if-eq p1, v2, :cond_2

    const/4 v2, 0x3

    if-eq p1, v2, :cond_1

    .line 148
    :try_start_1
    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->deactivateReason:I

    goto :goto_0

    .line 144
    :cond_1
    iput v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->deactivateReason:I

    goto :goto_0

    .line 140
    :cond_2
    iput v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->deactivateReason:I

    goto :goto_0

    .line 136
    :cond_3
    iput v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->deactivateReason:I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 152
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
