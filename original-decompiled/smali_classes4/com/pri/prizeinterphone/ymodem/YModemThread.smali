.class public Lcom/pri/prizeinterphone/ymodem/YModemThread;
.super Ljava/lang/Object;
.source "YModemThread.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;
    }
.end annotation


# static fields
.field public static final TAG:Ljava/lang/String; = "YModemThread"


# instance fields
.field private isStop:Z

.field private mYModem:Lcom/pri/prizeinterphone/ymodem/YModem;

.field private mmInStream:Ljava/io/InputStream;

.field private mmOutStream:Ljava/io/OutputStream;

.field private onSendReceiveDataListener:Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;

.field private serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

.field private thread:Ljava/lang/Thread;

.field private final threadFactory:Lcom/pri/prizeinterphone/Util/NamedThreadFactory;


# direct methods
.method public constructor <init>(Lcom/pri/prizeinterphone/serial/port/SerialPort;)V
    .locals 2

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 18
    new-instance v0, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;

    const-string v1, "serial-port-read-t"

    invoke-direct {v0, v1}, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->threadFactory:Lcom/pri/prizeinterphone/Util/NamedThreadFactory;

    const/4 v0, 0x0

    .line 28
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->isStop:Z

    .line 31
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->setSerial(Lcom/pri/prizeinterphone/serial/port/SerialPort;)V

    const/4 p1, 0x1

    .line 32
    iput-boolean p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->isStop:Z

    return-void
.end method

