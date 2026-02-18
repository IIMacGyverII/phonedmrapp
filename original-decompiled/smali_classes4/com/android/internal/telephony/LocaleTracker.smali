.class public Lcom/android/internal/telephony/LocaleTracker;
.super Landroid/os/Handler;
.source "LocaleTracker.java"


# static fields
.field private static final ACTION_COUNTRY_OVERRIDE:Ljava/lang/String; = "com.android.internal.telephony.action.COUNTRY_OVERRIDE"

.field private static final CELL_INFO_MAX_DELAY_MS:J = 0x927c0L

.field private static final CELL_INFO_MIN_DELAY_MS:J = 0x7d0L

.field private static final CELL_INFO_PERIODIC_POLLING_DELAY_MS:J = 0x927c0L

.field private static final DBG:Z = true

.field private static final EVENT_OPERATOR_LOST:I = 0x6

.field private static final EVENT_OVERRIDE_LOCALE:I = 0x7

.field private static final EVENT_REQUEST_CELL_INFO:I = 0x1

.field private static final EVENT_RESPONSE_CELL_INFO:I = 0x5

.field private static final EVENT_SERVICE_STATE_CHANGED:I = 0x2

.field private static final EVENT_SIM_STATE_CHANGED:I = 0x3

.field private static final EVENT_UNSOL_CELL_INFO:I = 0x4

.field private static final EXTRA_COUNTRY:Ljava/lang/String; = "country"

.field private static final EXTRA_RESET:Ljava/lang/String; = "reset"

.field private static final LAST_KNOWN_COUNTRY_ISO_SHARED_PREFS_KEY:Ljava/lang/String; = "last_known_country_iso"

.field private static final MAX_FAIL_COUNT:I = 0x1e

.field private static final SERVICE_OPERATOR_LOST_DELAY_MS:J = 0x927c0L


# instance fields
.field private final mBroadcastReceiver:Landroid/content/BroadcastReceiver;

.field private mCellInfoList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/CellInfo;",
            ">;"
        }
    .end annotation
.end field

.field private mCountryOverride:Ljava/lang/String;

.field private mCurrentCountryIso:Ljava/lang/String;

.field private mFailCellInfoCount:I

.field private mIsTracking:Z

.field private mLastServiceState:I

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mNitzStateMachine:Lcom/android/internal/telephony/NitzStateMachine;

.field private mOperatorNumeric:Ljava/lang/String;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private mSimState:I

.field private mTag:Ljava/lang/String;


