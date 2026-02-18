.class public Lcom/android/internal/telephony/metrics/DataStallRecoveryStats;
.super Ljava/lang/Object;
.source "DataStallRecoveryStats.java"


# static fields
.field private static final RECOVERY_ACTION_RADIO_RESTART_MAPPING:I = 0x3

.field private static final RECOVERY_ACTION_RESET_MODEM_MAPPING:I = 0x4


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 32
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static getIsOpportunistic(Lcom/android/internal/telephony/Phone;)Z
    .locals 1

    .line 139
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 140
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/SubscriptionController;->isOpportunistic(I)Z

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static getRat(Lcom/android/internal/telephony/Phone;)I
    .locals 0

    .line 130
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 132
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    if-eqz p0, :cond_1

    .line 134
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataNetworkType()I

    move-result p0

    goto :goto_1

    :cond_1
    const/4 p0, 0x0

    :goto_1
    return p0
.end method

.method public static onDataStallEvent(ILcom/android/internal/telephony/Phone;ZI)V
    .locals 11

    .line 51
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneType()I

    move-result v0

    const/4 v1, 0x5

    if-ne v0, v1, :cond_0

    .line 52
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object p1

    .line 55
    :cond_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v1

    .line 56
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/DataStallRecoveryStats;->getRat(Lcom/android/internal/telephony/Phone;)I

    move-result v2

    const/16 v0, 0x12

    const/4 v3, 0x0

    if-ne v2, v0, :cond_1

    move v7, v3

    goto :goto_0

    .line 58
    :cond_1
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getBand(Lcom/android/internal/telephony/Phone;)I

    move-result v0

    move v7, v0

    .line 60
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSignalStrength()Landroid/telephony/SignalStrength;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/SignalStrength;->getLevel()I

    move-result v4

    .line 61
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/DataStallRecoveryStats;->getIsOpportunistic(Lcom/android/internal/telephony/Phone;)Z

    move-result v5

    .line 62
    invoke-static {}, Lcom/android/internal/telephony/metrics/SimSlotState;->getCurrentState()Lcom/android/internal/telephony/metrics/SimSlotState;

    move-result-object p1

    iget p1, p1, Lcom/android/internal/telephony/metrics/SimSlotState;->numActiveSims:I

    const/4 v0, 0x1

    if-le p1, v0, :cond_2

    move v6, v0

    goto :goto_1

    :cond_2
    move v6, v3

    :goto_1
    const/4 v10, 0x0

    const/16 v0, 0x13b

    move v3, v4

    move v4, p0

    move v8, p2

    move v9, p3

    .line 66
    invoke-static/range {v0 .. v10}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIIIIZZIZII)V

    return-void
.end method

.method public static onDataStallEvent(ILcom/android/internal/telephony/Phone;ZII)V
    .locals 11

    .line 95
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneType()I

    move-result v0

    const/4 v1, 0x5

    if-ne v0, v1, :cond_0

    .line 96
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getDefaultPhone()Lcom/android/internal/telephony/Phone;

    move-result-object p1

    .line 99
    :cond_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v1

    .line 100
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/DataStallRecoveryStats;->getRat(Lcom/android/internal/telephony/Phone;)I

    move-result v2

    const/16 v0, 0x12

    const/4 v3, 0x0

    if-ne v2, v0, :cond_1

    move v7, v3

    goto :goto_0

    .line 102
    :cond_1
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->getBand(Lcom/android/internal/telephony/Phone;)I

    move-result v0

    move v7, v0

    .line 104
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSignalStrength()Landroid/telephony/SignalStrength;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/SignalStrength;->getLevel()I

    move-result v4

    .line 105
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/DataStallRecoveryStats;->getIsOpportunistic(Lcom/android/internal/telephony/Phone;)Z

    move-result v5

    .line 106
    invoke-static {}, Lcom/android/internal/telephony/metrics/SimSlotState;->getCurrentState()Lcom/android/internal/telephony/metrics/SimSlotState;

    move-result-object p1

    iget p1, p1, Lcom/android/internal/telephony/metrics/SimSlotState;->numActiveSims:I

    const/4 v0, 0x1

    if-le p1, v0, :cond_2

    move v6, v0

    goto :goto_1

    :cond_2
    move v6, v3

    :goto_1
    const/4 p1, 0x4

    const/4 v0, 0x3

    if-ne p0, v0, :cond_3

    move p0, v0

    goto :goto_2

    :cond_3
    if-ne p0, p1, :cond_4

    move p0, p1

    :cond_4
    :goto_2
    const/16 v0, 0x13b

    move v3, v4

    move v4, p0

    move v8, p2

    move v9, p3

    move v10, p4

    .line 114
    invoke-static/range {v0 .. v10}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(IIIIIZZIZII)V

    return-void
.end method
