.class public final Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;
.super Ljava/lang/Object;
.source "NitzSignalInputFilterPredicateFactory.java"


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$NitzSignalInputFilterPredicateImpl;,
        Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;
    }
.end annotation


# static fields
.field private static final DBG:Z = true

.field private static final LOG_TAG:Ljava/lang/String; = "NitzStateMachineImpl"

.field private static final WAKELOCK_TAG:Ljava/lang/String; = "NitzSignalInputFilterPredicateFactory"


# direct methods
.method public static synthetic $r8$lambda$AFH-grvcNqec6oFVX3e6XyckO4g(Landroid/os/PowerManager$WakeLock;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;
    .locals 0

    invoke-static {p0, p1, p2, p3}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;->lambda$createBogusElapsedRealtimeCheck$1(Landroid/os/PowerManager$WakeLock;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$RyT8N5u9h9eBBMUvGLQRGa2YYus(Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;->lambda$createNoOldSignalCheck$2(Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$dRDT18aFkQ7rzNlYAPjK13S5LWg(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;->lambda$createIgnoreNitzPropertyCheck$0(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0
.end method

.method private constructor <init>()V
    .locals 0

    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static create(Landroid/content/Context;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)Lcom/android/internal/telephony/nitz/NitzStateMachineImpl$NitzSignalInputFilterPredicate;
    .locals 3

    .line 56
    invoke-static {p0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 57
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    const/4 v0, 0x4

    new-array v0, v0, [Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;

    .line 61
    invoke-static {p1}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;->createIgnoreNitzPropertyCheck(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    .line 63
    invoke-static {p0, p1}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;->createBogusElapsedRealtimeCheck(Landroid/content/Context;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;

    move-result-object p0

    const/4 v1, 0x1

    aput-object p0, v0, v1

    .line 65
    invoke-static {}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;->createNoOldSignalCheck()Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;

    move-result-object p0

    const/4 v1, 0x2

    aput-object p0, v0, v1

    .line 67
    invoke-static {p1}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory;->createRateLimitCheck(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;

    move-result-object p0

    const/4 p1, 0x3

    aput-object p0, v0, p1

    .line 69
    new-instance p0, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$NitzSignalInputFilterPredicateImpl;

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$NitzSignalInputFilterPredicateImpl;-><init>([Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;)V

    return-object p0
.end method

.method public static createBogusElapsedRealtimeCheck(Landroid/content/Context;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const-string v0, "power"

    .line 123
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/os/PowerManager;

    const/4 v0, 0x1

    const-string v1, "NitzSignalInputFilterPredicateFactory"

    .line 125
    invoke-virtual {p0, v0, v1}, Landroid/os/PowerManager;->newWakeLock(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;

    move-result-object p0

    .line 127
    new-instance v0, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda0;-><init>(Landroid/os/PowerManager$WakeLock;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)V

    return-object v0
.end method

.method public static createIgnoreNitzPropertyCheck(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 100
    new-instance v0, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)V

    return-object v0
.end method

.method public static createNoOldSignalCheck()Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 162
    new-instance v0, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda2;

    invoke-direct {v0}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$$ExternalSyntheticLambda2;-><init>()V

    return-object v0
.end method

.method public static createRateLimitCheck(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$TrivalentPredicate;
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 178
    new-instance v0, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/nitz/NitzSignalInputFilterPredicateFactory$1;-><init>(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;)V

    return-object v0
.end method

.method private static synthetic lambda$createBogusElapsedRealtimeCheck$1(Landroid/os/PowerManager$WakeLock;Lcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;
    .locals 4

    .line 128
    invoke-static {p3}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 133
    :try_start_0
    invoke-virtual {p0}, Landroid/os/PowerManager$WakeLock;->acquire()V

    .line 135
    invoke-interface {p1}, Lcom/android/internal/telephony/NitzStateMachine$DeviceState;->elapsedRealtimeMillis()J

    move-result-wide p1

    .line 137
    invoke-virtual {p3}, Lcom/android/internal/telephony/NitzSignal;->getReceiptElapsedRealtimeMillis()J

    move-result-wide v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    sub-long v0, p1, v0

    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    if-ltz v2, :cond_1

    const-wide/32 v2, 0x7fffffff

    cmp-long v0, v0, v2

    if-lez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 148
    invoke-virtual {p0}, Landroid/os/PowerManager$WakeLock;->release()V

    return-object p1

    :cond_1
    :goto_0
    :try_start_1
    const-string v0, "NitzStateMachineImpl"

    .line 140
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mustProcessNitzSignal: Not processing NITZ signal because unexpected elapsedRealtime="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, " nitzSignal="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 144
    sget-object p1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 148
    invoke-virtual {p0}, Landroid/os/PowerManager$WakeLock;->release()V

    return-object p1

    :catchall_0
    move-exception p1

    invoke-virtual {p0}, Landroid/os/PowerManager$WakeLock;->release()V

    .line 149
    throw p1
.end method

.method private static synthetic lambda$createIgnoreNitzPropertyCheck$0(Lcom/android/internal/telephony/NitzStateMachine$DeviceState;Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;
    .locals 0

    .line 101
    invoke-interface {p0}, Lcom/android/internal/telephony/NitzStateMachine$DeviceState;->getIgnoreNitz()Z

    move-result p0

    if-eqz p0, :cond_0

    const-string p0, "NitzStateMachineImpl"

    const-string p1, "mustProcessNitzSignal: Not processing NITZ signal because gsm.ignore-nitz is set"

    .line 104
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 107
    sget-object p0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static synthetic lambda$createNoOldSignalCheck$2(Lcom/android/internal/telephony/NitzSignal;Lcom/android/internal/telephony/NitzSignal;)Ljava/lang/Boolean;
    .locals 0

    if-nez p0, :cond_0

    .line 162
    sget-object p0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method
