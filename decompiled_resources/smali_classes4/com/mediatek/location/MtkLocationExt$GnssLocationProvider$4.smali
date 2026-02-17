.class Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$4;
.super Landroid/os/Handler;
.source "MtkLocationExt.java"


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

    .line 294
    iput-object p1, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$4;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 1

    .line 296
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    .line 297
    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider$4;->this$0:Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;

    invoke-static {p0}, Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;->-$$Nest$fgetmContext(Lcom/mediatek/location/MtkLocationExt$GnssLocationProvider;)Landroid/content/Context;

    move-result-object p0

    const/4 v0, 0x1

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return-void
.end method
