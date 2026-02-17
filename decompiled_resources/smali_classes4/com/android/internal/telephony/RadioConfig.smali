.class public Lcom/android/internal/telephony/RadioConfig;
.super Landroid/os/Handler;
.source "RadioConfig.java"


# static fields
.field private static final DBG:Z = true

.field static final EVENT_AIDL_SERVICE_DEAD:I = 0x2

.field static final EVENT_HIDL_SERVICE_DEAD:I = 0x1

.field protected static final RADIO_CONFIG_HAL_VERSION_1_0:Lcom/android/internal/telephony/HalVersion;

.field protected static final RADIO_CONFIG_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

.field protected static final RADIO_CONFIG_HAL_VERSION_1_3:Lcom/android/internal/telephony/HalVersion;

.field protected static final RADIO_CONFIG_HAL_VERSION_2_0:Lcom/android/internal/telephony/HalVersion;

.field protected static final RADIO_CONFIG_HAL_VERSION_UNKNOWN:Lcom/android/internal/telephony/HalVersion;

.field private static final TAG:Ljava/lang/String; = "RadioConfig"

.field private static final VDBG:Z = false

.field private static sContext:Landroid/content/Context;

.field private static final sLock:Ljava/lang/Object;

.field private static sRadioConfig:Lcom/android/internal/telephony/RadioConfig;


# instance fields
.field private final mDefaultWorkSource:Landroid/os/WorkSource;

.field private final mDeviceNrCapabilities:[I

.field private final mIsMobileNetworkSupported:Z

.field private mMockModem:Lcom/android/internal/telephony/MockModem;

.field protected final mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

.field protected final mRadioConfigProxyCookie:Ljava/util/concurrent/atomic/AtomicLong;

.field private final mRequestList:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/RILRequest;",
            ">;"
        }
    .end annotation
.end field

.field protected mSimSlotStatusRegistrant:Lcom/android/internal/telephony/Registrant;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 63
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/RadioConfig;->sLock:Ljava/lang/Object;

    .line 68
    new-instance v0, Lcom/android/internal/telephony/HalVersion;

    const/4 v1, -0x1

    invoke-direct {v0, v1, v1}, Lcom/android/internal/telephony/HalVersion;-><init>(II)V

    sput-object v0, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_UNKNOWN:Lcom/android/internal/telephony/HalVersion;

    .line 69
    new-instance v0, Lcom/android/internal/telephony/HalVersion;

    const/4 v1, 0x1

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/HalVersion;-><init>(II)V

    sput-object v0, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_0:Lcom/android/internal/telephony/HalVersion;

    .line 70
    new-instance v0, Lcom/android/internal/telephony/HalVersion;

    invoke-direct {v0, v1, v1}, Lcom/android/internal/telephony/HalVersion;-><init>(II)V

    sput-object v0, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    .line 71
    new-instance v0, Lcom/android/internal/telephony/HalVersion;

    const/4 v3, 0x3

    invoke-direct {v0, v1, v3}, Lcom/android/internal/telephony/HalVersion;-><init>(II)V

    sput-object v0, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_3:Lcom/android/internal/telephony/HalVersion;

    .line 72
    new-instance v0, Lcom/android/internal/telephony/HalVersion;

    const/4 v1, 0x2

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/HalVersion;-><init>(II)V

    sput-object v0, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_2_0:Lcom/android/internal/telephony/HalVersion;

    return-void
.end method

