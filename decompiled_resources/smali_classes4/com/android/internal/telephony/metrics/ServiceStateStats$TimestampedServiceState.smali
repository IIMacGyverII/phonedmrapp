.class final Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;
.super Ljava/lang/Object;
.source "ServiceStateStats.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/ServiceStateStats;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "TimestampedServiceState"
.end annotation


# instance fields
.field private final mServiceState:Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

.field private final mTimestamp:J


# direct methods
.method static bridge synthetic -$$Nest$fgetmServiceState(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->mServiceState:Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmTimestamp(Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;)J
    .locals 2

    iget-wide v0, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->mTimestamp:J

    return-wide v0
.end method

.method constructor <init>(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;J)V
    .locals 0

    .line 311
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 312
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->mServiceState:Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    .line 313
    iput-wide p2, p0, Lcom/android/internal/telephony/metrics/ServiceStateStats$TimestampedServiceState;->mTimestamp:J

    return-void
.end method
