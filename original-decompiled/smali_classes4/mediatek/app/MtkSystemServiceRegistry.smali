.class public final Lmediatek/app/MtkSystemServiceRegistry;
.super Ljava/lang/Object;
.source "MtkSystemServiceRegistry.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "MtkSystemServiceRegistry"

.field private static sSystemServiceFetchers:Landroid/util/ArrayMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/ArrayMap<",
            "Ljava/lang/String;",
            "Landroid/app/SystemServiceRegistry$ServiceFetcher<",
            "*>;>;"
        }
    .end annotation
.end field

.field private static sSystemServiceNames:Landroid/util/ArrayMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/ArrayMap<",
            "Ljava/lang/Class<",
            "*>;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 56
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static registerAllService()V
    .locals 3

    const-string v0, "MtkSystemServiceRegistry"

    const-string v1, "registerAllService start"

    .line 60
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string v1, "Comment out registerService"

    .line 61
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 62
    const-class v0, Lcom/mediatek/search/SearchEngineManager;

    new-instance v1, Lmediatek/app/MtkSystemServiceRegistry$1;

    invoke-direct {v1}, Lmediatek/app/MtkSystemServiceRegistry$1;-><init>()V

    const-string v2, "search_engine_service"

    invoke-static {v2, v0, v1}, Lmediatek/app/MtkSystemServiceRegistry;->registerService(Ljava/lang/String;Ljava/lang/Class;Landroid/app/SystemServiceRegistry$ServiceFetcher;)V

    .line 69
    invoke-static {}, Lmediatek/app/MtkSystemServiceRegistry;->registerFmService()V

    .line 72
    invoke-static {}, Lmediatek/app/MtkSystemServiceRegistry;->registerOmadmService()V

    return-void
.end method

.method public static registerFmService()V
    .locals 4

    const-string v0, "com.mediatek.fmradio.FmRadioPackageManager"

    .line 97
    :try_start_0
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const-string v1, "getPackageName"

    const/4 v2, 0x0

    .line 99
    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    const/4 v1, 0x0

    new-array v3, v1, [Ljava/lang/Object;

    .line 100
    invoke-virtual {v0, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 101
    check-cast v0, Ljava/lang/String;

    .line 102
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/Class;

    .line 104
    const-class v3, Landroid/content/Context;

    aput-object v3, v2, v1

    const/4 v1, 0x1

    const-class v3, Landroid/os/Looper;

    aput-object v3, v2, v1

    .line 105
    invoke-virtual {v0, v2}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v0

    if-eqz v0, :cond_0

    const-string v1, "fm_radio_service"

    .line 107
    const-class v2, Ljava/util/Optional;

    new-instance v3, Lmediatek/app/MtkSystemServiceRegistry$2;

    invoke-direct {v3, v0}, Lmediatek/app/MtkSystemServiceRegistry$2;-><init>(Ljava/lang/reflect/Constructor;)V

    invoke-static {v1, v2, v3}, Lmediatek/app/MtkSystemServiceRegistry;->registerService(Ljava/lang/String;Ljava/lang/Class;Landroid/app/SystemServiceRegistry$ServiceFetcher;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const-string v0, "MtkSystemServiceRegistry"

    const-string v1, "Exception while getting FmRadioPackageManager class"

    .line 128
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    :goto_0
    return-void
.end method

.method public static registerOmadmService()V
    .locals 4

    const-string v0, "com.mediatek.common.omadm.OmadmManager"

    .line 136
    :try_start_0
    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Class;

    const/4 v2, 0x0

    .line 138
    const-class v3, Landroid/content/Context;

    aput-object v3, v1, v2

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v0

    if-eqz v0, :cond_0

    const-string v1, "omadm_service"

    .line 140
    const-class v2, Ljava/util/Optional;

    new-instance v3, Lmediatek/app/MtkSystemServiceRegistry$3;

    invoke-direct {v3, v0}, Lmediatek/app/MtkSystemServiceRegistry$3;-><init>(Ljava/lang/reflect/Constructor;)V

    invoke-static {v1, v2, v3}, Lmediatek/app/MtkSystemServiceRegistry;->registerService(Ljava/lang/String;Ljava/lang/Class;Landroid/app/SystemServiceRegistry$ServiceFetcher;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const-string v0, "MtkSystemServiceRegistry"

    const-string v1, "Exception while getting OmadmManager class"

    .line 160
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    :goto_0
    return-void
.end method

.method private static registerService(Ljava/lang/String;Ljava/lang/Class;Landroid/app/SystemServiceRegistry$ServiceFetcher;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Ljava/lang/String;",
            "Ljava/lang/Class<",
            "TT;>;",
            "Landroid/app/SystemServiceRegistry$ServiceFetcher<",
            "TT;>;)V"
        }
    .end annotation

    .line 89
    sget-object v0, Lmediatek/app/MtkSystemServiceRegistry;->sSystemServiceNames:Landroid/util/ArrayMap;

    invoke-virtual {v0, p1, p0}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 90
    sget-object p1, Lmediatek/app/MtkSystemServiceRegistry;->sSystemServiceFetchers:Landroid/util/ArrayMap;

    invoke-virtual {p1, p0, p2}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public static setMtkSystemServiceName(Landroid/util/ArrayMap;Landroid/util/ArrayMap;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/util/ArrayMap<",
            "Ljava/lang/Class<",
            "*>;",
            "Ljava/lang/String;",
            ">;",
            "Landroid/util/ArrayMap<",
            "Ljava/lang/String;",
            "Landroid/app/SystemServiceRegistry$ServiceFetcher<",
            "*>;>;)V"
        }
    .end annotation

    .line 78
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setMtkSystemServiceName start names"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ",fetchers"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "MtkSystemServiceRegistry"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 79
    sput-object p0, Lmediatek/app/MtkSystemServiceRegistry;->sSystemServiceNames:Landroid/util/ArrayMap;

    .line 80
    sput-object p1, Lmediatek/app/MtkSystemServiceRegistry;->sSystemServiceFetchers:Landroid/util/ArrayMap;

    return-void
.end method
