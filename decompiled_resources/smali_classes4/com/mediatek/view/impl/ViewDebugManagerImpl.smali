.class public Lcom/mediatek/view/impl/ViewDebugManagerImpl;
.super Lcom/mediatek/view/ViewDebugManager;
.source "ViewDebugManagerImpl.java"


# static fields
.field private static final DATE_FORMAT_STRING:Ljava/lang/String; = "yyyyMMdd_hhmmss"

.field private static final DBG_APP_DRAWING_MODE:I

.field private static final DBG_APP_DRAWING_MODE_FORCE_HWLAYER:I = 0x4

.field private static final DBG_APP_DRAWING_MODE_FORCE_HWUI:I = 0x1

.field private static final DBG_APP_DRAWING_MODE_FORCE_SW:I = 0x2

.field private static final DBG_APP_DRAWING_MODE_FORCE_SWLAYER:I = 0x8

.field private static final DBG_APP_DRAWING_MODE_NOT_SET:I = 0x0

.field static final DBG_APP_FAST_LAUNCH_ENHANCE:Z

.field static final DBG_APP_LAUNCH_ENHANCE:Z = true

.field private static final DBG_TRANSP:Z

.field private static final DEBUG_CHOREOGRAPHER_FRAMES_FLAG:I = 0x20000000

.field private static final DEBUG_CHOREOGRAPHER_JANK_FLAG:I = 0x10000000

.field private static final DEBUG_CONFIGURATION_FLAG:I = 0x100

.field private static final DEBUG_DEFAULT_FLAG:I = 0x200

.field private static final DEBUG_DIALOG_FLAG:I = 0x8

.field private static final DEBUG_DRAW_FLAG:I = 0x2

.field private static final DEBUG_ENABLE_ALL_FLAG:I = 0x1

.field private static final DEBUG_FOCUS_FLAG:I = 0x1000000

.field private static final DEBUG_FPS_FLAG:I = 0x400

.field private static final DEBUG_HWUI_FLAG:I = 0x800

.field private static final DEBUG_IME_ANR_FLAG:I = 0x8000

.field private static final DEBUG_IMF_FLAG:I = 0x80

.field private static final DEBUG_INPUT_FLAG:I = 0x1000

.field private static final DEBUG_INPUT_RESIZE_FLAG:I = 0x10

.field private static final DEBUG_INPUT_STAGES_FLAG:I = 0x400000

.field private static final DEBUG_INVALIDATE_FLAG:I = 0x40000

.field private static final DEBUG_KEEP_SCREEN_ON_FLAG:I = 0x800000

.field private static final DEBUG_KEY_FLAG:I = 0x2000

.field private static final DEBUG_LAYOUT_FLAG:I = 0x4

.field private static final DEBUG_LIFECYCLE_FLAG:I = 0x10000

.field private static final DEBUG_MET_TRACE_FLAG:I = 0x40000000

.field private static final DEBUG_MOTION_FLAG:I = 0x4000

.field private static final DEBUG_ORIENTATION_FLAG:I = 0x20

.field private static final DEBUG_REQUESTLAYOUT_FLAG:I = 0x20000

.field private static final DEBUG_SCHEDULETRAVERSALS_FLAG:I = 0x80000

.field private static final DEBUG_SYSTRACE_DRAW_FLAG:I = 0x2000000

.field private static final DEBUG_SYSTRACE_LAYOUT_FLAG:I = 0x8000000

.field private static final DEBUG_SYSTRACE_MEASURE_FLAG:I = 0x4000000

.field private static final DEBUG_TOUCHMODE_FLAG:I = 0x100000

.field private static final DEBUG_TOUCH_FLAG:I = 0x200000

.field private static final DEBUG_TRACKBALL_FLAG:I = 0x40

.field private static final DUMP_IMAGE_FORMAT:Ljava/lang/String; = ".png"

.field private static final DUMP_IMAGE_PTAH:Ljava/lang/String; = "/data/dump/"

.field public static final INPUT_TIMEOUT:I = 0x1770

.field private static final LOG_DISABLED:I = 0x0

.field private static final LOG_ENABLED:I = 0x1

.field private static final LOG_PROPERTY_NAME:Ljava/lang/String; = "mtk_d.viewroot.enable"

.field private static final USE_RENDER_THREAD:Z = false

.field private static final VIEWROOT_LOG_TAG:Ljava/lang/String; = "ViewRoot"

.field private static final VIEW_LOG_TAG:Ljava/lang/String; = "View"

.field private static sIdent:J


# instance fields
.field private mCurrentKeyEvent:Landroid/view/KeyEvent;

.field private mCurrentMotion:Landroid/view/MotionEvent;

.field private mIdent:J

.field private mInputStageRecored:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Object;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field private mKeyEventStartTime:J

.field private mKeyEventStatus:Ljava/lang/String;

.field private mMotionEventStartTime:J

.field private mMotionEventStatus:Ljava/lang/String;

.field private mPreviousKeyEvent:Landroid/view/KeyEvent;

.field private mPreviousKeyEventFinishTime:J

.field private mPreviousMotion:Landroid/view/MotionEvent;

