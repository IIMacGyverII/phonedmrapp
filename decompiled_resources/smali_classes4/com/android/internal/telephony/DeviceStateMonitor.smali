.class public Lcom/android/internal/telephony/DeviceStateMonitor;
.super Landroid/os/Handler;
.source "DeviceStateMonitor.java"


# static fields
.field static final CELL_INFO_INTERVAL_LONG_MS:I = 0x2710
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final CELL_INFO_INTERVAL_SHORT_MS:I = 0x7d0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field protected static final DBG:Z = false

.field static final EVENT_AUTOMOTIVE_PROJECTION_STATE_CHANGED:I = 0x1

.field static final EVENT_CHARGING_STATE_CHANGED:I = 0x4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final EVENT_POWER_SAVE_MODE_CHANGED:I = 0x3

.field static final EVENT_RADIO_AVAILABLE:I = 0x6

.field static final EVENT_RADIO_OFF_OR_NOT_AVAILABLE:I = 0xa

.field static final EVENT_RADIO_ON:I = 0x9

.field static final EVENT_RIL_CONNECTED:I = 0x0

.field static final EVENT_SCREEN_STATE_CHANGED:I = 0x2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field static final EVENT_TETHERING_STATE_CHANGED:I = 0x5

.field static final EVENT_UPDATE_ALWAYS_REPORT_SIGNAL_STRENGTH:I = 0x8

