.class public final Lcom/pri/prizeinterphone/serial/port/SerialPort;
.super Ljava/lang/Object;
.source "SerialPort.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "SerialPort"


# instance fields
.field private fis:Ljava/io/FileInputStream;

.field private fos:Ljava/io/FileOutputStream;

.field private mFd:Ljava/io/FileDescriptor;

.field private success:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "interphone_serial_port"

    .line 95
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 13
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->success:Z

    const/4 v0, 0x0

    .line 15
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->mFd:Ljava/io/FileDescriptor;

    .line 16
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    .line 17
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    return-void
.end method

.method private static native open(Ljava/lang/String;II)Ljava/io/FileDescriptor;
.end method


# virtual methods
.method public native close()V
.end method

.method public getInputStream()Ljava/io/FileInputStream;
    .locals 0

    .line 77
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    return-object p0
.end method

.method public getOutputStream()Ljava/io/FileOutputStream;
    .locals 0

    .line 81
    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    return-object p0
.end method

.method public isConnected()Z
    .locals 1

    .line 86
    iget-boolean v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->success:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->mFd:Ljava/io/FileDescriptor;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public open()Z
    .locals 5

    const-string v0, "SerialPort"

    .line 24
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->isConnected()Z

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_0

    return v2

    :cond_0
    const/4 v1, 0x0

    :try_start_0
    const-string v3, "/dev/ttyS0 open start"

    .line 28
    invoke-static {v0, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string v3, "/dev/ttyS0"

    const v4, 0xe100

    .line 29
    invoke-static {v3, v4, v1}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->open(Ljava/lang/String;II)Ljava/io/FileDescriptor;

    move-result-object v3

    iput-object v3, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->mFd:Ljava/io/FileDescriptor;

    if-nez v3, :cond_1

    const-string v2, "fd == null \u6253\u5f00\u5931\u8d25"

    .line 31
    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 32
    iput-boolean v1, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->success:Z

    goto :goto_0

    .line 34
    :cond_1
    iput-boolean v2, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->success:Z

    .line 35
    new-instance v2, Ljava/io/FileInputStream;

    iget-object v3, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->mFd:Ljava/io/FileDescriptor;

    invoke-direct {v2, v3}, Ljava/io/FileInputStream;-><init>(Ljava/io/FileDescriptor;)V

    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    .line 36
    new-instance v2, Ljava/io/FileOutputStream;

    iget-object v3, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->mFd:Ljava/io/FileDescriptor;

    invoke-direct {v2, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/FileDescriptor;)V

    iput-object v2, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v2

    .line 39
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    .line 40
    iput-boolean v1, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->success:Z

    .line 41
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->close()V

    .line 43
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "/dev/ttyS0 open end,success="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v2, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->success:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 44
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->success:Z

    return p0
.end method

.method public release()V
    .locals 2

    const/4 v0, 0x0

    .line 50
    :try_start_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    if-eqz v1, :cond_0

    .line 51
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 56
    :cond_0
    :goto_0
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    goto :goto_1

    :catchall_0
    move-exception v1

    goto :goto_6

    :catch_0
    move-exception v1

    .line 54
    :try_start_1
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    .line 59
    :goto_1
    :try_start_2
    iget-object v1, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    if-eqz v1, :cond_1

    .line 60
    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 65
    :cond_1
    :goto_2
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    goto :goto_3

    :catchall_1
    move-exception v1

    goto :goto_5

    :catch_1
    move-exception v1

    .line 63
    :try_start_3
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_2

    .line 68
    :goto_3
    :try_start_4
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->close()V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_2

    goto :goto_4

    :catch_2
    move-exception v1

    .line 70
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    .line 72
    :goto_4
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->mFd:Ljava/io/FileDescriptor;

    const/4 v0, 0x0

    .line 73
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->success:Z

    return-void

    .line 65
    :goto_5
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    .line 66
    throw v1

    .line 56
    :goto_6
    iput-object v0, p0, Lcom/pri/prizeinterphone/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    .line 57
    throw v1
.end method
