.class public final Lcom/serial/port/SerialPort;
.super Ljava/lang/Object;
.source "SerialPort.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/serial/port/SerialPort$Builder;
    }
.end annotation


# static fields
.field public static final DEFAULT_SU_PATH:Ljava/lang/String; = "/system/bin/su"

.field private static final TAG:Ljava/lang/String; = "SerialPort"

.field private static sSuPath:Ljava/lang/String; = "/system/bin/su"


# instance fields
.field private baudrate:I

.field private dataBits:I

.field private device:Ljava/io/File;

.field private fd:Ljava/io/FileDescriptor;

.field private fic:Ljava/nio/channels/FileChannel;

.field private fis:Ljava/io/FileInputStream;

.field private flags:I

.field private foc:Ljava/nio/channels/FileChannel;

.field private fos:Ljava/io/FileOutputStream;

.field private mFd:Ljava/io/FileDescriptor;

.field private mFileInputStream:Ljava/io/FileInputStream;

.field private mFileOutputStream:Ljava/io/FileOutputStream;

.field private parity:I

.field private stopBits:I

.field private success:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "serial_port_app"

    .line 309
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 19
    iput-boolean v0, p0, Lcom/serial/port/SerialPort;->success:Z

    const/4 v0, 0x0

    .line 20
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fd:Ljava/io/FileDescriptor;

    .line 21
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fic:Ljava/nio/channels/FileChannel;

    .line 22
    iput-object v0, p0, Lcom/serial/port/SerialPort;->foc:Ljava/nio/channels/FileChannel;

    .line 23
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    .line 24
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    return-void
.end method

.method public constructor <init>(Ljava/io/File;I)V
    .locals 7
    .param p1    # Ljava/io/File;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/SecurityException;,
            Ljava/io/IOException;
        }
    .end annotation

    const/16 v3, 0x8

    const/4 v4, 0x0

    const/4 v5, 0x1

    const/4 v6, 0x0

    move-object v0, p0

    move-object v1, p1

    move v2, p2

    .line 219
    invoke-direct/range {v0 .. v6}, Lcom/serial/port/SerialPort;-><init>(Ljava/io/File;IIIII)V

    return-void
.end method

.method public constructor <init>(Ljava/io/File;IIII)V
    .locals 7
    .param p1    # Ljava/io/File;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/SecurityException;,
            Ljava/io/IOException;
        }
    .end annotation

    const/4 v6, 0x0

    move-object v0, p0

    move-object v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    .line 235
    invoke-direct/range {v0 .. v6}, Lcom/serial/port/SerialPort;-><init>(Ljava/io/File;IIIII)V

    return-void
.end method

