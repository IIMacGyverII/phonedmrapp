.class public Lcom/android/internal/telephony/data/DataStallRecoveryManager;
.super Landroid/os/Handler;
.source "DataStallRecoveryManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/DataStallRecoveryManager$DataStallRecoveryManagerCallback;,
        Lcom/android/internal/telephony/data/DataStallRecoveryManager$RecoveredReason;,
        Lcom/android/internal/telephony/data/DataStallRecoveryManager$RecoveryAction;
    }
.end annotation


# static fields
.field private static final EVENT_DATA_CONFIG_UPDATED:I = 0x1

.field private static final EVENT_DO_RECOVERY:I = 0x2

.field private static final EVENT_RADIO_STATE_CHANGED:I = 0x3

.field private static final RECOVERED_REASON_DSRM:I = 0x1

.field private static final RECOVERED_REASON_MODEM:I = 0x2

.field private static final RECOVERED_REASON_NONE:I = 0x0

.field private static final RECOVERED_REASON_USER:I = 0x3

.field public static final RECOVERY_ACTION_CLEANUP:I = 0x1

.field public static final RECOVERY_ACTION_GET_DATA_CALL_LIST:I = 0x0

.field public static final RECOVERY_ACTION_RADIO_RESTART:I = 0x3

.field public static final RECOVERY_ACTION_REREGISTER:I = 0x2
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation
.end field

.field public static final RECOVERY_ACTION_RESET_MODEM:I = 0x4

.field private static final VDBG:Z = false


# instance fields
.field private final mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

.field private final mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

