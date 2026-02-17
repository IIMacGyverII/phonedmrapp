.class public Lcom/mediatek/wmsmsync/MSyncCtrlBean;
.super Ljava/lang/Object;
.source "MSyncCtrlBean.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;
    }
.end annotation


# instance fields
.field private mActivityBeans:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;",
            ">;"
        }
    .end annotation
.end field

.field private mFps:F

.field private mImeFps:F

.field private mPackageName:Ljava/lang/String;

.field private mSlideResponse:Z

.field private mVoiceFps:F


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 44
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getActivityBeans()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;",
            ">;"
        }
    .end annotation

    .line 61
    iget-object v0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mActivityBeans:Ljava/util/List;

    if-nez v0, :cond_0

    .line 62
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mActivityBeans:Ljava/util/List;

    .line 64
    :cond_0
    iget-object p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mActivityBeans:Ljava/util/List;

    return-object p0
.end method

.method public getFps()F
    .locals 0

    .line 88
    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mFps:F

    return p0
.end method

.method public getImeFps()F
    .locals 0

    .line 72
    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mImeFps:F

    return p0
.end method

.method public getPackageName()Ljava/lang/String;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mPackageName:Ljava/lang/String;

    return-object p0
.end method

.method public getVoiceFps()F
    .locals 0

    .line 96
    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mVoiceFps:F

    return p0
.end method

.method public isSlideResponse()Z
    .locals 0

    .line 80
    iget-boolean p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mSlideResponse:Z

    return p0
.end method

.method public setActivityBeans(Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;",
            ">;)V"
        }
    .end annotation

    .line 68
    iput-object p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mActivityBeans:Ljava/util/List;

    return-void
.end method

.method public setFps(F)V
    .locals 0

    .line 92
    iput p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mFps:F

    return-void
.end method

.method public setImeFps(F)V
    .locals 0

    .line 76
    iput p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mImeFps:F

    return-void
.end method

.method public setPackageName(Ljava/lang/String;)V
    .locals 0

    .line 57
    iput-object p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mPackageName:Ljava/lang/String;

    return-void
.end method

.method public setSlideResponse(Z)V
    .locals 0

    .line 84
    iput-boolean p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mSlideResponse:Z

    return-void
.end method

.method public setVoiceFps(F)V
    .locals 0

    .line 100
    iput p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mVoiceFps:F

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 154
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "MSyncCtrlTableBean{packageName=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mPackageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v1, ", activityBeans="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mActivityBeans:Ljava/util/List;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", slideResponse="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mSlideResponse:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", defaultFps="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mFps:F

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, ", imeFps="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mImeFps:F

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, ", voiceFps="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean;->mVoiceFps:F

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
