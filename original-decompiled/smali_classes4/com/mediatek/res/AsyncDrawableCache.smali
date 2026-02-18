.class Lcom/mediatek/res/AsyncDrawableCache;
.super Ljava/lang/Object;
.source "AsyncDrawableCache.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "AsyncDrawableCache"

.field private static isDEBUG:Z = false

.field private static isPreloaded:Z = false

.field private static lock:Ljava/lang/Object; = null

.field private static mAsyncDrawableCache:Lcom/mediatek/res/AsyncDrawableCache; = null

.field private static final sClearCacheTime:J = 0x2710L

.field private static final sDefResolution:Ljava/lang/String; = "720"

.field private static final sDrawableCache:Landroid/util/ArrayMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/ArrayMap<",
            "Ljava/lang/Long;",
            "Landroid/graphics/drawable/Drawable$ConstantState;",
            ">;"
        }
    .end annotation
.end field

.field private static sFeatureConfig:Ljava/lang/String; = null

.field private static final sPerfName:Ljava/lang/String; = "perf_img_scale"

.field private static sPreloadList:Ljava/util/ArrayList; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static sResolution:Ljava/lang/String; = null

.field private static final sResolutionEnableProp:Ljava/lang/String; = "ro.vendor.pref_scale_enable_cfg"

