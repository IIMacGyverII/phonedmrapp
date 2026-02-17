.class public final Lcom/mediatek/boostfwk/info/ScrollState;
.super Ljava/lang/Object;
.source "ScrollState.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;,
        Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;,
        Lcom/mediatek/boostfwk/info/ScrollState$State;
    }
.end annotation


# static fields
.field public static REFRESHRATE_60:F = 60.0f

.field private static isScrolling:Z

.field private static lock:Ljava/lang/Object;

.field private static mDisplayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

.field private static mIsFling:Z

.field private static mIsScrolling:Z

.field private static mRefreshRate:F

.field private static mRefreshRateListeners:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;",
            ">;"
        }
    .end annotation
.end field

.field private static mScrollStateListeners:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;",
            ">;"
        }
    .end annotation
.end field

.field private static scrollingState:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Object;",
            "Lcom/mediatek/boostfwk/info/ScrollState$State;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static bridge synthetic -$$Nest$smnotifyRefreshRateChangedIfNeeded()V
    .locals 0

    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->notifyRefreshRateChangedIfNeeded()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 2

    .line 56
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->scrollingState:Ljava/util/HashMap;

    .line 57
    new-instance v0, Ljava/util/ArrayList;

    const/4 v1, 0x4

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    sput-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->mScrollStateListeners:Ljava/util/ArrayList;

    .line 58
    new-instance v0, Ljava/util/ArrayList;

    const/16 v1, 0x8

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    sput-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRateListeners:Ljava/util/ArrayList;

    const/4 v0, 0x0

    .line 59
    sput-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->mDisplayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

    const/high16 v0, -0x40800000    # -1.0f

    .line 60
    sput v0, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRate:F

    .line 61
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->lock:Ljava/lang/Object;

    const/4 v0, 0x0

    .line 63
    sput-boolean v0, Lcom/mediatek/boostfwk/info/ScrollState;->isScrolling:Z

    .line 67
    sput-boolean v0, Lcom/mediatek/boostfwk/info/ScrollState;->mIsScrolling:Z

    .line 68
    sput-boolean v0, Lcom/mediatek/boostfwk/info/ScrollState;->mIsFling:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 52
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static clearAll()V
    .locals 1

    .line 107
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->scrollingState:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->clear()V

    return-void
.end method

