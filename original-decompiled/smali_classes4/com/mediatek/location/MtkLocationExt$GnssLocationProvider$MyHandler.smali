.class Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$MyHandler;
.super Landroid/os/Handler;
.source "MtkLocationExt.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "MyHandler"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;


# direct methods
.method public constructor <init>(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;Landroid/os/Looper;)V
    .locals 0

    .line 134
    iput-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$MyHandler;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    .line 135
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 140
    iget p1, p1, Landroid/os/Message;->what:I

    const/4 v0, 0x4

    const-string v1, "MtkLocationExt"

    if-eq p1, v0, :cond_1

    const/4 v0, 0x5

    if-eq p1, v0, :cond_0

    goto :goto_0

    .line 149
    :cond_0
    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$MyHandler;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$fgetmContext(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/location/BlueskyUtility;->sendBlueskyBroadcast(Landroid/content/Context;)V

    const-string p0, "Finish Bluesky broadcast"

    .line 150
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 142
    :cond_1
    iget-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$MyHandler;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {p1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$mgetGpsTimeSyncState(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Z

    move-result p1

    .line 144
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "GPS Time sync is changed to "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 146
    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$MyHandler;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-virtual {p0, p1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->onGpsTimeChanged(Z)V

    :goto_0
    return-void
.end method
