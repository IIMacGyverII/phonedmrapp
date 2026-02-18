.class Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;
.super Ljava/lang/Object;
.source "DcTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DcTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "DataStallRecoveryHandler"
.end annotation


# static fields
.field private static final DEFAULT_MIN_DURATION_BETWEEN_RECOVERY_STEPS_IN_MS:I = 0x2bf20


# instance fields
.field private mDataStallStartMs:J

.field private mIsValidNetwork:Z

.field private mLastAction:I

.field private mLastActionReported:Z

.field private mTimeLastRecoveryStartMs:J

.field private mWasDataStall:Z

.field final synthetic this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;


# direct methods
.method static bridge synthetic -$$Nest$mgetRecoveryAction(Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;)I
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->getRecoveryAction()I

    move-result p0

    return p0
.end method

.method public constructor <init>(Lcom/android/internal/telephony/dataconnection/DcTracker;)V
    .locals 0

    .line 5069
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 5070
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->reset()V

    return-void
.end method

.method private broadcastDataStallDetected(I)V
    .locals 2

    .line 5140
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.DATA_STALL_DETECTED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 5141
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v1, v1, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-static {v0, v1}, Landroid/telephony/SubscriptionManager;->putPhoneIdAndSubIdExtra(Landroid/content/Intent;I)V

    const-string v1, "recoveryAction"

    .line 5142
    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 5143
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string p1, "android.permission.READ_PRIVILEGED_PHONE_STATE"

    invoke-virtual {p0, v0, p1}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;Ljava/lang/String;)V

    return-void
.end method

.method private checkRecovery()Z
    .locals 4

    .line 5152
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->getElapsedTimeSinceRecoveryMs()J

    move-result-wide v0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->getMinDurationBetweenRecovery()J

    move-result-wide v2

    cmp-long v0, v0, v2

    const/4 v1, 0x0

    if-gez v0, :cond_0

    return v1

    .line 5158
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getState()Lcom/android/internal/telephony/PhoneConstants$State;

    move-result-object v0

    sget-object v2, Lcom/android/internal/telephony/PhoneConstants$State;->IDLE:Lcom/android/internal/telephony/PhoneConstants$State;

    const/4 v3, 0x1

    if-eq v0, v2, :cond_1

    .line 5159
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->getRecoveryAction()I

    move-result v0

    if-le v0, v3, :cond_1

    return v1

    .line 5165
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmAttached(Lcom/android/internal/telephony/dataconnection/DcTracker;)Ljava/util/concurrent/atomic/AtomicBoolean;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->isDataAllowed(Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;)Z

    move-result p0

    if-eqz p0, :cond_2

    move v1, v3

    :cond_2
    return v1
.end method

.method private getElapsedTimeSinceRecoveryMs()J
    .locals 4

    .line 5123
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mTimeLastRecoveryStartMs:J

    sub-long/2addr v0, v2

    return-wide v0
.end method

.method private getMinDurationBetweenRecovery()J
    .locals 3

    .line 5117
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmResolver(Lcom/android/internal/telephony/dataconnection/DcTracker;)Landroid/content/ContentResolver;

    move-result-object p0

    const-string v0, "min_duration_between_recovery_steps"

    const-wide/32 v1, 0x2bf20

    invoke-static {p0, v0, v1, v2}, Landroid/provider/Settings$Global;->getLong(Landroid/content/ContentResolver;Ljava/lang/String;J)J

    move-result-wide v0

    return-wide v0
.end method

.method private getRecoveryAction()I
    .locals 2

    .line 5128
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmResolver(Lcom/android/internal/telephony/dataconnection/DcTracker;)Landroid/content/ContentResolver;

    move-result-object p0

    const-string v0, "radio.data.stall.recovery.action"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/provider/Settings$System;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    return p0
.end method

.method private isRecoveryAlreadyStarted()Z
    .locals 0

    .line 5147
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->getRecoveryAction()I

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private putRecoveryAction(I)V
    .locals 1

    .line 5135
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmResolver(Lcom/android/internal/telephony/dataconnection/DcTracker;)Landroid/content/ContentResolver;

    move-result-object p0

    const-string v0, "radio.data.stall.recovery.action"

    invoke-static {p0, v0, p1}, Landroid/provider/Settings$System;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z

    return-void
.end method