.method public static bytes2HexString([BI)Ljava/lang/String;
    .locals 5

    .line 167
    new-instance v0, Ljava/lang/StringBuffer;

    invoke-direct {v0}, Ljava/lang/StringBuffer;-><init>()V

    const/4 v1, 0x0

    :goto_0
    if-ge v1, p1, :cond_1

    .line 170
    aget-byte v2, p0, v1

    and-int/lit16 v2, v2, 0xff

    invoke-static {v2}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v2

    .line 171
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    const/4 v4, 0x1

    if-ne v3, v4, :cond_0

    .line 172
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const/16 v4, 0x30

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 174
    :cond_0
    invoke-virtual {v2}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    const-string v2, " "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 176
    :cond_1
    invoke-virtual {v0}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private initStream()V
    .locals 1

    .line 44
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->getInputStream()Ljava/io/FileInputStream;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mmInStream:Ljava/io/InputStream;

    .line 45
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/serial/port/SerialPort;->getOutputStream()Ljava/io/FileOutputStream;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mmOutStream:Ljava/io/OutputStream;

    return-void
.end method


# virtual methods
.method public cancel()Z
    .locals 3

    const-string v0, "YModemThread"

    const/4 v1, 0x0

    .line 145
    :try_start_0
    iput-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mmInStream:Ljava/io/InputStream;

    .line 146
    iput-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mmOutStream:Ljava/io/OutputStream;

    const-string v2, "YModemThread:cancel-->\u6210\u529f\u65ad\u5f00\u8fde\u63a5"

    .line 147
    invoke-static {v0, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const/4 p0, 0x1

    return p0

    :catch_0
    move-exception v2

    .line 152
    iput-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mmInStream:Ljava/io/InputStream;

    .line 153
    iput-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mmOutStream:Ljava/io/OutputStream;

    .line 154
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "YModemThread:cancel-->\u65ad\u5f00\u8fde\u63a5\u5f02\u5e38\uff01"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return p0
.end method

.method public isStop()Z
    .locals 0

    .line 40
    iget-boolean p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->isStop:Z

    return p0
.end method

.method public run()V
    .locals 5

    const/16 v0, 0x800

    new-array v0, v0, [B

    .line 74
    :cond_0
    :goto_0
    iget-boolean v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->isStop:Z

    const-string v2, "YModemThread"

    if-nez v1, :cond_4

    .line 76
    :try_start_0
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mmInStream:Ljava/io/InputStream;

    if-nez v1, :cond_1

    const-string v0, "YModemThread:run-->\u8f93\u5165\u6d41mmInStream == null"

    .line 77
    invoke-static {v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_1

    .line 81
    :cond_1
    invoke-virtual {v1}, Ljava/io/InputStream;->available()I

    move-result v1

    if-eqz v1, :cond_0

    .line 83
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mmInStream:Ljava/io/InputStream;

    invoke-virtual {v1, v0}, Ljava/io/InputStream;->read([B)I

    move-result v1

    .line 84
    invoke-static {v0, v1}, Ljava/util/Arrays;->copyOf([BI)[B

    move-result-object v1

    .line 85
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "YModemThread:run-->\u6536\u5230\u6d88\u606f,\u957f\u5ea6"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v4, v1

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, "->"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v4, v1

    invoke-static {v1, v4}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->bytes2HexString([BI)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 86
    iget-object v3, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->onSendReceiveDataListener:Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;

    if-eqz v3, :cond_2

    .line 87
    invoke-interface {v3, v1}, Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;->onReceiveDataSuccess([B)V

    .line 89
    :cond_2
    iget-object v3, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mYModem:Lcom/pri/prizeinterphone/ymodem/YModem;

    if-eqz v3, :cond_0

    .line 90
    invoke-virtual {v3, v1}, Lcom/pri/prizeinterphone/ymodem/YModem;->onReceiveData([B)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 95
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "YModemThread:run-->\u63a5\u6536\u6d88\u606f\u5f02\u5e38\uff01"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 96
    iget-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->onSendReceiveDataListener:Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;

    if-eqz v1, :cond_3

    .line 97
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "\u63a5\u6536\u6d88\u606f\u5f02\u5e38:"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-interface {v1, v0}, Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;->onReceiveDataError(Ljava/lang/String;)V

    .line 100
    :cond_3
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->cancel()Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, "YModemThread:run-->\u63a5\u6536\u6d88\u606f\u5f02\u5e38,\u6210\u529f\u65ad\u5f00\u8fde\u63a5\uff01"

    .line 102
    invoke-static {v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 108
    :cond_4
    :goto_1
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->cancel()Z

    move-result p0

    if-eqz p0, :cond_5

    const-string p0, "YModemThread:run-->\u63a5\u6536\u6d88\u606f\u7ed3\u675f,\u65ad\u5f00\u8fde\u63a5\uff01"

    .line 110
    invoke-static {v2, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_5
    return-void
.end method

.method public setOnSendReceiveDataListener(Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;)V
    .locals 0

    .line 182
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->onSendReceiveDataListener:Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;

    return-void
.end method

.method public setSerial(Lcom/pri/prizeinterphone/serial/port/SerialPort;)V
    .locals 0

    .line 36
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->serial:Lcom/pri/prizeinterphone/serial/port/SerialPort;

    return-void
.end method

.method public setYModem(Lcom/pri/prizeinterphone/ymodem/YModem;)V
    .locals 0

    .line 56
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mYModem:Lcom/pri/prizeinterphone/ymodem/YModem;

    return-void
.end method

.method public startRead()V
    .locals 1

    .line 49
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->initStream()V

    const/4 v0, 0x0

    .line 50
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->isStop:Z

    .line 51
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->threadFactory:Lcom/pri/prizeinterphone/Util/NamedThreadFactory;

    invoke-virtual {v0, p0}, Lcom/pri/prizeinterphone/Util/NamedThreadFactory;->newThread(Ljava/lang/Runnable;)Ljava/lang/Thread;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->thread:Ljava/lang/Thread;

    .line 52
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public stopRead()V
    .locals 1

    .line 60
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->thread:Ljava/lang/Thread;

    if-eqz v0, :cond_0

    .line 61
    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    const/4 v0, 0x0

    .line 62
    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->thread:Ljava/lang/Thread;

    :cond_0
    const/4 v0, 0x1

    .line 64
    iput-boolean v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->isStop:Z

    return-void
.end method

.method public write([B)Z
    .locals 4

    const-string v0, "YModemThread"

    const/4 v1, 0x0

    .line 116
    :try_start_0
    iget-object v2, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->mmOutStream:Ljava/io/OutputStream;

    if-nez v2, :cond_0

    const-string v2, "mmOutStream == null"

    .line 117
    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    .line 122
    :cond_0
    invoke-virtual {v2, p1}, Ljava/io/OutputStream;->write([B)V

    .line 123
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "\u5199\u5165\u6210\u529f\uff1a"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v3, p1

    invoke-static {p1, v3}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->bytes2HexString([BI)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 124
    iget-object v2, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->onSendReceiveDataListener:Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;

    if-eqz v2, :cond_1

    .line 125
    invoke-interface {v2, p1}, Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;->onSendDataSuccess([B)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    :cond_1
    const/4 p0, 0x1

    return p0

    .line 130
    :catch_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "\u5199\u5165\u5931\u8d25\uff1a"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length v3, p1

    invoke-static {p1, v3}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->bytes2HexString([BI)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 131
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemThread;->onSendReceiveDataListener:Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;

    if-eqz p0, :cond_2

    const-string/jumbo v0, "\u5199\u5165\u5931\u8d25"

    .line 132
    invoke-interface {p0, p1, v0}, Lcom/pri/prizeinterphone/ymodem/YModemThread$OnSendReceiveDataListener;->onSendDataError([BLjava/lang/String;)V

    :cond_2
    return v1
.end method
