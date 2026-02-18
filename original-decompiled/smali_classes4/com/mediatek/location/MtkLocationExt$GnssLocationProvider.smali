.class public Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;
.super Ljava/lang/Object;
.source "MtkLocationExt.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/location/MtkLocationExt;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "GnssLocationProvider"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;,
        Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$MyHandler;
    }
.end annotation


# static fields
.field private static final EVENT_GPS_TIME_SYNC_CHANGED:I = 0x4

.field private static final EVENT_SEND_BLUESKY_BROADCAST:I = 0x5


# instance fields
.field private final mContext:Landroid/content/Context;

.field private mGpsHandler:Landroid/os/Handler;

.field private mGpsTimeSyncObserver:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;

.field private mGpsTimerThread:Ljava/lang/Thread;

.field private mGpsToastHandler:Landroid/os/Handler;

.field private final mHandler:Landroid/os/Handler;

.field private mIsGpsTimeSyncRunning:Z

.field private mLastLocation:Landroid/location/Location;

.field private mLocationListener:Landroid/location/LocationListener;

.field private mLocationManager:Landroid/location/LocationManager;

.field private mPassiveLocationListener:Landroid/location/LocationListener;


# direct methods
.method static bridge synthetic -$$Nest$fgetmContext(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/content/Context;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mContext:Landroid/content/Context;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmGpsHandler(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mGpsHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmGpsTimerThread(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Ljava/lang/Thread;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mGpsTimerThread:Ljava/lang/Thread;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmGpsToastHandler(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mGpsToastHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLocationListener(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/location/LocationListener;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mLocationListener:Landroid/location/LocationListener;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLocationManager(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/location/LocationManager;
    .locals 0

    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mLocationManager:Landroid/location/LocationManager;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmIsGpsTimeSyncRunning(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mIsGpsTimeSyncRunning:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$mdoSystemTimeSyncByGps(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;ZJ)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->doSystemTimeSyncByGps(ZJ)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mgetGpsTimeSyncState(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Z
    .locals 0

    invoke-direct {p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->getGpsTimeSyncState()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$msetGpsTimeSyncFlag(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;Z)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->setGpsTimeSyncFlag(Z)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/os/Handler;)V
    .locals 2

    .line 96
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 160
    iput-boolean v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mIsGpsTimeSyncRunning:Z

    .line 219
    new-instance v0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$2;

    invoke-direct {v0, p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$2;-><init>(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)V

    iput-object v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mPassiveLocationListener:Landroid/location/LocationListener;

    .line 294
    new-instance v0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$4;

    invoke-direct {v0, p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$4;-><init>(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)V

    iput-object v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mGpsToastHandler:Landroid/os/Handler;

    .line 301
    new-instance v0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$5;

    invoke-direct {v0, p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$5;-><init>(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)V

    iput-object v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mLocationListener:Landroid/location/LocationListener;

    const-string v0, "MtkLocationExt"

    const-string v1, "MtkLocationExt GnssLocationProvider()"

    .line 98
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 99
    iput-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mContext:Landroid/content/Context;

    .line 100
    iput-object p2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mHandler:Landroid/os/Handler;

    .line 102
    invoke-direct {p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->registerIntentReceiver()V

    const-string v1, "add GPS time sync handler and looper"

    .line 104
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 105
    new-instance v0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$MyHandler;

    invoke-virtual {p2}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object p2

    invoke-direct {v0, p0, p2}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$MyHandler;-><init>(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mGpsHandler:Landroid/os/Handler;

    const-string p2, "location"

    .line 108
    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/location/LocationManager;

    iput-object p2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mLocationManager:Landroid/location/LocationManager;

    .line 109
    new-instance p2, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;

    iget-object v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mGpsHandler:Landroid/os/Handler;

    const/4 v1, 0x4

    invoke-direct {p2, v0, v1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;-><init>(Landroid/os/Handler;I)V

    iput-object p2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mGpsTimeSyncObserver:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;

    .line 111
    invoke-virtual {p2, p1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;->observe(Landroid/content/Context;)V

    return-void
.end method

.method private doSystemTimeSyncByGps(ZJ)V
    .locals 4

    if-eqz p1, :cond_1

    .line 246
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, " ########## Auto-sync time with GPS: timestamp = "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v0, " ########## "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "MtkLocationExt"

    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 249
    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object p1

    .line 250
    invoke-virtual {p1, p2, p3}, Ljava/util/Calendar;->setTimeInMillis(J)V

    .line 251
    invoke-virtual {p1}, Ljava/util/Calendar;->getTimeInMillis()J

    move-result-wide p1

    const-wide/16 v0, 0x3e8

    .line 252
    div-long v0, p1, v0

    const-wide/32 v2, 0x7fffffff

    cmp-long p3, v0, v2

    if-gez p3, :cond_0

    .line 253
    invoke-static {p1, p2}, Landroid/os/SystemClock;->setCurrentTimeMillis(J)Z

    .line 255
    :cond_0
    iget-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mLocationManager:Landroid/location/LocationManager;

    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mPassiveLocationListener:Landroid/location/LocationListener;

    invoke-virtual {p1, p0}, Landroid/location/LocationManager;->removeUpdates(Landroid/location/LocationListener;)V

    :cond_1
    return-void
.end method

.method private getGpsTimeSyncState()Z
    .locals 2

    const/4 v0, 0x0

    .line 165
    :try_start_0
    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    const-string v1, "auto_time_gps"

    invoke-static {p0, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;)I

    move-result p0
    :try_end_0
    .catch Landroid/provider/Settings$SettingNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    if-lez p0, :cond_0

    const/4 v0, 0x1

    :catch_0
    :cond_0
    return v0
.end method

.method private registerIntentReceiver()V
    .locals 6

    .line 115
    new-instance v3, Landroid/content/IntentFilter;

    invoke-direct {v3}, Landroid/content/IntentFilter;-><init>()V

    const-string v0, "android.intent.action.BOOT_COMPLETED"

    .line 116
    invoke-virtual {v3, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 117
    iget-object v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mContext:Landroid/content/Context;

    new-instance v1, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$1;

    invoke-direct {v1, p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$1;-><init>(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)V

    sget-object v2, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    iget-object v5, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mHandler:Landroid/os/Handler;

    const/4 v4, 0x0

    invoke-virtual/range {v0 .. v5}, Landroid/content/Context;->registerReceiverAsUser(Landroid/content/BroadcastReceiver;Landroid/os/UserHandle;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;

    return-void
.end method

.method private setGpsTimeSyncFlag(Z)V
    .locals 8

    .line 208
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setGpsTimeSyncFlag: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MtkLocationExt"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz p1, :cond_0

    .line 211
    iget-object v2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mLocationManager:Landroid/location/LocationManager;

    const-wide/16 v4, 0x0

    const/4 v6, 0x0

    iget-object v7, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mPassiveLocationListener:Landroid/location/LocationListener;

    const-string v3, "passive"

    invoke-virtual/range {v2 .. v7}, Landroid/location/LocationManager;->requestLocationUpdates(Ljava/lang/String;JFLandroid/location/LocationListener;)V

    goto :goto_0

    .line 215
    :cond_0
    iget-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mLocationManager:Landroid/location/LocationManager;

    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mPassiveLocationListener:Landroid/location/LocationListener;

    invoke-virtual {p1, p0}, Landroid/location/LocationManager;->removeUpdates(Landroid/location/LocationListener;)V

    :goto_0
    return-void
.end method


# virtual methods
.method public onGpsTimeChanged(Z)V
    .locals 3

    if-eqz p1, :cond_0

    const v0, 0x2bf20

    .line 196
    iget-object v1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mContext:Landroid/content/Context;

    const v2, 0x80500ce

    .line 197
    invoke-virtual {v1, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v1

    .line 196
    invoke-virtual {p0, v0, v1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->startUsingGpsWithTimeout(ILjava/lang/String;)V

    goto :goto_0

    .line 199
    :cond_0
    iget-object v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mGpsTimerThread:Ljava/lang/Thread;

    if-eqz v0, :cond_1

    .line 200
    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    .line 203
    :cond_1
    :goto_0
    invoke-direct {p0, p1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->setGpsTimeSyncFlag(Z)V

    return-void
.end method

.method public startUsingGpsWithTimeout(ILjava/lang/String;)V
    .locals 8

    .line 262
    iget-boolean v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mIsGpsTimeSyncRunning:Z

    const-string v1, "MtkLocationExt"

    const/4 v2, 0x1

    if-ne v0, v2, :cond_0

    const-string p0, "WARNING: Gps Time Sync is already run"

    .line 263
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 266
    :cond_0
    iput-boolean v2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mIsGpsTimeSyncRunning:Z

    .line 269
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "start using GPS for GPS time sync timeout="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " timeoutMsg="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 271
    iget-object v2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mLocationManager:Landroid/location/LocationManager;

    const-wide/16 v4, 0x3e8

    const/4 v6, 0x0

    iget-object v7, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mLocationListener:Landroid/location/LocationListener;

    const-string v3, "gps"

    invoke-virtual/range {v2 .. v7}, Landroid/location/LocationManager;->requestLocationUpdates(Ljava/lang/String;JFLandroid/location/LocationListener;)V

    .line 273
    new-instance v0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;

    invoke-direct {v0, p0, p1, p2}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;-><init>(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;ILjava/lang/String;)V

    iput-object v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->mGpsTimerThread:Ljava/lang/Thread;

    .line 291
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method
