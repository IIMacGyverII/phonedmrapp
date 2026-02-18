.class public Lcom/mediatek/anr/MessageLogger;
.super Ljava/lang/Object;
.source "MessageLogger.java"

# interfaces
.implements Landroid/util/Printer;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;,
        Lcom/mediatek/anr/MessageLogger$MessageInfo;
    }
.end annotation


# static fields
.field static final LONGER_TIME:I = 0xc8

.field static final LONGER_TIME_MESSAGE_COUNT:I = 0x14

.field static final MESSAGE_COUNT:I = 0x14

.field private static final MESSAGE_DUMP_SIZE_MAX:I = 0x14

.field private static final TAG:Ljava/lang/String; = "MessageLogger"

.field public static mEnableLooperLog:Z = false

.field private static sGetCurrentTimeMicro:Ljava/lang/reflect/Method;


# instance fields
.field private MSL_Warn:Ljava/lang/String;

.field private mGetMessageQueue:Ljava/lang/reflect/Method;

.field private mLastRecord:Ljava/lang/String;

.field private mLastRecordDateTime:J

.field private mLastRecordKernelTime:J

.field private mLongTimeMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

.field private mMessageField:Ljava/lang/reflect/Field;

.field private mMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

.field private mMessageQueueField:Ljava/lang/reflect/Field;

.field private mMsgCnt:J

.field private mName:Ljava/lang/String;

.field private mNonSleepLastRecordKernelTime:J

.field private mProcessId:J

.field private mState:I

.field private messageInfo:Ljava/lang/StringBuilder;

.field public nonSleepWallStart:J

.field public nonSleepWallTime:J

.field private sInstNotCreated:Ljava/lang/String;

.field public wallStart:J

.field public wallTime:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "currentTimeMicro"

    .line 83
    invoke-static {v0}, Lcom/mediatek/anr/MessageLogger;->getSystemClockMethod(Ljava/lang/String;)Ljava/lang/reflect/Method;

    move-result-object v0

    sput-object v0, Lcom/mediatek/anr/MessageLogger;->sGetCurrentTimeMicro:Ljava/lang/reflect/Method;

    return-void
.end method

