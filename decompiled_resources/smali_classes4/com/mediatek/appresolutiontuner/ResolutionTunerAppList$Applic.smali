.class public Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;
.super Ljava/lang/Object;
.source "ResolutionTunerAppList.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Applic"
.end annotation


# instance fields
.field private filteredWindows:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private packageName:Ljava/lang/String;

.field private scale:F

.field private scaleHeight:F

.field private scaleWidth:F

.field private scalingFlow:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 195
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 200
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->filteredWindows:Ljava/util/ArrayList;

    const-string v0, ""

    .line 201
    iput-object v0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scalingFlow:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public addFilteredWindow(Ljava/lang/String;)V
    .locals 0

    .line 241
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->filteredWindows:Ljava/util/ArrayList;

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public getPackageName()Ljava/lang/String;
    .locals 0

    .line 204
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->packageName:Ljava/lang/String;

    return-object p0
.end method

.method public getScale()F
    .locals 0

    .line 212
    iget p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scale:F

    return p0
.end method

.method public getScaleHeight()F
    .locals 0

    .line 233
    iget p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scaleHeight:F

    return p0
.end method

.method public getScaleWidth()F
    .locals 0

    .line 225
    iget p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scaleWidth:F

    return p0
.end method

.method public getScalingFlow()Ljava/lang/String;
    .locals 0

    .line 249
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scalingFlow:Ljava/lang/String;

    return-object p0
.end method

.method public isFiltered(Ljava/lang/String;)Z
    .locals 0

    .line 245
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->filteredWindows:Ljava/util/ArrayList;

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method public isGameFlow()Z
    .locals 1

    .line 257
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scalingFlow:Ljava/lang/String;

    const-string v0, "game"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method public setPackageName(Ljava/lang/String;)V
    .locals 0

    .line 208
    iput-object p1, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->packageName:Ljava/lang/String;

    return-void
.end method

.method public setScale(F)V
    .locals 0

    .line 216
    iput p1, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scale:F

    return-void
.end method

.method public setScale(FF)V
    .locals 0

    .line 220
    iput p1, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scaleWidth:F

    .line 221
    iput p2, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scaleHeight:F

    return-void
.end method

.method public setScaleHeight(F)V
    .locals 0

    .line 237
    iput p1, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scaleHeight:F

    return-void
.end method

.method public setScaleWidth(F)V
    .locals 0

    .line 229
    iput p1, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scaleWidth:F

    return-void
.end method

.method public setScalingFlow(Ljava/lang/String;)V
    .locals 0

    .line 253
    iput-object p1, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scalingFlow:Ljava/lang/String;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 262
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "App{packageName=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->packageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x27

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", scale=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scale:F

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", scaleWidth=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scaleWidth:F

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", scaleHeight=\'"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scaleHeight:F

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", filteredWindows= "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->filteredWindows:Ljava/util/ArrayList;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const-string v2, ", scalingFlow= "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/ResolutionTunerAppList$Applic;->scalingFlow:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    const/16 p0, 0x7d

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
