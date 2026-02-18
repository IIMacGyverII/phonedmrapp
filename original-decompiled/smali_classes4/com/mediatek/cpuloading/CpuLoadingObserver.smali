.class public Lcom/mediatek/cpuloading/CpuLoadingObserver;
.super Ljava/lang/Object;
.source "CpuLoadingObserver.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;,
        Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;
    }
.end annotation


# static fields
.field private static final BACKGROUND_CPUS_PATH:Ljava/lang/String; = "/dev/cpuset/background/cpus"

.field private static DEFAULT_SPECIFY_THRESHOLD:I = 0x55

.field private static DEFAULT_THRESHOLD:I = 0x55

.field private static DEFAULT_WINDOW:I = 0xa

.field private static final OVER_THRESHOLD:Ljava/lang/String; = "/proc/cpu_loading/overThrhld"

.field private static final POLLING_ON_OFF:Ljava/lang/String; = "/proc/cpu_loading/onoff"

.field private static final POLLING_TIME_SECOND:Ljava/lang/String; = "/proc/cpu_loading/poltime_secs"

.field private static final SPECIFY_32BIT_CPUS_PATH:Ljava/lang/String; = "sys/devices/system/cpu/aarch32_el0"

.field private static final SPECIFY_CPUS:Ljava/lang/String; = "/proc/cpu_loading/specify_cpus"

.field private static final SPECIFY_OVER_THRESHOLD:Ljava/lang/String; = "/proc/cpu_loading/specify_overThrhld"

.field private static SPECIFY_RELEASE_TARGET:I = 0xf

.field private static final TAG:Ljava/lang/String; = "CpuLoadingObserver"

.field private static final UEVENT_PATH:Ljava/lang/String; = "DEVPATH=/devices/virtual/misc/cpu_loading"


# instance fields
.field private mObserver:Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;

.field private mSpecifyCpus:Ljava/lang/String;

.field private mSpecifyThreshold:I

.field private mThreshold:I

.field private mUEventObserver:Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;

.field private mWindow:I


# direct methods
.method static bridge synthetic -$$Nest$fgetmObserver(Lcom/mediatek/cpuloading/CpuLoadingObserver;)Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mObserver:Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$sfgetSPECIFY_RELEASE_TARGET()I
    .locals 1

    sget v0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->SPECIFY_RELEASE_TARGET:I

    return v0
.end method

.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 90
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 78
    sget v0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->DEFAULT_THRESHOLD:I

    iput v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mThreshold:I

    .line 79
    sget v0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->DEFAULT_WINDOW:I

    iput v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mWindow:I

    .line 80
    sget v0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->DEFAULT_SPECIFY_THRESHOLD:I

    iput v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mSpecifyThreshold:I

    const-string v0, ""

    .line 81
    iput-object v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mSpecifyCpus:Ljava/lang/String;

    .line 91
    new-instance v0, Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;-><init>(Lcom/mediatek/cpuloading/CpuLoadingObserver;Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver-IA;)V

    iput-object v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mUEventObserver:Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;

    .line 92
    invoke-direct {p0}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->readSpecifyCpus()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mSpecifyCpus:Ljava/lang/String;

    return-void
.end method