.method public constructor <init>()V
    .locals 3

    .line 129
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 66
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mLastRecord:Ljava/lang/String;

    const/4 v1, 0x0

    .line 70
    iput v1, p0, Lcom/mediatek/anr/MessageLogger;->mState:I

    const-wide/16 v1, 0x0

    .line 71
    iput-wide v1, p0, Lcom/mediatek/anr/MessageLogger;->mMsgCnt:J

    .line 72
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mName:Ljava/lang/String;

    const-string v0, "MSL Waraning:"

    .line 74
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    .line 75
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "!!! MessageLoggerInstance might not be created !!!\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->sInstNotCreated:Ljava/lang/String;

    const-string v0, "getQueue"

    .line 84
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->getLooperMethod(Ljava/lang/String;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mGetMessageQueue:Ljava/lang/reflect/Method;

    const-string v0, "mMessages"

    .line 86
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->getMessageQueueField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageQueueField:Ljava/lang/reflect/Field;

    const-string v0, "next"

    .line 87
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->getMessageField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageField:Ljava/lang/reflect/Field;

    .line 130
    invoke-direct {p0}, Lcom/mediatek/anr/MessageLogger;->init()V

    return-void
.end method

.method public constructor <init>(Z)V
    .locals 3

    .line 133
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 66
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mLastRecord:Ljava/lang/String;

    const/4 v1, 0x0

    .line 70
    iput v1, p0, Lcom/mediatek/anr/MessageLogger;->mState:I

    const-wide/16 v1, 0x0

    .line 71
    iput-wide v1, p0, Lcom/mediatek/anr/MessageLogger;->mMsgCnt:J

    .line 72
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mName:Ljava/lang/String;

    const-string v0, "MSL Waraning:"

    .line 74
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    .line 75
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "!!! MessageLoggerInstance might not be created !!!\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->sInstNotCreated:Ljava/lang/String;

    const-string v0, "getQueue"

    .line 84
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->getLooperMethod(Ljava/lang/String;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mGetMessageQueue:Ljava/lang/reflect/Method;

    const-string v0, "mMessages"

    .line 86
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->getMessageQueueField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageQueueField:Ljava/lang/reflect/Field;

    const-string v0, "next"

    .line 87
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->getMessageField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageField:Ljava/lang/reflect/Field;

    .line 134
    sput-boolean p1, Lcom/mediatek/anr/MessageLogger;->mEnableLooperLog:Z

    .line 135
    invoke-direct {p0}, Lcom/mediatek/anr/MessageLogger;->init()V

    return-void
.end method

.method public constructor <init>(ZLjava/lang/String;)V
    .locals 3

    .line 138
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 66
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mLastRecord:Ljava/lang/String;

    const/4 v1, 0x0

    .line 70
    iput v1, p0, Lcom/mediatek/anr/MessageLogger;->mState:I

    const-wide/16 v1, 0x0

    .line 71
    iput-wide v1, p0, Lcom/mediatek/anr/MessageLogger;->mMsgCnt:J

    .line 72
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mName:Ljava/lang/String;

    const-string v0, "MSL Waraning:"

    .line 74
    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    .line 75
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "!!! MessageLoggerInstance might not be created !!!\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->sInstNotCreated:Ljava/lang/String;

    const-string v0, "getQueue"

    .line 84
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->getLooperMethod(Ljava/lang/String;)Ljava/lang/reflect/Method;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mGetMessageQueue:Ljava/lang/reflect/Method;

    const-string v0, "mMessages"

    .line 86
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->getMessageQueueField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageQueueField:Ljava/lang/reflect/Field;

    const-string v0, "next"

    .line 87
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->getMessageField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageField:Ljava/lang/reflect/Field;

    .line 139
    iput-object p2, p0, Lcom/mediatek/anr/MessageLogger;->mName:Ljava/lang/String;

    .line 140
    sput-boolean p1, Lcom/mediatek/anr/MessageLogger;->mEnableLooperLog:Z

    .line 141
    invoke-direct {p0}, Lcom/mediatek/anr/MessageLogger;->init()V

    return-void
.end method

.method private getLooperMethod(Ljava/lang/String;)Ljava/lang/reflect/Method;
    .locals 1

    :try_start_0
    const-string p0, "android.os.Looper"

    .line 100
    invoke-static {p0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/Class;

    .line 101
    invoke-virtual {p0, p1, v0}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private getMessageField(Ljava/lang/String;)Ljava/lang/reflect/Field;
    .locals 0

    :try_start_0
    const-string p0, "android.os.Message"

    .line 120
    invoke-static {p0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    .line 121
    invoke-virtual {p0, p1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p0

    const/4 p1, 0x1

    .line 122
    invoke-virtual {p0, p1}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private getMessageQueueField(Ljava/lang/String;)Ljava/lang/reflect/Field;
    .locals 0

    :try_start_0
    const-string p0, "android.os.MessageQueue"

    .line 109
    invoke-static {p0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    .line 110
    invoke-virtual {p0, p1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p0

    const/4 p1, 0x1

    .line 111
    invoke-virtual {p0, p1}, Ljava/lang/reflect/Field;->setAccessible(Z)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static getSystemClockMethod(Ljava/lang/String;)Ljava/lang/reflect/Method;
    .locals 2

    :try_start_0
    const-string v0, "android.os.SystemClock"

    .line 91
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Class;

    .line 92
    invoke-virtual {v0, p0, v1}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private init()V
    .locals 2

    .line 145
    new-instance v0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    const/16 v1, 0x14

    invoke-direct {v0, p0, v1}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;-><init>(Lcom/mediatek/anr/MessageLogger;I)V

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    .line 146
    new-instance v0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    invoke-direct {v0, p0, v1}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;-><init>(Lcom/mediatek/anr/MessageLogger;I)V

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mLongTimeMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    .line 148
    new-instance v0, Ljava/lang/StringBuilder;

    const/16 v1, 0x5000

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger;->messageInfo:Ljava/lang/StringBuilder;

    .line 149
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v0

    int-to-long v0, v0

    iput-wide v0, p0, Lcom/mediatek/anr/MessageLogger;->mProcessId:J

    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 210
    iget-object p0, p0, Lcom/mediatek/anr/MessageLogger;->messageInfo:Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\n"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    return-void
.end method


# virtual methods
.method public dumpMessageHistory()V
    .locals 14

    .line 275
    monitor-enter p0

    :try_start_0
    const-string v0, ">>> Entering MessageLogger.dump. to Dump MSG HISTORY <<<"

    .line 276
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 277
    iget-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    if-eqz v0, :cond_6

    invoke-virtual {v0}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->size()I

    move-result v0

    if-nez v0, :cond_0

    goto/16 :goto_5

    :cond_0
    const-string v0, "MSG HISTORY IN MAIN THREAD:"

    .line 289
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 290
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Current kernel time : "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "ms PID="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/mediatek/anr/MessageLogger;->mProcessId:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 291
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string/jumbo v1, "yyyy-MM-dd HH:mm:ss.SSS"

    invoke-direct {v0, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 293
    iget-object v1, p0, Lcom/mediatek/anr/MessageLogger;->mMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    invoke-virtual {v1}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->size()I

    move-result v1

    const/4 v2, 0x1

    sub-int/2addr v1, v2

    .line 295
    iget v3, p0, Lcom/mediatek/anr/MessageLogger;->mState:I

    const-wide/16 v4, 0x3e8

    if-ne v3, v2, :cond_1

    .line 296
    new-instance v3, Ljava/util/Date;

    iget-wide v6, p0, Lcom/mediatek/anr/MessageLogger;->mLastRecordDateTime:J

    div-long/2addr v6, v4

    invoke-direct {v3, v6, v7}, Ljava/util/Date;-><init>(J)V

    .line 297
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v6

    iget-wide v8, p0, Lcom/mediatek/anr/MessageLogger;->mLastRecordKernelTime:J

    sub-long/2addr v6, v8

    .line 298
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v8

    iget-wide v10, p0, Lcom/mediatek/anr/MessageLogger;->mNonSleepLastRecordKernelTime:J

    sub-long/2addr v8, v10

    .line 299
    iget-object v10, p0, Lcom/mediatek/anr/MessageLogger;->mMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    invoke-virtual {v10}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->getLast()Lcom/mediatek/anr/MessageLogger$MessageInfo;

    move-result-object v10

    .line 301
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Last record : Msg#:"

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v12, v10, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdStart:J

    invoke-virtual {v11, v12, v13}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v12, " "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v10, v10, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startDispatch:Ljava/lang/String;

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-direct {p0, v10}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 302
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "Last record dispatching elapsedTime:"

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v6, v7}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v6, " ms/upTime:"

    invoke-virtual {v10, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v8, v9}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v6, " ms"

    invoke-virtual {v10, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-direct {p0, v6}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 304
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Last record dispatching time : "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    goto/16 :goto_1

    :cond_1
    :goto_0
    if-ltz v1, :cond_3

    .line 310
    iget-object v3, p0, Lcom/mediatek/anr/MessageLogger;->mMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    invoke-virtual {v3, v1}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->get(I)Lcom/mediatek/anr/MessageLogger$MessageInfo;

    move-result-object v3

    if-nez v3, :cond_2

    goto :goto_1

    .line 312
    :cond_2
    new-instance v6, Ljava/util/Date;

    iget-wide v7, v3, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeElapsed:J

    div-long/2addr v7, v4

    invoke-direct {v6, v7, v8}, Ljava/util/Date;-><init>(J)V

    .line 313
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Msg#:"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v8, v3, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdFinish:J

    invoke-virtual {v7, v8, v9}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v8, " "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v8, v3, Lcom/mediatek/anr/MessageLogger$MessageInfo;->finishDispatch:Ljava/lang/String;

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, " elapsedTime:"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v8, v3, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationElapsed:J

    div-long/2addr v8, v4

    invoke-virtual {v7, v8, v9}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v8, " ms/upTime:"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v8, v3, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationUp:J

    invoke-virtual {v7, v8, v9}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v8, " ms"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-direct {p0, v7}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 315
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Msg#:"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v8, v3, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdStart:J

    invoke-virtual {v7, v8, v9}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v8, " "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, v3, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startDispatch:Ljava/lang/String;

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " from "

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 316
    invoke-virtual {v0, v6}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 315
    invoke-direct {p0, v3}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    :cond_3
    const-string v1, "=== Finish Dumping MSG HISTORY==="

    .line 319
    invoke-direct {p0, v1}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    const-string v1, "=== LONGER MSG HISTORY IN MAIN THREAD ==="

    .line 321
    invoke-direct {p0, v1}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 322
    iget-object v1, p0, Lcom/mediatek/anr/MessageLogger;->mLongTimeMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    invoke-virtual {v1}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->size()I

    move-result v1

    sub-int/2addr v1, v2

    :goto_2
    if-ltz v1, :cond_5

    .line 324
    iget-object v2, p0, Lcom/mediatek/anr/MessageLogger;->mLongTimeMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    invoke-virtual {v2, v1}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->get(I)Lcom/mediatek/anr/MessageLogger$MessageInfo;

    move-result-object v2

    if-nez v2, :cond_4

    goto :goto_3

    .line 326
    :cond_4
    new-instance v3, Ljava/util/Date;

    iget-wide v6, v2, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeElapsed:J

    div-long/2addr v6, v4

    invoke-direct {v3, v6, v7}, Ljava/util/Date;-><init>(J)V

    .line 327
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Msg#:"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v7, v2, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdStart:J

    invoke-virtual {v6, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v7, " "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v7, v2, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startDispatch:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " from "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 328
    invoke-virtual {v0, v3}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " elapsedTime:"

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v7, v2, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationElapsed:J

    div-long/2addr v7, v4

    invoke-virtual {v6, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v3, " ms/upTime:"

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, v2, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationUp:J

    invoke-virtual {v6, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v2, "ms"

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 327
    invoke-direct {p0, v2}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    :goto_3
    add-int/lit8 v1, v1, -0x1

    goto :goto_2

    :cond_5
    const-string v0, "=== Finish Dumping LONGER MSG HISTORY==="

    .line 331
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 334
    :try_start_1
    invoke-virtual {p0}, Lcom/mediatek/anr/MessageLogger;->dumpMessageQueue()V

    .line 335
    invoke-static {}, Lcom/mediatek/anr/AnrManagerNative;->getDefault()Lcom/mediatek/anr/IAnrManager;

    move-result-object v0

    new-instance v1, Ljava/lang/String;

    iget-object v2, p0, Lcom/mediatek/anr/MessageLogger;->messageInfo:Ljava/lang/StringBuilder;

    .line 336
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/String;-><init>(Ljava/lang/String;)V

    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v2

    .line 335
    invoke-interface {v0, v1, v2}, Lcom/mediatek/anr/IAnrManager;->informMessageDump(Ljava/lang/String;I)V

    .line 337
    iget-object v0, p0, Lcom/mediatek/anr/MessageLogger;->messageInfo:Ljava/lang/StringBuilder;

    const/4 v1, 0x0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->delete(II)Ljava/lang/StringBuilder;
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_4

    :catch_0
    move-exception v0

    :try_start_2
    const-string v1, "MessageLogger"

    .line 339
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "informMessageDump exception "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 341
    :goto_4
    monitor-exit p0

    return-void

    .line 278
    :cond_6
    :goto_5
    iget-object v0, p0, Lcom/mediatek/anr/MessageLogger;->sInstNotCreated:Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 279
    invoke-virtual {p0}, Lcom/mediatek/anr/MessageLogger;->dumpMessageQueue()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 281
    :try_start_3
    invoke-static {}, Lcom/mediatek/anr/AnrManagerNative;->getDefault()Lcom/mediatek/anr/IAnrManager;

    move-result-object v0

    iget-object v1, p0, Lcom/mediatek/anr/MessageLogger;->messageInfo:Ljava/lang/StringBuilder;

    .line 282
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v2

    .line 281
    invoke-interface {v0, v1, v2}, Lcom/mediatek/anr/IAnrManager;->informMessageDump(Ljava/lang/String;I)V
    :try_end_3
    .catch Landroid/os/RemoteException; {:try_start_3 .. :try_end_3} :catch_1
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_6

    :catch_1
    move-exception v0

    :try_start_4
    const-string v1, "MessageLogger"

    .line 284
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "informMessageDump exception "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 286
    :goto_6
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    .line 341
    monitor-exit p0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    throw v0
.end method

.method public dumpMessageQueue()V
    .locals 10

    const/4 v0, 0x0

    .line 219
    :try_start_0
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    if-nez v1, :cond_0

    .line 220
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "!!! Current MainLooper is Null !!!"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 222
    :cond_0
    iget-object v2, p0, Lcom/mediatek/anr/MessageLogger;->mGetMessageQueue:Ljava/lang/reflect/Method;

    new-array v3, v0, [Ljava/lang/Object;

    .line 223
    invoke-virtual {v2, v1, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/MessageQueue;

    if-nez v1, :cond_1

    .line 224
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "!!! Current MainLooper\'s MsgQueue is Null !!!"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 227
    :cond_1
    invoke-virtual {p0, v1}, Lcom/mediatek/anr/MessageLogger;->dumpMessageQueueImpl(Landroid/os/MessageQueue;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 231
    :catch_0
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "!!! Calling thread from PID:%d\'s TID:%d(%s),Thread\'s type is %s!!!"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x4

    new-array v3, v2, [Ljava/lang/Object;

    .line 233
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v3, v0

    .line 234
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Thread;->getId()J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    const/4 v5, 0x1

    aput-object v4, v3, v5

    .line 235
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Thread;->getName()Ljava/lang/String;

    move-result-object v4

    const/4 v6, 0x2

    aput-object v4, v3, v6

    .line 236
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    const/4 v7, 0x3

    aput-object v4, v3, v7

    .line 231
    invoke-static {v1, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 238
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Thread;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v1

    .line 239
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "!!! get StackTrace: !!!"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    new-array v4, v0, [Ljava/lang/Object;

    invoke-static {v3, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    move v3, v0

    .line 240
    :goto_1
    array-length v4, v1

    if-ge v3, v4, :cond_2

    .line 241
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v8, p0, Lcom/mediatek/anr/MessageLogger;->MSL_Warn:Ljava/lang/String;

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "File:%s\'s Linenumber:%d, Class:%s, Method:%s"

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    new-array v8, v2, [Ljava/lang/Object;

    aget-object v9, v1, v3

    .line 242
    invoke-virtual {v9}, Ljava/lang/StackTraceElement;->getFileName()Ljava/lang/String;

    move-result-object v9

    aput-object v9, v8, v0

    aget-object v9, v1, v3

    .line 243
    invoke-virtual {v9}, Ljava/lang/StackTraceElement;->getLineNumber()I

    move-result v9

    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    aput-object v9, v8, v5

    aget-object v9, v1, v3

    .line 244
    invoke-virtual {v9}, Ljava/lang/StackTraceElement;->getClassName()Ljava/lang/String;

    move-result-object v9

    aput-object v9, v8, v6

    aget-object v9, v1, v3

    .line 245
    invoke-virtual {v9}, Ljava/lang/StackTraceElement;->getMethodName()Ljava/lang/String;

    move-result-object v9

    aput-object v9, v8, v7

    .line 241
    invoke-static {v4, v8}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_2
    return-void
.end method

.method public dumpMessageQueueImpl(Landroid/os/MessageQueue;)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 250
    monitor-enter p1

    const/4 v0, 0x0

    .line 252
    :try_start_0
    iget-object v1, p0, Lcom/mediatek/anr/MessageLogger;->mMessageQueueField:Ljava/lang/reflect/Field;

    if-eqz v1, :cond_0

    .line 253
    invoke-virtual {v1, p1}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    :cond_0
    if-eqz v0, :cond_3

    const-string v1, "Dump first 20 messages in Queue: "

    .line 256
    invoke-direct {p0, v1}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    const/4 v1, 0x0

    :goto_0
    if-eqz v0, :cond_2

    add-int/lit8 v1, v1, 0x1

    const/16 v2, 0x14

    if-gt v1, v2, :cond_1

    .line 262
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Dump Message in Queue ("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, "): "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 264
    :cond_1
    iget-object v2, p0, Lcom/mediatek/anr/MessageLogger;->mMessageField:Ljava/lang/reflect/Field;

    invoke-virtual {v2, v0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Message;

    goto :goto_0

    .line 267
    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Total Message Count: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    goto :goto_1

    :cond_3
    const-string v0, "mMessages is null"

    .line 269
    invoke-direct {p0, v0}, Lcom/mediatek/anr/MessageLogger;->log(Ljava/lang/String;)V

    .line 271
    :goto_1
    monitor-exit p1

    return-void

    :catchall_0
    move-exception p0

    monitor-exit p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public println(Ljava/lang/String;)V
    .locals 8

    .line 158
    monitor-enter p0

    .line 159
    :try_start_0
    iget v0, p0, Lcom/mediatek/anr/MessageLogger;->mState:I

    const/4 v1, 0x1

    add-int/2addr v0, v1

    iput v0, p0, Lcom/mediatek/anr/MessageLogger;->mState:I

    .line 160
    iget-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mMsgCnt:J

    const-wide/16 v4, 0x1

    add-long/2addr v2, v4

    iput-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mMsgCnt:J

    .line 162
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mLastRecordKernelTime:J

    .line 163
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mNonSleepLastRecordKernelTime:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v0, 0x0

    .line 166
    :try_start_1
    sget-object v2, Lcom/mediatek/anr/MessageLogger;->sGetCurrentTimeMicro:Ljava/lang/reflect/Method;

    if-eqz v2, :cond_0

    const/4 v3, 0x0

    new-array v4, v0, [Ljava/lang/Object;

    .line 167
    invoke-virtual {v2, v3, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Long;

    invoke-virtual {v2}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mLastRecordDateTime:J
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 171
    :catch_0
    :cond_0
    :try_start_2
    iget v2, p0, Lcom/mediatek/anr/MessageLogger;->mState:I

    if-ne v2, v1, :cond_1

    .line 172
    iget-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    invoke-virtual {v0}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->add()Lcom/mediatek/anr/MessageLogger$MessageInfo;

    move-result-object v0

    .line 173
    invoke-virtual {v0}, Lcom/mediatek/anr/MessageLogger$MessageInfo;->init()V

    .line 174
    iput-object p1, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startDispatch:Ljava/lang/String;

    .line 175
    iget-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mMsgCnt:J

    iput-wide v2, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdStart:J

    .line 176
    iget-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mLastRecordDateTime:J

    iput-wide v2, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeElapsed:J

    .line 177
    iget-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mNonSleepLastRecordKernelTime:J

    iput-wide v2, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeUp:J

    goto :goto_0

    .line 179
    :cond_1
    iput v0, p0, Lcom/mediatek/anr/MessageLogger;->mState:I

    .line 181
    iget-object v0, p0, Lcom/mediatek/anr/MessageLogger;->mMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    invoke-virtual {v0}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->getLast()Lcom/mediatek/anr/MessageLogger$MessageInfo;

    move-result-object v0

    .line 182
    iput-object p1, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->finishDispatch:Ljava/lang/String;

    .line 183
    iget-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mMsgCnt:J

    iput-wide v2, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->msgIdFinish:J

    .line 184
    iget-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->mLastRecordDateTime:J

    iget-wide v4, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeElapsed:J

    sub-long/2addr v2, v4

    iput-wide v2, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationElapsed:J

    .line 185
    iget-wide v4, p0, Lcom/mediatek/anr/MessageLogger;->mNonSleepLastRecordKernelTime:J

    iget-wide v6, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->startTimeUp:J

    sub-long/2addr v4, v6

    iput-wide v4, v0, Lcom/mediatek/anr/MessageLogger$MessageInfo;->durationUp:J

    .line 186
    iput-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->wallTime:J

    const-wide/32 v4, 0x30d40

    cmp-long v2, v2, v4

    if-ltz v2, :cond_2

    .line 188
    iget-object v2, p0, Lcom/mediatek/anr/MessageLogger;->mLongTimeMessageHistory:Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;

    invoke-virtual {v2}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->add()Lcom/mediatek/anr/MessageLogger$MessageInfo;

    move-result-object v2

    .line 189
    invoke-virtual {v2, v0}, Lcom/mediatek/anr/MessageLogger$MessageInfo;->copy(Lcom/mediatek/anr/MessageLogger$MessageInfo;)V

    .line 193
    :cond_2
    :goto_0
    sget-boolean v0, Lcom/mediatek/anr/MessageLogger;->mEnableLooperLog:Z

    if-eqz v0, :cond_4

    .line 194
    iget v0, p0, Lcom/mediatek/anr/MessageLogger;->mState:I

    if-ne v0, v1, :cond_3

    const-string v0, "MessageLogger"

    .line 195
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Debugging_MessageLogger: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " start"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    :cond_3
    const-string v0, "MessageLogger"

    .line 197
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Debugging_MessageLogger: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " spent "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, p0, Lcom/mediatek/anr/MessageLogger;->wallTime:J

    const-wide/16 v4, 0x3e8

    div-long/2addr v2, v4

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, "ms"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 201
    :cond_4
    :goto_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p1
.end method

.method public setInitStr(Ljava/lang/String;)V
    .locals 3

    .line 205
    iget-object v0, p0, Lcom/mediatek/anr/MessageLogger;->messageInfo:Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    const/4 v2, 0x0

    invoke-virtual {v0, v2, v1}, Ljava/lang/StringBuilder;->delete(II)Ljava/lang/StringBuilder;

    .line 206
    iget-object p0, p0, Lcom/mediatek/anr/MessageLogger;->messageInfo:Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    return-void
.end method