.method private setNetworkValidationState(Z)V
    .locals 6

    if-eqz p1, :cond_0

    .line 5080
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mWasDataStall:Z

    if-nez v0, :cond_0

    return-void

    .line 5084
    :cond_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mWasDataStall:Z

    const/4 v1, 0x1

    if-nez v0, :cond_1

    .line 5085
    iput-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mWasDataStall:Z

    .line 5086
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mDataStallStartMs:J

    .line 5087
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "data stall: start time = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mDataStallStartMs:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->log(Ljava/lang/String;)V

    return-void

    .line 5091
    :cond_1
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mLastActionReported:Z

    if-nez v0, :cond_2

    .line 5092
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    iget-wide v4, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mDataStallStartMs:J

    sub-long/2addr v2, v4

    long-to-int v0, v2

    .line 5094
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "data stall: lastaction = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v4, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mLastAction:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ", isRecovered = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, ", mTimeDuration = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/dataconnection/DcTracker;->log(Ljava/lang/String;)V

    .line 5097
    iget v2, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mLastAction:I

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v3, v3, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v2, v3, p1, v0}, Lcom/android/internal/telephony/metrics/DataStallRecoveryStats;->onDataStallEvent(ILcom/android/internal/telephony/Phone;ZI)V

    .line 5099
    iput-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mLastActionReported:Z

    :cond_2
    if-eqz p1, :cond_3

    const/4 p1, 0x0

    .line 5103
    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mLastActionReported:Z

    .line 5104
    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mWasDataStall:Z

    :cond_3
    return-void
.end method

.method private triggerRecovery()V
    .locals 2

    .line 5171
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mTimeLastRecoveryStartMs:J

    .line 5172
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    const v0, 0x42012

    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method


