.class public final Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;
.super Ljava/lang/Object;
.source "TimeServiceHelperImpl.java"

# interfaces
.implements Lcom/android/internal/telephony/nitz/TimeServiceHelper;


# instance fields
.field private mLastSuggestedTimeZone:Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;

.field private final mSlotIndex:I

.field private final mTimeDetector:Landroid/app/timedetector/TimeDetector;

.field private final mTimeLog:Lcom/android/internal/telephony/LocalLog;

.field private final mTimeZoneDetector:Landroid/app/timezonedetector/TimeZoneDetector;

.field private final mTimeZoneLog:Lcom/android/internal/telephony/LocalLog;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 3

    .line 57
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 46
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x20

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/LocalLog;-><init>(IZ)V

    iput-object v0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeZoneLog:Lcom/android/internal/telephony/LocalLog;

    .line 47
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/LocalLog;-><init>(IZ)V

    iput-object v0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeLog:Lcom/android/internal/telephony/LocalLog;

    .line 58
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mSlotIndex:I

    .line 59
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    move-object v0, p1

    check-cast v0, Landroid/content/Context;

    .line 60
    const-class v0, Landroid/app/timedetector/TimeDetector;

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/timedetector/TimeDetector;

    invoke-static {v0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    check-cast v0, Landroid/app/timedetector/TimeDetector;

    iput-object v0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeDetector:Landroid/app/timedetector/TimeDetector;

    .line 61
    const-class v0, Landroid/app/timezonedetector/TimeZoneDetector;

    .line 62
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/app/timezonedetector/TimeZoneDetector;

    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    check-cast p1, Landroid/app/timezonedetector/TimeZoneDetector;

    iput-object p1, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeZoneDetector:Landroid/app/timezonedetector/TimeZoneDetector;

    return-void
.end method

.method private static shouldSendNewTimeZoneSuggestion(Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;)Z
    .locals 1

    const/4 v0, 0x1

    if-nez p0, :cond_0

    return v0

    .line 98
    :cond_0
    invoke-static {p1, p0}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    xor-int/2addr p0, v0

    return p0
.end method


# virtual methods
.method public dumpLogs(Lcom/android/internal/telephony/IndentingPrintWriter;)V
    .locals 3

    const-string v0, "TimeServiceHelperImpl:"

    .line 103
    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 104
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 105
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "SystemClock.elapsedRealtime()="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 106
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "System.currentTimeMillis()="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string v0, "Time Logs:"

    .line 108
    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 109
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 110
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/PrintWriter;)V

    .line 111
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v0, "Time zone Logs:"

    .line 113
    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 114
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 115
    iget-object p0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeZoneLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/PrintWriter;)V

    .line 116
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 117
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    return-void
.end method

.method public dumpState(Ljava/io/PrintWriter;)V
    .locals 2

    .line 122
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " TimeServiceHelperImpl.mLastSuggestedTimeZone="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mLastSuggestedTimeZone:Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    return-void
.end method

.method public maybeSuggestDeviceTimeZone(Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;)V
    .locals 3

    .line 80
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 82
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mLastSuggestedTimeZone:Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;

    .line 83
    invoke-static {v0, p1}, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->shouldSendNewTimeZoneSuggestion(Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 84
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeZoneLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Suggesting time zone update: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 85
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeZoneDetector:Landroid/app/timezonedetector/TimeZoneDetector;

    invoke-interface {v0, p1}, Landroid/app/timezonedetector/TimeZoneDetector;->suggestTelephonyTimeZone(Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;)V

    .line 86
    iput-object p1, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mLastSuggestedTimeZone:Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;

    :cond_0
    return-void
.end method

.method public suggestDeviceTime(Landroid/app/timedetector/TelephonyTimeSuggestion;)V
    .locals 5

    .line 67
    iget-object v0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Sending time suggestion: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 69
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 71
    invoke-virtual {p1}, Landroid/app/timedetector/TelephonyTimeSuggestion;->getUnixEpochTime()Landroid/os/TimestampedValue;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 72
    invoke-virtual {p1}, Landroid/app/timedetector/TelephonyTimeSuggestion;->getUnixEpochTime()Landroid/os/TimestampedValue;

    move-result-object v0

    .line 73
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v1

    iget v2, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mSlotIndex:I

    invoke-virtual {v0}, Landroid/os/TimestampedValue;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v3

    invoke-virtual {v1, v2, v3, v4}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeNITZEvent(IJ)V

    .line 75
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/nitz/TimeServiceHelperImpl;->mTimeDetector:Landroid/app/timedetector/TimeDetector;

    invoke-interface {p0, p1}, Landroid/app/timedetector/TimeDetector;->suggestTelephonyTime(Landroid/app/timedetector/TelephonyTimeSuggestion;)V

    return-void
.end method
