.class public Lcom/android/internal/telephony/metrics/TelephonyMetrics;
.super Ljava/lang/Object;
.source "TelephonyMetrics.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;
    }
.end annotation


# static fields
.field private static final DBG:Z = true

.field private static final MAX_COMPLETED_CALL_SESSIONS:I = 0x32

.field private static final MAX_COMPLETED_SMS_SESSIONS:I = 0x1f4

.field private static final MAX_TELEPHONY_EVENTS:I = 0x3e8

.field private static final SESSION_START_PRECISION_MINUTES:I = 0x5

.field private static final TAG:Ljava/lang/String; = "TelephonyMetrics"

.field private static final VDBG:Z = false

.field private static sInstance:Lcom/android/internal/telephony/metrics/TelephonyMetrics;


# instance fields
.field private final mBwEstStatsMapList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;",
            ">;>;"
        }
    .end annotation
.end field

.field private final mCompletedCallSessions:Ljava/util/Deque;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Deque<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;",
            ">;"
        }
    .end annotation
.end field

.field private final mCompletedSmsSessions:Ljava/util/Deque;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Deque<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;",
            ">;"
        }
    .end annotation
.end field

.field private mContext:Landroid/content/Context;

.field private final mInProgressCallSessions:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/metrics/InProgressCallSession;",
            ">;"
        }
    .end annotation
.end field

.field private final mInProgressSmsSessions:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/metrics/InProgressSmsSession;",
            ">;"
        }
    .end annotation
.end field

.field private final mLastActiveSubscriptionInfos:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;",
            ">;"
        }
    .end annotation
.end field

.field private final mLastCarrierId:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatching;",
            ">;"
        }
    .end annotation
.end field

.field private mLastEnabledModemBitmap:I

.field private final mLastImsCapabilities:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;",
            ">;"
        }
    .end annotation
.end field

.field private final mLastImsConnectionState:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;",
            ">;"
        }
    .end annotation
.end field

.field private final mLastNetworkCapabilitiesInfos:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$NetworkCapabilitiesInfo;",
            ">;"
        }
    .end annotation
.end field

.field private final mLastRadioState:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private final mLastRilDataCallEvents:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;",
            ">;>;"
        }
    .end annotation
.end field

.field private final mLastServiceState:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;",
            ">;"
        }
    .end annotation
.end field

.field private final mLastSettings:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;",
            ">;"
        }
    .end annotation
.end field

.field private final mLastSimState:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mStartElapsedTimeMs:J

.field private mStartSystemTimeMs:J

.field private final mTelephonyEvents:Ljava/util/Deque;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Deque<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;",
            ">;"
        }
    .end annotation
.end field

.field private mTelephonyEventsDropped:Z


