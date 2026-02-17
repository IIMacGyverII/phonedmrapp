.class public interface abstract Lcom/android/internal/telephony/nitz/TimeServiceHelper;
.super Ljava/lang/Object;
.source "TimeServiceHelper.java"


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
.end annotation


# virtual methods
.method public abstract dumpLogs(Lcom/android/internal/telephony/IndentingPrintWriter;)V
.end method

.method public abstract dumpState(Ljava/io/PrintWriter;)V
.end method

.method public abstract maybeSuggestDeviceTimeZone(Landroid/app/timezonedetector/TelephonyTimeZoneSuggestion;)V
.end method

.method public abstract suggestDeviceTime(Landroid/app/timedetector/TelephonyTimeSuggestion;)V
.end method
