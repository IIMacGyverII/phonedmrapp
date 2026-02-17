.class public Lcom/pri/anim/spring/SpringOverScroller;
.super Ljava/lang/Object;
.source "SpringOverScroller.java"

# interfaces
.implements Lcom/pri/anim/spring/SpringListener;
.implements Lcom/pri/anim/spring/IOverScroller;


# static fields
.field public static final COASTING_CONFIG:Lcom/pri/anim/spring/SpringConfig;

.field private static final DBG:Z = true

.field public static final RUBBERBANDING_CONFIG:Lcom/pri/anim/spring/SpringConfig;

.field private static final TAG:Ljava/lang/String; = "SpringOverScroller"


# instance fields
.field private mFlingSpringCfg:Lcom/pri/anim/spring/SpringConfig;

.field private mSpringBackSpringCfg:Lcom/pri/anim/spring/SpringConfig;

.field private final mSpringSystem:Lcom/pri/anim/spring/SpringSystem;

.field private final mSpringX:Lcom/pri/anim/spring/Spring;

.field private final mSpringY:Lcom/pri/anim/spring/Spring;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    const-wide/16 v0, 0x0

    const-wide/high16 v2, 0x3fe0000000000000L    # 0.5

    .line 17
    invoke-static {v0, v1, v2, v3}, Lcom/pri/anim/spring/SpringConfig;->fromOrigamiTensionAndFriction(DD)Lcom/pri/anim/spring/SpringConfig;

    move-result-object v0

    sput-object v0, Lcom/pri/anim/spring/SpringOverScroller;->COASTING_CONFIG:Lcom/pri/anim/spring/SpringConfig;

    const-wide v0, 0x40a1a60000000000L    # 2259.0

    const-wide v2, 0x4073800000000000L    # 312.0

    .line 19
    invoke-static {v0, v1, v2, v3}, Lcom/pri/anim/spring/SpringConfig;->fromOrigamiTensionAndFriction(DD)Lcom/pri/anim/spring/SpringConfig;

    move-result-object v0

    sput-object v0, Lcom/pri/anim/spring/SpringOverScroller;->RUBBERBANDING_CONFIG:Lcom/pri/anim/spring/SpringConfig;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    const/4 v0, 0x0

    .line 25
    invoke-direct {p0, p1, v0}, Lcom/pri/anim/spring/SpringOverScroller;-><init>(Landroid/content/Context;Landroid/view/animation/Interpolator;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/view/animation/Interpolator;)V
    .locals 1

    const/4 v0, 0x1

    .line 29
    invoke-direct {p0, p1, p2, v0}, Lcom/pri/anim/spring/SpringOverScroller;-><init>(Landroid/content/Context;Landroid/view/animation/Interpolator;Z)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/view/animation/Interpolator;FF)V
    .locals 0

    const/4 p3, 0x1

    .line 34
    invoke-direct {p0, p1, p2, p3}, Lcom/pri/anim/spring/SpringOverScroller;-><init>(Landroid/content/Context;Landroid/view/animation/Interpolator;Z)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/view/animation/Interpolator;FFZ)V
    .locals 0

    .line 39
    invoke-direct {p0, p1, p2, p5}, Lcom/pri/anim/spring/SpringOverScroller;-><init>(Landroid/content/Context;Landroid/view/animation/Interpolator;Z)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/view/animation/Interpolator;Z)V
    .locals 0

    .line 42
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 43
    invoke-static {}, Lcom/pri/anim/spring/SpringSystem;->create()Lcom/pri/anim/spring/SpringSystem;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringSystem:Lcom/pri/anim/spring/SpringSystem;

    .line 45
    invoke-virtual {p1}, Lcom/pri/anim/spring/BaseSpringSystem;->createSpring()Lcom/pri/anim/spring/Spring;

    move-result-object p2

    .line 46
    invoke-virtual {p2, p0}, Lcom/pri/anim/spring/Spring;->addListener(Lcom/pri/anim/spring/SpringListener;)Lcom/pri/anim/spring/Spring;

    move-result-object p2

    iput-object p2, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    .line 48
    invoke-virtual {p1}, Lcom/pri/anim/spring/BaseSpringSystem;->createSpring()Lcom/pri/anim/spring/Spring;

    move-result-object p1

    .line 49
    invoke-virtual {p1, p0}, Lcom/pri/anim/spring/Spring;->addListener(Lcom/pri/anim/spring/SpringListener;)Lcom/pri/anim/spring/Spring;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    return-void