.method public constructor <init>(Ljava/io/File;IIIII)V
    .locals 1
    .param p1    # Ljava/io/File;
        .annotation build Landroidx/annotation/NonNull;
        .end annotation
    .end param
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/SecurityException;,
            Ljava/io/IOException;
        }
    .end annotation

    .line 175
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 19
    iput-boolean v0, p0, Lcom/serial/port/SerialPort;->success:Z

    const/4 v0, 0x0

    .line 20
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fd:Ljava/io/FileDescriptor;

    .line 21
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fic:Ljava/nio/channels/FileChannel;

    .line 22
    iput-object v0, p0, Lcom/serial/port/SerialPort;->foc:Ljava/nio/channels/FileChannel;

    .line 23
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    .line 24
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    .line 177
    iput-object p1, p0, Lcom/serial/port/SerialPort;->device:Ljava/io/File;

    .line 178
    iput p2, p0, Lcom/serial/port/SerialPort;->baudrate:I

    .line 179
    iput p3, p0, Lcom/serial/port/SerialPort;->dataBits:I

    .line 180
    iput p4, p0, Lcom/serial/port/SerialPort;->parity:I

    .line 181
    iput p5, p0, Lcom/serial/port/SerialPort;->stopBits:I

    .line 182
    iput p6, p0, Lcom/serial/port/SerialPort;->flags:I

    .line 185
    invoke-virtual {p1}, Ljava/io/File;->canRead()Z

    move-result p3

    if-eqz p3, :cond_0

    invoke-virtual {p1}, Ljava/io/File;->canWrite()Z

    move-result p3

    if-nez p3, :cond_1

    .line 189
    :cond_0
    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object p3

    sget-object p4, Lcom/serial/port/SerialPort;->sSuPath:Ljava/lang/String;

    invoke-virtual {p3, p4}, Ljava/lang/Runtime;->exec(Ljava/lang/String;)Ljava/lang/Process;

    move-result-object p3

    .line 190
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string p5, "chmod 666 "

    invoke-virtual {p4, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p5

    invoke-virtual {p4, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p5, "\nexit\n"

    invoke-virtual {p4, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p4

    .line 191
    invoke-virtual {p3}, Ljava/lang/Process;->getOutputStream()Ljava/io/OutputStream;

    move-result-object p5

    invoke-virtual {p4}, Ljava/lang/String;->getBytes()[B

    move-result-object p4

    invoke-virtual {p5, p4}, Ljava/io/OutputStream;->write([B)V

    .line 192
    invoke-virtual {p3}, Ljava/lang/Process;->waitFor()I

    move-result p3

    if-nez p3, :cond_3

    invoke-virtual {p1}, Ljava/io/File;->canRead()Z

    move-result p3

    if-eqz p3, :cond_3

    invoke-virtual {p1}, Ljava/io/File;->canWrite()Z

    move-result p3
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz p3, :cond_3

    .line 201
    :cond_1
    invoke-virtual {p1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1, p2, p6}, Lcom/serial/port/SerialPort;->open(Ljava/lang/String;II)Ljava/io/FileDescriptor;

    move-result-object p1

    iput-object p1, p0, Lcom/serial/port/SerialPort;->mFd:Ljava/io/FileDescriptor;

    if-eqz p1, :cond_2

    .line 206
    new-instance p1, Ljava/io/FileInputStream;

    iget-object p2, p0, Lcom/serial/port/SerialPort;->mFd:Ljava/io/FileDescriptor;

    invoke-direct {p1, p2}, Ljava/io/FileInputStream;-><init>(Ljava/io/FileDescriptor;)V

    iput-object p1, p0, Lcom/serial/port/SerialPort;->mFileInputStream:Ljava/io/FileInputStream;

    .line 207
    new-instance p1, Ljava/io/FileOutputStream;

    iget-object p2, p0, Lcom/serial/port/SerialPort;->mFd:Ljava/io/FileDescriptor;

    invoke-direct {p1, p2}, Ljava/io/FileOutputStream;-><init>(Ljava/io/FileDescriptor;)V

    iput-object p1, p0, Lcom/serial/port/SerialPort;->mFileOutputStream:Ljava/io/FileOutputStream;

    return-void

    :cond_2
    const-string p0, "SerialPort"

    const-string p1, "native open returns null"

    .line 203
    invoke-static {p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 204
    new-instance p0, Ljava/io/IOException;

    invoke-direct {p0}, Ljava/io/IOException;-><init>()V

    throw p0

    .line 193
    :cond_3
    :try_start_1
    new-instance p0, Ljava/lang/SecurityException;

    invoke-direct {p0}, Ljava/lang/SecurityException;-><init>()V

    throw p0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    :catch_0
    move-exception p0

    .line 196
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    .line 197
    new-instance p0, Ljava/lang/SecurityException;

    invoke-direct {p0}, Ljava/lang/SecurityException;-><init>()V

    throw p0
.end method

.method public static getSuPath()Ljava/lang/String;
    .locals 1
    .annotation build Landroidx/annotation/NonNull;
    .end annotation

    .line 152
    sget-object v0, Lcom/serial/port/SerialPort;->sSuPath:Ljava/lang/String;

    return-object v0
.end method

.method public static newBuilder(Ljava/io/File;I)Lcom/serial/port/SerialPort$Builder;
    .locals 2

    .line 313
    new-instance v0, Lcom/serial/port/SerialPort$Builder;

    const/4 v1, 0x0

    invoke-direct {v0, p0, p1, v1}, Lcom/serial/port/SerialPort$Builder;-><init>(Ljava/io/File;ILcom/serial/port/SerialPort$Builder-IA;)V

    return-object v0
.end method

.method public static newBuilder(Ljava/lang/String;I)Lcom/serial/port/SerialPort$Builder;
    .locals 2

    .line 317
    new-instance v0, Lcom/serial/port/SerialPort$Builder;

    const/4 v1, 0x0

    invoke-direct {v0, p0, p1, v1}, Lcom/serial/port/SerialPort$Builder;-><init>(Ljava/lang/String;ILcom/serial/port/SerialPort$Builder-IA;)V

    return-object v0
.end method

.method private static native open(Ljava/lang/String;II)Ljava/io/FileDescriptor;
.end method

.method public static setSuPath(Ljava/lang/String;)V
    .locals 0
    .param p0    # Ljava/lang/String;
        .annotation build Landroidx/annotation/Nullable;
        .end annotation
    .end param

    if-nez p0, :cond_0

    return-void

    .line 142
    :cond_0
    sput-object p0, Lcom/serial/port/SerialPort;->sSuPath:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public native close()V
.end method

.method public getBaudrate()I
    .locals 0

    .line 257
    iget p0, p0, Lcom/serial/port/SerialPort;->baudrate:I

    return p0
.end method

.method public getDataBits()I
    .locals 0

    .line 262
    iget p0, p0, Lcom/serial/port/SerialPort;->dataBits:I

    return p0
.end method

.method public getDevice()Ljava/io/File;
    .locals 0
    .annotation build Landroidx/annotation/NonNull;
    .end annotation

    .line 252
    iget-object p0, p0, Lcom/serial/port/SerialPort;->device:Ljava/io/File;

    return-object p0
.end method

.method public getFlags()I
    .locals 0

    .line 276
    iget p0, p0, Lcom/serial/port/SerialPort;->flags:I

    return p0
.end method

.method public getInputChannel()Ljava/nio/channels/FileChannel;
    .locals 0

    .line 100
    iget-object p0, p0, Lcom/serial/port/SerialPort;->fic:Ljava/nio/channels/FileChannel;

    return-object p0
.end method

.method public getInputStream()Ljava/io/FileInputStream;
    .locals 0

    .line 108
    iget-object p0, p0, Lcom/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    return-object p0
.end method

.method public getOutputChannel()Ljava/nio/channels/FileChannel;
    .locals 0

    .line 104
    iget-object p0, p0, Lcom/serial/port/SerialPort;->foc:Ljava/nio/channels/FileChannel;

    return-object p0
.end method

.method public getOutputStream()Ljava/io/FileOutputStream;
    .locals 0

    .line 111
    iget-object p0, p0, Lcom/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    return-object p0
.end method

.method public getParity()I
    .locals 0

    .line 267
    iget p0, p0, Lcom/serial/port/SerialPort;->parity:I

    return p0
.end method

.method public getStopBits()I
    .locals 0

    .line 272
    iget p0, p0, Lcom/serial/port/SerialPort;->stopBits:I

    return p0
.end method

.method public isConnected()Z
    .locals 1

    .line 116
    iget-boolean v0, p0, Lcom/serial/port/SerialPort;->success:Z

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/serial/port/SerialPort;->fd:Ljava/io/FileDescriptor;

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

    .line 31
    iget-boolean v1, p0, Lcom/serial/port/SerialPort;->success:Z

    const/4 v2, 0x1

    if-eqz v1, :cond_0

    return v2

    :cond_0
    const/4 v1, 0x0

    :try_start_0
    const-string v3, "/dev/ttyS0 open start"

    .line 35
    invoke-static {v0, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string v3, "/dev/ttyS0"

    const v4, 0xe100

    .line 36
    invoke-static {v3, v4, v1}, Lcom/serial/port/SerialPort;->open(Ljava/lang/String;II)Ljava/io/FileDescriptor;

    move-result-object v3

    iput-object v3, p0, Lcom/serial/port/SerialPort;->fd:Ljava/io/FileDescriptor;

    if-nez v3, :cond_1

    const-string v2, "fd == null \u6253\u5f00\u5931\u8d25"

    .line 38
    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 39
    iput-boolean v1, p0, Lcom/serial/port/SerialPort;->success:Z

    goto :goto_0

    .line 41
    :cond_1
    iput-boolean v2, p0, Lcom/serial/port/SerialPort;->success:Z

    .line 42
    new-instance v2, Ljava/io/FileInputStream;

    iget-object v3, p0, Lcom/serial/port/SerialPort;->fd:Ljava/io/FileDescriptor;

    invoke-direct {v2, v3}, Ljava/io/FileInputStream;-><init>(Ljava/io/FileDescriptor;)V

    iput-object v2, p0, Lcom/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    .line 43
    new-instance v2, Ljava/io/FileOutputStream;

    iget-object v3, p0, Lcom/serial/port/SerialPort;->fd:Ljava/io/FileDescriptor;

    invoke-direct {v2, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/FileDescriptor;)V

    iput-object v2, p0, Lcom/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    .line 44
    iget-object v2, p0, Lcom/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    invoke-virtual {v2}, Ljava/io/FileInputStream;->getChannel()Ljava/nio/channels/FileChannel;

    move-result-object v2

    iput-object v2, p0, Lcom/serial/port/SerialPort;->fic:Ljava/nio/channels/FileChannel;

    .line 45
    iget-object v2, p0, Lcom/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    invoke-virtual {v2}, Ljava/io/FileOutputStream;->getChannel()Ljava/nio/channels/FileChannel;

    move-result-object v2

    iput-object v2, p0, Lcom/serial/port/SerialPort;->foc:Ljava/nio/channels/FileChannel;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v2

    .line 48
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    .line 49
    iput-boolean v1, p0, Lcom/serial/port/SerialPort;->success:Z

    .line 50
    invoke-virtual {p0}, Lcom/serial/port/SerialPort;->close()V

    .line 52
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "/dev/ttyS0 open end,success="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v2, p0, Lcom/serial/port/SerialPort;->success:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 53
    iget-boolean p0, p0, Lcom/serial/port/SerialPort;->success:Z

    return p0
.end method

.method public release()V
    .locals 1

    .line 59
    :try_start_0
    iget-object v0, p0, Lcom/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    if-eqz v0, :cond_0

    .line 60
    invoke-virtual {v0}, Ljava/io/FileInputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 63
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 66
    :cond_0
    :goto_0
    :try_start_1
    iget-object v0, p0, Lcom/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    if-eqz v0, :cond_1

    .line 67
    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_1
    move-exception v0

    .line 70
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 73
    :cond_1
    :goto_1
    :try_start_2
    iget-object v0, p0, Lcom/serial/port/SerialPort;->fic:Ljava/nio/channels/FileChannel;

    if-eqz v0, :cond_2

    .line 74
    invoke-virtual {v0}, Ljava/nio/channels/FileChannel;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_2

    :catch_2
    move-exception v0

    .line 77
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 80
    :cond_2
    :goto_2
    :try_start_3
    iget-object v0, p0, Lcom/serial/port/SerialPort;->foc:Ljava/nio/channels/FileChannel;

    if-eqz v0, :cond_3

    .line 81
    invoke-virtual {v0}, Ljava/nio/channels/FileChannel;->close()V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_3

    goto :goto_3

    :catch_3
    move-exception v0

    .line 84
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 87
    :cond_3
    :goto_3
    :try_start_4
    invoke-virtual {p0}, Lcom/serial/port/SerialPort;->close()V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_4

    goto :goto_4

    :catch_4
    move-exception v0

    .line 89
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    :goto_4
    const/4 v0, 0x0

    .line 91
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fis:Ljava/io/FileInputStream;

    .line 92
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fos:Ljava/io/FileOutputStream;

    .line 93
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fic:Ljava/nio/channels/FileChannel;

    .line 94
    iput-object v0, p0, Lcom/serial/port/SerialPort;->foc:Ljava/nio/channels/FileChannel;

    .line 95
    iput-object v0, p0, Lcom/serial/port/SerialPort;->fd:Ljava/io/FileDescriptor;

    const/4 v0, 0x0

    .line 96
    iput-boolean v0, p0, Lcom/serial/port/SerialPort;->success:Z

    return-void
.end method

.method public tryClose()V
    .locals 1

    .line 290
    :try_start_0
    iget-object v0, p0, Lcom/serial/port/SerialPort;->mFileInputStream:Ljava/io/FileInputStream;

    invoke-virtual {v0}, Ljava/io/FileInputStream;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 296
    :catch_0
    :try_start_1
    iget-object v0, p0, Lcom/serial/port/SerialPort;->mFileOutputStream:Ljava/io/FileOutputStream;

    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1

    .line 302
    :catch_1
    :try_start_2
    invoke-virtual {p0}, Lcom/serial/port/SerialPort;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2

    :catch_2
    return-void
.end method