.field private mDataStallRecoveryDelayMillisArray:[J

.field private mDataStallRecoveryManagerCallback:Lcom/android/internal/telephony/data/DataStallRecoveryManager$DataStallRecoveryManagerCallback;

.field private mDataStallStartMs:J

.field private mDataStalled:Z

.field private mIsAttemptedAllSteps:Z

.field private mIsInternetNetworkConnected:Z

.field private mIsValidNetwork:Z

.field private mLastAction:I

.field private mLastActionReported:Z

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mLogTag:Ljava/lang/String;

.field private mMobileDataChangedToEnabledDuringDataStall:Z

.field private mNetworkCheckTimerStarted:Z

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private mRadioPowerState:I

.field private mRadioStateChangedDuringDataStall:Z

.field private mRecovryAction:I

.field private mSkipRecoveryActionArray:[Z

.field private mTimeLastRecoveryStartMs:J

.field private final mWwanDataServiceManager:Lcom/android/internal/telephony/data/DataServiceManager;


# direct methods
.method public static synthetic $r8$lambda$Cdbu4LjMoxQu16XRfCGDwlu1QFE(Lcom/android/internal/telephony/data/DataStallRecoveryManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->lambda$cleanUpDataNetwork$0()V

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmIsInternetNetworkConnected(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsInternetNetworkConnected:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$mlogl(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monInternetValidationStatusChanged(Lcom/android/internal/telephony/data/DataStallRecoveryManager;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->onInternetValidationStatusChanged(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monMobileDataEnabledChanged(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->onMobileDataEnabledChanged(Z)V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataStallRecoveryManager$DataStallRecoveryManagerCallback;)V
    .locals 1

    .line 220
    invoke-direct {p0, p4}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 138
    new-instance p4, Lcom/android/internal/telephony/LocalLog;

    const/16 v0, 0x80

    invoke-direct {p4, v0}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    const/4 p4, 0x0

    .line 166
    iput-boolean p4, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mNetworkCheckTimerStarted:Z

    .line 221
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 222
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "DSRM-"

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p4

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLogTag:Ljava/lang/String;

    const-string p4, "DataStallRecoveryManager created."

    .line 223
    invoke-direct {p0, p4}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 224
    iput-object p2, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    .line 225
    iput-object p3, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mWwanDataServiceManager:Lcom/android/internal/telephony/data/DataServiceManager;

    .line 226
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataConfigManager()Lcom/android/internal/telephony/data/DataConfigManager;

    move-result-object p3

    iput-object p3, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 228
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object p2

    new-instance p3, Lcom/android/internal/telephony/data/DataStallRecoveryManager$1;

    new-instance p4, Lcom/android/internal/telephony/data/DataStallRecoveryManager$$ExternalSyntheticLambda0;

    invoke-direct {p4, p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/DataStallRecoveryManager;)V

    invoke-direct {p3, p0, p4}, Lcom/android/internal/telephony/data/DataStallRecoveryManager$1;-><init>(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Ljava/util/concurrent/Executor;)V

    .line 229
    invoke-virtual {p2, p3}, Lcom/android/internal/telephony/data/DataSettingsManager;->registerCallback(Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)V

    .line 239
    iput-object p5, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallRecoveryManagerCallback:Lcom/android/internal/telephony/data/DataStallRecoveryManager$DataStallRecoveryManagerCallback;

    .line 240
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getRadioPowerState()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioPowerState:I

    .line 241
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->updateDataStallRecoveryConfigs()V

    .line 243
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->registerAllEvents()V

    return-void
.end method

.method private broadcastDataStallDetected(I)V
    .locals 2

    .line 465
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "broadcastDataStallDetected recoveryAction: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 466
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.DATA_STALL_DETECTED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 467
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-static {v0, v1}, Landroid/telephony/SubscriptionManager;->putPhoneIdAndSubIdExtra(Landroid/content/Intent;I)V

    const-string v1, "recoveryAction"

    .line 468
    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 469
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    return-void
.end method

.method private cancelNetworkCheckTimer()V
    .locals 1

    const-string v0, "cancelNetworkCheckTimer()"

    .line 516
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 517
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mNetworkCheckTimerStarted:Z

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    .line 518
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mNetworkCheckTimerStarted:Z

    const/4 v0, 0x2

    .line 519
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    :cond_0
    return-void
.end method

.method private cleanUpDataNetwork()V
    .locals 2

    const-string v0, "cleanUpDataNetwork: notify clean up data network"

    .line 480
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 481
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallRecoveryManagerCallback:Lcom/android/internal/telephony/data/DataStallRecoveryManager$DataStallRecoveryManagerCallback;

    new-instance v1, Lcom/android/internal/telephony/data/DataStallRecoveryManager$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/DataStallRecoveryManager;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private doRecovery()V
    .locals 5

    .line 639
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getRecoveryAction()I

    move-result v0

    .line 640
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSignalStrength()Landroid/telephony/SignalStrength;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/SignalStrength;->getLevel()I

    move-result v1

    const/4 v2, 0x0

    .line 644
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->isRecoveryNeeded(Z)Z

    move-result v3

    if-nez v3, :cond_0

    .line 645
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->cancelNetworkCheckTimer()V

    .line 646
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->startNetworkCheckTimer(I)V

    return-void

    .line 650
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v3

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 651
    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v4

    invoke-virtual {v3, v4, v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeSignalStrengthEvent(II)V

    .line 652
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v1

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    invoke-virtual {v1, v3, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeDataStallEvent(II)V

    .line 653
    iput v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastAction:I

    .line 654
    iput-boolean v2, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastActionReported:Z

    .line 655
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->broadcastDataStallDetected(I)V

    .line 656
    iput-boolean v2, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mNetworkCheckTimerStarted:Z

    const/4 v1, 0x1

    if-eqz v0, :cond_4

    const/4 v2, 0x3

    if-eq v0, v1, :cond_3

    const/4 v3, 0x4

    if-eq v0, v2, :cond_2

    if-ne v0, v3, :cond_1

    const-string v0, "doRecovery(): modem reset"

    .line 675
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    .line 676
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->rebootModem()V

    .line 677
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->resetAction()V

    .line 678
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsAttemptedAllSteps:Z

    goto :goto_0

    .line 681
    :cond_1
    new-instance p0, Ljava/lang/RuntimeException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "doRecovery: Invalid recoveryAction = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 683
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->recoveryActionToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_2
    const-string v0, "doRecovery(): restarting radio"

    .line 670
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    .line 671
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->setRecoveryAction(I)V

    .line 672
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->powerOffRadio()V

    goto :goto_0

    :cond_3
    const-string v0, "doRecovery(): cleanup all connections"

    .line 665
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    .line 666
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->cleanUpDataNetwork()V

    .line 667
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->setRecoveryAction(I)V

    goto :goto_0

    :cond_4
    const-string v0, "doRecovery(): get data call list"

    .line 660
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    .line 661
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getDataCallList()V

    .line 662
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->setRecoveryAction(I)V

    .line 686
    :goto_0
    iget v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastAction:I

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->startNetworkCheckTimer(I)V

    return-void
.end method

.method private getDataCallList()V
    .locals 1

    const-string v0, "getDataCallList: request data call list"

    .line 474
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 475
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mWwanDataServiceManager:Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataServiceManager;->requestDataCallList(Landroid/os/Message;)V

    return-void
.end method

.method private getDataStallRecoveryDelayMillis(I)J
    .locals 0

    .line 309
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallRecoveryDelayMillisArray:[J

    aget-wide p0, p0, p1

    return-wide p0
.end method

.method private getElapsedTimeSinceRecoveryMs()J
    .locals 4

    .line 456
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mTimeLastRecoveryStartMs:J

    sub-long/2addr v0, v2

    return-wide v0
.end method

.method private getRecoveredReason(Z)I
    .locals 1

    if-nez p1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 624
    :cond_0
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioStateChangedDuringDataStall:Z

    const/4 v0, 0x1

    if-eqz p1, :cond_3

    .line 625
    iget p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastAction:I

    if-gt p0, v0, :cond_1

    const/4 p1, 0x2

    goto :goto_0

    :cond_1
    move p1, v0

    :goto_0
    if-le p0, v0, :cond_2

    goto :goto_1

    :cond_2
    move v0, p1

    goto :goto_1

    .line 631
    :cond_3
    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mMobileDataChangedToEnabledDuringDataStall:Z

    if-eqz p0, :cond_4

    const/4 v0, 0x3

    :cond_4
    :goto_1
    return v0
.end method

.method private isRecoveryAlreadyStarted()Z
    .locals 0

    .line 447
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getRecoveryAction()I

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isRecoveryNeeded(Z)Z
    .locals 6

    const-string v0, "enter: isRecoveryNeeded()"

    .line 532
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logv(Ljava/lang/String;)V

    .line 535
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsAttemptedAllSteps:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    const-string/jumbo p1, "skip retrying continue recovery action"

    .line 536
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    return v1

    .line 541
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getElapsedTimeSinceRecoveryMs()J

    move-result-wide v2

    iget v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastAction:I

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getDataStallRecoveryDelayMillis(I)J

    move-result-wide v4

    cmp-long v0, v2, v4

    if-gez v0, :cond_1

    if-eqz p1, :cond_1

    const-string/jumbo p1, "skip back to back data stall recovery"

    .line 543
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    return v1

    .line 548
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getState()Lcom/android/internal/telephony/PhoneConstants$State;

    move-result-object p1

    sget-object v0, Lcom/android/internal/telephony/PhoneConstants$State;->IDLE:Lcom/android/internal/telephony/PhoneConstants$State;

    const/4 v2, 0x1

    if-eq p1, v0, :cond_2

    .line 549
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getRecoveryAction()I

    move-result p1

    if-le p1, v2, :cond_2

    const-string/jumbo p1, "skip data stall recovery as there is an active call"

    .line 550
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    return v1

    .line 555
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSignalStrength()Landroid/telephony/SignalStrength;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/SignalStrength;->getLevel()I

    move-result p1

    if-gt p1, v2, :cond_3

    const-string/jumbo p1, "skip data stall recovery as in poor signal condition"

    .line 556
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    return v1

    .line 560
    :cond_3
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetworkController;->isInternetDataAllowed()Z

    move-result p1

    if-nez p1, :cond_4

    const-string/jumbo p1, "skip data stall recovery as data not allowed."

    .line 561
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    return v1

    .line 565
    :cond_4
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsInternetNetworkConnected:Z

    if-nez p1, :cond_5

    const-string/jumbo p1, "skip data stall recovery as data not connected"

    .line 566
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    return v1

    :cond_5
    return v2
.end method

.method private synthetic lambda$cleanUpDataNetwork$0()V
    .locals 0

    .line 482
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallRecoveryManagerCallback:Lcom/android/internal/telephony/data/DataStallRecoveryManager$DataStallRecoveryManagerCallback;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager$DataStallRecoveryManagerCallback;->onDataStallReestablishInternet()V

    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 756
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 774
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private logl(Ljava/lang/String;)V
    .locals 0

    .line 783
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 784
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method private logv(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method private onDataConfigUpdated()V
    .locals 0

    .line 324
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->updateDataStallRecoveryConfigs()V

    return-void
.end method

.method private onInternetValidationStatusChanged(I)V
    .locals 2

    .line 361
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onInternetValidationStatusChanged: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->validationStatusToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    const/4 v0, 0x0

    const/4 v1, 0x1

    if-ne p1, v1, :cond_0

    move p1, v1

    goto :goto_0

    :cond_0
    move p1, v0

    .line 363
    :goto_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->setNetworkValidationState(Z)V

    if-eqz p1, :cond_1

    .line 365
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->reset()V

    goto :goto_1

    .line 367
    :cond_1
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsValidNetwork:Z

    if-nez p1, :cond_2

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->isRecoveryAlreadyStarted()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 368
    :cond_2
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsValidNetwork:Z

    .line 369
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->isRecoveryNeeded(Z)Z

    move-result p1

    if-eqz p1, :cond_3

    const-string/jumbo p1, "trigger data stall recovery"

    .line 370
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 371
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mTimeLastRecoveryStartMs:J

    const/4 p1, 0x2

    .line 372
    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    :cond_3
    :goto_1
    return-void
.end method

.method private onMobileDataEnabledChanged(Z)V
    .locals 2

    .line 333
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onMobileDataEnabledChanged: DataEnabled:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ",DataStalled:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStalled:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    .line 336
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStalled:Z

    if-eqz v0, :cond_0

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    .line 337
    iput-boolean p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mMobileDataChangedToEnabledDuringDataStall:Z

    :cond_0
    return-void
.end method

.method private powerOffRadio()V
    .locals 1

    const-string v0, "powerOffRadio: Restart radio"

    .line 487
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 488
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->powerOffRadioSafely()V

    return-void
.end method

.method private static radioPowerStateToString(I)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_2

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v0, 0x2

    if-eq p0, v0, :cond_0

    .line 725
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "RADIO_POWER_UNAVAILABLE"

    return-object p0

    :cond_1
    const-string p0, "RADIO_POWER_ON"

    return-object p0

    :cond_2
    const-string p0, "RADIO_POWER_OFF"

    return-object p0
.end method

.method private rebootModem()V
    .locals 1

    const-string v0, "rebootModem: reboot modem"

    .line 493
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 494
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->rebootModem(Landroid/os/Message;)V

    return-void
.end method

.method private static recoveredReasonToString(I)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_3

    const/4 v0, 0x1

    if-eq p0, v0, :cond_2

    const/4 v0, 0x2

    if-eq p0, v0, :cond_1

    const/4 v0, 0x3

    if-eq p0, v0, :cond_0

    .line 706
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "RECOVERED_REASON_USER"

    return-object p0

    :cond_1
    const-string p0, "RECOVERED_REASON_MODEM"

    return-object p0

    :cond_2
    const-string p0, "RECOVERED_REASON_DSRM"

    return-object p0

    :cond_3
    const-string p0, "RECOVERED_REASON_NONE"

    return-object p0
.end method

.method private static recoveryActionToString(I)Ljava/lang/String;
    .locals 2

    if-eqz p0, :cond_3

    const/4 v0, 0x1

    if-eq p0, v0, :cond_2

    const/4 v0, 0x3

    if-eq p0, v0, :cond_1

    const/4 v0, 0x4

    if-eq p0, v0, :cond_0

    .line 746
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "RECOVERY_ACTION_RESET_MODEM"

    return-object p0

    :cond_1
    const-string p0, "RECOVERY_ACTION_RADIO_RESTART"

    return-object p0

    :cond_2
    const-string p0, "RECOVERY_ACTION_CLEANUP"

    return-object p0

    :cond_3
    const-string p0, "RECOVERY_ACTION_GET_DATA_CALL_LIST"

    return-object p0
.end method

.method private registerAllEvents()V
    .locals 3

    .line 248
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    const/4 v1, 0x1

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/data/DataConfigManager;->registerForConfigUpdate(Landroid/os/Handler;I)V

    .line 249
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    new-instance v1, Lcom/android/internal/telephony/data/DataStallRecoveryManager$2;

    new-instance v2, Lcom/android/internal/telephony/data/DataStallRecoveryManager$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/DataStallRecoveryManager;)V

    invoke-direct {v1, p0, v2}, Lcom/android/internal/telephony/data/DataStallRecoveryManager$2;-><init>(Lcom/android/internal/telephony/data/DataStallRecoveryManager;Ljava/util/concurrent/Executor;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->registerDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    .line 270
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x3

    const/4 v2, 0x0

    invoke-interface {v0, p0, v1, v2}, Lcom/android/internal/telephony/CommandsInterface;->registerForRadioStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method private reset()V
    .locals 3

    const/4 v0, 0x1

    .line 345
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsValidNetwork:Z

    const/4 v0, 0x0

    .line 346
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsAttemptedAllSteps:Z

    .line 347
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioStateChangedDuringDataStall:Z

    .line 348
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mMobileDataChangedToEnabledDuringDataStall:Z

    .line 349
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->cancelNetworkCheckTimer()V

    const-wide/16 v1, 0x0

    .line 350
    iput-wide v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mTimeLastRecoveryStartMs:J

    .line 351
    iput v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastAction:I

    .line 352
    iput v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRecovryAction:I

    return-void
.end method

.method private resetAction()V
    .locals 2

    const-wide/16 v0, 0x0

    .line 380
    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mTimeLastRecoveryStartMs:J

    const/4 v0, 0x0

    .line 381
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mMobileDataChangedToEnabledDuringDataStall:Z

    .line 382
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioStateChangedDuringDataStall:Z

    .line 383
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->setRecoveryAction(I)V

    return-void
.end method

.method private setNetworkValidationState(Z)V
    .locals 6

    if-eqz p1, :cond_0

    .line 580
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStalled:Z

    if-nez v0, :cond_0

    return-void

    .line 584
    :cond_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStalled:Z

    const/4 v1, 0x1

    if-nez v0, :cond_1

    .line 585
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStalled:Z

    .line 586
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallStartMs:J

    .line 587
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "data stall: start time = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallStartMs:J

    invoke-static {v0, v1}, Lcom/android/internal/telephony/data/DataUtils;->elapsedTimeToString(J)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    return-void

    .line 591
    :cond_1
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastActionReported:Z

    if-nez v0, :cond_2

    .line 592
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getRecoveredReason(Z)I

    move-result v0

    .line 593
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    iget-wide v4, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallStartMs:J

    sub-long/2addr v2, v4

    long-to-int v2, v2

    .line 594
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "data stall: lastaction = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastAction:I

    .line 596
    invoke-static {v4}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->recoveryActionToString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", isRecovered = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, ", reason = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 600
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->recoveredReasonToString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", TimeDuration = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 594
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logl(Ljava/lang/String;)V

    .line 603
    iget v3, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastAction:I

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v3, v4, p1, v2, v0}, Lcom/android/internal/telephony/metrics/DataStallRecoveryStats;->onDataStallEvent(ILcom/android/internal/telephony/Phone;ZII)V

    .line 605
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastActionReported:Z

    :cond_2
    if-eqz p1, :cond_3

    const/4 p1, 0x0

    .line 609
    iput-boolean p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastActionReported:Z

    .line 610
    iput-boolean p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStalled:Z

    :cond_3
    return-void
.end method

.method private shouldSkipRecoveryAction(I)Z
    .locals 0

    .line 319
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mSkipRecoveryActionArray:[Z

    aget-boolean p0, p0, p1

    return p0
.end method

.method private startNetworkCheckTimer(I)V
    .locals 3

    const/4 v0, 0x4

    if-ne p1, v0, :cond_0

    return-void

    .line 505
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "startNetworkCheckTimer(): "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getDataStallRecoveryDelayMillis(I)J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "ms"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 506
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mNetworkCheckTimerStarted:Z

    if-nez v0, :cond_1

    const/4 v0, 0x1

    .line 507
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mNetworkCheckTimerStarted:Z

    .line 508
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mTimeLastRecoveryStartMs:J

    const/4 v0, 0x2

    .line 510
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getDataStallRecoveryDelayMillis(I)J

    move-result-wide v1

    .line 509
    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    :cond_1
    return-void
.end method

.method private updateDataStallRecoveryConfigs()V
    .locals 1

    .line 298
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getDataStallRecoveryDelayMillis()[J

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallRecoveryDelayMillisArray:[J

    .line 299
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getDataStallRecoveryShouldSkipArray()[Z

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mSkipRecoveryActionArray:[Z

    return-void
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 3

    .line 795
    new-instance v0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 796
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-class v1, Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    .line 797
    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "-"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 796
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 798
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 800
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsValidNetwork="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsValidNetwork:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 801
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsInternetNetworkConnected="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsInternetNetworkConnected:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 802
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataStalled="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStalled:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 803
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mLastAction="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastAction:I

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->recoveryActionToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 804
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsAttemptedAllSteps="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mIsAttemptedAllSteps:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 805
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataStallStartMs="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallStartMs:J

    invoke-static {v1, v2}, Lcom/android/internal/telephony/data/DataUtils;->elapsedTimeToString(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 806
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mRadioPowerState="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioPowerState:I

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->radioPowerStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 807
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mLastActionReported="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLastActionReported:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 808
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mTimeLastRecoveryStartMs="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mTimeLastRecoveryStartMs:J

    .line 809
    invoke-static {v1, v2}, Lcom/android/internal/telephony/data/DataUtils;->elapsedTimeToString(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 808
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 810
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getRecoveryAction()="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->getRecoveryAction()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->recoveryActionToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 811
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mRadioStateChangedDuringDataStall="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioStateChangedDuringDataStall:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 812
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mMobileDataChangedToEnabledDuringDataStall="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mMobileDataChangedToEnabledDuringDataStall:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 815
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DataStallRecoveryDelayMillisArray="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStallRecoveryDelayMillisArray:[J

    .line 817
    invoke-static {v1}, Ljava/util/Arrays;->toString([J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 815
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 818
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "SkipRecoveryActionArray="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mSkipRecoveryActionArray:[Z

    invoke-static {v1}, Ljava/util/Arrays;->toString([Z)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 819
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, ""

    .line 820
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Local logs:"

    .line 822
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 823
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 824
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 825
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 826
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-void
.end method

.method public getRecoveryAction()I
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 394
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getRecoveryAction: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRecovryAction:I

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->recoveryActionToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    .line 395
    iget p0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRecovryAction:I

    return p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 275
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handleMessage = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->logv(Ljava/lang/String;)V

    .line 276
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_2

    const/4 v2, 0x2

    if-eq v0, v2, :cond_1

    const/4 v2, 0x3

    if-eq v0, v2, :cond_0

    .line 291
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected message = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 284
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getRadioPowerState()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioPowerState:I

    .line 285
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mDataStalled:Z

    if-eqz p1, :cond_3

    .line 287
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioStateChangedDuringDataStall:Z

    goto :goto_0

    .line 281
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->doRecovery()V

    goto :goto_0

    .line 278
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->onDataConfigUpdated()V

    :cond_3
    :goto_0
    return-void
.end method

.method public setRecoveryAction(I)V
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 405
    iput p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRecovryAction:I

    .line 410
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mMobileDataChangedToEnabledDuringDataStall:Z

    const/4 v1, 0x3

    if-eqz v0, :cond_0

    if-ge p1, v1, :cond_0

    .line 412
    iput v1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRecovryAction:I

    .line 416
    :cond_0
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioStateChangedDuringDataStall:Z

    const/4 v0, 0x4

    const/4 v2, 0x1

    if-eqz p1, :cond_1

    iget p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRadioPowerState:I

    if-ne p1, v2, :cond_1

    .line 418
    iput v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRecovryAction:I

    .line 421
    :cond_1
    iget p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRecovryAction:I

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->shouldSkipRecoveryAction(I)Z

    move-result p1

    if-eqz p1, :cond_6

    .line 422
    iget p1, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRecovryAction:I

    if-eqz p1, :cond_5

    if-eq p1, v2, :cond_4

    if-eq p1, v1, :cond_3

    if-eq p1, v0, :cond_2

    goto :goto_0

    .line 433
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->resetAction()V

    goto :goto_0

    .line 430
    :cond_3
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->setRecoveryAction(I)V

    goto :goto_0

    .line 427
    :cond_4
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->setRecoveryAction(I)V

    goto :goto_0

    .line 424
    :cond_5
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->setRecoveryAction(I)V

    .line 438
    :cond_6
    :goto_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "setRecoveryAction: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->mRecovryAction:I

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->recoveryActionToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->log(Ljava/lang/String;)V

    return-void
.end method
