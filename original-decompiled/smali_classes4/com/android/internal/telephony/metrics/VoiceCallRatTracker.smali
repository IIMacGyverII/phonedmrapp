.class public Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;
.super Ljava/lang/Object;
.source "VoiceCallRatTracker.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;,
        Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String; = "VoiceCallRatTracker"


# instance fields
.field private mLastKey:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

.field private mLastKeyTimestampMillis:J

.field private final mRatUsageMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;",
            "Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$1nvbB2I5NTRvEFzN4_mgPL6obhM(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->lambda$fromProto$0(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)V

    return-void
.end method

.method public static synthetic $r8$lambda$JkuH6Q1swmxULUkVXvhFSEl85wU(I)[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->lambda$toProto$1(I)[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$YDEGVxmdQMy4Y8UNytk-5u7uXCg(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;Ljava/util/Map$Entry;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->lambda$mergeWith$2(Ljava/util/Map$Entry;)V

    return-void
.end method

.method public static synthetic $r8$lambda$ht1LsujkKxY6qqg5690nSyVIt0M(Ljava/util/Map$Entry;)Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->entryToProto(Ljava/util/Map$Entry;)Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$sfgetTAG()Ljava/lang/String;
    .locals 1

    sget-object v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->TAG:Ljava/lang/String;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method constructor <init>()V
    .locals 1

    .line 50
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 41
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    .line 51
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->clear()V

    return-void
.end method

.method private addProto(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)V
    .locals 1

    .line 144
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->fromProto(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    move-result-object v0

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->fromProto(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;

    move-result-object p1

    invoke-interface {p0, v0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method private addToKey(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;JLjava/util/Set;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;",
            "J",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 135
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;

    if-nez v0, :cond_0

    .line 137
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    new-instance v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;

    invoke-direct {v0, p2, p3, p4}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;-><init>(JLjava/util/Set;)V

    invoke-interface {p0, p1, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 139
    :cond_0
    invoke-virtual {v0, p2, p3, p4}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->add(JLjava/util/Set;)V

    :goto_0
    return-void
.end method

.method private static entryToProto(Ljava/util/Map$Entry;)Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map$Entry<",
            "Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;",
            "Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;",
            ">;)",
            "Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;"
        }
    .end annotation

    .line 148
    invoke-interface {p0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    .line 149
    invoke-interface {p0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;

    .line 150
    new-instance v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    invoke-direct {v1}, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;-><init>()V

    .line 151
    iget v2, v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->carrierId:I

    iput v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->carrierId:I

    .line 152
    iget v0, v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->rat:I

    iput v0, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->rat:I

    .line 153
    invoke-static {p0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->-$$Nest$fgetmConnectionIds(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;)Ljava/util/Set;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 154
    sget-object v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->TAG:Ljava/lang/String;

    const-string v2, "call not concluded when converting to proto"

    invoke-static {v0, v2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 156
    :cond_0
    iget-wide v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->totalDurationMillis:J

    .line 157
    iget-wide v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->callCount:J

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->callCount:J

    return-object v1
.end method

.method public static fromProto([Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;
    .locals 2

    .line 56
    new-instance v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    invoke-direct {v0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;-><init>()V

    if-nez p0, :cond_0

    .line 58
    sget-object p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->TAG:Ljava/lang/String;

    const-string v1, "fromProto: usages=null"

    invoke-static {p0, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 60
    :cond_0
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda2;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;)V

    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    :goto_0
    return-object v0
.end method

.method private static synthetic lambda$fromProto$0(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)V
    .locals 0

    .line 60
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->addProto(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)V

    return-void
.end method

.method private synthetic lambda$mergeWith$2(Ljava/util/Map$Entry;)V
    .locals 2

    .line 128
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    .line 129
    invoke-interface {p1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    invoke-interface {p1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;

    new-instance v1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda5;

    invoke-direct {v1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda5;-><init>()V

    .line 128
    invoke-interface {p0, v0, p1, v1}, Ljava/util/Map;->merge(Ljava/lang/Object;Ljava/lang/Object;Ljava/util/function/BiFunction;)Ljava/lang/Object;

    return-void
.end method

.method private static synthetic lambda$toProto$1(I)[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;
    .locals 0

    .line 69
    new-array p0, p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    return-object p0
.end method


# virtual methods
.method public add(IIJLjava/util/Set;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(IIJ",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 83
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKey:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    const-wide/16 v1, 0x0

    if-eqz v0, :cond_1

    .line 84
    iget-wide v3, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKeyTimestampMillis:J

    sub-long v3, p3, v3

    cmp-long v0, v3, v1

    if-gez v0, :cond_0

    .line 86
    sget-object v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->TAG:Ljava/lang/String;

    const-string v3, "add: durationMillis<0"

    invoke-static {v0, v3}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    move-wide v3, v1

    .line 89
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKey:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    invoke-direct {p0, v0, v3, v4, p5}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->addToKey(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;JLjava/util/Set;)V

    .line 93
    :cond_1
    new-instance v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    invoke-direct {v0, p1, p2}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;-><init>(II)V

    .line 94
    invoke-direct {p0, v0, v1, v2, p5}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->addToKey(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;JLjava/util/Set;)V

    .line 96
    iput-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKey:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    .line 97
    iput-wide p3, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKeyTimestampMillis:J

    return-void
.end method

.method public clear()V
    .locals 2

    .line 74
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    const/4 v0, 0x0

    .line 75
    iput-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKey:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    const-wide/16 v0, 0x0

    .line 76
    iput-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKeyTimestampMillis:J

    return-void
.end method

.method public conclude(J)V
    .locals 3

    .line 102
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKey:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    if-eqz v0, :cond_2

    .line 103
    iget-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKeyTimestampMillis:J

    sub-long/2addr p1, v0

    const-wide/16 v0, 0x0

    cmp-long v2, p1, v0

    if-gez v2, :cond_0

    .line 105
    sget-object p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->TAG:Ljava/lang/String;

    const-string p2, "conclude: durationMillis<0"

    invoke-static {p1, p2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    move-wide p1, v0

    .line 108
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mLastKey:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;

    if-nez v0, :cond_1

    .line 110
    sget-object p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->TAG:Ljava/lang/String;

    const-string p2, "conclude: value=null && mLastKey!=null"

    invoke-static {p1, p2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 112
    :cond_1
    iget-wide v1, v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    add-long/2addr v1, p1

    iput-wide v1, v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    .line 114
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Collection;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda3;

    invoke-direct {p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    goto :goto_1

    .line 116
    :cond_2
    sget-object p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->TAG:Ljava/lang/String;

    const-string p1, "conclude: mLastKey=null"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    return-void
.end method

.method public mergeWith(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;)Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;
    .locals 2

    if-nez p1, :cond_0

    .line 123
    sget-object p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->TAG:Ljava/lang/String;

    new-instance v0, Ljava/lang/Throwable;

    invoke-direct {v0}, Ljava/lang/Throwable;-><init>()V

    const-string v1, "mergeWith: attempting to merge with null"

    invoke-static {p1, v1, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0

    .line 125
    :cond_0
    iget-object p1, p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    invoke-interface {p1}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda4;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda4;-><init>(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;)V

    .line 126
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    :goto_0
    return-object p0
.end method

.method public toProto()[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;
    .locals 1

    .line 67
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mRatUsageMap:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda0;-><init>()V

    .line 68
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda1;

    invoke-direct {v0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$$ExternalSyntheticLambda1;-><init>()V

    .line 69
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->toArray(Ljava/util/function/IntFunction;)[Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    return-object p0
.end method
