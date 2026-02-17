.class Lmediatek/app/MtkSystemServiceRegistry$1;
.super Landroid/app/SystemServiceRegistry$StaticServiceFetcher;
.source "MtkSystemServiceRegistry.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lmediatek/app/MtkSystemServiceRegistry;->registerAllService()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroid/app/SystemServiceRegistry$StaticServiceFetcher<",
        "Lcom/mediatek/search/SearchEngineManager;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 63
    invoke-direct {p0}, Landroid/app/SystemServiceRegistry$StaticServiceFetcher;-><init>()V

    return-void
.end method


# virtual methods
.method public createService()Lcom/mediatek/search/SearchEngineManager;
    .locals 0

    .line 66
    new-instance p0, Lcom/mediatek/search/SearchEngineManager;

    invoke-direct {p0}, Lcom/mediatek/search/SearchEngineManager;-><init>()V

    return-object p0
.end method

.method public bridge synthetic createService()Ljava/lang/Object;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/ServiceManager$ServiceNotFoundException;
        }
    .end annotation

    .line 63
    invoke-virtual {p0}, Lmediatek/app/MtkSystemServiceRegistry$1;->createService()Lcom/mediatek/search/SearchEngineManager;

    move-result-object p0

    return-object p0
.end method
