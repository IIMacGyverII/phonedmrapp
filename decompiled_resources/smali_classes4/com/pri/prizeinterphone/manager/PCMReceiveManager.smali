.class public Lcom/pri/prizeinterphone/manager/PCMReceiveManager;
.super Ljava/lang/Object;
.source "PCMReceiveManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/manager/PCMReceiveManager$WorkHandler;,
        Lcom/pri/prizeinterphone/manager/PCMReceiveManager$SingletonHolder;
    }
.end annotation


# static fields
.field private static final DEFAULT_AUDIO_FORMAT:I = 0x2

.field private static final DEFAULT_CHANNEL_CONFIG:I = 0xc

.field private static final DEFAULT_PLAY_MODE:I = 0x1

.field private static final DEFAULT_SAMPLE_RATE:I = 0x1f40

.field private static final DEFAULT_STREAM_TYPE:I = 0x3

.field public static final PCM_READ_DATA:I = 0x1

.field private static final TAG:Ljava/lang/String; = "PCMReceiveManager"


# instance fields
.field private mAudioTrack:Landroid/media/AudioTrack;

.field private mCallback:Landroid/os/ITinyRecvCallback;

.field private mMinBufferSize:I

.field private mOutputStream:Ljava/io/FileOutputStream;

.field private mPrizeTinyService:Landroid/os/PrizeTinyService;

.field private mReadThread:Landroid/os/HandlerThread;

.field private mReadThreadHandler:Landroid/os/Handler;

.field private mRecordFile:Ljava/io/File;

.field private final mRecordFileDir:Ljava/lang/String;

.field private mSyncTrack:Ljava/lang/Object;

.field private timestamp:J


