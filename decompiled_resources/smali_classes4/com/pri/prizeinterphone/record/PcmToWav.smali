.class public Lcom/pri/prizeinterphone/record/PcmToWav;
.super Ljava/lang/Object;
.source "PcmToWav.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static clearFiles(Ljava/util/List;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    const/4 v0, 0x0

    .line 189
    :goto_0
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 190
    new-instance v1, Ljava/io/File;

    invoke-interface {p0, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 191
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 192
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method

.method public static makePCMFileToWAVFile(Ljava/lang/String;Ljava/lang/String;Z)Z
    .locals 8

    const-string v0, "PcmToWav"

    .line 116
    new-instance v1, Ljava/io/File;

    invoke-direct {v1, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 117
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result p0

    const/4 v2, 0x0

    if-nez p0, :cond_0

    return v2

    .line 120
    :cond_0
    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v3

    long-to-int p0, v3

    .line 122
    new-instance v3, Lcom/pri/prizeinterphone/record/WaveHeader;

    invoke-direct {v3}, Lcom/pri/prizeinterphone/record/WaveHeader;-><init>()V

    add-int/lit8 v4, p0, 0x24

    .line 125
    iput v4, v3, Lcom/pri/prizeinterphone/record/WaveHeader;->fileLength:I

    const/16 v4, 0x10

    .line 126
    iput v4, v3, Lcom/pri/prizeinterphone/record/WaveHeader;->FmtHdrLeth:I

    .line 127
    iput-short v4, v3, Lcom/pri/prizeinterphone/record/WaveHeader;->BitsPerSample:S

    const/4 v5, 0x2

    .line 128
    iput-short v5, v3, Lcom/pri/prizeinterphone/record/WaveHeader;->Channels:S

    const/4 v6, 0x1

    .line 129
    iput-short v6, v3, Lcom/pri/prizeinterphone/record/WaveHeader;->FormatTag:S

    const/16 v7, 0x1f40

    .line 130
    iput v7, v3, Lcom/pri/prizeinterphone/record/WaveHeader;->SamplesPerSec:I

    mul-int/2addr v5, v4

    .line 131
    div-int/lit8 v5, v5, 0x8

    int-to-short v4, v5

    iput-short v4, v3, Lcom/pri/prizeinterphone/record/WaveHeader;->BlockAlign:S

    mul-int/2addr v4, v7

    .line 132
    iput v4, v3, Lcom/pri/prizeinterphone/record/WaveHeader;->AvgBytesPerSec:I

    .line 133
    iput p0, v3, Lcom/pri/prizeinterphone/record/WaveHeader;->DataHdrLeth:I

    .line 137
    :try_start_0
    invoke-virtual {v3}, Lcom/pri/prizeinterphone/record/WaveHeader;->getHeader()[B

    move-result-object p0
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2

    .line 143
    array-length v3, p0

    const/16 v4, 0x2c

    if-eq v3, v4, :cond_1

    return v2

    .line 147
    :cond_1
    new-instance v3, Ljava/io/File;

    invoke-direct {v3, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 148
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v4

    if-eqz v4, :cond_2

    .line 149
    invoke-virtual {v3}, Ljava/io/File;->delete()Z

    :cond_2
    const/16 v3, 0x1000

    :try_start_1
    new-array v3, v3, [B

    .line 157
    new-instance v4, Ljava/io/BufferedOutputStream;

    new-instance v5, Ljava/io/FileOutputStream;

    invoke-direct {v5, p1}, Ljava/io/FileOutputStream;-><init>(Ljava/lang/String;)V

    invoke-direct {v4, v5}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 159
    array-length p1, p0

    invoke-virtual {v4, p0, v2, p1}, Ljava/io/OutputStream;->write([BII)V

    .line 160
    new-instance p0, Ljava/io/BufferedInputStream;

    new-instance p1, Ljava/io/FileInputStream;

    invoke-direct {p1, v1}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    invoke-direct {p0, p1}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    .line 161
    invoke-virtual {p0, v3}, Ljava/io/InputStream;->read([B)I

    move-result p1

    :goto_0
    const/4 v5, -0x1

    if-eq p1, v5, :cond_3

    .line 163
    invoke-virtual {v4, v3}, Ljava/io/OutputStream;->write([B)V

    .line 164
    invoke-virtual {p0, v3}, Ljava/io/InputStream;->read([B)I

    move-result p1

    goto :goto_0

    .line 166
    :cond_3
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    .line 167
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V
    :try_end_1
    .catch Ljava/io/FileNotFoundException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    if-eqz p2, :cond_4

    .line 176
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 178
    :cond_4
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "makePCMFileToWAVFile  success!"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance p1, Ljava/text/SimpleDateFormat;

    const-string/jumbo p2, "yyyy-MM-dd hh:mm"

    invoke-direct {p1, p2}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    new-instance p2, Ljava/util/Date;

    invoke-direct {p2}, Ljava/util/Date;-><init>()V

    invoke-virtual {p1, p2}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return v6

    :catch_0
    move-exception p0

    .line 172
    invoke-virtual {p0}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    :catch_1
    move-exception p0

    .line 169
    invoke-virtual {p0}, Ljava/io/FileNotFoundException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    :catch_2
    move-exception p0

    .line 139
    invoke-virtual {p0}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v2
.end method

.method public static mergePCMFilesToWAVFile(Ljava/util/List;Ljava/lang/String;)Z
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")Z"
        }
    .end annotation

    const-string v0, "PcmToWav"

    .line 32
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v1

    new-array v1, v1, [Ljava/io/File;

    .line 36
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v2

    const/4 v3, 0x0

    move v4, v3

    move v5, v4

    :goto_0
    if-ge v4, v2, :cond_0

    .line 39
    new-instance v6, Ljava/io/File;

    invoke-interface {p0, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/String;

    invoke-direct {v6, v7}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    aput-object v6, v1, v4

    int-to-long v7, v5

    .line 40
    invoke-virtual {v6}, Ljava/io/File;->length()J

    move-result-wide v5

    add-long/2addr v7, v5

    long-to-int v5, v7

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 44
    :cond_0
    new-instance v4, Lcom/pri/prizeinterphone/record/WaveHeader;

    invoke-direct {v4}, Lcom/pri/prizeinterphone/record/WaveHeader;-><init>()V

    add-int/lit8 v6, v5, 0x24

    .line 47
    iput v6, v4, Lcom/pri/prizeinterphone/record/WaveHeader;->fileLength:I

    const/16 v6, 0x10

    .line 48
    iput v6, v4, Lcom/pri/prizeinterphone/record/WaveHeader;->FmtHdrLeth:I

    .line 49
    iput-short v6, v4, Lcom/pri/prizeinterphone/record/WaveHeader;->BitsPerSample:S

    const/4 v7, 0x2

    .line 50
    iput-short v7, v4, Lcom/pri/prizeinterphone/record/WaveHeader;->Channels:S

    const/4 v8, 0x1

    .line 51
    iput-short v8, v4, Lcom/pri/prizeinterphone/record/WaveHeader;->FormatTag:S

    const/16 v9, 0x1f40

    .line 52
    iput v9, v4, Lcom/pri/prizeinterphone/record/WaveHeader;->SamplesPerSec:I

    mul-int/2addr v7, v6

    .line 53
    div-int/lit8 v7, v7, 0x8

    int-to-short v6, v7

    iput-short v6, v4, Lcom/pri/prizeinterphone/record/WaveHeader;->BlockAlign:S

    mul-int/2addr v6, v9

    .line 54
    iput v6, v4, Lcom/pri/prizeinterphone/record/WaveHeader;->AvgBytesPerSec:I

    .line 55
    iput v5, v4, Lcom/pri/prizeinterphone/record/WaveHeader;->DataHdrLeth:I

    .line 59
    :try_start_0
    invoke-virtual {v4}, Lcom/pri/prizeinterphone/record/WaveHeader;->getHeader()[B

    move-result-object v4
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2

    .line 65
    array-length v5, v4

    const/16 v6, 0x2c

    if-eq v5, v6, :cond_1

    return v3

    .line 69
    :cond_1
    new-instance v5, Ljava/io/File;

    invoke-direct {v5, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 70
    invoke-virtual {v5}, Ljava/io/File;->exists()Z

    move-result v6

    if-eqz v6, :cond_2

    .line 71
    invoke-virtual {v5}, Ljava/io/File;->delete()Z

    :cond_2
    const/16 v5, 0x1000

    :try_start_1
    new-array v5, v5, [B

    .line 79
    new-instance v6, Ljava/io/BufferedOutputStream;

    new-instance v7, Ljava/io/FileOutputStream;

    invoke-direct {v7, p1}, Ljava/io/FileOutputStream;-><init>(Ljava/lang/String;)V

    invoke-direct {v6, v7}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 81
    array-length p1, v4

    invoke-virtual {v6, v4, v3, p1}, Ljava/io/OutputStream;->write([BII)V

    move p1, v3

    :goto_1
    if-ge p1, v2, :cond_4

    .line 83
    new-instance v4, Ljava/io/BufferedInputStream;

    new-instance v7, Ljava/io/FileInputStream;

    aget-object v9, v1, p1

    invoke-direct {v7, v9}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v4, v7}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    .line 84
    invoke-virtual {v4, v5}, Ljava/io/InputStream;->read([B)I

    move-result v7

    :goto_2
    const/4 v9, -0x1

    if-eq v7, v9, :cond_3

    .line 86
    invoke-virtual {v6, v5}, Ljava/io/OutputStream;->write([B)V

    .line 87
    invoke-virtual {v4, v5}, Ljava/io/InputStream;->read([B)I

    move-result v7

    goto :goto_2

    .line 89
    :cond_3
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    add-int/lit8 p1, p1, 0x1

    goto :goto_1

    .line 91
    :cond_4
    invoke-virtual {v6}, Ljava/io/OutputStream;->close()V
    :try_end_1
    .catch Ljava/io/FileNotFoundException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 99
    invoke-static {p0}, Lcom/pri/prizeinterphone/record/PcmToWav;->clearFiles(Ljava/util/List;)V

    .line 100
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "mergePCMFilesToWAVFile  success!"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance p1, Ljava/text/SimpleDateFormat;

    const-string/jumbo v1, "yyyy-MM-dd hh:mm"

    invoke-direct {p1, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    new-instance v1, Ljava/util/Date;

    invoke-direct {v1}, Ljava/util/Date;-><init>()V

    invoke-virtual {p1, v1}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return v8

    :catch_0
    move-exception p0

    .line 96
    invoke-virtual {p0}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v3

    :catch_1
    move-exception p0

    .line 93
    invoke-virtual {p0}, Ljava/io/FileNotFoundException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v3

    :catch_2
    move-exception p0

    .line 61
    invoke-virtual {p0}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v3
.end method
