.class public Lcom/mediatek/location/MtkLocationExt$LocationManagerService;
.super Ljava/lang/Object;
.source "MtkLocationExt.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/location/MtkLocationExt;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "LocationManagerService"
.end annotation


# instance fields
.field private final mContext:Landroid/content/Context;

.field private mCtaManager:Lcom/mediatek/cta/CtaManager;

.field private final mHandler:Landroid/os/Handler;

.field private mLocationManager:Landroid/location/LocationManager;


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/os/Handler;)V
    .locals 2

    .line 333
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string v0, "MtkLocationExt"

    const-string v1, "MtkLocationExt LocationManagerService()"

    .line 335
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 336
    iput-object p1, p0, Lcom/mediatek/location/MtkLocationExt$LocationManagerService;->mContext:Landroid/content/Context;

    .line 337
    iput-object p2, p0, Lcom/mediatek/location/MtkLocationExt$LocationManagerService;->mHandler:Landroid/os/Handler;

    .line 338
    invoke-static {}, Lcom/mediatek/cta/CtaManagerFactory;->getInstance()Lcom/mediatek/cta/CtaManagerFactory;

    move-result-object p2

    invoke-virtual {p2}, Lcom/mediatek/cta/CtaManagerFactory;->makeCtaManager()Lcom/mediatek/cta/CtaManager;

    move-result-object p2

    iput-object p2, p0, Lcom/mediatek/location/MtkLocationExt$LocationManagerService;->mCtaManager:Lcom/mediatek/cta/CtaManager;

    const-string p2, "location"

    .line 340
    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/location/LocationManager;

    iput-object p1, p0, Lcom/mediatek/location/MtkLocationExt$LocationManagerService;->mLocationManager:Landroid/location/LocationManager;

    return-void
.end method


# virtual methods
.method public isCtaFeatureSupport()Z
    .locals 0

    .line 344
    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$LocationManagerService;->mCtaManager:Lcom/mediatek/cta/CtaManager;

    invoke-virtual {p0}, Lcom/mediatek/cta/CtaManager;->isCtaSupported()Z

    move-result p0

    return p0
.end method

.method public printCtaLog(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 8

    .line 362
    sget-object v0, Lcom/mediatek/cta/CtaManager$ActionType;->USE_LOCATION:Lcom/mediatek/cta/CtaManager$ActionType;

    const-string v1, "USE_LOCATION"

    .line 363
    invoke-virtual {v1, p4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 364
    sget-object v0, Lcom/mediatek/cta/CtaManager$ActionType;->USE_LOCATION:Lcom/mediatek/cta/CtaManager$ActionType;

    goto :goto_0

    :cond_0
    const-string v1, "READ_LOCATION_INFO"

    .line 365
    invoke-virtual {v1, p4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p4

    if-eqz p4, :cond_1

    .line 366
    sget-object v0, Lcom/mediatek/cta/CtaManager$ActionType;->READ_LOCATION_INFO:Lcom/mediatek/cta/CtaManager$ActionType;

    :cond_1
    :goto_0
    move-object v6, v0

    .line 376
    iget-object v1, p0, Lcom/mediatek/location/MtkLocationExt$LocationManagerService;->mCtaManager:Lcom/mediatek/cta/CtaManager;

    sget-object v4, Lcom/mediatek/cta/CtaManager$KeywordType;->LOCATION:Lcom/mediatek/cta/CtaManager$KeywordType;

    move v2, p1

    move v3, p2

    move-object v5, p3

    move-object v7, p5

    invoke-virtual/range {v1 .. v7}, Lcom/mediatek/cta/CtaManager;->printCtaInfor(IILcom/mediatek/cta/CtaManager$KeywordType;Ljava/lang/String;Lcom/mediatek/cta/CtaManager$ActionType;Ljava/lang/String;)V

    return-void
.end method

.method public showNlpNotInstalledToast(Ljava/lang/String;)V
    .locals 3

    const-string v0, "MtkLocationExt"

    .line 382
    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "showNlpNotInstalledToast provider: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-string v1, "network"

    .line 383
    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 384
    iget-object p0, p0, Lcom/mediatek/location/MtkLocationExt$LocationManagerService;->mContext:Landroid/content/Context;

    const-string p1, "No Network Location Provider is installed!NLP is necessary for network location fixes."

    const/4 v1, 0x1

    invoke-static {p0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    .line 387
    invoke-virtual {p0}, Landroid/widget/Toast;->show()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "Failed to show toast "

    .line 390
    invoke-static {v0, p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_0
    :goto_0
    return-void
.end method
