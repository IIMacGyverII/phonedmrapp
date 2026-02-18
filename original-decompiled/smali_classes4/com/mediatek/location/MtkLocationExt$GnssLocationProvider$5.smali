.class Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$5;
.super Ljava/lang/Object;
.source "MtkLocationExt.java"

# interfaces
.implements Landroid/location/LocationListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;


# direct methods
.method constructor <init>(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)V
    .locals 0

    .line 301
    iput-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$5;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onLocationChanged(Landroid/location/Location;)V
    .locals 0

    .line 304
    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$5;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$fgetmGpsTimerThread(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Ljava/lang/Thread;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Thread;->interrupt()V

    return-void
.end method

.method public onProviderDisabled(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method public onProviderEnabled(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method public onStatusChanged(Ljava/lang/String;ILandroid/os/Bundle;)V
    .locals 0

    return-void
.end method
