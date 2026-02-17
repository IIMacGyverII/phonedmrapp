.class public Lcom/pri/prizeinterphone/serial/Serial;
.super Ljava/lang/Object;
.source "Serial.java"


# instance fields
.field private fd:Ljava/io/FileDescriptor;

.field private fic:Ljava/nio/channels/FileChannel;

.field private fis:Ljava/io/FileInputStream;

.field private foc:Ljava/nio/channels/FileChannel;

.field private fos:Ljava/io/FileOutputStream;

.field private success:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "drm"

    .line 19
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 12
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/serial/Serial;->success:Z

    const/4 v0, 0x0

    .line 13
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/Serial;->fd:Ljava/io/FileDescriptor;

    .line 14
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/Serial;->fic:Ljava/nio/channels/FileChannel;

    .line 15
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/Serial;->foc:Ljava/nio/channels/FileChannel;

    .line 16
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/Serial;->fis:Ljava/io/FileInputStream;

    .line 17
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/Serial;->fos:Ljava/io/FileOutputStream;

    return-void
.end method

.method private static native open(Ljava/lang/String;II)Ljava/io/FileDescriptor;
.end method


# virtual methods
.method public native close()V
.end method

.method public getInputChannel()Ljava/nio/channels/FileChannel;
    .locals 0

    .line 49
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/Serial;->fic:Ljava/nio/channels/FileChannel;

    return-object p0
.end method

.method public getInputStream()Ljava/io/FileInputStream;
    .locals 0

    .line 57
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/Serial;->fis:Ljava/io/FileInputStream;

    return-object p0
.end method

.method public getOutputChannel()Ljava/nio/channels/FileChannel;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/Serial;->foc:Ljava/nio/channels/FileChannel;

    return-object p0
.end method

.method public getOutputStream()Ljava/io/FileOutputStream;
    .locals 0

    .line 60
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/Serial;->fos:Ljava/io/FileOutputStream;

    return-object p0
.end method

.method public isConnected()Z
    .locals 1

    .line 65
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/serial/Serial;->success:Z

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/Serial;->fd:Ljava/io/FileDescriptor;

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public open()Z
    .locals 4

    const-string/jumbo v0, "zyingyong"

    .line 23
    iget-boolean v1, p0, Lcom/pri/prizeinterphone/serial/Serial;->success:Z

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/Serial;->fd:Ljava/io/FileDescriptor;

    if-eqz v1, :cond_0

    .line 24
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/Serial;->close()V

    :cond_0
    const/4 v1, 0x0

    :try_start_0
    const-string v2, "/dev/ttyS0 open start"

    .line 26
    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string v2, "/dev/ttyS0"

    const v3, 0xe100

    .line 27
    invoke-static {v2, v3, v1}, Lcom/pri/prizeinterphone/serial/Serial;->open(Ljava/lang/String;II)Ljava/io/FileDescriptor;

    move-result-object v2

    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/Serial;->fd:Ljava/io/FileDescriptor;

    if-nez v2, :cond_1

    const-string v2, "fd == null \u6253\u5f00\u5931\u8d25"

    .line 29
    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 30
    iput-boolean v1, p0, Lcom/pri/prizeinterphone/serial/Serial;->success:Z

    goto :goto_0

    :cond_1
    const/4 v2, 0x1

    .line 32
    iput-boolean v2, p0, Lcom/pri/prizeinterphone/serial/Serial;->success:Z

    .line 33
    new-instance v2, Ljava/io/FileInputStream;

    iget-object v3, p0, Lcom/pri/prizeinterphone/serial/Serial;->fd:Ljava/io/FileDescriptor;

    invoke-direct {v2, v3}, Ljava/io/FileInputStream;-><init>(Ljava/io/FileDescriptor;)V

    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/Serial;->fis:Ljava/io/FileInputStream;

    .line 34
    new-instance v2, Ljava/io/FileOutputStream;

    iget-object v3, p0, Lcom/pri/prizeinterphone/serial/Serial;->fd:Ljava/io/FileDescriptor;

    invoke-direct {v2, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/FileDescriptor;)V

    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/Serial;->fos:Ljava/io/FileOutputStream;

    .line 35
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/Serial;->fis:Ljava/io/FileInputStream;

    invoke-virtual {v2}, Ljava/io/FileInputStream;->getChannel()Ljava/nio/channels/FileChannel;

    move-result-object v2

    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/Serial;->fic:Ljava/nio/channels/FileChannel;

    .line 36
    iget-object v2, p0, Lcom/pri/prizeinterphone/serial/Serial;->fos:Ljava/io/FileOutputStream;

    invoke-virtual {v2}, Ljava/io/FileOutputStream;->getChannel()Ljava/nio/channels/FileChannel;

    move-result-object v2

    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/Serial;->foc:Ljava/nio/channels/FileChannel;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v2

    .line 39
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    .line 40
    iput-boolean v1, p0, Lcom/pri/prizeinterphone/serial/Serial;->success:Z

    .line 41
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/Serial;->close()V

    :goto_0
    const-string v1, "/dev/ttyS0 open end"

    .line 43
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 44
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/serial/Serial;->success:Z

    return p0
.end method