.field private mPreviousMotionEventFinishTime:J


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const-string v0, "mtk_ro.mtk_dbg_app_drawing_mode"

    const/4 v1, 0x0

    .line 93
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    sput v0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->DBG_APP_DRAWING_MODE:I

    const-string v0, "mtk_d.view.transparentRegion"

    .line 102
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    sput-boolean v0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->DBG_TRANSP:Z

    const-string v0, "mtk_ro.mtk_perf_fast_start_win"

    .line 109
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    const/4 v2, 0x1

    if-ne v2, v0, :cond_0

    move v1, v2

    :cond_0
    sput-boolean v1, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->DBG_APP_FAST_LAUNCH_ENHANCE:Z

    const-wide/16 v0, 0x0

    .line 115
    sput-wide v0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->sIdent:J

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 54
    invoke-direct {p0}, Lcom/mediatek/view/ViewDebugManager;-><init>()V

    .line 123
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mInputStageRecored:Ljava/util/HashMap;

    const-string v0, "0: Finish handle input event"

    .line 605
    iput-object v0, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStatus:Ljava/lang/String;

    .line 606
    iput-object v0, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStatus:Ljava/lang/String;

    return-void
.end method

.method private static checkAppLaunchTimeProperty()Z
    .locals 3

    const-string v0, "persist.applaunchtime.enable"

    const/4 v1, 0x0

    .line 449
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getInt(Ljava/lang/String;I)I

    move-result v0

    const/4 v2, 0x1

    if-ne v2, v0, :cond_0

    move v1, v2

    :cond_0
    return v1
.end method

