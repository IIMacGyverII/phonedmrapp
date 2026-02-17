.class public Lcom/android/internal/telephony/metrics/ModemRestartStats;
.super Ljava/lang/Object;
.source "ModemRestartStats.java"


# static fields
.field private static final MAX_BASEBAND_LEN:I = 0x64

.field private static final MAX_REASON_LEN:I = 0x64

.field private static final TAG:Ljava/lang/String; = "ModemRestartStats"


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 40
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static getCarrierId()I
    .locals 6

    const/4 v0, -0x1

    .line 68
    :try_start_0
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object v1

    array-length v2, v1
    :try_end_0
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_1

    const/4 v3, 0x0

    move v4, v0

    :goto_0
    if-ge v3, v2, :cond_1

    :try_start_1
    aget-object v5, v1, v3

    .line 69
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v4
    :try_end_1
    .catch Ljava/lang/IllegalStateException; {:try_start_1 .. :try_end_1} :catch_0

    if-eq v4, v0, :cond_0

    goto :goto_1

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :catch_0
    move v0, v4

    :catch_1
    move v4, v0

    :cond_1
    :goto_1
    return v4
.end method

.method private static nullToEmpty(Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const-string p0, ""

    :goto_0
    return-object p0
.end method

.method public static onModemRestart(Ljava/lang/String;)V
    .locals 5

    const/16 v0, 0x64

    .line 44
    invoke-static {p0, v0}, Lcom/android/internal/telephony/metrics/ModemRestartStats;->truncateString(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object p0

    .line 45
    invoke-static {}, Landroid/os/Build;->getRadioVersion()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1, v0}, Lcom/android/internal/telephony/metrics/ModemRestartStats;->truncateString(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    .line 46
    invoke-static {}, Lcom/android/internal/telephony/metrics/ModemRestartStats;->getCarrierId()I

    move-result v1

    .line 48
    sget-object v2, Lcom/android/internal/telephony/metrics/ModemRestartStats;->TAG:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Modem restart (carrier="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, "): "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/16 v2, 0x138

    .line 49
    invoke-static {v2, v0, p0, v1}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(ILjava/lang/String;Ljava/lang/String;I)V

    return-void
.end method

.method private static truncateString(Ljava/lang/String;I)Ljava/lang/String;
    .locals 1

    .line 53
    invoke-static {p0}, Lcom/android/internal/telephony/metrics/ModemRestartStats;->nullToEmpty(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 54
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-le v0, p1, :cond_0

    const/4 v0, 0x0

    .line 55
    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    :cond_0
    return-object p0
.end method