.method private static computeScrollingState()Z
    .locals 3

    .line 111
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->scrollingState:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v0

    .line 112
    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    .line 113
    sget-object v2, Lcom/mediatek/boostfwk/info/ScrollState;->scrollingState:Ljava/util/HashMap;

    invoke-virtual {v2, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/mediatek/boostfwk/info/ScrollState$State;

    .line 114
    iget-boolean v1, v1, Lcom/mediatek/boostfwk/info/ScrollState$State;->scrolling:Z

    if-eqz v1, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_1
    const/4 v0, 0x0

    return v0
.end method

.method public static getFling()Z
    .locals 1

    .line 170
    sget-boolean v0, Lcom/mediatek/boostfwk/info/ScrollState;->mIsFling:Z

    return v0
.end method

.method public static getRefreshRate()F
    .locals 2

    .line 238
    sget v0, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRate:F

    const/high16 v1, -0x40800000    # -1.0f

    cmpl-float v0, v0, v1

    if-nez v0, :cond_0

    .line 239
    invoke-static {}, Landroid/hardware/display/DisplayManagerGlobal;->getInstance()Landroid/hardware/display/DisplayManagerGlobal;

    move-result-object v0

    const/4 v1, 0x0

    .line 240
    invoke-virtual {v0, v1}, Landroid/hardware/display/DisplayManagerGlobal;->getDisplayInfo(I)Landroid/view/DisplayInfo;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/DisplayInfo;->getRefreshRate()F

    move-result v0

    .line 241
    sput v0, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRate:F

    .line 242
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->registerDisplyListenerIfNeeded()V

    .line 244
    :cond_0
    sget v0, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRate:F

    return v0
.end method

.method public static isScrollerScrolling(Ljava/lang/Object;)Z
    .locals 2

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return v0

    .line 129
    :cond_0
    sget-object v1, Lcom/mediatek/boostfwk/info/ScrollState;->scrollingState:Ljava/util/HashMap;

    invoke-virtual {v1, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/mediatek/boostfwk/info/ScrollState$State;

    if-eqz p0, :cond_1

    .line 130
    iget-boolean p0, p0, Lcom/mediatek/boostfwk/info/ScrollState$State;->scrolling:Z

    if-eqz p0, :cond_1

    const/4 v0, 0x1

    :cond_1
    return v0
.end method

.method public static isScrolling()Z
    .locals 1

    .line 122
    sget-boolean v0, Lcom/mediatek/boostfwk/info/ScrollState;->isScrolling:Z

    return v0
.end method

.method private static declared-synchronized notifyRefreshRateChangedIfNeeded()V
    .locals 6

    const-class v0, Lcom/mediatek/boostfwk/info/ScrollState;

    monitor-enter v0

    .line 199
    :try_start_0
    invoke-static {}, Landroid/hardware/display/DisplayManagerGlobal;->getInstance()Landroid/hardware/display/DisplayManagerGlobal;

    move-result-object v1

    const/4 v2, 0x0

    .line 200
    invoke-virtual {v1, v2}, Landroid/hardware/display/DisplayManagerGlobal;->getDisplayInfo(I)Landroid/view/DisplayInfo;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/DisplayInfo;->getRefreshRate()F

    move-result v1

    .line 201
    sget v3, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRate:F

    cmpl-float v3, v1, v3

    if-eqz v3, :cond_0

    .line 202
    sput v1, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRate:F

    const v3, 0x4e6e6b28    # 1.0E9f

    div-float/2addr v3, v1

    .line 204
    sget-object v4, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRateListeners:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_0

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;

    .line 205
    invoke-interface {v5, v2, v1, v3}, Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;->onDisplayRefreshRateChanged(IFF)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    .line 208
    :cond_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception v1

    monitor-exit v0

    throw v1
.end method

.method public static onScrolling()Z
    .locals 1

    .line 156
    sget-boolean v0, Lcom/mediatek/boostfwk/info/ScrollState;->mIsScrolling:Z

    return v0
.end method

.method private static registerDisplyListenerIfNeeded()V
    .locals 6

    .line 212
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 213
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/info/ScrollState;->mDisplayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

    if-eqz v1, :cond_0

    .line 214
    monitor-exit v0

    return-void

    .line 216
    :cond_0
    new-instance v1, Lcom/mediatek/boostfwk/info/ScrollState$1;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/info/ScrollState$1;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/info/ScrollState;->mDisplayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

    .line 232
    invoke-static {}, Landroid/hardware/display/DisplayManagerGlobal;->getInstance()Landroid/hardware/display/DisplayManagerGlobal;

    move-result-object v1

    sget-object v2, Lcom/mediatek/boostfwk/info/ScrollState;->mDisplayListener:Landroid/hardware/display/DisplayManager$DisplayListener;

    new-instance v3, Landroid/os/Handler;

    invoke-direct {v3}, Landroid/os/Handler;-><init>()V

    const-wide/16 v4, 0x4

    invoke-virtual {v1, v2, v3, v4, v5}, Landroid/hardware/display/DisplayManagerGlobal;->registerDisplayListener(Landroid/hardware/display/DisplayManager$DisplayListener;Landroid/os/Handler;J)V

    .line 234
    monitor-exit v0

    return-void

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method public static registerRefreshRateChangedListener(Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;)V
    .locals 1

    if-nez p0, :cond_0

    return-void

    .line 187
    :cond_0
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRateListeners:Ljava/util/ArrayList;

    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public static registerScrollStateListener(Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;)V
    .locals 1

    if-nez p0, :cond_0

    return-void

    .line 142
    :cond_0
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->mScrollStateListeners:Ljava/util/ArrayList;

    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public static removeState(Ljava/lang/Object;)V
    .locals 1

    if-nez p0, :cond_0

    return-void

    .line 103
    :cond_0
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->scrollingState:Ljava/util/HashMap;

    invoke-virtual {v0, p0}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public static setFling(Z)V
    .locals 0

    .line 174
    sput-boolean p0, Lcom/mediatek/boostfwk/info/ScrollState;->mIsFling:Z

    return-void
.end method

.method public static setScrolling(ZLjava/lang/String;)V
    .locals 3

    .line 160
    sput-boolean p0, Lcom/mediatek/boostfwk/info/ScrollState;->mIsScrolling:Z

    .line 161
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->mScrollStateListeners:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;

    .line 162
    sget-boolean v2, Lcom/mediatek/boostfwk/info/ScrollState;->mIsScrolling:Z

    invoke-interface {v1, v2}, Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;->onScroll(Z)V

    goto :goto_0

    .line 164
    :cond_0
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_1

    .line 165
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "scroll state changed to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " because:"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->trace(Ljava/lang/String;)V

    :cond_1
    return-void
.end method

.method public static unregisterRefreshRateChangedListener(Lcom/mediatek/boostfwk/info/ScrollState$RefreshRateChangedListener;)V
    .locals 1

    if-nez p0, :cond_0

    return-void

    .line 194
    :cond_0
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->mRefreshRateListeners:Ljava/util/ArrayList;

    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public static unregisterScrollStateListener(Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;)V
    .locals 1

    if-nez p0, :cond_0

    return-void

    .line 149
    :cond_0
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->mScrollStateListeners:Ljava/util/ArrayList;

    invoke-virtual {v0, p0}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method public static updateState(Ljava/lang/Object;Z)V
    .locals 2

    if-nez p0, :cond_0

    return-void

    .line 80
    :cond_0
    sget-object v0, Lcom/mediatek/boostfwk/info/ScrollState;->scrollingState:Ljava/util/HashMap;

    invoke-virtual {v0, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/boostfwk/info/ScrollState$State;

    if-nez v0, :cond_1

    .line 82
    new-instance v0, Lcom/mediatek/boostfwk/info/ScrollState$State;

    invoke-direct {v0}, Lcom/mediatek/boostfwk/info/ScrollState$State;-><init>()V

    .line 83
    iput-boolean p1, v0, Lcom/mediatek/boostfwk/info/ScrollState$State;->scrolling:Z

    .line 84
    sget-object v1, Lcom/mediatek/boostfwk/info/ScrollState;->scrollingState:Ljava/util/HashMap;

    invoke-virtual {v1, p0, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 86
    :cond_1
    iput-boolean p1, v0, Lcom/mediatek/boostfwk/info/ScrollState$State;->scrolling:Z

    :goto_0
    if-eqz p1, :cond_2

    const/4 p0, 0x1

    .line 89
    sput-boolean p0, Lcom/mediatek/boostfwk/info/ScrollState;->isScrolling:Z

    goto :goto_1

    .line 91
    :cond_2
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->computeScrollingState()Z

    move-result p0

    sput-boolean p0, Lcom/mediatek/boostfwk/info/ScrollState;->isScrolling:Z

    .line 93
    :goto_1
    sget-object p0, Lcom/mediatek/boostfwk/info/ScrollState;->mScrollStateListeners:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_2
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p1

    if-eqz p1, :cond_3

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;

    .line 95
    sget-boolean v0, Lcom/mediatek/boostfwk/info/ScrollState;->isScrolling:Z

    invoke-interface {p1, v0}, Lcom/mediatek/boostfwk/info/ScrollState$ScrollStateListener;->onScroll(Z)V

    goto :goto_2

    :cond_3
    return-void
.end method