.method static checkViewRootImplLogProperty()V
    .locals 8

    const-string v0, "ViewRoot"

    const-string v1, "mtk_d.viewroot.enable"

    .line 370
    invoke-static {v1}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x1

    .line 371
    sput-boolean v2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_USER:Z

    .line 372
    sget-boolean v3, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->DBG_TRANSP:Z

    sput-boolean v3, Lcom/mediatek/view/ViewDebugManager;->DBG_TRANSP:Z

    if-eqz v1, :cond_21

    .line 373
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v3

    if-lez v3, :cond_21

    const/16 v3, 0x10

    const/4 v4, 0x0

    .line 376
    :try_start_0
    invoke-static {v1, v3}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;I)I

    move-result v5
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 378
    :catch_0
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Invalid format of propery string: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v0, v5}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    move v5, v4

    .line 381
    :goto_0
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "checkViewRootImplLogProperty: propString = "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ",logFilter = #"

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 382
    invoke-static {v5}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 381
    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    and-int/lit8 v0, v5, 0x1

    if-ne v0, v2, :cond_0

    move v0, v2

    goto :goto_1

    :cond_0
    move v0, v4

    .line 383
    :goto_1
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->LOCAL_LOGV:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->LOCAL_LOGV:Z

    and-int/lit8 v0, v5, 0x2

    const/4 v1, 0x2

    if-ne v0, v1, :cond_1

    move v0, v2

    goto :goto_2

    :cond_1
    move v0, v4

    .line 385
    :goto_2
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_DRAW:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_DRAW:Z

    and-int/lit8 v0, v5, 0x4

    const/4 v1, 0x4

    if-ne v0, v1, :cond_2

    move v0, v2

    goto :goto_3

    :cond_2
    move v0, v4

    .line 387
    :goto_3
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_LAYOUT:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_LAYOUT:Z

    and-int/lit8 v0, v5, 0x8

    const/16 v1, 0x8

    if-ne v0, v1, :cond_3

    move v0, v2

    goto :goto_4

    :cond_3
    move v0, v4

    .line 389
    :goto_4
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_DIALOG:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_DIALOG:Z

    and-int/lit8 v0, v5, 0x10

    if-ne v0, v3, :cond_4

    move v0, v2

    goto :goto_5

    :cond_4
    move v0, v4

    .line 391
    :goto_5
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_INPUT_RESIZE:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_INPUT_RESIZE:Z

    and-int/lit8 v0, v5, 0x20

    const/16 v1, 0x20

    if-ne v0, v1, :cond_5

    move v0, v2

    goto :goto_6

    :cond_5
    move v0, v4

    .line 393
    :goto_6
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_ORIENTATION:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_ORIENTATION:Z

    and-int/lit8 v0, v5, 0x40

    const/16 v1, 0x40

    if-ne v0, v1, :cond_6

    move v0, v2

    goto :goto_7

    :cond_6
    move v0, v4

    .line 395
    :goto_7
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_TRACKBALL:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_TRACKBALL:Z

    and-int/lit16 v0, v5, 0x80

    const/16 v1, 0x80

    if-ne v0, v1, :cond_7

    move v0, v2

    goto :goto_8

    :cond_7
    move v0, v4

    .line 397
    :goto_8
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_IMF:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_IMF:Z

    and-int/lit16 v0, v5, 0x100

    const/16 v1, 0x100

    if-ne v0, v1, :cond_8

    move v0, v2

    goto :goto_9

    :cond_8
    move v0, v4

    .line 399
    :goto_9
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_CONFIGURATION:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_CONFIGURATION:Z

    and-int/lit16 v0, v5, 0x200

    const/16 v1, 0x200

    if-ne v0, v1, :cond_9

    move v0, v2

    goto :goto_a

    :cond_9
    move v0, v4

    .line 401
    :goto_a
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DBG:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DBG:Z

    and-int/lit16 v0, v5, 0x400

    const/16 v1, 0x400

    if-ne v0, v1, :cond_a

    move v0, v2

    goto :goto_b

    :cond_a
    move v0, v4

    .line 403
    :goto_b
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_FPS:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_FPS:Z

    const/high16 v0, 0x400000

    and-int v1, v5, v0

    if-ne v1, v0, :cond_b

    move v0, v2

    goto :goto_c

    :cond_b
    move v0, v4

    .line 405
    :goto_c
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_INPUT_STAGES:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_INPUT_STAGES:Z

    const/high16 v0, 0x800000

    and-int v1, v5, v0

    if-ne v1, v0, :cond_c

    move v0, v2

    goto :goto_d

    :cond_c
    move v0, v4

    .line 407
    :goto_d
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_KEEP_SCREEN_ON:Z

    sput-boolean v0, Landroid/view/ViewRootImpl;->DEBUG_KEEP_SCREEN_ON:Z

    and-int/lit16 v0, v5, 0x800

    const/16 v1, 0x800

    if-ne v0, v1, :cond_d

    move v0, v2

    goto :goto_e

    :cond_d
    move v0, v4

    .line 409
    :goto_e
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_HWUI:Z

    and-int/lit16 v0, v5, 0x1000

    const/16 v1, 0x1000

    if-ne v0, v1, :cond_e

    move v0, v2

    goto :goto_f

    :cond_e
    move v0, v4

    .line 410
    :goto_f
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_INPUT:Z

    if-nez v0, :cond_10

    and-int/lit16 v1, v5, 0x2000

    const/16 v3, 0x2000

    if-ne v1, v3, :cond_f

    goto :goto_10

    :cond_f
    move v1, v4

    goto :goto_11

    :cond_10
    :goto_10
    move v1, v2

    .line 411
    :goto_11
    sput-boolean v1, Lcom/mediatek/view/ViewDebugManager;->DEBUG_KEY:Z

    if-nez v0, :cond_12

    and-int/lit16 v0, v5, 0x4000

    const/16 v1, 0x4000

    if-ne v0, v1, :cond_11

    goto :goto_12

    :cond_11
    move v0, v4

    goto :goto_13

    :cond_12
    :goto_12
    move v0, v2

    .line 413
    :goto_13
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_MOTION:Z

    const v0, 0x8000

    and-int v1, v5, v0

    if-ne v1, v0, :cond_13

    move v0, v2

    goto :goto_14

    :cond_13
    move v0, v4

    .line 415
    :goto_14
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_IME_ANR:Z

    const/high16 v0, 0x10000

    and-int v1, v5, v0

    if-ne v1, v0, :cond_14

    move v0, v2

    goto :goto_15

    :cond_14
    move v0, v4

    .line 417
    :goto_15
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_LIFECYCLE:Z

    const/high16 v0, 0x20000

    and-int v1, v5, v0

    if-ne v1, v0, :cond_15

    move v0, v2

    goto :goto_16

    :cond_15
    move v0, v4

    .line 419
    :goto_16
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_REQUESTLAYOUT:Z

    const/high16 v0, 0x40000

    and-int/2addr v0, v5

    const/high16 v1, 0x40000

    if-ne v0, v1, :cond_16

    move v0, v2

    goto :goto_17

    :cond_16
    move v0, v4

    .line 421
    :goto_17
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_INVALIDATE:Z

    const/high16 v0, 0x80000

    and-int/2addr v0, v5

    const/high16 v1, 0x80000

    if-ne v0, v1, :cond_17

    move v0, v2

    goto :goto_18

    :cond_17
    move v0, v4

    .line 423
    :goto_18
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_SCHEDULETRAVERSALS:Z

    const/high16 v0, 0x100000

    and-int/2addr v0, v5

    const/high16 v1, 0x100000

    if-ne v0, v1, :cond_18

    move v0, v2

    goto :goto_19

    :cond_18
    move v0, v4

    .line 425
    :goto_19
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_TOUCHMODE:Z

    const/high16 v0, 0x200000

    and-int/2addr v0, v5

    const/high16 v1, 0x200000

    if-ne v0, v1, :cond_19

    move v0, v2

    goto :goto_1a

    :cond_19
    move v0, v4

    .line 427
    :goto_1a
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_TOUCH:Z

    const/high16 v0, 0x1000000

    and-int/2addr v0, v5

    const/high16 v1, 0x1000000

    if-ne v0, v1, :cond_1a

    move v0, v2

    goto :goto_1b

    :cond_1a
    move v0, v4

    .line 428
    :goto_1b
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_FOCUS:Z

    const/high16 v0, 0x4000000

    and-int/2addr v0, v5

    const/high16 v1, 0x4000000

    if-ne v0, v1, :cond_1b

    move v0, v2

    goto :goto_1c

    :cond_1b
    move v0, v4

    .line 429
    :goto_1c
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_SYSTRACE_MEASURE:Z

    const/high16 v0, 0x8000000

    and-int/2addr v0, v5

    const/high16 v1, 0x8000000

    if-ne v0, v1, :cond_1c

    move v0, v2

    goto :goto_1d

    :cond_1c
    move v0, v4

    .line 431
    :goto_1d
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_SYSTRACE_LAYOUT:Z

    const/high16 v0, 0x2000000

    and-int/2addr v0, v5

    const/high16 v1, 0x2000000

    if-ne v0, v1, :cond_1d

    move v0, v2

    goto :goto_1e

    :cond_1d
    move v0, v4

    .line 433
    :goto_1e
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_SYSTRACE_DRAW:Z

    const/high16 v0, 0x10000000

    and-int/2addr v0, v5

    const/high16 v1, 0x10000000

    if-ne v0, v1, :cond_1e

    move v0, v2

    goto :goto_1f

    :cond_1e
    move v0, v4

    .line 435
    :goto_1f
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_CHOREOGRAPHER_JANK:Z

    const/high16 v0, 0x20000000

    and-int/2addr v0, v5

    const/high16 v1, 0x20000000

    if-ne v0, v1, :cond_1f

    move v0, v2

    goto :goto_20

    :cond_1f
    move v0, v4

    .line 437
    :goto_20
    sput-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_CHOREOGRAPHER_FRAMES:Z

    const/high16 v0, 0x40000000    # 2.0f

    and-int/2addr v0, v5

    const/high16 v1, 0x40000000    # 2.0f

    if-ne v0, v1, :cond_20

    goto :goto_21

    :cond_20
    move v2, v4

    .line 439
    :goto_21
    sput-boolean v2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_MET_TRACE:Z

    :cond_21
    return-void
