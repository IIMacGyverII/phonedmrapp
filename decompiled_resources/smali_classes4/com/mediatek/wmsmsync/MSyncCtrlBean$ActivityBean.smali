.class public Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;
.super Ljava/lang/Object;
.source "MSyncCtrlBean.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/wmsmsync/MSyncCtrlBean;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "ActivityBean"
.end annotation


# instance fields
.field private mFps:F

.field private mImeFps:F

.field private mName:Ljava/lang/String;

.field private mVoiceFps:F


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 103
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getFps()F
    .locals 0

    .line 136
    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mFps:F

    return p0
.end method

.method public getImeFps()F
    .locals 0

    .line 120
    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mImeFps:F

    return p0
.end method

.method public getName()Ljava/lang/String;
    .locals 0

    .line 128
    iget-object p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mName:Ljava/lang/String;

    return-object p0
.end method

.method public getVoiceFps()F
    .locals 0

    .line 144
    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mVoiceFps:F

    return p0
.end method

.method public setFps(F)V
    .locals 0

    .line 140
    iput p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mFps:F

    return-void
.end method

.method public setImeFps(F)V
    .locals 0

    .line 124
    iput p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mImeFps:F

    return-void
.end method

.method public setName(Ljava/lang/String;)V
    .locals 0

    .line 132
    iput-object p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mName:Ljava/lang/String;

    return-void
.end method

.method public setVoiceFps(F)V
    .locals 0

    .line 148
    iput p1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mVoiceFps:F

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 106
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "ActivityBean{name=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v1, ", fps="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mFps:F

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, ", imeFps="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mImeFps:F

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, ", voiceFps="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/mediatek/wmsmsync/MSyncCtrlBean$ActivityBean;->mVoiceFps:F

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
