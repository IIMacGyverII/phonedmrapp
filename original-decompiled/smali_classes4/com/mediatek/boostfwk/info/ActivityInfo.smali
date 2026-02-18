.class public final Lcom/mediatek/boostfwk/info/ActivityInfo;
.super Ljava/lang/Object;
.source "ActivityInfo.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;,
        Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;
    }
.end annotation


# static fields
.field private static final LOCK:Ljava/lang/Object;

.field public static final NO_CHECKED_STATUS:I = 0x0

.field public static final PAGE_TYPE_AOSP_DESIGN:I = 0x1

.field public static final PAGE_TYPE_APPBRAND:I = 0x10

.field public static final PAGE_TYPE_FLUTTER:I = 0x8

.field public static final PAGE_TYPE_FULLSCREEN_GLTHREAD:I = 0x40

.field public static final PAGE_TYPE_NO_ACTIVITY:I = 0x80

.field public static final PAGE_TYPE_SPECIAL_DESIGN:I = 0x2

.field public static final PAGE_TYPE_SPECIAL_DESIGN_WEB_ON_60:I = 0x20

.field public static final PAGE_TYPE_WEBVIEW:I = 0x4

.field public static final SBE_MASK_DEBUG_HINT:I = 0x8

.field public static final SBE_MASK_FRAME_HINT:I = 0x2

.field public static final SBE_MASK_RECUE_HINT:I = 0x1

.field public static final SBE_MASK_SKIP_FRAME_END_HINT:I = 0x4

.field private static final TAG:Ljava/lang/String; = "ActivityInfo"

.field private static instance:Lcom/mediatek/boostfwk/info/ActivityInfo;

.field private static mSBEMask:I


# instance fields
.field private activityChangeListeners:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;",
            ">;"
        }
    .end annotation
.end field

.field private activityContext:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/content/Context;",
            ">;"
        }
    .end annotation
.end field

.field private attrs:Landroid/view/WindowManager$LayoutParams;

.field private density:F

.field private volatile mActivityCount:I

.field mActivityStateListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;

.field private mFlutterRenderTid:I

.field private mPageType:I

.field private mRenderThreadTid:I

.field private mWeakThreadedRender:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/view/ThreadedRenderer;",
            ">;"
        }
    .end annotation
.end field

.field private mWeakThreadedRenderArray:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Ljava/lang/ref/WeakReference<",
            "Landroid/view/ThreadedRenderer;",
            ">;>;"
        }
    .end annotation
.end field

.field private mWebviewRenderPid:I

.field private packageName:Ljava/lang/String;


# direct methods
.method static bridge synthetic -$$Nest$fgetmActivityCount(Lcom/mediatek/boostfwk/info/ActivityInfo;)I
    .locals 0

    iget p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mActivityCount:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputmActivityCount(Lcom/mediatek/boostfwk/info/ActivityInfo;I)V
    .locals 0

    iput p1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mActivityCount:I

    return-void
.end method

