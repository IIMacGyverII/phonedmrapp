.class public final Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;
.super Ljava/lang/Object;
.source "NitzStateMachineImpl.java"

# interfaces
.implements Lcom/android/internal/telephony/NitzStateMachine;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$TimeZoneSuggester;,
        Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;
    }
.end annotation


# static fields
.field static final DBG:Z = true

.field static final LOG_TAG:Ljava/lang/String; = "NitzStateMachineImpl"


# instance fields
.field private mCountryIsoCode:Ljava/lang/String;

.field private final mDeviceState:Lcom/android/internal/telephony/NitzStateMachine$DeviceState;

.field private mLastNitzSignalCleared:Landroid/os/TimestampedValue;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/TimestampedValue<",
            "Lcom/android/internal/telephony/NitzSignal;",
            ">;"
        }
    .end annotation
.end field

.field private mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

.field private final mNitzSignalInputFilter:Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;

.field private final mSlotIndex:I

.field private final mTimeServiceHelper:Lcom/android/internal/telephony/nitz/TimeServiceHelper;

.field private final mTimeZoneSuggester:Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$TimeZoneSuggester;


# direct methods
.method public constructor <init>(ILcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$TimeZoneSuggester;Lcom/android/internal/telephony/nitz/TimeServiceHelper;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 165
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 166
    iput p1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mSlotIndex:I

    .line 167
    invoke-static {p2}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    check-cast p2, Lcom/android/internal/telephony/NitzStateMachine$DeviceState;

    iput-object p2, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mDeviceState:Lcom/android/internal/telephony/NitzStateMachine$DeviceState;

    .line 168
    invoke-static {p4}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    check-cast p4, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$TimeZoneSuggester;

    iput-object p4, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mTimeZoneSuggester:Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$TimeZoneSuggester;

    .line 169
    invoke-static {p5}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    check-cast p5, Lcom/android/internal/telephony/nitz/TimeServiceHelper;

    iput-object p5, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mTimeServiceHelper:Lcom/android/internal/telephony/nitz/TimeServiceHelper;

    .line 170
    invoke-static {p3}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    check-cast p3, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;

    iput-object p3, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mNitzSignalInputFilter:Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;

    return-void
.end method

.method private clearNetworkStateAndRerunDetection(Ljava/lang/String;Z)V
    .locals 4

    .line 293
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    const/4 v1, 0x0

    if-nez v0, :cond_1

    if-eqz p2, :cond_0

    .line 295
    iput-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    .line 300
    :cond_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ": mLatestNitzSignal was already null. Nothing to do."

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "NitzStateMachineImpl"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_1
    if-eqz p2, :cond_2

    .line 306
    iput-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    goto :goto_0

    .line 308
    :cond_2
    new-instance p2, Landroid/os/TimestampedValue;

    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mDeviceState:Lcom/android/internal/telephony/NitzStateMachine$DeviceState;

    .line 309
    invoke-interface {v0}, Lcom/android/internal/telephony/NitzStateMachine$DeviceState;->elapsedRealtimeMillis()J

    move-result-wide v2

    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    invoke-direct {p2, v2, v3, v0}, Landroid/os/TimestampedValue;-><init>(JLjava/lang/Object;)V

    iput-object p2, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    .line 311
    :goto_0
    iput-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    .line 313
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->runDetection(Ljava/lang/String;)V

    return-void
.end method

.method public static createInstance(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;
    .locals 6

    .line 142
    invoke-static {p0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 144
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    .line 145
    new-instance v2, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/NitzStateMachine$DeviceStateImpl;-><init>(Lcom/android/internal/telephony/Phone;)V

    .line 146
    new-instance v0, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;

    invoke-direct {v0}, Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;-><init>()V

    .line 147
    new-instance v4, Lcom/android/internal/telephony/nitz/TimeZoneSuggesterImpl;

    invoke-direct {v4, v2, v0}, Lcom/android/internal/telephony/nitz/TimeZoneSuggesterImpl;-><init>(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/nitz/TimeZoneLookupHelper;)V

    .line 149
    new-instance v5, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;

    invoke-direct {v5, p0}, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;-><init>(Lcom/android/internal/telephony/Phone;)V

    .line 151
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0, v2}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;->create(Landroid/content/Context;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;

    move-result-object v3

    .line 152
    new-instance p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;

    move-object v0, p0

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;-><init>(ILcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$TimeZoneSuggester;Lcom/android/internal/telephony/nitz/TimeServiceHelper;)V

    return-object p0
.end method

.method private doTimeDetection(Lcom/android/internal/telephony/NitzSignal;Ljava/lang/String;)V
    .locals 4

    const-string v0, ", reason="

    .line 370
    :try_start_0
    invoke-static {p2}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 372
    new-instance v1, Landroid/app/timedetector/TelephonyTimeSuggestion$Builder;

    iget v2, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mSlotIndex:I

    invoke-direct {v1, v2}, Landroid/app/timedetector/TelephonyTimeSuggestion$Builder;-><init>(I)V

    if-nez p1, :cond_0

    .line 375
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Clearing time suggestion reason="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/app/timedetector/TelephonyTimeSuggestion$Builder;->addDebugInfo(Ljava/lang/String;)Landroid/app/timedetector/TelephonyTimeSuggestion$Builder;

    goto :goto_0

    .line 378
    :cond_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/NitzSignal;->createTimeSignal()Landroid/os/TimestampedValue;

    move-result-object v2

    .line 379
    invoke-virtual {v1, v2}, Landroid/app/timedetector/TelephonyTimeSuggestion$Builder;->setUnixEpochTime(Landroid/os/TimestampedValue;)Landroid/app/timedetector/TelephonyTimeSuggestion$Builder;

    .line 380
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Sending new time suggestion nitzSignal="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/app/timedetector/TelephonyTimeSuggestion$Builder;->addDebugInfo(Ljava/lang/String;)Landroid/app/timedetector/TelephonyTimeSuggestion$Builder;

    .line 384
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mTimeServiceHelper:Lcom/android/internal/telephony/nitz/TimeServiceHelper;

    invoke-virtual {v1}, Landroid/app/timedetector/TelephonyTimeSuggestion$Builder;->build()Landroid/app/timedetector/TelephonyTimeSuggestion;

    move-result-object v1

    invoke-interface {v2, v1}, Lcom/android/internal/telephony/nitz/TimeServiceHelper;->suggestDeviceTime(Landroid/app/timedetector/TelephonyTimeSuggestion;)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception v1

    .line 386
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "doTimeDetection: Exception thrown mSlotIndex="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mSlotIndex:I

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ", nitzSignal="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ", ex="

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "NitzStateMachineImpl"

    invoke-static {p1, p0, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_1
    return-void
.end method

.method private doTimeZoneDetection(Ljava/lang/String;Lcom/android/internal/telephony/NitzSignal;Ljava/lang/String;)V
    .locals 6

    const-string v0, ", reason="

    const-string v1, ", nitzSignal="

    const-string v2, "NitzStateMachineImpl"

    .line 342
    :try_start_0
    invoke-static {p3}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 344
    iget-object v3, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mTimeZoneSuggester:Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$TimeZoneSuggester;

    iget v4, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mSlotIndex:I

    invoke-interface {v3, v4, p1, p2}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$TimeZoneSuggester;->getTimeZoneSuggestion(ILjava/lang/String;Lcom/android/internal/telephony/NitzSignal;)Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;

    move-result-object v3

    .line 346
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Detection reason="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;->addDebugInfo(Ljava/lang/String;)V

    .line 349
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "doTimeZoneDetection: countryIsoCode="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, ", suggestion="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v2, v4}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 353
    iget-object v4, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mTimeServiceHelper:Lcom/android/internal/telephony/nitz/TimeServiceHelper;

    invoke-interface {v4, v3}, Lcom/android/internal/telephony/nitz/TimeServiceHelper;->maybeSuggestDeviceTimeZone(Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v3

    .line 355
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "doTimeZoneDetection: Exception thrown mSlotIndex="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mSlotIndex:I

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ", countryIsoCode="

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ", ex="

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0, v3}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_0
    return-void
.end method

.method private restoreNetworkStateAndRerunDetection(Ljava/lang/String;)V
    .locals 6

    .line 262
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    const-string v1, "NitzStateMachineImpl"

    if-nez v0, :cond_0

    .line 264
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ": mLastNitzSignalCleared is null."

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 270
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mDeviceState:Lcom/android/internal/telephony/NitzStateMachine$DeviceState;

    invoke-interface {v0}, Lcom/android/internal/telephony/NitzStateMachine$DeviceState;->elapsedRealtimeMillis()J

    move-result-wide v2

    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    .line 271
    invoke-virtual {v0}, Landroid/os/TimestampedValue;->getReferenceTimeMillis()J

    move-result-wide v4

    sub-long/2addr v2, v4

    .line 272
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mDeviceState:Lcom/android/internal/telephony/NitzStateMachine$DeviceState;

    .line 273
    invoke-interface {v0}, Lcom/android/internal/telephony/NitzStateMachine$DeviceState;->getNitzNetworkDisconnectRetentionMillis()I

    move-result v0

    int-to-long v4, v0

    cmp-long v0, v2, v4

    if-gez v0, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :goto_0
    if-eqz v0, :cond_2

    .line 275
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", mLatestNitzSignal restored from mLastNitzSignalCleared="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    .line 276
    invoke-virtual {p1}, Landroid/os/TimestampedValue;->getValue()Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 277
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    invoke-virtual {v0}, Landroid/os/TimestampedValue;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/NitzSignal;

    iput-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    const/4 v0, 0x0

    .line 280
    iput-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    .line 282
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->runDetection(Ljava/lang/String;)V

    goto :goto_1

    .line 285
    :cond_2
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ": mLastNitzSignalCleared is too old."

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    return-void
.end method

.method private runDetection(Ljava/lang/String;)V
    .locals 4

    .line 319
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mCountryIsoCode:Ljava/lang/String;

    .line 321
    iget-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    .line 323
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "runDetection: reason="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ", countryIsoCode="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ", nitzSignal="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "NitzStateMachineImpl"

    invoke-static {v3, v2}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 329
    invoke-direct {p0, v0, v1, p1}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->doTimeZoneDetection(Ljava/lang/String;Lcom/android/internal/telephony/NitzSignal;Ljava/lang/String;)V

    .line 332
    invoke-direct {p0, v1, p1}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->doTimeDetection(Lcom/android/internal/telephony/NitzSignal;Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public dumpLogs(Ljava/io/FileDescriptor;Lcom/android/internal/telephony/IndentingPrintWriter;[Ljava/lang/String;)V
    .locals 0

    .line 404
    iget-object p0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mTimeServiceHelper:Lcom/android/internal/telephony/nitz/TimeServiceHelper;

    invoke-interface {p0, p2}, Lcom/android/internal/telephony/nitz/TimeServiceHelper;->dumpLogs(Lcom/android/internal/telephony/IndentingPrintWriter;)V

    return-void
.end method

.method public dumpState(Ljava/io/PrintWriter;)V
    .locals 2

    .line 396
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " NitzStateMachineImpl.mLatestNitzSignal="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 397
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " NitzStateMachineImpl.mCountryIsoCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mCountryIsoCode:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 398
    iget-object p0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mTimeServiceHelper:Lcom/android/internal/telephony/nitz/TimeServiceHelper;

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/nitz/TimeServiceHelper;->dumpState(Ljava/io/PrintWriter;)V

    .line 399
    invoke-virtual {p1}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method public getLastNitzDataCleared()Lcom/android/internal/telephony/NitzData;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 416
    iget-object p0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    if-eqz p0, :cond_0

    .line 417
    invoke-virtual {p0}, Landroid/os/TimestampedValue;->getValue()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/NitzSignal;

    invoke-virtual {p0}, Lcom/android/internal/telephony/NitzSignal;->getNitzData()Lcom/android/internal/telephony/NitzData;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public getLatestNitzData()Lcom/android/internal/telephony/NitzData;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 410
    iget-object p0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/NitzSignal;->getNitzData()Lcom/android/internal/telephony/NitzData;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method public handleAirplaneModeChanged(Z)V
    .locals 2

    const/4 v0, 0x0

    .line 254
    iput-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mCountryIsoCode:Ljava/lang/String;

    .line 256
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handleAirplaneModeChanged("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, ")"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 v0, 0x1

    .line 257
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->clearNetworkStateAndRerunDetection(Ljava/lang/String;Z)V

    return-void
.end method

.method public handleCountryDetected(Ljava/lang/String;)V
    .locals 3

    .line 188
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handleCountryDetected: countryIsoCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mLatestNitzSignal="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "NitzStateMachineImpl"

    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 192
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mCountryIsoCode:Ljava/lang/String;

    .line 193
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    iput-object p1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mCountryIsoCode:Ljava/lang/String;

    .line 194
    invoke-static {v0, p1}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 196
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "handleCountryDetected(\""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\")"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, p1, v0, v1}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->doTimeZoneDetection(Ljava/lang/String;Lcom/android/internal/telephony/NitzSignal;Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method public handleCountryUnavailable()V
    .locals 3

    .line 204
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handleCountryUnavailable: mLatestNitzSignal="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "NitzStateMachineImpl"

    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x0

    .line 207
    iput-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mCountryIsoCode:Ljava/lang/String;

    .line 210
    iget-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    const-string v2, "handleCountryUnavailable"

    invoke-direct {p0, v0, v1, v2}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->doTimeZoneDetection(Ljava/lang/String;Lcom/android/internal/telephony/NitzSignal;Ljava/lang/String;)V

    return-void
.end method

.method public handleNetworkAvailable()V
    .locals 1

    const-string v0, "handleNetworkAvailable"

    .line 176
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->restoreNetworkStateAndRerunDetection(Ljava/lang/String;)V

    return-void
.end method

.method public handleNetworkUnavailable()V
    .locals 2

    const-string v0, "handleNetworkUnavailable"

    const/4 v1, 0x0

    .line 182
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->clearNetworkStateAndRerunDetection(Ljava/lang/String;Z)V

    return-void
.end method

.method public handleNitzReceived(Lcom/android/internal/telephony/NitzSignal;)V
    .locals 2

    .line 216
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 219
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    .line 220
    iget-object v1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mNitzSignalInputFilter:Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;

    invoke-interface {v1, v0, p1}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;->mustProcessNitzSignal(Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 222
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handleNitzReceived: previousNitzSignal="

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, ", nitzSignal="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ": NITZ filtered"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "NitzStateMachineImpl"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 229
    :cond_0
    iput-object p1, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLatestNitzSignal:Lcom/android/internal/telephony/NitzSignal;

    const/4 v0, 0x0

    .line 232
    iput-object v0, p0, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->mLastNitzSignalCleared:Landroid/os/TimestampedValue;

    .line 234
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handleNitzReceived("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ")"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 235
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/nitz/NitzStateMachineImpl;->runDetection(Ljava/lang/String;)V

    return-void
.end method
