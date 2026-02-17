.class public Lcom/pri/prizeinterphone/Util/ReadFileUtils;
.super Ljava/lang/Object;
.source "ReadFileUtils.java"


# static fields
.field private static final DMR009_FILENAME:Ljava/lang/String; = "/sys/devices/platform/dmr009/debug"

.field private static final DMR009_PTT:Ljava/lang/String; = "/sys/devices/platform/dmr009/ptt"

.field private static final DMR009_PWD:Ljava/lang/String; = "/sys/devices/platform/dmr009/pwd"

.field private static final TAG:Ljava/lang/String; = "ReadFileUtils"

.field private static volatile instance:Lcom/pri/prizeinterphone/Util/ReadFileUtils;


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;
    .locals 2

    .line 27
    sget-object v0, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->instance:Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    if-nez v0, :cond_1

    .line 28
    const-class v0, Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    monitor-enter v0

    .line 29
    :try_start_0
    sget-object v1, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->instance:Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    if-nez v1, :cond_0

    .line 30
    new-instance v1, Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    invoke-direct {v1}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;-><init>()V

    sput-object v1, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->instance:Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    .line 32
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 34
    :cond_1
    :goto_0
    sget-object v0, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->instance:Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    return-object v0
.end method

.method private readFilePtt()Ljava/lang/String;
    .locals 2

    const-string v0, "/sys/devices/platform/dmr009/ptt"

    const/4 v1, 0x0

    .line 87
    invoke-virtual {p0, v0, v1}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->readFile(Ljava/lang/String;Z)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private readFilePwd()Ljava/lang/String;
    .locals 2

    const-string v0, "/sys/devices/platform/dmr009/pwd"

    const/4 v1, 0x0

    .line 79
    invoke-virtual {p0, v0, v1}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->readFile(Ljava/lang/String;Z)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private writeFilePtt(Ljava/lang/String;)Z
    .locals 1

    const-string v0, "/sys/devices/platform/dmr009/ptt"

    .line 91
    invoke-virtual {p0, v0, p1}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->writeFileData(Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private writeFilePwd(Ljava/lang/String;)Z
    .locals 1

    const-string v0, "/sys/devices/platform/dmr009/pwd"

    .line 83
    invoke-virtual {p0, v0, p1}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->writeFileData(Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method


# virtual methods
.method public pullDownPttFoot()V
    .locals 2

    const-string v0, "ReadFileUtils"

    const-string v1, "pullDownPttFoot"

    .line 128
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 129
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object v0

    invoke-direct {v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->readFilePtt()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ptt :1"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "0"

    .line 130
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->writeFilePtt(Ljava/lang/String;)Z

    :cond_0
    return-void
.end method

.method public pullDownPwdFoot()V
    .locals 2

    const-string v0, "ReadFileUtils"

    const-string v1, "pullDownPwdFoot"

    .line 108
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 109
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object v0

    invoke-direct {v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->readFilePwd()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const-string v1, "pwd :1"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "0"

    .line 110
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->writeFilePwd(Ljava/lang/String;)Z

    :cond_0
    return-void
.end method

.method public pullUpPttFoot()V
    .locals 2

    const-string v0, "ReadFileUtils"

    const-string v1, "pullUpPttFoot"

    .line 118
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 119
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object v0

    invoke-direct {v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->readFilePtt()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ptt :0"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "1"

    .line 120
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->writeFilePtt(Ljava/lang/String;)Z

    :cond_0
    return-void
.end method

.method public pullUpPwdFoot()V
    .locals 2

    const-string v0, "ReadFileUtils"

    const-string v1, "pullUpPwdFoot"

    .line 98
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 99
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object v0

    invoke-direct {v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->readFilePwd()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const-string v1, "pwd :0"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "1"

    .line 100
    invoke-direct {p0, v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->writeFilePwd(Ljava/lang/String;)Z

    :cond_0
    return-void
.end method

.method public readFile()Ljava/lang/String;
    .locals 2

    const-string v0, "/sys/devices/platform/dmr009/debug"

    const/4 v1, 0x0

    .line 38
    invoke-virtual {p0, v0, v1}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->readFile(Ljava/lang/String;Z)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public readFile(Ljava/lang/String;Z)Ljava/lang/String;
    .locals 2

    .line 48
    :try_start_0
    new-instance p0, Ljava/io/BufferedReader;

    new-instance v0, Ljava/io/FileReader;

    new-instance v1, Ljava/io/File;

    invoke-direct {v1, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {p0, v0}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz p2, :cond_0

    .line 51
    :try_start_1
    invoke-virtual {p0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 58
    :try_start_2
    invoke-virtual {p0}, Ljava/io/BufferedReader;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    return-object p1

    .line 53
    :cond_0
    :try_start_3
    invoke-virtual {p0}, Ljava/io/BufferedReader;->lines()Ljava/util/stream/Stream;

    move-result-object p1

    .line 54
    new-instance p2, Ljava/util/StringJoiner;

    const-string v0, "\n"

    invoke-direct {p2, v0}, Ljava/util/StringJoiner;-><init>(Ljava/lang/CharSequence;)V

    .line 55
    new-instance v0, Lcom/pri/prizeinterphone/Util/ReadFileUtils$$ExternalSyntheticLambda0;

    invoke-direct {v0, p2}, Lcom/pri/prizeinterphone/Util/ReadFileUtils$$ExternalSyntheticLambda0;-><init>(Ljava/util/StringJoiner;)V

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 56
    invoke-virtual {p2}, Ljava/util/StringJoiner;->toString()Ljava/lang/String;

    move-result-object p1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 58
    :try_start_4
    invoke-virtual {p0}, Ljava/io/BufferedReader;->close()V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    return-object p1

    :catchall_0
    move-exception p1

    .line 48
    :try_start_5
    invoke-virtual {p0}, Ljava/io/BufferedReader;->close()V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    goto :goto_0

    :catchall_1
    move-exception p0

    :try_start_6
    invoke-virtual {p1, p0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_0
    throw p1
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_0

    :catch_0
    move-exception p0

    .line 59
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    const-string p0, "0"

    return-object p0
.end method

.method public readFileDate()Ljava/lang/String;
    .locals 1

    .line 67
    :try_start_0
    new-instance p0, Ljava/io/FileInputStream;

    const-string v0, "/sys/devices/platform/dmr009/debug"

    invoke-direct {p0, v0}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    const/4 v0, 0x4

    new-array v0, v0, [B

    .line 69
    invoke-virtual {p0, v0}, Ljava/io/FileInputStream;->read([B)I

    .line 70
    new-instance p0, Ljava/lang/String;

    invoke-direct {p0, v0}, Ljava/lang/String;-><init>([B)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 73
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    const-string p0, "0"

    :goto_0
    return-object p0
.end method

.method public setDmrUpdateCondition()V
    .locals 2

    const-string v0, "ReadFileUtils"

    const-string v1, "setDmrUpdateCondition"

    .line 135
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 137
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->pullDownPwdFoot()V

    const-wide/16 v0, 0x32

    .line 140
    :try_start_0
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_2

    .line 145
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->pullDownPttFoot()V

    .line 148
    :try_start_1
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_1
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_1

    .line 153
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->pullUpPwdFoot()V

    const-wide/16 v0, 0x3e8

    .line 156
    :try_start_2
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_2
    .catch Ljava/lang/InterruptedException; {:try_start_2 .. :try_end_2} :catch_0

    .line 161
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->pullUpPttFoot()V

    return-void

    :catch_0
    move-exception p0

    .line 158
    new-instance v0, Ljava/lang/RuntimeException;

    invoke-direct {v0, p0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v0

    :catch_1
    move-exception p0

    .line 150
    new-instance v0, Ljava/lang/RuntimeException;

    invoke-direct {v0, p0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v0

    :catch_2
    move-exception p0

    .line 142
    new-instance v0, Ljava/lang/RuntimeException;

    invoke-direct {v0, p0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/Throwable;)V

    throw v0
.end method

.method public writeFileData(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 3

    const-string/jumbo p0, "writeFileData write "

    const-string v0, "ReadFileUtils"

    .line 167
    :try_start_0
    new-instance v1, Ljava/io/BufferedWriter;

    new-instance v2, Ljava/io/FileWriter;

    invoke-direct {v2, p1}, Ljava/io/FileWriter;-><init>(Ljava/lang/String;)V

    invoke-direct {v1, v2}, Ljava/io/BufferedWriter;-><init>(Ljava/io/Writer;)V

    .line 168
    invoke-virtual {v1, p2}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 169
    invoke-virtual {v1}, Ljava/io/BufferedWriter;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 175
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " ok"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0

    :catch_0
    move-exception p1

    .line 171
    invoke-virtual {p1}, Ljava/io/IOException;->printStackTrace()V

    .line 172
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " failed!"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return p0
.end method
