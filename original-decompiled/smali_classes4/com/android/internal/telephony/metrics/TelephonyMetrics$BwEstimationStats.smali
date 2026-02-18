.class Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;
.super Ljava/lang/Object;
.source "TelephonyMetrics.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/TelephonyMetrics;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "BwEstimationStats"
.end annotation


# instance fields
.field final mBwAccKbps:[J

.field final mBwEstErrorAcc:[J

.field final mCount:[I

.field final mNrMode:I

.field final mRadioTechnology:I

.field final mStaticBwErrorAcc:[J


# direct methods
.method static bridge synthetic -$$Nest$mwriteBandwidthStats(Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;)Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->writeBandwidthStats()Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;

    move-result-object p0

    return-object p0
.end method

.method constructor <init>(II)V
    .locals 2

    .line 3012
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x5

    new-array v1, v0, [J

    .line 3007
    iput-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mBwEstErrorAcc:[J

    new-array v1, v0, [J

    .line 3008
    iput-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mStaticBwErrorAcc:[J

    new-array v1, v0, [J

    .line 3009
    iput-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mBwAccKbps:[J

    new-array v0, v0, [I

    .line 3010
    iput-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mCount:[I

    .line 3013
    iput p1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mRadioTechnology:I

    .line 3014
    iput p2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mNrMode:I

    return-void
.end method

.method private calculateAvg(JI)I
    .locals 2

    if-lez p3, :cond_0

    int-to-long v0, p3

    .line 3075
    div-long/2addr p1, v0

    long-to-int p0, p1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private printAvgValues([J[I)Ljava/lang/String;
    .locals 5

    .line 3037
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v1, 0x0

    :goto_0
    const/4 v2, 0x5

    if-ge v1, v2, :cond_0

    .line 3039
    aget-wide v2, p1, v1

    aget v4, p2, v1

    invoke-direct {p0, v2, v3, v4}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->calculateAvg(JI)I

    move-result v2

    .line 3040
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, " "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 3042
    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private printValues([I)Ljava/lang/String;
    .locals 3

    .line 3029
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v0, 0x0

    :goto_0
    const/4 v1, 0x5

    if-ge v0, v1, :cond_0

    .line 3031
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget v2, p1, v0

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 3033
    :cond_0
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private writeBandwidthStats()Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;
    .locals 5

    .line 3046
    new-instance v0, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;-><init>()V

    .line 3047
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    const/4 v4, 0x5

    if-ge v3, v4, :cond_1

    .line 3049
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->writeBandwidthStatsPerLevel(I)Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;

    move-result-object v4

    if-eqz v4, :cond_0

    .line 3051
    invoke-interface {v1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 3054
    :cond_1
    iget v3, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mRadioTechnology:I

    iput v3, v0, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;->rat:I

    new-array v2, v2, [Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;

    .line 3055
    invoke-interface {v1, v2}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;->perLevel:[Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;

    .line 3056
    iget p0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mNrMode:I

    iput p0, v0, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerRat;->nrMode:I

    return-object v0
.end method

.method private writeBandwidthStatsPerLevel(I)Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;
    .locals 4

    .line 3061
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mCount:[I

    aget v0, v0, p1

    if-lez v0, :cond_0

    .line 3063
    new-instance v1, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;-><init>()V

    .line 3064
    iput p1, v1, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;->signalLevel:I

    .line 3065
    iput v0, v1, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;->count:I

    .line 3066
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mBwAccKbps:[J

    aget-wide v2, v2, p1

    invoke-direct {p0, v2, v3, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->calculateAvg(JI)I

    move-result v2

    iput v2, v1, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;->avgBwKbps:I

    .line 3067
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mStaticBwErrorAcc:[J

    aget-wide v2, v2, p1

    invoke-direct {p0, v2, v3, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->calculateAvg(JI)I

    move-result v2

    iput v2, v1, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;->staticBwErrorPercent:I

    .line 3068
    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mBwEstErrorAcc:[J

    aget-wide v2, v2, p1

    invoke-direct {p0, v2, v3, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->calculateAvg(JI)I

    move-result p0

    iput p0, v1, Lcom/android/internal/telephony/nano/TelephonyProto$BandwidthEstimatorStats$PerLevel;->bwEstErrorPercent:I

    return-object v1

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 3

    .line 3019
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 3020
    iget v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mRadioTechnology:I

    iget v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mNrMode:I

    invoke-static {v1, v2}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getDataRatName(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n Count\n"

    .line 3021
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mCount:[I

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->printValues([I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n AvgKbps\n"

    .line 3022
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mBwAccKbps:[J

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mCount:[I

    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->printAvgValues([J[I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n BwEst Error\n"

    .line 3023
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mBwEstErrorAcc:[J

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mCount:[I

    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->printAvgValues([J[I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\n StaticBw Error\n"

    .line 3024
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mStaticBwErrorAcc:[J

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->mCount:[I

    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/TelephonyMetrics$BwEstimationStats;->printAvgValues([J[I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3025
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
