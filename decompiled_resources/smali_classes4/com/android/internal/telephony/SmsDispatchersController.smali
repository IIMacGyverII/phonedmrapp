.class public Lcom/android/internal/telephony/SmsDispatchersController;
.super Landroid/os/Handler;
.source "SmsDispatchersController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;
    }
.end annotation


# static fields
.field private static final EVENT_IMS_STATE_CHANGED:I = 0xc

.field private static final EVENT_IMS_STATE_DONE:I = 0xd

.field private static final EVENT_PARTIAL_SEGMENT_TIMER_EXPIRY:I = 0xf

.field private static final EVENT_RADIO_ON:I = 0xb

.field private static final EVENT_SERVICE_STATE_CHANGED:I = 0xe

.field protected static final EVENT_SMS_HANDLER_EXITING_WAITING_STATE:I = 0x11

.field private static final EVENT_USER_UNLOCKED:I = 0x10

.field private static final INVALID_TIME:J = -0x1L

.field private static final PARTIAL_SEGMENT_WAIT_DURATION:J = 0x5265c00L

.field private static final TAG:Ljava/lang/String; = "SmsDispatchersController"

.field private static final VDBG:Z = false


# instance fields
.field private final mBroadcastReceiver:Landroid/content/BroadcastReceiver;

.field protected mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

.field protected mCdmaInboundSmsHandler:Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

.field protected final mCi:Lcom/android/internal/telephony/CommandsInterface;

.field protected final mContext:Landroid/content/Context;

.field private mCurrentWaitElapsedDuration:J

.field private mCurrentWaitStartTime:J

.field private mDeliveryPendingMapFor3GPP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;",
            ">;"
        }
    .end annotation
.end field

.field private mDeliveryPendingMapFor3GPP2:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;",
            ">;"
        }
    .end annotation
.end field

.field protected mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

.field protected mGsmInboundSmsHandler:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

.field private mIms:Z

.field protected mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

.field private mImsSmsFormat:Ljava/lang/String;

.field private mLastInServiceTime:J

.field protected mPhone:Lcom/android/internal/telephony/Phone;

