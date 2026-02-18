.class public Lcom/mediatek/view/impl/MsyncExtimpl;
.super Lcom/mediatek/view/MsyncExt;
.source "MsyncExtimpl.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "MsyncExt"


# instance fields
.field private mIsContainPackageName:Z

.field private mPackageName:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 21
    invoke-direct {p0}, Lcom/mediatek/view/MsyncExt;-><init>()V

    const/4 v0, 0x0

    .line 19
    iput-boolean v0, p0, Lcom/mediatek/view/impl/MsyncExtimpl;->mIsContainPackageName:Z

    .line 22
    invoke-static {}, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->getInstance()Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;

    move-result-object v0

    invoke-virtual {v0}, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->isRead()Z

    move-result v0

    if-nez v0, :cond_0

    .line 23
    invoke-direct {p0}, Lcom/mediatek/view/impl/MsyncExtimpl;->openNewTread()V

    :cond_0
    return-void
.end method

.method private openNewTread()V
    .locals 1

    .line 28
    new-instance v0, Lcom/mediatek/view/impl/MsyncExtimpl$1;

    invoke-direct {v0, p0}, Lcom/mediatek/view/impl/MsyncExtimpl$1;-><init>(Lcom/mediatek/view/impl/MsyncExtimpl;)V

    .line 32
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method


# virtual methods
.method public isOpenMsyncPackage(Ljava/lang/String;)Z
    .locals 1

    .line 38
    invoke-static {}, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->getInstance()Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;->isScaledBySurfaceView(Ljava/lang/String;)Z

    move-result p1

    iput-boolean p1, p0, Lcom/mediatek/view/impl/MsyncExtimpl;->mIsContainPackageName:Z

    return p1
.end method
