.class public Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;
.super Ljava/lang/Object;
.source "AudioRecordPresenter.java"

# interfaces
.implements Lcom/pri/prizeinterphone/audio/IAudioRecordInterface;


# static fields
.field private static final FILE_NAME:Ljava/lang/String;

.field public static final TAG:Ljava/lang/String; = "AudioRecordPresenter"

.field private static presenter:Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;


# instance fields
.field private context:Landroid/content/Context;

.field private isRecording:Z

.field private mAudioRecord:Landroid/media/AudioRecord;

.field private mCurrentId:I

.field private mLastRecordFile:Ljava/io/File;

.field private mOutputStream:Ljava/io/FileOutputStream;

.field private mRecordFileDir:Ljava/lang/String;

.field private mTempRecordFile:Ljava/io/File;

.field private recordBufsize:I

.field private recordingThread:Ljava/lang/Thread;


# direct methods
.method public static synthetic $r8$lambda$zh_tm8ox6gtma04VisWQ_VLS3gA(Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->lambda$startRecord$0()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 2

    .line 57
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v1, Landroid/os/Environment;->DIRECTORY_MUSIC:Ljava/lang/String;

    invoke-static {v1}, Landroid/os/Environment;->getExternalStoragePublicDirectory(Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string/jumbo v1, "test.pcm"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->FILE_NAME:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 29
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 20
    iput-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mAudioRecord:Landroid/media/AudioRecord;

    const/4 v0, 0x0

    .line 21
    iput v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->recordBufsize:I

    .line 24
    iput v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mCurrentId:I

    return-void
.end method

.method private checkEnvirement()V
    .locals 2

    .line 112
    new-instance v0, Ljava/io/File;

    iget-object v1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mRecordFileDir:Ljava/lang/String;

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 113
    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-nez v1, :cond_0

    .line 114
    invoke-virtual {v0}, Ljava/io/File;->mkdir()Z

    .line 116
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mTempRecordFile:Ljava/io/File;

    invoke-virtual {v0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_1

    .line 117
    iget-object p0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mTempRecordFile:Ljava/io/File;

    invoke-virtual {p0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object p0

    invoke-virtual {p0}, Ljava/io/File;->mkdirs()Z

    :cond_1
    return-void
.end method

.method private createAudioRecord()V
    .locals 7

    const v0, 0xac44

    const/16 v1, 0x10

    const/4 v2, 0x2

    .line 44
    invoke-static {v0, v1, v2}, Landroid/media/AudioRecord;->getMinBufferSize(III)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->recordBufsize:I

    .line 47
    new-instance v0, Landroid/media/AudioRecord;

    iget v6, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->recordBufsize:I

    const/4 v2, 0x1

    const v3, 0xac44

    const/16 v4, 0x10

    const/4 v5, 0x2

    move-object v1, v0

    invoke-direct/range {v1 .. v6}, Landroid/media/AudioRecord;-><init>(IIIII)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mAudioRecord:Landroid/media/AudioRecord;

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;
    .locals 1

    .line 32
    sget-object v0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->presenter:Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;

    if-nez v0, :cond_0

    .line 33
    new-instance v0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->presenter:Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;

    .line 35
    :cond_0
    sget-object v0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->presenter:Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;

    return-object v0
.end method

.method private synthetic lambda$startRecord$0()V
    .locals 5

    const/16 v0, -0x13

    .line 86
    invoke-static {v0}, Landroid/os/Process;->setThreadPriority(I)V

    .line 88
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mAudioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v0}, Landroid/media/AudioRecord;->getState()I

    move-result v0

    const-string v1, "AudioRecordPresenter"

    if-nez v0, :cond_0

    const-string/jumbo p0, "startRecord unInit"

    .line 89
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 93
    :cond_0
    iget v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->recordBufsize:I

    new-array v2, v0, [B

    .line 94
    :goto_0
    iget-boolean v3, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->isRecording:Z

    if-eqz v3, :cond_1

    .line 95
    iget-object v3, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mAudioRecord:Landroid/media/AudioRecord;

    const/4 v4, 0x0

    invoke-virtual {v3, v2, v4, v0}, Landroid/media/AudioRecord;->read([BII)I

    .line 98
    :try_start_0
    iget-object v3, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mOutputStream:Ljava/io/FileOutputStream;

    invoke-virtual {v3, v2}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v3

    .line 101
    invoke-virtual {v3}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    :cond_1
    const-string p0, "recording  thread end"

    .line 105
    invoke-static {v1, p0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method public init(Landroid/content/Context;)V
    .locals 0

    .line 39
    iput-object p1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->context:Landroid/content/Context;

    return-void
.end method

.method public startRecord(Ljava/lang/String;)V
    .locals 2

    .line 68
    invoke-direct {p0}, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->createAudioRecord()V

    .line 70
    iput-object p1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mRecordFileDir:Ljava/lang/String;

    .line 71
    new-instance p1, Ljava/io/File;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mRecordFileDir:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/record.pcm"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p1, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mTempRecordFile:Ljava/io/File;

    .line 72
    invoke-direct {p0}, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->checkEnvirement()V

    .line 74
    :try_start_0
    new-instance p1, Ljava/io/FileOutputStream;

    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mTempRecordFile:Ljava/io/File;

    invoke-direct {p1, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mOutputStream:Ljava/io/FileOutputStream;
    :try_end_0
    .catch Ljava/io/FileNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 76
    invoke-virtual {p1}, Ljava/io/FileNotFoundException;->printStackTrace()V

    .line 79
    :goto_0
    iget-boolean p1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->isRecording:Z

    if-eqz p1, :cond_0

    return-void

    :cond_0
    const/4 p1, 0x1

    .line 82
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->isRecording:Z

    .line 83
    iget-object p1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mAudioRecord:Landroid/media/AudioRecord;

    invoke-virtual {p1}, Landroid/media/AudioRecord;->startRecording()V

    .line 84
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v0, "\u5f00\u59cb\u5f55\u97f3 mOutputStream="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mOutputStream:Ljava/io/FileOutputStream;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "AudioRecordPresenter"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 85
    new-instance p1, Ljava/lang/Thread;

    new-instance v0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter$$ExternalSyntheticLambda0;-><init>(Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;)V

    invoke-direct {p1, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    iput-object p1, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->recordingThread:Ljava/lang/Thread;

    .line 108
    invoke-virtual {p1}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public stopRecord()V
    .locals 4

    const/4 v0, 0x0

    .line 124
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->isRecording:Z

    .line 125
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mAudioRecord:Landroid/media/AudioRecord;

    const-string v1, "AudioRecordPresenter"

    if-eqz v0, :cond_0

    .line 126
    invoke-virtual {v0}, Landroid/media/AudioRecord;->stop()V

    const-string/jumbo v0, "\u505c\u6b62\u5f55\u97f3"

    .line 127
    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 128
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mAudioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v0}, Landroid/media/AudioRecord;->release()V

    const/4 v0, 0x0

    .line 129
    iput-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mAudioRecord:Landroid/media/AudioRecord;

    .line 130
    iput-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->recordingThread:Ljava/lang/Thread;

    .line 134
    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mOutputStream:Ljava/io/FileOutputStream;

    invoke-virtual {v0}, Ljava/io/FileOutputStream;->flush()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 136
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    .line 139
    :goto_0
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string/jumbo v2, "yyyy_MM_dd_HH_mm_ss"

    invoke-direct {v0, v2}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 140
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mRecordFileDir:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v3, Ljava/util/Date;

    invoke-direct {v3}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v3}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ".pcm"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 141
    iget-object p0, p0, Lcom/pri/prizeinterphone/audio/AudioRecordPresenter;->mTempRecordFile:Ljava/io/File;

    new-instance v2, Ljava/io/File;

    invoke-direct {v2, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v2}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    .line 142
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "stopRecord: \u5f55\u97f3\u4fdd\u5b58\u5728"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 145
    invoke-static {}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->getInstance()Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;

    move-result-object p0

    invoke-virtual {p0, v0}, Lcom/pri/prizeinterphone/audio/PCMAudioPlayer;->startPlay(Ljava/lang/String;)V

    return-void
.end method
