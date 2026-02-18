.class Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;
.super Ljava/lang/Object;
.source "VoiceCallRatTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "Key"
.end annotation


# instance fields
.field public final carrierId:I

.field public final rat:I


# direct methods
.method constructor <init>(II)V
    .locals 0

    .line 170
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 171
    iput p1, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->carrierId:I

    .line 172
    iput p2, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->rat:I

    return-void
.end method

.method static fromProto(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;
    .locals 2

    .line 176
    new-instance v0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->carrierId:I

    iget p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->rat:I

    invoke-direct {v0, v1, p0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;-><init>(II)V

    return-object v0
.end method


# virtual methods
.method public equals(Ljava/lang/Object;)Z
    .locals 3

    const/4 v0, 0x0

    if-eqz p1, :cond_1

    .line 184
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    if-eq v1, v2, :cond_0

    goto :goto_0

    .line 187
    :cond_0
    check-cast p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;

    .line 188
    iget v1, p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->carrierId:I

    if-ne v1, v2, :cond_1

    iget p1, p1, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->rat:I

    iget p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->rat:I

    if-ne p1, p0, :cond_1

    const/4 v0, 0x1

    :cond_1
    :goto_0
    return v0
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x2

    new-array v0, v0, [Ljava/lang/Object;

    .line 180
    iget v1, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->carrierId:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget p0, p0, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker$Key;->rat:I

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    const/4 v1, 0x1

    aput-object p0, v0, v1

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method
