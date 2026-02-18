.class public Lcom/pri/prizeinterphone/ymodem/YModemManager;
.super Ljava/lang/Object;
.source "YModemManager.java"


# static fields
.field private static final CUR_ASSETS_NAME:Ljava/lang/String;

.field private static final CUR_ASSETS_PATH:Ljava/lang/String;

.field private static final EXTERNAL_FILE_PATH:Ljava/lang/String;

.field private static final EXTERNAL_PATH_NAME:Ljava/lang/String; = "/sdcard/DMR/DMRDEBUG.bin"

.field public static final TAG:Ljava/lang/String; = "YModemManager"

.field private static volatile instance:Lcom/pri/prizeinterphone/ymodem/YModemManager;

.field private static mCanSendClientWhenOnDataReadySet:Landroidx/collection/ArraySet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroidx/collection/ArraySet<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private mClientMessengers:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Landroid/os/Messenger;",
            ">;"
        }
    .end annotation
.end field

.field private mContext:Landroid/content/Context;

.field private mYModem:Lcom/pri/prizeinterphone/ymodem/YModem;

.field private mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;


# direct methods
.method static bridge synthetic -$$Nest$fgetmClientMessengers(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Ljava/util/Set;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mClientMessengers:Ljava/util/Set;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmYModemThread(Lcom/pri/prizeinterphone/ymodem/YModemManager;)Lcom/pri/prizeinterphone/ymodem/YModemThread;
    .locals 0

    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mnotifyUpdate2Notification(Lcom/pri/prizeinterphone/ymodem/YModemManager;II)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->notifyUpdate2Notification(II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$sfgetmCanSendClientWhenOnDataReadySet()Landroidx/collection/ArraySet;
    .locals 1

    sget-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mCanSendClientWhenOnDataReadySet:Landroidx/collection/ArraySet;

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 33
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getVersionFromRes()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->CUR_ASSETS_NAME:Ljava/lang/String;

    .line 34
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v2, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->ASSETS:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->getUriPrefix()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->CUR_ASSETS_PATH:Ljava/lang/String;

    .line 38
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v1, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->FILE:Lcom/pri/prizeinterphone/ymodem/SourceScheme;

    invoke-virtual {v1}, Lcom/pri/prizeinterphone/ymodem/SourceScheme;->getUriPrefix()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/sdcard/DMR/DMRDEBUG.bin"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->EXTERNAL_FILE_PATH:Ljava/lang/String;

    .line 40
    new-instance v0, Landroidx/collection/ArraySet;

    invoke-direct {v0}, Landroidx/collection/ArraySet;-><init>()V

    sput-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mCanSendClientWhenOnDataReadySet:Landroidx/collection/ArraySet;

    const/4 v1, 0x2

    .line 43
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroidx/collection/ArraySet;->add(Ljava/lang/Object;)Z

    .line 44
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mCanSendClientWhenOnDataReadySet:Landroidx/collection/ArraySet;

    const/4 v1, 0x4

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroidx/collection/ArraySet;->add(Ljava/lang/Object;)Z

    .line 45
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mCanSendClientWhenOnDataReadySet:Landroidx/collection/ArraySet;

    const/16 v1, 0x10

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroidx/collection/ArraySet;->add(Ljava/lang/Object;)Z

    .line 46
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mCanSendClientWhenOnDataReadySet:Landroidx/collection/ArraySet;

    const/16 v1, 0x20

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroidx/collection/ArraySet;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 70
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 49
    new-instance v0, Landroidx/collection/ArraySet;

    invoke-direct {v0}, Landroidx/collection/ArraySet;-><init>()V

    invoke-static {v0}, Ljava/util/Collections;->synchronizedSet(Ljava/util/Set;)Ljava/util/Set;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mClientMessengers:Ljava/util/Set;

    .line 71
    iput-object p1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mContext:Landroid/content/Context;

    return-void
.end method

.method private getDmrFirmwareName()Ljava/lang/String;
    .locals 2

    .line 87
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->isExternalSdcardHaveFirmware()Z

    move-result p0

    if-eqz p0, :cond_0

    const-string p0, "/sdcard/DMR/DMRDEBUG.bin"

    goto :goto_0

    .line 90
    :cond_0
    sget-object p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->CUR_ASSETS_NAME:Ljava/lang/String;

    .line 92
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getDmrFirmwarePath,name="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "YModemManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object p0
.end method

.method private getDmrFirmwarePath()Ljava/lang/String;
    .locals 2

    .line 76
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->isExternalSdcardHaveFirmware()Z

    move-result p0

    if-eqz p0, :cond_0

    .line 77
    sget-object p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->EXTERNAL_FILE_PATH:Ljava/lang/String;

    goto :goto_0

    .line 79
    :cond_0
    sget-object p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->CUR_ASSETS_PATH:Ljava/lang/String;

    .line 81
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getDmrFirmwarePath,path="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "YModemManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object p0
.end method

.method public static getInstance()Lcom/pri/prizeinterphone/ymodem/YModemManager;
    .locals 3

    .line 60
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->instance:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    if-nez v0, :cond_1

    .line 61
    const-class v0, Lcom/pri/prizeinterphone/serial/SerialManager;

    monitor-enter v0

    .line 62
    :try_start_0
    sget-object v1, Lcom/pri/prizeinterphone/ymodem/YModemManager;->instance:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    if-nez v1, :cond_0

    .line 63
    new-instance v1, Lcom/pri/prizeinterphone/ymodem/YModemManager;

    invoke-static {}, Lcom/pri/prizeinterphone/PrizeInterPhoneApp;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-direct {v1, v2}, Lcom/pri/prizeinterphone/ymodem/YModemManager;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/pri/prizeinterphone/ymodem/YModemManager;->instance:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    .line 65
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 67
    :cond_1
    :goto_0
    sget-object v0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->instance:Lcom/pri/prizeinterphone/ymodem/YModemManager;

    return-object v0
.end method

.method private notifyUpdate2Notification(II)V
    .locals 0

    .line 243
    invoke-static {}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->getInstance()Lcom/pri/prizeinterphone/notification/MyNotificationManager;

    move-result-object p0

    invoke-virtual {p0, p1, p2}, Lcom/pri/prizeinterphone/notification/MyNotificationManager;->notifyUpdate2Notification(II)V

    return-void
.end method


# virtual methods
.method public isExternalSdcardHaveFirmware()Z
    .locals 1

    .line 98
    new-instance p0, Ljava/io/File;

    const-string v0, "/sdcard/DMR/DMRDEBUG.bin"

    invoke-direct {p0, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result p0

    return p0
.end method

.method public isNeedUpdateDmr()Z
    .locals 4

    .line 289
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object p0

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getVersionNumberFromModule()I

    move-result p0

    .line 290
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isNeedUpdateDmr,versionNumberFromModule="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "YModemManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 291
    invoke-static {}, Lcom/pri/prizeinterphone/manager/DmrManager;->getInstance()Lcom/pri/prizeinterphone/manager/DmrManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/manager/DmrManager;->getVersionNumberFromRes()I

    move-result v0

    .line 292
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "isNeedUpdateDmr,versionNumberFromRes="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-le v0, p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public isRunning()Z
    .locals 0

    .line 236
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    if-eqz p0, :cond_0

    .line 237
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->isStop()Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public registerCallbackMessenger(Landroid/os/Messenger;)V
    .locals 0

    .line 52
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mClientMessengers:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public releaseYModem()V
    .locals 2

    .line 247
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 248
    invoke-virtual {v0, v1}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->setYModem(Lcom/pri/prizeinterphone/ymodem/YModem;)V

    .line 249
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->stopRead()V

    .line 250
    iput-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    .line 252
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModem:Lcom/pri/prizeinterphone/ymodem/YModem;

    if-eqz v0, :cond_1

    .line 253
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/YModem;->stop()V

    .line 254
    iput-object v1, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModem:Lcom/pri/prizeinterphone/ymodem/YModem;

    .line 256
    :cond_1
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mClientMessengers:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    .line 257
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mClientMessengers:Ljava/util/Set;

    invoke-interface {p0}, Ljava/util/Set;->clear()V

    :cond_2
    return-void
.end method

.method public setSerial(Lcom/pri/prizeinterphone/serial/port/SerialPort;)V
    .locals 0

    .line 102
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    if-eqz p0, :cond_0

    .line 103
    invoke-virtual {p0, p1}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->setSerial(Lcom/pri/prizeinterphone/serial/port/SerialPort;)V

    :cond_0
    return-void
.end method

.method public startUpdateFirmware()V
    .locals 3

    .line 108
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "startUpdateFirmware,"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "YModemManager"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 109
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    if-nez v0, :cond_0

    .line 110
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/YModemThread;

    invoke-static {}, Lcom/pri/prizeinterphone/serial/SerialManager;->getInstance()Lcom/pri/prizeinterphone/serial/SerialManager;

    move-result-object v2

    invoke-virtual {v2}, Lcom/pri/prizeinterphone/serial/SerialManager;->getSerial()Lcom/pri/prizeinterphone/serial/port/SerialPort;

    move-result-object v2

    invoke-direct {v0, v2}, Lcom/pri/prizeinterphone/ymodem/YModemThread;-><init>(Lcom/pri/prizeinterphone/serial/port/SerialPort;)V

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    .line 112
    :cond_0
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModem:Lcom/pri/prizeinterphone/ymodem/YModem;

    if-nez v0, :cond_1

    .line 113
    new-instance v0, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;

    invoke-direct {v0}, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;-><init>()V

    iget-object v2, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mContext:Landroid/content/Context;

    .line 114
    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->with(Landroid/content/Context;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;

    move-result-object v0

    .line 115
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getDmrFirmwarePath()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->filePath(Ljava/lang/String;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;

    move-result-object v0

    .line 116
    invoke-direct {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->getDmrFirmwareName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->fileName(Ljava/lang/String;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;

    move-result-object v0

    const/16 v2, 0x400

    .line 117
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->sendSize(Ljava/lang/Integer;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;

    move-result-object v0

    new-instance v2, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;

    invoke-direct {v2, p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager$1;-><init>(Lcom/pri/prizeinterphone/ymodem/YModemManager;)V

    .line 118
    invoke-virtual {v0, v2}, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->callback(Lcom/pri/prizeinterphone/ymodem/YModemListener;)Lcom/pri/prizeinterphone/ymodem/YModem$Builder;

    move-result-object v0

    .line 221
    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/YModem$Builder;->build()Lcom/pri/prizeinterphone/ymodem/YModem;

    move-result-object v0

    iput-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModem:Lcom/pri/prizeinterphone/ymodem/YModem;

    .line 222
    iget-object v2, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    invoke-virtual {v2, v0}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->setYModem(Lcom/pri/prizeinterphone/ymodem/YModem;)V

    .line 224
    :cond_1
    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModemManager;->isRunning()Z

    move-result v0

    if-nez v0, :cond_2

    .line 225
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "start----------,"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-string v0, "2"

    .line 226
    invoke-static {v0}, Lcom/pri/prizeinterphone/Util/Util;->setDMRUpdateStatusToNvram(Ljava/lang/String;)Z

    .line 227
    invoke-static {}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->getInstance()Lcom/pri/prizeinterphone/Util/ReadFileUtils;

    move-result-object v0

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/Util/ReadFileUtils;->setDmrUpdateCondition()V

    .line 228
    iget-object v0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModemThread:Lcom/pri/prizeinterphone/ymodem/YModemThread;

    invoke-virtual {v0}, Lcom/pri/prizeinterphone/ymodem/YModemThread;->startRead()V

    .line 229
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mYModem:Lcom/pri/prizeinterphone/ymodem/YModem;

    invoke-virtual {p0}, Lcom/pri/prizeinterphone/ymodem/YModem;->start()V

    goto :goto_0

    .line 231
    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "is already start----------,"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public unregisterCallbackMessenger(Landroid/os/Messenger;)V
    .locals 0

    .line 56
    iget-object p0, p0, Lcom/pri/prizeinterphone/ymodem/YModemManager;->mClientMessengers:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    return-void
.end method