# direct methods
.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/LocaleTracker;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mlog(Lcom/android/internal/telephony/LocaleTracker;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/NitzStateMachine;Landroid/os/Looper;)V
    .locals 2

    .line 247
    invoke-direct {p0, p3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    const/4 p3, 0x3

    .line 161
    iput p3, p0, Lcom/android/internal/telephony/LocaleTracker;->mLastServiceState:I

    const/4 p3, 0x0

    .line 163
    iput-boolean p3, p0, Lcom/android/internal/telephony/LocaleTracker;->mIsTracking:Z

    .line 165
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x20

    invoke-direct {v0, v1, p3}, Lcom/android/internal/telephony/LocalLog;-><init>(IZ)V

    iput-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 168
    new-instance v0, Lcom/android/internal/telephony/LocaleTracker$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/LocaleTracker$1;-><init>(Lcom/android/internal/telephony/LocaleTracker;)V

    iput-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    .line 248
    iput-object p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 249
    iput-object p2, p0, Lcom/android/internal/telephony/LocaleTracker;->mNitzStateMachine:Lcom/android/internal/telephony/NitzStateMachine;

    .line 250
    iput p3, p0, Lcom/android/internal/telephony/LocaleTracker;->mSimState:I

    .line 251
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-class p3, Lcom/android/internal/telephony/LocaleTracker;

    invoke-virtual {p3}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p3, "-"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/LocaleTracker;->mTag:Ljava/lang/String;

    .line 253
    new-instance p2, Landroid/content/IntentFilter;

    invoke-direct {p2}, Landroid/content/IntentFilter;-><init>()V

    const-string p3, "android.telephony.action.SIM_CARD_STATE_CHANGED"

    .line 254
    invoke-virtual {p2, p3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 255
    sget-boolean p3, Lcom/android/internal/telephony/util/TelephonyUtils;->IS_DEBUGGABLE:Z

    if-eqz p3, :cond_0

    const-string p3, "com.android.internal.telephony.action.COUNTRY_OVERRIDE"

    .line 256
    invoke-virtual {p2, p3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 258
    :cond_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p3

    invoke-virtual {p3, v0, p2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    const/4 p2, 0x2

    const/4 p3, 0x0

    .line 260
    invoke-virtual {p1, p0, p2, p3}, Lcom/android/internal/telephony/Phone;->registerForServiceStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    const/4 p2, 0x4

    .line 261
    invoke-virtual {p1, p0, p2, p3}, Lcom/android/internal/telephony/Phone;->registerForCellInfo(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public static getCellInfoDelayTime(I)J
    .locals 4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const/16 v0, 0x1e

    .line 436
    invoke-static {p0, v0}, Ljava/lang/Math;->min(II)I

    move-result p0

    add-int/lit8 p0, p0, -0x1

    int-to-double v0, p0

    const-wide/high16 v2, 0x4000000000000000L    # 2.0

    invoke-static {v2, v3, v0, v1}, Ljava/lang/Math;->pow(DD)D

    move-result-wide v0

    double-to-long v0, v0

    const-wide/16 v2, 0x7d0

    mul-long/2addr v0, v2

    .line 437
    invoke-static {v0, v1, v2, v3}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v0

    const-wide/32 v2, 0x927c0

    invoke-static {v0, v1, v2, v3}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v0

    return-wide v0
.end method

.method private getMccFromCellInfo()Ljava/lang/String;
    .locals 6

    .line 282
    iget-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 283
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    const/4 v2, 0x0

    .line 285
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/CellInfo;

    .line 286
    invoke-virtual {v3}, Landroid/telephony/CellInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v3

    invoke-virtual {v3}, Landroid/telephony/CellIdentity;->getMccString()Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_0

    .line 289
    invoke-interface {v0, v3}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    const/4 v5, 0x1

    if-eqz v4, :cond_1

    .line 290
    invoke-interface {v0, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    add-int/2addr v5, v4

    .line 292
    :cond_1
    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {v0, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    if-le v5, v2, :cond_0

    move-object v1, v3

    move v2, v5

    goto :goto_0

    :cond_2
    return-object v1
.end method

.method private getMccMncFromCellInfo(Ljava/lang/String;)Lcom/android/internal/telephony/MccTable$MccMnc;
    .locals 6

    .line 317
    iget-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 318
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    const/4 v2, 0x0

    .line 320
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/CellInfo;

    .line 321
    invoke-virtual {v3}, Landroid/telephony/CellInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/CellIdentity;->getMccString()Ljava/lang/String;

    move-result-object v4

    .line 322
    invoke-static {v4, p1}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 323
    invoke-virtual {v3}, Landroid/telephony/CellInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v3

    invoke-virtual {v3}, Landroid/telephony/CellIdentity;->getMncString()Ljava/lang/String;

    move-result-object v3

    .line 324
    new-instance v5, Lcom/android/internal/telephony/MccTable$MccMnc;

    invoke-direct {v5, v4, v3}, Lcom/android/internal/telephony/MccTable$MccMnc;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 326
    invoke-interface {v0, v5}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v3

    const/4 v4, 0x1

    if-eqz v3, :cond_1

    .line 327
    invoke-interface {v0, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    add-int/2addr v4, v3

    .line 329
    :cond_1
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v0, v5, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    if-le v4, v2, :cond_0

    move v2, v4

    move-object v1, v5

    goto :goto_0

    :cond_2
    return-object v1
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 627
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 631
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private onServiceStateChanged(Landroid/telephony/ServiceState;)V
    .locals 0

    .line 362
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getState()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mLastServiceState:I

    .line 363
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->updateLocale()V

    .line 364
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->updateTrackingStatus()V

    return-void
.end method

.method private onSimCardStateChanged(I)V
    .locals 0

    .line 351
    iput p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mSimState:I

    .line 352
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->updateLocale()V

    .line 353
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->updateTrackingStatus()V

    return-void
.end method

.method private processCellInfo(Landroid/os/AsyncResult;)V
    .locals 2

    if-eqz p1, :cond_1

    .line 393
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v0, :cond_0

    goto :goto_0

    .line 397
    :cond_0
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/util/List;

    .line 398
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "processCellInfo: cell info="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 399
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    .line 400
    iput-object p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    .line 401
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->updateLocale()V

    return-void

    :cond_1
    :goto_0
    const/4 p1, 0x0

    .line 394
    iput-object p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    return-void
.end method

.method private requestNextCellInfo(Z)V
    .locals 5

    .line 405
    iget-boolean v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mIsTracking:Z

    if-nez v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 407
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    if-eqz p1, :cond_1

    .line 409
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->resetCellInfoRetry()V

    const/4 p1, 0x4

    .line 412
    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeMessages(I)V

    const/4 p1, 0x5

    .line 413
    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeMessages(I)V

    .line 414
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    const-wide/32 v0, 0x927c0

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_0

    .line 418
    :cond_1
    iget p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mFailCellInfoCount:I

    add-int/2addr p1, v0

    iput p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mFailCellInfoCount:I

    invoke-static {p1}, Lcom/android/internal/telephony/LocaleTracker;->getCellInfoDelayTime(I)J

    move-result-wide v1

    .line 419
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Can\'t get cell info. Try again in "

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-wide/16 v3, 0x3e8

    div-long v3, v1, v3

    invoke-virtual {p1, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v3, " secs."

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    .line 420
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    :goto_0
    return-void
.end method

.method private resetCellInfoRetry()V
    .locals 1

    const/4 v0, 0x0

    .line 445
    iput v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mFailCellInfoCount:I

    const/4 v0, 0x1

    .line 446
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    return-void
.end method

.method private startTracking()V
    .locals 2

    .line 473
    iget-boolean v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mIsTracking:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const-string v0, "Starting LocaleTracker"

    .line 475
    iget-object v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 476
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    const/4 v0, 0x1

    .line 477
    iput-boolean v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mIsTracking:Z

    .line 478
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method private stopTracking()V
    .locals 2

    .line 463
    iget-boolean v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mIsTracking:Z

    if-nez v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 464
    iput-boolean v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mIsTracking:Z

    const-string v0, "Stopping LocaleTracker"

    .line 466
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    .line 467
    iget-object v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 468
    iput-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    .line 469
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->resetCellInfoRetry()V

    return-void
.end method

.method private updateLastKnownCountryIso(Ljava/lang/String;)V
    .locals 3

    .line 603
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 604
    iget-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    const-string v2, "last_known_country_iso"

    invoke-virtual {v0, v2, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 606
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 607
    invoke-interface {v0, v2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 608
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 609
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "update country iso in sharedPrefs "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method private declared-synchronized updateLocale()V
    .locals 8

    monitor-enter p0

    :try_start_0
    const-string v0, ""

    const-string v1, "empty as default"

    .line 494
    iget-object v2, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    const/4 v3, 0x0

    if-nez v2, :cond_1

    .line 495
    iget-object v2, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    invoke-static {v2}, Lcom/android/internal/telephony/MccTable$MccMnc;->fromOperatorNumeric(Ljava/lang/String;)Lcom/android/internal/telephony/MccTable$MccMnc;

    move-result-object v2

    if-eqz v2, :cond_0

    .line 497
    iget-object v0, v2, Lcom/android/internal/telephony/MccTable$MccMnc;->mcc:Ljava/lang/String;

    invoke-static {v0}, Lcom/android/internal/telephony/MccTable;->countryCodeForMcc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 498
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "OperatorNumeric("

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "): MccTable.countryCodeForMcc(\""

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, v2, Lcom/android/internal/telephony/MccTable$MccMnc;->mcc:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "\")"

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 500
    invoke-static {v2}, Lcom/android/internal/telephony/MccTable;->geoCountryCodeForMccMnc(Lcom/android/internal/telephony/MccTable$MccMnc;)Ljava/lang/String;

    move-result-object v4

    .line 501
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "OperatorNumeric: MccTable.geoCountryCodeForMccMnc("

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ")"

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_0

    .line 504
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "updateLocale: Can\'t get country from operator numeric. mOperatorNumeric = "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/LocaleTracker;->loge(Ljava/lang/String;)V

    :cond_1
    move-object v2, v3

    move-object v4, v2

    .line 511
    :goto_0
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_2

    .line 512
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->getMccFromCellInfo()Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_2

    .line 514
    invoke-static {v5}, Lcom/android/internal/telephony/MccTable;->countryCodeForMcc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 515
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "CellInfo: MccTable.countryCodeForMcc(\""

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "\")"

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 517
    invoke-direct {p0, v5}, Lcom/android/internal/telephony/LocaleTracker;->getMccMncFromCellInfo(Ljava/lang/String;)Lcom/android/internal/telephony/MccTable$MccMnc;

    move-result-object v5

    if-eqz v5, :cond_2

    .line 519
    invoke-static {v5}, Lcom/android/internal/telephony/MccTable;->geoCountryCodeForMccMnc(Lcom/android/internal/telephony/MccTable$MccMnc;)Ljava/lang/String;

    move-result-object v4

    .line 520
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "CellInfo: MccTable.geoCountryCodeForMccMnc("

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, ")"

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 526
    :cond_2
    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mCountryOverride:Ljava/lang/String;

    if-eqz v5, :cond_3

    .line 528
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCountryOverride = \""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mCountryOverride:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    move-object v2, v1

    move-object v0, v5

    move-object v4, v0

    .line 533
    :cond_3
    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->isRadioOn()Z

    move-result v5

    if-nez v5, :cond_4

    const-string v0, ""

    const-string v1, "radio off"

    .line 538
    :cond_4
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v6, "updateLocale: countryIso = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ", countryIsoDebugInfo = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {p0, v5}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    .line 540
    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mCurrentCountryIso:Ljava/lang/String;

    invoke-static {v0, v5}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_8

    .line 541
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v6, "updateLocale: Change the current country to \""

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "\", countryIsoDebugInfo = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ", mCellInfoList = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 544
    invoke-direct {p0, v5}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    .line 545
    iget-object v6, p0, Lcom/android/internal/telephony/LocaleTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v6, v5}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 546
    iput-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mCurrentCountryIso:Ljava/lang/String;

    .line 549
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_5

    .line 550
    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mCurrentCountryIso:Ljava/lang/String;

    invoke-direct {p0, v5}, Lcom/android/internal/telephony/LocaleTracker;->updateLastKnownCountryIso(Ljava/lang/String;)V

    .line 553
    :cond_5
    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v5

    .line 554
    invoke-static {v5}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v6

    if-eqz v6, :cond_7

    .line 555
    new-instance v6, Ljava/util/ArrayList;

    .line 556
    invoke-static {}, Landroid/internal/telephony/sysprop/TelephonyProperties;->operator_iso_country()Ljava/util/List;

    move-result-object v7

    invoke-direct {v6, v7}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 557
    :goto_1
    invoke-interface {v6}, Ljava/util/List;->size()I

    move-result v7

    if-gt v7, v5, :cond_6

    invoke-interface {v6, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 558
    :cond_6
    iget-object v3, p0, Lcom/android/internal/telephony/LocaleTracker;->mCurrentCountryIso:Ljava/lang/String;

    invoke-interface {v6, v5, v3}, Ljava/util/List;->set(ILjava/lang/Object;)Ljava/lang/Object;

    .line 559
    invoke-static {v6}, Landroid/internal/telephony/sysprop/TelephonyProperties;->operator_iso_country(Ljava/util/List;)V

    .line 562
    :cond_7
    new-instance v3, Landroid/content/Intent;

    const-string v5, "android.telephony.action.NETWORK_COUNTRY_CHANGED"

    invoke-direct {v3, v5}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v5, "android.telephony.extra.NETWORK_COUNTRY"

    .line 563
    invoke-virtual {v3, v5, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string v5, "android.telephony.extra.LAST_KNOWN_NETWORK_COUNTRY"

    .line 565
    invoke-virtual {p0}, Lcom/android/internal/telephony/LocaleTracker;->getLastKnownCountryIso()Ljava/lang/String;

    move-result-object v6

    .line 564
    invoke-virtual {v3, v5, v6}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 566
    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v5

    invoke-static {v3, v5}, Landroid/telephony/SubscriptionManager;->putPhoneIdAndSubIdExtra(Landroid/content/Intent;I)V

    .line 567
    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v5

    invoke-virtual {v5, v3}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    :cond_8
    const/4 v3, 0x0

    .line 573
    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_9

    .line 576
    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    const-string v6, "001"

    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_9

    const/4 v3, 0x1

    const-string v4, ""

    .line 579
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Test cell: "

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    :cond_9
    if-nez v4, :cond_a

    .line 585
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Defaulted: "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_2

    :cond_a
    move-object v0, v4

    .line 587
    :goto_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "updateLocale: timeZoneCountryIso = "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", timeZoneCountryIsoDebugInfo = "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    .line 590
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_b

    if-nez v3, :cond_b

    .line 591
    iget-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mNitzStateMachine:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {v0}, Lcom/android/internal/telephony/NitzStateMachine;->handleCountryUnavailable()V

    goto :goto_3

    .line 593
    :cond_b
    iget-object v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mNitzStateMachine:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {v1, v0}, Lcom/android/internal/telephony/NitzStateMachine;->handleCountryDetected(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 595
    :goto_3
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method private updateOperatorNumericImmediate(Ljava/lang/String;)V
    .locals 2

    .line 383
    iget-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 384
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Operator numeric changes to \""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 385
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/LocaleTracker;->log(Ljava/lang/String;)V

    .line 386
    iget-object v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 387
    iput-object p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    .line 388
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->updateLocale()V

    :cond_0
    return-void
.end method

.method private updateTrackingStatus()V
    .locals 3

    .line 450
    iget v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mSimState:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    .line 452
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/LocaleTracker;->mLastServiceState:I

    if-eq v0, v1, :cond_2

    const/4 v2, 0x2

    if-ne v0, v2, :cond_1

    goto :goto_0

    :cond_1
    const/4 v1, 0x0

    :cond_2
    :goto_0
    if-eqz v1, :cond_3

    .line 456
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->startTracking()V

    goto :goto_1

    .line 458
    :cond_3
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->stopTracking()V

    :goto_1
    return-void
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 3

    .line 642
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 643
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "LocaleTracker-"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ":"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 644
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 645
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsTracking = "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mIsTracking:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 646
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mOperatorNumeric = "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mOperatorNumeric:Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 647
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mSimState = "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mSimState:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 648
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCellInfoList = "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 649
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCurrentCountryIso = "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mCurrentCountryIso:Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 650
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mFailCellInfoCount = "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/LocaleTracker;->mFailCellInfoCount:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Local logs:"

    .line 651
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 652
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 653
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 654
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 655
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 656
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method public getCountryOverride()Ljava/lang/String;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 666
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mCountryOverride:Ljava/lang/String;

    return-object p0
.end method

.method public getCurrentCountry()Ljava/lang/String;
    .locals 0

    .line 271
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mCurrentCountryIso:Ljava/lang/String;

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const-string p0, ""

    :goto_0
    return-object p0
.end method

.method public getLastKnownCountryIso()Ljava/lang/String;
    .locals 2

    .line 621
    iget-object p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "last_known_country_iso"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v1, ""

    .line 623
    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 197
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    packed-switch v0, :pswitch_data_0

    .line 235
    new-instance p0, Ljava/lang/IllegalStateException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected message arrives. msg = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 230
    :pswitch_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    iput-object p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mCountryOverride:Ljava/lang/String;

    .line 231
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->updateLocale()V

    goto :goto_1

    :pswitch_1
    const-string p1, ""

    .line 225
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/LocaleTracker;->updateOperatorNumericImmediate(Ljava/lang/String;)V

    .line 226
    invoke-direct {p0}, Lcom/android/internal/telephony/LocaleTracker;->updateTrackingStatus()V

    goto :goto_1

    .line 209
    :pswitch_2
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/LocaleTracker;->processCellInfo(Landroid/os/AsyncResult;)V

    .line 212
    iget-object p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    if-eqz p1, :cond_0

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    if-lez p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/LocaleTracker;->requestNextCellInfo(Z)V

    goto :goto_1

    .line 203
    :pswitch_3
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/LocaleTracker;->processCellInfo(Landroid/os/AsyncResult;)V

    .line 205
    iget-object p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mCellInfoList:Ljava/util/List;

    if-eqz p1, :cond_1

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    if-lez p1, :cond_1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/LocaleTracker;->requestNextCellInfo(Z)V

    goto :goto_1

    .line 221
    :pswitch_4
    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/LocaleTracker;->onSimCardStateChanged(I)V

    goto :goto_1

    .line 216
    :pswitch_5
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 217
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/ServiceState;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/LocaleTracker;->onServiceStateChanged(Landroid/telephony/ServiceState;)V

    goto :goto_1

    .line 199
    :pswitch_6
    iget-object p1, p0, Lcom/android/internal/telephony/LocaleTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 v0, 0x0

    const/4 v1, 0x5

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p1, v0, p0}, Lcom/android/internal/telephony/Phone;->requestCellInfoUpdate(Landroid/os/WorkSource;Landroid/os/Message;)V

    :cond_1
    :goto_1
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public isTracking()Z
    .locals 0

    .line 599
    iget-boolean p0, p0, Lcom/android/internal/telephony/LocaleTracker;->mIsTracking:Z

    return p0
.end method

.method public updateOperatorNumeric(Ljava/lang/String;)V
    .locals 2

    .line 373
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const/4 v1, 0x6

    if-eqz v0, :cond_0

    .line 374
    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    const-wide/32 v0, 0x927c0

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_0

    .line 376
    :cond_0
    invoke-virtual {p0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 377
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/LocaleTracker;->updateOperatorNumericImmediate(Ljava/lang/String;)V

    :goto_0
    return-void
.end method