.field private final mUsageMonitor:Lcom/android/internal/telephony/SmsUsageMonitor;


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/SmsUsageMonitor;)V
    .locals 5

    .line 140
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    const-wide/16 v0, -0x1

    .line 87
    iput-wide v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mLastInServiceTime:J

    const-wide/16 v2, 0x0

    .line 89
    iput-wide v2, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitElapsedDuration:J

    .line 91
    iput-wide v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitStartTime:J

    const/4 v0, 0x0

    .line 116
    iput-boolean v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mIms:Z

    const-string/jumbo v0, "unknown"

    .line 117
    iput-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsFormat:Ljava/lang/String;

    .line 120
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP:Ljava/util/HashMap;

    .line 123
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP2:Ljava/util/HashMap;

    .line 195
    new-instance v0, Lcom/android/internal/telephony/SmsDispatchersController$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/SmsDispatchersController$1;-><init>(Lcom/android/internal/telephony/SmsDispatchersController;)V

    iput-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    const-string v1, "SmsDispatchersController"

    const-string v2, "SmsDispatchersController created"

    .line 141
    invoke-static {v1, v2}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 143
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mContext:Landroid/content/Context;

    .line 144
    iput-object p3, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mUsageMonitor:Lcom/android/internal/telephony/SmsUsageMonitor;

    .line 145
    iget-object p3, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iput-object p3, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 146
    iput-object p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 153
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    const-class v3, Lcom/android/internal/telephony/TelephonyComponentFactory;

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 155
    invoke-virtual {v2, p1, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeImsSmsDispatcher(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsDispatchersController;)Lcom/android/internal/telephony/ImsSmsDispatcher;

    move-result-object v3

    iput-object v3, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    .line 157
    invoke-virtual {v2, p1, p0}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeCdmaSMSDispatcher(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsDispatchersController;)Lcom/android/internal/telephony/cdma/CdmaSMSDispatcher;

    move-result-object v3

    iput-object v3, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    .line 159
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v3

    const-class v4, Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v3

    .line 160
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v4

    invoke-virtual {v3, v4, p2, p1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeGsmInboundSmsHandler(Landroid/content/Context;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    move-result-object v3

    iput-object v3, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmInboundSmsHandler:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    .line 163
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v3

    iget-object v4, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    check-cast v4, Lcom/android/internal/telephony/cdma/CdmaSMSDispatcher;

    invoke-static {v3, p2, p1, v4}, Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;->makeInboundSmsHandler(Landroid/content/Context;Lcom/android/internal/telephony/SmsStorageMonitor;Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/cdma/CdmaSMSDispatcher;)Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaInboundSmsHandler:Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

    .line 167
    iget-object p2, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmInboundSmsHandler:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    .line 168
    invoke-virtual {v2, p1, p0, p2}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeGsmSMSDispatcher(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/SmsDispatchersController;Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;)Lcom/android/internal/telephony/gsm/GsmSMSDispatcher;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    .line 169
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    iget-object v3, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmInboundSmsHandler:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    iget-object v4, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaInboundSmsHandler:Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

    invoke-virtual {v2, p2, v3, v4}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeSmsBroadcastUndelivered(Landroid/content/Context;Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;)V

    .line 172
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/InboundSmsHandler;->registerNewMessageNotificationActionHandler(Landroid/content/Context;)V

    const/16 p1, 0xb

    const/4 p2, 0x0

    .line 174
    invoke-interface {p3, p0, p1, p2}, Lcom/android/internal/telephony/CommandsInterface;->registerForOn(Landroid/os/Handler;ILjava/lang/Object;)V

    const/16 p1, 0xc

    .line 175
    invoke-interface {p3, p0, p1, p2}, Lcom/android/internal/telephony/CommandsInterface;->registerForImsNetworkStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    const-string/jumbo p1, "user"

    .line 177
    invoke-virtual {v1, p1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/os/UserManager;

    .line 178
    invoke-virtual {p1}, Landroid/os/UserManager;->isUserUnlocked()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 183
    iget-object p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mPhone:Lcom/android/internal/telephony/Phone;

    const/16 p3, 0xe

    invoke-virtual {p1, p0, p3, p2}, Lcom/android/internal/telephony/Phone;->registerForServiceStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 184
    invoke-direct {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->resetPartialSegmentWaitTimer()V

    goto :goto_0

    .line 189
    :cond_0
    new-instance p0, Landroid/content/IntentFilter;

    invoke-direct {p0}, Landroid/content/IntentFilter;-><init>()V

    const-string p1, "android.intent.action.USER_UNLOCKED"

    .line 190
    invoke-virtual {p0, p1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 191
    invoke-virtual {v1, v0, p0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    :goto_0
    return-void
.end method

.method private handleInService(J)V
    .locals 5

    .line 303
    iget-wide v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitStartTime:J

    const-wide/16 v2, -0x1

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    iput-wide p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitStartTime:J

    :cond_0
    const/16 v0, 0xf

    .line 307
    iget-wide v1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitStartTime:J

    .line 308
    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {p0, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    const-wide/32 v1, 0x5265c00

    iget-wide v3, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitElapsedDuration:J

    sub-long/2addr v1, v3

    .line 307
    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    .line 312
    iput-wide p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mLastInServiceTime:J

    return-void
.end method

.method private handleOutOfService(J)V
    .locals 0

    const-wide/16 p1, -0x1

    .line 322
    iput-wide p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mLastInServiceTime:J

    return-void
.end method

.method private handlePartialSegmentTimerExpiry(J)V
    .locals 2

    .line 326
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmInboundSmsHandler:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    invoke-virtual {v0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    invoke-interface {v0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "WaitingState"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaInboundSmsHandler:Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

    .line 327
    invoke-virtual {v0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    invoke-interface {v0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 339
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mContext:Landroid/content/Context;

    invoke-static {v0, p1, p2}, Lcom/android/internal/telephony/SmsBroadcastUndelivered;->scanRawTable(Landroid/content/Context;J)V

    .line 344
    invoke-direct {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->resetPartialSegmentWaitTimer()V

    return-void

    :cond_1
    :goto_0
    const-string p1, "handlePartialSegmentTimerExpiry: ignoring timer expiry as InboundSmsHandler is in WaitingState"

    .line 328
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SmsDispatchersController;->logd(Ljava/lang/String;)V

    return-void
.end method

.method private isInService()Z
    .locals 0

    .line 374
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 375
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getState()I

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private logd(Ljava/lang/String;)V
    .locals 0

    const-string p0, "SmsDispatchersController"

    .line 1088
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private reevaluateTimerStatus()V
    .locals 6

    .line 268
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const/16 v2, 0xf

    .line 271
    invoke-virtual {p0, v2}, Landroid/os/Handler;->removeMessages(I)V

    .line 275
    iget-wide v2, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mLastInServiceTime:J

    const-wide/16 v4, -0x1

    cmp-long v4, v2, v4

    if-eqz v4, :cond_0

    .line 276
    iget-wide v4, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitElapsedDuration:J

    sub-long v2, v0, v2

    add-long/2addr v4, v2

    iput-wide v4, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitElapsedDuration:J

    .line 284
    :cond_0
    iget-wide v2, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitElapsedDuration:J

    const-wide/32 v4, 0x5265c00

    cmp-long v2, v2, v4

    if-lez v2, :cond_1

    .line 286
    iget-wide v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitStartTime:J

    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/SmsDispatchersController;->handlePartialSegmentTimerExpiry(J)V

    goto :goto_0

    .line 288
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->isInService()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 289
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/SmsDispatchersController;->handleInService(J)V

    goto :goto_0

    .line 291
    :cond_2
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/SmsDispatchersController;->handleOutOfService(J)V

    :goto_0
    return-void
.end method

.method private resetPartialSegmentWaitTimer()V
    .locals 4

    .line 348
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    const/16 v2, 0xf

    .line 350
    invoke-virtual {p0, v2}, Landroid/os/Handler;->removeMessages(I)V

    .line 351
    invoke-direct {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->isInService()Z

    move-result v3

    if-eqz v3, :cond_0

    .line 356
    iput-wide v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitStartTime:J

    .line 357
    iput-wide v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mLastInServiceTime:J

    .line 359
    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {p0, v2, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    const-wide/32 v1, 0x5265c00

    .line 358
    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_0

    :cond_0
    const-wide/16 v0, -0x1

    .line 366
    iput-wide v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitStartTime:J

    .line 367
    iput-wide v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mLastInServiceTime:J

    :goto_0
    const-wide/16 v0, 0x0

    .line 370
    iput-wide v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCurrentWaitElapsedDuration:J

    return-void
.end method

.method private setImsSmsFormat(I)V
    .locals 1

    const/4 v0, 0x1

    if-eq p1, v0, :cond_1

    const/4 v0, 0x2

    if-eq p1, v0, :cond_0

    const-string/jumbo p1, "unknown"

    .line 387
    iput-object p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsFormat:Ljava/lang/String;

    goto :goto_0

    :cond_0
    const-string p1, "3gpp2"

    .line 384
    iput-object p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsFormat:Ljava/lang/String;

    goto :goto_0

    :cond_1
    const-string p1, "3gpp"

    .line 381
    iput-object p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsFormat:Ljava/lang/String;

    :goto_0
    return-void
.end method

.method private triggerDeliveryIntent(Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;Ljava/lang/String;[B)Z
    .locals 2

    .line 1055
    iget-object p1, p1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mDeliveryIntent:Landroid/app/PendingIntent;

    .line 1056
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    const-string v1, "pdu"

    .line 1057
    invoke-virtual {v0, v1, p3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;[B)Landroid/content/Intent;

    const-string p3, "format"

    .line 1058
    invoke-virtual {v0, p3, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 1060
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mContext:Landroid/content/Context;

    const/4 p2, -0x1

    invoke-virtual {p1, p0, p2, v0}, Landroid/app/PendingIntent;->send(Landroid/content/Context;ILandroid/content/Intent;)V
    :try_end_0
    .catch Landroid/app/PendingIntent$CanceledException; {:try_start_0 .. :try_end_0} :catch_0

    const/4 p0, 0x1

    return p0

    :catch_0
    const/4 p0, 0x0

    return p0
.end method

.method private updateImsInfo(Landroid/os/AsyncResult;)V
    .locals 3

    .line 393
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [I

    const/4 v0, 0x1

    .line 394
    aget v1, p1, v0

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/SmsDispatchersController;->setImsSmsFormat(I)V

    const/4 v1, 0x0

    .line 395
    aget p1, p1, v1

    if-ne p1, v0, :cond_0

    iget-object p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsFormat:Ljava/lang/String;

    const-string/jumbo v2, "unknown"

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    goto :goto_0

    :cond_0
    move v0, v1

    :goto_0
    iput-boolean v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mIms:Z

    .line 396
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "IMS registration state: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mIms:Z

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, " format: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsFormat:Ljava/lang/String;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "SmsDispatchersController"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public dispose()V
    .locals 1

    .line 206
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForOn(Landroid/os/Handler;)V

    .line 207
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForImsNetworkStateChanged(Landroid/os/Handler;)V

    .line 208
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/Phone;->unregisterForServiceStateChanged(Landroid/os/Handler;)V

    .line 209
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SMSDispatcher;->dispose()V

    .line 210
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SMSDispatcher;->dispose()V

    .line 211
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmInboundSmsHandler:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    invoke-virtual {v0}, Lcom/android/internal/telephony/InboundSmsHandler;->dispose()V

    .line 212
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaInboundSmsHandler:Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

    invoke-virtual {p0}, Lcom/android/internal/telephony/InboundSmsHandler;->dispose()V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 1

    .line 1080
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmInboundSmsHandler:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    invoke-virtual {v0, p1, p2, p3}, Lcom/android/internal/telephony/InboundSmsHandler;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1081
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaInboundSmsHandler:Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

    invoke-virtual {v0, p1, p2, p3}, Lcom/android/internal/telephony/InboundSmsHandler;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1082
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    invoke-virtual {v0, p1, p2, p3}, Lcom/android/internal/telephony/SMSDispatcher;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1083
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    invoke-virtual {v0, p1, p2, p3}, Lcom/android/internal/telephony/SMSDispatcher;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1084
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/SMSDispatcher;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    return-void
.end method

.method public getImsSmsFormat()Ljava/lang/String;
    .locals 1

    .line 585
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-virtual {v0}, Lcom/android/internal/telephony/ImsSmsDispatcher;->isAvailable()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ImsSmsDispatcher;->getFormat()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsFormat:Ljava/lang/String;

    :goto_0
    return-object p0
.end method

.method public getInboundSmsHandler(Z)Lcom/android/internal/telephony/InboundSmsHandler;
    .locals 0

    if-eqz p1, :cond_0

    .line 1071
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaInboundSmsHandler:Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

    return-object p0

    .line 1072
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmInboundSmsHandler:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    return-object p0
.end method

.method public getPremiumSmsPermission(Ljava/lang/String;)I
    .locals 0

    .line 962
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mUsageMonitor:Lcom/android/internal/telephony/SmsUsageMonitor;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SmsUsageMonitor;->getPremiumSmsPermission(Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method public getUsageMonitor()Lcom/android/internal/telephony/SmsUsageMonitor;
    .locals 0

    .line 978
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mUsageMonitor:Lcom/android/internal/telephony/SmsUsageMonitor;

    return-object p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 224
    iget v0, p1, Landroid/os/Message;->what:I

    packed-switch v0, :pswitch_data_0

    .line 259
    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaMo()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 260
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SMSDispatcher;->handleMessage(Landroid/os/Message;)V

    goto :goto_0

    .line 254
    :pswitch_0
    iget-object p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mPhone:Lcom/android/internal/telephony/Phone;

    const/16 v0, 0xe

    const/4 v1, 0x0

    invoke-virtual {p1, p0, v0, v1}, Lcom/android/internal/telephony/Phone;->registerForServiceStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 255
    invoke-direct {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->resetPartialSegmentWaitTimer()V

    goto :goto_0

    .line 247
    :pswitch_1
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/SmsDispatchersController;->handlePartialSegmentTimerExpiry(J)V

    goto :goto_0

    .line 243
    :pswitch_2
    invoke-direct {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->reevaluateTimerStatus()V

    goto :goto_0

    .line 231
    :pswitch_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 233
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_0

    .line 234
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/SmsDispatchersController;->updateImsInfo(Landroid/os/AsyncResult;)V

    goto :goto_0

    .line 236
    :cond_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "IMS State query failed with exp "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "SmsDispatchersController"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 227
    :pswitch_4
    iget-object p1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0xd

    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->getImsRegistrationState(Landroid/os/Message;)V

    goto :goto_0

    .line 262
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SMSDispatcher;->handleMessage(Landroid/os/Message;)V

    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0xb
        :pswitch_4
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_2
    .end packed-switch
.end method

.method public handleSmsStatusReport(Ljava/lang/String;[B)V
    .locals 7

    .line 991
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaFormat(Ljava/lang/String;)Z

    move-result v0

    const/16 v1, 0x40

    const/4 v2, 0x0

    if-eqz v0, :cond_4

    .line 993
    invoke-static {p2}, Lcom/android/internal/telephony/cdma/SmsMessage;->createFromPdu([B)Lcom/android/internal/telephony/cdma/SmsMessage;

    move-result-object v0

    if-eqz v0, :cond_7

    .line 996
    iget v3, v0, Lcom/android/internal/telephony/cdma/SmsMessage;->mMessageRef:I

    .line 997
    iget-object v4, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP2:Ljava/util/HashMap;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    if-nez v4, :cond_0

    .line 1003
    iget-object v4, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP:Ljava/util/HashMap;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    if-eqz v4, :cond_0

    const/4 v5, 0x1

    goto :goto_0

    :cond_0
    move v5, v2

    :goto_0
    if-eqz v4, :cond_7

    .line 1011
    invoke-virtual {v0}, Lcom/android/internal/telephony/cdma/SmsMessage;->getStatus()I

    move-result v0

    shr-int/lit8 v0, v0, 0x18

    and-int/lit8 v0, v0, 0x3

    const/4 v6, 0x2

    if-eq v0, v6, :cond_3

    .line 1014
    iget-object v6, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mContext:Landroid/content/Context;

    if-nez v0, :cond_1

    move v1, v2

    :cond_1
    invoke-virtual {v4, v6, v1}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->updateSentMessageStatus(Landroid/content/Context;I)V

    if-eqz v5, :cond_2

    .line 1021
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP:Ljava/util/HashMap;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_1

    .line 1023
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP2:Ljava/util/HashMap;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 1026
    :cond_3
    :goto_1
    invoke-direct {p0, v4, p1, p2}, Lcom/android/internal/telephony/SmsDispatchersController;->triggerDeliveryIntent(Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;Ljava/lang/String;[B)Z

    move-result p0

    move v2, p0

    goto :goto_2

    .line 1031
    :cond_4
    invoke-static {p2}, Lcom/android/internal/telephony/gsm/SmsMessage;->createFromPdu([B)Lcom/android/internal/telephony/gsm/SmsMessage;

    move-result-object v0

    if-eqz v0, :cond_7

    .line 1033
    iget v3, v0, Lcom/android/internal/telephony/gsm/SmsMessage;->mMessageRef:I

    .line 1034
    iget-object v4, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP:Ljava/util/HashMap;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;

    if-eqz v4, :cond_7

    .line 1036
    invoke-virtual {v0}, Lcom/android/internal/telephony/gsm/SmsMessage;->getStatus()I

    move-result v0

    if-ge v0, v1, :cond_5

    const/16 v1, 0x20

    if-ge v0, v1, :cond_6

    .line 1039
    :cond_5
    iget-object v1, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mContext:Landroid/content/Context;

    invoke-virtual {v4, v1, v0}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->updateSentMessageStatus(Landroid/content/Context;I)V

    .line 1041
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP:Ljava/util/HashMap;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 1043
    :cond_6
    invoke-direct {p0, v4, p1, p2}, Lcom/android/internal/telephony/SmsDispatchersController;->triggerDeliveryIntent(Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;Ljava/lang/String;[B)Z

    move-result v2

    :cond_7
    :goto_2
    if-nez v2, :cond_8

    const-string p0, "SmsDispatchersController"

    const-string p1, "handleSmsStatusReport: can not handle the status report!"

    .line 1049
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_8
    return-void
.end method

.method public injectSmsPdu(Landroid/telephony/SmsMessage;Ljava/lang/String;Lcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;ZZ)V
    .locals 8
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const-string v0, "SmsDispatchersController"

    const-string v1, "SmsDispatchersController:injectSmsPdu"

    .line 431
    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v1, 0x2

    if-nez p1, :cond_0

    :try_start_0
    const-string p0, "injectSmsPdu: createFromPdu returned null"

    .line 434
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 435
    invoke-interface {p3, v1}, Lcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;->onSmsInjectedResult(I)V

    return-void

    :cond_0
    if-nez p4, :cond_1

    .line 440
    invoke-virtual {p1}, Landroid/telephony/SmsMessage;->getMessageClass()Landroid/telephony/SmsMessage$MessageClass;

    move-result-object p4

    sget-object v2, Landroid/telephony/SmsMessage$MessageClass;->CLASS_1:Landroid/telephony/SmsMessage$MessageClass;

    if-eq p4, v2, :cond_1

    const-string p0, "injectSmsPdu: not class 1"

    .line 441
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 442
    invoke-interface {p3, v1}, Lcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;->onSmsInjectedResult(I)V

    return-void

    .line 446
    :cond_1
    new-instance p4, Landroid/os/AsyncResult;

    const/4 v2, 0x0

    invoke-direct {p4, p3, p1, v2}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    const-string v2, "3gpp"

    .line 448
    invoke-virtual {p2, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const/4 v3, 0x1

    const/4 v4, 0x7

    const-string v5, ", format="

    const-string v6, "SmsDispatchersController:injectSmsText Sending msg="

    const/4 v7, 0x0

    if-eqz v2, :cond_3

    .line 449
    :try_start_1
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string/jumbo p1, "to mGsmInboundSmsHandler"

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 451
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmInboundSmsHandler:Lcom/android/internal/telephony/gsm/GsmInboundSmsHandler;

    if-eqz p5, :cond_2

    goto :goto_0

    :cond_2
    move v3, v7

    :goto_0
    invoke-virtual {p0, v4, v3, v7, p4}, Lcom/android/internal/telephony/StateMachine;->sendMessage(IIILjava/lang/Object;)V

    goto :goto_2

    :cond_3
    const-string v2, "3gpp2"

    .line 453
    invoke-virtual {p2, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_5

    .line 454
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string/jumbo p1, "to mCdmaInboundSmsHandler"

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 456
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaInboundSmsHandler:Lcom/android/internal/telephony/cdma/CdmaInboundSmsHandler;

    if-eqz p5, :cond_4

    goto :goto_1

    :cond_4
    move v3, v7

    :goto_1
    invoke-virtual {p0, v4, v3, v7, p4}, Lcom/android/internal/telephony/StateMachine;->sendMessage(IIILjava/lang/Object;)V

    goto :goto_2

    .line 460
    :cond_5
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "Invalid pdu format: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 461
    invoke-interface {p3, v1}, Lcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;->onSmsInjectedResult(I)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_2

    :catch_0
    move-exception p0

    const-string p1, "injectSmsPdu failed: "

    .line 464
    invoke-static {v0, p1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 465
    invoke-interface {p3, v1}, Lcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;->onSmsInjectedResult(I)V

    :goto_2
    return-void
.end method

.method public injectSmsPdu([BLjava/lang/String;ZLcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;)V
    .locals 6
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 414
    invoke-static {p1, p2}, Landroid/telephony/SmsMessage;->createFromPdu([BLjava/lang/String;)Landroid/telephony/SmsMessage;

    move-result-object v1

    const/4 v4, 0x0

    move-object v0, p0

    move-object v2, p2

    move-object v3, p4

    move v5, p3

    .line 415
    invoke-virtual/range {v0 .. v5}, Lcom/android/internal/telephony/SmsDispatchersController;->injectSmsPdu(Landroid/telephony/SmsMessage;Ljava/lang/String;Lcom/android/internal/telephony/SmsDispatchersController$SmsInjectionCallback;ZZ)V

    return-void
.end method

.method public isCdmaFormat(Ljava/lang/String;)Z
    .locals 0

    .line 611
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    invoke-virtual {p0}, Lcom/android/internal/telephony/SMSDispatcher;->getFormat()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method protected isCdmaMo()Z
    .locals 1

    .line 596
    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->isIms()Z

    move-result v0

    if-nez v0, :cond_1

    const/4 v0, 0x2

    .line 598
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneType()I

    move-result p0

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0

    .line 601
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->getImsSmsFormat()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaFormat(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public isIms()Z
    .locals 1

    .line 575
    iget-object v0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-virtual {v0}, Lcom/android/internal/telephony/ImsSmsDispatcher;->isAvailable()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    iget-boolean p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mIms:Z

    :goto_0
    return p0
.end method

.method public putDeliveryPendingTracker(Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;)V
    .locals 1

    .line 132
    iget-object v0, p1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mFormat:Ljava/lang/String;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaFormat(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 133
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP2:Ljava/util/HashMap;

    iget v0, p1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mMessageRef:I

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {p0, v0, p1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 135
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mDeliveryPendingMapFor3GPP:Ljava/util/HashMap;

    iget v0, p1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mMessageRef:I

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {p0, v0, p1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_0
    return-void
.end method

.method protected sendData(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I[BLandroid/app/PendingIntent;Landroid/app/PendingIntent;Z)V
    .locals 12

    move-object v0, p0

    .line 695
    iget-object v1, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-virtual {v1}, Lcom/android/internal/telephony/ImsSmsDispatcher;->isAvailable()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 696
    iget-object v2, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    move-object v3, p1

    move-object v4, p2

    move-object v5, p3

    move/from16 v6, p4

    move-object/from16 v7, p5

    move-object/from16 v8, p6

    move-object/from16 v9, p7

    move/from16 v10, p8

    invoke-virtual/range {v2 .. v10}, Lcom/android/internal/telephony/SMSDispatcher;->sendData(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I[BLandroid/app/PendingIntent;Landroid/app/PendingIntent;Z)V

    goto :goto_0

    .line 698
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaMo()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 699
    iget-object v2, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    move-object v3, p1

    move-object v4, p2

    move-object v5, p3

    move/from16 v6, p4

    move-object/from16 v7, p5

    move-object/from16 v8, p6

    move-object/from16 v9, p7

    move/from16 v10, p8

    invoke-virtual/range {v2 .. v10}, Lcom/android/internal/telephony/SMSDispatcher;->sendData(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I[BLandroid/app/PendingIntent;Landroid/app/PendingIntent;Z)V

    goto :goto_0

    .line 702
    :cond_1
    iget-object v3, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    move-object v4, p1

    move-object v5, p2

    move-object v6, p3

    move/from16 v7, p4

    move-object/from16 v8, p5

    move-object/from16 v9, p6

    move-object/from16 v10, p7

    move/from16 v11, p8

    invoke-virtual/range {v3 .. v11}, Lcom/android/internal/telephony/SMSDispatcher;->sendData(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I[BLandroid/app/PendingIntent;Landroid/app/PendingIntent;Z)V

    :goto_0
    return-void
.end method

.method protected sendMultipartText(Ljava/lang/String;Ljava/lang/String;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/ArrayList;Landroid/net/Uri;Ljava/lang/String;ZIZIJ)V
    .locals 17
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/ArrayList<",
            "Landroid/app/PendingIntent;",
            ">;",
            "Ljava/util/ArrayList<",
            "Landroid/app/PendingIntent;",
            ">;",
            "Landroid/net/Uri;",
            "Ljava/lang/String;",
            "ZIZIJ)V"
        }
    .end annotation

    move-object/from16 v0, p0

    .line 934
    iget-object v1, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-virtual {v1}, Lcom/android/internal/telephony/ImsSmsDispatcher;->isAvailable()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 935
    iget-object v2, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    const/4 v12, 0x0

    move-object/from16 v3, p1

    move-object/from16 v4, p2

    move-object/from16 v5, p3

    move-object/from16 v6, p4

    move-object/from16 v7, p5

    move-object/from16 v8, p6

    move-object/from16 v9, p7

    move/from16 v10, p8

    move/from16 v11, p9

    move/from16 v13, p11

    move-wide/from16 v14, p12

    invoke-virtual/range {v2 .. v15}, Lcom/android/internal/telephony/SMSDispatcher;->sendMultipartText(Ljava/lang/String;Ljava/lang/String;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/ArrayList;Landroid/net/Uri;Ljava/lang/String;ZIZIJ)V

    goto :goto_0

    .line 939
    :cond_0
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaMo()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 940
    iget-object v2, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    move-object/from16 v3, p1

    move-object/from16 v4, p2

    move-object/from16 v5, p3

    move-object/from16 v6, p4

    move-object/from16 v7, p5

    move-object/from16 v8, p6

    move-object/from16 v9, p7

    move/from16 v10, p8

    move/from16 v11, p9

    move/from16 v12, p10

    move/from16 v13, p11

    move-wide/from16 v14, p12

    invoke-virtual/range {v2 .. v15}, Lcom/android/internal/telephony/SMSDispatcher;->sendMultipartText(Ljava/lang/String;Ljava/lang/String;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/ArrayList;Landroid/net/Uri;Ljava/lang/String;ZIZIJ)V

    goto :goto_0

    .line 944
    :cond_1
    iget-object v3, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    move-object/from16 v4, p1

    move-object/from16 v5, p2

    move-object/from16 v6, p3

    move-object/from16 v7, p4

    move-object/from16 v8, p5

    move-object/from16 v9, p6

    move-object/from16 v10, p7

    move/from16 v11, p8

    move/from16 v12, p9

    move/from16 v13, p10

    move/from16 v14, p11

    move-wide/from16 v15, p12

    invoke-virtual/range {v3 .. v16}, Lcom/android/internal/telephony/SMSDispatcher;->sendMultipartText(Ljava/lang/String;Ljava/lang/String;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/util/ArrayList;Landroid/net/Uri;Ljava/lang/String;ZIZIJ)V

    :goto_0
    return-void
.end method

.method public sendRetrySms(Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;)V
    .locals 16

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 475
    iget-object v2, v1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mFormat:Ljava/lang/String;

    .line 478
    iget-boolean v3, v1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mUsesImsServiceForIms:Z

    const/4 v5, 0x0

    if-nez v3, :cond_0

    iget-object v3, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-virtual {v3}, Lcom/android/internal/telephony/ImsSmsDispatcher;->isAvailable()Z

    move-result v3

    if-eqz v3, :cond_0

    const/4 v3, 0x1

    goto :goto_0

    :cond_0
    move v3, v5

    :goto_0
    const/4 v6, 0x2

    if-eqz v3, :cond_1

    .line 488
    iget-object v7, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-virtual {v7}, Lcom/android/internal/telephony/ImsSmsDispatcher;->getFormat()Ljava/lang/String;

    move-result-object v7

    goto :goto_1

    .line 489
    :cond_1
    iget-object v7, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v7}, Lcom/android/internal/telephony/Phone;->getPhoneType()I

    move-result v7

    if-ne v6, v7, :cond_2

    .line 490
    iget-object v7, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    invoke-virtual {v7}, Lcom/android/internal/telephony/SMSDispatcher;->getFormat()Ljava/lang/String;

    move-result-object v7

    goto :goto_1

    .line 491
    :cond_2
    iget-object v7, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    invoke-virtual {v7}, Lcom/android/internal/telephony/SMSDispatcher;->getFormat()Ljava/lang/String;

    move-result-object v7

    .line 493
    :goto_1
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "old format("

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, ") ==> new format ("

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, ")"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    const-string v9, "SmsDispatchersController"

    invoke-static {v9, v8}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 494
    invoke-virtual {v2, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_11

    .line 496
    invoke-virtual/range {p1 .. p1}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->getData()Ljava/util/HashMap;

    move-result-object v2

    const-string v8, "scAddr"

    .line 500
    invoke-virtual {v2, v8}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v10

    const/4 v11, -0x1

    const/16 v12, 0x1e

    if-eqz v10, :cond_10

    const-string v10, "destAddr"

    invoke-virtual {v2, v10}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_10

    const-string/jumbo v13, "text"

    .line 501
    invoke-virtual {v2, v13}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v14

    const-string v15, "destPort"

    const-string v4, "data"

    if-nez v14, :cond_3

    .line 502
    invoke-virtual {v2, v4}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v14

    if-eqz v14, :cond_10

    invoke-virtual {v2, v15}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v14

    if-nez v14, :cond_3

    goto/16 :goto_a

    .line 508
    :cond_3
    invoke-virtual {v2, v8}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Ljava/lang/String;

    .line 509
    invoke-virtual {v2, v10}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ljava/lang/String;

    if-nez v10, :cond_4

    const-string v2, "sendRetrySms failed due to null destAddr"

    .line 511
    invoke-static {v9, v2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 512
    iget-object v0, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mContext:Landroid/content/Context;

    invoke-virtual {v1, v0, v12, v11}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->onFailed(Landroid/content/Context;II)V

    return-void

    .line 518
    :cond_4
    invoke-virtual {v2, v13}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v14

    const/4 v11, 0x0

    if-eqz v14, :cond_9

    .line 519
    invoke-virtual {v2, v13}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 520
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v14, "sms failed was text with length: "

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v4, :cond_5

    move-object v14, v11

    goto :goto_2

    .line 521
    :cond_5
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v14

    invoke-static {v14}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v14

    :goto_2
    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    .line 520
    invoke-static {v9, v13}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 523
    invoke-virtual {v0, v7}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaFormat(Ljava/lang/String;)Z

    move-result v13

    if-eqz v13, :cond_7

    .line 524
    iget-object v13, v1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mDeliveryIntent:Landroid/app/PendingIntent;

    if-eqz v13, :cond_6

    const/4 v13, 0x1

    goto :goto_3

    :cond_6
    move v13, v5

    :goto_3
    invoke-static {v8, v10, v4, v13, v11}, Lcom/android/internal/telephony/cdma/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLcom/android/internal/telephony/SmsHeader;)Lcom/android/internal/telephony/cdma/SmsMessage$SubmitPdu;

    move-result-object v4

    goto :goto_5

    .line 527
    :cond_7
    iget-object v13, v1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mDeliveryIntent:Landroid/app/PendingIntent;

    if-eqz v13, :cond_8

    const/4 v13, 0x1

    goto :goto_4

    :cond_8
    move v13, v5

    :goto_4
    invoke-static {v8, v10, v4, v13, v11}, Lcom/android/internal/telephony/gsm/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z[B)Lcom/android/internal/telephony/gsm/SmsMessage$SubmitPdu;

    move-result-object v4

    :goto_5
    move-object v11, v4

    goto :goto_9

    .line 530
    :cond_9
    invoke-virtual {v2, v4}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_e

    .line 531
    invoke-virtual {v2, v4}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, [B

    .line 532
    invoke-virtual {v2, v15}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Ljava/lang/Integer;

    .line 533
    new-instance v14, Ljava/lang/StringBuilder;

    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v11, "sms failed was data with length: "

    invoke-virtual {v14, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v4, :cond_a

    const/4 v11, 0x0

    goto :goto_6

    .line 534
    :cond_a
    array-length v11, v4

    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v11

    :goto_6
    invoke-virtual {v14, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    .line 533
    invoke-static {v9, v11}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 536
    invoke-virtual {v0, v7}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaFormat(Ljava/lang/String;)Z

    move-result v11

    if-eqz v11, :cond_c

    .line 538
    invoke-virtual {v13}, Ljava/lang/Integer;->intValue()I

    move-result v11

    iget-object v13, v1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mDeliveryIntent:Landroid/app/PendingIntent;

    if-eqz v13, :cond_b

    const/4 v13, 0x1

    goto :goto_7

    :cond_b
    move v13, v5

    .line 537
    :goto_7
    invoke-static {v8, v10, v11, v4, v13}, Lcom/android/internal/telephony/cdma/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;I[BZ)Lcom/android/internal/telephony/cdma/SmsMessage$SubmitPdu;

    move-result-object v11

    goto :goto_9

    .line 542
    :cond_c
    invoke-virtual {v13}, Ljava/lang/Integer;->intValue()I

    move-result v11

    iget-object v13, v1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mDeliveryIntent:Landroid/app/PendingIntent;

    if-eqz v13, :cond_d

    const/4 v13, 0x1

    goto :goto_8

    :cond_d
    move v13, v5

    .line 541
    :goto_8
    invoke-static {v8, v10, v11, v4, v13}, Lcom/android/internal/telephony/gsm/SmsMessage;->getSubmitPdu(Ljava/lang/String;Ljava/lang/String;I[BZ)Lcom/android/internal/telephony/gsm/SmsMessage$SubmitPdu;

    move-result-object v11

    goto :goto_9

    :cond_e
    const/4 v11, 0x0

    :goto_9
    if-nez v11, :cond_f

    new-array v3, v6, [Ljava/lang/Object;

    aput-object v8, v3, v5

    .line 550
    invoke-virtual {v2, v15}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    const/4 v4, 0x1

    aput-object v2, v3, v4

    const-string v2, "sendRetrySms failed to encode message.scAddr: %s, destPort: %s"

    .line 548
    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v9, v2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 551
    iget-object v0, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mContext:Landroid/content/Context;

    const/4 v2, -0x1

    invoke-virtual {v1, v0, v12, v2}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->onFailed(Landroid/content/Context;II)V

    return-void

    .line 555
    :cond_f
    iget-object v4, v11, Lcom/android/internal/telephony/SmsMessageBase$SubmitPduBase;->encodedScAddress:[B

    const-string/jumbo v5, "smsc"

    invoke-virtual {v2, v5, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 556
    iget-object v4, v11, Lcom/android/internal/telephony/SmsMessageBase$SubmitPduBase;->encodedMessage:[B

    const-string v5, "pdu"

    invoke-virtual {v2, v5, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 557
    iput-object v7, v1, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->mFormat:Ljava/lang/String;

    goto :goto_b

    :cond_10
    :goto_a
    const-string v2, "sendRetrySms failed to re-encode per missing fields!"

    .line 504
    invoke-static {v9, v2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 505
    iget-object v0, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mContext:Landroid/content/Context;

    const/4 v2, -0x1

    invoke-virtual {v1, v0, v12, v2}, Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;->onFailed(Landroid/content/Context;II)V

    return-void

    :cond_11
    :goto_b
    if-eqz v3, :cond_12

    .line 562
    iget-object v0, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    goto :goto_c

    .line 563
    :cond_12
    invoke-virtual {v0, v7}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaFormat(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_13

    iget-object v0, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    goto :goto_c

    :cond_13
    iget-object v0, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    .line 565
    :goto_c
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SMSDispatcher;->sendSms(Lcom/android/internal/telephony/SMSDispatcher$SmsTracker;)V

    return-void
.end method

.method public sendText(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/app/PendingIntent;Landroid/app/PendingIntent;Landroid/net/Uri;Ljava/lang/String;ZIZIZJ)V
    .locals 17

    move-object/from16 v0, p0

    .line 808
    iget-object v1, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    invoke-virtual {v1}, Lcom/android/internal/telephony/ImsSmsDispatcher;->isAvailable()Z

    move-result v1

    if-nez v1, :cond_2

    iget-object v1, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    move-object/from16 v3, p1

    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/ImsSmsDispatcher;->isEmergencySmsSupport(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    .line 813
    :cond_0
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/SmsDispatchersController;->isCdmaMo()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 814
    iget-object v2, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mCdmaDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    move-object/from16 v3, p1

    move-object/from16 v4, p2

    move-object/from16 v5, p3

    move-object/from16 v6, p4

    move-object/from16 v7, p5

    move-object/from16 v8, p6

    move-object/from16 v9, p7

    move/from16 v10, p8

    move/from16 v11, p9

    move/from16 v12, p10

    move/from16 v13, p11

    move/from16 v14, p12

    move-wide/from16 v15, p13

    invoke-virtual/range {v2 .. v16}, Lcom/android/internal/telephony/SMSDispatcher;->sendText(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/app/PendingIntent;Landroid/app/PendingIntent;Landroid/net/Uri;Ljava/lang/String;ZIZIZJ)V

    goto :goto_1

    .line 818
    :cond_1
    iget-object v2, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mGsmDispatcher:Lcom/android/internal/telephony/SMSDispatcher;

    move-object/from16 v3, p1

    move-object/from16 v4, p2

    move-object/from16 v5, p3

    move-object/from16 v6, p4

    move-object/from16 v7, p5

    move-object/from16 v8, p6

    move-object/from16 v9, p7

    move/from16 v10, p8

    move/from16 v11, p9

    move/from16 v12, p10

    move/from16 v13, p11

    move/from16 v14, p12

    move-wide/from16 v15, p13

    invoke-virtual/range {v2 .. v16}, Lcom/android/internal/telephony/SMSDispatcher;->sendText(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/app/PendingIntent;Landroid/app/PendingIntent;Landroid/net/Uri;Ljava/lang/String;ZIZIZJ)V

    goto :goto_1

    :cond_2
    move-object/from16 v3, p1

    .line 809
    :goto_0
    iget-object v2, v0, Lcom/android/internal/telephony/SmsDispatchersController;->mImsSmsDispatcher:Lcom/android/internal/telephony/ImsSmsDispatcher;

    const/4 v12, 0x0

    move-object/from16 v3, p1

    move-object/from16 v4, p2

    move-object/from16 v5, p3

    move-object/from16 v6, p4

    move-object/from16 v7, p5

    move-object/from16 v8, p6

    move-object/from16 v9, p7

    move/from16 v10, p8

    move/from16 v11, p9

    move/from16 v13, p11

    move/from16 v14, p12

    move-wide/from16 v15, p13

    invoke-virtual/range {v2 .. v16}, Lcom/android/internal/telephony/SMSDispatcher;->sendText(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/app/PendingIntent;Landroid/app/PendingIntent;Landroid/net/Uri;Ljava/lang/String;ZIZIZJ)V

    :goto_1
    return-void
.end method

.method public setPremiumSmsPermission(Ljava/lang/String;I)V
    .locals 0

    .line 974
    iget-object p0, p0, Lcom/android/internal/telephony/SmsDispatchersController;->mUsageMonitor:Lcom/android/internal/telephony/SmsUsageMonitor;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/SmsUsageMonitor;->setPremiumSmsPermission(Ljava/lang/String;I)V

    return-void
.end method
