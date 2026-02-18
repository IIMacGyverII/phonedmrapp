.class public final Lcom/android/internal/telephony/SomeArgs;
.super Ljava/lang/Object;
.source "SomeArgs.java"


# static fields
.field private static final MAX_POOL_SIZE:I = 0xa

.field static final WAIT_FINISHED:I = 0x2

.field static final WAIT_NONE:I = 0x0

.field static final WAIT_WAITING:I = 0x1

.field private static sPool:Lcom/android/internal/telephony/SomeArgs;

.field private static sPoolLock:Ljava/lang/Object;

.field private static sPoolSize:I


# instance fields
.field public arg1:Ljava/lang/Object;

.field public arg2:Ljava/lang/Object;

.field public arg3:Ljava/lang/Object;

.field public arg4:Ljava/lang/Object;

.field public arg5:Ljava/lang/Object;

.field public arg6:Ljava/lang/Object;

.field public arg7:Ljava/lang/Object;

.field public argi1:I

.field public argi2:I

.field public argi3:I

.field public argi4:I

.field public argi5:I

.field public argi6:I

.field public argl1:J

.field public argl2:J

.field private mInPool:Z

.field private mNext:Lcom/android/internal/telephony/SomeArgs;

.field mWaitState:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 35
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/SomeArgs;->sPoolLock:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 67
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 44
    iput v0, p0, Lcom/android/internal/telephony/SomeArgs;->mWaitState:I

    return-void
.end method

.method private clear()V
    .locals 2

    const/4 v0, 0x0

    .line 117
    iput-object v0, p0, Lcom/android/internal/telephony/SomeArgs;->arg1:Ljava/lang/Object;

    .line 118
    iput-object v0, p0, Lcom/android/internal/telephony/SomeArgs;->arg2:Ljava/lang/Object;

    .line 119
    iput-object v0, p0, Lcom/android/internal/telephony/SomeArgs;->arg3:Ljava/lang/Object;

    .line 120
    iput-object v0, p0, Lcom/android/internal/telephony/SomeArgs;->arg4:Ljava/lang/Object;

    .line 121
    iput-object v0, p0, Lcom/android/internal/telephony/SomeArgs;->arg5:Ljava/lang/Object;

    .line 122
    iput-object v0, p0, Lcom/android/internal/telephony/SomeArgs;->arg6:Ljava/lang/Object;

    .line 123
    iput-object v0, p0, Lcom/android/internal/telephony/SomeArgs;->arg7:Ljava/lang/Object;

    const/4 v0, 0x0

    .line 124
    iput v0, p0, Lcom/android/internal/telephony/SomeArgs;->argi1:I

    .line 125
    iput v0, p0, Lcom/android/internal/telephony/SomeArgs;->argi2:I

    .line 126
    iput v0, p0, Lcom/android/internal/telephony/SomeArgs;->argi3:I

    .line 127
    iput v0, p0, Lcom/android/internal/telephony/SomeArgs;->argi4:I

    .line 128
    iput v0, p0, Lcom/android/internal/telephony/SomeArgs;->argi5:I

    .line 129
    iput v0, p0, Lcom/android/internal/telephony/SomeArgs;->argi6:I

    const-wide/16 v0, 0x0

    .line 130
    iput-wide v0, p0, Lcom/android/internal/telephony/SomeArgs;->argl1:J

    .line 131
    iput-wide v0, p0, Lcom/android/internal/telephony/SomeArgs;->argl2:J

    return-void
.end method

.method public static obtain()Lcom/android/internal/telephony/SomeArgs;
    .locals 4

    .line 73
    sget-object v0, Lcom/android/internal/telephony/SomeArgs;->sPoolLock:Ljava/lang/Object;

    monitor-enter v0

    .line 74
    :try_start_0
    sget v1, Lcom/android/internal/telephony/SomeArgs;->sPoolSize:I

    if-lez v1, :cond_0

    .line 75
    sget-object v2, Lcom/android/internal/telephony/SomeArgs;->sPool:Lcom/android/internal/telephony/SomeArgs;

    .line 76
    iget-object v3, v2, Lcom/android/internal/telephony/SomeArgs;->mNext:Lcom/android/internal/telephony/SomeArgs;

    sput-object v3, Lcom/android/internal/telephony/SomeArgs;->sPool:Lcom/android/internal/telephony/SomeArgs;

    const/4 v3, 0x0

    .line 77
    iput-object v3, v2, Lcom/android/internal/telephony/SomeArgs;->mNext:Lcom/android/internal/telephony/SomeArgs;

    const/4 v3, 0x0

    .line 78
    iput-boolean v3, v2, Lcom/android/internal/telephony/SomeArgs;->mInPool:Z

    add-int/lit8 v1, v1, -0x1

    .line 79
    sput v1, Lcom/android/internal/telephony/SomeArgs;->sPoolSize:I

    .line 80
    monitor-exit v0

    return-object v2

    .line 82
    :cond_0
    new-instance v1, Lcom/android/internal/telephony/SomeArgs;

    invoke-direct {v1}, Lcom/android/internal/telephony/SomeArgs;-><init>()V

    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception v1

    .line 84
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method


# virtual methods
.method public complete()V
    .locals 2

    .line 88
    monitor-enter p0

    .line 89
    :try_start_0
    iget v0, p0, Lcom/android/internal/telephony/SomeArgs;->mWaitState:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    const/4 v0, 0x2

    .line 92
    iput v0, p0, Lcom/android/internal/telephony/SomeArgs;->mWaitState:I

    .line 93
    invoke-virtual {p0}, Ljava/lang/Object;->notifyAll()V

    .line 94
    monitor-exit p0

    return-void

    .line 90
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Not waiting"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    :catchall_0
    move-exception v0

    .line 94
    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public recycle()V
    .locals 3

    .line 99
    iget-boolean v0, p0, Lcom/android/internal/telephony/SomeArgs;->mInPool:Z

    if-nez v0, :cond_2

    .line 102
    iget v0, p0, Lcom/android/internal/telephony/SomeArgs;->mWaitState:I

    if-eqz v0, :cond_0

    return-void

    .line 105
    :cond_0
    sget-object v0, Lcom/android/internal/telephony/SomeArgs;->sPoolLock:Ljava/lang/Object;

    monitor-enter v0

    .line 106
    :try_start_0
    invoke-direct {p0}, Lcom/android/internal/telephony/SomeArgs;->clear()V

    .line 107
    sget v1, Lcom/android/internal/telephony/SomeArgs;->sPoolSize:I

    const/16 v2, 0xa

    if-ge v1, v2, :cond_1

    .line 108
    sget-object v2, Lcom/android/internal/telephony/SomeArgs;->sPool:Lcom/android/internal/telephony/SomeArgs;

    iput-object v2, p0, Lcom/android/internal/telephony/SomeArgs;->mNext:Lcom/android/internal/telephony/SomeArgs;

    const/4 v2, 0x1

    .line 109
    iput-boolean v2, p0, Lcom/android/internal/telephony/SomeArgs;->mInPool:Z

    .line 110
    sput-object p0, Lcom/android/internal/telephony/SomeArgs;->sPool:Lcom/android/internal/telephony/SomeArgs;

    add-int/2addr v1, v2

    .line 111
    sput v1, Lcom/android/internal/telephony/SomeArgs;->sPoolSize:I

    .line 113
    :cond_1
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    .line 100
    :cond_2
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string v0, "Already recycled."

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