.method protected constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/HalVersion;)V
    .locals 3

    .line 93
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 75
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    .line 79
    new-instance v0, Ljava/util/concurrent/atomic/AtomicLong;

    const-wide/16 v1, 0x0

    invoke-direct {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicLong;-><init>(J)V

    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxyCookie:Ljava/util/concurrent/atomic/AtomicLong;

    .line 94
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/RadioConfig;->isMobileDataCapable(Landroid/content/Context;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/RadioConfig;->mIsMobileNetworkSupported:Z

    .line 95
    new-instance v0, Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-direct {v0, p0, p2}, Lcom/android/internal/telephony/RadioConfigProxy;-><init>(Lcom/android/internal/telephony/RadioConfig;Lcom/android/internal/telephony/HalVersion;)V

    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    .line 96
    new-instance p2, Landroid/os/WorkSource;

    invoke-virtual {p1}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v0

    iget v0, v0, Landroid/content/pm/ApplicationInfo;->uid:I

    .line 97
    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p2, v0, v1}, Landroid/os/WorkSource;-><init>(ILjava/lang/String;)V

    iput-object p2, p0, Lcom/android/internal/telephony/RadioConfig;->mDefaultWorkSource:Landroid/os/WorkSource;

    .line 99
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p2

    const v0, 0x11101da

    invoke-virtual {p2, v0}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result p2

    .line 101
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    const v0, 0x11101d9

    invoke-virtual {p1, v0}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result p1

    if-nez p2, :cond_0

    if-nez p1, :cond_0

    const/4 p1, 0x0

    new-array p1, p1, [I

    .line 105
    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfig;->mDeviceNrCapabilities:[I

    goto :goto_0

    .line 107
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    if-eqz p1, :cond_1

    const/4 p1, 0x1

    .line 109
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_1
    if-eqz p2, :cond_2

    const/4 p1, 0x2

    .line 112
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 114
    :cond_2
    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance p2, Lcom/android/internal/telephony/RadioConfig$$ExternalSyntheticLambda0;

    invoke-direct {p2}, Lcom/android/internal/telephony/RadioConfig$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {p1, p2}, Ljava/util/stream/Stream;->mapToInt(Ljava/util/function/ToIntFunction;)Ljava/util/stream/IntStream;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/stream/IntStream;->toArray()[I

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfig;->mDeviceNrCapabilities:[I

    :goto_0
    return-void
.end method

.method private clearRequestList(IZ)V
    .locals 6

    .line 185
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    monitor-enter v0

    .line 186
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v1

    if-eqz p2, :cond_0

    .line 188
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "clearRequestList: mRequestList="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    :cond_0
    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_2

    .line 192
    iget-object v3, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    invoke-virtual {v3, v2}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/RILRequest;

    if-eqz p2, :cond_1

    .line 194
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, ": ["

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, v3, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, "] "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, v3, Lcom/android/internal/telephony/RILRequest;->mRequest:I

    invoke-static {v5}, Lcom/android/internal/telephony/RILUtils;->requestToString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    :cond_1
    const/4 v4, 0x0

    .line 196
    invoke-virtual {v3, p1, v4}, Lcom/android/internal/telephony/RILRequest;->onError(ILjava/lang/Object;)V

    .line 197
    invoke-virtual {v3}, Lcom/android/internal/telephony/RILRequest;->release()V

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 199
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    invoke-virtual {p0}, Landroid/util/SparseArray;->clear()V

    .line 200
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private findAndRemoveRequestFromList(I)Lcom/android/internal/telephony/RILRequest;
    .locals 2

    .line 378
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    monitor-enter v0

    .line 379
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/RILRequest;

    if-eqz v1, :cond_0

    .line 381
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->remove(I)V

    .line 383
    :cond_0
    monitor-exit v0

    return-object v1

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public static getInstance()Lcom/android/internal/telephony/RadioConfig;
    .locals 3

    .line 122
    sget-object v0, Lcom/android/internal/telephony/RadioConfig;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 123
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/RadioConfig;->sRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    if-eqz v1, :cond_0

    .line 127
    monitor-exit v0

    return-object v1

    .line 124
    :cond_0
    new-instance v1, Ljava/lang/RuntimeException;

    const-string v2, "RadioConfig.getInstance can\'t be called before make()"

    invoke-direct {v1, v2}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v1

    :catchall_0
    move-exception v1

    .line 128
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method private isMobileDataCapable(Landroid/content/Context;)Z
    .locals 0

    .line 89
    const-class p0, Landroid/telephony/TelephonyManager;

    invoke-virtual {p1, p0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/TelephonyManager;

    if-eqz p0, :cond_0

    .line 90
    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->isDataCapable()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static logd(Ljava/lang/String;)V
    .locals 1

    const-string v0, "RadioConfig"

    .line 658
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static loge(Ljava/lang/String;)V
    .locals 1

    const-string v0, "RadioConfig"

    .line 662
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public static make(Landroid/content/Context;Lcom/android/internal/telephony/HalVersion;)Lcom/android/internal/telephony/RadioConfig;
    .locals 7

    .line 135
    sget-object v0, Lcom/android/internal/telephony/RadioConfig;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 136
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/RadioConfig;->sRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    if-nez v1, :cond_1

    .line 139
    sput-object p0, Lcom/android/internal/telephony/RadioConfig;->sContext:Landroid/content/Context;

    const-string v1, "ro.vendor.mtk_telephony_add_on_policy"

    const-string v2, "0"

    .line 141
    invoke-static {v1, v2}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "0"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "com.mediatek.internal.telephony.MtkRadioConfig"
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 146
    :try_start_1
    invoke-static {}, Ljava/lang/ClassLoader;->getSystemClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    const/4 v3, 0x0

    invoke-static {v1, v3, v2}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v1

    .line 147
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "class = "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    const/4 v2, 0x2

    new-array v4, v2, [Ljava/lang/Class;

    .line 148
    const-class v5, Landroid/content/Context;

    aput-object v5, v4, v3

    const-class v5, Lcom/android/internal/telephony/HalVersion;

    const/4 v6, 0x1

    aput-object v5, v4, v6

    invoke-virtual {v1, v4}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v1

    .line 150
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "constructor function = "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    new-array v2, v2, [Ljava/lang/Object;

    aput-object p0, v2, v3

    aput-object p1, v2, v6

    .line 151
    invoke-virtual {v1, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/RadioConfig;

    sput-object v1, Lcom/android/internal/telephony/RadioConfig;->sRadioConfig:Lcom/android/internal/telephony/RadioConfig;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catch_0
    move-exception v1

    .line 153
    :try_start_2
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "No MtkRadioConfig! Used AOSP! e: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    .line 154
    new-instance v1, Lcom/android/internal/telephony/RadioConfig;

    invoke-direct {v1, p0, p1}, Lcom/android/internal/telephony/RadioConfig;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/HalVersion;)V

    sput-object v1, Lcom/android/internal/telephony/RadioConfig;->sRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    goto :goto_0

    .line 157
    :cond_0
    new-instance v1, Lcom/android/internal/telephony/RadioConfig;

    invoke-direct {v1, p0, p1}, Lcom/android/internal/telephony/RadioConfig;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/HalVersion;)V

    sput-object v1, Lcom/android/internal/telephony/RadioConfig;->sRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    .line 159
    :goto_0
    sget-object p0, Lcom/android/internal/telephony/RadioConfig;->sRadioConfig:Lcom/android/internal/telephony/RadioConfig;

    monitor-exit v0

    return-object p0

    .line 137
    :cond_1
    new-instance p0, Ljava/lang/RuntimeException;

    const-string p1, "RadioConfig.make() should only be called once"

    invoke-direct {p0, p1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0

    :catchall_0
    move-exception p0

    .line 160
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method

.method private obtainRequest(ILandroid/os/Message;Landroid/os/WorkSource;)Lcom/android/internal/telephony/RILRequest;
    .locals 0

    .line 369
    invoke-static {p1, p2, p3}, Lcom/android/internal/telephony/RILRequest;->obtain(ILandroid/os/Message;Landroid/os/WorkSource;)Lcom/android/internal/telephony/RILRequest;

    move-result-object p1

    .line 370
    iget-object p2, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    monitor-enter p2

    .line 371
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mRequestList:Landroid/util/SparseArray;

    iget p3, p1, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    invoke-virtual {p0, p3, p1}, Landroid/util/SparseArray;->append(ILjava/lang/Object;)V

    .line 372
    monitor-exit p2

    return-object p1

    :catchall_0
    move-exception p0

    monitor-exit p2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V
    .locals 1

    .line 204
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ": "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    .line 205
    iget-object p1, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RadioConfigProxy;->clear()V

    .line 208
    iget-object p1, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxyCookie:Ljava/util/concurrent/atomic/AtomicLong;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J

    .line 210
    invoke-static {}, Lcom/android/internal/telephony/RILRequest;->resetSerial()V

    const/4 p1, 0x1

    const/4 p2, 0x0

    .line 212
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/RadioConfig;->clearRequestList(IZ)V

    const/4 p1, 0x0

    .line 214
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RadioConfig;->getRadioConfigProxy(Landroid/os/Message;)Lcom/android/internal/telephony/RadioConfigProxy;

    return-void
.end method


# virtual methods
.method public getDeviceNrCapabilities()[I
    .locals 0

    .line 654
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mDeviceNrCapabilities:[I

    return-object p0
.end method

.method public getHalDeviceCapabilities(Landroid/os/Message;)V
    .locals 3

    .line 615
    invoke-static {p1}, Landroid/os/Message;->obtain(Landroid/os/Message;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RadioConfig;->getRadioConfigProxy(Landroid/os/Message;)Lcom/android/internal/telephony/RadioConfigProxy;

    move-result-object v0

    .line 616
    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    return-void

    .line 618
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->getVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object v1

    sget-object v2, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_3:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v1

    if-eqz v1, :cond_2

    if-eqz p1, :cond_1

    const-string p0, "RIL_REQUEST_GET_HAL_DEVICE_CAPABILITIES > REQUEST_NOT_SUPPORTED"

    .line 621
    invoke-static {p0}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 626
    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->getFullCapabilitySet()Ljava/util/Set;

    move-result-object p0

    const/4 v0, 0x6

    .line 627
    invoke-static {v0}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object v0

    .line 623
    invoke-static {p1, p0, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 628
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    :cond_1
    const-string p0, "RIL_REQUEST_GET_HAL_DEVICE_CAPABILITIES > REQUEST_NOT_SUPPORTED on complete message not set."

    .line 631
    invoke-static {p0}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    :goto_0
    return-void

    :cond_2
    const/16 v1, 0xdc

    .line 638
    iget-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mDefaultWorkSource:Landroid/os/WorkSource;

    invoke-direct {p0, v1, p1, v2}, Lcom/android/internal/telephony/RadioConfig;->obtainRequest(ILandroid/os/Message;Landroid/os/WorkSource;)Lcom/android/internal/telephony/RILRequest;

    move-result-object p1

    .line 641
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/android/internal/telephony/RILRequest;->serialString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "> "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Lcom/android/internal/telephony/RILRequest;->mRequest:I

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->requestToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 644
    :try_start_0
    iget p1, p1, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/RadioConfigProxy;->getHalDeviceCapabilities(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception p1

    const-string v0, "getHalDeviceCapabilities"

    .line 646
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    :goto_1
    return-void
.end method

.method public getPhoneCapability(Landroid/os/Message;)V
    .locals 4

    const/4 v0, 0x0

    .line 510
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RadioConfig;->getRadioConfigProxy(Landroid/os/Message;)Lcom/android/internal/telephony/RadioConfigProxy;

    move-result-object v1

    .line 511
    invoke-virtual {v1}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_0

    return-void

    .line 513
    :cond_0
    invoke-virtual {v1}, Lcom/android/internal/telephony/RadioConfigProxy;->getVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object v2

    sget-object v3, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v2

    if-eqz v2, :cond_2

    if-eqz p1, :cond_1

    const/4 p0, 0x6

    .line 516
    invoke-static {p0}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p0

    .line 515
    invoke-static {p1, v0, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 517
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    :cond_1
    return-void

    :cond_2
    const/16 v0, 0xce

    .line 522
    iget-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mDefaultWorkSource:Landroid/os/WorkSource;

    invoke-direct {p0, v0, p1, v2}, Lcom/android/internal/telephony/RadioConfig;->obtainRequest(ILandroid/os/Message;Landroid/os/WorkSource;)Lcom/android/internal/telephony/RILRequest;

    move-result-object p1

    .line 524
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/android/internal/telephony/RILRequest;->serialString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "> "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Lcom/android/internal/telephony/RILRequest;->mRequest:I

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->requestToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 527
    :try_start_0
    iget p1, p1, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/RadioConfigProxy;->getPhoneCapability(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string v0, "getPhoneCapability"

    .line 529
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    :goto_0
    return-void
.end method

.method public getRadioConfigProxy(Landroid/os/Message;)Lcom/android/internal/telephony/RadioConfigProxy;
    .locals 3

    .line 224
    iget-boolean v0, p0, Lcom/android/internal/telephony/RadioConfig;->mIsMobileNetworkSupported:Z

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-nez v0, :cond_1

    if-eqz p1, :cond_0

    .line 228
    invoke-static {v1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object v0

    .line 227
    invoke-static {p1, v2, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 229
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    .line 231
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RadioConfigProxy;->clear()V

    .line 232
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    return-object p0

    .line 235
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    .line 236
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    return-object p0

    .line 239
    :cond_2
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfig;->updateRadioConfigProxy()V

    .line 241
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_3

    if-eqz p1, :cond_3

    .line 243
    invoke-static {v1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object v0

    .line 242
    invoke-static {p1, v2, v0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 244
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    .line 247
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    return-object p0
.end method

.method public getSimSlotsStatus(Landroid/os/Message;)V
    .locals 3

    .line 464
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RadioConfig;->getRadioConfigProxy(Landroid/os/Message;)Lcom/android/internal/telephony/RadioConfigProxy;

    move-result-object v0

    .line 465
    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    return-void

    :cond_0
    const/16 v1, 0xc8

    .line 467
    iget-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mDefaultWorkSource:Landroid/os/WorkSource;

    invoke-direct {p0, v1, p1, v2}, Lcom/android/internal/telephony/RadioConfig;->obtainRequest(ILandroid/os/Message;Landroid/os/WorkSource;)Lcom/android/internal/telephony/RILRequest;

    move-result-object p1

    .line 469
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/android/internal/telephony/RILRequest;->serialString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "> "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p1, Lcom/android/internal/telephony/RILRequest;->mRequest:I

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->requestToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 472
    :try_start_0
    iget p1, p1, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/RadioConfigProxy;->getSimSlotStatus(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string v0, "getSimSlotsStatus"

    .line 474
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    :goto_0
    return-void
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 6

    .line 165
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    .line 166
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "handleMessage: EVENT_HIDL_SERVICE_DEAD cookie = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " mRadioConfigProxyCookie = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxyCookie:Ljava/util/concurrent/atomic/AtomicLong;

    .line 167
    invoke-virtual {v2}, Ljava/util/concurrent/atomic/AtomicLong;->get()J

    move-result-wide v2

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 166
    invoke-static {v0}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 168
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    iget-object p1, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxyCookie:Ljava/util/concurrent/atomic/AtomicLong;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicLong;->get()J

    move-result-wide v4

    cmp-long p1, v2, v4

    if-nez p1, :cond_1

    const-string p1, "EVENT_HIDL_SERVICE_DEAD"

    .line 169
    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    goto :goto_0

    :cond_0
    const/4 p1, 0x2

    if-ne v0, p1, :cond_1

    .line 172
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handleMessage: EVENT_AIDL_SERVICE_DEAD mRadioConfigProxyCookie = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxyCookie:Ljava/util/concurrent/atomic/AtomicLong;

    .line 173
    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicLong;->get()J

    move-result-wide v2

    invoke-virtual {p1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 172
    invoke-static {p1}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    const-string p1, "EVENT_AIDL_SERVICE_DEAD"

    .line 174
    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    :cond_1
    :goto_0
    return-void
.end method

.method protected isGetHidlServiceSync()Z
    .locals 0

    const/4 p0, 0x1

    return p0
.end method

.method public isSetPreferredDataCommandSupported()Z
    .locals 1

    const/4 v0, 0x0

    .line 540
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RadioConfig;->getRadioConfigProxy(Landroid/os/Message;)Lcom/android/internal/telephony/RadioConfigProxy;

    move-result-object p0

    .line 541
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->getVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object p0

    sget-object v0, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public processResponse(Landroid/hardware/radio/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;
    .locals 4

    .line 395
    iget v0, p1, Landroid/hardware/radio/RadioResponseInfo;->serial:I

    .line 396
    iget v1, p1, Landroid/hardware/radio/RadioResponseInfo;->error:I

    .line 397
    iget p1, p1, Landroid/hardware/radio/RadioResponseInfo;->type:I

    if-eqz p1, :cond_0

    .line 400
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "processResponse: Unexpected response type "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    .line 403
    :cond_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/RadioConfig;->findAndRemoveRequestFromList(I)Lcom/android/internal/telephony/RILRequest;

    move-result-object p0

    if-nez p0, :cond_1

    .line 405
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "processResponse: Unexpected response! serial: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " error: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    :cond_1
    return-object p0
.end method

.method public processResponse(Landroid/hardware/radio/V1_0/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;
    .locals 4

    .line 419
    iget v0, p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;->serial:I

    .line 420
    iget v1, p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;->error:I

    .line 421
    iget p1, p1, Landroid/hardware/radio/V1_0/RadioResponseInfo;->type:I

    if-eqz p1, :cond_0

    .line 424
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "processResponse: Unexpected response type "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    .line 427
    :cond_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/RadioConfig;->findAndRemoveRequestFromList(I)Lcom/android/internal/telephony/RILRequest;

    move-result-object p0

    if-nez p0, :cond_1

    .line 429
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "processResponse: Unexpected response! serial: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " error: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    :cond_1
    return-object p0
.end method

.method public processResponse_1_6(Landroid/hardware/radio/V1_6/RadioResponseInfo;)Lcom/android/internal/telephony/RILRequest;
    .locals 4

    .line 444
    iget v0, p1, Landroid/hardware/radio/V1_6/RadioResponseInfo;->serial:I

    .line 445
    iget v1, p1, Landroid/hardware/radio/V1_6/RadioResponseInfo;->error:I

    .line 446
    iget p1, p1, Landroid/hardware/radio/V1_6/RadioResponseInfo;->type:I

    if-eqz p1, :cond_0

    .line 448
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "processResponse: Unexpected response type "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    .line 451
    :cond_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/RadioConfig;->findAndRemoveRequestFromList(I)Lcom/android/internal/telephony/RILRequest;

    move-result-object p0

    if-nez p0, :cond_1

    .line 453
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "processResponse: Unexpected response! serial: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " error: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    :cond_1
    return-object p0
.end method

.method public registerForSimSlotStatusChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 598
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    iput-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mSimSlotStatusRegistrant:Lcom/android/internal/telephony/Registrant;

    return-void
.end method

.method public setModemService(Ljava/lang/String;)Z
    .locals 8

    const/4 v0, 0x1

    const/4 v1, 0x0

    if-eqz p1, :cond_4

    const-string v2, "Overriding connected service to MockModemService"

    .line 261
    invoke-static {v2}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 262
    iput-object v1, p0, Lcom/android/internal/telephony/RadioConfig;->mMockModem:Lcom/android/internal/telephony/MockModem;

    .line 264
    new-instance v2, Lcom/android/internal/telephony/MockModem;

    sget-object v3, Lcom/android/internal/telephony/RadioConfig;->sContext:Landroid/content/Context;

    invoke-direct {v2, v3, p1}, Lcom/android/internal/telephony/MockModem;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    iput-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mMockModem:Lcom/android/internal/telephony/MockModem;

    const/4 v3, 0x7

    .line 270
    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/MockModem;->bindToMockModemService(I)V

    const/4 v2, 0x0

    move v4, v2

    .line 275
    :cond_0
    iget-object v5, p0, Lcom/android/internal/telephony/RadioConfig;->mMockModem:Lcom/android/internal/telephony/MockModem;

    invoke-virtual {v5, v3}, Lcom/android/internal/telephony/MockModem;->getServiceBinder(I)Landroid/os/IBinder;

    move-result-object v5

    add-int/2addr v4, v0

    if-nez v5, :cond_1

    .line 279
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Retry("

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, ") Mock RadioConfig"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    const-wide/16 v6, 0x12c

    .line 281
    :try_start_0
    invoke-static {v6, v7}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_1
    if-nez v5, :cond_2

    const/4 v6, 0x3

    if-lt v4, v6, :cond_0

    :cond_2
    if-nez v5, :cond_3

    const-string v0, "Mock RadioConfig bind fail"

    .line 288
    invoke-static {v0}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    move v0, v2

    :cond_3
    if-eqz v0, :cond_4

    const-string v2, "EVENT_HIDL_SERVICE_DEAD"

    .line 292
    invoke-direct {p0, v2, v1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    :cond_4
    if-eqz p1, :cond_5

    if-nez v0, :cond_7

    :cond_5
    if-eqz v0, :cond_6

    const-string p1, "Unbinding to mock RadioConfig service"

    .line 296
    invoke-static {p1}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 298
    :cond_6
    iget-object p1, p0, Lcom/android/internal/telephony/RadioConfig;->mMockModem:Lcom/android/internal/telephony/MockModem;

    if-eqz p1, :cond_7

    .line 299
    iput-object v1, p0, Lcom/android/internal/telephony/RadioConfig;->mMockModem:Lcom/android/internal/telephony/MockModem;

    const-string p1, "EVENT_AIDL_SERVICE_DEAD"

    .line 300
    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    :cond_7
    return v0
.end method

.method public setNumOfLiveModems(ILandroid/os/Message;)V
    .locals 3

    .line 569
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RadioConfig;->getRadioConfigProxy(Landroid/os/Message;)Lcom/android/internal/telephony/RadioConfigProxy;

    move-result-object v0

    .line 570
    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    return-void

    .line 572
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->getVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object v1

    sget-object v2, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v1

    if-eqz v1, :cond_2

    if-eqz p2, :cond_1

    const/4 p0, 0x0

    const/4 p1, 0x6

    .line 575
    invoke-static {p1}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p1

    .line 574
    invoke-static {p2, p0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 576
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    :cond_1
    return-void

    :cond_2
    const/16 v1, 0xcf

    .line 581
    iget-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mDefaultWorkSource:Landroid/os/WorkSource;

    invoke-direct {p0, v1, p2, v2}, Lcom/android/internal/telephony/RadioConfig;->obtainRequest(ILandroid/os/Message;Landroid/os/WorkSource;)Lcom/android/internal/telephony/RILRequest;

    move-result-object p2

    .line 584
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2}, Lcom/android/internal/telephony/RILRequest;->serialString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "> "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p2, Lcom/android/internal/telephony/RILRequest;->mRequest:I

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->requestToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ", numOfLiveModems = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 588
    :try_start_0
    iget p2, p2, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    invoke-virtual {v0, p2, p1}, Lcom/android/internal/telephony/RadioConfigProxy;->setNumOfLiveModems(II)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string p2, "setNumOfLiveModems"

    .line 590
    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    :goto_0
    return-void
.end method

.method public setPreferredDataModem(ILandroid/os/Message;)V
    .locals 3

    const/4 v0, 0x0

    .line 482
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RadioConfig;->getRadioConfigProxy(Landroid/os/Message;)Lcom/android/internal/telephony/RadioConfigProxy;

    move-result-object v1

    .line 483
    invoke-virtual {v1}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_0

    return-void

    .line 485
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfig;->isSetPreferredDataCommandSupported()Z

    move-result v2

    if-nez v2, :cond_2

    if-eqz p2, :cond_1

    const/4 p0, 0x6

    .line 488
    invoke-static {p0}, Lcom/android/internal/telephony/CommandException;->fromRilErrno(I)Lcom/android/internal/telephony/CommandException;

    move-result-object p0

    .line 487
    invoke-static {p2, v0, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 489
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    :cond_1
    return-void

    :cond_2
    const/16 v0, 0xcc

    .line 494
    iget-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mDefaultWorkSource:Landroid/os/WorkSource;

    invoke-direct {p0, v0, p2, v2}, Lcom/android/internal/telephony/RadioConfig;->obtainRequest(ILandroid/os/Message;Landroid/os/WorkSource;)Lcom/android/internal/telephony/RILRequest;

    move-result-object p2

    .line 497
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2}, Lcom/android/internal/telephony/RILRequest;->serialString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "> "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p2, Lcom/android/internal/telephony/RILRequest;->mRequest:I

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->requestToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 500
    :try_start_0
    iget p2, p2, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    invoke-virtual {v1, p2, p1}, Lcom/android/internal/telephony/RadioConfigProxy;->setPreferredDataModem(II)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string p2, "setPreferredDataModem"

    .line 502
    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    :goto_0
    return-void
.end method

.method public setSimSlotsMapping(Ljava/util/List;Landroid/os/Message;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/UiccSlotMapping;",
            ">;",
            "Landroid/os/Message;",
            ")V"
        }
    .end annotation

    .line 548
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RadioConfig;->getRadioConfigProxy(Landroid/os/Message;)Lcom/android/internal/telephony/RadioConfigProxy;

    move-result-object v0

    .line 549
    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    return-void

    :cond_0
    const/16 v1, 0xc9

    .line 551
    iget-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mDefaultWorkSource:Landroid/os/WorkSource;

    invoke-direct {p0, v1, p2, v2}, Lcom/android/internal/telephony/RadioConfig;->obtainRequest(ILandroid/os/Message;Landroid/os/WorkSource;)Lcom/android/internal/telephony/RILRequest;

    move-result-object p2

    .line 554
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2}, Lcom/android/internal/telephony/RILRequest;->serialString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "> "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p2, Lcom/android/internal/telephony/RILRequest;->mRequest:I

    invoke-static {v2}, Lcom/android/internal/telephony/RILUtils;->requestToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/RadioConfig;->logd(Ljava/lang/String;)V

    .line 558
    :try_start_0
    iget p2, p2, Lcom/android/internal/telephony/RILRequest;->mSerial:I

    invoke-virtual {v0, p2, p1}, Lcom/android/internal/telephony/RadioConfigProxy;->setSimSlotsMapping(ILjava/util/List;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    const-string p2, "setSimSlotsMapping"

    .line 560
    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/RadioConfig;->resetProxyAndRequestList(Ljava/lang/String;Ljava/lang/Exception;)V

    :goto_0
    return-void
.end method

.method public unregisterForSimSlotStatusChanged(Landroid/os/Handler;)V
    .locals 1

    .line 605
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mSimSlotStatusRegistrant:Lcom/android/internal/telephony/Registrant;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->getHandler()Landroid/os/Handler;

    move-result-object v0

    if-ne v0, p1, :cond_0

    .line 606
    iget-object p1, p0, Lcom/android/internal/telephony/RadioConfig;->mSimSlotStatusRegistrant:Lcom/android/internal/telephony/Registrant;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Registrant;->clear()V

    const/4 p1, 0x0

    .line 607
    iput-object p1, p0, Lcom/android/internal/telephony/RadioConfig;->mSimSlotStatusRegistrant:Lcom/android/internal/telephony/Registrant;

    :cond_0
    return-void
.end method

.method protected updateRadioConfigProxy()V
    .locals 4

    .line 310
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mMockModem:Lcom/android/internal/telephony/MockModem;

    if-nez v0, :cond_0

    .line 311
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v1, Landroid/hardware/radio/config/IRadioConfig;->DESCRIPTOR:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/default"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/os/ServiceManager;->waitForDeclaredService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v0

    goto :goto_0

    :cond_0
    const/4 v1, 0x7

    .line 315
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/MockModem;->getServiceBinder(I)Landroid/os/IBinder;

    move-result-object v0

    :goto_0
    if-eqz v0, :cond_1

    .line 319
    iget-object v1, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    sget-object v2, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_2_0:Lcom/android/internal/telephony/HalVersion;

    .line 321
    invoke-static {v0}, Landroid/hardware/radio/config/IRadioConfig$Stub;->asInterface(Landroid/os/IBinder;)Landroid/hardware/radio/config/IRadioConfig;

    move-result-object v0

    .line 319
    invoke-virtual {v1, v2, v0}, Lcom/android/internal/telephony/RadioConfigProxy;->setAidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/config/IRadioConfig;)V

    .line 324
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_2

    .line 326
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    sget-object v2, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_3:Lcom/android/internal/telephony/HalVersion;

    .line 327
    invoke-static {v1}, Landroid/hardware/radio/config/V1_3/IRadioConfig;->getService(Z)Landroid/hardware/radio/config/V1_3/IRadioConfig;

    move-result-object v3

    .line 326
    invoke-virtual {v0, v2, v3}, Lcom/android/internal/telephony/RadioConfigProxy;->setHidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/config/V1_0/IRadioConfig;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/util/NoSuchElementException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception v0

    .line 329
    iget-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v2}, Lcom/android/internal/telephony/RadioConfigProxy;->clear()V

    .line 330
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "getHidlRadioConfigProxy1_3: RadioConfigProxy getService: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    .line 334
    :cond_2
    :goto_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 336
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    sget-object v2, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_1:Lcom/android/internal/telephony/HalVersion;

    .line 337
    invoke-static {v1}, Landroid/hardware/radio/config/V1_1/IRadioConfig;->getService(Z)Landroid/hardware/radio/config/V1_1/IRadioConfig;

    move-result-object v3

    .line 336
    invoke-virtual {v0, v2, v3}, Lcom/android/internal/telephony/RadioConfigProxy;->setHidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/config/V1_0/IRadioConfig;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/util/NoSuchElementException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_2

    :catch_1
    move-exception v0

    .line 339
    iget-object v2, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v2}, Lcom/android/internal/telephony/RadioConfigProxy;->clear()V

    .line 340
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "getHidlRadioConfigProxy1_1: RadioConfigProxy getService | linkToDeath: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    .line 344
    :cond_3
    :goto_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 346
    :try_start_2
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    sget-object v2, Lcom/android/internal/telephony/RadioConfig;->RADIO_CONFIG_HAL_VERSION_1_0:Lcom/android/internal/telephony/HalVersion;

    .line 347
    invoke-static {v1}, Landroid/hardware/radio/config/V1_0/IRadioConfig;->getService(Z)Landroid/hardware/radio/config/V1_0/IRadioConfig;

    move-result-object v1

    .line 346
    invoke-virtual {v0, v2, v1}, Lcom/android/internal/telephony/RadioConfigProxy;->setHidl(Lcom/android/internal/telephony/HalVersion;Landroid/hardware/radio/config/V1_0/IRadioConfig;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2
    .catch Ljava/util/NoSuchElementException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_3

    :catch_2
    move-exception v0

    .line 349
    iget-object v1, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v1}, Lcom/android/internal/telephony/RadioConfigProxy;->clear()V

    .line 350
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getHidlRadioConfigProxy1_0: RadioConfigProxy getService | linkToDeath: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    .line 354
    :cond_4
    :goto_3
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioConfigProxy;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_5

    .line 356
    :try_start_3
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    iget-object v1, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxyCookie:Ljava/util/concurrent/atomic/AtomicLong;

    invoke-virtual {v1}, Ljava/util/concurrent/atomic/AtomicLong;->incrementAndGet()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/RadioConfigProxy;->linkToDeath(J)V

    .line 357
    iget-object v0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/RadioConfigProxy;->setResponseFunctions(Lcom/android/internal/telephony/RadioConfig;)V
    :try_end_3
    .catch Landroid/os/RemoteException; {:try_start_3 .. :try_end_3} :catch_3

    return-void

    .line 360
    :catch_3
    iget-object p0, p0, Lcom/android/internal/telephony/RadioConfig;->mRadioConfigProxy:Lcom/android/internal/telephony/RadioConfigProxy;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RadioConfigProxy;->clear()V

    const-string p0, "RadioConfigProxy: failed to linkToDeath() or setResponseFunction()"

    .line 361
    invoke-static {p0}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    :cond_5
    const-string p0, "getRadioConfigProxy: mRadioConfigProxy == null"

    .line 365
    invoke-static {p0}, Lcom/android/internal/telephony/RadioConfig;->loge(Ljava/lang/String;)V

    return-void
.end method