# direct methods
.method static bridge synthetic -$$Nest$fgetmReadThreadHandler(Lcom/pri/prizeinterphone/manager/PCMReceiveManager;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mReadThreadHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mwriteAudioTrack(Lcom/pri/prizeinterphone/manager/PCMReceiveManager;[BI)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->writeAudioTrack([BI)V

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string v0, "/sdcard/interphone/record"

    .line 31
    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mRecordFileDir:Ljava/lang/String;

    .line 37
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mSyncTrack:Ljava/lang/Object;

    .line 139
    new-instance v0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$1;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$1;-><init>(Lcom/pri/prizeinterphone/manager/PCMReceiveManager;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mCallback:Landroid/os/ITinyRecvCallback;

    .line 40
    new-instance v0, Landroid/os/PrizeTinyService;

    invoke-direct {v0}, Landroid/os/PrizeTinyService;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    .line 41
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->initPcmRead()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/manager/PCMReceiveManager-IA;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;-><init>()V

    return-void
.end method

.method private checkEnvirement()V
    .locals 2

    .line 197
    new-instance v0, Ljava/io/File;

    const-string v1, "/sdcard/interphone/record"

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 198
    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-nez v1, :cond_0

    .line 199
    invoke-virtual {v0}, Ljava/io/File;->mkdir()Z

    .line 201
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mRecordFile:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_1

    .line 202
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mRecordFile:Ljava/io/File;

    invoke-virtual {p0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object p0

    invoke-virtual {p0}, Ljava/io/File;->mkdirs()Z

    :cond_1
    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;
    .locals 1

    .line 49
    invoke-static {}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$SingletonHolder;->-$$Nest$sfgetINSTANCE()Lcom/pri/prizeinterphone/manager/PCMReceiveManager;

    move-result-object v0

    return-object v0
.end method

.method private initAudioTrack()V
    .locals 10

    const/16 v0, 0x1f40

    const/16 v1, 0xc

    const/4 v2, 0x2

    .line 53
    invoke-static {v0, v1, v2}, Landroid/media/AudioTrack;->getMinBufferSize(III)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mMinBufferSize:I

    .line 54
    new-instance v0, Landroid/media/AudioTrack;

    iget v1, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mMinBufferSize:I

    mul-int/lit8 v8, v1, 0x2

    const/4 v4, 0x3

    const/16 v5, 0x1f40

    const/16 v6, 0xc

    const/4 v7, 0x2

    const/4 v9, 0x1

    move-object v3, v0

    invoke-direct/range {v3 .. v9}, Landroid/media/AudioTrack;-><init>(IIIIII)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mAudioTrack:Landroid/media/AudioTrack;

    const-string p0, "PCMReceiveManager"

    const-string v0, "init audiotrack stram:3,rate:8000,chennel:12,format:2"

    .line 55
    invoke-static {p0, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private releaseAutioTrack()V
    .locals 1

    .line 71
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mAudioTrack:Landroid/media/AudioTrack;

    if-eqz v0, :cond_0

    .line 72
    invoke-virtual {v0}, Landroid/media/AudioTrack;->release()V

    const/4 v0, 0x0

    .line 73
    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mAudioTrack:Landroid/media/AudioTrack;

    :cond_0
    return-void
.end method

.method private startAudioTrack()V
    .locals 0

    .line 61
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->initAudioTrack()V

    .line 64
    :try_start_0
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mAudioTrack:Landroid/media/AudioTrack;

    invoke-virtual {p0}, Landroid/media/AudioTrack;->play()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 66
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_0
    return-void
.end method

.method private stopAudioTrack()V
    .locals 2

    .line 80
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mAudioTrack:Landroid/media/AudioTrack;

    if-eqz v0, :cond_0

    .line 81
    invoke-virtual {v0}, Landroid/media/AudioTrack;->getState()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 82
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mAudioTrack:Landroid/media/AudioTrack;

    invoke-virtual {v0}, Landroid/media/AudioTrack;->stop()V

    .line 85
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->releaseAutioTrack()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 87
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_0
    return-void
.end method

.method private writeAudioTrack([BI)V
    .locals 3

    .line 122
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mSyncTrack:Ljava/lang/Object;

    monitor-enter v0

    .line 123
    :try_start_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mAudioTrack:Landroid/media/AudioTrack;

    if-eqz v1, :cond_1

    const/4 v2, 0x0

    .line 124
    invoke-virtual {v1, p1, v2, p2}, Landroid/media/AudioTrack;->write([BII)I

    move-result p2

    .line 125
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v1

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/manager/DmrManager;->needSaveRecordFile()Z

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v1, :cond_0

    .line 127
    :try_start_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mOutputStream:Ljava/io/FileOutputStream;

    if-eqz p0, :cond_0

    .line 128
    invoke-virtual {p0, p1}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 131
    :try_start_2
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :cond_0
    :goto_0
    const-string p0, "PCMReceiveManager"

    .line 134
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "writeAudioTrack "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 136
    :cond_1
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method


# virtual methods
.method public getRecordFileName()Ljava/lang/String;
    .locals 0

    .line 218
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mRecordFile:Ljava/io/File;

    if-eqz p0, :cond_0

    .line 219
    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, ""

    return-object p0
.end method

.method public getRecordFilePath()Ljava/lang/String;
    .locals 0

    .line 211
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mRecordFile:Ljava/io/File;

    if-eqz p0, :cond_0

    .line 212
    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, ""

    return-object p0
.end method

.method public getTimestamp()J
    .locals 2

    .line 207
    iget-wide v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->timestamp:J

    return-wide v0
.end method

.method public initPcmRead()V
    .locals 2

    .line 92
    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "readpcm"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mReadThread:Landroid/os/HandlerThread;

    .line 93
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 94
    new-instance v0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$WorkHandler;

    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mReadThread:Landroid/os/HandlerThread;

    invoke-virtual {v1}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, p0, v1}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager$WorkHandler;-><init>(Lcom/pri/prizeinterphone/manager/PCMReceiveManager;Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mReadThreadHandler:Landroid/os/Handler;

    .line 95
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mCallback:Landroid/os/ITinyRecvCallback;

    invoke-virtual {v0, p0}, Landroid/os/PrizeTinyService;->registerRecvCallback(Landroid/os/ITinyRecvCallback;)V

    return-void
.end method

.method public releaseService()V
    .locals 1

    const/4 v0, 0x0

    .line 225
    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    return-void
.end method

.method public startPcmRead()V
    .locals 4

    const-string v0, "PCMReceiveManager"

    const-string/jumbo v1, "startPcmRead"

    .line 151
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 153
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mSyncTrack:Ljava/lang/Object;

    monitor-enter v0

    .line 154
    :try_start_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->startAudioTrack()V

    .line 155
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 156
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    if-eqz v0, :cond_0

    .line 157
    invoke-virtual {v0}, Landroid/os/PrizeTinyService;->openRecvPcm()Z

    .line 158
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->needSaveRecordFile()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 159
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string/jumbo v1, "yyyyMMdd-HHmmss"

    invoke-direct {v0, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 160
    new-instance v1, Ljava/util/Date;

    invoke-direct {v1}, Ljava/util/Date;-><init>()V

    .line 161
    invoke-virtual {v1}, Ljava/util/Date;->getTime()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->timestamp:J

    .line 162
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ".pcm"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 163
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "/sdcard/interphone/record/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mRecordFile:Ljava/io/File;

    .line 164
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->checkEnvirement()V

    .line 167
    :try_start_1
    new-instance v0, Ljava/io/FileOutputStream;

    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mRecordFile:Ljava/io/File;

    invoke-direct {v0, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mOutputStream:Ljava/io/FileOutputStream;
    :try_end_1
    .catch Ljava/io/FileNotFoundException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 169
    invoke-virtual {p0}, Ljava/io/FileNotFoundException;->printStackTrace()V

    :cond_0
    :goto_0
    return-void

    :catchall_0
    move-exception p0

    .line 155
    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method

.method public stopPcmRead()V
    .locals 2

    const-string v0, "PCMReceiveManager"

    const-string/jumbo v1, "stopPcmRead"

    .line 176
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 177
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mSyncTrack:Ljava/lang/Object;

    monitor-enter v0

    .line 178
    :try_start_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->stopAudioTrack()V

    .line 179
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 180
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    if-eqz v0, :cond_0

    .line 181
    invoke-virtual {v0}, Landroid/os/PrizeTinyService;->closeRecvPcm()V

    .line 183
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mReadThreadHandler:Landroid/os/Handler;

    if-eqz v0, :cond_1

    const/4 v1, 0x1

    .line 184
    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 188
    :cond_1
    :try_start_1
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PCMReceiveManager;->mOutputStream:Ljava/io/FileOutputStream;

    if-eqz p0, :cond_2

    .line 189
    invoke-virtual {p0}, Ljava/io/FileOutputStream;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 192
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :cond_2
    :goto_0
    return-void

    :catchall_0
    move-exception p0

    .line 179
    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method
