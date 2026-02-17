.class public Lcom/mediatek/res/ResOptExtImpl;
.super Lcom/mediatek/res/ResOptExt;
.source "ResOptExtImpl.java"


# static fields
.field private static lock:Ljava/lang/Object;

.field private static sInstance:Lcom/mediatek/res/ResOptExtImpl;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 47
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/res/ResOptExtImpl;->lock:Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 44
    invoke-direct {p0}, Lcom/mediatek/res/ResOptExt;-><init>()V

    return-void
.end method

.method public static getInstance()Lcom/mediatek/res/ResOptExtImpl;
    .locals 2

    .line 50
    sget-object v0, Lcom/mediatek/res/ResOptExtImpl;->sInstance:Lcom/mediatek/res/ResOptExtImpl;

    if-nez v0, :cond_1

    .line 51
    sget-object v0, Lcom/mediatek/res/ResOptExtImpl;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 52
    :try_start_0
    sget-object v1, Lcom/mediatek/res/ResOptExtImpl;->sInstance:Lcom/mediatek/res/ResOptExtImpl;

    if-nez v1, :cond_0

    .line 53
    new-instance v1, Lcom/mediatek/res/ResOptExtImpl;

    invoke-direct {v1}, Lcom/mediatek/res/ResOptExtImpl;-><init>()V

    sput-object v1, Lcom/mediatek/res/ResOptExtImpl;->sInstance:Lcom/mediatek/res/ResOptExtImpl;

    .line 55
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 57
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/res/ResOptExtImpl;->sInstance:Lcom/mediatek/res/ResOptExtImpl;

    return-object v0
.end method


# virtual methods
.method public getCachedDrawable(Landroid/content/res/Resources;JI)Landroid/graphics/drawable/Drawable;
    .locals 0

    .line 65
    invoke-static {}, Lcom/mediatek/res/AsyncDrawableCache;->getInstance()Lcom/mediatek/res/AsyncDrawableCache;

    move-result-object p0

    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/mediatek/res/AsyncDrawableCache;->getCachedDrawable(Landroid/content/res/Resources;JI)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    return-object p0
.end method

.method public preloadRes(Landroid/content/Context;Landroid/content/res/Resources;)V
    .locals 0

    .line 61
    invoke-static {}, Lcom/mediatek/res/AsyncDrawableCache;->getInstance()Lcom/mediatek/res/AsyncDrawableCache;

    move-result-object p0

    invoke-virtual {p0, p1, p2}, Lcom/mediatek/res/AsyncDrawableCache;->preloadRes(Landroid/content/Context;Landroid/content/res/Resources;)V

    return-void
.end method

.method public putCacheList(JLandroid/graphics/drawable/Drawable;ILandroid/content/Context;)V
    .locals 6

    .line 69
    invoke-static {}, Lcom/mediatek/res/AsyncDrawableCache;->getInstance()Lcom/mediatek/res/AsyncDrawableCache;

    move-result-object v0

    move-wide v1, p1

    move-object v3, p3

    move v4, p4

    move-object v5, p5

    invoke-virtual/range {v0 .. v5}, Lcom/mediatek/res/AsyncDrawableCache;->putCacheList(JLandroid/graphics/drawable/Drawable;ILandroid/content/Context;)V

    return-void
.end method
