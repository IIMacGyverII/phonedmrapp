.class public Lcom/android/internal/telephony/SignalStrengthController;
.super Landroid/os/Handler;
.source "SignalStrengthController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;,
        Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;
    }
.end annotation


# static fields
.field private static final ALIGNMENT_HYSTERESIS_DB:I = 0x1

.field private static final DBG:Z = false

.field private static final EVENT_CARRIER_CONFIG_CHANGED:I = 0xa

.field private static final EVENT_CLEAR_SIGNAL_STRENGTH_UPDATE_REQUEST:I = 0x2

.field private static final EVENT_GET_SIGNAL_STRENGTH:I = 0x6

.field private static final EVENT_ON_DEVICE_IDLE_STATE_CHANGED:I = 0x3

.field private static final EVENT_POLL_SIGNAL_STRENGTH:I = 0x7

.field private static final EVENT_POLL_SIGNAL_STRENGTH_DONE:I = 0x9

.field private static final EVENT_RADIO_AVAILABLE:I = 0x5

.field private static final EVENT_RIL_CONNECTED:I = 0x4

.field private static final EVENT_SET_SIGNAL_STRENGTH_UPDATE_REQUEST:I = 0x1

.field private static final EVENT_SIGNAL_STRENGTH_UPDATE:I = 0x8

.field private static final INVALID_ARFCN:I = -0x1

.field private static final POLL_PERIOD_MILLIS:J

.field private static final REPORTING_HYSTERESIS_DB:I = 0x2

.field private static final REPORTING_HYSTERESIS_MILLIS:I = 0xbb8

.field private static final SIGNAL_STRENGTH_REFRESH_THRESHOLD_IN_MS:J

.field private static final TAG:Ljava/lang/String; = "SSCtr"


# instance fields
.field private mBroadcastReceiver:Landroid/content/BroadcastReceiver;

.field protected mCarrierConfig:Landroid/os/PersistableBundle;

.field protected final mCi:Lcom/android/internal/telephony/CommandsInterface;

.field private mEarfcnPairListForRsrpBoost:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/util/Pair<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation
.end field

.field private mLastSignalStrength:Landroid/telephony/SignalStrength;

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private mLteRsrpBoost:I

.field private mNrRsrpBoost:[I

.field private mNrarfcnRangeListForRsrpBoost:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/util/Pair<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation
.end field

.field protected final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mRsrpBoostLock:Ljava/lang/Object;

.field private final mSignalRequestRecords:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;",
            ">;"
        }
    .end annotation
.end field

.field protected mSignalStrength:Landroid/telephony/SignalStrength;

.field protected mSignalStrengthUpdatedTime:J