.method static bridge synthetic -$$Nest$mnotifyAllActivityPause(Lcom/mediatek/boostfwk/info/ActivityInfo;Landroid/content/Context;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->notifyAllActivityPause(Landroid/content/Context;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 106
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/mediatek/boostfwk/info/ActivityInfo;->LOCK:Ljava/lang/Object;

    return-void
.end method

.method private constructor <init>()V
    .locals 2

    .line 108
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 66
    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityContext:Ljava/lang/ref/WeakReference;

    const/high16 v1, -0x40800000    # -1.0f

    .line 68
    iput v1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->density:F

    .line 69
    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->packageName:Ljava/lang/String;

    const/high16 v1, -0x80000000

    .line 70
    iput v1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mRenderThreadTid:I

    .line 71
    iput v1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWebviewRenderPid:I

    .line 72
    iput v1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mFlutterRenderTid:I

    .line 74
    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityChangeListeners:Ljava/util/ArrayList;

    .line 75
    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mActivityStateListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;

    const/4 v1, 0x0

    .line 77
    iput v1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mActivityCount:I

    .line 79
    iput v1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    .line 102
    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    .line 103
    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRender:Ljava/lang/ref/WeakReference;

    .line 109
    new-instance v0, Ljava/util/ArrayList;

    const/4 v1, 0x4

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityChangeListeners:Ljava/util/ArrayList;

    return-void
.end method

.method public static clearTraversalCount()V
    .locals 2

    .line 438
    sget v0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mSBEMask:I

    const v1, 0xffff

    and-int/2addr v0, v1

    sput v0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mSBEMask:I

    return-void
.end method

.method public static containMask(I)Z
    .locals 1

    .line 442
    sget v0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mSBEMask:I

    and-int/2addr p0, v0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public static getInstance()Lcom/mediatek/boostfwk/info/ActivityInfo;
    .locals 2

    .line 114
    sget-object v0, Lcom/mediatek/boostfwk/info/ActivityInfo;->instance:Lcom/mediatek/boostfwk/info/ActivityInfo;

    if-nez v0, :cond_1

    .line 115
    sget-object v0, Lcom/mediatek/boostfwk/info/ActivityInfo;->LOCK:Ljava/lang/Object;

    monitor-enter v0

    .line 116
    :try_start_0
    sget-object v1, Lcom/mediatek/boostfwk/info/ActivityInfo;->instance:Lcom/mediatek/boostfwk/info/ActivityInfo;

    if-nez v1, :cond_0

    .line 117
    new-instance v1, Lcom/mediatek/boostfwk/info/ActivityInfo;

    invoke-direct {v1}, Lcom/mediatek/boostfwk/info/ActivityInfo;-><init>()V

    sput-object v1, Lcom/mediatek/boostfwk/info/ActivityInfo;->instance:Lcom/mediatek/boostfwk/info/ActivityInfo;

    .line 119
    :cond_0
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 121
    :cond_1
    :goto_0
    sget-object v0, Lcom/mediatek/boostfwk/info/ActivityInfo;->instance:Lcom/mediatek/boostfwk/info/ActivityInfo;

    return-object v0
.end method

.method private initialBasicInfo(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 151
    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->attrs:Landroid/view/WindowManager$LayoutParams;

    .line 152
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->density:F

    .line 153
    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->packageName:Ljava/lang/String;

    .line 154
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mActivityStateListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;

    if-nez v0, :cond_1

    .line 155
    new-instance v0, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;

    invoke-direct {v0, p0}, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;-><init>(Lcom/mediatek/boostfwk/info/ActivityInfo;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mActivityStateListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;

    .line 156
    instance-of v0, p1, Landroid/app/Activity;

    if-eqz v0, :cond_0

    .line 157
    check-cast p1, Landroid/app/Activity;

    invoke-virtual {p1}, Landroid/app/Activity;->getApplication()Landroid/app/Application;

    move-result-object p1

    .line 158
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mActivityStateListener:Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityStateListener;

    invoke-virtual {p1, v0}, Landroid/app/Application;->registerActivityLifecycleCallbacks(Landroid/app/Application$ActivityLifecycleCallbacks;)V

    .line 160
    iget p1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mActivityCount:I

    add-int/lit8 p1, p1, 0x1

    iput p1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mActivityCount:I

    .line 162
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->getBoostFwkVersion()I

    move-result p0

    const/4 p1, 0x2

    if-le p0, p1, :cond_1

    .line 164
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/FrameDecision;->getInstance()Lcom/mediatek/boostfwk/policy/frame/FrameDecision;

    :cond_1
    return-void
.end method

.method private notifyActivityUpdate(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 170
    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    .line 171
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->resetFeatureOption()V

    .line 172
    iget-object p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityChangeListeners:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;

    .line 173
    invoke-interface {v0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;->onChange(Landroid/content/Context;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private notifyAllActivityPause(Landroid/content/Context;)V
    .locals 1

    .line 178
    iget-object p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityChangeListeners:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;

    .line 179
    invoke-interface {v0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;->onAllActivityPaused(Landroid/content/Context;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method public static declared-synchronized updateSBEMask(IZ)I
    .locals 2

    const-class v0, Lcom/mediatek/boostfwk/info/ActivityInfo;

    monitor-enter v0

    if-eqz p1, :cond_0

    .line 427
    :try_start_0
    sget p1, Lcom/mediatek/boostfwk/info/ActivityInfo;->mSBEMask:I

    or-int/2addr p0, p1

    sput p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mSBEMask:I

    goto :goto_0

    .line 429
    :cond_0
    sget p1, Lcom/mediatek/boostfwk/info/ActivityInfo;->mSBEMask:I

    not-int p0, p0

    and-int/2addr p0, p1

    sput p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mSBEMask:I

    .line 431
    :goto_0
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_1

    const-string p0, "ActivityInfo"

    .line 432
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateSBEMask to "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v1, Lcom/mediatek/boostfwk/info/ActivityInfo;->mSBEMask:I

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 434
    :cond_1
    sget p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mSBEMask:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return p0

    :catchall_0
    move-exception p0

    monitor-exit v0

    throw p0
.end method


# virtual methods
.method public getContext()Landroid/content/Context;
    .locals 0

    .line 125
    iget-object p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityContext:Ljava/lang/ref/WeakReference;

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 128
    :cond_0
    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/content/Context;

    return-object p0
.end method

.method public getDensity()F
    .locals 0

    .line 203
    iget p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->density:F

    return p0
.end method

.method public getFlutterRenderTid()I
    .locals 2

    .line 366
    iget v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mFlutterRenderTid:I

    const/high16 v1, -0x80000000

    if-eq v0, v1, :cond_0

    return v0

    .line 369
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/TasksUtil;->findFlutterRenderTidForPid()I

    move-result v0

    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mFlutterRenderTid:I

    return v0
.end method

.method public getPackageName()Ljava/lang/String;
    .locals 0

    .line 207
    iget-object p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->packageName:Ljava/lang/String;

    return-object p0
.end method

.method public getPageType()I
    .locals 3

    .line 274
    iget v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    const-string v1, "ActivityInfo"

    if-eqz v0, :cond_1

    .line 275
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_0

    .line 276
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "pageType--> "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->pageType2Str()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 278
    :cond_0
    iget p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    return p0

    .line 280
    :cond_1
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getContext()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_2

    const/16 v0, 0x80

    .line 283
    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    return v0

    .line 287
    :cond_2
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->getWindowLayoutAttr()Landroid/view/WindowManager$LayoutParams;

    move-result-object v2

    invoke-static {v2}, Lcom/mediatek/boostfwk/utils/TasksUtil;->fullscreenAndGl(Landroid/view/WindowManager$LayoutParams;)Z

    move-result v2

    if-eqz v2, :cond_3

    const/16 v0, 0x40

    .line 288
    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    goto :goto_1

    .line 290
    :cond_3
    invoke-static {}, Lcom/mediatek/boostfwk/utils/TasksUtil;->isAppBrand()Z

    move-result v2

    if-eqz v2, :cond_4

    .line 291
    iget v2, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    or-int/lit8 v2, v2, 0x12

    iput v2, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    .line 293
    :cond_4
    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/TasksUtil;->isFlutterApp(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_5

    .line 294
    iget v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    or-int/lit8 v0, v0, 0xa

    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    .line 296
    :cond_5
    invoke-static {}, Lcom/mediatek/boostfwk/utils/TasksUtil;->isWebview()Z

    move-result v0

    if-eqz v0, :cond_7

    const/16 v0, 0x18

    .line 297
    invoke-virtual {p0, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v0

    if-nez v0, :cond_6

    .line 298
    invoke-static {}, Lcom/mediatek/boostfwk/info/ScrollState;->getRefreshRate()F

    move-result v0

    sget v2, Lcom/mediatek/boostfwk/info/ScrollState;->REFRESHRATE_60:F

    cmpl-float v0, v0, v2

    if-nez v0, :cond_6

    .line 299
    iget v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    or-int/lit8 v0, v0, 0x22

    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    goto :goto_0

    .line 301
    :cond_6
    iget v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    or-int/lit8 v0, v0, 0x6

    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    .line 304
    :cond_7
    :goto_0
    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isSpecialPageDesign()Z

    move-result v0

    if-nez v0, :cond_8

    const/4 v0, 0x1

    .line 305
    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    .line 308
    :cond_8
    :goto_1
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz v0, :cond_9

    .line 309
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "finally pageType--> "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->pageType2Str()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/mediatek/boostfwk/utils/LogUtil;->traceAndMLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 311
    :cond_9
    iget p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    return p0
.end method

.method public getRenderThreadTid()I
    .locals 2

    .line 215
    iget v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mRenderThreadTid:I

    const/high16 v1, -0x80000000

    if-ne v0, v1, :cond_0

    .line 216
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v0

    invoke-static {v0}, Lcom/mediatek/boostfwk/utils/TasksUtil;->findRenderTheadTid(I)I

    move-result v0

    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mRenderThreadTid:I

    .line 218
    :cond_0
    iget p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mRenderThreadTid:I

    return p0
.end method

.method public getThreadedRenderer()Landroid/view/ThreadedRenderer;
    .locals 5

    .line 395
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 399
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRender:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_1

    .line 400
    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/ThreadedRenderer;

    if-eqz v0, :cond_1

    return-object v0

    .line 403
    :cond_1
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    invoke-virtual {v0}, Landroid/util/SparseArray;->size()I

    move-result v0

    if-nez v0, :cond_2

    return-object v1

    :cond_2
    const/4 v2, 0x0

    :goto_0
    if-ge v2, v0, :cond_4

    .line 411
    iget-object v3, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    invoke-virtual {v3, v2}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v3

    .line 412
    iget-object v4, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    invoke-virtual {v4, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/ref/WeakReference;

    if-eqz v3, :cond_3

    .line 414
    invoke-virtual {v3}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/view/ThreadedRenderer;

    if-eqz v4, :cond_3

    .line 416
    iput-object v3, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRender:Ljava/lang/ref/WeakReference;

    return-object v4

    :cond_3
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 421
    :cond_4
    iget-object p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    invoke-virtual {p0}, Landroid/util/SparseArray;->clear()V

    return-object v1
.end method

.method public getWebViewRenderPid()I
    .locals 2

    .line 358
    iget v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWebviewRenderPid:I

    const/high16 v1, -0x80000000

    if-eq v0, v1, :cond_0

    return v0

    .line 361
    :cond_0
    invoke-static {}, Lcom/mediatek/boostfwk/utils/TasksUtil;->findGPUProcessPid()I

    move-result v0

    iput v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWebviewRenderPid:I

    return v0
.end method

.method public getWindowLayoutAttr()Landroid/view/WindowManager$LayoutParams;
    .locals 3

    .line 184
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->attrs:Landroid/view/WindowManager$LayoutParams;

    if-eqz v0, :cond_0

    return-object v0

    .line 187
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityContext:Ljava/lang/ref/WeakReference;

    const/4 v1, 0x0

    if-nez v0, :cond_1

    return-object v1

    .line 190
    :cond_1
    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/Context;

    if-eqz v0, :cond_2

    .line 192
    instance-of v2, v0, Landroid/app/Activity;

    if-eqz v2, :cond_2

    .line 193
    check-cast v0, Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    goto :goto_0

    :cond_2
    move-object v0, v1

    :goto_0
    if-eqz v0, :cond_3

    .line 196
    invoke-virtual {v0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v0

    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->attrs:Landroid/view/WindowManager$LayoutParams;

    return-object v0

    :cond_3
    return-object v1
.end method

.method public isAOSPPageDesign()Z
    .locals 1

    const/4 v0, 0x1

    .line 319
    invoke-virtual {p0, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result p0

    return p0
.end method

.method public isPage(I)Z
    .locals 0

    .line 323
    iget p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    and-int/2addr p0, p1

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isSpecialPageDesign()Z
    .locals 1

    const/4 v0, 0x2

    .line 315
    invoke-virtual {p0, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result p0

    return p0
.end method

.method public pageType2Str()Ljava/lang/String;
    .locals 2

    .line 327
    sget-boolean v0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-nez v0, :cond_0

    const-string p0, ""

    return-object p0

    .line 330
    :cond_0
    iget v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mPageType:I

    if-nez v0, :cond_1

    const-string p0, "NO_CHECKED_STATUS"

    return-object p0

    :cond_1
    const/4 v0, 0x1

    .line 335
    invoke-virtual {p0, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string p0, "PAGE_TYPE_AOSP_DESIGN"

    goto/16 :goto_0

    :cond_2
    const/16 v0, 0x40

    .line 337
    invoke-virtual {p0, v0}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v0

    if-eqz v0, :cond_3

    const-string p0, "PAGE_TYPE_FULLSCREEN_GLTHREAD"

    goto :goto_0

    :cond_3
    const-string v0, "PAGE_TYPE_SPECIAL_DESIGN"

    const/4 v1, 0x4

    .line 341
    invoke-virtual {p0, v1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v1

    if-eqz v1, :cond_4

    .line 342
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " & PAGE_TYPE_WEBVIEW"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_4
    const/16 v1, 0x8

    .line 344
    invoke-virtual {p0, v1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v1

    if-eqz v1, :cond_5

    .line 345
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " & PAGE_TYPE_FLUTTER"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_5
    const/16 v1, 0x20

    .line 347
    invoke-virtual {p0, v1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v1

    if-eqz v1, :cond_6

    .line 348
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " & PAGE_TYPE_SPECIAL_DESIGN_WEB_ON_60"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :cond_6
    const/16 v1, 0x10

    .line 350
    invoke-virtual {p0, v1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result p0

    if-eqz p0, :cond_7

    .line 351
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " & PAGE_TYPE_APPBRAND"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_7
    move-object p0, v0

    :goto_0
    return-object p0
.end method

.method public registerActivityListener(Lcom/mediatek/boostfwk/info/ActivityInfo$ActivityChangeListener;)V
    .locals 0

    if-nez p1, :cond_0

    return-void

    .line 232
    :cond_0
    iget-object p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityChangeListeners:Ljava/util/ArrayList;

    invoke-virtual {p0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public setContext(Landroid/content/Context;)V
    .locals 1

    if-nez p1, :cond_0

    return-void

    .line 139
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityContext:Ljava/lang/ref/WeakReference;

    if-nez v0, :cond_1

    .line 140
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityContext:Ljava/lang/ref/WeakReference;

    .line 141
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->initialBasicInfo(Landroid/content/Context;)V

    goto :goto_0

    .line 142
    :cond_1
    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 143
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityContext:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->clear()V

    .line 144
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->activityContext:Ljava/lang/ref/WeakReference;

    .line 145
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->initialBasicInfo(Landroid/content/Context;)V

    .line 147
    :cond_2
    :goto_0
    invoke-direct {p0, p1}, Lcom/mediatek/boostfwk/info/ActivityInfo;->notifyActivityUpdate(Landroid/content/Context;)V

    return-void
.end method

.method public setRenderThreadTid(I)V
    .locals 0

    .line 211
    iput p1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mRenderThreadTid:I

    return-void
.end method

.method public setThreadedRenderer(Landroid/view/ThreadedRenderer;)V
    .locals 2

    if-nez p1, :cond_0

    return-void

    .line 378
    :cond_0
    iget-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    if-nez v0, :cond_1

    .line 379
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    .line 381
    :cond_1
    invoke-virtual {p1}, Ljava/lang/Object;->hashCode()I

    move-result v0

    .line 382
    iget-object v1, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->contains(I)Z

    move-result v1

    if-eqz v1, :cond_2

    return-void

    .line 386
    :cond_2
    new-instance v1, Ljava/lang/ref/WeakReference;

    invoke-direct {v1, p1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    .line 388
    iget-object p0, p0, Lcom/mediatek/boostfwk/info/ActivityInfo;->mWeakThreadedRenderArray:Landroid/util/SparseArray;

    invoke-virtual {p0, v0, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 389
    sget-boolean p0, Lcom/mediatek/boostfwk/utils/LogUtil;->DEBUG:Z

    if-eqz p0, :cond_3

    .line 390
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "add new render = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "ActivityInfo"

    invoke-static {p1, p0}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_3
    return-void
.end method