# virtual methods
.method public doRecovery()V
    .locals 5

    .line 5176
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->isAnyDataConnected()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 5178
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->getRecoveryAction()I

    move-result v0

    .line 5179
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v1, v1, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSignalStrength()Landroid/telephony/SignalStrength;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/SignalStrength;->getLevel()I

    move-result v1

    .line 5180
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v2

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v3, v3, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 5181
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    .line 5180
    invoke-virtual {v2, v3, v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeSignalStrengthEvent(II)V

    .line 5182
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v2, v2, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 5183
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    .line 5182
    invoke-virtual {v1, v2, v0}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeDataStallEvent(II)V

    .line 5184
    iput v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mLastAction:I

    const/4 v1, 0x0

    .line 5185
    iput-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mLastActionReported:Z

    .line 5186
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->broadcastDataStallDetected(I)V

    const/4 v1, 0x1

    if-eqz v0, :cond_3

    const/4 v2, 0x2

    if-eq v0, v1, :cond_2

    const/4 v1, 0x3

    if-eq v0, v2, :cond_1

    if-ne v0, v1, :cond_0

    const v0, 0xc3c9

    .line 5214
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmSentSinceLastRecv(Lcom/android/internal/telephony/dataconnection/DcTracker;)J

    move-result-wide v1

    invoke-static {v0, v1, v2}, Landroid/util/EventLog;->writeEvent(IJ)I

    .line 5216
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    const-string v1, "restarting radio"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->log(Ljava/lang/String;)V

    .line 5217
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$mrestartRadio(Lcom/android/internal/telephony/dataconnection/DcTracker;)V

    .line 5218
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->reset()V

    goto/16 :goto_0

    .line 5221
    :cond_0
    new-instance p0, Ljava/lang/RuntimeException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "doRecovery: Invalid recoveryAction="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_1
    const v0, 0xc3c8

    .line 5207
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {v2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmSentSinceLastRecv(Lcom/android/internal/telephony/dataconnection/DcTracker;)J

    move-result-wide v2

    invoke-static {v0, v2, v3}, Landroid/util/EventLog;->writeEvent(IJ)I

    .line 5209
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    const-string v2, "doRecovery() re-register"

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->log(Ljava/lang/String;)V

    .line 5210
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/dataconnection/DcTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->reRegisterNetwork(Landroid/os/Message;)V

    .line 5211
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->putRecoveryAction(I)V

    goto :goto_0

    :cond_2
    const v0, 0xc3c7

    .line 5197
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmSentSinceLastRecv(Lcom/android/internal/telephony/dataconnection/DcTracker;)J

    move-result-wide v3

    invoke-static {v0, v3, v4}, Landroid/util/EventLog;->writeEvent(IJ)I

    .line 5199
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    const-string v1, "doRecovery() cleanup all connections"

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->log(Ljava/lang/String;)V

    .line 5200
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v1, v0, Lcom/android/internal/telephony/dataconnection/DcTracker;->mApnContexts:Ljava/util/concurrent/ConcurrentHashMap;

    const/16 v3, 0x11

    invoke-static {v3}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/dataconnection/ApnContext;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->cleanUpConnection(Lcom/android/internal/telephony/dataconnection/ApnContext;)V

    .line 5202
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget-object v1, v0, Lcom/android/internal/telephony/dataconnection/DcTracker;->mApnContexts:Ljava/util/concurrent/ConcurrentHashMap;

    const/16 v3, 0x4000

    invoke-static {v3}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/util/concurrent/ConcurrentHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/dataconnection/ApnContext;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->cleanUpConnection(Lcom/android/internal/telephony/dataconnection/ApnContext;)V

    .line 5204
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->putRecoveryAction(I)V

    goto :goto_0

    :cond_3
    const v0, 0xc3c6

    .line 5190
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {v2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmSentSinceLastRecv(Lcom/android/internal/telephony/dataconnection/DcTracker;)J

    move-result-wide v2

    invoke-static {v0, v2, v3}, Landroid/util/EventLog;->writeEvent(IJ)I

    .line 5192
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    const-string v2, "doRecovery() get data call list"

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->log(Ljava/lang/String;)V

    .line 5193
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmDataServiceManager(Lcom/android/internal/telephony/dataconnection/DcTracker;)Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    move-result-object v0

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-virtual {v2}, Landroid/os/Handler;->obtainMessage()Landroid/os/Message;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->requestDataCallList(Landroid/os/Message;)V

    .line 5194
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->putRecoveryAction(I)V

    .line 5224
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    const-wide/16 v0, 0x0

    invoke-static {p0, v0, v1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fputmSentSinceLastRecv(Lcom/android/internal/telephony/dataconnection/DcTracker;J)V

    :cond_4
    return-void
.end method

.method public isAggressiveRecovery()Z
    .locals 2

    .line 5109
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->getRecoveryAction()I

    move-result p0

    const/4 v0, 0x1

    if-eq p0, v0, :cond_1

    const/4 v1, 0x2

    if-eq p0, v1, :cond_1

    const/4 v1, 0x3

    if-ne p0, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :cond_1
    :goto_0
    return v0
.end method

.method public isNoRxDataStallDetectionEnabled()Z
    .locals 1

    .line 5252
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmDataStallNoRxEnabled(Lcom/android/internal/telephony/dataconnection/DcTracker;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->isRecoveryOnBadNetworkEnabled()Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isRecoveryOnBadNetworkEnabled()Z
    .locals 2

    .line 5247
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->-$$Nest$fgetmResolver(Lcom/android/internal/telephony/dataconnection/DcTracker;)Landroid/content/ContentResolver;

    move-result-object p0

    const-string v0, "data_stall_recovery_on_bad_network"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0

    if-ne p0, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method public processNetworkStatusChanged(Z)V
    .locals 1

    .line 5229
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->setNetworkValidationState(Z)V

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    .line 5231
    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mIsValidNetwork:Z

    .line 5232
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->reset()V

    goto :goto_0

    .line 5234
    :cond_0
    iget-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mIsValidNetwork:Z

    if-nez p1, :cond_1

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->isRecoveryAlreadyStarted()Z

    move-result p1

    if-eqz p1, :cond_2

    :cond_1
    const/4 p1, 0x0

    .line 5235
    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mIsValidNetwork:Z

    .line 5238
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->checkRecovery()Z

    move-result p1

    if-eqz p1, :cond_2

    .line 5239
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->this$0:Lcom/android/internal/telephony/dataconnection/DcTracker;

    const-string/jumbo v0, "trigger data stall recovery"

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->log(Ljava/lang/String;)V

    .line 5240
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->triggerRecovery()V

    :cond_2
    :goto_0
    return-void
.end method

.method public reset()V
    .locals 2

    const-wide/16 v0, 0x0

    .line 5074
    iput-wide v0, p0, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->mTimeLastRecoveryStartMs:J

    const/4 v0, 0x0

    .line 5075
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DcTracker$DataStallRecoveryHandler;->putRecoveryAction(I)V

    return-void
.end method