# direct methods
.method public static synthetic $r8$lambda$4Hz8txT3RiS7V8_46FdgzXN6650(ILjava/lang/Integer;Ljava/lang/Integer;)I
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/SignalStrengthController;->lambda$getConsolidatedSignalThresholds$1(ILjava/lang/Integer;Ljava/lang/Integer;)I

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$J_uQ9drEBXByJlLRynCHCseGOGU(ILcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->lambda$shouldHonorSystemThresholds$2(ILcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$Y-Ry1J3-ANy6MROM7q5ysdLBQWU(ILcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->lambda$updateAlwaysReportSignalStrength$3(ILcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$f6d96MfFe5aU-WPW8VRo8ymoKzU(Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->lambda$handleMessage$0(Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mlocalLog(Lcom/android/internal/telephony/SignalStrengthController;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->localLog(Ljava/lang/String;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 71
    sget-object v0, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0xa

    .line 72
    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v1

    sput-wide v1, Lcom/android/internal/telephony/SignalStrengthController;->SIGNAL_STRENGTH_REFRESH_THRESHOLD_IN_MS:J

    const-wide/16 v1, 0x14

    .line 74
    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/SignalStrengthController;->POLL_PERIOD_MILLIS:J

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 3

    .line 163
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    const/4 v0, 0x0

    .line 112
    iput-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLastSignalStrength:Landroid/telephony/SignalStrength;

    .line 120
    iput-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mEarfcnPairListForRsrpBoost:Ljava/util/ArrayList;

    const/4 v1, 0x0

    .line 125
    iput v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLteRsrpBoost:I

    .line 131
    iput-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrarfcnRangeListForRsrpBoost:Ljava/util/ArrayList;

    .line 133
    iput-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrRsrpBoost:[I

    .line 135
    new-instance v1, Ljava/lang/Object;

    invoke-direct {v1}, Ljava/lang/Object;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mRsrpBoostLock:Ljava/lang/Object;

    .line 138
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalRequestRecords:Ljava/util/List;

    .line 146
    new-instance v1, Lcom/android/internal/telephony/LocalLog;

    const/16 v2, 0x40

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 149
    new-instance v1, Lcom/android/internal/telephony/SignalStrengthController$1;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/SignalStrengthController$1;-><init>(Lcom/android/internal/telephony/SignalStrengthController;)V

    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    .line 164
    iput-object p1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 165
    iget-object v1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v2, 0x4

    .line 167
    invoke-interface {v1, p0, v2, v0}, Lcom/android/internal/telephony/CommandsInterface;->registerForRilConnected(Landroid/os/Handler;ILjava/lang/Object;)V

    const/4 v2, 0x5

    .line 168
    invoke-interface {v1, p0, v2, v0}, Lcom/android/internal/telephony/CommandsInterface;->registerForAvailable(Landroid/os/Handler;ILjava/lang/Object;)V

    const/16 v2, 0x8

    .line 169
    invoke-interface {v1, p0, v2, v0}, Lcom/android/internal/telephony/CommandsInterface;->setOnSignalStrengthUpdate(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 170
    invoke-virtual {p0}, Lcom/android/internal/telephony/SignalStrengthController;->setSignalStrengthDefaultValues()V

    .line 172
    invoke-direct {p0}, Lcom/android/internal/telephony/SignalStrengthController;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    .line 173
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    const-string v1, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 174
    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 175
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p1, p0, v0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    return-void
.end method

.method private consolidatedAndSetReportingCriteria(Ljava/util/List;)V
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/SignalThresholdInfo;",
            ">;)V"
        }
    .end annotation

    .line 559
    new-instance v0, Ljava/util/ArrayList;

    .line 560
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 561
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/SignalThresholdInfo;

    .line 562
    invoke-virtual {v1}, Landroid/telephony/SignalThresholdInfo;->getRadioAccessNetworkType()I

    move-result v2

    .line 563
    invoke-virtual {v1}, Landroid/telephony/SignalThresholdInfo;->getSignalMeasurementType()I

    move-result v3

    .line 564
    invoke-virtual {v1}, Landroid/telephony/SignalThresholdInfo;->isEnabled()Z

    move-result v4

    const/4 v5, 0x0

    if-eqz v4, :cond_0

    .line 569
    invoke-virtual {p0}, Lcom/android/internal/telephony/SignalStrengthController;->shouldHonorSystemThresholds()Z

    move-result v6

    if-eqz v6, :cond_0

    .line 570
    invoke-virtual {v1}, Landroid/telephony/SignalThresholdInfo;->getThresholds()[I

    move-result-object v1

    goto :goto_1

    :cond_0
    new-array v1, v5, [I

    :goto_1
    const/4 v6, 0x1

    .line 566
    invoke-virtual {p0, v2, v3, v1, v6}, Lcom/android/internal/telephony/SignalStrengthController;->getConsolidatedSignalThresholds(II[II)[I

    move-result-object v1

    .line 573
    iget-object v7, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 577
    invoke-virtual {v7}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v7

    iget-object v8, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 578
    invoke-virtual {v8}, Lcom/android/internal/telephony/Phone;->isDeviceIdle()Z

    move-result v8

    .line 574
    invoke-virtual {p0, v2, v3, v7, v8}, Lcom/android/internal/telephony/SignalStrengthController;->shouldEnableSignalThresholdForAppRequest(IIIZ)Z

    move-result v7

    .line 579
    new-instance v8, Landroid/telephony/SignalThresholdInfo$Builder;

    invoke-direct {v8}, Landroid/telephony/SignalThresholdInfo$Builder;-><init>()V

    .line 581
    invoke-virtual {v8, v2}, Landroid/telephony/SignalThresholdInfo$Builder;->setRadioAccessNetworkType(I)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object v2

    .line 582
    invoke-virtual {v2, v3}, Landroid/telephony/SignalThresholdInfo$Builder;->setSignalMeasurementType(I)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object v2

    const/16 v3, 0xbb8

    .line 583
    invoke-virtual {v2, v3}, Landroid/telephony/SignalThresholdInfo$Builder;->setHysteresisMs(I)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object v2

    const/4 v3, 0x2

    .line 584
    invoke-virtual {v2, v3}, Landroid/telephony/SignalThresholdInfo$Builder;->setHysteresisDb(I)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object v2

    .line 585
    invoke-virtual {v2, v1, v6}, Landroid/telephony/SignalThresholdInfo$Builder;->setThresholds([IZ)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object v1

    if-nez v4, :cond_1

    if-eqz v7, :cond_2

    :cond_1
    move v5, v6

    .line 586
    :cond_2
    invoke-virtual {v1, v5}, Landroid/telephony/SignalThresholdInfo$Builder;->setIsEnabled(Z)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object v1

    .line 587
    invoke-virtual {v1}, Landroid/telephony/SignalThresholdInfo$Builder;->build()Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 579
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 589
    :cond_3
    iget-object p1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x0

    invoke-interface {p1, v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->setSignalStrengthReportingCriteria(Ljava/util/List;Landroid/os/Message;)V

    .line 591
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setSignalStrengthReportingCriteria consolidatedSignalThresholdInfos="

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->localLog(Ljava/lang/String;)V

    return-void
.end method

.method private static containsEarfcnInEarfcnRange(Ljava/util/ArrayList;I)I
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/util/Pair<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;>;I)I"
        }
    .end annotation

    if-eqz p0, :cond_1

    .line 921
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    const/4 v0, 0x0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/util/Pair;

    .line 922
    iget-object v2, v1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    if-lt p1, v2, :cond_0

    iget-object v1, v1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    if-gt p1, v1, :cond_0

    return v0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method private static convertEarfcnStringArrayToPairList([Ljava/lang/String;)Ljava/util/ArrayList;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/ArrayList<",
            "Landroid/util/Pair<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation

    .line 941
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    if-eqz p0, :cond_2

    const/4 v1, 0x0

    move v2, v1

    .line 946
    :goto_0
    array-length v3, p0

    if-ge v2, v3, :cond_2

    const/4 v3, 0x0

    .line 948
    :try_start_0
    aget-object v4, p0, v2

    const-string v5, "-"

    invoke-virtual {v4, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v4

    .line 949
    array-length v5, v4

    const/4 v6, 0x2

    if-eq v5, v6, :cond_0

    return-object v3

    .line 956
    :cond_0
    aget-object v5, v4, v1

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    const/4 v6, 0x1

    .line 957
    aget-object v4, v4, v6

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    if-le v5, v4, :cond_1

    return-object v3

    .line 966
    :cond_1
    new-instance v6, Landroid/util/Pair;

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-direct {v6, v5, v4}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/util/regex/PatternSyntaxException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :catch_0
    return-object v3

    :cond_2
    return-object v0
.end method

.method private static createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;
    .locals 1

    .line 994
    new-instance v0, Landroid/telephony/SignalThresholdInfo$Builder;

    invoke-direct {v0}, Landroid/telephony/SignalThresholdInfo$Builder;-><init>()V

    .line 995
    invoke-virtual {v0, p0}, Landroid/telephony/SignalThresholdInfo$Builder;->setSignalMeasurementType(I)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object p0

    .line 996
    invoke-virtual {p0, p1}, Landroid/telephony/SignalThresholdInfo$Builder;->setThresholds([I)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object p0

    .line 997
    invoke-virtual {p0, p2}, Landroid/telephony/SignalThresholdInfo$Builder;->setRadioAccessNetworkType(I)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object p0

    .line 998
    invoke-virtual {p0, p3}, Landroid/telephony/SignalThresholdInfo$Builder;->setIsEnabled(Z)Landroid/telephony/SignalThresholdInfo$Builder;

    move-result-object p0

    .line 999
    invoke-virtual {p0}, Landroid/telephony/SignalThresholdInfo$Builder;->build()Landroid/telephony/SignalThresholdInfo;

    move-result-object p0

    return-object p0
.end method

.method private getCarrierConfig()Landroid/os/PersistableBundle;
    .locals 2

    .line 798
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "carrier_config"

    .line 799
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    if-eqz v0, :cond_0

    .line 802
    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    if-eqz p0, :cond_0

    return-object p0

    .line 808
    :cond_0
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object p0

    return-object p0
.end method

.method private static isRanAndSignalMeasurementTypeMatch(IILandroid/telephony/SignalThresholdInfo;)Z
    .locals 1

    .line 780
    invoke-virtual {p2}, Landroid/telephony/SignalThresholdInfo;->getRadioAccessNetworkType()I

    move-result v0

    if-ne p0, v0, :cond_0

    .line 781
    invoke-virtual {p2}, Landroid/telephony/SignalThresholdInfo;->getSignalMeasurementType()I

    move-result p0

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static isSignalReportRequestedWhileIdle(Landroid/telephony/SignalStrengthUpdateRequest;)Z
    .locals 1

    .line 786
    invoke-virtual {p0}, Landroid/telephony/SignalStrengthUpdateRequest;->isSystemThresholdReportingRequestedWhileIdle()Z

    move-result v0

    if-nez v0, :cond_1

    .line 787
    invoke-virtual {p0}, Landroid/telephony/SignalStrengthUpdateRequest;->isReportingRequestedWhileIdle()Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method private static synthetic lambda$getConsolidatedSignalThresholds$1(ILjava/lang/Integer;Ljava/lang/Integer;)I
    .locals 2

    .line 693
    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    sub-int/2addr v1, p0

    if-lt v0, v1, :cond_0

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    add-int/2addr v1, p0

    if-gt v0, v1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 696
    :cond_0
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p0

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-static {p0, p1}, Ljava/lang/Integer;->compare(II)I

    move-result p0

    return p0
.end method

.method private static synthetic lambda$handleMessage$0(Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z
    .locals 2

    .line 197
    iget v0, p1, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mCallingUid:I

    iget v1, p0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mCallingUid:I

    if-ne v0, v1, :cond_0

    iget p1, p1, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mSubId:I

    iget p0, p0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mSubId:I

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$shouldHonorSystemThresholds$2(ILcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z
    .locals 1

    .line 743
    iget v0, p1, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mSubId:I

    if-ne p0, v0, :cond_0

    iget-object p0, p1, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mRequest:Landroid/telephony/SignalStrengthUpdateRequest;

    .line 744
    invoke-virtual {p0}, Landroid/telephony/SignalStrengthUpdateRequest;->isSystemThresholdReportingRequestedWhileIdle()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$updateAlwaysReportSignalStrength$3(ILcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)Z
    .locals 1

    .line 842
    iget v0, p1, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mSubId:I

    if-ne v0, p0, :cond_0

    iget-object p0, p1, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mRequest:Landroid/telephony/SignalStrengthUpdateRequest;

    invoke-static {p0}, Lcom/android/internal/telephony/SignalStrengthController;->isSignalReportRequestedWhileIdle(Landroid/telephony/SignalStrengthUpdateRequest;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private localLog(Ljava/lang/String;)V
    .locals 2

    const-string v0, "SSCtr"

    .line 1125
    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1126
    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "SSCtr: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static log(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method private static loge(Ljava/lang/String;)V
    .locals 1

    const-string v0, "SSCtr"

    .line 1120
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private onCarrierConfigChanged()V
    .locals 1

    .line 985
    invoke-direct {p0}, Lcom/android/internal/telephony/SignalStrengthController;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "Carrier Config changed."

    .line 986
    invoke-static {v0}, Lcom/android/internal/telephony/SignalStrengthController;->log(Ljava/lang/String;)V

    .line 988
    invoke-virtual {p0}, Lcom/android/internal/telephony/SignalStrengthController;->updateArfcnLists()V

    .line 989
    invoke-virtual {p0}, Lcom/android/internal/telephony/SignalStrengthController;->updateReportingCriteria()V

    return-void
.end method

.method private onReset()V
    .locals 0

    .line 303
    invoke-direct {p0}, Lcom/android/internal/telephony/SignalStrengthController;->setDefaultSignalStrengthReportingCriteria()V

    return-void
.end method

.method private setDefaultSignalStrengthReportingCriteria()V
    .locals 6

    .line 492
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 494
    sget-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->GERAN:[I

    const/4 v2, 0x1

    .line 495
    invoke-static {v2, v1, v2, v2}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 494
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 500
    sget-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->UTRAN:[I

    const/4 v3, 0x2

    .line 501
    invoke-static {v3, v1, v3, v2}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 500
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 506
    sget-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->EUTRAN_RSRP:[I

    const/4 v3, 0x3

    .line 507
    invoke-static {v3, v1, v3, v2}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 506
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 512
    sget-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->CDMA2000:[I

    const/4 v4, 0x4

    .line 513
    invoke-static {v2, v1, v4, v2}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 512
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 519
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getHalVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object v1

    sget-object v5, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v1, v5}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 520
    sget-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->EUTRAN_RSRQ:[I

    const/4 v5, 0x0

    .line 521
    invoke-static {v4, v1, v3, v5}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 520
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const/4 v1, 0x5

    .line 526
    sget-object v4, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->EUTRAN_RSSNR:[I

    .line 527
    invoke-static {v1, v4, v3, v2}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 526
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 534
    sget-object v1, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->NGRAN_SSRSRP:[I

    const/4 v3, 0x6

    .line 535
    invoke-static {v3, v1, v3, v2}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 534
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const/4 v1, 0x7

    .line 540
    sget-object v2, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->NGRAN_SSRSRQ:[I

    .line 541
    invoke-static {v1, v2, v3, v5}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 540
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const/16 v1, 0x8

    .line 546
    sget-object v2, Lcom/android/internal/telephony/SignalStrengthController$AccessNetworkThresholds;->NGRAN_SSSINR:[I

    .line 547
    invoke-static {v1, v2, v3, v5}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 546
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 554
    :cond_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/SignalStrengthController;->consolidatedAndSetReportingCriteria(Ljava/util/List;)V

    return-void
.end method

.method private shouldRefreshSignalStrength()Z
    .locals 7

    .line 355
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 359
    iget-wide v2, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrengthUpdatedTime:J

    cmp-long v4, v2, v0

    const/4 v5, 0x1

    const/4 v6, 0x0

    if-gtz v4, :cond_1

    sub-long/2addr v0, v2

    sget-wide v2, Lcom/android/internal/telephony/SignalStrengthController;->SIGNAL_STRENGTH_REFRESH_THRESHOLD_IN_MS:J

    cmp-long v0, v0, v2

    if-lez v0, :cond_0

    goto :goto_0

    :cond_0
    move v0, v6

    goto :goto_1

    :cond_1
    :goto_0
    move v0, v5

    :goto_1
    if-nez v0, :cond_2

    return v6

    .line 363
    :cond_2
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 364
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 365
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object v2

    .line 364
    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/SubscriptionController;->getActiveSubscriptionInfoList(Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;

    move-result-object v0

    .line 367
    invoke-static {v0}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty(Ljava/util/Collection;)Z

    move-result v1

    if-nez v1, :cond_4

    .line 368
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_3
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_4

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/SubscriptionInfo;

    .line 372
    invoke-virtual {v1}, Landroid/telephony/SubscriptionInfo;->isOpportunistic()Z

    move-result v2

    if-eqz v2, :cond_3

    .line 373
    iget-object v2, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-static {v2}, Landroid/telephony/TelephonyManager;->from(Landroid/content/Context;)Landroid/telephony/TelephonyManager;

    move-result-object v2

    .line 374
    invoke-virtual {v1}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v1

    invoke-virtual {v2, v1}, Landroid/telephony/TelephonyManager;->createForSubscriptionId(I)Landroid/telephony/TelephonyManager;

    move-result-object v1

    .line 375
    invoke-virtual {v1}, Landroid/telephony/TelephonyManager;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    if-eqz v1, :cond_3

    .line 377
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v1

    if-nez v1, :cond_3

    return v5

    :cond_4
    return v6
.end method

.method private updateAlwaysReportSignalStrength()V
    .locals 3

    .line 840
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 841
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalRequestRecords:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda3;

    invoke-direct {v2, v0}, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda3;-><init>(I)V

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v0

    .line 846
    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->setAlwaysReportSignalStrength(Z)V

    return-void
.end method


# virtual methods
.method public clearSignalStrengthUpdateRequest(IILandroid/telephony/SignalStrengthUpdateRequest;Landroid/os/Message;)V
    .locals 2

    .line 665
    new-instance v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    invoke-direct {v0, p0, p1, p2, p3}, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;-><init>(Lcom/android/internal/telephony/SignalStrengthController;IILandroid/telephony/SignalStrengthUpdateRequest;)V

    .line 666
    new-instance v1, Landroid/util/Pair;

    invoke-direct {v1, v0, p4}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    const/4 p4, 0x2

    invoke-virtual {p0, p4, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p4

    invoke-virtual {p0, p4}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 669
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "clearSignalStrengthUpdateRequest subId="

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " callingUid="

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " request="

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->localLog(Ljava/lang/String;)V

    return-void
.end method

.method dispose()V
    .locals 1

    .line 295
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unSetOnSignalStrengthUpdate(Landroid/os/Handler;)V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 627
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "SignalStrengthController - phoneId: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string v0, "SignalStrengthController - Log Begin ----"

    .line 628
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 629
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v0, p1, p2, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    const-string p1, "SignalStrengthController - Log End ----"

    .line 630
    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 632
    new-instance p1, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p3, "  "

    invoke-direct {p1, p2, p3}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 633
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 634
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "mSignalRequestRecords="

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalRequestRecords:Ljava/util/List;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 635
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " mLastSignalStrength="

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLastSignalStrength:Landroid/telephony/SignalStrength;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 636
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " mSignalStrength="

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrength:Landroid/telephony/SignalStrength;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 637
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " mLteRsrpBoost="

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLteRsrpBoost:I

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 638
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " mNrRsrpBoost="

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrRsrpBoost:[I

    invoke-static {v0}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 639
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " mEarfcnPairListForRsrpBoost="

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mEarfcnPairListForRsrpBoost:Ljava/util/ArrayList;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 640
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " mNrarfcnRangeListForRsrpBoost="

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrarfcnRangeListForRsrpBoost:Ljava/util/ArrayList;

    invoke-virtual {p3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 641
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 642
    invoke-virtual {p1}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method public getConsolidatedSignalThresholds(II[II)[I
    .locals 7
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 692
    new-instance v0, Ljava/util/TreeSet;

    new-instance v1, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda2;

    invoke-direct {v1, p4}, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda2;-><init>(I)V

    invoke-direct {v0, v1}, Ljava/util/TreeSet;-><init>(Ljava/util/Comparator;)V

    const/4 p4, 0x0

    if-eqz p3, :cond_0

    .line 700
    array-length v1, p3

    move v2, p4

    :goto_0
    if-ge v2, v1, :cond_0

    aget v3, p3, v2

    .line 701
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v0, v3}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 705
    :cond_0
    iget-object p3, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p3}, Lcom/android/internal/telephony/Phone;->isDeviceIdle()Z

    move-result p3

    .line 706
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    .line 710
    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalRequestRecords:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_1
    :goto_1
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    .line 711
    iget v3, v2, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mSubId:I

    if-ne v1, v3, :cond_1

    if-eqz p3, :cond_2

    iget-object v3, v2, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mRequest:Landroid/telephony/SignalStrengthUpdateRequest;

    .line 712
    invoke-virtual {v3}, Landroid/telephony/SignalStrengthUpdateRequest;->isReportingRequestedWhileIdle()Z

    move-result v3

    if-nez v3, :cond_2

    goto :goto_1

    .line 715
    :cond_2
    iget-object v2, v2, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mRequest:Landroid/telephony/SignalStrengthUpdateRequest;

    invoke-virtual {v2}, Landroid/telephony/SignalStrengthUpdateRequest;->getSignalThresholdInfos()Ljava/util/Collection;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_3
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/SignalThresholdInfo;

    .line 716
    invoke-static {p1, p2, v3}, Lcom/android/internal/telephony/SignalStrengthController;->isRanAndSignalMeasurementTypeMatch(IILandroid/telephony/SignalThresholdInfo;)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 717
    invoke-virtual {v3}, Landroid/telephony/SignalThresholdInfo;->getThresholds()[I

    move-result-object v3

    array-length v4, v3

    move v5, p4

    :goto_2
    if-ge v5, v4, :cond_3

    aget v6, v3, v5

    .line 718
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-interface {v0, v6}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    add-int/lit8 v5, v5, 0x1

    goto :goto_2

    .line 724
    :cond_4
    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result p0

    new-array p0, p0, [I

    .line 726
    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_3
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_5

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    add-int/lit8 p3, p4, 0x1

    .line 727
    aput p2, p0, p4

    move p4, p3

    goto :goto_3

    :cond_5
    return-object p0
.end method

.method public getSignalStrength()Landroid/telephony/SignalStrength;
    .locals 1

    .line 347
    invoke-direct {p0}, Lcom/android/internal/telephony/SignalStrengthController;->shouldRefreshSignalStrength()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "getSignalStrength() refreshing signal strength."

    .line 348
    invoke-static {v0}, Lcom/android/internal/telephony/SignalStrengthController;->log(Ljava/lang/String;)V

    const/4 v0, 0x7

    .line 349
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {v0}, Landroid/os/Message;->sendToTarget()V

    .line 351
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrength:Landroid/telephony/SignalStrength;

    return-object p0
.end method

.method public getSignalStrengthFromCi()V
    .locals 2

    .line 308
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x6

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->getSignalStrength(Landroid/os/Message;)V

    return-void
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 4

    .line 183
    iget v0, p1, Landroid/os/Message;->what:I

    packed-switch v0, :pswitch_data_0

    .line 289
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Unhandled message with number: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/SignalStrengthController;->log(Ljava/lang/String;)V

    goto/16 :goto_1

    .line 284
    :pswitch_0
    invoke-direct {p0}, Lcom/android/internal/telephony/SignalStrengthController;->onCarrierConfigChanged()V

    goto/16 :goto_1

    .line 278
    :pswitch_1
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 279
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->onSignalStrengthResult(Landroid/os/AsyncResult;)Z

    goto/16 :goto_1

    .line 271
    :pswitch_2
    iget-object p1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x9

    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->getSignalStrength(Landroid/os/Message;)V

    goto/16 :goto_1

    .line 259
    :pswitch_3
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v0

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    return-void

    .line 263
    :cond_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 264
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->onSignalStrengthResult(Landroid/os/AsyncResult;)Z

    goto/16 :goto_1

    .line 186
    :pswitch_4
    invoke-direct {p0}, Lcom/android/internal/telephony/SignalStrengthController;->onReset()V

    goto/16 :goto_1

    .line 250
    :pswitch_5
    invoke-virtual {p0}, Lcom/android/internal/telephony/SignalStrengthController;->updateReportingCriteria()V

    goto/16 :goto_1

    .line 225
    :pswitch_6
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/util/Pair;

    .line 227
    iget-object v0, p1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    .line 228
    iget-object p1, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p1, Landroid/os/Message;

    .line 231
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalRequestRecords:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    .line 232
    :cond_1
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 233
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    .line 234
    iget-object v2, v2, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mRequest:Landroid/telephony/SignalStrengthUpdateRequest;

    invoke-virtual {v2}, Landroid/telephony/SignalStrengthUpdateRequest;->getLiveToken()Landroid/os/IBinder;

    move-result-object v2

    iget-object v3, v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mRequest:Landroid/telephony/SignalStrengthUpdateRequest;

    invoke-virtual {v3}, Landroid/telephony/SignalStrengthUpdateRequest;->getLiveToken()Landroid/os/IBinder;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 235
    invoke-interface {v1}, Ljava/util/Iterator;->remove()V

    goto :goto_0

    .line 239
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/SignalStrengthController;->updateAlwaysReportSignalStrength()V

    .line 240
    invoke-virtual {p0}, Lcom/android/internal/telephony/SignalStrengthController;->updateReportingCriteria()V

    if-eqz p1, :cond_4

    .line 243
    invoke-static {p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;)Landroid/os/AsyncResult;

    .line 244
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    goto :goto_1

    .line 189
    :pswitch_7
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/util/Pair;

    .line 191
    iget-object v0, p1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    .line 192
    iget-object p1, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p1, Landroid/os/Message;

    .line 193
    invoke-static {p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;)Landroid/os/AsyncResult;

    move-result-object v1

    .line 196
    iget-object v2, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalRequestRecords:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda1;

    invoke-direct {v3, v0}, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;)V

    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v2

    if-eqz v2, :cond_3

    .line 200
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string v0, "setSignalStrengthUpdateRequest called again with same subId"

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    iput-object p0, v1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    .line 202
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    goto :goto_1

    .line 207
    :cond_3
    :try_start_0
    iget-object v2, v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mRequest:Landroid/telephony/SignalStrengthUpdateRequest;

    invoke-virtual {v2}, Landroid/telephony/SignalStrengthUpdateRequest;->getLiveToken()Landroid/os/IBinder;

    move-result-object v2

    const/4 v3, 0x0

    invoke-interface {v2, v0, v3}, Landroid/os/IBinder;->linkToDeath(Landroid/os/IBinder$DeathRecipient;I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/NullPointerException; {:try_start_0 .. :try_end_0} :catch_0

    .line 215
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalRequestRecords:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 217
    invoke-direct {p0}, Lcom/android/internal/telephony/SignalStrengthController;->updateAlwaysReportSignalStrength()V

    .line 218
    invoke-virtual {p0}, Lcom/android/internal/telephony/SignalStrengthController;->updateReportingCriteria()V

    .line 220
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    goto :goto_1

    .line 209
    :catch_0
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string v0, "Signal request client is already dead."

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    iput-object p0, v1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    .line 211
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    :cond_4
    :goto_1
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_3
        :pswitch_0
    .end packed-switch
.end method

.method public notifySignalStrength()Z
    .locals 3

    .line 606
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrength:Landroid/telephony/SignalStrength;

    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLastSignalStrength:Landroid/telephony/SignalStrength;

    invoke-virtual {v0, v1}, Landroid/telephony/SignalStrength;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 608
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->notifySignalStrength()V

    const/4 v1, 0x1

    .line 610
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrength:Landroid/telephony/SignalStrength;

    iput-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLastSignalStrength:Landroid/telephony/SignalStrength;
    :try_end_0
    .catch Ljava/lang/NullPointerException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 612
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "updateSignalStrength() Phone already destroyed: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p0, "SignalStrength not notified"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/SignalStrengthController;->log(Ljava/lang/String;)V

    :cond_0
    :goto_0
    return v1
.end method

.method onDeviceIdleStateChanged(Z)V
    .locals 2

    .line 748
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    const/4 v1, 0x3

    invoke-virtual {p0, v1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 750
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDeviceIdleStateChanged isDeviceIdle="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->localLog(Ljava/lang/String;)V

    return-void
.end method

.method protected onSignalStrengthResult(Landroid/os/AsyncResult;)Z
    .locals 2

    .line 325
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_0

    iget-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz v0, :cond_0

    .line 326
    check-cast v0, Landroid/telephony/SignalStrength;

    iput-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrength:Landroid/telephony/SignalStrength;

    .line 328
    iget-object p1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 329
    iget-object p1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrength:Landroid/telephony/SignalStrength;

    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v1

    iget-object v1, v1, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p1, v0, v1}, Landroid/telephony/SignalStrength;->updateLevel(Landroid/os/PersistableBundle;Landroid/telephony/ServiceState;)V

    goto :goto_0

    .line 332
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onSignalStrengthResult() Exception from RIL : "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/SignalStrengthController;->log(Ljava/lang/String;)V

    .line 333
    new-instance p1, Landroid/telephony/SignalStrength;

    invoke-direct {p1}, Landroid/telephony/SignalStrength;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrength:Landroid/telephony/SignalStrength;

    .line 335
    :cond_1
    :goto_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrengthUpdatedTime:J

    .line 337
    invoke-virtual {p0}, Lcom/android/internal/telephony/SignalStrengthController;->notifySignalStrength()Z

    move-result p0

    return p0
.end method

.method public setSignalStrengthDefaultValues()V
    .locals 2

    .line 598
    new-instance v0, Landroid/telephony/SignalStrength;

    invoke-direct {v0}, Landroid/telephony/SignalStrength;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrength:Landroid/telephony/SignalStrength;

    .line 599
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalStrengthUpdatedTime:J

    return-void
.end method

.method public setSignalStrengthUpdateRequest(IILandroid/telephony/SignalStrengthUpdateRequest;Landroid/os/Message;)V
    .locals 2

    .line 650
    new-instance v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    invoke-direct {v0, p0, p1, p2, p3}, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;-><init>(Lcom/android/internal/telephony/SignalStrengthController;IILandroid/telephony/SignalStrengthUpdateRequest;)V

    .line 651
    new-instance v1, Landroid/util/Pair;

    invoke-direct {v1, v0, p4}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    const/4 p4, 0x1

    invoke-virtual {p0, p4, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p4

    invoke-virtual {p0, p4}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 654
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "setSignalStrengthUpdateRequest subId="

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " callingUid="

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " request="

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->localLog(Ljava/lang/String;)V

    return-void
.end method

.method public shouldEnableSignalThresholdForAppRequest(IIIZ)Z
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 762
    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalRequestRecords:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_4

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;

    .line 763
    iget v1, v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mSubId:I

    if-eq p3, v1, :cond_1

    goto :goto_0

    .line 766
    :cond_1
    iget-object v1, v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mRequest:Landroid/telephony/SignalStrengthUpdateRequest;

    invoke-virtual {v1}, Landroid/telephony/SignalStrengthUpdateRequest;->getSignalThresholdInfos()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_2
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/SignalThresholdInfo;

    .line 767
    invoke-static {p1, p2, v2}, Lcom/android/internal/telephony/SignalStrengthController;->isRanAndSignalMeasurementTypeMatch(IILandroid/telephony/SignalThresholdInfo;)Z

    move-result v2

    if-eqz v2, :cond_2

    if-eqz p4, :cond_3

    iget-object v2, v0, Lcom/android/internal/telephony/SignalStrengthController$SignalRequestRecord;->mRequest:Landroid/telephony/SignalStrengthUpdateRequest;

    .line 768
    invoke-static {v2}, Lcom/android/internal/telephony/SignalStrengthController;->isSignalReportRequestedWhileIdle(Landroid/telephony/SignalStrengthUpdateRequest;)Z

    move-result v2

    if-eqz v2, :cond_2

    :cond_3
    const/4 p0, 0x1

    return p0

    :cond_4
    const/4 p0, 0x0

    return p0
.end method

.method public shouldHonorSystemThresholds()Z
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 737
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isDeviceIdle()Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p0, 0x1

    return p0

    .line 741
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 742
    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mSignalRequestRecords:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v1, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda0;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/SignalStrengthController$$ExternalSyntheticLambda0;-><init>(I)V

    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0
.end method

.method updateArfcnLists()V
    .locals 4

    .line 850
    iget-object v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mRsrpBoostLock:Ljava/lang/Object;

    monitor-enter v0

    .line 851
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v2, "lte_earfcns_rsrp_boost_int"

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;I)I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLteRsrpBoost:I

    .line 853
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v2, "boosted_lte_earfcns_string_array"

    invoke-virtual {v1, v2}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 855
    invoke-static {v1}, Lcom/android/internal/telephony/SignalStrengthController;->convertEarfcnStringArrayToPairList([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mEarfcnPairListForRsrpBoost:Ljava/util/ArrayList;

    .line 858
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v2, "nrarfcns_rsrp_boost_int_array"

    invoke-virtual {v1, v2}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrRsrpBoost:[I

    .line 860
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v2, "boosted_nrarfcns_string_array"

    invoke-virtual {v1, v2}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 862
    invoke-static {v1}, Lcom/android/internal/telephony/SignalStrengthController;->convertEarfcnStringArrayToPairList([Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrarfcnRangeListForRsrpBoost:Ljava/util/ArrayList;

    .line 865
    iget-object v2, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrRsrpBoost:[I

    if-nez v2, :cond_0

    if-nez v1, :cond_2

    :cond_0
    if-eqz v2, :cond_1

    if-eqz v1, :cond_2

    :cond_1
    if-eqz v2, :cond_3

    if-eqz v1, :cond_3

    array-length v2, v2

    .line 868
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-eq v2, v1, :cond_3

    :cond_2
    const-string v1, "Invalid parameters for NR RSRP boost"

    .line 869
    invoke-static {v1}, Lcom/android/internal/telephony/SignalStrengthController;->loge(Ljava/lang/String;)V

    const/4 v1, 0x0

    .line 870
    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrRsrpBoost:[I

    .line 871
    iput-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrarfcnRangeListForRsrpBoost:Ljava/util/ArrayList;

    .line 873
    :cond_3
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public updateReportingCriteria()V
    .locals 9
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 392
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 394
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v2, "gsm_rssi_thresholds_int_array"

    invoke-virtual {v1, v2}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v1

    const/4 v2, 0x1

    if-eqz v1, :cond_0

    .line 398
    invoke-static {v2, v1, v2, v2}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 397
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 405
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string/jumbo v3, "wcdma_rscp_thresholds_int_array"

    invoke-virtual {v1, v3}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v1

    if-eqz v1, :cond_1

    const/4 v3, 0x2

    .line 409
    invoke-static {v3, v1, v3, v2}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 408
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 416
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v3, "parameters_used_for_lte_signal_bar_int"

    invoke-virtual {v1, v3, v2}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;I)I

    move-result v1

    .line 418
    iget-object v3, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v4, "lte_rsrp_thresholds_int_array"

    invoke-virtual {v3, v4}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v3

    const/4 v4, 0x3

    const/4 v5, 0x0

    if-eqz v3, :cond_3

    and-int/lit8 v6, v1, 0x1

    if-eqz v6, :cond_2

    move v6, v2

    goto :goto_0

    :cond_2
    move v6, v5

    .line 422
    :goto_0
    invoke-static {v4, v3, v4, v6}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v3

    .line 421
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 429
    :cond_3
    iget-object v3, p0, Lcom/android/internal/telephony/SignalStrengthController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getHalVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object v3

    sget-object v6, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v3, v6}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v3

    if-eqz v3, :cond_d

    .line 430
    iget-object v3, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v6, "lte_rsrq_thresholds_int_array"

    invoke-virtual {v3, v6}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v3

    const/4 v6, 0x4

    if-eqz v3, :cond_5

    and-int/lit8 v7, v1, 0x2

    if-eqz v7, :cond_4

    move v7, v2

    goto :goto_1

    :cond_4
    move v7, v5

    .line 434
    :goto_1
    invoke-static {v6, v3, v4, v7}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v3

    .line 433
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 441
    :cond_5
    iget-object v3, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v7, "lte_rssnr_thresholds_int_array"

    invoke-virtual {v3, v7}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v3

    if-eqz v3, :cond_7

    const/4 v7, 0x5

    and-int/2addr v1, v6

    if-eqz v1, :cond_6

    move v1, v2

    goto :goto_2

    :cond_6
    move v1, v5

    .line 445
    :goto_2
    invoke-static {v7, v3, v4, v1}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 444
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 452
    :cond_7
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v3, "parameters_use_for_5g_nr_signal_bar_int"

    invoke-virtual {v1, v3, v2}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;I)I

    move-result v1

    .line 454
    iget-object v3, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v4, "5g_nr_ssrsrp_thresholds_int_array"

    invoke-virtual {v3, v4}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v3

    const/4 v4, 0x6

    if-eqz v3, :cond_9

    and-int/lit8 v7, v1, 0x1

    if-eqz v7, :cond_8

    move v7, v2

    goto :goto_3

    :cond_8
    move v7, v5

    .line 458
    :goto_3
    invoke-static {v4, v3, v4, v7}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v3

    .line 457
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 465
    :cond_9
    iget-object v3, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v7, "5g_nr_ssrsrq_thresholds_int_array"

    invoke-virtual {v3, v7}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v3

    if-eqz v3, :cond_b

    const/4 v7, 0x7

    and-int/lit8 v8, v1, 0x2

    if-eqz v8, :cond_a

    move v8, v2

    goto :goto_4

    :cond_a
    move v8, v5

    .line 469
    :goto_4
    invoke-static {v7, v3, v4, v8}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v3

    .line 468
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 476
    :cond_b
    iget-object v3, p0, Lcom/android/internal/telephony/SignalStrengthController;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v7, "5g_nr_sssinr_thresholds_int_array"

    invoke-virtual {v3, v7}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v3

    if-eqz v3, :cond_d

    const/16 v7, 0x8

    and-int/2addr v1, v6

    if-eqz v1, :cond_c

    goto :goto_5

    :cond_c
    move v2, v5

    .line 480
    :goto_5
    invoke-static {v7, v3, v4, v2}, Lcom/android/internal/telephony/SignalStrengthController;->createSignalThresholdsInfo(I[IIZ)Landroid/telephony/SignalThresholdInfo;

    move-result-object v1

    .line 479
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 488
    :cond_d
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/SignalStrengthController;->consolidatedAndSetReportingCriteria(Ljava/util/List;)V

    return-void
.end method

.method updateServiceStateArfcnRsrpBoost(Landroid/telephony/ServiceState;Landroid/telephony/CellIdentity;)V
    .locals 5

    if-nez p2, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 885
    iget-object v1, p0, Lcom/android/internal/telephony/SignalStrengthController;->mRsrpBoostLock:Ljava/lang/Object;

    monitor-enter v1

    .line 886
    :try_start_0
    invoke-virtual {p2}, Landroid/telephony/CellIdentity;->getType()I

    move-result v2

    const/4 v3, 0x3

    const/4 v4, -0x1

    if-eq v2, v3, :cond_2

    const/4 v3, 0x6

    if-eq v2, v3, :cond_1

    goto :goto_0

    .line 896
    :cond_1
    check-cast p2, Landroid/telephony/CellIdentityNr;

    invoke-virtual {p2}, Landroid/telephony/CellIdentityNr;->getNrarfcn()I

    move-result p2

    if-eq p2, v4, :cond_3

    .line 898
    iget-object v2, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrarfcnRangeListForRsrpBoost:Ljava/util/ArrayList;

    invoke-static {v2, p2}, Lcom/android/internal/telephony/SignalStrengthController;->containsEarfcnInEarfcnRange(Ljava/util/ArrayList;I)I

    move-result p2

    if-eq p2, v4, :cond_3

    .line 900
    iget-object p0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mNrRsrpBoost:[I

    if-eqz p0, :cond_3

    .line 901
    aget p0, p0, p2

    move v0, p0

    goto :goto_0

    .line 888
    :cond_2
    check-cast p2, Landroid/telephony/CellIdentityLte;

    invoke-virtual {p2}, Landroid/telephony/CellIdentityLte;->getEarfcn()I

    move-result p2

    if-eq p2, v4, :cond_3

    .line 889
    iget-object v2, p0, Lcom/android/internal/telephony/SignalStrengthController;->mEarfcnPairListForRsrpBoost:Ljava/util/ArrayList;

    .line 890
    invoke-static {v2, p2}, Lcom/android/internal/telephony/SignalStrengthController;->containsEarfcnInEarfcnRange(Ljava/util/ArrayList;I)I

    move-result p2

    if-eq p2, v4, :cond_3

    .line 892
    iget v0, p0, Lcom/android/internal/telephony/SignalStrengthController;->mLteRsrpBoost:I

    .line 908
    :cond_3
    :goto_0
    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 909
    invoke-virtual {p1, v0}, Landroid/telephony/ServiceState;->setArfcnRsrpBoost(I)V

    return-void

    :catchall_0
    move-exception p0

    .line 908
    :try_start_1
    monitor-exit v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method
