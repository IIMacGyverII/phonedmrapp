.class public final Lcom/android/internal/telephony/d2d/Timeouts;
.super Ljava/lang/Object;
.source "Timeouts.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/d2d/Timeouts$Adapter;
    }
.end annotation


# static fields
.field private static final PREFIX:Ljava/lang/String; = "telephony.d2d."


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 25
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static get(Landroid/content/ContentResolver;Ljava/lang/String;J)J
    .locals 2

    .line 72
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "telephony.d2d."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1, p2, p3}, Landroid/provider/Settings$Secure;->getLong(Landroid/content/ContentResolver;Ljava/lang/String;J)J

    move-result-wide p0

    return-wide p0
.end method

.method public static getDtmfDurationFuzzMillis(Landroid/content/ContentResolver;)J
    .locals 3

    const-string v0, "dtmf_duration_fuzz_millis"

    const-wide/16 v1, 0xa

    .line 122
    invoke-static {p0, v0, v1, v2}, Lcom/android/internal/telephony/d2d/Timeouts;->get(Landroid/content/ContentResolver;Ljava/lang/String;J)J

    move-result-wide v0

    return-wide v0
.end method

.method public static getDtmfMinimumIntervalMillis(Landroid/content/ContentResolver;)J
    .locals 3

    const-string v0, "dtmf_minimum_interval_millis"

    const-wide/16 v1, 0x64

    .line 92
    invoke-static {p0, v0, v1, v2}, Lcom/android/internal/telephony/d2d/Timeouts;->get(Landroid/content/ContentResolver;Ljava/lang/String;J)J

    move-result-wide v0

    return-wide v0
.end method

.method public static getDtmfNegotiationTimeoutMillis(Landroid/content/ContentResolver;)J
    .locals 3

    const-string v0, "dtmf_negotiation_timeout_millis"

    const-wide/16 v1, 0xbb8

    .line 110
    invoke-static {p0, v0, v1, v2}, Lcom/android/internal/telephony/d2d/Timeouts;->get(Landroid/content/ContentResolver;Ljava/lang/String;J)J

    move-result-wide v0

    return-wide v0
.end method

.method public static getMaxDurationOfDtmfMessageMillis(Landroid/content/ContentResolver;)J
    .locals 3

    const-string v0, "dtmf_max_message_duration_millis"

    const-wide/16 v1, 0x3e8

    .line 101
    invoke-static {p0, v0, v1, v2}, Lcom/android/internal/telephony/d2d/Timeouts;->get(Landroid/content/ContentResolver;Ljava/lang/String;J)J

    move-result-wide v0

    return-wide v0
.end method

.method public static getRtpMessageAckDurationMillis(Landroid/content/ContentResolver;)J
    .locals 3

    const-string v0, "rtp_message_ack_duration_millis"

    const-wide/16 v1, 0x3e8

    .line 82
    invoke-static {p0, v0, v1, v2}, Lcom/android/internal/telephony/d2d/Timeouts;->get(Landroid/content/ContentResolver;Ljava/lang/String;J)J

    move-result-wide v0

    return-wide v0
.end method