.field static final EVENT_WIFI_CONNECTION_CHANGED:I = 0x7
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final LINK_CAPACITY_DOWNLINK_THRESHOLDS:[I

.field private static final LINK_CAPACITY_UPLINK_THRESHOLDS:[I

.field private static final NR_NSA_TRACKING_INDICATIONS_ALWAYS_ON:I = 0x2

.field private static final NR_NSA_TRACKING_INDICATIONS_EXTENDED:I = 0x1

.field private static final NR_NSA_TRACKING_INDICATIONS_OFF:I = 0x0

.field protected static final TAG:Ljava/lang/String;

.field private static final WIFI_AVAILABLE:I = 0x1

.field private static final WIFI_UNAVAILABLE:I


# instance fields
.field private final mBroadcastReceiver:Landroid/content/BroadcastReceiver;

.field private mCellInfoMinInterval:I

.field private final mDisplayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

.field private mIsAlwaysSignalStrengthReportingEnabled:Z

.field private mIsAutomotiveProjectionActive:Z

.field protected mIsCharging:Z

.field protected mIsLowDataExpected:Z

.field private mIsPowerSaveOn:Z

.field private mIsRadioOn:Z

.field protected mIsScreenOn:Z

.field protected mIsTetheringOn:Z

.field private mIsWifiConnected:Z

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mNetworkCallback:Landroid/net/ConnectivityManager$NetworkCallback;

.field protected final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mPhysicalChannelConfigRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private mUnsolicitedResponseFilter:I

.field private final mWifiNetworkRequest:Landroid/net/NetworkRequest;


# direct methods
.method public static synthetic $r8$lambda$H7FyOrCDkaZT9ooiVdD8LyLRZcc(Lcom/android/internal/telephony/DeviceStateMonitor;ILjava/util/Set;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/DeviceStateMonitor;->lambda$new$0(ILjava/util/Set;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$misPowerSaveModeOn(Lcom/android/internal/telephony/DeviceStateMonitor;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->isPowerSaveModeOn()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misScreenOn(Lcom/android/internal/telephony/DeviceStateMonitor;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->isScreenOn()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mlog(Lcom/android/internal/telephony/DeviceStateMonitor;Ljava/lang/String;Z)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 69
    const-class v0, Lcom/android/internal/telephony/DeviceStateMonitor;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/DeviceStateMonitor;->TAG:Ljava/lang/String;

    const/16 v0, 0xe

    new-array v0, v0, [I

    .line 839
    fill-array-data v0, :array_0

    sput-object v0, Lcom/android/internal/telephony/DeviceStateMonitor;->LINK_CAPACITY_DOWNLINK_THRESHOLDS:[I

    const/16 v0, 0xb

    new-array v0, v0, [I

    .line 857
    fill-array-data v0, :array_1

    sput-object v0, Lcom/android/internal/telephony/DeviceStateMonitor;->LINK_CAPACITY_UPLINK_THRESHOLDS:[I

    return-void

    nop

    :array_0
    .array-data 4
        0x64
        0x1f4
        0x3e8
        0x1388
        0x2710
        0x4e20
        0xc350
        0x124f8
        0x186a0
        0x30d40
        0x7a120
        0xf4240
        0x16e360
        0x1e8480
    .end array-data

    :array_1
    .array-data 4
        0x64
        0x1f4
        0x3e8
        0x1388
        0x2710
        0x4e20
        0xc350
        0x124f8
        0x186a0
        0x30d40
        0x7a120
    .end array-data
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 8

    .line 281
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 97
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x40

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 99
    new-instance v0, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v0}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhysicalChannelConfigRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 101
    new-instance v0, Landroid/net/NetworkRequest$Builder;

    invoke-direct {v0}, Landroid/net/NetworkRequest$Builder;-><init>()V

    const/4 v1, 0x1

    .line 103
    invoke-virtual {v0, v1}, Landroid/net/NetworkRequest$Builder;->addTransportType(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v0

    const/16 v2, 0xc

    .line 104
    invoke-virtual {v0, v2}, Landroid/net/NetworkRequest$Builder;->addCapability(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v0

    const/16 v2, 0xd

    .line 105
    invoke-virtual {v0, v2}, Landroid/net/NetworkRequest$Builder;->removeCapability(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v0

    .line 106
    invoke-virtual {v0}, Landroid/net/NetworkRequest$Builder;->build()Landroid/net/NetworkRequest;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mWifiNetworkRequest:Landroid/net/NetworkRequest;

    .line 108
    new-instance v2, Lcom/android/internal/telephony/DeviceStateMonitor$1;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/DeviceStateMonitor$1;-><init>(Lcom/android/internal/telephony/DeviceStateMonitor;)V

    iput-object v2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mNetworkCallback:Landroid/net/ConnectivityManager$NetworkCallback;

    const/16 v3, 0x7d0

    .line 209
    iput v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mCellInfoMinInterval:I

    const/4 v3, -0x1

    .line 215
    iput v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mUnsolicitedResponseFilter:I

    .line 217
    new-instance v3, Lcom/android/internal/telephony/DeviceStateMonitor$2;

    invoke-direct {v3, p0}, Lcom/android/internal/telephony/DeviceStateMonitor$2;-><init>(Lcom/android/internal/telephony/DeviceStateMonitor;)V

    iput-object v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mDisplayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

    .line 237
    new-instance v4, Lcom/android/internal/telephony/DeviceStateMonitor$3;

    invoke-direct {v4, p0}, Lcom/android/internal/telephony/DeviceStateMonitor$3;-><init>(Lcom/android/internal/telephony/DeviceStateMonitor;)V

    iput-object v4, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    .line 282
    iput-object p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 283
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v5

    const-string v6, "display"

    invoke-virtual {v5, v6}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/hardware/display/DisplayManager;

    const/4 v6, 0x0

    .line 285
    invoke-virtual {v5, v3, v6}, Landroid/hardware/display/DisplayManager;->registerDisplayListener(Landroid/hardware/display/DisplayManager$DisplayListener;Landroid/os/Handler;)V

    .line 287
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->isPowerSaveModeOn()Z

    move-result v3

    iput-boolean v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsPowerSaveOn:Z

    .line 288
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->isDeviceCharging()Z

    move-result v3

    iput-boolean v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsCharging:Z

    .line 289
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->isScreenOn()Z

    move-result v3

    iput-boolean v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsScreenOn:Z

    .line 290
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->isRadioOn()Z

    move-result v3

    iput-boolean v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsRadioOn:Z

    .line 291
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->isAutomotiveProjectionActive()Z

    move-result v3

    iput-boolean v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAutomotiveProjectionActive:Z

    const/4 v3, 0x0

    .line 293
    iput-boolean v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsTetheringOn:Z

    .line 294
    iput-boolean v3, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsLowDataExpected:Z

    .line 296
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "DeviceStateMonitor mIsTetheringOn="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsTetheringOn:Z

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, ", mIsScreenOn="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsScreenOn:Z

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, ", mIsCharging="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsCharging:Z

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, ", mIsPowerSaveOn="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsPowerSaveOn:Z

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, ", mIsLowDataExpected="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsLowDataExpected:Z

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, ", mIsAutomotiveProjectionActive="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAutomotiveProjectionActive:Z

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, ", mIsWifiConnected="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsWifiConnected:Z

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, ", mIsAlwaysSignalStrengthReportingEnabled="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAlwaysSignalStrengthReportingEnabled:Z

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, ", mIsRadioOn="

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v7, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsRadioOn:Z

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {p0, v5, v3}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    .line 307
    new-instance v5, Landroid/content/IntentFilter;

    invoke-direct {v5}, Landroid/content/IntentFilter;-><init>()V

    const-string v7, "android.os.action.POWER_SAVE_MODE_CHANGED"

    .line 308
    invoke-virtual {v5, v7}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v7, "android.os.action.CHARGING"

    .line 309
    invoke-virtual {v5, v7}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v7, "android.os.action.DISCHARGING"

    .line 310
    invoke-virtual {v5, v7}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v7, "android.net.conn.TETHER_STATE_CHANGED"

    .line 311
    invoke-virtual {v5, v7}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 312
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v7

    invoke-virtual {v7, v4, v5, v6, p1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;

    .line 314
    iget-object v4, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v4, p0, v3, v6}, Lcom/android/internal/telephony/CommandsInterface;->registerForRilConnected(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 315
    iget-object v3, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v4, 0x6

    invoke-interface {v3, p0, v4, v6}, Lcom/android/internal/telephony/CommandsInterface;->registerForAvailable(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 316
    iget-object v3, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v4, 0x9

    invoke-interface {v3, p0, v4, v6}, Lcom/android/internal/telephony/CommandsInterface;->registerForOn(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 317
    iget-object v3, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v4, 0xa

    invoke-interface {v3, p0, v4, v6}, Lcom/android/internal/telephony/CommandsInterface;->registerForOffOrNotAvailable(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 319
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v3

    const-string v4, "connectivity"

    invoke-virtual {v3, v4}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/net/ConnectivityManager;

    .line 321
    invoke-virtual {v3, v0, v2}, Landroid/net/ConnectivityManager;->registerNetworkCallback(Landroid/net/NetworkRequest;Landroid/net/ConnectivityManager$NetworkCallback;)V

    .line 323
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string/jumbo v2, "uimode"

    invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/UiModeManager;

    .line 326
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/Context;->getMainExecutor()Ljava/util/concurrent/Executor;

    move-result-object p1

    new-instance v2, Lcom/android/internal/telephony/DeviceStateMonitor$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/DeviceStateMonitor$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/DeviceStateMonitor;)V

    .line 325
    invoke-virtual {v0, v1, p1, v2}, Landroid/app/UiModeManager;->addOnProjectionStateChangedListener(ILjava/util/concurrent/Executor;Landroid/app/UiModeManager$OnProjectionStateChangedListener;)V

    return-void
.end method

.method private deviceTypeToString(I)Ljava/lang/String;
    .locals 0

    if-eqz p1, :cond_2

    const/4 p0, 0x1

    if-eq p1, p0, :cond_1

    const/4 p0, 0x2

    if-eq p1, p0, :cond_0

    const-string p0, "UNKNOWN"

    return-object p0

    :cond_0
    const-string p0, "LOW_DATA_EXPECTED"

    return-object p0

    :cond_1
    const-string p0, "CHARGING_STATE"

    return-object p0

    :cond_2
    const-string p0, "POWER_SAVE_MODE"

    return-object p0
.end method

.method private isAutomotiveProjectionActive()Z
    .locals 4

    .line 760
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string/jumbo v1, "uimode"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/UiModeManager;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 763
    :cond_0
    invoke-virtual {v0}, Landroid/app/UiModeManager;->getActiveProjectionTypes()I

    move-result v0

    const/4 v2, 0x1

    and-int/2addr v0, v2

    if-eqz v0, :cond_1

    move v1, v2

    .line 765
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "isAutomotiveProjectionActive="

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    return v1
.end method

.method private isDeviceCharging()Z
    .locals 3

    .line 713
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "batterymanager"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/BatteryManager;

    .line 715
    invoke-virtual {v0}, Landroid/os/BatteryManager;->isCharging()Z

    move-result v0

    .line 716
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isDeviceCharging="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x1

    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    return v0
.end method

.method private isPowerSaveModeOn()Z
    .locals 3

    .line 699
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "power"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/PowerManager;

    .line 701
    invoke-virtual {v0}, Landroid/os/PowerManager;->isPowerSaveMode()Z

    move-result v0

    .line 702
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isPowerSaveModeOn="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x1

    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    return v0
.end method

.method private isRadioOn()Z
    .locals 0

    .line 753
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isRadioOn()Z

    move-result p0

    return p0
.end method

.method private isScreenOn()Z
    .locals 8

    .line 728
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "display"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/display/DisplayManager;

    .line 730
    invoke-virtual {v0}, Landroid/hardware/display/DisplayManager;->getDisplays()[Landroid/view/Display;

    move-result-object v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz v0, :cond_2

    .line 733
    array-length v3, v0

    move v4, v1

    :goto_0
    if-ge v4, v3, :cond_1

    aget-object v5, v0, v4

    .line 736
    invoke-virtual {v5}, Landroid/view/Display;->getState()I

    move-result v6

    const/4 v7, 0x2

    if-ne v6, v7, :cond_0

    .line 737
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Screen on for display="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    return v2

    :cond_0
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_1
    const-string v0, "Screens all off"

    .line 741
    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    return v1

    :cond_2
    const-string v0, "No displays found"

    .line 745
    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    return v1
.end method

.method private synthetic lambda$new$0(ILjava/util/Set;)V
    .locals 1

    const/4 p1, 0x1

    .line 328
    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 329
    invoke-interface {p2}, Ljava/util/Set;->size()I

    move-result p2

    invoke-static {p2, p1}, Ljava/lang/Math;->min(II)I

    move-result p1

    iput p1, v0, Landroid/os/Message;->arg1:I

    .line 330
    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method private log(Ljava/lang/String;Z)V
    .locals 0

    if-eqz p2, :cond_0

    .line 798
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method private onReset()V
    .locals 3

    const-string v0, "onReset."

    const/4 v1, 0x1

    .line 626
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    .line 627
    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsCharging:Z

    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/DeviceStateMonitor;->sendDeviceState(IZ)V

    .line 628
    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsLowDataExpected:Z

    const/4 v2, 0x2

    invoke-direct {p0, v2, v0}, Lcom/android/internal/telephony/DeviceStateMonitor;->sendDeviceState(IZ)V

    .line 629
    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsPowerSaveOn:Z

    const/4 v2, 0x0

    invoke-direct {p0, v2, v0}, Lcom/android/internal/telephony/DeviceStateMonitor;->sendDeviceState(IZ)V

    .line 630
    iget v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mUnsolicitedResponseFilter:I

    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/DeviceStateMonitor;->setUnsolResponseFilter(IZ)V

    .line 631
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->setLinkCapacityReportingCriteria()V

    .line 632
    iget v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mCellInfoMinInterval:I

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/DeviceStateMonitor;->setCellInfoMinInterval(I)V

    return-void
.end method

.method private onUpdateDeviceState(IZ)V
    .locals 5

    .line 514
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableBarringInfoReports()Z

    move-result v0

    .line 515
    invoke-virtual {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableHighPowerConsumptionIndications()Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    packed-switch p1, :pswitch_data_0

    :pswitch_0
    return-void

    .line 528
    :pswitch_1
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsRadioOn:Z

    if-ne p1, p2, :cond_0

    return-void

    .line 529
    :cond_0
    iput-boolean p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsRadioOn:Z

    goto :goto_0

    .line 545
    :pswitch_2
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAlwaysSignalStrengthReportingEnabled:Z

    if-ne p1, p2, :cond_1

    return-void

    .line 546
    :cond_1
    iput-boolean p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAlwaysSignalStrengthReportingEnabled:Z

    goto :goto_0

    .line 541
    :pswitch_3
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsWifiConnected:Z

    if-ne p1, p2, :cond_2

    return-void

    .line 542
    :cond_2
    iput-boolean p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsWifiConnected:Z

    goto :goto_0

    .line 532
    :pswitch_4
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsTetheringOn:Z

    if-ne p1, p2, :cond_3

    return-void

    .line 533
    :cond_3
    iput-boolean p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsTetheringOn:Z

    goto :goto_0

    .line 522
    :pswitch_5
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsCharging:Z

    if-ne p1, p2, :cond_4

    return-void

    .line 523
    :cond_4
    iput-boolean p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsCharging:Z

    .line 524
    invoke-direct {p0, v3, p2}, Lcom/android/internal/telephony/DeviceStateMonitor;->sendDeviceState(IZ)V

    goto :goto_0

    .line 536
    :pswitch_6
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsPowerSaveOn:Z

    if-ne p1, p2, :cond_5

    return-void

    .line 537
    :cond_5
    iput-boolean p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsPowerSaveOn:Z

    .line 538
    invoke-direct {p0, v2, p2}, Lcom/android/internal/telephony/DeviceStateMonitor;->sendDeviceState(IZ)V

    goto :goto_0

    .line 518
    :pswitch_7
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsScreenOn:Z

    if-ne p1, p2, :cond_6

    return-void

    .line 519
    :cond_6
    iput-boolean p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsScreenOn:Z

    goto :goto_0

    .line 549
    :pswitch_8
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAutomotiveProjectionActive:Z

    if-ne p1, p2, :cond_7

    return-void

    .line 550
    :cond_7
    iput-boolean p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAutomotiveProjectionActive:Z

    .line 556
    :goto_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableHighPowerConsumptionIndications()Z

    move-result p1

    if-eq v1, p1, :cond_8

    .line 558
    iget-object p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    xor-int/2addr p1, v3

    invoke-virtual {p2, p1}, Lcom/android/internal/telephony/Phone;->notifyDeviceIdleStateChanged(Z)V

    .line 561
    :cond_8
    invoke-virtual {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->computeCellInfoMinInterval()I

    move-result p1

    .line 562
    iget p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mCellInfoMinInterval:I

    if-eq p2, p1, :cond_9

    .line 563
    iput p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mCellInfoMinInterval:I

    .line 564
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/DeviceStateMonitor;->setCellInfoMinInterval(I)V

    .line 565
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "CellInfo Min Interval Updated to "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1, v3}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    .line 568
    :cond_9
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsLowDataExpected:Z

    invoke-virtual {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->isLowDataExpected()Z

    move-result p2

    if-eq p1, p2, :cond_a

    .line 569
    iget-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsLowDataExpected:Z

    xor-int/2addr p1, v3

    iput-boolean p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsLowDataExpected:Z

    const/4 p2, 0x2

    .line 570
    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/DeviceStateMonitor;->sendDeviceState(IZ)V

    :cond_a
    const/16 p1, 0x20

    .line 576
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableSignalStrengthReports()Z

    move-result p2

    if-eqz p2, :cond_b

    const/16 p1, 0x21

    .line 580
    :cond_b
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableFullNetworkStateReports()Z

    move-result p2

    if-eqz p2, :cond_c

    or-int/lit8 p1, p1, 0x2

    .line 584
    :cond_c
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableDataCallDormancyChangedReports()Z

    move-result p2

    if-eqz p2, :cond_d

    or-int/lit8 p1, p1, 0x4

    .line 588
    :cond_d
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableLinkCapacityEstimateReports()Z

    move-result p2

    if-eqz p2, :cond_e

    or-int/lit8 p1, p1, 0x8

    .line 592
    :cond_e
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnablePhysicalChannelConfigReports()Z

    move-result p2

    if-eqz p2, :cond_f

    or-int/lit8 p1, p1, 0x10

    .line 596
    :cond_f
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableBarringInfoReports()Z

    move-result p2

    if-eqz p2, :cond_10

    or-int/lit8 p1, p1, 0x40

    :cond_10
    and-int/lit8 v1, p1, 0x10

    .line 602
    iget v4, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mUnsolicitedResponseFilter:I

    and-int/lit8 v4, v4, 0x10

    if-eq v1, v4, :cond_12

    .line 604
    iget-object v4, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhysicalChannelConfigRegistrants:Lcom/android/internal/telephony/RegistrantList;

    if-eqz v1, :cond_11

    goto :goto_1

    :cond_11
    move v3, v2

    .line 605
    :goto_1
    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    .line 604
    invoke-virtual {v4, v1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    .line 608
    :cond_12
    invoke-direct {p0, p1, v2}, Lcom/android/internal/telephony/DeviceStateMonitor;->setUnsolResponseFilter(IZ)V

    if-eqz p2, :cond_13

    if-nez v0, :cond_13

    .line 614
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 p1, 0x0

    invoke-interface {p0, p1}, Lcom/android/internal/telephony/CommandsInterface;->getBarringInfo(Landroid/os/Message;)V

    :cond_13
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_0
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_1
    .end packed-switch
.end method

.method private sendDeviceState(IZ)V
    .locals 2

    .line 657
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "send type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/DeviceStateMonitor;->deviceTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x1

    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    .line 658
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x0

    invoke-interface {p0, p1, p2, v0}, Lcom/android/internal/telephony/CommandsInterface;->sendDeviceState(IZLandroid/os/Message;)V

    return-void
.end method

.method private setCellInfoMinInterval(I)V
    .locals 0

    .line 691
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/Phone;->setCellInfoMinInterval(I)V

    return-void
.end method

.method private setLinkCapacityReportingCriteria()V
    .locals 4

    .line 676
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    sget-object v1, Lcom/android/internal/telephony/DeviceStateMonitor;->LINK_CAPACITY_DOWNLINK_THRESHOLDS:[I

    sget-object v2, Lcom/android/internal/telephony/DeviceStateMonitor;->LINK_CAPACITY_UPLINK_THRESHOLDS:[I

    const/4 v3, 0x1

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/Phone;->setLinkCapacityReportingCriteria([I[II)V

    .line 678
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 v3, 0x2

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/Phone;->setLinkCapacityReportingCriteria([I[II)V

    .line 680
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 v3, 0x3

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/Phone;->setLinkCapacityReportingCriteria([I[II)V

    .line 682
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 v3, 0x4

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/Phone;->setLinkCapacityReportingCriteria([I[II)V

    .line 684
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getHalVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object v0

    sget-object v3, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_5:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 685
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 v0, 0x6

    invoke-virtual {p0, v1, v2, v0}, Lcom/android/internal/telephony/Phone;->setLinkCapacityReportingCriteria([I[II)V

    :cond_0
    return-void
.end method

.method private setUnsolResponseFilter(IZ)V
    .locals 1

    if-nez p2, :cond_0

    .line 668
    iget p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mUnsolicitedResponseFilter:I

    if-eq p1, p2, :cond_1

    .line 669
    :cond_0
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "old filter: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mUnsolicitedResponseFilter:I

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ", new filter: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const/4 v0, 0x1

    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    .line 670
    iget-object p2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object p2, p2, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v0, 0x0

    invoke-interface {p2, p1, v0}, Lcom/android/internal/telephony/CommandsInterface;->setUnsolResponseFilter(ILandroid/os/Message;)V

    .line 671
    iput p1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mUnsolicitedResponseFilter:I

    :cond_1
    return-void
.end method

.method private shouldEnableBarringInfoReports()Z
    .locals 0

    .line 417
    invoke-virtual {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableHighPowerConsumptionIndications()Z

    move-result p0

    return p0
.end method

.method private shouldEnableDataCallDormancyChangedReports()Z
    .locals 0

    .line 393
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableNrTrackingIndications()Z

    move-result p0

    return p0
.end method

.method private shouldEnableFullNetworkStateReports()Z
    .locals 0

    .line 385
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableNrTrackingIndications()Z

    move-result p0

    return p0
.end method

.method private shouldEnableLinkCapacityEstimateReports()Z
    .locals 0

    .line 401
    invoke-virtual {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableHighPowerConsumptionIndications()Z

    move-result p0

    return p0
.end method

.method private shouldEnableNrTrackingIndications()Z
    .locals 3

    .line 443
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "nr_nsa_tracking_screen_off_mode"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    if-eqz v0, :cond_2

    const/4 v1, 0x1

    if-eq v0, v1, :cond_1

    const/4 v2, 0x2

    if-eq v0, v2, :cond_0

    .line 457
    invoke-virtual {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableHighPowerConsumptionIndications()Z

    move-result p0

    return p0

    :cond_0
    return v1

    .line 449
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getNrState()I

    move-result v0

    const/4 v2, 0x3

    if-ne v0, v2, :cond_2

    return v1

    .line 455
    :cond_2
    invoke-virtual {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableHighPowerConsumptionIndications()Z

    move-result p0

    return p0
.end method

.method private shouldEnablePhysicalChannelConfigReports()Z
    .locals 0

    .line 409
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableNrTrackingIndications()Z

    move-result p0

    return p0
.end method

.method private shouldEnableSignalStrengthReports()Z
    .locals 1

    .line 375
    invoke-virtual {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->shouldEnableHighPowerConsumptionIndications()Z

    move-result v0

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAlwaysSignalStrengthReportingEnabled:Z

    if-eqz v0, :cond_0

    iget-boolean p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsRadioOn:Z

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method


# virtual methods
.method public computeCellInfoMinInterval()I
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 350
    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsScreenOn:Z

    const/16 v1, 0x7d0

    if-eqz v0, :cond_0

    iget-boolean v2, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsWifiConnected:Z

    if-nez v2, :cond_0

    return v1

    :cond_0
    if-eqz v0, :cond_1

    .line 353
    iget-boolean p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsCharging:Z

    if-eqz p0, :cond_1

    return v1

    :cond_1
    const/16 p0, 0x2710

    return p0
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 810
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 811
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 812
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsTetheringOn="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsTetheringOn:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 813
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsScreenOn="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsScreenOn:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 814
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsCharging="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsCharging:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 815
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsPowerSaveOn="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsPowerSaveOn:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 816
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsLowDataExpected="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsLowDataExpected:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 817
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsAutomotiveProjectionActive="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAutomotiveProjectionActive:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 818
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mUnsolicitedResponseFilter="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mUnsolicitedResponseFilter:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 819
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsWifiConnected="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsWifiConnected:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 820
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsAlwaysSignalStrengthReportingEnabled="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAlwaysSignalStrengthReportingEnabled:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 822
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mIsRadioOn="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsRadioOn:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Local logs:"

    .line 823
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 824
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 825
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 826
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 827
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 828
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 479
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "handleMessage msg="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/DeviceStateMonitor;->log(Ljava/lang/String;Z)V

    .line 480
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v2, 0x1

    packed-switch v0, :pswitch_data_0

    .line 503
    new-instance p0, Ljava/lang/IllegalStateException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected message arrives. msg = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 489
    :pswitch_0
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/DeviceStateMonitor;->onUpdateDeviceState(IZ)V

    goto :goto_0

    .line 486
    :pswitch_1
    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/DeviceStateMonitor;->onUpdateDeviceState(IZ)V

    goto :goto_0

    .line 500
    :pswitch_2
    iget p1, p1, Landroid/os/Message;->arg1:I

    if-eqz p1, :cond_0

    move v1, v2

    :cond_0
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/DeviceStateMonitor;->onUpdateDeviceState(IZ)V

    goto :goto_0

    .line 497
    :pswitch_3
    iget p1, p1, Landroid/os/Message;->arg1:I

    if-eqz p1, :cond_1

    move v1, v2

    :cond_1
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/DeviceStateMonitor;->onUpdateDeviceState(IZ)V

    goto :goto_0

    .line 483
    :pswitch_4
    invoke-direct {p0}, Lcom/android/internal/telephony/DeviceStateMonitor;->onReset()V

    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_4
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_3
        :pswitch_4
        :pswitch_2
        :pswitch_3
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method protected isLowDataExpected()Z
    .locals 1

    .line 340
    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsCharging:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsTetheringOn:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsScreenOn:Z

    if-eqz v0, :cond_1

    :cond_0
    iget-boolean p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsRadioOn:Z

    if-nez p0, :cond_2

    :cond_1
    const/4 p0, 0x1

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public registerForPhysicalChannelConfigNotifChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 779
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 780
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhysicalChannelConfigRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    return-void
.end method

.method public setAlwaysReportSignalStrength(Z)V
    .locals 1

    const/16 v0, 0x8

    .line 467
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 468
    iput p1, v0, Landroid/os/Message;->arg1:I

    .line 469
    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public shouldEnableHighPowerConsumptionIndications()Z
    .locals 1

    .line 433
    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsCharging:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsScreenOn:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsTetheringOn:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsAutomotiveProjectionActive:Z

    if-eqz v0, :cond_1

    :cond_0
    iget-boolean p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mIsRadioOn:Z

    if-eqz p0, :cond_1

    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public unregisterForPhysicalChannelConfigNotifChanged(Landroid/os/Handler;)V
    .locals 0

    .line 788
    iget-object p0, p0, Lcom/android/internal/telephony/DeviceStateMonitor;->mPhysicalChannelConfigRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method
