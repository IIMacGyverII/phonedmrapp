.class public Lcom/pri/prizeinterphone/record/AudioRecorder;
.super Ljava/lang/Object;
.source "AudioRecorder.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/record/AudioRecorder$Status;,
        Lcom/pri/prizeinterphone/record/AudioRecorder$AudioRecorderHolder;
    }
.end annotation


# static fields
.field private static final AUDIO_CHANNEL:I = 0x10

.field private static final AUDIO_ENCODING:I = 0x2

.field private static final AUDIO_INPUT:I = 0x1

.field private static final AUDIO_SAMPLE_RATE:I = 0x3e80


# instance fields
.field private audioRecord:Landroid/media/AudioRecord;

.field private bufferSizeInBytes:I

.field private fileName:Ljava/lang/String;

.field private filesName:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;


# direct methods
.method static bridge synthetic -$$Nest$fgetfileName(Lcom/pri/prizeinterphone/record/AudioRecorder;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->fileName:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputfileName(Lcom/pri/prizeinterphone/record/AudioRecorder;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->fileName:Ljava/lang/String;

    return-void
.end method

.method static bridge synthetic -$$Nest$mwriteDataTOFile(Lcom/pri/prizeinterphone/record/AudioRecorder;Lcom/pri/prizeinterphone/record/RecordStreamListener;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/pri/prizeinterphone/record/AudioRecorder;->writeDataTOFile(Lcom/pri/prizeinterphone/record/RecordStreamListener;)V

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 60
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 34
    iput v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->bufferSizeInBytes:I

    .line 40
    sget-object v0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_NO_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    .line 46
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->filesName:Ljava/util/List;

    return-void
.end method

.method synthetic constructor <init>(Lcom/pri/prizeinterphone/record/AudioRecorder-IA;)V
    .locals 0

    invoke-direct {p0}, Lcom/pri/prizeinterphone/record/AudioRecorder;-><init>()V

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/record/AudioRecorder;
    .locals 1

    .line 64
    invoke-static {}, Lcom/pri/prizeinterphone/record/AudioRecorder$AudioRecorderHolder;->-$$Nest$sfgetinstance()Lcom/pri/prizeinterphone/record/AudioRecorder;

    move-result-object v0

    return-object v0
.end method

.method private makePCMFileToWAVFile()V
    .locals 2

    .line 276
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/pri/prizeinterphone/record/AudioRecorder$3;

    invoke-direct {v1, p0}, Lcom/pri/prizeinterphone/record/AudioRecorder$3;-><init>(Lcom/pri/prizeinterphone/record/AudioRecorder;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 288
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private mergePCMFilesToWAVFile(Ljava/util/List;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 257
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/pri/prizeinterphone/record/AudioRecorder$2;

    invoke-direct {v1, p0, p1}, Lcom/pri/prizeinterphone/record/AudioRecorder$2;-><init>(Lcom/pri/prizeinterphone/record/AudioRecorder;Ljava/util/List;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 269
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private writeDataTOFile(Lcom/pri/prizeinterphone/record/RecordStreamListener;)V
    .locals 7

    const-string v0, "AudioRecorder"

    .line 202
    iget v1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->bufferSizeInBytes:I

    new-array v2, v1, [B

    .line 207
    :try_start_0
    iget-object v3, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->fileName:Ljava/lang/String;

    .line 208
    iget-object v4, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    sget-object v5, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_PAUSE:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    if-ne v4, v5, :cond_0

    .line 210
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->filesName:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 213
    :cond_0
    iget-object v4, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->filesName:Ljava/util/List;

    invoke-interface {v4, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 214
    new-instance v4, Ljava/io/File;

    invoke-static {v3}, Lcom/pri/prizeinterphone/record/FileUtil;->getPcmFileAbsolutePath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v4, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 215
    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v3

    if-eqz v3, :cond_1

    .line 216
    invoke-virtual {v4}, Ljava/io/File;->delete()Z

    .line 218
    :cond_1
    new-instance v3, Ljava/io/FileOutputStream;

    invoke-direct {v3, v4}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_3
    .catch Ljava/io/FileNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v3

    .line 223
    invoke-virtual {v3}, Ljava/io/FileNotFoundException;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v3, 0x0

    .line 227
    :goto_0
    sget-object v4, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_START:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    iput-object v4, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    .line 228
    :cond_2
    :goto_1
    iget-object v4, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    sget-object v5, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_START:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    if-ne v4, v5, :cond_3

    .line 229
    iget-object v4, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    iget v5, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->bufferSizeInBytes:I

    const/4 v6, 0x0

    invoke-virtual {v4, v2, v6, v5}, Landroid/media/AudioRecord;->read([BII)I

    move-result v4

    const/4 v5, -0x3

    if-eq v5, v4, :cond_2

    if-eqz v3, :cond_2

    .line 232
    :try_start_1
    invoke-virtual {v3, v2}, Ljava/io/FileOutputStream;->write([B)V

    if-eqz p1, :cond_2

    .line 235
    invoke-interface {p1, v2, v6, v1}, Lcom/pri/prizeinterphone/record/RecordStreamListener;->recordOfByte([BII)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_1
    move-exception v4

    .line 238
    invoke-virtual {v4}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    :cond_3
    if-eqz v3, :cond_4

    .line 244
    :try_start_2
    invoke-virtual {v3}, Ljava/io/FileOutputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_2

    :catch_2
    move-exception p0

    .line 247
    invoke-virtual {p0}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_4
    :goto_2
    return-void

    :catch_3
    move-exception p0

    .line 220
    invoke-virtual {p0}, Ljava/lang/IllegalStateException;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 221
    new-instance p1, Ljava/lang/IllegalStateException;

    invoke-virtual {p0}, Ljava/lang/IllegalStateException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-direct {p1, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
.end method


# virtual methods
.method public canel()V
    .locals 2

    .line 184
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->filesName:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    const/4 v0, 0x0

    .line 185
    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->fileName:Ljava/lang/String;

    .line 186
    iget-object v1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    if-eqz v1, :cond_0

    .line 187
    invoke-virtual {v1}, Landroid/media/AudioRecord;->release()V

    .line 188
    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    .line 191
    :cond_0
    sget-object v0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_NO_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    return-void
.end method

.method public createAudio(Ljava/lang/String;IIII)V
    .locals 7

    .line 72
    invoke-static {p3, p4, p4}, Landroid/media/AudioRecord;->getMinBufferSize(III)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->bufferSizeInBytes:I

    .line 74
    new-instance v0, Landroid/media/AudioRecord;

    iget v6, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->bufferSizeInBytes:I

    move-object v1, v0

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    invoke-direct/range {v1 .. v6}, Landroid/media/AudioRecord;-><init>(IIIII)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    .line 75
    iput-object p1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->fileName:Ljava/lang/String;

    return-void
.end method

.method public createDefaultAudio(Ljava/lang/String;)V
    .locals 7

    const/16 v0, 0x3e80

    const/16 v1, 0x10

    const/4 v2, 0x2

    .line 85
    invoke-static {v0, v1, v2}, Landroid/media/AudioRecord;->getMinBufferSize(III)I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->bufferSizeInBytes:I

    .line 87
    new-instance v0, Landroid/media/AudioRecord;

    iget v6, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->bufferSizeInBytes:I

    const/4 v2, 0x1

    const/16 v3, 0x3e80

    const/16 v4, 0x10

    const/4 v5, 0x2

    move-object v1, v0

    invoke-direct/range {v1 .. v6}, Landroid/media/AudioRecord;-><init>(IIIII)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    .line 88
    iput-object p1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->fileName:Ljava/lang/String;

    .line 89
    sget-object p1, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    iput-object p1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    return-void
.end method

.method public getPcmFilesCount()I
    .locals 0

    .line 306
    iget-object p0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->filesName:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result p0

    return p0
.end method

.method public getStatus()Lcom/pri/prizeinterphone/record/AudioRecorder$Status;
    .locals 0

    .line 297
    iget-object p0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    return-object p0
.end method

.method public pauseRecord()V
    .locals 2

    const-string v0, "AudioRecorder"

    const-string v1, "===pauseRecord==="

    .line 121
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 122
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    sget-object v1, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_START:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    if-ne v0, v1, :cond_0

    .line 125
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v0}, Landroid/media/AudioRecord;->stop()V

    .line 126
    sget-object v0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_PAUSE:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    return-void

    .line 123
    :cond_0
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string/jumbo v0, "\u6ca1\u6709\u5728\u5f55\u97f3"

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public release()V
    .locals 2

    const-string v0, "AudioRecorder"

    const-string v1, "===release==="

    .line 148
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 172
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    if-eqz v0, :cond_0

    .line 173
    invoke-virtual {v0}, Landroid/media/AudioRecord;->release()V

    const/4 v0, 0x0

    .line 174
    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    .line 177
    :cond_0
    sget-object v0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_NO_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    return-void
.end method

.method public startRecord(Lcom/pri/prizeinterphone/record/RecordStreamListener;)V
    .locals 2

    .line 100
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    sget-object v1, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_NO_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    if-eq v0, v1, :cond_1

    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->fileName:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 103
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    sget-object v1, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_START:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    if-eq v0, v1, :cond_0

    .line 106
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "===startRecord==="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v1}, Landroid/media/AudioRecord;->getState()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "AudioRecorder"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 107
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v0}, Landroid/media/AudioRecord;->startRecording()V

    .line 109
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/pri/prizeinterphone/record/AudioRecorder$1;

    invoke-direct {v1, p0, p1}, Lcom/pri/prizeinterphone/record/AudioRecorder$1;-><init>(Lcom/pri/prizeinterphone/record/AudioRecorder;Lcom/pri/prizeinterphone/record/RecordStreamListener;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 114
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void

    .line 104
    :cond_0
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string/jumbo p1, "\u6b63\u5728\u5f55\u97f3"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 101
    :cond_1
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string/jumbo p1, "\u5f55\u97f3\u5c1a\u672a\u521d\u59cb\u5316,\u8bf7\u68c0\u67e5\u662f\u5426\u7981\u6b62\u4e86\u5f55\u97f3\u6743\u9650~"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public stopRecord()V
    .locals 2

    const-string v0, "AudioRecorder"

    const-string v1, "===stopRecord==="

    .line 134
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 135
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    sget-object v1, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_NO_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    if-eq v0, v1, :cond_0

    sget-object v1, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_READY:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    if-eq v0, v1, :cond_0

    .line 138
    iget-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->audioRecord:Landroid/media/AudioRecord;

    invoke-virtual {v0}, Landroid/media/AudioRecord;->stop()V

    .line 139
    sget-object v0, Lcom/pri/prizeinterphone/record/AudioRecorder$Status;->STATUS_STOP:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    iput-object v0, p0, Lcom/pri/prizeinterphone/record/AudioRecorder;->status:Lcom/pri/prizeinterphone/record/AudioRecorder$Status;

    .line 140
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/record/AudioRecorder;->release()V

    return-void

    .line 136
    :cond_0
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string/jumbo v0, "\u5f55\u97f3\u5c1a\u672a\u5f00\u59cb"

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
