.class public Lcom/pri/prizeinterphone/ymodem/FileStreamThread;
.super Ljava/lang/Thread;
.source "FileStreamThread.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;
    }
.end annotation


# instance fields
.field private fileByteSize:I

.field private final filePath:Ljava/lang/String;

.field private inputStream:Ljava/io/InputStream;

.field private final isDataAcknowledged:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private isKeepRunning:Z

.field private listener:Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;

.field private final mContext:Landroid/content/Context;


# direct methods
.method constructor <init>(Landroid/content/Context;Ljava/lang/String;Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;)V
    .locals 2

    .line 23
    invoke-direct {p0}, Ljava/lang/Thread;-><init>()V

    const/4 v0, 0x0

    .line 16
    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->inputStream:Ljava/io/InputStream;

    .line 19
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isDataAcknowledged:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 20
    iput-boolean v1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isKeepRunning:Z

    .line 21
    iput v1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->fileByteSize:I

    .line 24
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->mContext:Landroid/content/Context;

    .line 25
    iput-object p2, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->filePath:Ljava/lang/String;

    .line 26
    iput-object p3, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->listener:Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;

    return-void
.end method

.method private initStream()V
    .locals 2

    .line 108
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->inputStream:Ljava/io/InputStream;

    if-nez v0, :cond_0

    .line 110
    :try_start_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->mContext:Landroid/content/Context;

    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->filePath:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->getInputStream(Landroid/content/Context;Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->inputStream:Ljava/io/InputStream;

    .line 111
    invoke-virtual {v0}, Ljava/io/InputStream;->available()I

    move-result v0

    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->fileByteSize:I
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 113
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :cond_0
    :goto_0
    return-void
.end method

.method private onReadFinished()V
    .locals 1

    .line 119
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->inputStream:Ljava/io/InputStream;

    if-eqz v0, :cond_0

    .line 121
    :try_start_0
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V

    const/4 v0, 0x0

    .line 122
    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->inputStream:Ljava/io/InputStream;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 124
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    :cond_0
    :goto_0
    return-void
.end method

.method private onStop()V
    .locals 2

    const/4 v0, 0x0

    .line 101
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isKeepRunning:Z

    .line 102
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isDataAcknowledged:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v1, v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 103
    iput v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->fileByteSize:I

    .line 104
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->onReadFinished()V

    return-void
.end method

.method private prepareData()V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 46
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->initStream()V

    .line 48
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/YModem;->mSize:Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    new-array v0, v0, [B

    .line 51
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isDataAcknowledged:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 52
    iput-boolean v2, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isKeepRunning:Z

    .line 53
    :goto_0
    iget-boolean v1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isKeepRunning:Z

    if-eqz v1, :cond_3

    .line 55
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isDataAcknowledged:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v1

    if-nez v1, :cond_0

    const-wide/16 v3, 0x32

    .line 60
    :try_start_0
    invoke-static {v3, v4}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 62
    invoke-virtual {v1}, Ljava/lang/InterruptedException;->printStackTrace()V

    goto :goto_0

    .line 67
    :cond_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->inputStream:Ljava/io/InputStream;

    invoke-virtual {v1, v0}, Ljava/io/InputStream;->read([B)I

    move-result v1

    const/4 v3, -0x1

    if-ne v1, v3, :cond_1

    const-string v0, "The file data has all been read..."

    .line 68
    invoke-static {v0}, Lcom/pri/prizeinterphone/ymodem/Lg;->f(Ljava/lang/String;)V

    .line 69
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->listener:Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;

    if-eqz v0, :cond_3

    .line 70
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->onStop()V

    .line 71
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->listener:Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;

    invoke-interface {p0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;->onFinish()V

    goto :goto_1

    .line 76
    :cond_1
    invoke-static {v0, v1, v2}, Lcom/pri/prizeinterphone/ymodem/YModemUtil;->getDataPackage([BIB)[B

    move-result-object v1

    .line 78
    iget-object v3, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->listener:Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;

    if-eqz v3, :cond_2

    .line 79
    invoke-interface {v3, v1}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;->onDataReady([B)V

    :cond_2
    add-int/lit8 v2, v2, 0x1

    int-to-byte v2, v2

    .line 83
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isDataAcknowledged:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v3, 0x0

    invoke-virtual {v1, v3}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    goto :goto_0

    :cond_3
    :goto_1
    return-void
.end method


# virtual methods
.method getFileByteSize()I
    .locals 1

    .line 30
    iget v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->fileByteSize:I

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->inputStream:Ljava/io/InputStream;

    if-nez v0, :cond_1

    .line 31
    :cond_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->initStream()V

    .line 33
    :cond_1
    iget p0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->fileByteSize:I

    return p0
.end method

.method keepReading()V
    .locals 1

    .line 92
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->isDataAcknowledged:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    return-void
.end method

.method release()V
    .locals 1

    .line 96
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->onStop()V

    const/4 v0, 0x0

    .line 97
    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->listener:Lcom/pri/prizeinterphone/ymodem/FileStreamThread$DataRaderListener;

    return-void
.end method

.method public run()V
    .locals 0

    .line 39
    :try_start_0
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/FileStreamThread;->prepareData()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 41
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    :goto_0
    return-void
.end method
