.class Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;
.super Ljava/lang/Thread;
.source "MtkLocationExt.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->startUsingGpsWithTimeout(ILjava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

.field final synthetic val$milliseconds:I

.field final synthetic val$timeoutMsg:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;ILjava/lang/String;)V
    .locals 0

    .line 273
    iput-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    iput p2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;->val$milliseconds:I

    iput-object p3, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;->val$timeoutMsg:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Thread;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    const/4 v0, 0x1

    const/4 v1, 0x0

    .line 277
    :try_start_0
    iget v2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;->val$milliseconds:I

    int-to-long v2, v2

    invoke-static {v2, v3}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    move v2, v0

    goto :goto_0

    :catch_0
    move v2, v1

    .line 281
    :goto_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "isTimeout="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v4, "MtkLocationExt"

    invoke-static {v4, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-ne v2, v0, :cond_0

    .line 283
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 284
    iget-object v2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;->val$timeoutMsg:Ljava/lang/String;

    iput-object v2, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 285
    iget-object v2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {v2}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$fgetmGpsToastHandler(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/os/Handler;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 287
    :cond_0
    iget-object v0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {v0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$fgetmLocationManager(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/location/LocationManager;

    move-result-object v0

    iget-object v2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {v2}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$fgetmLocationListener(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/location/LocationListener;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/location/LocationManager;->removeUpdates(Landroid/location/LocationListener;)V

    .line 288
    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$3;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {p0, v1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$fputmIsGpsTimeSyncRunning(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;Z)V

    return-void
.end method
