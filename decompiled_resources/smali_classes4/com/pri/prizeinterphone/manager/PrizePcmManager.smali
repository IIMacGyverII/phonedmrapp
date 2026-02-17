.class public Lcom/pri/prizeinterphone/manager/PrizePcmManager;
.super Ljava/lang/Object;
.source "PrizePcmManager.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "PrizePcmManager"


# instance fields
.field private BUF_SIZE:I

.field private RecordChannel:I

.field private RecordPcmBit:I

.field private SAMPLE_RATE:I

.field private buffer:[B

.field private bufferSize:I

.field private isSaveRecord:Z

.field private mFrameSize:I

.field private mHandler:Landroid/os/Handler;

.field private mIsExit:Z

.field private mIsRecording:Z

.field private mOutputStream:Ljava/io/FileOutputStream;

.field private mPrizeTinyService:Landroid/os/PrizeTinyService;

.field private mRecord:Landroid/media/AudioRecord;

.field private mRecordFile:Ljava/io/File;

.field private final mRecordFileDir:Ljava/lang/String;

.field private mRecordThread:Ljava/lang/Thread;

.field private mRecordWait:Ljava/lang/Object;

.field private timestamp:J


# direct methods
.method static bridge synthetic -$$Nest$fgetmIsExit(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mIsExit:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmIsRecording(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mIsRecording:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmRecord(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)Landroid/media/AudioRecord;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecord:Landroid/media/AudioRecord;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRecordWait(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)Ljava/lang/Object;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordWait:Ljava/lang/Object;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mnotifyRecordThread(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->notifyRecordThread()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mrecordReadRun(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->recordReadRun()V

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 25
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mIsExit:Z

    .line 26
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mIsRecording:Z

    .line 27
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->isSaveRecord:Z

    .line 28
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordWait:Ljava/lang/Object;

    const/16 v0, 0x1f40

    .line 35
    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->SAMPLE_RATE:I

    const/16 v0, 0x400

    .line 36
    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->BUF_SIZE:I

    const/16 v0, 0xc

    .line 37
    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordChannel:I

    const/4 v0, 0x2

    .line 38
    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordPcmBit:I

    const-string v0, "/sdcard/interphone/record"

    .line 40
    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordFileDir:Ljava/lang/String;

    .line 45
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mHandler:Landroid/os/Handler;

    .line 73
    new-instance v0, Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;

    const-string v1, "record"

    invoke-direct {v0, p0, v1}, Lcom/pri/prizeinterphone/manager/PrizePcmManager$1;-><init>(Lcom/pri/prizeinterphone/manager/PrizePcmManager;Ljava/lang/String;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordThread:Ljava/lang/Thread;

    .line 48
    new-instance v0, Landroid/os/PrizeTinyService;

    invoke-direct {v0}, Landroid/os/PrizeTinyService;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    .line 49
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordThread:Ljava/lang/Thread;

    invoke-virtual {p0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private checkEnvirement()V
    .locals 2

    .line 229
    new-instance v0, Ljava/io/File;

    const-string v1, "/sdcard/interphone/record"

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 230
    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-nez v1, :cond_0

    .line 231
    invoke-virtual {v0}, Ljava/io/File;->mkdir()Z

    .line 233
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordFile:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_1

    .line 234
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordFile:Ljava/io/File;

    invoke-virtual {p0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object p0

    invoke-virtual {p0}, Ljava/io/File;->mkdirs()Z

    :cond_1
    return-void
.end method

.method private initRecord()V
    .locals 8

    .line 101
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecord:Landroid/media/AudioRecord;

    const-string v1, "PrizePcmManager"

    if-eqz v0, :cond_0

    const-string v0, "initRecord stopRecord"

    .line 102
    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 103
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->stopRecord()V

    :cond_0
    const-string v0, "debug.channel"

    const/4 v2, 0x2

    .line 106
    invoke-static {v0, v2}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    const/16 v3, 0x10

    if-ne v0, v2, :cond_1

    const/16 v0, 0xc

    .line 108
    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordChannel:I

    goto :goto_0

    .line 110
    :cond_1
    iput v3, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordChannel:I

    :goto_0
    const/16 v0, 0x1f40

    const-string v4, "debug.rate"

    .line 113
    invoke-static {v4, v0}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->SAMPLE_RATE:I

    const-string v0, "debug.bits"

    .line 115
    invoke-static {v0, v3}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    if-ne v0, v3, :cond_2

    .line 117
    iput v2, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordPcmBit:I

    goto :goto_1

    :cond_2
    const/16 v0, 0x16

    .line 119
    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordPcmBit:I

    .line 122
    :goto_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "initRecord RecordChannel:"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordChannel:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ",SAMPLE_RATE:"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->SAMPLE_RATE:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ",RecordPcmBit:"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordPcmBit:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 124
    iget v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->SAMPLE_RATE:I

    iget v2, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordChannel:I

    iget v3, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordPcmBit:I

    invoke-static {v0, v2, v3}, Landroid/media/AudioRecord;->getMinBufferSize(III)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    .line 125
    iget v2, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->SAMPLE_RATE:I

    iget v3, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordChannel:I

    iget v4, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordPcmBit:I

    invoke-static {v2, v3, v4}, Landroid/media/AudioTrack;->getMinBufferSize(III)I

    move-result v2

    invoke-static {v0, v2}, Ljava/lang/Math;->max(II)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    .line 126
    div-int/lit8 v0, v0, 0x8

    mul-int/lit8 v0, v0, 0x8

    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    .line 127
    new-instance v0, Landroid/media/AudioRecord;

    const/4 v3, 0x1

    iget v4, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->SAMPLE_RATE:I

    iget v5, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordChannel:I

    iget v6, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->RecordPcmBit:I

    iget v7, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    move-object v2, v0

    invoke-direct/range {v2 .. v7}, Landroid/media/AudioRecord;-><init>(IIIII)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecord:Landroid/media/AudioRecord;

    .line 129
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "initRecord bufferSize:"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private notifyRecordThread()V
    .locals 3

    .line 93
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordWait:Ljava/lang/Object;

    monitor-enter v0

    const/4 v1, 0x1

    .line 94
    :try_start_0
    iput-boolean v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mIsRecording:Z

    const-string v1, "PrizePcmManager"

    const-string v2, "notify record thread"

    .line 95
    invoke-static {v1, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 96
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordWait:Ljava/lang/Object;

    invoke-virtual {p0}, Ljava/lang/Object;->notifyAll()V

    .line 97
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private recordReadRun()V
    .locals 4

    .line 53
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "recordReadRun mIsRecording:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mIsRecording:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ",mFrameSize:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mFrameSize:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ",bufferSize:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "PrizePcmManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 54
    iget v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    iget v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mFrameSize:I

    if-ge v0, v1, :cond_0

    .line 55
    iput v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    .line 57
    :cond_0
    iget v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    new-array v0, v0, [B

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->buffer:[B

    .line 58
    :cond_1
    :goto_0
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mIsRecording:Z

    if-eqz v0, :cond_2

    .line 59
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecord:Landroid/media/AudioRecord;

    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->buffer:[B

    const/4 v2, 0x0

    iget v3, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->bufferSize:I

    invoke-virtual {v0, v1, v2, v3}, Landroid/media/AudioRecord;->read([BII)I

    move-result v0

    if-lez v0, :cond_1

    .line 61
    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    iget-object v2, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->buffer:[B

    invoke-virtual {v1, v2, v0}, Landroid/os/PrizeTinyService;->writeFrame([BI)I

    .line 62
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->needSaveRecordFile()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-boolean v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->isSaveRecord:Z

    if-eqz v0, :cond_1

    .line 64
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mOutputStream:Ljava/io/FileOutputStream;

    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->buffer:[B

    invoke-virtual {v0, v1}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 66
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    :cond_2
    return-void
.end method

.method private startRecord()Z
    .locals 2

    .line 138
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecord:Landroid/media/AudioRecord;

    invoke-virtual {v0}, Landroid/media/AudioRecord;->startRecording()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 146
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mHandler:Landroid/os/Handler;

    new-instance v1, Lcom/pri/prizeinterphone/manager/PrizePcmManager$2;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager$2;-><init>(Lcom/pri/prizeinterphone/manager/PrizePcmManager;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    const/4 p0, 0x1

    return p0

    :catch_0
    move-exception p0

    const-string v0, "PrizePcmManager"

    const-string/jumbo v1, "startRecord error"

    .line 140
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 141
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    const/4 p0, 0x0

    return p0
.end method

.method private stopRecord()V
    .locals 2

    const/4 v0, 0x0

    .line 182
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mIsRecording:Z

    .line 183
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecord:Landroid/media/AudioRecord;

    if-nez v0, :cond_0

    return-void

    .line 187
    :cond_0
    :try_start_0
    invoke-virtual {v0}, Landroid/media/AudioRecord;->stop()V

    .line 188
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecord:Landroid/media/AudioRecord;

    invoke-virtual {v0}, Landroid/media/AudioRecord;->release()V

    const/4 v0, 0x0

    .line 189
    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecord:Landroid/media/AudioRecord;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 192
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 194
    :goto_0
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->needSaveRecordFile()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mOutputStream:Ljava/io/FileOutputStream;

    if-eqz v0, :cond_1

    .line 196
    :try_start_1
    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_1
    move-exception v0

    .line 198
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    .line 201
    :cond_1
    :goto_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "stopRecord mIsRecording:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mIsRecording:Z

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "PrizePcmManager"

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public createRecordFile()V
    .locals 4

    .line 239
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->needSaveRecordFile()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 240
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string/jumbo v1, "yyyyMMdd-HHmmss"

    invoke-direct {v0, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 241
    new-instance v1, Ljava/util/Date;

    invoke-direct {v1}, Ljava/util/Date;-><init>()V

    .line 242
    invoke-virtual {v1}, Ljava/util/Date;->getTime()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->timestamp:J

    .line 243
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ".pcm"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 245
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "/sdcard/interphone/record/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    iput-object v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordFile:Ljava/io/File;

    .line 246
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->checkEnvirement()V

    .line 249
    :try_start_0
    new-instance v0, Ljava/io/FileOutputStream;

    iget-object v1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordFile:Ljava/io/File;

    invoke-direct {v0, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mOutputStream:Ljava/io/FileOutputStream;
    :try_end_0
    .catch Ljava/io/FileNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 251
    invoke-virtual {v0}, Ljava/io/FileNotFoundException;->printStackTrace()V

    :goto_0
    const/4 v0, 0x1

    .line 253
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->isSaveRecord:Z

    :cond_0
    return-void
.end method

.method public getRecordFileName()Ljava/lang/String;
    .locals 0

    .line 222
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordFile:Ljava/io/File;

    if-eqz p0, :cond_0

    .line 223
    invoke-virtual {p0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, ""

    return-object p0
.end method

.method public getRecordFilePath()Ljava/lang/String;
    .locals 0

    .line 215
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mRecordFile:Ljava/io/File;

    if-eqz p0, :cond_0

    .line 216
    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, ""

    return-object p0
.end method

.method public getSaveRecord()Z
    .locals 0

    .line 258
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->isSaveRecord:Z

    return p0
.end method

.method public getTimestamp()J
    .locals 2

    .line 133
    iget-wide v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->timestamp:J

    return-wide v0
.end method

.method public setSaveRecord(Z)V
    .locals 0

    .line 262
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->isSaveRecord:Z

    return-void
.end method

.method public startPcmRecord()I
    .locals 3

    .line 158
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    invoke-virtual {v0}, Landroid/os/PrizeTinyService;->openWritePcm()Z

    move-result v0

    const-string v1, "PrizePcmManager"

    if-nez v0, :cond_0

    const-string p0, "open write pcm error"

    .line 159
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, -0x1

    return p0

    .line 164
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    invoke-virtual {v0}, Landroid/os/PrizeTinyService;->getFrameSize()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mFrameSize:I

    if-gtz v0, :cond_1

    const-string v0, "get frame size error"

    .line 166
    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 167
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    invoke-virtual {p0}, Landroid/os/PrizeTinyService;->closeWritePcm()V

    const/4 p0, -0x2

    return p0

    .line 170
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "clien get frame size:"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mFrameSize:I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 173
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->initRecord()V

    .line 174
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->startRecord()Z

    move-result p0

    if-nez p0, :cond_2

    const/4 p0, -0x3

    return p0

    :cond_2
    const/4 p0, 0x0

    return p0
.end method

.method public stopPcmRecord()V
    .locals 0

    .line 208
    invoke-direct {p0}, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->stopRecord()V

    .line 210
    iget-object p0, p0, Lcom/pri/prizeinterphone/manager/PrizePcmManager;->mPrizeTinyService:Landroid/os/PrizeTinyService;

    invoke-virtual {p0}, Landroid/os/PrizeTinyService;->closeWritePcm()V

    return-void
.end method
