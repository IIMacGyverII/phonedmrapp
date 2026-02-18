.class Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;
.super Landroid/database/ContentObserver;
.source "MtkLocationExt.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "GpsTimeSyncObserver"
.end annotation


# instance fields
.field private mHandler:Landroid/os/Handler;

.field private mMsg:I


# direct methods
.method constructor <init>(Landroid/os/Handler;I)V
    .locals 0

    .line 177
    invoke-direct {p0, p1}, Landroid/database/ContentObserver;-><init>(Landroid/os/Handler;)V

    .line 178
    iput-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;->mHandler:Landroid/os/Handler;

    .line 179
    iput p2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;->mMsg:I

    return-void
.end method


# virtual methods
.method observe(Landroid/content/Context;)V
    .locals 2

    .line 183
    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    const-string v0, "auto_time_gps"

    .line 185
    invoke-static {v0}, Landroid/provider/Settings$Global;->getUriFor(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    const/4 v1, 0x0

    .line 184
    invoke-virtual {p1, v0, v1, p0}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;)V

    return-void
.end method

.method public onChange(Z)V
    .locals 0

    .line 190
    iget-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;->mHandler:Landroid/os/Handler;

    iget p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$GpsTimeSyncObserver;->mMsg:I

    invoke-virtual {p1, p0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    return-void
.end method
