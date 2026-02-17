.class Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;
.super Landroid/view/GestureDetector$SimpleOnGestureListener;
.source "ScrollIdentify.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "ScrollGestureListener"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;


# direct methods
.method constructor <init>(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)V
    .locals 0

    .line 275
    iput-object p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-direct {p0}, Landroid/view/GestureDetector$SimpleOnGestureListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onDown(Landroid/view/MotionEvent;)Z
    .locals 0

    .line 278
    invoke-static {}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->getInstance()Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;

    move-result-object p0

    const/4 p1, 0x1

    invoke-virtual {p0, p1}, Lcom/mediatek/boostfwk/policy/frame/ScrollingFramePrefetcher;->disableAndLockSFP(Z)V

    return p1
.end method

.method public onFling(Landroid/view/MotionEvent;Landroid/view/MotionEvent;FF)Z
    .locals 3

    const/4 v0, 0x0

    if-eqz p1, :cond_5

    if-nez p2, :cond_0

    goto/16 :goto_1

    .line 316
    :cond_0
    iget-object v1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-static {v1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$fgetmActivityInfo(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object v1

    const/16 v2, 0x40

    invoke-virtual {v1, v2}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result v1

    if-eqz v1, :cond_1

    return v0

    .line 319
    :cond_1
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getX()F

    move-result v0

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v1

    sub-float/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Math;->abs(F)F

    move-result v0

    .line 320
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getY()F

    move-result p2

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    sub-float/2addr p2, p1

    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p1

    .line 321
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p2

    const-string v1, "ScrollIdentify"

    if-eqz p2, :cond_2

    .line 322
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onFling --> distanceX: "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v2, ", Math.abs(velocityX):"

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 323
    invoke-static {p3}, Ljava/lang/Math;->abs(F)F

    move-result v2

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v2, ", distanceY: "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v2, ", Math.abs(velocityY): "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 325
    invoke-static {p4}, Ljava/lang/Math;->abs(F)F

    move-result v2

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 322
    invoke-static {v1, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    const-string p2, "on fling"

    .line 327
    invoke-static {v1, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogi(Ljava/lang/String;Ljava/lang/String;)V

    .line 329
    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-static {p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$minitMinValuesIfNeeded(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)V

    .line 332
    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-static {p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$fgetminTouchDistanceHorizontal(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)F

    move-result p2

    cmpl-float p2, v0, p2

    if-lez p2, :cond_3

    invoke-static {p3}, Ljava/lang/Math;->abs(F)F

    move-result p2

    iget-object p3, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-static {p3}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$fgetminVelocityHorizontal(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)F

    move-result p3

    cmpl-float p2, p2, p3

    if-lez p2, :cond_3

    const/high16 p2, 0x3f000000    # 0.5f

    mul-float/2addr v0, p2

    cmpl-float p2, v0, p1

    if-lez p2, :cond_3

    .line 334
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    const/4 p1, 0x3

    const-string p2, "onFling Boost when FLING_HORIZONTAL"

    invoke-static {p0, p1, p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$msbeHint(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;ILjava/lang/String;)V

    goto :goto_0

    .line 335
    :cond_3
    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-static {p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$fgetminTouchDistanceVertical(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)F

    move-result p2

    cmpl-float p1, p1, p2

    if-lez p1, :cond_4

    invoke-static {p4}, Ljava/lang/Math;->abs(F)F

    move-result p1

    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-static {p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$fgetminVelocityVertical(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)F

    move-result p2

    cmpl-float p1, p1, p2

    if-lez p1, :cond_4

    .line 337
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    const/4 p1, 0x2

    const-string p2, "onFling Boost when FLING_VERTICAL"

    invoke-static {p0, p1, p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$msbeHint(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;ILjava/lang/String;)V

    :cond_4
    :goto_0
    const/4 p0, 0x1

    return p0

    :cond_5
    :goto_1
    return v0
.end method

.method public onScroll(Landroid/view/MotionEvent;Landroid/view/MotionEvent;FF)Z
    .locals 3

    const/4 p3, 0x0

    if-eqz p1, :cond_7

    if-nez p2, :cond_0

    goto/16 :goto_1

    .line 289
    :cond_0
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result p4

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getX()F

    move-result v0

    sub-float/2addr p4, v0

    invoke-static {p4}, Ljava/lang/Math;->abs(F)F

    move-result p4

    .line 290
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getY()F

    move-result p2

    sub-float/2addr p1, p2

    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result p1

    const/high16 p2, 0x42480000    # 50.0f

    cmpl-float v0, p4, p2

    const/4 v1, 0x1

    if-gtz v0, :cond_1

    cmpl-float p2, p1, p2

    if-lez p2, :cond_6

    .line 293
    :cond_1
    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-static {p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$mcheckSpecialPageType(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)V

    .line 294
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p2

    const-string v0, "ScrollIdentify"

    if-eqz p2, :cond_2

    .line 295
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mIsSpecialPageDesign = "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$sfgetmIsSpecialPageDesign()I

    move-result v2

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v0, p2}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 297
    :cond_2
    iget-object p2, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-static {p2}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$fgetmActivityInfo(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;)Lcom/mediatek/boostfwk/info/ActivityInfo;

    move-result-object p2

    const/16 v2, 0x40

    invoke-virtual {p2, v2}, Lcom/mediatek/boostfwk/info/ActivityInfo;->isPage(I)Z

    move-result p2

    if-eqz p2, :cond_3

    return p3

    .line 300
    :cond_3
    invoke-static {}, Lcom/mediatek/boostfwk/utils/Config;->isBoostFwkLogEnable()Z

    move-result p2

    if-eqz p2, :cond_5

    .line 301
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onScroll - "

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    cmpl-float p1, p4, p1

    if-lez p1, :cond_4

    const-string p1, "horizontal"

    goto :goto_0

    :cond_4
    const-string/jumbo p1, "vertical"

    .line 302
    :goto_0
    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 301
    invoke-static {v0, p1}, Lcom/mediatek/boostfwk/utils/LogUtil;->mLogd(Ljava/lang/String;Ljava/lang/String;)V

    .line 304
    :cond_5
    iget-object p1, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    invoke-static {p1, v1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$fputmHaveMoveEvent(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;Z)V

    .line 305
    iget-object p0, p0, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify$ScrollGestureListener;->this$0:Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;

    const-string p1, "Boost when move"

    invoke-static {p0, p3, p1}, Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;->-$$Nest$msbeHint(Lcom/mediatek/boostfwk/identify/scroll/ScrollIdentify;ILjava/lang/String;)V

    :cond_6
    return v1

    :cond_7
    :goto_1
    return p3
.end method