.end method

.method private getCurrentLevel(Landroid/view/View;)I
    .locals 1

    .line 252
    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    const/4 p1, 0x0

    :goto_0
    if-eqz p0, :cond_0

    .line 253
    instance-of v0, p0, Landroid/view/View;

    if-eqz v0, :cond_0

    add-int/lit8 p1, p1, 0x1

    .line 255
    check-cast p0, Landroid/view/View;

    .line 256
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    goto :goto_0

    :cond_0
    return p1
.end method

.method private getViewLayoutProperties(Landroid/view/View;)Ljava/lang/String;
    .locals 3

    .line 237
    new-instance p0, Ljava/lang/StringBuilder;

    const/16 v0, 0x80

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 238
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, ", Padding = {"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/view/View;->getPaddingLeft()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/view/View;->getPaddingTop()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 239
    invoke-virtual {p1}, Landroid/view/View;->getPaddingRight()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/view/View;->getPaddingBottom()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string/jumbo v2, "}"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 238
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 241
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    if-nez v0, :cond_0

    const-string p1, ", BAD! no layout params"

    .line 242
    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_0

    .line 244
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    const-string v1, ""

    invoke-virtual {p1, v1}, Landroid/view/ViewGroup$LayoutParams;->debug(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 247
    :goto_0
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private sizeToString(I)Ljava/lang/String;
    .locals 0

    const/4 p0, -0x2

    if-ne p1, p0, :cond_0

    const-string/jumbo p0, "wrap-content"

    return-object p0

    :cond_0
    const/4 p0, -0x1

    if-ne p1, p0, :cond_1

    const-string p0, "match-parent"

    return-object p0

    .line 268
    :cond_1
    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method clearInputStageInfo()V
    .locals 0

    .line 498
    iget-object p0, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mInputStageRecored:Ljava/util/HashMap;

    invoke-virtual {p0}, Ljava/util/HashMap;->clear()V

    return-void
.end method

.method public debug(Ljava/lang/String;Landroid/view/ViewGroup$MarginLayoutParams;)Ljava/lang/String;
    .locals 1

    .line 272
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "ViewGroup.MarginLayoutParams={ width="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p2, Landroid/view/ViewGroup$MarginLayoutParams;->width:I

    invoke-direct {p0, p1}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->sizeToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", height="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p2, Landroid/view/ViewGroup$MarginLayoutParams;->height:I

    .line 273
    invoke-direct {p0, p1}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->sizeToString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ", leftMargin="

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p2, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ", rightMargin="

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p2, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ", topMargin="

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p2, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ", bottomMargin="

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p2, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " }"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public debugEventHandled(Landroid/view/View;Landroid/view/InputEvent;Ljava/lang/String;)V
    .locals 1

    .line 159
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Event handle in "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ", event = "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ", handler = "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "View"

    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public debugForceHWDraw(Z)Z
    .locals 2

    .line 126
    sget p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->DBG_APP_DRAWING_MODE:I

    and-int/lit8 v0, p0, 0x1

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    return v1

    :cond_0
    const/4 v0, 0x2

    and-int/2addr p0, v0

    if-ne p0, v0, :cond_1

    const/4 p0, 0x0

    return p0

    :cond_1
    return p1
.end method

.method public debugForceHWLayer(I)I
    .locals 2

    .line 138
    sget p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->DBG_APP_DRAWING_MODE:I

    and-int/lit8 v0, p0, 0x4

    const/4 v1, 0x4

    if-ne v0, v1, :cond_0

    const/4 p0, 0x2

    return p0

    :cond_0
    const/16 v0, 0x8

    and-int/2addr p0, v0

    if-ne p0, v0, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    return p1
.end method

.method public debugInputDispatchState(Landroid/view/InputEvent;Ljava/lang/String;)V
    .locals 0

    .line 576
    instance-of p1, p1, Landroid/view/KeyEvent;

    if-eqz p1, :cond_0

    .line 577
    invoke-virtual {p0, p2}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->setKeyDispatchState(Ljava/lang/String;)V

    goto :goto_0

    .line 579
    :cond_0
    invoke-virtual {p0, p2}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->setMotionDispatchState(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public debugInputEventFinished(Ljava/lang/String;ZLandroid/view/InputEvent;Landroid/view/ViewRootImpl;)V
    .locals 6

    .line 536
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 537
    instance-of p4, p3, Landroid/view/KeyEvent;

    const-string v2, "0: Finish handle input event"

    const/4 v3, 0x0

    if-eqz p4, :cond_0

    .line 538
    iget-object p4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentKeyEvent:Landroid/view/KeyEvent;

    iput-object p4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mPreviousKeyEvent:Landroid/view/KeyEvent;

    .line 539
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    iput-wide v4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mPreviousKeyEventFinishTime:J

    .line 540
    iput-object v3, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentKeyEvent:Landroid/view/KeyEvent;

    .line 541
    iget-object p4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStatus:Ljava/lang/String;

    .line 542
    iput-object v2, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStatus:Ljava/lang/String;

    .line 543
    iget-wide v2, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStartTime:J

    goto :goto_0

    .line 545
    :cond_0
    iget-object p4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentMotion:Landroid/view/MotionEvent;

    iput-object p4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mPreviousMotion:Landroid/view/MotionEvent;

    .line 546
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    iput-wide v4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mPreviousMotionEventFinishTime:J

    .line 547
    iput-object v3, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentMotion:Landroid/view/MotionEvent;

    .line 548
    iget-object p4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStatus:Ljava/lang/String;

    .line 549
    iput-object v2, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStatus:Ljava/lang/String;

    .line 550
    iget-wide v2, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStartTime:J

    :goto_0
    sub-long v2, v0, v2

    const-wide/16 v4, 0x1770

    cmp-long v4, v2, v4

    if-ltz v4, :cond_1

    .line 553
    new-instance v4, Landroid/icu/text/SimpleDateFormat;

    const-string/jumbo v5, "yyyy-MM-dd HH:mm:ss.SSS"

    invoke-direct {v4, v5}, Landroid/icu/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 554
    new-instance v5, Ljava/util/Date;

    sub-long/2addr v0, v2

    invoke-direct {v5, v0, v1}, Ljava/util/Date;-><init>(J)V

    .line 555
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[ANR Warning]Input routeing takes more than 6000ms since "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 556
    invoke-virtual {v4, v5}, Landroid/icu/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", this = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 555
    invoke-static {p1, v0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 557
    invoke-virtual {p0, p1, v4}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->dumpInputStageInfo(Ljava/lang/String;Landroid/icu/text/SimpleDateFormat;)V

    .line 559
    :cond_1
    invoke-virtual {p0}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->clearInputStageInfo()V

    .line 562
    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_ENG:Z

    if-nez p0, :cond_2

    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_INPUT:Z

    if-nez p0, :cond_2

    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_KEY:Z

    if-nez p0, :cond_2

    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_MOTION:Z

    if-eqz p0, :cond_4

    .line 563
    :cond_2
    instance-of p0, p3, Landroid/view/MotionEvent;

    const-string v0, ", stage = "

    const-string v1, "finishInputEvent: handled = "

    if-eqz p0, :cond_3

    .line 564
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, ",event action = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    check-cast p3, Landroid/view/MotionEvent;

    .line 565
    invoke-virtual {p3}, Landroid/view/MotionEvent;->getAction()I

    move-result p2

    invoke-static {p2}, Landroid/view/MotionEvent;->actionToString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ",x = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 566
    invoke-virtual {p3}, Landroid/view/MotionEvent;->getX()F

    move-result p2

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string p2, ",y = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Landroid/view/MotionEvent;->getY()F

    move-result p2

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 564
    invoke-static {p1, p0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 569
    :cond_3
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, ",event = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    :cond_4
    :goto_1
    return-void
.end method

.method public debugInputEventStart(Landroid/view/InputEvent;)V
    .locals 4

    .line 518
    instance-of v0, p1, Landroid/view/KeyEvent;

    const-string v1, "1: Start event from input"

    if-eqz v0, :cond_0

    .line 519
    check-cast p1, Landroid/view/KeyEvent;

    iput-object p1, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentKeyEvent:Landroid/view/KeyEvent;

    .line 520
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStartTime:J

    .line 521
    iput-object v1, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStatus:Ljava/lang/String;

    goto :goto_0

    .line 523
    :cond_0
    check-cast p1, Landroid/view/MotionEvent;

    iput-object p1, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentMotion:Landroid/view/MotionEvent;

    .line 524
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    iput-wide v2, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStartTime:J

    .line 525
    iput-object v1, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStatus:Ljava/lang/String;

    :goto_0
    return-void
.end method

.method public debugInputStageDeliverd(Ljava/lang/Object;J)V
    .locals 0

    .line 494
    iget-object p0, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mInputStageRecored:Ljava/util/HashMap;

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p2

    invoke-virtual {p0, p1, p2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public debugKeyDispatch(Landroid/view/View;Landroid/view/KeyEvent;)V
    .locals 3

    .line 151
    invoke-virtual {p2}, Landroid/view/KeyEvent;->getAction()I

    move-result p0

    const-string v0, ", event = "

    const-string v1, "View"

    if-nez p0, :cond_0

    .line 152
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Key down dispatch to "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 153
    :cond_0
    invoke-virtual {p2}, Landroid/view/KeyEvent;->getAction()I

    move-result p0

    const/4 v2, 0x1

    if-ne p0, v2, :cond_1

    .line 154
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Key up dispatch to "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    :goto_0
    return-void
.end method

.method public debugOnDrawDone(Landroid/view/View;J)V
    .locals 4

    .line 186
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sub-long/2addr v0, p2

    .line 187
    sget p0, Lcom/mediatek/view/ViewDebugManager;->DBG_TIMEOUT_VALUE:I

    int-to-long p2, p0

    cmp-long p0, v0, p2

    const-string p2, " ms"

    const-string/jumbo p3, "time ="

    const-string v2, "View"

    if-lez p0, :cond_0

    .line 188
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "[ANR Warning]onDraw time too long, this ="

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 191
    :cond_0
    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_DRAW:Z

    if-eqz p0, :cond_1

    .line 192
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "onDraw done, this ="

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    return-void
.end method

.method public debugOnLayoutEnd(Landroid/view/View;J)V
    .locals 3

    .line 225
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sub-long/2addr v0, p2

    .line 226
    sget p0, Lcom/mediatek/view/ViewDebugManager;->DBG_TIMEOUT_VALUE:I

    int-to-long p2, p0

    cmp-long p0, v0, p2

    const-string p2, " ms"

    const-string p3, "View"

    if-lez p0, :cond_0

    .line 227
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[ANR Warning]onLayout time too long, this ="

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string/jumbo v2, "time ="

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p3, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 230
    :cond_0
    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_LAYOUT:Z

    if-eqz p0, :cond_1

    .line 231
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "view layout end, this ="

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ", time ="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p3, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    return-void
.end method

.method public debugOnMeasureEnd(Landroid/view/View;J)V
    .locals 3

    .line 212
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sub-long/2addr v0, p2

    .line 213
    sget p0, Lcom/mediatek/view/ViewDebugManager;->DBG_TIMEOUT_VALUE:I

    int-to-long p2, p0

    cmp-long p0, v0, p2

    const-string p2, " ms"

    const-string p3, "View"

    if-lez p0, :cond_0

    .line 214
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[ANR Warning]onMeasure time too long, this ="

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string/jumbo v2, "time ="

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p3, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 217
    :cond_0
    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_LAYOUT:Z

    if-eqz p0, :cond_1

    .line 218
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "view onMeasure end (measure cache), this ="

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ", mMeasuredWidth = "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 219
    invoke-virtual {p1}, Landroid/view/View;->getMeasuredWidth()I

    move-result v2

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", mMeasuredHeight = "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 220
    invoke-virtual {p1}, Landroid/view/View;->getMeasuredHeight()I

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", time ="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 218
    invoke-static {p3, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    return-void
.end method

.method public debugOnMeasureStart(Landroid/view/View;IIII)J
    .locals 2

    .line 200
    sget-boolean v0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_LAYOUT:Z

    if-eqz v0, :cond_0

    .line 201
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "view measure start, this = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", widthMeasureSpec = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 202
    invoke-static {p2}, Landroid/view/View$MeasureSpec;->toString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ", heightMeasureSpec = "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 203
    invoke-static {p3}, Landroid/view/View$MeasureSpec;->toString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ", mOldWidthMeasureSpec = "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 204
    invoke-static {p4}, Landroid/view/View$MeasureSpec;->toString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ", mOldHeightMeasureSpec = "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 205
    invoke-static {p5}, Landroid/view/View$MeasureSpec;->toString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0, p1}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->getViewLayoutProperties(Landroid/view/View;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "View"

    .line 201
    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 207
    :cond_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p0

    return-wide p0
.end method

.method public debugTouchDispatched(Landroid/view/View;Landroid/view/MotionEvent;)V
    .locals 4

    .line 164
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getAction()I

    move-result p0

    const-string v0, ", event x = "

    const-string v1, ",y = "

    const-string v2, "View"

    if-nez p0, :cond_0

    .line 165
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Touch down dispatch to "

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 166
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getX()F

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 165
    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 167
    :cond_0
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getAction()I

    move-result p0

    const/4 v3, 0x1

    if-ne p0, v3, :cond_1

    .line 168
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Touch up dispatch to "

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 169
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getX()F

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 168
    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 171
    :cond_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "(View)dispatchTouchEvent: event action = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 172
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    invoke-static {v0}, Landroid/view/MotionEvent;->actionToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ",x = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 173
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getX()F

    move-result v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getY()F

    move-result p2

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string p2, ",this = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 171
    invoke-static {v2, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public debugTraveralDone(Ljava/lang/Object;Ljava/lang/Object;ZLandroid/view/ViewRootImpl;ZZLjava/lang/String;)V
    .locals 0

    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    .line 597
    iget p0, p4, Landroid/view/ViewRootImpl;->mFrame:I

    int-to-long p0, p0

    goto :goto_0

    :cond_0
    const-wide/16 p0, -0x3e7

    .line 599
    :goto_0
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "ViewRoot performTraversals and draw- : frame#"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p0, ", isViewVisible = "

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, " (cancelDraw = "

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p7, p0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 602
    iget p0, p4, Landroid/view/ViewRootImpl;->mFrame:I

    add-int/lit8 p0, p0, 0x1

    iput p0, p4, Landroid/view/ViewRootImpl;->mFrame:I

    return-void
.end method

.method public debugViewGroupChildMeasure(Landroid/view/View;Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;II)V
    .locals 3

    .line 304
    invoke-direct {p0, p2}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->getCurrentLevel(Landroid/view/View;)I

    move-result v0

    .line 305
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[ViewGroup][measureChildWithMargins] +"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " , child = "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ", child params (width, height) = "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p3, Landroid/view/ViewGroup$LayoutParams;->width:I

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ","

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p3, p3, Landroid/view/ViewGroup$LayoutParams;->height:I

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, ", widthUsed = "

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, ", heightUsed = "

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, ", parent padding (L,R,T,B) = "

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 309
    invoke-virtual {p2}, Landroid/view/View;->getPaddingLeft()I

    move-result p3

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/view/View;->getPaddingRight()I

    move-result p3

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 310
    invoke-virtual {p2}, Landroid/view/View;->getPaddingTop()I

    move-result p3

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", this = "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "View"

    .line 305
    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public debugViewGroupChildMeasure(Landroid/view/View;Landroid/view/View;Landroid/view/ViewGroup$MarginLayoutParams;II)V
    .locals 3

    .line 292
    invoke-direct {p0, p2}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->getCurrentLevel(Landroid/view/View;)I

    move-result v0

    .line 293
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[ViewGroup][measureChildWithMargins] +"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " , child = "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ", child margin (L,R,T,B) = "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p3, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ","

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p3, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p3, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p3, p3, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, ", widthUsed = "

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, ", heightUsed = "

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, ", parent padding (L,R,T,B) = "

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 297
    invoke-virtual {p2}, Landroid/view/View;->getPaddingLeft()I

    move-result p3

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/view/View;->getPaddingRight()I

    move-result p3

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 298
    invoke-virtual {p2}, Landroid/view/View;->getPaddingTop()I

    move-result p3

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", this = "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "View"

    .line 293
    invoke-static {p1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public debugViewRemoved(Landroid/view/View;Landroid/view/ViewGroup;Ljava/lang/Thread;)V
    .locals 2

    .line 279
    invoke-virtual {p2}, Landroid/view/ViewGroup;->getViewRootImpl()Landroid/view/ViewRootImpl;

    move-result-object p0

    const-string v0, " view == "

    const-string v1, "View"

    if-eqz p0, :cond_0

    .line 280
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p0

    if-eq p3, p0, :cond_0

    .line 281
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "[Warning] remove view from parent not in UIThread: parent = "

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 284
    :cond_0
    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_LIFECYCLE:Z

    if-eqz p0, :cond_1

    .line 285
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p3, "will remove view from parent "

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    new-instance p1, Ljava/lang/Throwable;

    invoke-direct {p1}, Ljava/lang/Throwable;-><init>()V

    invoke-static {v1, p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_1
    return-void
.end method

.method public debugViewRootConstruct(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Landroid/view/ViewRootImpl;)V
    .locals 4

    .line 320
    sget-wide v0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->sIdent:J

    const-wide/16 v2, 0x1

    add-long/2addr v2, v0

    sput-wide v2, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->sIdent:J

    iput-wide v0, p6, Landroid/view/ViewRootImpl;->mIdent:J

    .line 321
    invoke-static {}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->checkViewRootImplLogProperty()V

    .line 322
    sget-boolean v0, Lcom/mediatek/view/ViewDebugManager;->LOCAL_LOGV:Z

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    .line 323
    invoke-virtual {p0, p1, v0}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->enableLog(Ljava/lang/String;Z)V

    .line 326
    :cond_0
    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_LIFECYCLE:Z

    if-eqz p0, :cond_1

    .line 327
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "ViewRootImpl construct: context = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p2, ", mThread = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p2, ", mChoreographer = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p2, ", mTraversalRunnable = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p2, ", this = "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    return-void
.end method

.method public dumpInputDispatchingStatus(Ljava/lang/String;)V
    .locals 13

    .line 460
    new-instance v0, Landroid/icu/text/SimpleDateFormat;

    const-string/jumbo v1, "yyyy-MM-dd HH:mm:ss.SSS"

    invoke-direct {v0, v1}, Landroid/icu/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    .line 461
    new-instance v1, Ljava/util/Date;

    iget-wide v2, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStartTime:J

    invoke-direct {v1, v2, v3}, Ljava/util/Date;-><init>(J)V

    .line 462
    new-instance v2, Ljava/util/Date;

    iget-wide v3, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mPreviousKeyEventFinishTime:J

    invoke-direct {v2, v3, v4}, Ljava/util/Date;-><init>(J)V

    .line 463
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    iget-wide v5, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStartTime:J

    sub-long/2addr v3, v5

    .line 464
    iget-object v5, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentKeyEvent:Landroid/view/KeyEvent;

    const-string v6, ",finish at "

    const-string v7, "ms."

    const-string v8, ", spent "

    const-string v9, ",start at "

    const-string v10, " status is "

    const-string v11, "Dispatch "

    if-nez v5, :cond_0

    const-string v3, "ANR Key Analyze: No Key event currently."

    .line 465
    invoke-static {p1, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 466
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "ANR Key Analyze: Previeous Event "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mPreviousKeyEvent:Landroid/view/KeyEvent;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 467
    invoke-virtual {v0, v2}, Landroid/icu/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 466
    invoke-static {p1, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 469
    :cond_0
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentKeyEvent:Landroid/view/KeyEvent;

    invoke-virtual {v5, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v12, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStatus:Ljava/lang/String;

    invoke-virtual {v5, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 470
    invoke-virtual {v0, v1}, Landroid/icu/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v5, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 469
    invoke-static {p1, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 474
    :goto_0
    iget-object v3, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentMotion:Landroid/view/MotionEvent;

    if-nez v3, :cond_1

    .line 475
    iget-wide v3, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mPreviousMotionEventFinishTime:J

    invoke-virtual {v2, v3, v4}, Ljava/util/Date;->setTime(J)V

    const-string v1, "ANR Motion Analyze: No motion event currently."

    .line 476
    invoke-static {p1, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 477
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "ANR Motion Analyze: Previeous Event "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mPreviousMotion:Landroid/view/MotionEvent;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 478
    invoke-virtual {v0, v2}, Landroid/icu/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 477
    invoke-static {p1, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 480
    :cond_1
    iget-wide v2, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStartTime:J

    invoke-virtual {v1, v2, v3}, Ljava/util/Date;->setTime(J)V

    .line 481
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    iget-wide v4, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStartTime:J

    sub-long/2addr v2, v4

    .line 482
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mCurrentMotion:Landroid/view/MotionEvent;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStatus:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 483
    invoke-virtual {v0, v1}, Landroid/icu/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 482
    invoke-static {p1, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 487
    :goto_1
    invoke-virtual {p0, p1, v0}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->dumpInputStageInfo(Ljava/lang/String;Landroid/icu/text/SimpleDateFormat;)V

    .line 488
    invoke-virtual {p0}, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->clearInputStageInfo()V

    return-void
.end method

.method dumpInputStageInfo(Ljava/lang/String;Landroid/icu/text/SimpleDateFormat;)V
    .locals 7

    .line 502
    iget-object v0, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mInputStageRecored:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_1

    .line 503
    iget-object v0, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mInputStageRecored:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    .line 504
    iget-object v2, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mInputStageRecored:Ljava/util/HashMap;

    invoke-virtual {v2, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Long;

    invoke-virtual {v2}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    .line 505
    new-instance v4, Ljava/util/Date;

    invoke-direct {v4, v2, v3}, Ljava/util/Date;-><init>(J)V

    const-wide/16 v5, 0x0

    cmp-long v2, v2, v5

    if-eqz v2, :cond_0

    .line 507
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Input event delivered to "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " at "

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 508
    invoke-virtual {p2, v4}, Landroid/icu/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 507
    invoke-static {p1, v1}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_1
    return-void
.end method

.method enableLog(Ljava/lang/String;Z)V
    .locals 1

    .line 342
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "enableLog: enable = "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p1, p0}, Landroid/util/Log;->v(Ljava/lang/String;Ljava/lang/String;)I

    .line 343
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->LOCAL_LOGV:Z

    .line 344
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_DRAW:Z

    .line 345
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_LAYOUT:Z

    .line 346
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_DIALOG:Z

    .line 347
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_INPUT_RESIZE:Z

    .line 348
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_ORIENTATION:Z

    .line 349
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_TRACKBALL:Z

    .line 350
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_IMF:Z

    .line 351
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_CONFIGURATION:Z

    .line 352
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_FPS:Z

    .line 353
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_INPUT:Z

    .line 354
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_IME_ANR:Z

    .line 355
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_LIFECYCLE:Z

    .line 356
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_REQUESTLAYOUT:Z

    .line 357
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_INVALIDATE:Z

    .line 358
    sput-boolean p2, Lcom/mediatek/view/ViewDebugManager;->DEBUG_SCHEDULETRAVERSALS:Z

    return-void
.end method

.method setKeyDispatchState(Ljava/lang/String;)V
    .locals 0

    .line 584
    iput-object p1, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mKeyEventStatus:Ljava/lang/String;

    return-void
.end method

.method setMotionDispatchState(Ljava/lang/String;)V
    .locals 0

    .line 588
    iput-object p1, p0, Lcom/mediatek/view/impl/ViewDebugManagerImpl;->mMotionEventStatus:Ljava/lang/String;

    return-void
.end method

.method public warningParentToNull(Landroid/view/View;)V
    .locals 2

    .line 178
    sget-boolean p0, Lcom/mediatek/view/ViewDebugManager;->DEBUG_MOTION:Z

    const-string v0, "View"

    if-eqz p0, :cond_0

    .line 179
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "assignParent to null: this = "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", callstack = "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    new-instance v1, Ljava/lang/Throwable;

    invoke-direct {v1}, Ljava/lang/Throwable;-><init>()V

    invoke-static {v0, p0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 182
    :cond_0
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[Warning] assignParent to null: this = "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
