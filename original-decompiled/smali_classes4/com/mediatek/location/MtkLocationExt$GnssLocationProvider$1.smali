.class Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$1;
.super Landroid/content/BroadcastReceiver;
.source "MtkLocationExt.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->registerIntentReceiver()V
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

    .line 117
    iput-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$1;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 1

    .line 120
    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string p2, "android.intent.action.BOOT_COMPLETED"

    .line 121
    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 122
    iget-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$1;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {p1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$mgetGpsTimeSyncState(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Z

    move-result p1

    .line 123
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "BOOT_COMPLETED, GPS Time sync is set to "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string v0, "MtkLocationExt"

    invoke-static {v0, p2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 124
    iget-object p2, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$1;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {p2, p1}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$msetGpsTimeSyncFlag(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;Z)V

    .line 126
    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$1;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$fgetmGpsHandler(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/os/Handler;

    move-result-object p0

    const/4 p1, 0x5

    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    :cond_0
    return-void
.end method