.method private readFile(Ljava/lang/String;)Ljava/lang/String;
    .locals 5

    const-string p0, ""

    if-nez p1, :cond_0

    return-object p0

    .line 179
    :cond_0
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    const/4 p1, 0x0

    .line 183
    :try_start_0
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, v0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 184
    :try_start_1
    new-instance p1, Ljava/io/InputStreamReader;

    const-string v0, "UTF-8"

    invoke-direct {p1, v1, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    .line 185
    new-instance v0, Ljava/io/StringWriter;

    invoke-direct {v0}, Ljava/io/StringWriter;-><init>()V

    const/16 v2, 0x400

    new-array v2, v2, [C

    :goto_0
    const/4 v3, -0x1

    .line 189
    invoke-virtual {p1, v2}, Ljava/io/InputStreamReader;->read([C)I

    move-result v4

    if-eq v3, v4, :cond_1

    const/4 v3, 0x0

    .line 190
    invoke-virtual {v0, v2, v3, v4}, Ljava/io/StringWriter;->write([CII)V

    goto :goto_0

    .line 193
    :cond_1
    invoke-virtual {v0}, Ljava/io/StringWriter;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 199
    :try_start_2
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_1

    :catch_0
    move-exception p1

    .line 201
    invoke-virtual {p1}, Ljava/io/IOException;->printStackTrace()V

    :goto_1
    return-object p0

    :catch_1
    move-exception p1

    goto :goto_2

    :catchall_0
    move-exception p0

    goto :goto_4

    :catch_2
    move-exception v0

    move-object v1, p1

    move-object p1, v0

    .line 195
    :goto_2
    :try_start_3
    invoke-virtual {p1}, Ljava/io/IOException;->printStackTrace()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    if-eqz v1, :cond_2

    .line 199
    :try_start_4
    invoke-virtual {v1}, Ljava/io/FileInputStream;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_3

    goto :goto_3

    :catch_3
    move-exception p1

    .line 201
    invoke-virtual {p1}, Ljava/io/IOException;->printStackTrace()V

    :cond_2
    :goto_3
    return-object p0

    :catchall_1
    move-exception p0

    move-object p1, v1

    :goto_4
    if-eqz p1, :cond_3

    .line 199
    :try_start_5
    invoke-virtual {p1}, Ljava/io/FileInputStream;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_4

    goto :goto_5

    :catch_4
    move-exception p1

    .line 201
    invoke-virtual {p1}, Ljava/io/IOException;->printStackTrace()V

    .line 204
    :cond_3
    :goto_5
    throw p0
.end method

.method private readSpecifyCpus()Ljava/lang/String;
    .locals 3

    const-string/jumbo v0, "sys/devices/system/cpu/aarch32_el0"

    .line 120
    invoke-direct {p0, v0}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->readFile(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, ""

    .line 121
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    const-string v0, "/dev/cpuset/background/cpus"

    .line 122
    invoke-direct {p0, v0}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->readFile(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 125
    :cond_0
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_2

    const-string p0, "-"

    .line 126
    invoke-virtual {v0, p0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 127
    array-length v1, p0

    const/4 v2, 0x2

    if-ne v1, v2, :cond_1

    .line 128
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v1, 0x1

    aget-object v1, p0, v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v1, 0x0

    aget-object p0, p0, v1

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_1
    return-object v0

    :cond_2
    return-object v1
.end method

.method private writeFile(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    if-nez p1, :cond_0

    return-void

    .line 150
    :cond_0
    new-instance p0, Ljava/io/File;

    invoke-direct {p0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    const/4 p1, 0x0

    .line 153
    invoke-static {}, Landroid/os/StrictMode;->allowThreadDiskReads()Landroid/os/StrictMode$ThreadPolicy;

    move-result-object v0

    .line 154
    invoke-static {}, Landroid/os/StrictMode;->allowThreadDiskWrites()Landroid/os/StrictMode$ThreadPolicy;

    .line 157
    :try_start_0
    new-instance v1, Ljava/io/FileOutputStream;

    invoke-direct {v1, p0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 158
    :try_start_1
    invoke-virtual {p2}, Ljava/lang/String;->getBytes()[B

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/io/FileOutputStream;->write([B)V

    .line 159
    invoke-virtual {v1}, Ljava/io/FileOutputStream;->flush()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 165
    :try_start_2
    invoke-virtual {v1}, Ljava/io/FileOutputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0

    goto :goto_2

    :catch_0
    move-exception p0

    goto :goto_1

    :catchall_0
    move-exception p0

    move-object p1, v1

    goto :goto_3

    :catch_1
    move-exception p0

    move-object p1, v1

    goto :goto_0

    :catchall_1
    move-exception p0

    goto :goto_3

    :catch_2
    move-exception p0

    .line 161
    :goto_0
    :try_start_3
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    if-eqz p1, :cond_1

    .line 165
    :try_start_4
    invoke-virtual {p1}, Ljava/io/FileOutputStream;->close()V
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_3

    goto :goto_2

    :catch_3
    move-exception p0

    .line 167
    :goto_1
    invoke-virtual {p0}, Ljava/io/IOException;->printStackTrace()V

    .line 170
    :cond_1
    :goto_2
    invoke-static {v0}, Landroid/os/StrictMode;->setThreadPolicy(Landroid/os/StrictMode$ThreadPolicy;)V

    return-void

    :goto_3
    if-eqz p1, :cond_2

    .line 165
    :try_start_5
    invoke-virtual {p1}, Ljava/io/FileOutputStream;->close()V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_5} :catch_4

    goto :goto_4

    :catch_4
    move-exception p1

    .line 167
    invoke-virtual {p1}, Ljava/io/IOException;->printStackTrace()V

    .line 170
    :cond_2
    :goto_4
    invoke-static {v0}, Landroid/os/StrictMode;->setThreadPolicy(Landroid/os/StrictMode$ThreadPolicy;)V

    .line 171
    throw p0
.end method


# virtual methods
.method public setObserver(Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;)V
    .locals 0

    .line 101
    iput-object p1, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mObserver:Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;

    return-void
.end method

.method public startObserving()V
    .locals 2

    const-string v0, "/proc/cpu_loading/onoff"

    const-string v1, "1"

    .line 108
    invoke-direct {p0, v0, v1}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->writeFile(Ljava/lang/String;Ljava/lang/String;)V

    .line 109
    iget v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mThreshold:I

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "/proc/cpu_loading/overThrhld"

    invoke-direct {p0, v1, v0}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->writeFile(Ljava/lang/String;Ljava/lang/String;)V

    .line 110
    iget v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mWindow:I

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "/proc/cpu_loading/poltime_secs"

    invoke-direct {p0, v1, v0}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->writeFile(Ljava/lang/String;Ljava/lang/String;)V

    .line 112
    iget-object v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mSpecifyCpus:Ljava/lang/String;

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 113
    iget-object v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mSpecifyCpus:Ljava/lang/String;

    const-string v1, "/proc/cpu_loading/specify_cpus"

    invoke-direct {p0, v1, v0}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->writeFile(Ljava/lang/String;Ljava/lang/String;)V

    .line 114
    iget v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mSpecifyThreshold:I

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    const-string v1, "/proc/cpu_loading/specify_overThrhld"

    invoke-direct {p0, v1, v0}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->writeFile(Ljava/lang/String;Ljava/lang/String;)V

    .line 116
    :cond_0
    iget-object p0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mUEventObserver:Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;

    const-string v0, "DEVPATH=/devices/virtual/misc/cpu_loading"

    invoke-virtual {p0, v0}, Landroid/os/UEventObserver;->startObserving(Ljava/lang/String;)V

    return-void
.end method

.method public stopObserving()V
    .locals 2

    const-string v0, "/proc/cpu_loading/onoff"

    const-string v1, "0"

    .line 140
    invoke-direct {p0, v0, v1}, Lcom/mediatek/cpuloading/CpuLoadingObserver;->writeFile(Ljava/lang/String;Ljava/lang/String;)V

    .line 141
    iget-object v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mUEventObserver:Lcom/mediatek/cpuloading/CpuLoadingObserver$MyUEventObserver;

    invoke-virtual {v0}, Landroid/os/UEventObserver;->stopObserving()V

    const/4 v0, 0x0

    .line 142
    iput-object v0, p0, Lcom/mediatek/cpuloading/CpuLoadingObserver;->mObserver:Lcom/mediatek/cpuloading/CpuLoadingObserver$Observer;

    return-void
.end method
