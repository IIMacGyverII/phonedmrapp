.class public Lcom/android/internal/telephony/RadioBugDetector;
.super Ljava/lang/Object;
.source "RadioBugDetector.java"


# static fields
.field private static final DEFAULT_SYSTEM_ERROR_COUNT_THRESHOLD:I = 0x64

.field private static final DEFAULT_WAKELOCK_TIMEOUT_COUNT_THRESHOLD:I = 0xa

.field private static final RADIO_BUG_NONE:I = 0x0

.field protected static final RADIO_BUG_REPETITIVE_SYSTEM_ERROR:I = 0x2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final RADIO_BUG_REPETITIVE_WAKELOCK_TIMEOUT_ERROR:I = 0x1

.field private static final TAG:Ljava/lang/String; = "RadioBugDetector"


# instance fields
.field private mContext:Landroid/content/Context;

.field private mContinuousWakelockTimoutCount:I

.field private mRadioBugStatus:I

.field private mSlotId:I

.field private mSysErrRecord:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mSystemErrorThreshold:I

.field private mWakelockTimeoutThreshold:I


# direct methods
.method public constructor <init>(Landroid/content/Context;I)V
    .locals 1

    .line 64
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 55
    iput v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mContinuousWakelockTimoutCount:I

    .line 56
    iput v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mRadioBugStatus:I

    .line 58
    iput v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mWakelockTimeoutThreshold:I

    .line 59
    iput v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSystemErrorThreshold:I

    .line 61
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSysErrRecord:Ljava/util/HashMap;

    .line 65
    iput-object p1, p0, Lcom/android/internal/telephony/RadioBugDetector;->mContext:Landroid/content/Context;

    .line 66
    iput p2, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSlotId:I

    .line 67
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioBugDetector;->init()V

    return-void
.end method

.method private declared-synchronized broadcastBug(Z)V
    .locals 2

    monitor-enter p0

    if-eqz p1, :cond_0

    .line 121
    :try_start_0
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioBugDetector;->isFrequentSystemError()Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_1

    .line 122
    monitor-exit p0

    return-void

    .line 125
    :cond_0
    :try_start_1
    iget v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mContinuousWakelockTimoutCount:I

    iget v1, p0, Lcom/android/internal/telephony/RadioBugDetector;->mWakelockTimeoutThreshold:I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-ge v0, v1, :cond_1

    .line 126
    monitor-exit p0

    return-void

    .line 132
    :cond_1
    :try_start_2
    iget v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mRadioBugStatus:I

    if-nez v0, :cond_4

    if-eqz p1, :cond_2

    const/4 p1, 0x2

    goto :goto_0

    :cond_2
    const/4 p1, 0x1

    .line 134
    :goto_0
    iput p1, p0, Lcom/android/internal/telephony/RadioBugDetector;->mRadioBugStatus:I

    .line 135
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Repeated radio error "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mRadioBugStatus:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " on slot "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSlotId:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "RadioBugDetector"

    .line 136
    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 138
    iget v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSlotId:I

    invoke-static {v0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object v0

    if-nez v0, :cond_3

    const/4 v0, -0x1

    goto :goto_1

    .line 139
    :cond_3
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v0

    :goto_1
    const-string v1, "d264ead0-3f05-11ea-b77f-2e728ce88125"

    .line 142
    invoke-static {v1}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v1

    .line 141
    invoke-static {v1, p1, v0}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 145
    :cond_4
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private init()V
    .locals 3

    .line 71
    iget-object v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mContext:Landroid/content/Context;

    .line 72
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "radio_bug_wakelock_timeout_count_threshold"

    const/16 v2, 0xa

    .line 71
    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mWakelockTimeoutThreshold:I

    .line 75
    iget-object v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mContext:Landroid/content/Context;

    .line 76
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "radio_bug_system_error_count_threshold"

    const/16 v2, 0x64

    .line 75
    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSystemErrorThreshold:I

    return-void
.end method

.method private isFrequentSystemError()Z
    .locals 4

    .line 150
    iget-object v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSysErrRecord:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v1, 0x0

    move v2, v1

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    add-int/2addr v2, v3

    .line 152
    iget v3, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSystemErrorThreshold:I

    if-lt v2, v3, :cond_0

    const/4 v1, 0x1

    :cond_1
    return v1
.end method


# virtual methods
.method public declared-synchronized detectRadioBug(II)V
    .locals 2

    monitor-enter p0

    const/4 v0, 0x0

    .line 95
    :try_start_0
    iput v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mContinuousWakelockTimoutCount:I

    const/16 v1, 0x27

    if-ne p2, v1, :cond_0

    .line 97
    iget-object p2, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSysErrRecord:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {p2, v1, v0}, Ljava/util/HashMap;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    const/4 v0, 0x1

    add-int/2addr p2, v0

    .line 99
    iget-object v1, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSysErrRecord:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {v1, p1, p2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 100
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/RadioBugDetector;->broadcastBug(Z)V

    goto :goto_0

    .line 103
    :cond_0
    iget-object p2, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSysErrRecord:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 104
    invoke-direct {p0}, Lcom/android/internal/telephony/RadioBugDetector;->isFrequentSystemError()Z

    move-result p1

    if-nez p1, :cond_1

    .line 105
    iput v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mRadioBugStatus:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 108
    :cond_1
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public getRadioBugStatus()I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 162
    iget p0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mRadioBugStatus:I

    return p0
.end method

.method public getSystemErrorThreshold()I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 172
    iget p0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mSystemErrorThreshold:I

    return p0
.end method

.method public getWakelockTimeoutThreshold()I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 167
    iget p0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mWakelockTimeoutThreshold:I

    return p0
.end method

.method public getWakelockTimoutCount()I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 177
    iget p0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mContinuousWakelockTimoutCount:I

    return p0
.end method

.method public processWakelockTimeout()V
    .locals 1

    .line 115
    iget v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mContinuousWakelockTimoutCount:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/android/internal/telephony/RadioBugDetector;->mContinuousWakelockTimoutCount:I

    const/4 v0, 0x0

    .line 116
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/RadioBugDetector;->broadcastBug(Z)V

    return-void
.end method
