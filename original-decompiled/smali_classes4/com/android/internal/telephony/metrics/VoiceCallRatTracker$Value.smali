.class Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;
.super Ljava/lang/Object;
.source "VoiceCallRatTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "Value"
.end annotation


# instance fields
.field public callCount:J

.field public durationMillis:J

.field private mConnectionIds:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static bridge synthetic -$$Nest$fgetmConnectionIds(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;)Ljava/util/Set;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->mConnectionIds:Ljava/util/Set;

    return-object p0
.end method

.method private constructor <init>(JJ)V
    .locals 0

    .line 204
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 205
    iput-wide p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    const/4 p1, 0x0

    .line 206
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->mConnectionIds:Ljava/util/Set;

    .line 207
    iput-wide p3, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->callCount:J

    return-void
.end method

.method constructor <init>(JLjava/util/Set;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(J",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 198
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 199
    iput-wide p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    .line 200
    iput-object p3, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->mConnectionIds:Ljava/util/Set;

    const-wide/16 p1, 0x0

    .line 201
    iput-wide p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->callCount:J

    return-void
.end method

.method static fromProto(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;
    .locals 5

    .line 230
    new-instance v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;

    iget-wide v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->totalDurationMillis:J

    iget-wide v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->callCount:J

    invoke-direct {v0, v1, v2, v3, v4}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;-><init>(JJ)V

    return-object v0
.end method

.method static mergeInPlace(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;)Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;
    .locals 4

    .line 235
    iget-object v0, p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->mConnectionIds:Ljava/util/Set;

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->mConnectionIds:Ljava/util/Set;

    if-eqz v0, :cond_1

    .line 236
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->-$$Nest$sfgetTAG()Ljava/lang/String;

    move-result-object v0

    const-string v1, "Value: call not concluded yet when merging"

    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 239
    :cond_1
    iget-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    iget-wide v2, p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    .line 240
    iget-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->callCount:J

    iget-wide v2, p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->callCount:J

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->callCount:J

    return-object p0
.end method


# virtual methods
.method add(JLjava/util/Set;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(J",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 211
    iget-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    add-long/2addr v0, p1

    iput-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->durationMillis:J

    .line 212
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->mConnectionIds:Ljava/util/Set;

    if-eqz p0, :cond_0

    .line 213
    invoke-interface {p0, p3}, Ljava/util/Set;->addAll(Ljava/util/Collection;)Z

    goto :goto_0

    .line 215
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->-$$Nest$sfgetTAG()Ljava/lang/String;

    move-result-object p0

    const-string p1, "Value: trying to add to concluded call"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method endSession()V
    .locals 4

    .line 220
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->mConnectionIds:Ljava/util/Set;

    if-eqz v0, :cond_1

    .line 221
    iget-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->callCount:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-eqz v0, :cond_0

    .line 222
    invoke-static {}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->-$$Nest$sfgetTAG()Ljava/lang/String;

    move-result-object v0

    const-string v1, "Value: mConnectionIds!=null && callCount!=0"

    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 224
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->mConnectionIds:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v0

    int-to-long v0, v0

    iput-wide v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->callCount:J

    const/4 v0, 0x0

    .line 225
    iput-object v0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Value;->mConnectionIds:Ljava/util/Set;

    :cond_1
    return-void
.end method