# direct methods
.method public static synthetic $r8$lambda$7oose0tYhwPsBvAjTon9B60KcP0(I)[Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->lambda$writeCarrierIdMatchingEvent$2(I)[Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$_t3S7XJAGi2lGZbrrIqVHr7oKPg(I)[Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->lambda$convertEmergencyNumberToEmergencyNumberInfo$1(I)[Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$iokZKurxt-VqPCSqDMm-wUgsa-k(ILjava/lang/Integer;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->lambda$updateActiveSubscriptionInfoList$0(ILjava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 5

    .line 245
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 166
    new-instance v0, Ljava/util/ArrayDeque;

    invoke-direct {v0}, Ljava/util/ArrayDeque;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEvents:Ljava/util/Deque;

    .line 173
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    .line 176
    new-instance v0, Ljava/util/ArrayDeque;

    invoke-direct {v0}, Ljava/util/ArrayDeque;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedCallSessions:Ljava/util/Deque;

    .line 179
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressSmsSessions:Landroid/util/SparseArray;

    .line 182
    new-instance v0, Ljava/util/ArrayDeque;

    invoke-direct {v0}, Ljava/util/ArrayDeque;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedSmsSessions:Ljava/util/Deque;

    .line 185
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastServiceState:Landroid/util/SparseArray;

    .line 190
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsCapabilities:Landroid/util/SparseArray;

    .line 196
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsConnectionState:Landroid/util/SparseArray;

    .line 199
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSettings:Landroid/util/SparseArray;

    .line 202
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSimState:Landroid/util/SparseArray;

    .line 205
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRadioState:Landroid/util/SparseArray;

    .line 208
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    .line 217
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getPhoneCount()I

    move-result v0

    const/4 v1, 0x1

    shl-int v0, v1, v0

    sub-int/2addr v0, v1

    iput v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastEnabledModemBitmap:I

    .line 220
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastCarrierId:Landroid/util/SparseArray;

    .line 223
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastNetworkCapabilitiesInfos:Landroid/util/SparseArray;

    .line 227
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    .line 231
    new-instance v0, Ljava/util/ArrayList;

    const/4 v2, 0x2

    new-array v2, v2, [Landroid/util/ArrayMap;

    new-instance v3, Landroid/util/ArrayMap;

    invoke-direct {v3}, Landroid/util/ArrayMap;-><init>()V

    const/4 v4, 0x0

    aput-object v3, v2, v4

    new-instance v3, Landroid/util/ArrayMap;

    invoke-direct {v3}, Landroid/util/ArrayMap;-><init>()V

    aput-object v3, v2, v1

    .line 232
    invoke-static {v2}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mBwEstStatsMapList:Ljava/util/List;

    .line 241
    iput-boolean v4, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEventsDropped:Z

    .line 246
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartSystemTimeMs:J

    .line 247
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    return-void
.end method

.method private declared-synchronized addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V
    .locals 2

    monitor-enter p0

    .line 1202
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEvents:Ljava/util/Deque;

    invoke-interface {v0}, Ljava/util/Deque;->size()I

    move-result v0

    const/16 v1, 0x3e8

    if-lt v0, v1, :cond_0

    .line 1203
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEvents:Ljava/util/Deque;

    invoke-interface {v0}, Ljava/util/Deque;->removeFirst()Ljava/lang/Object;

    const/4 v0, 0x1

    .line 1204
    iput-boolean v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEventsDropped:Z

    .line 1206
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEvents:Ljava/util/Deque;

    invoke-interface {v0, p1}, Ljava/util/Deque;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1207
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized annotateInProgressCallSession(JILcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V
    .locals 1

    monitor-enter p0

    .line 1037
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-eqz p3, :cond_0

    .line 1039
    invoke-virtual {p3, p1, p2, p4}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(JLcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1041
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized annotateInProgressSmsSession(JILcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V
    .locals 1

    monitor-enter p0

    .line 1052
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressSmsSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    if-eqz p3, :cond_0

    .line 1054
    invoke-virtual {p3, p1, p2, p4}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(JLcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1056
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private buildBandwidthEstimatorStats()Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats;
    .locals 4

    .line 2986
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats;-><init>()V

    .line 2988
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mBwEstStatsMapList:Ljava/util/List;

    const/4 v2, 0x0

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeBandwidthEstimatorStatsRatList(Ljava/util/Map;)Ljava/util/List;

    move-result-object v1

    new-array v3, v2, [Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;

    .line 2989
    invoke-interface {v1, v3}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats;->perRatTx:[Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;

    .line 2990
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mBwEstStatsMapList:Ljava/util/List;

    const/4 v3, 0x1

    invoke-interface {v1, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeBandwidthEstimatorStatsRatList(Ljava/util/Map;)Ljava/util/List;

    move-result-object p0

    new-array v1, v2, [Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;

    .line 2991
    invoke-interface {p0, v1}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;

    iput-object p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats;->perRatRx:[Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;

    return-object v0
.end method

.method private declared-synchronized buildProto()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;
    .locals 7

    monitor-enter p0

    .line 763
    :try_start_0
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;-><init>()V

    .line 765
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEvents:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->size()I

    move-result v1

    new-array v1, v1, [Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->events:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    .line 766
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEvents:Ljava/util/Deque;

    invoke-interface {v2, v1}, Ljava/util/Deque;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    .line 767
    iget-boolean v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEventsDropped:Z

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->eventsDropped:Z

    .line 770
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedCallSessions:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->size()I

    move-result v1

    new-array v1, v1, [Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->callSessions:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;

    .line 771
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedCallSessions:Ljava/util/Deque;

    invoke-interface {v2, v1}, Ljava/util/Deque;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    .line 774
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedSmsSessions:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->size()I

    move-result v1

    new-array v1, v1, [Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->smsSessions:[Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;

    .line 775
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedSmsSessions:Ljava/util/Deque;

    invoke-interface {v2, v1}, Ljava/util/Deque;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    .line 778
    invoke-static {}, Lcom/android/internal/telephony/RIL;->getTelephonyRILTimingHistograms()Ljava/util/List;

    move-result-object v1

    .line 779
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v2

    new-array v2, v2, [Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;

    iput-object v2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->histograms:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;

    const/4 v2, 0x0

    move v3, v2

    .line 780
    :goto_0
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v4

    if-ge v3, v4, :cond_0

    .line 781
    iget-object v4, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->histograms:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;

    new-instance v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;

    invoke-direct {v5}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;-><init>()V

    aput-object v5, v4, v3

    .line 782
    invoke-interface {v1, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/telephony/TelephonyHistogram;

    .line 783
    iget-object v5, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->histograms:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;

    aget-object v5, v5, v3

    .line 785
    invoke-virtual {v4}, Landroid/telephony/TelephonyHistogram;->getCategory()I

    move-result v6

    iput v6, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;->category:I

    .line 786
    invoke-virtual {v4}, Landroid/telephony/TelephonyHistogram;->getId()I

    move-result v6

    iput v6, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;->id:I

    .line 787
    invoke-virtual {v4}, Landroid/telephony/TelephonyHistogram;->getMinTime()I

    move-result v6

    iput v6, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;->minTimeMillis:I

    .line 788
    invoke-virtual {v4}, Landroid/telephony/TelephonyHistogram;->getMaxTime()I

    move-result v6

    iput v6, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;->maxTimeMillis:I

    .line 789
    invoke-virtual {v4}, Landroid/telephony/TelephonyHistogram;->getAverageTime()I

    move-result v6

    iput v6, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;->avgTimeMillis:I

    .line 790
    invoke-virtual {v4}, Landroid/telephony/TelephonyHistogram;->getSampleCount()I

    move-result v6

    iput v6, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;->count:I

    .line 791
    invoke-virtual {v4}, Landroid/telephony/TelephonyHistogram;->getBucketCount()I

    move-result v6

    iput v6, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;->bucketCount:I

    .line 792
    invoke-virtual {v4}, Landroid/telephony/TelephonyHistogram;->getBucketEndPoints()[I

    move-result-object v6

    iput-object v6, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;->bucketEndPoints:[I

    .line 793
    invoke-virtual {v4}, Landroid/telephony/TelephonyHistogram;->getBucketCounters()[I

    move-result-object v4

    iput-object v4, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyHistogram;->bucketCounters:[I

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 797
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mContext:Landroid/content/Context;

    if-nez v1, :cond_1

    const/4 v1, 0x0

    goto :goto_1

    :cond_1
    const-string v3, "batterystats"

    .line 798
    invoke-virtual {v1, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/BatteryStatsManager;

    .line 799
    :goto_1
    new-instance v3, Lcom/android/internal/telephony/metrics/ModemPowerMetrics;

    invoke-direct {v3, v1}, Lcom/android/internal/telephony/metrics/ModemPowerMetrics;-><init>(Landroid/os/BatteryStatsManager;)V

    invoke-virtual {v3}, Lcom/android/internal/telephony/metrics/ModemPowerMetrics;->buildProto()Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->modemPowerStats:Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;

    const-string v1, "ro.boot.revision"

    const-string v3, ""

    .line 802
    invoke-static {v1, v3}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->hardwareRevision:Ljava/lang/String;

    .line 805
    new-instance v1, Lcom/android/internal/telephony/nano/TelephonyProto$Time;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/TelephonyProto$Time;-><init>()V

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->startTime:Lcom/android/internal/telephony/nano/TelephonyProto$Time;

    .line 806
    iget-wide v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartSystemTimeMs:J

    iput-wide v3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$Time;->systemTimestampMillis:J

    .line 807
    iget-wide v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    iput-wide v3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$Time;->elapsedTimestampMillis:J

    .line 809
    new-instance v1, Lcom/android/internal/telephony/nano/TelephonyProto$Time;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/TelephonyProto$Time;-><init>()V

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->endTime:Lcom/android/internal/telephony/nano/TelephonyProto$Time;

    .line 810
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    iput-wide v3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$Time;->systemTimestampMillis:J

    .line 811
    iget-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->endTime:Lcom/android/internal/telephony/nano/TelephonyProto$Time;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v3

    iput-wide v3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$Time;->elapsedTimestampMillis:J

    .line 814
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/TelephonyManager;->getPhoneCount()I

    move-result v1

    .line 815
    new-array v3, v1, [Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;

    move v4, v2

    .line 817
    :goto_2
    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    invoke-virtual {v5}, Landroid/util/SparseArray;->size()I

    move-result v5

    if-ge v4, v5, :cond_2

    .line 818
    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    invoke-virtual {v5, v4}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v5

    .line 819
    iget-object v6, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    invoke-virtual {v6, v5}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;

    aput-object v6, v3, v5

    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    :cond_2
    :goto_3
    if-ge v2, v1, :cond_4

    .line 822
    aget-object v4, v3, v2

    if-nez v4, :cond_3

    .line 823
    invoke-static {v2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->makeInvalidSubscriptionInfo(I)Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;

    move-result-object v4

    aput-object v4, v3, v2

    :cond_3
    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    .line 826
    :cond_4
    iput-object v3, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->lastActiveSubscriptionInfo:[Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;

    .line 827
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->buildBandwidthEstimatorStats()Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;->bandwidthEstimatorStats:Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 828
    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method private static callQualityLevelToProtoEnum(I)I
    .locals 2

    const/4 v0, 0x1

    if-nez p0, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x2

    if-ne p0, v0, :cond_1

    return v1

    :cond_1
    const/4 v0, 0x3

    if-ne p0, v1, :cond_2

    return v0

    :cond_2
    const/4 v1, 0x4

    if-ne p0, v0, :cond_3

    return v1

    :cond_3
    const/4 v0, 0x5

    if-ne p0, v1, :cond_4

    return v0

    :cond_4
    if-ne p0, v0, :cond_5

    const/4 p0, 0x6

    return p0

    :cond_5
    const/4 p0, 0x0

    return p0
.end method

.method private static callSessionEventToString(I)Ljava/lang/String;
    .locals 0

    packed-switch p0, :pswitch_data_0

    .line 412
    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :pswitch_0
    const-string p0, "AUDIO_CODEC"

    return-object p0

    :pswitch_1
    const-string p0, "NITZ_TIME"

    return-object p0

    :pswitch_2
    const-string p0, "PHONE_STATE_CHANGED"

    return-object p0

    :pswitch_3
    const-string p0, "IMS_CALL_HANDOVER_FAILED"

    return-object p0

    :pswitch_4
    const-string p0, "IMS_CALL_HANDOVER"

    return-object p0

    :pswitch_5
    const-string p0, "IMS_CALL_TERMINATED"

    return-object p0

    :pswitch_6
    const-string p0, "IMS_CALL_STATE_CHANGED"

    return-object p0

    :pswitch_7
    const-string p0, "IMS_CALL_RECEIVE"

    return-object p0

    :pswitch_8
    const-string p0, "IMS_COMMAND_COMPLETE"

    return-object p0

    :pswitch_9
    const-string p0, "IMS_COMMAND_FAILED"

    return-object p0

    :pswitch_a
    const-string p0, "IMS_COMMAND_RECEIVED"

    return-object p0

    :pswitch_b
    const-string p0, "IMS_COMMAND"

    return-object p0

    :pswitch_c
    const-string p0, "RIL_CALL_LIST_CHANGED"

    return-object p0

    :pswitch_d
    const-string p0, "RIL_CALL_SRVCC"

    return-object p0

    :pswitch_e
    const-string p0, "RIL_CALL_RING"

    return-object p0

    :pswitch_f
    const-string p0, "RIL_RESPONSE"

    return-object p0

    :pswitch_10
    const-string p0, "RIL_REQUEST"

    return-object p0

    :pswitch_11
    const-string p0, "DATA_CALL_LIST_CHANGED"

    return-object p0

    :pswitch_12
    const-string p0, "IMS_CAPABILITIES_CHANGED"

    return-object p0

    :pswitch_13
    const-string p0, "IMS_CONNECTION_STATE_CHANGED"

    return-object p0

    :pswitch_14
    const-string p0, "RIL_SERVICE_STATE_CHANGED"

    return-object p0

    :pswitch_15
    const-string p0, "SETTINGS_CHANGED"

    return-object p0

    :pswitch_16
    const-string p0, "EVENT_UNKNOWN"

    return-object p0

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_16
        :pswitch_15
        :pswitch_14
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private cloneCurrentTelephonySettings(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;
    .locals 1

    .line 1263
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;-><init>()V

    .line 1264
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSettings:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;

    if-eqz p0, :cond_0

    .line 1267
    iget p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->preferredNetworkMode:I

    iput p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->preferredNetworkMode:I

    .line 1268
    iget-boolean p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isEnhanced4GLteModeEnabled:Z

    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isEnhanced4GLteModeEnabled:Z

    .line 1269
    iget-boolean p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isVtOverLteEnabled:Z

    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isVtOverLteEnabled:Z

    .line 1270
    iget-boolean p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isWifiCallingEnabled:Z

    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isWifiCallingEnabled:Z

    .line 1271
    iget-boolean p0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isVtOverWifiEnabled:Z

    iput-boolean p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isVtOverWifiEnabled:Z

    :cond_0
    return-object v0
.end method

.method private convertConnectionToRilCall(Lcom/android/internal/telephony/GsmCdmaConnection;Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;Ljava/lang/String;)V
    .locals 5

    .line 1620
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->isIncoming()Z

    move-result v0

    const/4 v1, 0x2

    const/4 v2, 0x1

    if-eqz v0, :cond_0

    .line 1621
    iput v1, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->type:I

    goto :goto_0

    .line 1623
    :cond_0
    iput v2, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->type:I

    .line 1625
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$1;->$SwitchMap$com$android$internal$telephony$Call$State:[I

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaConnection;->getState()Lcom/android/internal/telephony/Call$State;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Enum;->ordinal()I

    move-result v3

    aget v0, v0, v3

    packed-switch v0, :pswitch_data_0

    const/4 v0, 0x0

    .line 1654
    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    goto :goto_1

    :pswitch_0
    const/16 v0, 0x9

    .line 1651
    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    goto :goto_1

    :pswitch_1
    const/16 v0, 0x8

    .line 1648
    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    goto :goto_1

    :pswitch_2
    const/4 v0, 0x7

    .line 1645
    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    goto :goto_1

    :pswitch_3
    const/4 v0, 0x6

    .line 1642
    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    goto :goto_1

    :pswitch_4
    const/4 v0, 0x5

    .line 1639
    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    goto :goto_1

    :pswitch_5
    const/4 v0, 0x4

    .line 1636
    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    goto :goto_1

    :pswitch_6
    const/4 v0, 0x3

    .line 1633
    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    goto :goto_1

    .line 1630
    :pswitch_7
    iput v1, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    goto :goto_1

    .line 1627
    :pswitch_8
    iput v2, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    .line 1657
    :goto_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getDisconnectCause()I

    move-result v0

    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->callEndReason:I

    .line 1658
    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaConnection;->isMultiparty()Z

    move-result v0

    iput-boolean v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->isMultiparty:Z

    .line 1659
    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaConnection;->getPreciseDisconnectCause()I

    move-result v0

    iput v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->preciseDisconnectCause:I

    .line 1662
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getDisconnectCause()I

    move-result v0

    if-eqz v0, :cond_2

    .line 1663
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->isEmergencyCall()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getEmergencyNumberInfo()Landroid/telephony/emergency/EmergencyNumber;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 1665
    invoke-static {}, Ljava/util/concurrent/ThreadLocalRandom;->current()Ljava/util/concurrent/ThreadLocalRandom;

    move-result-object v0

    const-wide/16 v1, 0x0

    const-wide/high16 v3, 0x4059000000000000L    # 100.0

    invoke-virtual {v0, v1, v2, v3, v4}, Ljava/util/concurrent/ThreadLocalRandom;->nextDouble(DD)D

    move-result-wide v0

    .line 1666
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getSamplePercentageForEmergencyCall(Ljava/lang/String;)D

    move-result-wide v2

    cmpg-double p3, v0, v2

    if-gez p3, :cond_2

    .line 1667
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->isEmergencyCall()Z

    move-result p3

    iput-boolean p3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->isEmergencyCall:Z

    .line 1669
    invoke-virtual {p1}, Lcom/android/internal/telephony/Connection;->getEmergencyNumberInfo()Landroid/telephony/emergency/EmergencyNumber;

    move-result-object p3

    .line 1668
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertEmergencyNumberToEmergencyNumberInfo(Landroid/telephony/emergency/EmergencyNumber;)Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    move-result-object p0

    iput-object p0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->emergencyNumberInfo:Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    .line 1670
    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaConnection;->getEmergencyNumberTracker()Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 1672
    invoke-virtual {p0}, Lcom/android/internal/telephony/emergency/EmergencyNumberTracker;->getEmergencyNumberDbVersion()I

    move-result p0

    goto :goto_2

    :cond_1
    const/4 p0, -0x1

    .line 1673
    :goto_2
    iput p0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->emergencyNumberDatabaseVersion:I

    :cond_2
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private convertConnectionsToRilCalls(Ljava/util/ArrayList;Ljava/lang/String;)[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/GsmCdmaConnection;",
            ">;",
            "Ljava/lang/String;",
            ")[",
            "Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;"
        }
    .end annotation

    .line 1597
    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result v0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;

    const/4 v1, 0x0

    .line 1598
    :goto_0
    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result v2

    if-ge v1, v2, :cond_0

    .line 1599
    new-instance v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;

    invoke-direct {v2}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;-><init>()V

    aput-object v2, v0, v1

    .line 1600
    iput v1, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->index:I

    .line 1601
    invoke-virtual {p1, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/GsmCdmaConnection;

    aget-object v3, v0, v1

    invoke-direct {p0, v2, v3, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertConnectionToRilCall(Lcom/android/internal/telephony/GsmCdmaConnection;Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;Ljava/lang/String;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method private convertEmergencyNumberToEmergencyNumberInfo(Landroid/telephony/emergency/EmergencyNumber;)Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;
    .locals 2

    .line 1607
    new-instance p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    invoke-direct {p0}, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;-><init>()V

    .line 1608
    invoke-virtual {p1}, Landroid/telephony/emergency/EmergencyNumber;->getNumber()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->address:Ljava/lang/String;

    .line 1609
    invoke-virtual {p1}, Landroid/telephony/emergency/EmergencyNumber;->getCountryIso()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->countryIso:Ljava/lang/String;

    .line 1610
    invoke-virtual {p1}, Landroid/telephony/emergency/EmergencyNumber;->getMnc()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->mnc:Ljava/lang/String;

    .line 1611
    invoke-virtual {p1}, Landroid/telephony/emergency/EmergencyNumber;->getEmergencyServiceCategoryBitmask()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->serviceCategoriesBitmask:I

    .line 1612
    invoke-virtual {p1}, Landroid/telephony/emergency/EmergencyNumber;->getEmergencyUrns()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/metrics/TelephonyMetrics$$ExternalSyntheticLambda1;

    invoke-direct {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$$ExternalSyntheticLambda1;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->toArray(Ljava/util/function/IntFunction;)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Ljava/lang/String;

    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->urns:[Ljava/lang/String;

    .line 1613
    invoke-virtual {p1}, Landroid/telephony/emergency/EmergencyNumber;->getEmergencyNumberSourceBitmask()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->numberSourcesBitmask:I

    .line 1614
    invoke-virtual {p1}, Landroid/telephony/emergency/EmergencyNumber;->getEmergencyCallRouting()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;->routing:I

    return-object p0
.end method

.method private convertGsmCdmaCodec(I)I
    .locals 0

    packed-switch p1, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/4 p0, 0x7

    return p0

    :pswitch_1
    const/4 p0, 0x6

    return p0

    :pswitch_2
    const/4 p0, 0x5

    return p0

    :pswitch_3
    const/4 p0, 0x4

    return p0

    :pswitch_4
    const/16 p0, 0xa

    return p0

    :pswitch_5
    const/16 p0, 0x9

    return p0

    :pswitch_6
    const/16 p0, 0x8

    return p0

    :pswitch_7
    const/4 p0, 0x2

    return p0

    :pswitch_8
    const/4 p0, 0x1

    return p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private static convertImsCodec(I)I
    .locals 0

    packed-switch p0, :pswitch_data_0

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/16 p0, 0x14

    return p0

    :pswitch_1
    const/16 p0, 0x13

    return p0

    :pswitch_2
    const/16 p0, 0x12

    return p0

    :pswitch_3
    const/16 p0, 0x11

    return p0

    :pswitch_4
    const/16 p0, 0x10

    return p0

    :pswitch_5
    const/16 p0, 0xf

    return p0

    :pswitch_6
    const/16 p0, 0xe

    return p0

    :pswitch_7
    const/16 p0, 0xd

    return p0

    :pswitch_8
    const/16 p0, 0xc

    return p0

    :pswitch_9
    const/16 p0, 0xb

    return p0

    :pswitch_a
    const/16 p0, 0xa

    return p0

    :pswitch_b
    const/16 p0, 0x9

    return p0

    :pswitch_c
    const/16 p0, 0x8

    return p0

    :pswitch_d
    const/4 p0, 0x7

    return p0

    :pswitch_e
    const/4 p0, 0x6

    return p0

    :pswitch_f
    const/4 p0, 0x5

    return p0

    :pswitch_10
    const/4 p0, 0x4

    return p0

    :pswitch_11
    const/4 p0, 0x3

    return p0

    :pswitch_12
    const/4 p0, 0x2

    return p0

    :pswitch_13
    const/4 p0, 0x1

    return p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private static convertProtoToBase64String(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;)Ljava/lang/String;
    .locals 1

    .line 661
    invoke-static {p0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p0

    const/4 v0, 0x0

    .line 660
    invoke-static {p0, v0}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static convertRadioState(I)I
    .locals 2

    const/4 v0, 0x1

    if-eqz p0, :cond_2

    const/4 v1, 0x2

    if-eq p0, v0, :cond_1

    if-eq p0, v1, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const/4 p0, 0x3

    return p0

    :cond_1
    return v1

    :cond_2
    return v0
.end method

.method private convertSmsFormat(Ljava/lang/String;)I
    .locals 0

    .line 2748
    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    const-string p0, "3gpp"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_1

    const-string p0, "3gpp2"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    const/4 p0, 0x2

    goto :goto_0

    :cond_1
    const/4 p0, 0x1

    :goto_0
    return p0
.end method

.method private disconnectReasonsKnown([Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;)Z
    .locals 3

    .line 1589
    array-length p0, p1

    const/4 v0, 0x0

    move v1, v0

    :goto_0
    if-ge v1, p0, :cond_1

    aget-object v2, p1, v1

    .line 1590
    iget v2, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->callEndReason:I

    if-nez v2, :cond_0

    return v0

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x1

    return p0
.end method

.method private declared-synchronized finishCallSession(Lcom/android/internal/telephony/metrics/InProgressCallSession;)V
    .locals 3

    monitor-enter p0

    .line 1153
    :try_start_0
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;-><init>()V

    .line 1154
    iget-object v1, p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;->events:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->size()I

    move-result v1

    new-array v1, v1, [Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;->events:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;

    .line 1155
    iget-object v2, p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;->events:Ljava/util/Deque;

    invoke-interface {v2, v1}, Ljava/util/Deque;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    .line 1156
    iget v1, p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;->startSystemTimeMin:I

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;->startTimeMinutes:I

    .line 1157
    iget v1, p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;->phoneId:I

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;->phoneId:I

    .line 1158
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->isEventsDropped()Z

    move-result v1

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;->eventsDropped:Z

    .line 1159
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedCallSessions:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->size()I

    move-result v1

    const/16 v2, 0x32

    if-lt v1, v2, :cond_0

    .line 1160
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedCallSessions:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->removeFirst()Ljava/lang/Object;

    .line 1162
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedCallSessions:Ljava/util/Deque;

    invoke-interface {v1, v0}, Ljava/util/Deque;->add(Ljava/lang/Object;)Z

    .line 1163
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    iget p1, p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;->phoneId:I

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->remove(I)V

    const-string p1, "Call session finished"

    .line 1164
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1165
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized finishSmsSession(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;
    .locals 3

    monitor-enter p0

    .line 1182
    :try_start_0
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;-><init>()V

    .line 1183
    iget-object v1, p1, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->events:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->size()I

    move-result v1

    new-array v1, v1, [Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;->events:[Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    .line 1184
    iget-object v2, p1, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->events:Ljava/util/Deque;

    invoke-interface {v2, v1}, Ljava/util/Deque;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    .line 1185
    iget v1, p1, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->startSystemTimeMin:I

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;->startTimeMinutes:I

    .line 1186
    iget v1, p1, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->phoneId:I

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;->phoneId:I

    .line 1187
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->isEventsDropped()Z

    move-result p1

    iput-boolean p1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;->eventsDropped:Z

    .line 1189
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedSmsSessions:Ljava/util/Deque;

    invoke-interface {p1}, Ljava/util/Deque;->size()I

    move-result p1

    const/16 v1, 0x1f4

    if-lt p1, v1, :cond_0

    .line 1190
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedSmsSessions:Ljava/util/Deque;

    invoke-interface {p1}, Ljava/util/Deque;->removeFirst()Ljava/lang/Object;

    .line 1192
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedSmsSessions:Ljava/util/Deque;

    invoke-interface {p1, v0}, Ljava/util/Deque;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1193
    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized finishSmsSessionIfNeeded(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)V
    .locals 1

    monitor-enter p0

    .line 1173
    :try_start_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->getNumExpectedResponses()I

    move-result v0

    if-nez v0, :cond_0

    .line 1174
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishSmsSession(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;

    .line 1176
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressSmsSessions:Landroid/util/SparseArray;

    iget p1, p1, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->phoneId:I

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->remove(I)V

    const-string p1, "SMS session finished"

    .line 1177
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1179
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private getCallId(Landroid/telephony/ims/ImsCallSession;)I
    .locals 0

    const/4 p0, -0x1

    if-nez p1, :cond_0

    return p0

    .line 2058
    :cond_0
    :try_start_0
    invoke-virtual {p1}, Landroid/telephony/ims/ImsCallSession;->getCallId()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return p0
.end method

.method public static declared-synchronized getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;
    .locals 2

    const-class v0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    monitor-enter v0

    .line 256
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->sInstance:Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    if-nez v1, :cond_0

    .line 257
    new-instance v1, Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    invoke-direct {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;-><init>()V

    sput-object v1, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->sInstance:Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    .line 260
    :cond_0
    sget-object v1, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->sInstance:Lcom/android/internal/telephony/metrics/TelephonyMetrics;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method private getSamplePercentageForEmergencyCall(Ljava/lang/String;)D
    .locals 0

    const-string p0, "cn,in"

    .line 2935
    invoke-virtual {p0, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_0

    const-wide/high16 p0, 0x3ff0000000000000L    # 1.0

    return-wide p0

    :cond_0
    const-string/jumbo p0, "us,id,br,pk,ng,bd,ru,mx,jp,et,ph,eg,vn,cd,tr,ir,de"

    .line 2937
    invoke-virtual {p0, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_1

    const-wide/high16 p0, 0x4014000000000000L    # 5.0

    return-wide p0

    :cond_1
    const-string/jumbo p0, "th,gb,fr,tz,it,za,mm,ke,kr,co,es,ug,ar,ua,dz,sd,iq"

    .line 2939
    invoke-virtual {p0, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_2

    const-wide/high16 p0, 0x402e000000000000L    # 15.0

    return-wide p0

    :cond_2
    const-string p0, "pl,ca,af,ma,sa,pe,uz,ve,my,ao,mz,gh,np,ye,mg,kp,cm"

    .line 2941
    invoke-virtual {p0, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_3

    const-wide/high16 p0, 0x4039000000000000L    # 25.0

    return-wide p0

    :cond_3
    const-string p0, "au,tw,ne,lk,bf,mw,ml,ro,kz,sy,cl,zm,gt,zw,nl,ec,sn"

    .line 2943
    invoke-virtual {p0, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_4

    const-wide p0, 0x4041800000000000L    # 35.0

    return-wide p0

    :cond_4
    const-string p0, "kh,td,so,gn,ss,rw,bj,tn,bi,be,cu,bo,ht,gr,do,cz,pt"

    .line 2945
    invoke-virtual {p0, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_5

    const-wide p0, 0x4046800000000000L    # 45.0

    return-wide p0

    :cond_5
    const-wide/high16 p0, 0x4049000000000000L    # 50.0

    return-wide p0
.end method

.method private getSmsTech(IZ)I
    .locals 0

    const/4 p0, 0x1

    if-ne p1, p0, :cond_0

    const/4 p0, 0x3

    return p0

    :cond_0
    if-nez p1, :cond_2

    if-eqz p2, :cond_1

    const/4 p0, 0x2

    :cond_1
    return p0

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method private static synthetic lambda$convertEmergencyNumberToEmergencyNumberInfo$1(I)[Ljava/lang/String;
    .locals 0

    .line 1612
    new-array p0, p0, [Ljava/lang/String;

    return-object p0
.end method

.method private static synthetic lambda$updateActiveSubscriptionInfoList$0(ILjava/lang/Integer;)Z
    .locals 0

    .line 851
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/Integer;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$writeCarrierIdMatchingEvent$2(I)[Ljava/lang/String;
    .locals 0

    .line 2674
    new-array p0, p0, [Ljava/lang/String;

    return-object p0
.end method

.method private logv(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method private lookupEstimationStats(III)Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;
    .locals 2

    .line 2976
    invoke-static {p2, p3}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getDataRatName(II)Ljava/lang/String;

    move-result-object v0

    .line 2977
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mBwEstStatsMapList:Ljava/util/List;

    invoke-interface {v1, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;

    if-nez v1, :cond_0

    .line 2979
    new-instance v1, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;

    invoke-direct {v1, p2, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;-><init>(II)V

    .line 2980
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mBwEstStatsMapList:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Map;

    invoke-interface {p0, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-object v1
.end method

.method private static makeInvalidSubscriptionInfo(I)Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;
    .locals 1

    .line 884
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;-><init>()V

    .line 885
    iput p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;->slotIndex:I

    const/4 p0, -0x1

    .line 886
    iput p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;->carrierId:I

    .line 887
    iput p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;->isOpportunistic:I

    return-object v0
.end method

.method private static mapSimStateToProto(I)I
    .locals 1

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/16 v0, 0xa

    if-eq p0, v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const/4 p0, 0x2

    return p0

    :cond_1
    return v0
.end method

.method private declared-synchronized printAllMetrics(Ljava/io/PrintWriter;)V
    .locals 14

    monitor-enter p0

    .line 454
    :try_start_0
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p1, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    const-string v1, "Telephony metrics proto:"

    .line 456
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string v1, "------------------------------------------"

    .line 457
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string v1, "Telephony events:"

    .line 458
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 459
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 460
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEvents:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    const/4 v3, 0x2

    const/4 v4, 0x0

    if-eqz v2, :cond_2

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    .line 461
    iget-wide v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    invoke-virtual {v0, v5, v6}, Ljava/io/PrintWriter;->print(J)V

    const-string v5, " ["

    .line 462
    invoke-virtual {v0, v5}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 463
    iget v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->phoneId:I

    invoke-virtual {v0, v5}, Ljava/io/PrintWriter;->print(I)V

    const-string v5, "] "

    .line 464
    invoke-virtual {v0, v5}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    const-string v5, "T="

    .line 466
    invoke-virtual {v0, v5}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 467
    iget v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->type:I

    if-ne v5, v3, :cond_0

    .line 468
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->type:I

    invoke-static {v5}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->telephonyEventToString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "(Data RAT "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v5, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->dataRat:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " Voice RAT "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v5, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->voiceRat:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " Channel Number "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v5, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->channelNumber:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " NR Frequency Range "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v5, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->nrFrequencyRange:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " NR State "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v5, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->nrState:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, ")"

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 475
    :goto_1
    iget-object v3, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget-object v3, v3, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->networkRegistrationInfo:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;

    array-length v3, v3

    if-ge v4, v3, :cond_1

    .line 476
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "reg info: domain="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget-object v5, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->networkRegistrationInfo:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;

    aget-object v5, v5, v4

    iget v5, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;->domain:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, ", rat="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget-object v5, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->networkRegistrationInfo:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;

    aget-object v5, v5, v4

    iget v5, v5, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;->rat:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    add-int/lit8 v4, v4, 0x1

    goto :goto_1

    .line 481
    :cond_0
    invoke-static {v5}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->telephonyEventToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    :cond_1
    const-string v2, ""

    .line 484
    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 487
    :cond_2
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "Call sessions:"

    .line 488
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 489
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 491
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedCallSessions:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_2
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    const/16 v5, 0xa

    if-eqz v2, :cond_9

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;

    .line 492
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Start time in minutes: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v7, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;->startTimeMinutes:I

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 493
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, ", phone: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v7, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;->phoneId:I

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 494
    iget-boolean v6, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;->eventsDropped:Z

    if-eqz v6, :cond_3

    .line 495
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, ", events dropped: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;->eventsDropped:Z

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_3

    :cond_3
    const-string v6, ""

    .line 497
    invoke-virtual {v0, v6}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    :goto_3
    const-string v6, "Events: "

    .line 500
    invoke-virtual {v0, v6}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 501
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 502
    iget-object v2, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession;->events:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;

    array-length v6, v2

    move v7, v4

    :goto_4
    if-ge v7, v6, :cond_8

    aget-object v8, v2, v7

    .line 503
    iget v9, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->delay:I

    invoke-virtual {v0, v9}, Ljava/io/PrintWriter;->print(I)V

    const-string v9, " T="

    .line 504
    invoke-virtual {v0, v9}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 505
    iget v9, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->type:I

    if-ne v9, v3, :cond_4

    .line 506
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    iget v10, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->type:I

    invoke-static {v10}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->callSessionEventToString(I)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, "(Data RAT "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->dataRat:I

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v10, " Voice RAT "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->voiceRat:I

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v10, " Channel Number "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->channelNumber:I

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v10, " NR Frequency Range "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->nrFrequencyRange:I

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v10, " NR State "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v8, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v8, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->nrState:I

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v8, ")"

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto/16 :goto_6

    :cond_4
    if-ne v9, v5, :cond_6

    .line 514
    invoke-static {v9}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->callSessionEventToString(I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v0, v9}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 515
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 516
    iget-object v8, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->calls:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;

    array-length v9, v8

    move v10, v4

    :goto_5
    if-ge v10, v9, :cond_5

    aget-object v11, v8, v10

    .line 517
    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    iget v13, v11, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->index:I

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v13, ". Type = "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v13, v11, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->type:I

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v13, " State = "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v13, v11, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->state:I

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v13, " End Reason "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v13, v11, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->callEndReason:I

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v13, " Precise Disconnect Cause "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v13, v11, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->preciseDisconnectCause:I

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v13, " isMultiparty = "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v11, v11, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->isMultiparty:Z

    invoke-virtual {v12, v11}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    add-int/lit8 v10, v10, 0x1

    goto :goto_5

    .line 522
    :cond_5
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    goto :goto_6

    :cond_6
    const/16 v10, 0x16

    if-ne v9, v10, :cond_7

    .line 524
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    iget v10, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->type:I

    invoke-static {v10}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->callSessionEventToString(I)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, "("

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v8, v8, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event;->audioCodec:I

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v8, ")"

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_6

    .line 527
    :cond_7
    invoke-static {v9}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->callSessionEventToString(I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    :goto_6
    add-int/lit8 v7, v7, 0x1

    goto/16 :goto_4

    .line 530
    :cond_8
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    goto/16 :goto_2

    .line 533
    :cond_9
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "Sms sessions:"

    .line 534
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 535
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 538
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedSmsSessions:Ljava/util/Deque;

    invoke-interface {v1}, Ljava/util/Deque;->iterator()Ljava/util/Iterator;

    move-result-object v1

    move v2, v4

    :goto_7
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    const/4 v7, 0x1

    if-eqz v6, :cond_16

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;

    add-int/2addr v2, v7

    .line 540
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "["

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v9, "] Start time in minutes: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v9, v6, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;->startTimeMinutes:I

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 542
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, ", phone: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v9, v6, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;->phoneId:I

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 543
    iget-boolean v8, v6, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;->eventsDropped:Z

    if-eqz v8, :cond_a

    .line 544
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, ", events dropped: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v9, v6, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;->eventsDropped:Z

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v8}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_8

    :cond_a
    const-string v8, ""

    .line 546
    invoke-virtual {v0, v8}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    :goto_8
    const-string v8, "Events: "

    .line 548
    invoke-virtual {v0, v8}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 549
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 550
    iget-object v6, v6, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;->events:[Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;

    array-length v8, v6

    move v9, v4

    :goto_9
    if-ge v9, v8, :cond_15

    aget-object v10, v6, v9

    .line 551
    iget v11, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->delay:I

    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->print(I)V

    const-string v11, " T="

    .line 552
    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 553
    iget v11, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->type:I

    if-ne v11, v3, :cond_b

    .line 554
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    iget v12, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->type:I

    invoke-static {v12}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->smsSessionEventToString(I)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v12, "(Data RAT "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v12, v12, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->dataRat:I

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, " Voice RAT "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v12, v12, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->voiceRat:I

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, " Channel Number "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v12, v12, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->channelNumber:I

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, " NR Frequency Range "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v12, v12, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->nrFrequencyRange:I

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, " NR State "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    iget v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->nrState:I

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v10, ")"

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto/16 :goto_c

    :cond_b
    const/16 v12, 0x8

    if-ne v11, v12, :cond_11

    .line 562
    invoke-static {v11}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->smsSessionEventToString(I)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 563
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 564
    iget v11, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->smsType:I

    if-eq v11, v7, :cond_f

    if-eq v11, v3, :cond_e

    const/4 v12, 0x3

    if-eq v11, v12, :cond_d

    const/4 v12, 0x4

    if-eq v11, v12, :cond_c

    goto :goto_a

    :cond_c
    const-string v11, "Type: WAP PUSH"

    .line 575
    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_a

    :cond_d
    const-string v11, "Type: zero"

    .line 572
    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_a

    :cond_e
    const-string v11, "Type: Voicemail indication"

    .line 569
    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_a

    :cond_f
    const-string v11, "Type: SMS-PP"

    .line 566
    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 580
    :goto_a
    iget v11, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->errorCode:I

    if-eqz v11, :cond_10

    .line 581
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "E="

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->errorCode:I

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 583
    :cond_10
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    goto/16 :goto_c

    :cond_11
    const/4 v12, 0x6

    if-eq v11, v12, :cond_13

    const/4 v12, 0x7

    if-ne v11, v12, :cond_12

    goto :goto_b

    :cond_12
    if-ne v11, v5, :cond_14

    .line 594
    invoke-static {v11}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->smsSessionEventToString(I)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 595
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 596
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Received: "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->incompleteSms:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;

    iget v12, v12, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;->receivedParts:I

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v12, "/"

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->incompleteSms:Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;

    iget v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;->totalParts:I

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 598
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    goto :goto_c

    .line 586
    :cond_13
    :goto_b
    invoke-static {v11}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->smsSessionEventToString(I)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 587
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 588
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "ReqId="

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v12, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->rilRequestId:I

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 589
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "E="

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v12, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->errorCode:I

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 590
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "RilE="

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v12, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->error:I

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v11}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 591
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "ImsE="

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v10, v10, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event;->imsError:I

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 592
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    :cond_14
    :goto_c
    add-int/lit8 v9, v9, 0x1

    goto/16 :goto_9

    .line 601
    :cond_15
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    goto/16 :goto_7

    .line 604
    :cond_16
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "Modem power stats:"

    .line 605
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 606
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 608
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mContext:Landroid/content/Context;

    if-nez v1, :cond_17

    const/4 v1, 0x0

    goto :goto_d

    :cond_17
    const-string v2, "batterystats"

    .line 609
    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/BatteryStatsManager;

    .line 610
    :goto_d
    new-instance v2, Lcom/android/internal/telephony/metrics/ModemPowerMetrics;

    invoke-direct {v2, v1}, Lcom/android/internal/telephony/metrics/ModemPowerMetrics;-><init>(Landroid/os/BatteryStatsManager;)V

    invoke-virtual {v2}, Lcom/android/internal/telephony/metrics/ModemPowerMetrics;->buildProto()Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;

    move-result-object v1

    .line 612
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Power log duration (battery time) (ms): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->loggingDurationMs:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 613
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Energy consumed by modem (mAh): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->energyConsumedMah:D

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 614
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Number of packets sent (tx): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->numPacketsTx:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 615
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Number of bytes sent (tx): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->numBytesTx:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 616
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Number of packets received (rx): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->numPacketsRx:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 617
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Number of bytes received (rx): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->numBytesRx:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 618
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Amount of time kernel is active because of cellular data (ms): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->cellularKernelActiveTimeMs:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 620
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Amount of time spent in very poor rx signal level (ms): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->timeInVeryPoorRxSignalLevelMs:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 622
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Amount of time modem is in sleep (ms): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->sleepTimeMs:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 623
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Amount of time modem is in idle (ms): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->idleTimeMs:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 624
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Amount of time modem is in rx (ms): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->rxTimeMs:J

    invoke-virtual {v2, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 625
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Amount of time modem is in tx (ms): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->txTimeMs:[J

    invoke-static {v3}, Ljava/util/Arrays;->toString([J)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 626
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Amount of time phone spent in various Radio Access Technologies (ms): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->timeInRatMs:[J

    .line 627
    invoke-static {v3}, Ljava/util/Arrays;->toString([J)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 626
    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 628
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Amount of time phone spent in various cellular rx signal strength levels (ms): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->timeInRxSignalStrengthLevelMs:[J

    .line 630
    invoke-static {v3}, Ljava/util/Arrays;->toString([J)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 628
    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 631
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Energy consumed across measured modem rails (mAh): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v3, Ljava/text/DecimalFormat;

    const-string v5, "#.##"

    invoke-direct {v3, v5}, Ljava/text/DecimalFormat;-><init>(Ljava/lang/String;)V

    iget-wide v5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$ModemPowerStats;->monitoredRailEnergyConsumedMah:D

    .line 632
    invoke-virtual {v3, v5, v6}, Ljava/text/DecimalFormat;->format(D)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 631
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 633
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 634
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Hardware Version: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "ro.boot.revision"

    const-string v3, ""

    invoke-static {v2, v3}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 636
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "LinkBandwidthEstimator stats:"

    .line 637
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 638
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "Tx"

    .line 640
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 641
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mBwEstStatsMapList:Ljava/util/List;

    invoke-interface {v1, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_e
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_18

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;

    .line 642
    invoke-virtual {v2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_e

    :cond_18
    const-string v1, "Rx"

    .line 645
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 646
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mBwEstStatsMapList:Ljava/util/List;

    invoke-interface {v1, v7}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_f
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_19

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;

    .line 647
    invoke-virtual {v2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_f

    .line 650
    :cond_19
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/metrics/RcsStats;->printAllMetrics(Ljava/io/PrintWriter;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 651
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized reset()V
    .locals 9

    monitor-enter p0

    .line 668
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEvents:Ljava/util/Deque;

    invoke-interface {v0}, Ljava/util/Deque;->clear()V

    .line 669
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedCallSessions:Ljava/util/Deque;

    invoke-interface {v0}, Ljava/util/Deque;->clear()V

    .line 670
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mCompletedSmsSessions:Ljava/util/Deque;

    invoke-interface {v0}, Ljava/util/Deque;->clear()V

    .line 671
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mBwEstStatsMapList:Ljava/util/List;

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    .line 672
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mBwEstStatsMapList:Ljava/util/List;

    const/4 v2, 0x1

    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    .line 674
    iput-boolean v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mTelephonyEventsDropped:Z

    .line 676
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    iput-wide v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartSystemTimeMs:J

    .line 677
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v3

    iput-wide v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    .line 684
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    const/4 v5, -0x1

    invoke-direct {v0, v3, v4, v5}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSimState:Landroid/util/SparseArray;

    .line 685
    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setSimStateChange(Landroid/util/SparseArray;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v0

    .line 684
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    .line 687
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    iget-wide v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    invoke-direct {v0, v3, v4, v5}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    iget v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastEnabledModemBitmap:I

    .line 688
    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setEnabledModemBitmap(I)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v0

    .line 687
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    move v0, v1

    .line 690
    :goto_0
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v3

    if-ge v0, v3, :cond_0

    .line 691
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    invoke-virtual {v3, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    .line 692
    new-instance v4, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    iget-wide v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    invoke-direct {v4, v5, v6, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    .line 693
    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setActiveSubscriptionInfoChange(Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v3

    .line 694
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    move v0, v1

    .line 697
    :goto_1
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastServiceState:Landroid/util/SparseArray;

    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v3

    if-ge v0, v3, :cond_1

    .line 698
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastServiceState:Landroid/util/SparseArray;

    invoke-virtual {v3, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    .line 700
    new-instance v4, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    iget-wide v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    invoke-direct {v4, v5, v6, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastServiceState:Landroid/util/SparseArray;

    .line 701
    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setServiceState(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v3

    .line 702
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :cond_1
    move v0, v1

    .line 705
    :goto_2
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsCapabilities:Landroid/util/SparseArray;

    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v3

    if-ge v0, v3, :cond_2

    .line 706
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsCapabilities:Landroid/util/SparseArray;

    invoke-virtual {v3, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    .line 708
    new-instance v4, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    iget-wide v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    invoke-direct {v4, v5, v6, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsCapabilities:Landroid/util/SparseArray;

    .line 709
    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setImsCapabilities(Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v3

    .line 710
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    :cond_2
    move v0, v1

    .line 713
    :goto_3
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsConnectionState:Landroid/util/SparseArray;

    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v3

    if-ge v0, v3, :cond_3

    .line 714
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsConnectionState:Landroid/util/SparseArray;

    invoke-virtual {v3, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    .line 716
    new-instance v4, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    iget-wide v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    invoke-direct {v4, v5, v6, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsConnectionState:Landroid/util/SparseArray;

    .line 717
    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setImsConnectionState(Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v3

    .line 718
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_3

    :cond_3
    move v0, v1

    .line 721
    :goto_4
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastCarrierId:Landroid/util/SparseArray;

    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v3

    if-ge v0, v3, :cond_4

    .line 722
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastCarrierId:Landroid/util/SparseArray;

    invoke-virtual {v3, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    .line 723
    new-instance v4, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    iget-wide v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    invoke-direct {v4, v5, v6, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastCarrierId:Landroid/util/SparseArray;

    .line 724
    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatching;

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setCarrierIdMatching(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatching;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v3

    .line 725
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_4

    :cond_4
    move v0, v1

    .line 728
    :goto_5
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastNetworkCapabilitiesInfos:Landroid/util/SparseArray;

    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v3

    if-ge v0, v3, :cond_5

    .line 729
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastNetworkCapabilitiesInfos:Landroid/util/SparseArray;

    invoke-virtual {v3, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    .line 730
    new-instance v4, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    iget-wide v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    invoke-direct {v4, v5, v6, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastNetworkCapabilitiesInfos:Landroid/util/SparseArray;

    .line 731
    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$NetworkCapabilitiesInfo;

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setNetworkCapabilities(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$NetworkCapabilitiesInfo;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v3

    .line 732
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_5

    :cond_5
    move v0, v1

    .line 735
    :goto_6
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v3

    if-ge v0, v3, :cond_7

    .line 736
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    invoke-virtual {v3, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    move v4, v1

    .line 737
    :goto_7
    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/util/SparseArray;

    invoke-virtual {v5}, Landroid/util/SparseArray;->size()I

    move-result v5

    if-ge v4, v5, :cond_6

    .line 738
    iget-object v5, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/util/SparseArray;

    invoke-virtual {v5, v4}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v5

    new-array v6, v2, [Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;

    .line 740
    iget-object v7, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    invoke-virtual {v7, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/util/SparseArray;

    invoke-virtual {v7, v5}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;

    aput-object v5, v6, v1

    .line 741
    new-instance v5, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    iget-wide v7, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    invoke-direct {v5, v7, v8, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    .line 742
    invoke-virtual {v5, v6}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setDataCalls([Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v5

    invoke-virtual {v5}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v5

    .line 741
    invoke-direct {p0, v5}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    add-int/lit8 v4, v4, 0x1

    goto :goto_7

    :cond_6
    add-int/lit8 v0, v0, 0x1

    goto :goto_6

    .line 746
    :cond_7
    :goto_8
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRadioState:Landroid/util/SparseArray;

    invoke-virtual {v0}, Landroid/util/SparseArray;->size()I

    move-result v0

    if-ge v1, v0, :cond_8

    .line 747
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRadioState:Landroid/util/SparseArray;

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v0

    .line 748
    new-instance v2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    iget-wide v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mStartElapsedTimeMs:J

    invoke-direct {v2, v3, v4, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(JI)V

    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRadioState:Landroid/util/SparseArray;

    .line 749
    invoke-virtual {v3, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-virtual {v2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setRadioState(I)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v0

    .line 750
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_8

    .line 753
    :cond_8
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/RcsStats;->reset()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 754
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method static roundSessionStart(J)I
    .locals 2

    const-wide/32 v0, 0x493e0

    .line 898
    div-long/2addr p0, v0

    const-wide/16 v0, 0x5

    mul-long/2addr p0, v0

    long-to-int p0, p0

    return p0
.end method

.method private static smsSessionEventToString(I)Ljava/lang/String;
    .locals 0

    packed-switch p0, :pswitch_data_0

    .line 444
    :pswitch_0
    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :pswitch_1
    const-string p0, "INCOMPLETE_SMS_RECEIVED"

    return-object p0

    :pswitch_2
    const-string p0, "SMS_RECEIVED"

    return-object p0

    :pswitch_3
    const-string p0, "SMS_SEND_RESULT"

    return-object p0

    :pswitch_4
    const-string p0, "SMS_SEND"

    return-object p0

    :pswitch_5
    const-string p0, "DATA_CALL_LIST_CHANGED"

    return-object p0

    :pswitch_6
    const-string p0, "IMS_CAPABILITIES_CHANGED"

    return-object p0

    :pswitch_7
    const-string p0, "IMS_CONNECTION_STATE_CHANGED"

    return-object p0

    :pswitch_8
    const-string p0, "RIL_SERVICE_STATE_CHANGED"

    return-object p0

    :pswitch_9
    const-string p0, "SETTINGS_CHANGED"

    return-object p0

    :pswitch_a
    const-string p0, "EVENT_UNKNOWN"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method private declared-synchronized startNewCallSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressCallSession;
    .locals 6

    monitor-enter p0

    .line 1065
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez v0, :cond_2

    .line 1067
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Starting a new call session on phone "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    .line 1068
    new-instance v0, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/InProgressCallSession;-><init>(I)V

    .line 1069
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v1, p1, v0}, Landroid/util/SparseArray;->append(ILjava/lang/Object;)V

    .line 1073
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastServiceState:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    if-eqz v1, :cond_0

    .line 1075
    iget-wide v2, v0, Lcom/android/internal/telephony/metrics/InProgressCallSession;->startElapsedTimeMs:J

    new-instance v4, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/4 v5, 0x2

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 1077
    invoke-virtual {v4, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setServiceState(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object v1

    .line 1075
    invoke-virtual {v0, v2, v3, v1}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(JLcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    .line 1080
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsCapabilities:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;

    if-eqz v1, :cond_1

    .line 1082
    iget-wide v2, v0, Lcom/android/internal/telephony/metrics/InProgressCallSession;->startElapsedTimeMs:J

    new-instance v4, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/4 v5, 0x4

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 1084
    invoke-virtual {v4, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setImsCapabilities(Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object v1

    .line 1082
    invoke-virtual {v0, v2, v3, v1}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(JLcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    .line 1087
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsConnectionState:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;

    if-eqz p1, :cond_2

    .line 1089
    iget-wide v1, v0, Lcom/android/internal/telephony/metrics/InProgressCallSession;->startElapsedTimeMs:J

    new-instance v3, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/4 v4, 0x3

    invoke-direct {v3, v4}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 1091
    invoke-virtual {v3, p1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setImsConnectionState(Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p1

    .line 1089
    invoke-virtual {v0, v1, v2, p1}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(JLcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1094
    :cond_2
    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private startNewSmsSession(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;
    .locals 6

    .line 1120
    new-instance v0, Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;-><init>(I)V

    .line 1124
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastServiceState:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    if-eqz v1, :cond_0

    .line 1126
    iget-wide v2, v0, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->startElapsedTimeMs:J

    new-instance v4, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/4 v5, 0x2

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 1128
    invoke-virtual {v4, v1}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setServiceState(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v1

    .line 1126
    invoke-virtual {v0, v2, v3, v1}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(JLcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 1131
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsCapabilities:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;

    if-eqz v1, :cond_1

    .line 1133
    iget-wide v2, v0, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->startElapsedTimeMs:J

    new-instance v4, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/4 v5, 0x4

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 1135
    invoke-virtual {v4, v1}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setImsCapabilities(Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v1

    .line 1133
    invoke-virtual {v0, v2, v3, v1}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(JLcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 1138
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsConnectionState:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;

    if-eqz p0, :cond_2

    .line 1140
    iget-wide v1, v0, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->startElapsedTimeMs:J

    new-instance p1, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/4 v3, 0x3

    invoke-direct {p1, v3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 1142
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setImsConnectionState(Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p0

    .line 1140
    invoke-virtual {v0, v1, v2, p0}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(JLcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    :cond_2
    return-object v0
.end method

.method private declared-synchronized startNewSmsSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;
    .locals 2

    monitor-enter p0

    .line 1104
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressSmsSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    if-nez v0, :cond_0

    .line 1106
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Starting a new sms session on phone "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    .line 1107
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewSmsSession(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    move-result-object v0

    .line 1108
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressSmsSessions:Landroid/util/SparseArray;

    invoke-virtual {v1, p1, v0}, Landroid/util/SparseArray;->append(ILjava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1110
    :cond_0
    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private static telephonyEventToString(I)Ljava/lang/String;
    .locals 1

    const/16 v0, 0x15

    if-eq p0, v0, :cond_1

    const/16 v0, 0x16

    if-eq p0, v0, :cond_0

    packed-switch p0, :pswitch_data_0

    .line 353
    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :pswitch_0
    const-string p0, "CARRIER_ID_MATCHING"

    return-object p0

    :pswitch_1
    const-string p0, "NITZ_TIME"

    return-object p0

    :pswitch_2
    const-string p0, "MODEM_RESTART"

    return-object p0

    :pswitch_3
    const-string p0, "DATA_STALL_ACTION"

    return-object p0

    :pswitch_4
    const-string p0, "DATA_CALL_DEACTIVATE_RESPONSE"

    return-object p0

    :pswitch_5
    const-string p0, "DATA_CALL_DEACTIVATE"

    return-object p0

    :pswitch_6
    const-string p0, "DATA_CALL_LIST_CHANGED"

    return-object p0

    :pswitch_7
    const-string p0, "DATA_CALL_SETUP_RESPONSE"

    return-object p0

    :pswitch_8
    const-string p0, "DATA_CALL_SETUP"

    return-object p0

    :pswitch_9
    const-string p0, "IMS_CAPABILITIES_CHANGED"

    return-object p0

    :pswitch_a
    const-string p0, "IMS_CONNECTION_STATE_CHANGED"

    return-object p0

    :pswitch_b
    const-string p0, "RIL_SERVICE_STATE_CHANGED"

    return-object p0

    :pswitch_c
    const-string p0, "SETTINGS_CHANGED"

    return-object p0

    :pswitch_d
    const-string p0, "UNKNOWN"

    return-object p0

    :cond_0
    const-string p0, "NETWORK_CAPABILITIES_CHANGED"

    return-object p0

    :cond_1
    const-string p0, "EMERGENCY_NUMBER_REPORT"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static toCallQualityProto(Landroid/telephony/CallQuality;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;
    .locals 3

    .line 2184
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;-><init>()V

    if-eqz p0, :cond_0

    .line 2187
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getDownlinkCallQualityLevel()I

    move-result v1

    .line 2186
    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->callQualityLevelToProtoEnum(I)I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->downlinkLevel:I

    .line 2188
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getUplinkCallQualityLevel()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->callQualityLevelToProtoEnum(I)I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->uplinkLevel:I

    .line 2190
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getCallDuration()I

    move-result v1

    div-int/lit16 v1, v1, 0x3e8

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->durationInSeconds:I

    .line 2191
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getNumRtpPacketsTransmitted()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->rtpPacketsTransmitted:I

    .line 2192
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getNumRtpPacketsReceived()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->rtpPacketsReceived:I

    .line 2193
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getNumRtpPacketsTransmittedLost()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->rtpPacketsTransmittedLost:I

    .line 2194
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getNumRtpPacketsNotReceived()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->rtpPacketsNotReceived:I

    .line 2195
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getAverageRelativeJitter()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->averageRelativeJitterMillis:I

    .line 2196
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getMaxRelativeJitter()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->maxRelativeJitterMillis:I

    .line 2197
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getCodecType()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertImsCodec(I)I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->codecType:I

    .line 2198
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->isRtpInactivityDetected()Z

    move-result v1

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->rtpInactivityDetected:Z

    .line 2199
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->isIncomingSilenceDetectedAtCallSetup()Z

    move-result v1

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->rxSilenceDetected:Z

    .line 2200
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->isOutgoingSilenceDetectedAtCallSetup()Z

    move-result v1

    iput-boolean v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->txSilenceDetected:Z

    .line 2201
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getNumVoiceFrames()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->voiceFrames:I

    .line 2202
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getNumNoDataFrames()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->noDataFrames:I

    .line 2203
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getNumDroppedRtpPackets()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->rtpDroppedPackets:I

    .line 2204
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getMinPlayoutDelayMillis()J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->minPlayoutDelayMillis:J

    .line 2205
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getMaxPlayoutDelayMillis()J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->maxPlayoutDelayMillis:J

    .line 2206
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getNumRtpSidPacketsReceived()I

    move-result v1

    iput v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->rxRtpSidPackets:I

    .line 2207
    invoke-virtual {p0}, Landroid/telephony/CallQuality;->getNumRtpDuplicatePackets()I

    move-result p0

    iput p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQuality;->rtpDuplicatePackets:I

    :cond_0
    return-object v0
.end method

.method private toCallSessionRilRequest(I)I
    .locals 2

    const/16 p0, 0xa

    if-eq p1, p0, :cond_3

    const/16 p0, 0x24

    if-eq p1, p0, :cond_2

    const/16 p0, 0x28

    if-eq p1, p0, :cond_1

    const/16 p0, 0x54

    if-eq p1, p0, :cond_0

    packed-switch p1, :pswitch_data_0

    .line 1809
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown RIL request: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return p0

    :pswitch_0
    const/4 p0, 0x7

    return p0

    :pswitch_1
    const/4 p0, 0x5

    return p0

    :pswitch_2
    const/4 p0, 0x3

    return p0

    :cond_0
    const/4 p0, 0x6

    return p0

    :cond_1
    const/4 p0, 0x2

    return p0

    :cond_2
    const/4 p0, 0x4

    return p0

    :cond_3
    const/4 p0, 0x1

    return p0

    nop

    :pswitch_data_0
    .packed-switch 0xc
        :pswitch_2
        :pswitch_2
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private toImsReasonInfoProto(Landroid/telephony/ims/ImsReasonInfo;)Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;
    .locals 1

    .line 2164
    new-instance p0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;

    invoke-direct {p0}, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;-><init>()V

    if-eqz p1, :cond_0

    .line 2166
    invoke-virtual {p1}, Landroid/telephony/ims/ImsReasonInfo;->getCode()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;->reasonCode:I

    .line 2167
    invoke-virtual {p1}, Landroid/telephony/ims/ImsReasonInfo;->getExtraCode()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;->extraCode:I

    .line 2168
    invoke-virtual {p1}, Landroid/telephony/ims/ImsReasonInfo;->getExtraMessage()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 2170
    iput-object p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;->extraMessage:Ljava/lang/String;

    :cond_0
    return-object p0
.end method

.method private toPdpType(Ljava/lang/String;)I
    .locals 7

    .line 1455
    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    invoke-virtual {p1}, Ljava/lang/String;->hashCode()I

    move-result p0

    const/4 v0, 0x5

    const/4 v1, 0x4

    const/4 v2, 0x3

    const/4 v3, 0x2

    const/4 v4, 0x1

    const/4 v5, 0x0

    const/4 v6, -0x1

    sparse-switch p0, :sswitch_data_0

    goto :goto_0

    :sswitch_0
    const-string p0, "UNSTRUCTURED"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    goto :goto_0

    :cond_0
    move v6, v0

    goto :goto_0

    :sswitch_1
    const-string p0, "IPV6"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_1

    goto :goto_0

    :cond_1
    move v6, v1

    goto :goto_0

    :sswitch_2
    const-string p0, "PPP"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_2

    goto :goto_0

    :cond_2
    move v6, v2

    goto :goto_0

    :sswitch_3
    const-string p0, "IP"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_3

    goto :goto_0

    :cond_3
    move v6, v3

    goto :goto_0

    :sswitch_4
    const-string p0, "NON-IP"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_4

    goto :goto_0

    :cond_4
    move v6, v4

    goto :goto_0

    :sswitch_5
    const-string p0, "IPV4V6"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_5

    goto :goto_0

    :cond_5
    move v6, v5

    :goto_0
    packed-switch v6, :pswitch_data_0

    .line 1469
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v5

    :pswitch_0
    const/4 p0, 0x6

    return p0

    :pswitch_1
    return v3

    :pswitch_2
    return v1

    :pswitch_3
    return v4

    :pswitch_4
    return v0

    :pswitch_5
    return v2

    :sswitch_data_0
    .sparse-switch
        -0x7edefc9b -> :sswitch_5
        -0x766897b9 -> :sswitch_4
        0x927 -> :sswitch_3
        0x13650 -> :sswitch_2
        0x226607 -> :sswitch_1
        0x139cccaa -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method static toPrivacyFuzzedTimeInterval(JJ)I
    .locals 0

    sub-long/2addr p2, p0

    const-wide/16 p0, 0x0

    cmp-long p0, p2, p0

    if-gez p0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const-wide/16 p0, 0xa

    cmp-long p0, p2, p0

    if-gtz p0, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    const-wide/16 p0, 0x14

    cmp-long p0, p2, p0

    if-gtz p0, :cond_2

    const/4 p0, 0x2

    return p0

    :cond_2
    const-wide/16 p0, 0x32

    cmp-long p0, p2, p0

    if-gtz p0, :cond_3

    const/4 p0, 0x3

    return p0

    :cond_3
    const-wide/16 p0, 0x64

    cmp-long p0, p2, p0

    if-gtz p0, :cond_4

    const/4 p0, 0x4

    return p0

    :cond_4
    const-wide/16 p0, 0xc8

    cmp-long p0, p2, p0

    if-gtz p0, :cond_5

    const/4 p0, 0x5

    return p0

    :cond_5
    const-wide/16 p0, 0x1f4

    cmp-long p0, p2, p0

    if-gtz p0, :cond_6

    const/4 p0, 0x6

    return p0

    :cond_6
    const-wide/16 p0, 0x3e8

    cmp-long p0, p2, p0

    if-gtz p0, :cond_7

    const/4 p0, 0x7

    return p0

    :cond_7
    const-wide/16 p0, 0x7d0

    cmp-long p0, p2, p0

    if-gtz p0, :cond_8

    const/16 p0, 0x8

    return p0

    :cond_8
    const-wide/16 p0, 0x1388

    cmp-long p0, p2, p0

    if-gtz p0, :cond_9

    const/16 p0, 0x9

    return p0

    :cond_9
    const-wide/16 p0, 0x2710

    cmp-long p0, p2, p0

    if-gtz p0, :cond_a

    const/16 p0, 0xa

    return p0

    :cond_a
    const-wide/16 p0, 0x7530

    cmp-long p0, p2, p0

    if-gtz p0, :cond_b

    const/16 p0, 0xb

    return p0

    :cond_b
    const-wide/32 p0, 0xea60

    cmp-long p0, p2, p0

    if-gtz p0, :cond_c

    const/16 p0, 0xc

    return p0

    :cond_c
    const-wide/32 p0, 0x2bf20

    cmp-long p0, p2, p0

    if-gtz p0, :cond_d

    const/16 p0, 0xd

    return p0

    :cond_d
    const-wide/32 p0, 0x927c0

    cmp-long p0, p2, p0

    if-gtz p0, :cond_e

    const/16 p0, 0xe

    return p0

    :cond_e
    const-wide/32 p0, 0x1b7740

    cmp-long p0, p2, p0

    if-gtz p0, :cond_f

    const/16 p0, 0xf

    return p0

    :cond_f
    const-wide/32 p0, 0x36ee80

    cmp-long p0, p2, p0

    if-gtz p0, :cond_10

    const/16 p0, 0x10

    return p0

    :cond_10
    const-wide/32 p0, 0x6ddd00

    cmp-long p0, p2, p0

    if-gtz p0, :cond_11

    const/16 p0, 0x11

    return p0

    :cond_11
    const-wide/32 p0, 0xdbba00

    cmp-long p0, p2, p0

    if-gtz p0, :cond_12

    const/16 p0, 0x12

    return p0

    :cond_12
    const/16 p0, 0x13

    return p0
.end method

.method private toServiceStateProto(Landroid/telephony/ServiceState;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;
    .locals 5

    .line 978
    new-instance p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    invoke-direct {p0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;-><init>()V

    .line 980
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getVoiceRoamingType()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->voiceRoamingType:I

    .line 981
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getDataRoamingType()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->dataRoamingType:I

    .line 983
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->voiceOperator:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    .line 984
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->dataOperator:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    .line 985
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaLong()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 986
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->voiceOperator:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaLong()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;->alphaLong:Ljava/lang/String;

    .line 987
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->dataOperator:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaLong()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;->alphaLong:Ljava/lang/String;

    .line 990
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaShort()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 991
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->voiceOperator:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaShort()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;->alphaShort:Ljava/lang/String;

    .line 992
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->dataOperator:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaShort()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;->alphaShort:Ljava/lang/String;

    .line 995
    :cond_1
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 996
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->voiceOperator:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;->numeric:Ljava/lang/String;

    .line 997
    iget-object v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->dataOperator:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$TelephonyOperator;->numeric:Ljava/lang/String;

    .line 1004
    :cond_2
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x2

    const/4 v2, 0x1

    .line 1005
    invoke-virtual {p1, v1, v2}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v3

    if-eqz v3, :cond_3

    .line 1008
    new-instance v4, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;

    invoke-direct {v4}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;-><init>()V

    .line 1010
    iput v1, v4, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;->domain:I

    .line 1011
    iput v2, v4, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;->transport:I

    .line 1013
    invoke-virtual {v3}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v1

    .line 1012
    invoke-static {v1}, Landroid/telephony/ServiceState;->networkTypeToRilRadioTechnology(I)I

    move-result v1

    iput v1, v4, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;->rat:I

    .line 1014
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1016
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    new-array v1, v1, [Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;

    iput-object v1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->networkRegistrationInfo:[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState$NetworkRegistrationInfo;

    .line 1017
    invoke-interface {v0, v1}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    .line 1020
    :cond_3
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->voiceRat:I

    .line 1021
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->dataRat:I

    .line 1022
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getChannelNumber()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->channelNumber:I

    .line 1023
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getNrFrequencyRange()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->nrFrequencyRange:I

    .line 1024
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getNrState()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;->nrState:I

    return-object p0
.end method

.method private writeBandwidthEstimatorStatsRatList(Ljava/util/Map;)Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;",
            ">;)",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;",
            ">;"
        }
    .end annotation

    .line 2997
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    .line 2998
    invoke-interface {p1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;

    .line 2999
    invoke-static {v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->-$$Nest$mwriteBandwidthStats(Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;)Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_0
    return-object p0
.end method

.method private writeIncomingSmsSessionWithType(IIILjava/lang/String;[JZZJ)V
    .locals 18

    move-object/from16 v0, p0

    move/from16 v1, p2

    move/from16 v2, p3

    move-object/from16 v3, p5

    move/from16 v4, p6

    .line 2494
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Logged SMS session consisting of "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v6, v3

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " parts, source = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " blocked = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v6, " type = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2498
    invoke-static/range {p8 .. p9}, Lcom/android/internal/telephony/SmsController;->formatCrossStackMessageId(J)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 2494
    invoke-direct {v0, v5}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    move-object/from16 v5, p4

    .line 2500
    invoke-direct {v0, v5}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertSmsFormat(Ljava/lang/String;)I

    move-result v5

    const/4 v6, 0x1

    xor-int/lit8 v7, p7, 0x1

    const/4 v8, 0x2

    const/4 v9, 0x0

    if-ne v5, v8, :cond_0

    goto :goto_0

    :cond_0
    move v6, v9

    .line 2503
    :goto_0
    invoke-direct {v0, v2, v6}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getSmsTech(IZ)I

    move-result v2

    .line 2505
    invoke-direct/range {p0 .. p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewSmsSession(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    move-result-object v6

    .line 2507
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v10

    .line 2508
    :goto_1
    array-length v8, v3

    if-ge v9, v8, :cond_2

    .line 2509
    new-instance v8, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/16 v12, 0x8

    invoke-direct {v8, v12}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 2511
    invoke-virtual {v8, v5}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setFormat(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v8

    .line 2512
    invoke-virtual {v8, v2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setTech(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v8

    .line 2513
    invoke-virtual {v8, v7}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setErrorCode(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v8

    .line 2514
    invoke-virtual {v8, v1}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setSmsType(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v8

    .line 2515
    invoke-virtual {v8, v4}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setBlocked(Z)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v8

    move-wide/from16 v12, p8

    .line 2516
    invoke-virtual {v8, v12, v13}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setMessageId(J)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v8

    if-lez v9, :cond_1

    .line 2517
    aget-wide v14, v3, v9

    add-int/lit8 v16, v9, -0x1

    aget-wide v16, v3, v16

    sub-long v14, v14, v16

    goto :goto_2

    :cond_1
    const-wide/16 v14, 0x0

    :goto_2
    add-long/2addr v14, v10

    .line 2518
    invoke-virtual {v6, v14, v15, v8}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(JLcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    add-int/lit8 v9, v9, 0x1

    goto :goto_1

    .line 2520
    :cond_2
    invoke-direct {v0, v6}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishSmsSession(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;

    return-void
.end method

.method private writeIncomingSmsWithType(IILjava/lang/String;Z)V
    .locals 2

    .line 2429
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewSmsSession(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    move-result-object p1

    .line 2430
    new-instance v0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/16 v1, 0x8

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 2431
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertSmsFormat(Ljava/lang/String;)I

    move-result p3

    invoke-virtual {v0, p3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setFormat(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p3

    .line 2432
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setSmsType(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    xor-int/lit8 p3, p4, 0x1

    .line 2433
    invoke-virtual {p2, p3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setErrorCode(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2430
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 2435
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishSmsSession(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;

    return-void
.end method

.method private writeOnCallSolicitedResponse(IIII)V
    .locals 2

    .line 1856
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p1, :cond_0

    .line 1858
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string/jumbo p1, "writeOnCallSolicitedResponse: Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 1860
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/4 v1, 0x7

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 1862
    invoke-direct {p0, p4}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toCallSessionRilRequest(I)I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilRequest(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 1863
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilRequestId(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    add-int/lit8 p3, p3, 0x1

    .line 1864
    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilError(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 1860
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    :goto_0
    return-void
.end method

.method private writeOnDeactivateDataCallResponse(II)V
    .locals 1

    .line 1937
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    add-int/lit8 p2, p2, 0x1

    .line 1938
    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setDeactivateDataCallResponse(I)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 1937
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method private writeOnSetupDataCallResponse(IIIILandroid/telephony/data/DataCallResponse;)V
    .locals 1

    .line 1825
    new-instance p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCallResponse;

    invoke-direct {p2}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCallResponse;-><init>()V

    .line 1826
    new-instance p3, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;

    invoke-direct {p3}, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;-><init>()V

    if-eqz p5, :cond_1

    .line 1829
    invoke-virtual {p5}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result p4

    const/4 v0, 0x1

    if-nez p4, :cond_0

    move p4, v0

    goto :goto_0

    .line 1830
    :cond_0
    invoke-virtual {p5}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result p4

    :goto_0
    iput p4, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCallResponse;->status:I

    .line 1831
    invoke-virtual {p5}, Landroid/telephony/data/DataCallResponse;->getSuggestedRetryTime()I

    move-result p4

    iput p4, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCallResponse;->suggestedRetryTimeMillis:I

    .line 1833
    invoke-virtual {p5}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result p4

    iput p4, p3, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;->cid:I

    .line 1834
    invoke-virtual {p5}, Landroid/telephony/data/DataCallResponse;->getProtocolType()I

    move-result p4

    add-int/2addr p4, v0

    iput p4, p3, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;->type:I

    .line 1836
    invoke-virtual {p5}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object p4

    invoke-static {p4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p4

    if-nez p4, :cond_1

    .line 1837
    invoke-virtual {p5}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object p4

    iput-object p4, p3, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;->ifname:Ljava/lang/String;

    .line 1840
    :cond_1
    iput-object p3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCallResponse;->call:Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;

    .line 1842
    new-instance p3, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    .line 1843
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setSetupDataCallResponse(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCallResponse;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 1842
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method private declared-synchronized writeOnSmsSolicitedResponse(IIILcom/android/internal/telephony/SmsResponse;)V
    .locals 4

    monitor-enter p0

    .line 1878
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressSmsSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    if-nez p1, :cond_0

    .line 1880
    sget-object p1, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string p2, "SMS session is missing"

    invoke-static {p1, p2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_0
    const/4 v0, -0x1

    const-wide/16 v1, 0x0

    if-eqz p4, :cond_1

    .line 1885
    iget v0, p4, Lcom/android/internal/telephony/SmsResponse;->mErrorCode:I

    .line 1886
    iget-wide v1, p4, Lcom/android/internal/telephony/SmsResponse;->mMessageId:J

    .line 1889
    :cond_1
    new-instance p4, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/4 v3, 0x7

    invoke-direct {p4, v3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 1891
    invoke-virtual {p4, v0}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setErrorCode(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p4

    add-int/lit8 p3, p3, 0x1

    .line 1892
    invoke-virtual {p4, p3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setRilErrno(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p3

    .line 1893
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setRilRequestId(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 1894
    invoke-virtual {p2, v1, v2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setMessageId(J)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 1889
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 1897
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->decreaseExpectedResponse()V

    .line 1898
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishSmsSessionIfNeeded(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1900
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method


# virtual methods
.method public declared-synchronized dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 6

    monitor-enter p0

    if-eqz p3, :cond_8

    .line 281
    :try_start_0
    array-length p1, p3

    if-lez p1, :cond_8

    .line 283
    array-length p1, p3

    const/4 v0, 0x0

    const/4 v1, 0x1

    if-le p1, v1, :cond_0

    const-string p1, "--keep"

    aget-object v2, p3, v1

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    move p1, v0

    goto :goto_0

    :cond_0
    move p1, v1

    .line 287
    :goto_0
    aget-object p3, p3, v0

    const/4 v2, -0x1

    invoke-virtual {p3}, Ljava/lang/String;->hashCode()I

    move-result v3

    const v4, -0x746ad8dd

    const/4 v5, 0x2

    if-eq v3, v4, :cond_3

    const v0, 0x1ea00b52

    if-eq v3, v0, :cond_2

    const v0, 0x38a4a0a5

    if-eq v3, v0, :cond_1

    goto :goto_1

    :cond_1
    const-string v0, "--metricsproto"

    invoke-virtual {p3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_4

    move v0, v1

    goto :goto_2

    :cond_2
    const-string v0, "--metricsprototext"

    invoke-virtual {p3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_4

    move v0, v5

    goto :goto_2

    :cond_3
    const-string v3, "--metrics"

    invoke-virtual {p3, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_4

    goto :goto_2

    :cond_4
    :goto_1
    move v0, v2

    :goto_2
    if-eqz v0, :cond_7

    if-eq v0, v1, :cond_6

    if-eq v0, v5, :cond_5

    goto :goto_3

    .line 299
    :cond_5
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->buildProto()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 300
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/RcsStats;->buildProto()Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_3

    .line 292
    :cond_6
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->buildProto()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;

    move-result-object p3

    invoke-static {p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertProtoToBase64String(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyLog;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 293
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object p3

    invoke-virtual {p3}, Lcom/android/internal/telephony/metrics/RcsStats;->buildLog()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    if-eqz p1, :cond_8

    .line 295
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->reset()V

    goto :goto_3

    .line 289
    :cond_7
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->printAllMetrics(Ljava/io/PrintWriter;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_3

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1

    .line 304
    :cond_8
    :goto_3
    monitor-exit p0

    return-void
.end method

.method public setContext(Landroid/content/Context;)V
    .locals 0

    .line 270
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mContext:Landroid/content/Context;

    return-void
.end method

.method public declared-synchronized updateActiveSubscriptionInfoList(Ljava/util/List;)V
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/SubscriptionInfo;",
            ">;)V"
        }
    .end annotation

    monitor-enter p0

    .line 844
    :try_start_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x0

    move v2, v1

    .line 845
    :goto_0
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    invoke-virtual {v3}, Landroid/util/SparseArray;->size()I

    move-result v3

    if-ge v2, v3, :cond_0

    .line 846
    iget-object v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    invoke-virtual {v3, v2}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 849
    :cond_0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_1
    :goto_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/SubscriptionInfo;

    .line 850
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getSimSlotIndex()I

    move-result v3

    .line 851
    new-instance v4, Lcom/android/internal/telephony/metrics/TelephonyMetrics$$ExternalSyntheticLambda0;

    invoke-direct {v4, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$$ExternalSyntheticLambda0;-><init>(I)V

    invoke-interface {v0, v4}, Ljava/util/List;->removeIf(Ljava/util/function/Predicate;)Z

    .line 852
    new-instance v4, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;

    invoke-direct {v4}, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;-><init>()V

    .line 853
    iput v3, v4, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;->slotIndex:I

    .line 854
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->isOpportunistic()Z

    move-result v5

    if-eqz v5, :cond_2

    const/4 v5, 0x1

    goto :goto_2

    :cond_2
    move v5, v1

    :goto_2
    iput v5, v4, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;->isOpportunistic:I

    .line 855
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getCarrierId()I

    move-result v5

    iput v5, v4, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;->carrierId:I

    .line 856
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getMccString()Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_3

    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getMncString()Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_3

    .line 857
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getMccString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getMncString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    iput-object v2, v4, Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;->simMccmnc:Ljava/lang/String;

    .line 859
    :cond_3
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    .line 860
    invoke-virtual {v2, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    .line 859
    invoke-static {v2, v4}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->messageNanoEquals(Lcom/android/internal/telephony/protobuf/nano/MessageNano;Lcom/android/internal/telephony/protobuf/nano/MessageNano;)Z

    move-result v2

    if-nez v2, :cond_1

    .line 861
    new-instance v2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v2, v3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    .line 862
    invoke-virtual {v2, v4}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setActiveSubscriptionInfoChange(Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v2

    invoke-virtual {v2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v2

    .line 861
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    .line 864
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    invoke-virtual {v2, v3, v4}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    goto :goto_1

    .line 868
    :cond_4
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_3
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 869
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastActiveSubscriptionInfos:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->remove(I)V

    .line 870
    new-instance v1, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    .line 871
    invoke-static {v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->makeInvalidSubscriptionInfo(I)Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;

    move-result-object v0

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setActiveSubscriptionInfoChange(Lcom/android/internal/telephony/nano/TelephonyProto$ActiveSubscriptionInfo;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v0

    .line 870
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_3

    .line 873
    :cond_5
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public updateEnabledModemBitmap(I)V
    .locals 1

    .line 877
    iget v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastEnabledModemBitmap:I

    if-ne v0, p1, :cond_0

    return-void

    .line 878
    :cond_0
    iput p1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastEnabledModemBitmap:I

    .line 879
    new-instance p1, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>()V

    iget v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastEnabledModemBitmap:I

    .line 880
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setEnabledModemBitmap(I)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 879
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public updateSimState(II)V
    .locals 2

    .line 833
    invoke-static {p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mapSimStateToProto(I)I

    move-result p2

    .line 834
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSimState:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    if-eqz v0, :cond_0

    .line 835
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/Integer;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 836
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSimState:Landroid/util/SparseArray;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {v0, p1, p2}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 837
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    iget-object p1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSimState:Landroid/util/SparseArray;

    .line 838
    invoke-virtual {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setSimStateChange(Landroid/util/SparseArray;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 837
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    :cond_1
    return-void
.end method

.method public writeAudioCodecGsmCdma(II)V
    .locals 2

    .line 2890
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p1, :cond_0

    .line 2892
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string p1, "Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 2896
    :cond_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertGsmCdmaCodec(I)I

    move-result p2

    .line 2897
    new-instance v0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v1, 0x16

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2899
    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setAudioCodec(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object v0

    .line 2897
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    .line 2901
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Logged Audio Codec event. Value: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    return-void
.end method

.method public writeAudioCodecIms(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 3

    .line 2865
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p1, :cond_0

    .line 2867
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string p1, "Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 2871
    :cond_0
    invoke-virtual {p2}, Landroid/telephony/ims/ImsCallSession;->getLocalCallProfile()Landroid/telephony/ims/ImsCallProfile;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 2873
    iget-object v0, v0, Landroid/telephony/ims/ImsCallProfile;->mMediaProfile:Landroid/telephony/ims/ImsStreamMediaProfile;

    iget v0, v0, Landroid/telephony/ims/ImsStreamMediaProfile;->mAudioQuality:I

    invoke-static {v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertImsCodec(I)I

    move-result v0

    .line 2874
    new-instance v1, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v2, 0x16

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2876
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getCallId(Landroid/telephony/ims/ImsCallSession;)I

    move-result p2

    invoke-virtual {v1, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallIndex(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 2877
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setAudioCodec(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 2874
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    .line 2879
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "Logged Audio Codec event. Value: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    :cond_1
    return-void
.end method

.method public declared-synchronized writeBandwidthStats(IIIIIII)V
    .locals 4

    monitor-enter p0

    .line 2968
    :try_start_0
    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->lookupEstimationStats(III)Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;

    move-result-object p1

    .line 2969
    iget-object p2, p1, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mBwEstErrorAcc:[J

    aget-wide v0, p2, p4

    invoke-static {p5}, Ljava/lang/Math;->abs(I)I

    move-result p3

    int-to-long v2, p3

    add-long/2addr v0, v2

    aput-wide v0, p2, p4

    .line 2970
    iget-object p2, p1, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mStaticBwErrorAcc:[J

    aget-wide v0, p2, p4

    invoke-static {p6}, Ljava/lang/Math;->abs(I)I

    move-result p3

    int-to-long p5, p3

    add-long/2addr v0, p5

    aput-wide v0, p2, p4

    .line 2971
    iget-object p2, p1, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mBwAccKbps:[J

    aget-wide p5, p2, p4

    int-to-long v0, p7

    add-long/2addr p5, v0

    aput-wide p5, p2, p4

    .line 2972
    iget-object p1, p1, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mCount:[I

    aget p2, p1, p4

    add-int/lit8 p2, p2, 0x1

    aput p2, p1, p4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 2973
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public writeCarrierIdMatchingEvent(IIILjava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;)V
    .locals 3

    .line 2644
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatching;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatching;-><init>()V

    .line 2645
    new-instance v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;-><init>()V

    const/4 v2, -0x1

    if-eq p3, v2, :cond_0

    .line 2650
    iput p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->carrierId:I

    if-eqz p5, :cond_1

    .line 2653
    iput-object p4, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->unknownMccmnc:Ljava/lang/String;

    .line 2654
    iput-object p5, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->unknownGid1:Ljava/lang/String;

    goto :goto_0

    :cond_0
    if-eqz p4, :cond_1

    .line 2659
    iput-object p4, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->unknownMccmnc:Ljava/lang/String;

    .line 2664
    :cond_1
    :goto_0
    iget-object p3, p6, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->mccMnc:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/util/TelephonyUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    iput-object p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->mccmnc:Ljava/lang/String;

    .line 2665
    iget-object p3, p6, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->spn:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/util/TelephonyUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    iput-object p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->spn:Ljava/lang/String;

    .line 2666
    iget-object p3, p6, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->plmn:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/util/TelephonyUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    iput-object p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->pnn:Ljava/lang/String;

    .line 2667
    iget-object p3, p6, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid1:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/util/TelephonyUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    iput-object p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->gid1:Ljava/lang/String;

    .line 2668
    iget-object p3, p6, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->gid2:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/util/TelephonyUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    iput-object p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->gid2:Ljava/lang/String;

    .line 2669
    iget-object p3, p6, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->imsiPrefixPattern:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/util/TelephonyUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    iput-object p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->imsiPrefix:Ljava/lang/String;

    .line 2670
    iget-object p3, p6, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->iccidPrefix:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/util/TelephonyUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    iput-object p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->iccidPrefix:Ljava/lang/String;

    .line 2671
    iget-object p3, p6, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->apn:Ljava/lang/String;

    invoke-static {p3}, Lcom/android/internal/telephony/util/TelephonyUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    iput-object p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->preferApn:Ljava/lang/String;

    .line 2672
    iget-object p3, p6, Lcom/android/internal/telephony/CarrierResolver$CarrierMatchingRule;->privilegeAccessRule:Ljava/util/List;

    if-eqz p3, :cond_2

    .line 2674
    invoke-interface {p3}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p3

    new-instance p4, Lcom/android/internal/telephony/metrics/TelephonyMetrics$$ExternalSyntheticLambda2;

    invoke-direct {p4}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$$ExternalSyntheticLambda2;-><init>()V

    invoke-interface {p3, p4}, Ljava/util/stream/Stream;->toArray(Ljava/util/function/IntFunction;)[Ljava/lang/Object;

    move-result-object p3

    check-cast p3, [Ljava/lang/String;

    iput-object p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;->privilegeAccessRule:[Ljava/lang/String;

    .line 2677
    :cond_2
    iput p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatching;->cidTableVersion:I

    .line 2678
    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatching;->result:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatchingResult;

    .line 2680
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setCarrierIdMatching(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierIdMatching;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p2

    .line 2681
    invoke-virtual {p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p2

    .line 2682
    iget-object p3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastCarrierId:Landroid/util/SparseArray;

    invoke-virtual {p3, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 2683
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeCarrierKeyEvent(IIZ)V
    .locals 1

    .line 910
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierKeyChange;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierKeyChange;-><init>()V

    .line 911
    iput p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierKeyChange;->keyType:I

    .line 912
    iput-boolean p3, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierKeyChange;->isDownloadSuccessful:Z

    .line 913
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setCarrierKeyChange(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$CarrierKeyChange;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    .line 914
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 915
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeDataStallEvent(II)V
    .locals 1

    .line 1247
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    .line 1248
    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setDataStallRecoveryAction(I)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 1247
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeDataSwitch(ILcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$DataSwitch;)V
    .locals 1

    .line 1992
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->getPhoneId(I)I

    move-result p1

    .line 1993
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setDataSwitch(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$DataSwitch;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeDroppedIncomingMultipartSms(ILjava/lang/String;II)V
    .locals 2

    .line 2403
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Logged dropped multipart SMS: received "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " out of "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    .line 2406
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;-><init>()V

    .line 2407
    iput p3, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;->receivedParts:I

    .line 2408
    iput p4, v0, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;->totalParts:I

    .line 2410
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewSmsSession(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    move-result-object p1

    .line 2411
    new-instance p3, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/16 p4, 0xa

    invoke-direct {p3, p4}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 2413
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertSmsFormat(Ljava/lang/String;)I

    move-result p2

    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setFormat(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2414
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setIncompleteSms(Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$IncompleteSms;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2411
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 2416
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishSmsSession(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;

    return-void
.end method

.method public writeEmergencyNumberUpdateEvent(ILandroid/telephony/emergency/EmergencyNumber;I)V
    .locals 1

    if-nez p2, :cond_0

    return-void

    .line 2697
    :cond_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertEmergencyNumberToEmergencyNumberInfo(Landroid/telephony/emergency/EmergencyNumber;)Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    move-result-object p2

    .line 2699
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {v0, p2, p3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setUpdatedEmergencyNumber(Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;I)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    .line 2700
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 2701
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeImsCallState(ILandroid/telephony/ims/ImsCallSession;Lcom/android/internal/telephony/Call$State;)V
    .locals 2

    .line 2074
    sget-object v0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$1;->$SwitchMap$com$android$internal$telephony$Call$State:[I

    invoke-virtual {p3}, Ljava/lang/Enum;->ordinal()I

    move-result p3

    aget p3, v0, p3

    packed-switch p3, :pswitch_data_0

    const/4 p3, 0x0

    goto :goto_0

    :pswitch_0
    const/16 p3, 0x9

    goto :goto_0

    :pswitch_1
    const/16 p3, 0x8

    goto :goto_0

    :pswitch_2
    const/4 p3, 0x7

    goto :goto_0

    :pswitch_3
    const/4 p3, 0x6

    goto :goto_0

    :pswitch_4
    const/4 p3, 0x5

    goto :goto_0

    :pswitch_5
    const/4 p3, 0x4

    goto :goto_0

    :pswitch_6
    const/4 p3, 0x3

    goto :goto_0

    :pswitch_7
    const/4 p3, 0x2

    goto :goto_0

    :pswitch_8
    const/4 p3, 0x1

    .line 2097
    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p1, :cond_0

    .line 2099
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string p1, "Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 2101
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v1, 0x10

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2103
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getCallId(Landroid/telephony/ims/ImsCallSession;)I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallIndex(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 2104
    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallState(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 2101
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    :goto_1
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public declared-synchronized writeImsServiceSendSms(ILjava/lang/String;IJ)V
    .locals 2

    monitor-enter p0

    .line 2340
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewSmsSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    move-result-object p1

    .line 2341
    new-instance v0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/4 v1, 0x6

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    const/4 v1, 0x3

    .line 2342
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setTech(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v0

    .line 2343
    invoke-virtual {v0, p3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setImsServiceErrno(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p3

    .line 2344
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertSmsFormat(Ljava/lang/String;)I

    move-result p2

    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setFormat(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2345
    invoke-virtual {p2, p4, p5}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setMessageId(J)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2341
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 2348
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->increaseExpectedResponse()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 2349
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized writeImsSetFeatureValue(IIII)V
    .locals 4

    monitor-enter p0

    .line 1286
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->cloneCurrentTelephonySettings(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;

    move-result-object v0

    const/4 v1, 0x2

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-nez p3, :cond_4

    if-eq p2, v3, :cond_2

    if-eq p2, v1, :cond_0

    goto :goto_0

    :cond_0
    if-eqz p4, :cond_1

    move v2, v3

    .line 1293
    :cond_1
    iput-boolean v2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isVtOverLteEnabled:Z

    goto :goto_0

    :cond_2
    if-eqz p4, :cond_3

    move v2, v3

    .line 1290
    :cond_3
    iput-boolean v2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isEnhanced4GLteModeEnabled:Z

    goto :goto_0

    :cond_4
    if-ne p3, v3, :cond_9

    if-eq p2, v3, :cond_7

    if-eq p2, v1, :cond_5

    goto :goto_0

    :cond_5
    if-eqz p4, :cond_6

    move v2, v3

    .line 1302
    :cond_6
    iput-boolean v2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isVtOverWifiEnabled:Z

    goto :goto_0

    :cond_7
    if-eqz p4, :cond_8

    move v2, v3

    .line 1299
    :cond_8
    iput-boolean v2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->isWifiCallingEnabled:Z

    .line 1308
    :cond_9
    :goto_0
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSettings:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    if-eqz p2, :cond_a

    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSettings:Landroid/util/SparseArray;

    .line 1309
    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    invoke-static {p2}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p2

    .line 1310
    invoke-static {v0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p3

    .line 1309
    invoke-static {p2, p3}, Ljava/util/Arrays;->equals([B[B)Z

    move-result p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p2, :cond_a

    .line 1311
    monitor-exit p0

    return-void

    .line 1314
    :cond_a
    :try_start_1
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSettings:Landroid/util/SparseArray;

    invoke-virtual {p2, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1316
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setSettings(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p2

    invoke-virtual {p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p2

    .line 1317
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    .line 1319
    iget-wide p3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    new-instance v1, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    invoke-direct {v1, v3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 1321
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setSettings(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object v1

    .line 1319
    invoke-direct {p0, p3, p4, p1, v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->annotateInProgressCallSession(JILcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    .line 1322
    iget-wide p2, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    new-instance p4, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    invoke-direct {p4, v3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 1324
    invoke-virtual {p4, v0}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setSettings(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p4

    .line 1322
    invoke-direct {p0, p2, p3, p1, p4}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->annotateInProgressSmsSession(JILcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1325
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public writeIncomingSMSPP(ILjava/lang/String;Z)V
    .locals 2

    .line 2447
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Logged SMS-PP session. Result = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    const/4 v0, 0x1

    .line 2448
    invoke-direct {p0, p1, v0, p2, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingSmsWithType(IILjava/lang/String;Z)V

    return-void
.end method

.method public writeIncomingSmsError(IZII)V
    .locals 3

    .line 2567
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Incoming SMS error = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    const/4 v0, 0x1

    if-eq p4, v0, :cond_3

    const/4 v1, 0x3

    if-eq p4, v1, :cond_1

    const/4 v1, 0x4

    if-eq p4, v1, :cond_0

    move p4, v0

    goto :goto_0

    :cond_0
    const/16 p4, 0x18

    goto :goto_0

    :cond_1
    const/16 p4, 0xd

    .line 2586
    :goto_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewSmsSession(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    move-result-object p1

    .line 2588
    new-instance v1, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/16 v2, 0x8

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    if-eqz p2, :cond_2

    const/4 v0, 0x2

    .line 2590
    :cond_2
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setFormat(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object v0

    .line 2593
    invoke-direct {p0, p3, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getSmsTech(IZ)I

    move-result p2

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setTech(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2594
    invoke-virtual {p2, p4}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setErrorCode(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2595
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 2596
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishSmsSession(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession;

    :cond_3
    return-void
.end method

.method public writeIncomingSmsSession(IILjava/lang/String;[JZJ)V
    .locals 10

    const/4 v2, 0x0

    const/4 v7, 0x1

    move-object v0, p0

    move v1, p1

    move v3, p2

    move-object v4, p3

    move-object v5, p4

    move v6, p5

    move-wide/from16 v8, p6

    .line 2553
    invoke-direct/range {v0 .. v9}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingSmsSessionWithType(IIILjava/lang/String;[JZZJ)V

    return-void
.end method

.method public writeIncomingSmsTypeZero(ILjava/lang/String;)V
    .locals 2

    const-string v0, "Logged Type-0 SMS message."

    .line 2473
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    const/4 v0, 0x3

    const/4 v1, 0x1

    .line 2474
    invoke-direct {p0, p1, v0, p2, v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingSmsWithType(IILjava/lang/String;Z)V

    return-void
.end method

.method public writeIncomingVoiceMailSms(ILjava/lang/String;)V
    .locals 2

    const-string v0, "Logged VoiceMail message."

    .line 2460
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    const/4 v0, 0x2

    const/4 v1, 0x1

    .line 2461
    invoke-direct {p0, p1, v0, p2, v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingSmsWithType(IILjava/lang/String;Z)V

    return-void
.end method

.method public writeIncomingWapPush(IILjava/lang/String;[JZJ)V
    .locals 10

    const/4 v2, 0x4

    const/4 v6, 0x0

    move-object v0, p0

    move v1, p1

    move v3, p2

    move-object v4, p3

    move-object v5, p4

    move v7, p5

    move-wide/from16 v8, p6

    .line 2536
    invoke-direct/range {v0 .. v9}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeIncomingSmsSessionWithType(IIILjava/lang/String;[JZZJ)V

    return-void
.end method

.method public writeModemRestartEvent(ILjava/lang/String;)V
    .locals 2

    .line 2622
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$ModemRestart;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$ModemRestart;-><init>()V

    .line 2623
    invoke-static {}, Landroid/os/Build;->getRadioVersion()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 2624
    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$ModemRestart;->basebandVersion:Ljava/lang/String;

    :cond_0
    if-eqz p2, :cond_1

    .line 2625
    iput-object p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$ModemRestart;->reason:Ljava/lang/String;

    .line 2626
    :cond_1
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setModemRestart(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$ModemRestart;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    .line 2627
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 2628
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeNITZEvent(IJ)V
    .locals 4

    .line 2606
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {v0, p2, p3}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setNITZ(J)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v0

    .line 2607
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    .line 2609
    iget-wide v0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    new-instance v2, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v3, 0x15

    invoke-direct {v2, v3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2612
    invoke-virtual {v2, p2, p3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setNITZ(J)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 2609
    invoke-direct {p0, v0, v1, p1, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->annotateInProgressCallSession(JILcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    return-void
.end method

.method public writeNetworkCapabilitiesChangedEvent(ILandroid/net/NetworkCapabilities;)V
    .locals 2

    .line 2712
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$NetworkCapabilitiesInfo;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$NetworkCapabilitiesInfo;-><init>()V

    const/16 v1, 0x19

    .line 2713
    invoke-virtual {p2, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$NetworkCapabilitiesInfo;->isNetworkUnmetered:Z

    .line 2716
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    .line 2717
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setNetworkCapabilities(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$NetworkCapabilitiesInfo;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p2

    invoke-virtual {p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p2

    .line 2718
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastNetworkCapabilitiesInfos:Landroid/util/SparseArray;

    invoke-virtual {v1, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 2719
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeNetworkValidate(I)V
    .locals 1

    .line 1982
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>()V

    .line 1983
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setNetworkValidate(I)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 1982
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public declared-synchronized writeNewCBSms(IIIZZIIJ)V
    .locals 1

    monitor-enter p0

    .line 2366
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewSmsSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    move-result-object p1

    const/4 v0, 0x1

    if-eqz p4, :cond_0

    const/4 p4, 0x2

    goto :goto_0

    :cond_0
    if-eqz p5, :cond_1

    move p4, v0

    goto :goto_0

    :cond_1
    const/4 p4, 0x3

    .line 2377
    :goto_0
    new-instance p5, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;

    invoke-direct {p5}, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;-><init>()V

    .line 2378
    iput p2, p5, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;->msgFormat:I

    add-int/2addr p3, v0

    .line 2379
    iput p3, p5, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;->msgPriority:I

    .line 2380
    iput p4, p5, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;->msgType:I

    .line 2381
    iput p6, p5, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;->serviceCategory:I

    .line 2382
    iput p7, p5, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;->serialNumber:I

    .line 2383
    iput-wide p8, p5, Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;->deliveredTimestampMillis:J

    .line 2385
    new-instance p2, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/16 p3, 0x9

    invoke-direct {p2, p3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 2386
    invoke-virtual {p2, p5}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setCellBroadcastMessage(Lcom/android/internal/telephony/nano/TelephonyProto$SmsSession$Event$CBMessage;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2385
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 2389
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishSmsSessionIfNeeded(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 2390
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public writeOnDemandDataSwitch(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;)V
    .locals 1

    .line 2001
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>()V

    .line 2002
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setOnDemandDataSwitch(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$OnDemandDataSwitch;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 2001
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeOnImsCallHandoverEvent(IILandroid/telephony/ims/ImsCallSession;IILandroid/telephony/ims/ImsReasonInfo;)V
    .locals 1

    .line 2290
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p1, :cond_0

    .line 2292
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string p1, "Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 2294
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    invoke-direct {v0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2296
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getCallId(Landroid/telephony/ims/ImsCallSession;)I

    move-result p2

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallIndex(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 2297
    invoke-virtual {p2, p4}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setSrcAccessTech(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 2298
    invoke-virtual {p2, p5}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setTargetAccessTech(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 2299
    invoke-direct {p0, p6}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toImsReasonInfoProto(Landroid/telephony/ims/ImsReasonInfo;)Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;

    move-result-object p0

    invoke-virtual {p2, p0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setImsReasonInfo(Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 2294
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    :goto_0
    return-void
.end method

.method public writeOnImsCallHeld(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallHoldFailed(ILandroid/telephony/ims/ImsCallSession;Landroid/telephony/ims/ImsReasonInfo;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallHoldReceived(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallInitiating(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallProgressing(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallReceive(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 2

    .line 2130
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewCallSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressCallSession;

    move-result-object p1

    .line 2132
    new-instance v0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v1, 0xf

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2134
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getCallId(Landroid/telephony/ims/ImsCallSession;)I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallIndex(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 2132
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    return-void
.end method

.method public writeOnImsCallResumeFailed(ILandroid/telephony/ims/ImsCallSession;Landroid/telephony/ims/ImsReasonInfo;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallResumeReceived(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallResumed(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallStart(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 2

    .line 2115
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewCallSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressCallSession;

    move-result-object p1

    .line 2117
    new-instance v0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v1, 0xb

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2119
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getCallId(Landroid/telephony/ims/ImsCallSession;)I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallIndex(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    const/4 p2, 0x1

    .line 2120
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setImsCommand(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 2117
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    return-void
.end method

.method public writeOnImsCallStartFailed(ILandroid/telephony/ims/ImsCallSession;Landroid/telephony/ims/ImsReasonInfo;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallStarted(ILandroid/telephony/ims/ImsCallSession;)V
    .locals 0

    return-void
.end method

.method public writeOnImsCallTerminated(ILandroid/telephony/ims/ImsCallSession;Landroid/telephony/ims/ImsReasonInfo;Lcom/android/internal/telephony/metrics/CallQualityMetrics;Landroid/telephony/emergency/EmergencyNumber;Ljava/lang/String;I)V
    .locals 3

    .line 2248
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p1, :cond_0

    .line 2250
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string p1, "Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 2252
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v1, 0x11

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2254
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getCallId(Landroid/telephony/ims/ImsCallSession;)I

    move-result p2

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallIndex(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    .line 2255
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toImsReasonInfoProto(Landroid/telephony/ims/ImsReasonInfo;)Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;

    move-result-object p2

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setImsReasonInfo(Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    if-eqz p4, :cond_1

    .line 2258
    invoke-virtual {p4}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->getCallQualitySummaryDl()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;

    move-result-object p2

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallQualitySummaryDl(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 2259
    invoke-virtual {p4}, Lcom/android/internal/telephony/metrics/CallQualityMetrics;->getCallQualitySummaryUl()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;

    move-result-object p3

    invoke-virtual {p2, p3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallQualitySummaryUl(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$CallQualitySummary;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    :cond_1
    if-eqz p5, :cond_2

    .line 2264
    invoke-static {}, Ljava/util/concurrent/ThreadLocalRandom;->current()Ljava/util/concurrent/ThreadLocalRandom;

    move-result-object p2

    const-wide/16 p3, 0x0

    const-wide/high16 v1, 0x4059000000000000L    # 100.0

    invoke-virtual {p2, p3, p4, v1, v2}, Ljava/util/concurrent/ThreadLocalRandom;->nextDouble(DD)D

    move-result-wide p2

    .line 2265
    invoke-direct {p0, p6}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getSamplePercentageForEmergencyCall(Ljava/lang/String;)D

    move-result-wide v1

    cmpg-double p2, p2, v1

    if-gez p2, :cond_2

    const/4 p2, 0x1

    .line 2266
    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setIsImsEmergencyCall(Z)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    .line 2268
    invoke-direct {p0, p5}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertEmergencyNumberToEmergencyNumberInfo(Landroid/telephony/emergency/EmergencyNumber;)Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;

    move-result-object p0

    .line 2267
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setImsEmergencyNumberInfo(Lcom/android/internal/telephony/nano/TelephonyProto$EmergencyNumberInfo;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    .line 2269
    invoke-virtual {v0, p7}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setEmergencyNumberDatabaseVersion(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    .line 2273
    :cond_2
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    :goto_0
    return-void
.end method

.method public declared-synchronized writeOnImsCapabilities(IILandroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;)V
    .locals 4

    monitor-enter p0

    .line 1407
    :try_start_0
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;-><init>()V

    const/4 v1, 0x2

    const/4 v2, 0x1

    const/4 v3, 0x4

    if-nez p2, :cond_0

    .line 1410
    invoke-virtual {p3, v2}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;->isCapable(I)Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;->voiceOverLte:Z

    .line 1412
    invoke-virtual {p3, v1}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;->isCapable(I)Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;->videoOverLte:Z

    .line 1414
    invoke-virtual {p3, v3}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;->isCapable(I)Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;->utOverLte:Z

    goto :goto_0

    :cond_0
    if-ne p2, v2, :cond_1

    .line 1418
    invoke-virtual {p3, v2}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;->isCapable(I)Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;->voiceOverWifi:Z

    .line 1420
    invoke-virtual {p3, v1}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;->isCapable(I)Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;->videoOverWifi:Z

    .line 1422
    invoke-virtual {p3, v3}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;->isCapable(I)Z

    move-result p2

    iput-boolean p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;->utOverWifi:Z

    .line 1426
    :cond_1
    :goto_0
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setImsCapabilities(Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p2

    invoke-virtual {p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p2

    .line 1429
    iget-object p3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsCapabilities:Landroid/util/SparseArray;

    invoke-virtual {p3, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    if-eqz p3, :cond_2

    iget-object p3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsCapabilities:Landroid/util/SparseArray;

    .line 1430
    invoke-virtual {p3, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    invoke-static {p3}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p3

    .line 1431
    invoke-static {v0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object v1

    .line 1430
    invoke-static {p3, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result p3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p3, :cond_2

    .line 1432
    monitor-exit p0

    return-void

    .line 1435
    :cond_2
    :try_start_1
    iget-object p3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsCapabilities:Landroid/util/SparseArray;

    invoke-virtual {p3, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1436
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    .line 1438
    iget-wide v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    new-instance p3, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    invoke-direct {p3, v3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    iget-object v2, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->imsCapabilities:Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;

    .line 1441
    invoke-virtual {p3, v2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setImsCapabilities(Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p3

    .line 1438
    invoke-direct {p0, v0, v1, p1, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->annotateInProgressCallSession(JILcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    .line 1442
    iget-wide v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    new-instance p3, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    invoke-direct {p3, v3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    iget-object p2, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->imsCapabilities:Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;

    .line 1445
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setImsCapabilities(Lcom/android/internal/telephony/nano/TelephonyProto$ImsCapabilities;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 1442
    invoke-direct {p0, v0, v1, p1, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->annotateInProgressSmsSession(JILcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1446
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public writeOnImsCommand(ILandroid/telephony/ims/ImsCallSession;I)V
    .locals 2

    .line 2146
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p1, :cond_0

    .line 2148
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string p1, "Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 2150
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v1, 0xb

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2152
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getCallId(Landroid/telephony/ims/ImsCallSession;)I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setCallIndex(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 2153
    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setImsCommand(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 2150
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    :goto_0
    return-void
.end method

.method public declared-synchronized writeOnImsConnectionState(IILandroid/telephony/ims/ImsReasonInfo;)V
    .locals 4

    monitor-enter p0

    .line 1359
    :try_start_0
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;-><init>()V

    .line 1360
    iput p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;->state:I

    if-eqz p3, :cond_1

    .line 1363
    new-instance p2, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;

    invoke-direct {p2}, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;-><init>()V

    .line 1365
    invoke-virtual {p3}, Landroid/telephony/ims/ImsReasonInfo;->getCode()I

    move-result v1

    iput v1, p2, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;->reasonCode:I

    .line 1366
    invoke-virtual {p3}, Landroid/telephony/ims/ImsReasonInfo;->getExtraCode()I

    move-result v1

    iput v1, p2, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;->extraCode:I

    .line 1367
    invoke-virtual {p3}, Landroid/telephony/ims/ImsReasonInfo;->getExtraMessage()Ljava/lang/String;

    move-result-object p3

    if-eqz p3, :cond_0

    .line 1369
    iput-object p3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;->extraMessage:Ljava/lang/String;

    .line 1372
    :cond_0
    iput-object p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;->reasonInfo:Lcom/android/internal/telephony/nano/TelephonyProto$ImsReasonInfo;

    .line 1376
    :cond_1
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsConnectionState:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    if-eqz p2, :cond_2

    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsConnectionState:Landroid/util/SparseArray;

    .line 1377
    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    invoke-static {p2}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p2

    .line 1378
    invoke-static {v0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p3

    .line 1377
    invoke-static {p2, p3}, Ljava/util/Arrays;->equals([B[B)Z

    move-result p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p2, :cond_2

    .line 1379
    monitor-exit p0

    return-void

    .line 1382
    :cond_2
    :try_start_1
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastImsConnectionState:Landroid/util/SparseArray;

    invoke-virtual {p2, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1384
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    .line 1385
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setImsConnectionState(Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p2

    invoke-virtual {p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p2

    .line 1386
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    .line 1388
    iget-wide v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    new-instance p3, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/4 v2, 0x3

    invoke-direct {p3, v2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    iget-object v3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->imsConnectionState:Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;

    .line 1391
    invoke-virtual {p3, v3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setImsConnectionState(Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p3

    .line 1388
    invoke-direct {p0, v0, v1, p1, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->annotateInProgressCallSession(JILcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    .line 1392
    iget-wide v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    new-instance p3, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    invoke-direct {p3, v2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    iget-object p2, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->imsConnectionState:Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;

    .line 1395
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setImsConnectionState(Lcom/android/internal/telephony/nano/TelephonyProto$ImsConnectionState;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 1392
    invoke-direct {p0, v0, v1, p1, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->annotateInProgressSmsSession(JILcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1396
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized writeOnImsServiceSmsSolicitedResponse(IIIJ)V
    .locals 2

    monitor-enter p0

    .line 1913
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressSmsSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    if-nez p1, :cond_0

    .line 1915
    sget-object p1, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string p2, "SMS session is missing"

    invoke-static {p1, p2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 1918
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/4 v1, 0x7

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 1920
    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setImsServiceErrno(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 1921
    invoke-virtual {p2, p3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setErrorCode(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 1922
    invoke-virtual {p2, p4, p5}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setMessageId(J)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 1918
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 1925
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->decreaseExpectedResponse()V

    .line 1926
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishSmsSessionIfNeeded(Lcom/android/internal/telephony/metrics/InProgressSmsSession;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1928
    :goto_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public writeOnRilSolicitedResponse(IIIILjava/lang/Object;)V
    .locals 7

    const/16 v0, 0xa

    if-eq p4, v0, :cond_2

    const/16 v0, 0x57

    if-eq p4, v0, :cond_1

    const/16 v0, 0x71

    if-eq p4, v0, :cond_1

    const/16 v0, 0x28

    if-eq p4, v0, :cond_2

    const/16 v0, 0x29

    if-eq p4, v0, :cond_0

    packed-switch p4, :pswitch_data_0

    packed-switch p4, :pswitch_data_1

    goto :goto_0

    .line 1954
    :pswitch_0
    move-object v6, p5

    check-cast v6, Landroid/telephony/data/DataCallResponse;

    move-object v1, p0

    move v2, p1

    move v3, p2

    move v4, p3

    move v5, p4

    .line 1955
    invoke-direct/range {v1 .. v6}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeOnSetupDataCallResponse(IIIILandroid/telephony/data/DataCallResponse;)V

    goto :goto_0

    .line 1958
    :cond_0
    invoke-direct {p0, p1, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeOnDeactivateDataCallResponse(II)V

    goto :goto_0

    .line 1971
    :cond_1
    :pswitch_1
    check-cast p5, Lcom/android/internal/telephony/SmsResponse;

    .line 1972
    invoke-direct {p0, p1, p2, p3, p5}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeOnSmsSolicitedResponse(IIILcom/android/internal/telephony/SmsResponse;)V

    goto :goto_0

    .line 1965
    :cond_2
    :pswitch_2
    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeOnCallSolicitedResponse(IIII)V

    :goto_0
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0xc
        :pswitch_2
        :pswitch_2
        :pswitch_2
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x19
        :pswitch_1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public writeOnRilTimeoutResponse(III)V
    .locals 0

    return-void
.end method

.method public writePhoneState(ILcom/android/internal/telephony/PhoneConstants$State;)V
    .locals 3

    .line 2013
    sget-object v0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$1;->$SwitchMap$com$android$internal$telephony$PhoneConstants$State:[I

    invoke-virtual {p2}, Lcom/android/internal/telephony/PhoneConstants$State;->ordinal()I

    move-result p2

    aget p2, v0, p2

    const/4 v0, 0x3

    const/4 v1, 0x2

    const/4 v2, 0x1

    if-eq p2, v2, :cond_1

    if-eq p2, v1, :cond_0

    if-eq p2, v0, :cond_2

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    move v0, v1

    goto :goto_0

    :cond_1
    move v0, v2

    .line 2028
    :cond_2
    :goto_0
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p1, :cond_3

    .line 2030
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string/jumbo p1, "writePhoneState: Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 2035
    :cond_3
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->setLastKnownPhoneState(I)V

    if-ne v0, v2, :cond_4

    .line 2037
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->containsCsCalls()Z

    move-result p2

    if-nez p2, :cond_4

    .line 2038
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishCallSession(Lcom/android/internal/telephony/metrics/InProgressCallSession;)V

    .line 2040
    :cond_4
    new-instance p0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 p2, 0x14

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 2042
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setPhoneState(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p0

    .line 2040
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    :goto_1
    return-void
.end method

.method public writeRadioState(II)V
    .locals 2

    .line 2724
    invoke-static {p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertRadioState(I)I

    move-result p2

    .line 2725
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setRadioState(I)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object v0

    .line 2726
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRadioState:Landroid/util/SparseArray;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {v1, p1, p2}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 2727
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeRilAnswer(II)V
    .locals 1

    .line 1750
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p0, :cond_0

    .line 1752
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string/jumbo p1, "writeRilAnswer: Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 1754
    :cond_0
    new-instance p1, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/4 v0, 0x6

    invoke-direct {p1, v0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    const/4 v0, 0x2

    .line 1756
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilRequest(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p1

    .line 1757
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilRequestId(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p1

    .line 1754
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    :goto_0
    return-void
.end method

.method public writeRilCallList(ILjava/util/ArrayList;Ljava/lang/String;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/GsmCdmaConnection;",
            ">;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .line 1570
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Logging CallList Changed Connections Size = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/util/ArrayList;->size()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    .line 1571
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewCallSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressCallSession;

    move-result-object p1

    if-nez p1, :cond_0

    .line 1573
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string/jumbo p1, "writeRilCallList: Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 1575
    :cond_0
    invoke-direct {p0, p2, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertConnectionsToRilCalls(Ljava/util/ArrayList;Ljava/lang/String;)[Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;

    move-result-object p2

    .line 1576
    new-instance p3, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v0, 0xa

    invoke-direct {p3, v0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 1579
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilCalls([Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p3

    .line 1576
    invoke-virtual {p1, p3}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    const-string p3, "Logged Call list changed"

    .line 1581
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    .line 1582
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->isPhoneIdle()Z

    move-result p3

    if-eqz p3, :cond_1

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->disconnectReasonsKnown([Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;)Z

    move-result p2

    if-eqz p2, :cond_1

    .line 1583
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->finishCallSession(Lcom/android/internal/telephony/metrics/InProgressCallSession;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public writeRilCallRing(I[C)V
    .locals 2

    .line 1712
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewCallSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressCallSession;

    move-result-object p0

    .line 1714
    iget-wide p1, p0, Lcom/android/internal/telephony/metrics/InProgressCallSession;->startElapsedTimeMs:J

    new-instance v0, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v1, 0x8

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    invoke-virtual {p0, p1, p2, v0}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(JLcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    return-void
.end method

.method public writeRilDataCallEvent(IIII)V
    .locals 3

    const/4 v0, 0x1

    new-array v0, v0, [Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;

    .line 1538
    new-instance v1, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;-><init>()V

    const/4 v2, 0x0

    aput-object v1, v0, v2

    .line 1539
    iput p2, v1, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;->cid:I

    .line 1540
    iput p3, v1, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;->apnTypeBitmask:I

    .line 1541
    iput p4, v1, Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;->state:I

    .line 1544
    iget-object p3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    invoke-virtual {p3, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    if-eqz p3, :cond_1

    .line 1546
    iget-object p3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    invoke-virtual {p3, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Landroid/util/SparseArray;

    invoke-virtual {p3, p2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    if-eqz p3, :cond_0

    iget-object p3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    .line 1548
    invoke-virtual {p3, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Landroid/util/SparseArray;

    invoke-virtual {p3, p2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    invoke-static {p3}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p3

    aget-object p4, v0, v2

    .line 1549
    invoke-static {p4}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p4

    .line 1547
    invoke-static {p3, p4}, Ljava/util/Arrays;->equals([B[B)Z

    move-result p3

    if-eqz p3, :cond_0

    return-void

    .line 1552
    :cond_0
    iget-object p3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    invoke-virtual {p3, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Landroid/util/SparseArray;

    goto :goto_0

    .line 1554
    :cond_1
    new-instance p3, Landroid/util/SparseArray;

    invoke-direct {p3}, Landroid/util/SparseArray;-><init>()V

    :goto_0
    aget-object p4, v0, v2

    .line 1557
    invoke-virtual {p3, p2, p4}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1558
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastRilDataCallEvents:Landroid/util/SparseArray;

    invoke-virtual {p2, p1, p3}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1559
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setDataCalls([Lcom/android/internal/telephony/nano/TelephonyProto$RilDataCall;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeRilDeactivateDataCall(IIII)V
    .locals 0

    .line 1508
    new-instance p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilDeactivateDataCall;

    invoke-direct {p2}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilDeactivateDataCall;-><init>()V

    .line 1509
    iput p3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilDeactivateDataCall;->cid:I

    const/4 p3, 0x1

    if-eq p4, p3, :cond_2

    const/4 p3, 0x2

    if-eq p4, p3, :cond_1

    const/4 p3, 0x3

    if-eq p4, p3, :cond_0

    const/4 p3, 0x0

    .line 1521
    iput p3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilDeactivateDataCall;->reason:I

    goto :goto_0

    :cond_0
    const/4 p3, 0x4

    .line 1518
    iput p3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilDeactivateDataCall;->reason:I

    goto :goto_0

    .line 1515
    :cond_1
    iput p3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilDeactivateDataCall;->reason:I

    goto :goto_0

    .line 1512
    :cond_2
    iput p3, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilDeactivateDataCall;->reason:I

    .line 1524
    :goto_0
    new-instance p3, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setDeactivateDataCall(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilDeactivateDataCall;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    .line 1525
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 1524
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeRilDial(ILcom/android/internal/telephony/GsmCdmaConnection;ILcom/android/internal/telephony/UUSInfo;)V
    .locals 3

    .line 1688
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewCallSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressCallSession;

    move-result-object p1

    .line 1689
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "Logging Dial Connection = "

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-direct {p0, p3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    if-nez p1, :cond_0

    .line 1691
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string/jumbo p1, "writeRilDial: Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_0
    const/4 p3, 0x1

    new-array p4, p3, [Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;

    const/4 v0, 0x0

    .line 1694
    new-instance v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;-><init>()V

    aput-object v1, p4, v0

    const/4 v0, -0x1

    .line 1695
    iput v0, v1, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->index:I

    const-string v0, ""

    .line 1696
    invoke-direct {p0, p2, v1, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertConnectionToRilCall(Lcom/android/internal/telephony/GsmCdmaConnection;Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;Ljava/lang/String;)V

    .line 1697
    iget-wide v0, p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;->startElapsedTimeMs:J

    new-instance p2, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/4 v2, 0x6

    invoke-direct {p2, v2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    .line 1699
    invoke-virtual {p2, p3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilRequest(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 1700
    invoke-virtual {p2, p4}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilCalls([Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 1697
    invoke-virtual {p1, v0, v1, p2}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(JLcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    const-string p1, "Logged Dial event"

    .line 1701
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public writeRilHangup(ILcom/android/internal/telephony/GsmCdmaConnection;ILjava/lang/String;)V
    .locals 3

    .line 1727
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p1, :cond_0

    .line 1729
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string/jumbo p1, "writeRilHangup: Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    new-array v0, v0, [Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;

    const/4 v1, 0x0

    .line 1732
    new-instance v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;

    invoke-direct {v2}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;-><init>()V

    aput-object v2, v0, v1

    .line 1733
    iput p3, v2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;->index:I

    .line 1734
    invoke-direct {p0, p2, v2, p4}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->convertConnectionToRilCall(Lcom/android/internal/telephony/GsmCdmaConnection;Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;Ljava/lang/String;)V

    .line 1735
    new-instance p2, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/4 p3, 0x6

    invoke-direct {p2, p3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    const/4 p3, 0x3

    .line 1737
    invoke-virtual {p2, p3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilRequest(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 1738
    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setRilCalls([Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyCallSession$Event$RilCall;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p2

    .line 1735
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    const-string p1, "Logged Hangup event"

    .line 1739
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->logv(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public declared-synchronized writeRilSendSms(IIIIJ)V
    .locals 2

    monitor-enter p0

    .line 2315
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->startNewSmsSessionIfNeeded(I)Lcom/android/internal/telephony/metrics/InProgressSmsSession;

    move-result-object p1

    .line 2317
    new-instance v0, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    const/4 v1, 0x6

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    .line 2318
    invoke-virtual {v0, p3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setTech(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p3

    .line 2319
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setRilRequestId(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2320
    invoke-virtual {p2, p4}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setFormat(I)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2321
    invoke-virtual {p2, p5, p6}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setMessageId(J)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 2317
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->addEvent(Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V

    .line 2324
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/InProgressSmsSession;->increaseExpectedResponse()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 2325
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public writeRilSrvcc(II)V
    .locals 1

    .line 1768
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mInProgressCallSessions:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/metrics/InProgressCallSession;

    if-nez p0, :cond_0

    .line 1770
    sget-object p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->TAG:Ljava/lang/String;

    const-string/jumbo p1, "writeRilSrvcc: Call session is missing"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 1772
    :cond_0
    new-instance p1, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/16 v0, 0x9

    invoke-direct {p1, v0}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    add-int/lit8 p2, p2, 0x1

    .line 1774
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setSrvccState(I)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object p1

    .line 1772
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/InProgressCallSession;->addEvent(Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    :goto_0
    return-void
.end method

.method public declared-synchronized writeServiceStateChanged(ILandroid/telephony/ServiceState;)V
    .locals 5

    monitor-enter p0

    .line 1217
    :try_start_0
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    .line 1218
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->toServiceStateProto(Landroid/telephony/ServiceState;)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    move-result-object p2

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setServiceState(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p2

    invoke-virtual {p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p2

    .line 1221
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastServiceState:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastServiceState:Landroid/util/SparseArray;

    .line 1222
    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    invoke-static {v0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object v0

    iget-object v1, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    .line 1223
    invoke-static {v1}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object v1

    .line 1222
    invoke-static {v0, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    .line 1224
    monitor-exit p0

    return-void

    .line 1227
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastServiceState:Landroid/util/SparseArray;

    iget-object v1, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    invoke-virtual {v0, p1, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1228
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    .line 1230
    iget-wide v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    new-instance v2, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    const/4 v3, 0x2

    invoke-direct {v2, v3}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;-><init>(I)V

    iget-object v4, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    .line 1233
    invoke-virtual {v2, v4}, Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;->setServiceState(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;)Lcom/android/internal/telephony/metrics/CallSessionEventBuilder;

    move-result-object v2

    .line 1230
    invoke-direct {p0, v0, v1, p1, v2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->annotateInProgressCallSession(JILcom/android/internal/telephony/metrics/CallSessionEventBuilder;)V

    .line 1234
    iget-wide v0, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->timestampMillis:J

    new-instance v2, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    invoke-direct {v2, v3}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;-><init>(I)V

    iget-object p2, p2, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;->serviceState:Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;

    .line 1237
    invoke-virtual {v2, p2}, Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;->setServiceState(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyServiceState;)Lcom/android/internal/telephony/metrics/SmsSessionEventBuilder;

    move-result-object p2

    .line 1234
    invoke-direct {p0, v0, v1, p1, p2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->annotateInProgressSmsSession(JILcom/android/internal/telephony/metrics/SmsSessionEventBuilder;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1238
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized writeSetPreferredNetworkType(II)V
    .locals 2

    monitor-enter p0

    .line 1335
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->cloneCurrentTelephonySettings(I)Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;

    move-result-object v0

    add-int/lit8 p2, p2, 0x1

    .line 1336
    iput p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;->preferredNetworkMode:I

    .line 1339
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSettings:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    if-eqz p2, :cond_0

    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSettings:Landroid/util/SparseArray;

    .line 1340
    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/protobuf/nano/MessageNano;

    invoke-static {p2}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object p2

    .line 1341
    invoke-static {v0}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object v1

    .line 1340
    invoke-static {p2, v1}, Ljava/util/Arrays;->equals([B[B)Z

    move-result p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p2, :cond_0

    .line 1342
    monitor-exit p0

    return-void

    .line 1345
    :cond_0
    :try_start_1
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->mLastSettings:Landroid/util/SparseArray;

    invoke-virtual {p2, p1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 1347
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setSettings(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonySettings;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1348
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public writeSetupDataCall(IIILjava/lang/String;I)V
    .locals 1

    .line 1485
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCall;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCall;-><init>()V

    .line 1486
    iput p2, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCall;->rat:I

    add-int/lit8 p3, p3, 0x1

    .line 1487
    iput p3, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCall;->dataProfile:I

    if-eqz p4, :cond_0

    .line 1489
    iput-object p4, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCall;->apn:Ljava/lang/String;

    :cond_0
    add-int/lit8 p5, p5, 0x1

    .line 1492
    iput p5, v0, Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCall;->type:I

    .line 1494
    new-instance p2, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setSetupDataCall(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent$RilSetupDataCall;)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    .line 1495
    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 1494
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method

.method public writeSignalStrengthEvent(II)V
    .locals 1

    .line 1258
    new-instance v0, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;-><init>(I)V

    .line 1259
    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->setSignalStrength(I)Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/metrics/TelephonyEventBuilder;->build()Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;

    move-result-object p1

    .line 1258
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->addTelephonyEvent(Lcom/android/internal/telephony/nano/TelephonyProto$TelephonyEvent;)V

    return-void
.end method