.field private static sResolutionList:Landroid/util/ArrayMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/ArrayMap<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$ac_r_7YgOMlJFsFlbAW5-E7gx9I(Landroid/content/SharedPreferences;Landroid/content/Context;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/mediatek/res/AsyncDrawableCache;->lambda$preloadRes$0(Landroid/content/SharedPreferences;Landroid/content/Context;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mclearCache(Lcom/mediatek/res/AsyncDrawableCache;)V
    .locals 0

    invoke-direct {p0}, Lcom/mediatek/res/AsyncDrawableCache;->clearCache()V

    return-void
.end method

.method static bridge synthetic -$$Nest$sfputisPreloaded(Z)V
    .locals 0

    sput-boolean p0, Lcom/mediatek/res/AsyncDrawableCache;->isPreloaded:Z

    return-void
.end method

.method static constructor <clinit>()V
    .locals 2

    .line 59
    new-instance v0, Lcom/mediatek/res/AsyncDrawableCache$1;

    invoke-direct {v0}, Lcom/mediatek/res/AsyncDrawableCache$1;-><init>()V

    sput-object v0, Lcom/mediatek/res/AsyncDrawableCache;->sPreloadList:Ljava/util/ArrayList;

    const/4 v0, 0x0

    .line 66
    sput-object v0, Lcom/mediatek/res/AsyncDrawableCache;->mAsyncDrawableCache:Lcom/mediatek/res/AsyncDrawableCache;

    const-string v0, "ro.vendor.pref_scale_enable_cfg"

    const-string v1, "1"

    .line 69
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/mediatek/res/AsyncDrawableCache;->sFeatureConfig:Ljava/lang/String;

    const-string v0, "720"

    .line 71
    sput-object v0, Lcom/mediatek/res/AsyncDrawableCache;->sResolution:Ljava/lang/String;

    .line 72
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    sput-object v0, Lcom/mediatek/res/AsyncDrawableCache;->sDrawableCache:Landroid/util/ArrayMap;

    .line 74
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    sput-object v0, Lcom/mediatek/res/AsyncDrawableCache;->sResolutionList:Landroid/util/ArrayMap;

    const/4 v0, 0x0

    .line 77
    sput-boolean v0, Lcom/mediatek/res/AsyncDrawableCache;->isPreloaded:Z

    .line 79
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/res/AsyncDrawableCache;->lock:Ljava/lang/Object;

    return-void
.end method

.method constructor <init>()V
    .locals 2

    .line 81
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 82
    sget-object p0, Lcom/mediatek/res/AsyncDrawableCache;->sResolutionList:Landroid/util/ArrayMap;

    const v0, 0x4b000

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    const-string v1, "480"

    invoke-virtual {p0, v1, v0}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 83
    sget-object p0, Lcom/mediatek/res/AsyncDrawableCache;->sResolutionList:Landroid/util/ArrayMap;

    const v0, 0xe1000

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    const-string v1, "720"

    invoke-virtual {p0, v1, v0}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 84
    sget-object p0, Lcom/mediatek/res/AsyncDrawableCache;->sResolutionList:Landroid/util/ArrayMap;

    const v0, 0x1fa400

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    const-string v1, "1080"

    invoke-virtual {p0, v1, v0}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method private clearCache()V
    .locals 3

    .line 283
    sget-object p0, Lcom/mediatek/res/AsyncDrawableCache;->sDrawableCache:Landroid/util/ArrayMap;

    if-eqz p0, :cond_0

    .line 284
    invoke-virtual {p0}, Landroid/util/ArrayMap;->size()I

    move-result v0

    if-eqz v0, :cond_0

    .line 285
    sget-object v0, Lcom/mediatek/res/AsyncDrawableCache;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 286
    :try_start_0
    invoke-virtual {p0}, Landroid/util/ArrayMap;->clear()V

    .line 287
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    .line 290
    :cond_0
    :goto_0
    sget-boolean v0, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    if-eqz v0, :cond_1

    const-string v0, "AsyncDrawableCache"

    .line 291
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "clearCache, cache size:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/util/ArrayMap;->size()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    return-void
.end method

.method private clearCacheAfterPreload()V
    .locals 4

    .line 296
    sget-boolean v0, Lcom/mediatek/res/AsyncDrawableCache;->isPreloaded:Z

    if-eqz v0, :cond_0

    .line 297
    new-instance v0, Ljava/util/Timer;

    invoke-direct {v0}, Ljava/util/Timer;-><init>()V

    .line 298
    new-instance v1, Lcom/mediatek/res/AsyncDrawableCache$2;

    invoke-direct {v1, p0}, Lcom/mediatek/res/AsyncDrawableCache$2;-><init>(Lcom/mediatek/res/AsyncDrawableCache;)V

    const-wide/16 v2, 0x2710

    invoke-virtual {v0, v1, v2, v3}, Ljava/util/Timer;->schedule(Ljava/util/TimerTask;J)V

    :cond_0
    return-void
.end method

.method static getInstance()Lcom/mediatek/res/AsyncDrawableCache;
    .locals 2

    .line 88
    sget-object v0, Lcom/mediatek/res/AsyncDrawableCache;->mAsyncDrawableCache:Lcom/mediatek/res/AsyncDrawableCache;

    if-nez v0, :cond_1

    .line 89
    const-class v0, Lcom/mediatek/res/AsyncDrawableCache;

    monitor-enter v0

    .line 90
    :try_start_0
    sget-object v1, Lcom/mediatek/res/AsyncDrawableCache;->mAsyncDrawableCache:Lcom/mediatek/res/AsyncDrawableCache;

    if-nez v1, :cond_0

    .line 91
    new-instance v1, Lcom/mediatek/res/AsyncDrawableCache;

    invoke-direct {v1}, Lcom/mediatek/res/AsyncDrawableCache;-><init>()V

    sput-object v1, Lcom/mediatek/res/AsyncDrawableCache;->mAsyncDrawableCache:Lcom/mediatek/res/AsyncDrawableCache;

    .line 93
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 95
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/res/AsyncDrawableCache;->mAsyncDrawableCache:Lcom/mediatek/res/AsyncDrawableCache;

    return-object v0
.end method

.method private isEnableFeature()Z
    .locals 3

    .line 259
    sget-object p0, Lcom/mediatek/res/AsyncDrawableCache;->sFeatureConfig:Ljava/lang/String;

    const-string v0, "0"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    const/4 v0, 0x1

    const/4 v1, 0x0

    if-eqz p0, :cond_1

    .line 261
    sput-boolean v1, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    :cond_0
    move v0, v1

    goto :goto_0

    .line 262
    :cond_1
    sget-object p0, Lcom/mediatek/res/AsyncDrawableCache;->sFeatureConfig:Ljava/lang/String;

    const-string v2, "1"

    invoke-virtual {p0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_2

    .line 264
    sput-boolean v1, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    goto :goto_0

    .line 265
    :cond_2
    sget-object p0, Lcom/mediatek/res/AsyncDrawableCache;->sFeatureConfig:Ljava/lang/String;

    const-string v2, "2"

    invoke-virtual {p0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    .line 267
    sput-boolean v0, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    :goto_0
    return v0
.end method

.method private isUserUnlocked(Landroid/content/Context;)Z
    .locals 0

    const-string/jumbo p0, "user"

    .line 274
    invoke-virtual {p1, p0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/os/UserManager;

    .line 275
    invoke-virtual {p0}, Landroid/os/UserManager;->isUserUnlocked()Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method private static synthetic lambda$preloadRes$0(Landroid/content/SharedPreferences;Landroid/content/Context;)V
    .locals 4

    .line 126
    invoke-interface {p0}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object p0

    .line 127
    invoke-interface {p0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    const-string v1, "AsyncDrawableCache"

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    .line 128
    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 129
    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 131
    sget-boolean v2, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    if-eqz v2, :cond_0

    .line 132
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "resource="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ", res obj="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 133
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getImpl()Landroid/content/res/ResourcesImpl;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 132
    invoke-static {v1, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 136
    :cond_0
    :try_start_0
    invoke-virtual {p1, v0}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;
    :try_end_0
    .catch Landroid/content/res/Resources$NotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 138
    :catch_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "can not found res: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ", maybe dynamic res id."

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 141
    :cond_1
    sget-boolean p0, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    if-eqz p0, :cond_2

    const-string p0, "preloadRes, end of preloadRes"

    .line 142
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    return-void
.end method

.method private needCacheDrawable(Landroid/graphics/drawable/Drawable;)Z
    .locals 2

    .line 221
    sget-object p0, Lcom/mediatek/res/AsyncDrawableCache;->sResolutionList:Landroid/util/ArrayMap;

    sget-object v0, Lcom/mediatek/res/AsyncDrawableCache;->sResolution:Ljava/lang/String;

    invoke-virtual {p0, v0}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    .line 222
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getMinimumWidth()I

    move-result v0

    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getMinimumHeight()I

    move-result p1

    mul-int/2addr v0, p1

    .line 223
    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p1

    if-lt v0, p1, :cond_1

    .line 224
    sget-boolean p1, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    if-eqz p1, :cond_0

    .line 225
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "computeResolution, drResolution:"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ", scaleResolution:"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "AsyncDrawableCache"

    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private storeDrawableId(ILandroid/content/Context;)V
    .locals 2

    const-string v0, "AsyncDrawableCache"

    if-nez p2, :cond_0

    .line 235
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p2, "storeDrawableId got the context is null, id:"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " cannot save"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 240
    :cond_0
    invoke-direct {p0, p2}, Lcom/mediatek/res/AsyncDrawableCache;->isUserUnlocked(Landroid/content/Context;)Z

    move-result p0

    if-nez p0, :cond_1

    return-void

    :cond_1
    const/4 p0, 0x0

    const-string v1, "perf_img_scale"

    .line 244
    invoke-virtual {p2, v1, p0}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    if-eqz p0, :cond_2

    .line 246
    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p2

    invoke-interface {p0, p2}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result p2

    if-nez p2, :cond_2

    .line 247
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 248
    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p2

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 249
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 250
    sget-boolean p0, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    if-eqz p0, :cond_2

    .line 251
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p2, "storeDrawableId, id:"

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    return-void
.end method


# virtual methods
.method getCachedDrawable(Landroid/content/res/Resources;JI)Landroid/graphics/drawable/Drawable;
    .locals 1

    .line 157
    invoke-direct {p0}, Lcom/mediatek/res/AsyncDrawableCache;->isEnableFeature()Z

    move-result p0

    const/4 p4, 0x0

    if-nez p0, :cond_0

    return-object p4

    .line 162
    :cond_0
    sget-object p0, Lcom/mediatek/res/AsyncDrawableCache;->lock:Ljava/lang/Object;

    monitor-enter p0

    .line 163
    :try_start_0
    sget-object v0, Lcom/mediatek/res/AsyncDrawableCache;->sDrawableCache:Landroid/util/ArrayMap;

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p2

    invoke-virtual {v0, p2}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/graphics/drawable/Drawable$ConstantState;

    .line 164
    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz p2, :cond_1

    .line 167
    invoke-virtual {p2, p1}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable(Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    return-object p0

    :cond_1
    return-object p4

    :catchall_0
    move-exception p1

    .line 164
    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method preloadRes(Landroid/content/Context;Landroid/content/res/Resources;)V
    .locals 1

    .line 107
    invoke-direct {p0}, Lcom/mediatek/res/AsyncDrawableCache;->isEnableFeature()Z

    move-result p2

    if-nez p2, :cond_0

    return-void

    .line 111
    :cond_0
    invoke-virtual {p0, p1}, Lcom/mediatek/res/AsyncDrawableCache;->skipPreload(Landroid/content/Context;)Z

    move-result p2

    if-eqz p2, :cond_1

    return-void

    .line 115
    :cond_1
    invoke-direct {p0, p1}, Lcom/mediatek/res/AsyncDrawableCache;->isUserUnlocked(Landroid/content/Context;)Z

    move-result p2

    if-nez p2, :cond_2

    return-void

    :cond_2
    const/4 p2, 0x0

    const-string v0, "perf_img_scale"

    .line 119
    invoke-virtual {p1, v0, p2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p2

    if-eqz p2, :cond_4

    .line 120
    invoke-interface {p2}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Map;->size()I

    move-result v0

    if-nez v0, :cond_3

    goto :goto_0

    :cond_3
    const/4 v0, 0x1

    .line 124
    sput-boolean v0, Lcom/mediatek/res/AsyncDrawableCache;->isPreloaded:Z

    .line 125
    new-instance v0, Lcom/mediatek/res/AsyncDrawableCache$$ExternalSyntheticLambda0;

    invoke-direct {v0, p2, p1}, Lcom/mediatek/res/AsyncDrawableCache$$ExternalSyntheticLambda0;-><init>(Landroid/content/SharedPreferences;Landroid/content/Context;)V

    invoke-static {v0}, Landroid/os/AsyncTask;->execute(Ljava/lang/Runnable;)V

    .line 146
    invoke-direct {p0}, Lcom/mediatek/res/AsyncDrawableCache;->clearCacheAfterPreload()V

    :cond_4
    :goto_0
    return-void
.end method

.method putCacheList(JLandroid/graphics/drawable/Drawable;ILandroid/content/Context;)V
    .locals 3

    .line 181
    invoke-direct {p0}, Lcom/mediatek/res/AsyncDrawableCache;->isEnableFeature()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 185
    :cond_0
    invoke-virtual {p0, p5}, Lcom/mediatek/res/AsyncDrawableCache;->skipPreload(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 189
    :cond_1
    invoke-virtual {p5}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v0

    iget-object v0, v0, Landroid/content/pm/ApplicationInfo;->processName:Ljava/lang/String;

    const-string/jumbo v1, "system"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_6

    .line 190
    invoke-virtual {p5}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/pm/ApplicationInfo;->isSystemApp()Z

    move-result v0

    if-eqz v0, :cond_2

    goto/16 :goto_1

    .line 195
    :cond_2
    sget-object v0, Lcom/mediatek/res/AsyncDrawableCache;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 196
    :try_start_0
    sget-object v1, Lcom/mediatek/res/AsyncDrawableCache;->sDrawableCache:Landroid/util/ArrayMap;

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/graphics/drawable/Drawable$ConstantState;

    .line 197
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    if-nez v2, :cond_5

    .line 199
    invoke-direct {p0, p3}, Lcom/mediatek/res/AsyncDrawableCache;->needCacheDrawable(Landroid/graphics/drawable/Drawable;)Z

    move-result v0

    if-eqz v0, :cond_5

    .line 200
    sget-boolean v0, Lcom/mediatek/res/AsyncDrawableCache;->isPreloaded:Z

    if-eqz v0, :cond_3

    .line 201
    sget-object v0, Lcom/mediatek/res/AsyncDrawableCache;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 202
    :try_start_1
    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    invoke-virtual {p3}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object p3

    invoke-virtual {v1, v2, p3}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 203
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 204
    sget-boolean p3, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    if-eqz p3, :cond_3

    const-string p3, "AsyncDrawableCache"

    .line 205
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "putCacheList, put cache, size:"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Landroid/util/ArrayMap;->size()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p3, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :catchall_0
    move-exception p0

    .line 203
    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0

    .line 209
    :cond_3
    :goto_0
    sget-boolean p3, Lcom/mediatek/res/AsyncDrawableCache;->isDEBUG:Z

    if-eqz p3, :cond_4

    const-string p3, "AsyncDrawableCache"

    .line 210
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "putCacheList, key:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p1, ", origResId:"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p3, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 212
    :cond_4
    invoke-direct {p0, p4, p5}, Lcom/mediatek/res/AsyncDrawableCache;->storeDrawableId(ILandroid/content/Context;)V

    :cond_5
    return-void

    :catchall_1
    move-exception p0

    .line 197
    :try_start_3
    monitor-exit v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    throw p0

    :cond_6
    :goto_1
    return-void
.end method

.method skipPreload(Landroid/content/Context;)Z
    .locals 1

    const/4 p0, 0x1

    if-nez p1, :cond_0

    return p0

    .line 102
    :cond_0
    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_2

    .line 103
    sget-object v0, Lcom/mediatek/res/AsyncDrawableCache;->sPreloadList:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :cond_2
    :goto_0
    return p0
.end method
