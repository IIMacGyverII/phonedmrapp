.class public Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;
.super Ljava/lang/Object;
.source "PCMAudioPlayer.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;
    }
.end annotation


# static fields
.field private static final DEFAULT_AUDIO_FORMAT:I = 0x2

.field private static final DEFAULT_CHANNEL_CONFIG:I = 0xc

.field private static final DEFAULT_PLAY_MODE:I = 0x1

.field private static final DEFAULT_SAMPLE_RATE:I = 0x1f40

.field private static final DEFAULT_STREAM_TYPE:I = 0x3

.field private static mInstance:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;


# instance fields
.field private audioTrack:Landroid/media/AudioTrack;

.field private dis:Ljava/io/DataInputStream;

.field private isPlay:Z

.field private final mExecutorService:Ljava/util/concurrent/ExecutorService;

.field private mMinBufferSize:I


# direct methods
.method static bridge synthetic -$$Nest$fgetaudioTrack(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Landroid/media/AudioTrack;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->audioTrack:Landroid/media/AudioTrack;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetdis(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Ljava/io/DataInputStream;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->dis:Ljava/io/DataInputStream;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetisPlay(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->isPlay:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmMinBufferSize(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)I
    .locals 0

    iget p0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mMinBufferSize:I

    return p0
.end method

.method static bridge synthetic -$$Nest$misTalkSend(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;)Z
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->isTalkSend()Z

    move-result p0

    return p0
.end method

.method public constructor <init>()V
    .locals 10

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 33
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->isPlay:Z

    const/16 v0, 0x1f40

    const/16 v1, 0xc

    const/4 v2, 0x2

    .line 36
    invoke-static {v0, v1, v2}, Landroid/media/AudioTrack;->getMinBufferSize(III)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mMinBufferSize:I

    .line 38
    new-instance v0, Landroid/media/AudioTrack;

    iget v1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mMinBufferSize:I

    mul-int/lit8 v8, v1, 0x2

    const/4 v4, 0x3

    const/16 v5, 0x1f40

    const/16 v6, 0xc

    const/4 v7, 0x2

    const/4 v9, 0x1

    move-object v3, v0

    invoke-direct/range {v3 .. v9}, Landroid/media/AudioTrack;-><init>(IIIIII)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->audioTrack:Landroid/media/AudioTrack;

    .line 41
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mExecutorService:Ljava/util/concurrent/ExecutorService;

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;
    .locals 2

    .line 50
    sget-object v0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mInstance:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    if-nez v0, :cond_1

    .line 51
    const-class v0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    monitor-enter v0

    .line 52
    :try_start_0
    sget-object v1, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mInstance:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    if-nez v1, :cond_0

    .line 53
    new-instance v1, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    invoke-direct {v1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;-><init>()V

    sput-object v1, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mInstance:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    .line 55
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 57
    :cond_1
    :goto_0
    sget-object v0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mInstance:Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    return-object v0
.end method

.method private isTalkSend()Z
    .locals 2

    .line 141
    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "pref_person_send_status"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Lcom/pri/prizeinterphone/serial/data/PersonSharePrefData;->getIntData(Landroid/content/Context;Ljava/lang/String;I)I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    move v1, v0

    :cond_0
    return v1
.end method

.method private setPath(Ljava/lang/String;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 67
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 68
    new-instance p1, Ljava/io/DataInputStream;

    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, v0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    invoke-direct {p1, v1}, Ljava/io/DataInputStream;-><init>(Ljava/io/InputStream;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->dis:Ljava/io/DataInputStream;

    return-void
.end method


# virtual methods
.method public release()V
    .locals 1

    .line 109
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->audioTrack:Landroid/media/AudioTrack;

    if-eqz v0, :cond_0

    .line 110
    invoke-virtual {v0}, Landroid/media/AudioTrack;->release()V

    .line 112
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mExecutorService:Ljava/util/concurrent/ExecutorService;

    invoke-interface {p0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    return-void
.end method

.method public startPlay(Ljava/lang/String;)V
    .locals 2

    .line 78
    :try_start_0
    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->setPath(Ljava/lang/String;)V

    const/4 p1, 0x1

    .line 79
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->isPlay:Z

    .line 80
    iget-object p1, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->mExecutorService:Ljava/util/concurrent/ExecutorService;

    new-instance v0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable;-><init>(Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;Lcom/pri/prizeinterphone/audio/PCMAudioPlayer$PlayRunnable-IA;)V

    invoke-interface {p1, v0}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 82
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_0
    return-void
.end method

.method public stopPlay()V
    .locals 2

    const/4 v0, 0x0

    .line 91
    :try_start_0
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->isPlay:Z

    .line 92
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->audioTrack:Landroid/media/AudioTrack;

    if-eqz v0, :cond_0

    .line 93
    invoke-virtual {v0}, Landroid/media/AudioTrack;->getState()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 94
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->audioTrack:Landroid/media/AudioTrack;

    invoke-virtual {v0}, Landroid/media/AudioTrack;->stop()V

    .line 97
    :cond_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->dis:Ljava/io/DataInputStream;

    if-eqz p0, :cond_1

    .line 98
    invoke-virtual {p0}, Ljava/io/DataInputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 101
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :cond_1
    :goto_0
    return-void
.end method
