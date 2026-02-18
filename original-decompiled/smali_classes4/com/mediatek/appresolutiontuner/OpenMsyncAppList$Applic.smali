.class Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;
.super Ljava/lang/Object;
.source "OpenMsyncAppList.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "Applic"
.end annotation


# instance fields
.field private packageName:Ljava/lang/String;

.field final synthetic this$0:Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;


# direct methods
.method constructor <init>(Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;)V
    .locals 0

    .line 111
    iput-object p1, p0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;->this$0:Lcom/mediatek/appresolutiontuner/OpenMsyncAppList;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getPackageName()Ljava/lang/String;
    .locals 0

    .line 115
    iget-object p0, p0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;->packageName:Ljava/lang/String;

    return-object p0
.end method

.method public setPackageName(Ljava/lang/String;)V
    .locals 0

    .line 119
    iput-object p1, p0, Lcom/mediatek/appresolutiontuner/OpenMsyncAppList$Applic;->packageName:Ljava/lang/String;

    return-void
.end method
