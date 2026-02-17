.class public Lcom/mediatek/search/SearchEngineManager;
.super Ljava/lang/Object;
.source "SearchEngineManager.java"


# static fields
.field public static final ACTION_SEARCH_ENGINE_CHANGED:Ljava/lang/String; = "com.mediatek.search.SEARCH_ENGINE_CHANGED"

.field private static final DBG:Z = false

.field public static final SEARCH_ENGINE_SERVICE:Ljava/lang/String; = "search_engine_service"

.field private static final TAG:Ljava/lang/String; = "SearchEngineManager"

.field private static mService:Lcom/mediatek/search/ISearchEngineManagerService;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 105
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string p0, "search_engine_service"

    .line 107
    invoke-static {p0}, Landroid/os/ServiceManager;->getService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object p0

    .line 106
    invoke-static {p0}, Lcom/mediatek/search/ISearchEngineManagerService$Stub;->asInterface(Landroid/os/IBinder;)Lcom/mediatek/search/ISearchEngineManagerService;

    move-result-object p0

    sput-object p0, Lcom/mediatek/search/SearchEngineManager;->mService:Lcom/mediatek/search/ISearchEngineManagerService;

    return-void
.end method


# virtual methods
.method public getAvailables()Ljava/util/List;
    .locals 2
    .annotation build Landroid/annotation/ProductApi;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/mediatek/common/search/SearchEngine;",
            ">;"
        }
    .end annotation

    .line 118
    :try_start_0
    sget-object p0, Lcom/mediatek/search/SearchEngineManager;->mService:Lcom/mediatek/search/ISearchEngineManagerService;

    invoke-interface {p0}, Lcom/mediatek/search/ISearchEngineManagerService;->getAvailables()Ljava/util/List;

    move-result-object p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 120
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getSearchEngineInfos() failed: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "SearchEngineManager"

    invoke-static {v0, p0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return-object p0
.end method

.method public getBestMatch(Ljava/lang/String;Ljava/lang/String;)Lcom/mediatek/common/search/SearchEngine;
    .locals 0
    .annotation build Landroid/annotation/ProductApi;
    .end annotation

    .line 136
    :try_start_0
    sget-object p0, Lcom/mediatek/search/SearchEngineManager;->mService:Lcom/mediatek/search/ISearchEngineManagerService;

    invoke-interface {p0, p1, p2}, Lcom/mediatek/search/ISearchEngineManagerService;->getBestMatch(Ljava/lang/String;Ljava/lang/String;)Lcom/mediatek/common/search/SearchEngine;

    move-result-object p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 138
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "getBestMatch() failed: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "SearchEngineManager"

    invoke-static {p1, p0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return-object p0
.end method

.method public getByFavicon(Ljava/lang/String;)Lcom/mediatek/common/search/SearchEngine;
    .locals 1

    const/4 v0, 0x2

    .line 150
    invoke-virtual {p0, v0, p1}, Lcom/mediatek/search/SearchEngineManager;->getSearchEngine(ILjava/lang/String;)Lcom/mediatek/common/search/SearchEngine;

    move-result-object p0

    return-object p0
.end method

.method public getByName(Ljava/lang/String;)Lcom/mediatek/common/search/SearchEngine;
    .locals 1
    .annotation build Landroid/annotation/ProductApi;
    .end annotation

    const/4 v0, -0x1

    .line 161
    invoke-virtual {p0, v0, p1}, Lcom/mediatek/search/SearchEngineManager;->getSearchEngine(ILjava/lang/String;)Lcom/mediatek/common/search/SearchEngine;

    move-result-object p0

    return-object p0
.end method

.method public getDefault()Lcom/mediatek/common/search/SearchEngine;
    .locals 2
    .annotation build Landroid/annotation/ProductApi;
    .end annotation

    .line 188
    :try_start_0
    sget-object p0, Lcom/mediatek/search/SearchEngineManager;->mService:Lcom/mediatek/search/ISearchEngineManagerService;

    invoke-interface {p0}, Lcom/mediatek/search/ISearchEngineManagerService;->getDefault()Lcom/mediatek/common/search/SearchEngine;

    move-result-object p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 190
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getSystemDefaultSearchEngine() failed: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "SearchEngineManager"

    invoke-static {v0, p0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return-object p0
.end method

.method public getSearchEngine(ILjava/lang/String;)Lcom/mediatek/common/search/SearchEngine;
    .locals 0

    .line 173
    :try_start_0
    sget-object p0, Lcom/mediatek/search/SearchEngineManager;->mService:Lcom/mediatek/search/ISearchEngineManagerService;

    invoke-interface {p0, p1, p2}, Lcom/mediatek/search/ISearchEngineManagerService;->getSearchEngine(ILjava/lang/String;)Lcom/mediatek/common/search/SearchEngine;

    move-result-object p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 175
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "getSearchEngine(int field, String value) failed: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "SearchEngineManager"

    invoke-static {p1, p0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return-object p0
.end method

.method public setDefault(Lcom/mediatek/common/search/SearchEngine;)Z
    .locals 1

    .line 203
    :try_start_0
    sget-object p0, Lcom/mediatek/search/SearchEngineManager;->mService:Lcom/mediatek/search/ISearchEngineManagerService;

    invoke-interface {p0, p1}, Lcom/mediatek/search/ISearchEngineManagerService;->setDefault(Lcom/mediatek/common/search/SearchEngine;)Z

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    :catch_0
    move-exception p0

    .line 205
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "getSystemDefaultSearchEngine() failed: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "SearchEngineManager"

    invoke-static {p1, p0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return p0
.end method