.end method


# virtual methods
.method public abortAnimation()V
    .locals 1

    .line 165
    iget-object v0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    invoke-virtual {v0}, Lcom/pri/anim/spring/Spring;->setAtRest()Lcom/pri/anim/spring/Spring;

    .line 166
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->setAtRest()Lcom/pri/anim/spring/Spring;

    return-void
.end method

.method public computeScrollOffset()Z
    .locals 1

    .line 95
    iget-object v0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    invoke-virtual {v0}, Lcom/pri/anim/spring/Spring;->isAtRest()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->isAtRest()Z

    move-result p0

    if-nez p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method public fling(IIIIIIII)V
    .locals 11

    const/4 v9, 0x0

    const/4 v10, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move/from16 v5, p5

    move/from16 v6, p6

    move/from16 v7, p7

    move/from16 v8, p8

    .line 142
    invoke-virtual/range {v0 .. v10}, Lcom/pri/anim/spring/SpringOverScroller;->fling(IIIIIIIIII)V

    return-void
.end method

.method public fling(IIIIIIIIII)V
    .locals 0

    .line 147
    iget-object p5, p0, Lcom/pri/anim/spring/SpringOverScroller;->mFlingSpringCfg:Lcom/pri/anim/spring/SpringConfig;

    if-eqz p5, :cond_0

    goto :goto_0

    :cond_0
    sget-object p5, Lcom/pri/anim/spring/SpringOverScroller;->COASTING_CONFIG:Lcom/pri/anim/spring/SpringConfig;

    .line 149
    :goto_0
    new-instance p6, Ljava/lang/StringBuilder;

    invoke-direct {p6}, Ljava/lang/StringBuilder;-><init>()V

    const-string p9, "fling: startY="

    invoke-virtual {p6, p9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p6, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p9, ", velY="

    invoke-virtual {p6, p9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p6, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p9, ", minY="

    invoke-virtual {p6, p9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p6, p7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p7, ", maxY="

    invoke-virtual {p6, p7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p6, p8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p7, ", overY="

    invoke-virtual {p6, p7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p6, p10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p7, ", tension="

    invoke-virtual {p6, p7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide p7, p5, Lcom/pri/anim/spring/SpringConfig;->tension:D

    invoke-virtual {p6, p7, p8}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string p7, ", friction="

    invoke-virtual {p6, p7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide p7, p5, Lcom/pri/anim/spring/SpringConfig;->friction:D

    invoke-virtual {p6, p7, p8}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {p6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p6

    const-string p7, "SpringOverScroller"

    invoke-static {p7, p6}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 154
    iget-object p6, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    .line 155
    invoke-virtual {p6, p5}, Lcom/pri/anim/spring/Spring;->setSpringConfig(Lcom/pri/anim/spring/SpringConfig;)Lcom/pri/anim/spring/Spring;

    move-result-object p6

    int-to-double p7, p1

    .line 156
    invoke-virtual {p6, p7, p8}, Lcom/pri/anim/spring/Spring;->setCurrentValue(D)Lcom/pri/anim/spring/Spring;

    move-result-object p1

    int-to-double p6, p3

    .line 157
    invoke-virtual {p1, p6, p7}, Lcom/pri/anim/spring/Spring;->setVelocity(D)Lcom/pri/anim/spring/Spring;

    .line 158
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    .line 159
    invoke-virtual {p0, p5}, Lcom/pri/anim/spring/Spring;->setSpringConfig(Lcom/pri/anim/spring/SpringConfig;)Lcom/pri/anim/spring/Spring;

    move-result-object p0

    int-to-double p1, p2

    .line 160
    invoke-virtual {p0, p1, p2}, Lcom/pri/anim/spring/Spring;->setCurrentValue(D)Lcom/pri/anim/spring/Spring;

    move-result-object p0

    int-to-double p1, p4

    .line 161
    invoke-virtual {p0, p1, p2}, Lcom/pri/anim/spring/Spring;->setVelocity(D)Lcom/pri/anim/spring/Spring;

    return-void
.end method

.method public getCurrVelocity()F
    .locals 4

    .line 73
    iget-object v0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    invoke-virtual {v0}, Lcom/pri/anim/spring/Spring;->getVelocity()D

    move-result-wide v0

    .line 74
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getVelocity()D

    move-result-wide v2

    mul-double/2addr v0, v0

    mul-double/2addr v2, v2

    add-double/2addr v0, v2

    .line 75
    invoke-static {v0, v1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v0

    double-to-int p0, v0

    int-to-float p0, p0

    return p0
.end method

.method public final getCurrX()I
    .locals 2

    .line 65
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getCurrentValue()D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v0

    long-to-int p0, v0

    return p0
.end method

.method public final getCurrY()I
    .locals 2

    .line 69
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getCurrentValue()D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v0

    long-to-int p0, v0

    return p0
.end method

.method public final getFinalX()I
    .locals 2

    .line 87
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getEndValue()D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v0

    long-to-int p0, v0

    return p0
.end method

.method public final getFinalY()I
    .locals 2

    .line 91
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getEndValue()D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v0

    long-to-int p0, v0

    return p0
.end method

.method public final getStartX()I
    .locals 2

    .line 79
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getStartValue()D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v0

    long-to-int p0, v0

    return p0
.end method

.method public final getStartY()I
    .locals 2

    .line 83
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getStartValue()D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v0

    long-to-int p0, v0

    return p0
.end method

.method public final isFinished()Z
    .locals 1

    .line 61
    iget-object v0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    invoke-virtual {v0}, Lcom/pri/anim/spring/Spring;->isAtRest()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->isAtRest()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public onSpringActivate(Lcom/pri/anim/spring/Spring;)V
    .locals 0

    return-void
.end method

.method public onSpringAtRest(Lcom/pri/anim/spring/Spring;)V
    .locals 0

    return-void
.end method

.method public onSpringEndStateChange(Lcom/pri/anim/spring/Spring;)V
    .locals 0

    return-void
.end method

.method public onSpringUpdate(Lcom/pri/anim/spring/Spring;)V
    .locals 0

    return-void
.end method

.method public setFlingConfig(Lcom/pri/anim/spring/SpringConfig;)V
    .locals 0

    .line 53
    iput-object p1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mFlingSpringCfg:Lcom/pri/anim/spring/SpringConfig;

    return-void
.end method

.method public setSpringBackConfig(Lcom/pri/anim/spring/SpringConfig;)V
    .locals 0

    .line 57
    iput-object p1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringBackSpringCfg:Lcom/pri/anim/spring/SpringConfig;

    return-void
.end method

.method public springBack(IIIIII)Z
    .locals 7

    .line 108
    iget-object v0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringBackSpringCfg:Lcom/pri/anim/spring/SpringConfig;

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    sget-object v0, Lcom/pri/anim/spring/SpringOverScroller;->RUBBERBANDING_CONFIG:Lcom/pri/anim/spring/SpringConfig;

    .line 110
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "springBack: startY="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", minY="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", maxY="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", tension="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, v0, Lcom/pri/anim/spring/SpringConfig;->tension:D

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string v2, ", friction="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, v0, Lcom/pri/anim/spring/SpringConfig;->friction:D

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "SpringOverScroller"

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 114
    iget-object v1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    int-to-double v2, p1

    const/4 v4, 0x0

    invoke-virtual {v1, v2, v3, v4}, Lcom/pri/anim/spring/Spring;->setCurrentValue(DZ)Lcom/pri/anim/spring/Spring;

    .line 115
    iget-object v1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    int-to-double v5, p2

    invoke-virtual {v1, v5, v6, v4}, Lcom/pri/anim/spring/Spring;->setCurrentValue(DZ)Lcom/pri/anim/spring/Spring;

    const/4 v1, 0x1

    if-gt p1, p4, :cond_6

    if-ge p1, p3, :cond_1

    goto :goto_3

    :cond_1
    if-gt p2, p6, :cond_3

    if-ge p2, p5, :cond_2

    goto :goto_1

    .line 135
    :cond_2
    iget-object p1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p1, v2, v3}, Lcom/pri/anim/spring/Spring;->setEndValue(D)Lcom/pri/anim/spring/Spring;

    .line 136
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0, v5, v6}, Lcom/pri/anim/spring/Spring;->setEndValue(D)Lcom/pri/anim/spring/Spring;

    return v1

    :cond_3
    :goto_1
    if-le p2, p6, :cond_4

    .line 127
    iget-object p1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    int-to-double p2, p6

    invoke-virtual {p1, p2, p3}, Lcom/pri/anim/spring/Spring;->setEndValue(D)Lcom/pri/anim/spring/Spring;

    goto :goto_2

    :cond_4
    if-ge p2, p5, :cond_5

    .line 129
    iget-object p1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    int-to-double p2, p5

    invoke-virtual {p1, p2, p3}, Lcom/pri/anim/spring/Spring;->setEndValue(D)Lcom/pri/anim/spring/Spring;

    .line 131
    :cond_5
    :goto_2
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0, v0}, Lcom/pri/anim/spring/Spring;->setSpringConfig(Lcom/pri/anim/spring/SpringConfig;)Lcom/pri/anim/spring/Spring;

    return v1

    :cond_6
    :goto_3
    if-le p1, p4, :cond_7

    .line 118
    iget-object p1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    int-to-double p2, p4

    invoke-virtual {p1, p2, p3}, Lcom/pri/anim/spring/Spring;->setEndValue(D)Lcom/pri/anim/spring/Spring;

    goto :goto_4

    :cond_7
    if-ge p1, p3, :cond_8

    .line 120
    iget-object p1, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    int-to-double p2, p3

    invoke-virtual {p1, p2, p3}, Lcom/pri/anim/spring/Spring;->setEndValue(D)Lcom/pri/anim/spring/Spring;

    .line 122
    :cond_8
    :goto_4
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    invoke-virtual {p0, v0}, Lcom/pri/anim/spring/Spring;->setSpringConfig(Lcom/pri/anim/spring/SpringConfig;)Lcom/pri/anim/spring/Spring;

    return v1
.end method

.method public startScroll(IIII)V
    .locals 6

    const/4 v5, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    .line 99
    invoke-virtual/range {v0 .. v5}, Lcom/pri/anim/spring/SpringOverScroller;->startScroll(IIIII)V

    return-void
.end method

.method public startScroll(IIIII)V
    .locals 2

    .line 103
    iget-object p5, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringX:Lcom/pri/anim/spring/Spring;

    int-to-double v0, p1

    invoke-virtual {p5, v0, v1}, Lcom/pri/anim/spring/Spring;->setCurrentValue(D)Lcom/pri/anim/spring/Spring;

    move-result-object p1

    int-to-double v0, p3

    invoke-virtual {p1, v0, v1}, Lcom/pri/anim/spring/Spring;->setEndValue(D)Lcom/pri/anim/spring/Spring;

    .line 104
    iget-object p0, p0, Lcom/pri/anim/spring/SpringOverScroller;->mSpringY:Lcom/pri/anim/spring/Spring;

    int-to-double p1, p2

    invoke-virtual {p0, p1, p2}, Lcom/pri/anim/spring/Spring;->setCurrentValue(D)Lcom/pri/anim/spring/Spring;

    move-result-object p0

    int-to-double p1, p4

    invoke-virtual {p0, p1, p2}, Lcom/pri/anim/spring/Spring;->setEndValue(D)Lcom/pri/anim/spring/Spring;

    return-void
.end method
