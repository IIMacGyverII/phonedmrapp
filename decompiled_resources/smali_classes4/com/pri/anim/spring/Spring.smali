.class public Lcom/pri/anim/spring/Spring;
.super Ljava/lang/Object;
.source "Spring.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/pri/anim/spring/Spring$PhysicsState;
    }
.end annotation


# static fields
.field private static ID:I = 0x0

.field private static final MAX_DELTA_TIME_SEC:D = 0.064

.field private static final SOLVER_TIMESTEP_SEC:D = 0.001


# instance fields
.field private final mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

.field private mDisplacementFromRestThreshold:D

.field private mEndValue:D

.field private final mId:Ljava/lang/String;

.field private mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/CopyOnWriteArraySet<",
            "Lcom/pri/anim/spring/SpringListener;",
            ">;"
        }
    .end annotation
.end field

.field private mOvershootClampingEnabled:Z

.field private final mPreviousState:Lcom/pri/anim/spring/Spring$PhysicsState;

.field private mRestSpeedThreshold:D

.field private mSpringConfig:Lcom/pri/anim/spring/SpringConfig;

.field private final mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;

.field private mStartValue:D

.field private final mTempState:Lcom/pri/anim/spring/Spring$PhysicsState;

.field private mTimeAccumulator:D

.field private mWasAtRest:Z


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method constructor <init>(Lcom/pri/anim/spring/BaseSpringSystem;)V
    .locals 2

    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 30
    new-instance v0, Lcom/pri/anim/spring/Spring$PhysicsState;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/pri/anim/spring/Spring$PhysicsState;-><init>(Lcom/pri/anim/spring/Spring$1;)V

    iput-object v0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    .line 31
    new-instance v0, Lcom/pri/anim/spring/Spring$PhysicsState;

    invoke-direct {v0, v1}, Lcom/pri/anim/spring/Spring$PhysicsState;-><init>(Lcom/pri/anim/spring/Spring$1;)V

    iput-object v0, p0, Lcom/pri/anim/spring/Spring;->mPreviousState:Lcom/pri/anim/spring/Spring$PhysicsState;

    .line 32
    new-instance v0, Lcom/pri/anim/spring/Spring$PhysicsState;

    invoke-direct {v0, v1}, Lcom/pri/anim/spring/Spring$PhysicsState;-><init>(Lcom/pri/anim/spring/Spring$1;)V

    iput-object v0, p0, Lcom/pri/anim/spring/Spring;->mTempState:Lcom/pri/anim/spring/Spring$PhysicsState;

    const/4 v0, 0x1

    .line 35
    iput-boolean v0, p0, Lcom/pri/anim/spring/Spring;->mWasAtRest:Z

    const-wide v0, 0x3f747ae147ae147bL    # 0.005

    .line 37
    iput-wide v0, p0, Lcom/pri/anim/spring/Spring;->mRestSpeedThreshold:D

    .line 38
    iput-wide v0, p0, Lcom/pri/anim/spring/Spring;->mDisplacementFromRestThreshold:D

    .line 39
    new-instance v0, Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-direct {v0}, Ljava/util/concurrent/CopyOnWriteArraySet;-><init>()V

    iput-object v0, p0, Lcom/pri/anim/spring/Spring;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    const-wide/16 v0, 0x0

    .line 40
    iput-wide v0, p0, Lcom/pri/anim/spring/Spring;->mTimeAccumulator:D

    if-eqz p1, :cond_0

    .line 51
    iput-object p1, p0, Lcom/pri/anim/spring/Spring;->mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;

    .line 52
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "com.pri.anim.com.pri.anim.spring.com.pri.anim.spring:"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v0, Lcom/pri/anim/spring/Spring;->ID:I

    add-int/lit8 v1, v0, 0x1

    sput v1, Lcom/pri/anim/spring/Spring;->ID:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/pri/anim/spring/Spring;->mId:Ljava/lang/String;

    .line 53
    sget-object p1, Lcom/pri/anim/spring/SpringConfig;->defaultConfig:Lcom/pri/anim/spring/SpringConfig;

    invoke-virtual {p0, p1}, Lcom/pri/anim/spring/Spring;->setSpringConfig(Lcom/pri/anim/spring/SpringConfig;)Lcom/pri/anim/spring/Spring;

    return-void

    .line 49
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Spring cannot be created outside of a BaseSpringSystem"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private getDisplacementDistanceForState(Lcom/pri/anim/spring/Spring$PhysicsState;)D
    .locals 2

    .line 161
    iget-wide v0, p0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    iget-wide p0, p1, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    sub-double/2addr v0, p0

    invoke-static {v0, v1}, Ljava/lang/Math;->abs(D)D

    move-result-wide p0

    return-wide p0
.end method

.method private interpolate(D)V
    .locals 7

    .line 488
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v1, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    mul-double/2addr v1, p1

    iget-object p0, p0, Lcom/pri/anim/spring/Spring;->mPreviousState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v3, p0, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    const-wide/high16 v5, 0x3ff0000000000000L    # 1.0

    sub-double/2addr v5, p1

    mul-double/2addr v3, v5

    add-double/2addr v1, v3

    iput-wide v1, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    .line 489
    iget-wide v1, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    mul-double/2addr v1, p1

    iget-wide p0, p0, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    mul-double/2addr p0, v5

    add-double/2addr v1, p0

    iput-wide v1, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    return-void
.end method


# virtual methods
.method public addListener(Lcom/pri/anim/spring/SpringListener;)Lcom/pri/anim/spring/Spring;
    .locals 1

    if-eqz p1, :cond_0

    .line 503
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {v0, p1}, Ljava/util/concurrent/CopyOnWriteArraySet;->add(Ljava/lang/Object;)Z

    return-object p0

    .line 501
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "newListener is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method advance(D)V
    .locals 30

    move-object/from16 v0, p0

    .line 285
    invoke-virtual/range {p0 .. p0}, Lcom/pri/anim/spring/Spring;->isAtRest()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 287
    iget-boolean v2, v0, Lcom/pri/anim/spring/Spring;->mWasAtRest:Z

    if-eqz v2, :cond_0

    return-void

    :cond_0
    const-wide v2, 0x3fb0624dd2f1a9fcL    # 0.064

    cmpl-double v4, p1, v2

    if-lez v4, :cond_1

    goto :goto_0

    :cond_1
    move-wide/from16 v2, p1

    .line 306
    :goto_0
    iget-wide v4, v0, Lcom/pri/anim/spring/Spring;->mTimeAccumulator:D

    add-double/2addr v4, v2

    iput-wide v4, v0, Lcom/pri/anim/spring/Spring;->mTimeAccumulator:D

    .line 308
    iget-object v2, v0, Lcom/pri/anim/spring/Spring;->mSpringConfig:Lcom/pri/anim/spring/SpringConfig;

    iget-wide v3, v2, Lcom/pri/anim/spring/SpringConfig;->tension:D

    .line 309
    iget-wide v5, v2, Lcom/pri/anim/spring/SpringConfig;->friction:D

    .line 313
    iget-object v2, v0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v7, v2, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    .line 314
    iget-wide v9, v2, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    .line 315
    iget-object v2, v0, Lcom/pri/anim/spring/Spring;->mTempState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v11, v2, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    .line 316
    iget-wide v13, v2, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    move v15, v1

    .line 326
    :goto_1
    iget-wide v1, v0, Lcom/pri/anim/spring/Spring;->mTimeAccumulator:D

    const-wide v16, 0x3f50624dd2f1a9fcL    # 0.001

    cmpl-double v18, v1, v16

    if-ltz v18, :cond_3

    sub-double v1, v1, v16

    .line 330
    iput-wide v1, v0, Lcom/pri/anim/spring/Spring;->mTimeAccumulator:D

    cmpg-double v1, v1, v16

    if-gez v1, :cond_2

    .line 335
    iget-object v1, v0, Lcom/pri/anim/spring/Spring;->mPreviousState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iput-wide v7, v1, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    .line 336
    iput-wide v9, v1, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    .line 348
    :cond_2
    iget-wide v1, v0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    sub-double v11, v1, v11

    mul-double/2addr v11, v3

    mul-double v13, v5, v9

    sub-double/2addr v11, v13

    mul-double v13, v9, v16

    const-wide/high16 v18, 0x3fe0000000000000L    # 0.5

    mul-double v13, v13, v18

    add-double/2addr v13, v7

    mul-double v20, v11, v16

    mul-double v20, v20, v18

    add-double v20, v9, v20

    sub-double v13, v1, v13

    mul-double/2addr v13, v3

    mul-double v22, v5, v20

    sub-double v13, v13, v22

    mul-double v22, v20, v16

    mul-double v22, v22, v18

    add-double v22, v7, v22

    mul-double v24, v13, v16

    mul-double v24, v24, v18

    add-double v24, v9, v24

    sub-double v18, v1, v22

    mul-double v18, v18, v3

    mul-double v22, v5, v24

    sub-double v18, v18, v22

    mul-double v22, v24, v16

    add-double v22, v7, v22

    mul-double v26, v18, v16

    add-double v26, v9, v26

    sub-double v1, v1, v22

    mul-double/2addr v1, v3

    mul-double v28, v5, v26

    sub-double v1, v1, v28

    add-double v20, v20, v24

    const-wide/high16 v24, 0x4000000000000000L    # 2.0

    mul-double v20, v20, v24

    add-double v20, v9, v20

    add-double v20, v20, v26

    const-wide v28, 0x3fc5555555555555L    # 0.16666666666666666

    mul-double v20, v20, v28

    add-double v13, v13, v18

    mul-double v13, v13, v24

    add-double/2addr v11, v13

    add-double/2addr v11, v1

    mul-double v11, v11, v28

    mul-double v20, v20, v16

    add-double v7, v7, v20

    mul-double v11, v11, v16

    add-double/2addr v9, v11

    move-wide/from16 v11, v22

    move-wide/from16 v13, v26

    goto :goto_1

    .line 375
    :cond_3
    iget-object v5, v0, Lcom/pri/anim/spring/Spring;->mTempState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iput-wide v11, v5, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    .line 376
    iput-wide v13, v5, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    .line 378
    iget-object v5, v0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iput-wide v7, v5, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    .line 379
    iput-wide v9, v5, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    const-wide/16 v5, 0x0

    cmpl-double v7, v1, v5

    if-lez v7, :cond_4

    div-double v1, v1, v16

    .line 382
    invoke-direct {v0, v1, v2}, Lcom/pri/anim/spring/Spring;->interpolate(D)V

    .line 388
    :cond_4
    invoke-virtual/range {p0 .. p0}, Lcom/pri/anim/spring/Spring;->isAtRest()Z

    move-result v1

    const/4 v2, 0x1

    if-nez v1, :cond_6

    iget-boolean v1, v0, Lcom/pri/anim/spring/Spring;->mOvershootClampingEnabled:Z

    if-eqz v1, :cond_5

    invoke-virtual/range {p0 .. p0}, Lcom/pri/anim/spring/Spring;->isOvershooting()Z

    move-result v1

    if-eqz v1, :cond_5

    goto :goto_2

    :cond_5
    move v1, v15

    goto :goto_4

    :cond_6
    :goto_2
    cmpl-double v1, v3, v5

    if-lez v1, :cond_7

    .line 391
    iget-wide v3, v0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    iput-wide v3, v0, Lcom/pri/anim/spring/Spring;->mStartValue:D

    .line 392
    iget-object v1, v0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iput-wide v3, v1, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    goto :goto_3

    .line 394
    :cond_7
    iget-object v1, v0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v3, v1, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    iput-wide v3, v0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    .line 395
    iput-wide v3, v0, Lcom/pri/anim/spring/Spring;->mStartValue:D

    .line 397
    :goto_3
    invoke-virtual {v0, v5, v6}, Lcom/pri/anim/spring/Spring;->setVelocity(D)Lcom/pri/anim/spring/Spring;

    move v1, v2

    .line 418
    :goto_4
    iget-boolean v3, v0, Lcom/pri/anim/spring/Spring;->mWasAtRest:Z

    const/4 v4, 0x0

    if-eqz v3, :cond_8

    .line 419
    iput-boolean v4, v0, Lcom/pri/anim/spring/Spring;->mWasAtRest:Z

    move v3, v2

    goto :goto_5

    :cond_8
    move v3, v4

    :goto_5
    if-eqz v1, :cond_9

    .line 424
    iput-boolean v2, v0, Lcom/pri/anim/spring/Spring;->mWasAtRest:Z

    goto :goto_6

    :cond_9
    move v2, v4

    .line 427
    :goto_6
    iget-object v1, v0, Lcom/pri/anim/spring/Spring;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {v1}, Ljava/util/concurrent/CopyOnWriteArraySet;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_a
    :goto_7
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_c

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/pri/anim/spring/SpringListener;

    if-eqz v3, :cond_b

    .line 430
    invoke-interface {v4, v0}, Lcom/pri/anim/spring/SpringListener;->onSpringActivate(Lcom/pri/anim/spring/Spring;)V

    .line 434
    :cond_b
    invoke-interface {v4, v0}, Lcom/pri/anim/spring/SpringListener;->onSpringUpdate(Lcom/pri/anim/spring/Spring;)V

    if-eqz v2, :cond_a

    .line 438
    invoke-interface {v4, v0}, Lcom/pri/anim/spring/SpringListener;->onSpringAtRest(Lcom/pri/anim/spring/Spring;)V

    goto :goto_7

    :cond_c
    return-void
.end method

.method public currentValueIsApproximately(D)Z
    .locals 2

    .line 537
    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getCurrentValue()D

    move-result-wide v0

    sub-double/2addr v0, p1

    invoke-static {v0, v1}, Ljava/lang/Math;->abs(D)D

    move-result-wide p1

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getRestDisplacementThreshold()D

    move-result-wide v0

    cmpg-double p0, p1, v0

    if-gtz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public destroy()V
    .locals 1

    .line 62
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {v0}, Ljava/util/concurrent/CopyOnWriteArraySet;->clear()V

    .line 63
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;

    invoke-virtual {v0, p0}, Lcom/pri/anim/spring/BaseSpringSystem;->deregisterSpring(Lcom/pri/anim/spring/Spring;)V

    return-void
.end method

.method public getCurrentDisplacementDistance()D
    .locals 2

    .line 152
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    invoke-direct {p0, v0}, Lcom/pri/anim/spring/Spring;->getDisplacementDistanceForState(Lcom/pri/anim/spring/Spring$PhysicsState;)D

    move-result-wide v0

    return-wide v0
.end method

.method public getCurrentValue()D
    .locals 2

    .line 144
    iget-object p0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v0, p0, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    return-wide v0
.end method

.method public getEndValue()D
    .locals 2

    .line 187
    iget-wide v0, p0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    return-wide v0
.end method

.method public getId()Ljava/lang/String;
    .locals 0

    .line 71
    iget-object p0, p0, Lcom/pri/anim/spring/Spring;->mId:Ljava/lang/String;

    return-object p0
.end method

.method public getRestDisplacementThreshold()D
    .locals 2

    .line 244
    iget-wide v0, p0, Lcom/pri/anim/spring/Spring;->mDisplacementFromRestThreshold:D

    return-wide v0
.end method

.method public getRestSpeedThreshold()D
    .locals 2

    .line 226
    iget-wide v0, p0, Lcom/pri/anim/spring/Spring;->mRestSpeedThreshold:D

    return-wide v0
.end method

.method public getSpringConfig()Lcom/pri/anim/spring/SpringConfig;
    .locals 0

    .line 92
    iget-object p0, p0, Lcom/pri/anim/spring/Spring;->mSpringConfig:Lcom/pri/anim/spring/SpringConfig;

    return-object p0
.end method

.method public getStartValue()D
    .locals 2

    .line 136
    iget-wide v0, p0, Lcom/pri/anim/spring/Spring;->mStartValue:D

    return-wide v0
.end method

.method public getVelocity()D
    .locals 2

    .line 208
    iget-object p0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v0, p0, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    return-wide v0
.end method

.method public isAtRest()Z
    .locals 4

    .line 466
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v0, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    invoke-static {v0, v1}, Ljava/lang/Math;->abs(D)D

    move-result-wide v0

    iget-wide v2, p0, Lcom/pri/anim/spring/Spring;->mRestSpeedThreshold:D

    cmpg-double v0, v0, v2

    if-gtz v0, :cond_1

    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    .line 467
    invoke-direct {p0, v0}, Lcom/pri/anim/spring/Spring;->getDisplacementDistanceForState(Lcom/pri/anim/spring/Spring$PhysicsState;)D

    move-result-wide v0

    iget-wide v2, p0, Lcom/pri/anim/spring/Spring;->mDisplacementFromRestThreshold:D

    cmpg-double v0, v0, v2

    if-lez v0, :cond_0

    iget-object p0, p0, Lcom/pri/anim/spring/Spring;->mSpringConfig:Lcom/pri/anim/spring/SpringConfig;

    iget-wide v0, p0, Lcom/pri/anim/spring/SpringConfig;->tension:D

    const-wide/16 v2, 0x0

    cmpl-double p0, v0, v2

    if-nez p0, :cond_1

    :cond_0
    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isOvershootClampingEnabled()Z
    .locals 0

    .line 262
    iget-boolean p0, p0, Lcom/pri/anim/spring/Spring;->mOvershootClampingEnabled:Z

    return p0
.end method

.method public isOvershooting()Z
    .locals 4

    .line 270
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mSpringConfig:Lcom/pri/anim/spring/SpringConfig;

    iget-wide v0, v0, Lcom/pri/anim/spring/SpringConfig;->tension:D

    const-wide/16 v2, 0x0

    cmpl-double v0, v0, v2

    if-lez v0, :cond_2

    iget-wide v0, p0, Lcom/pri/anim/spring/Spring;->mStartValue:D

    iget-wide v2, p0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    cmpg-double v0, v0, v2

    if-gez v0, :cond_0

    .line 271
    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getCurrentValue()D

    move-result-wide v0

    iget-wide v2, p0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    cmpl-double v0, v0, v2

    if-gtz v0, :cond_1

    :cond_0
    iget-wide v0, p0, Lcom/pri/anim/spring/Spring;->mStartValue:D

    iget-wide v2, p0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    cmpl-double v0, v0, v2

    if-lez v0, :cond_2

    .line 272
    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getCurrentValue()D

    move-result-wide v0

    iget-wide v2, p0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    cmpg-double p0, v0, v2

    if-gez p0, :cond_2

    :cond_1
    const/4 p0, 0x1

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public removeAllListeners()Lcom/pri/anim/spring/Spring;
    .locals 1

    .line 525
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {v0}, Ljava/util/concurrent/CopyOnWriteArraySet;->clear()V

    return-object p0
.end method

.method public removeListener(Lcom/pri/anim/spring/SpringListener;)Lcom/pri/anim/spring/Spring;
    .locals 1

    if-eqz p1, :cond_0

    .line 516
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {v0, p1}, Ljava/util/concurrent/CopyOnWriteArraySet;->remove(Ljava/lang/Object;)Z

    return-object p0

    .line 514
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "listenerToRemove is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public setAtRest()Lcom/pri/anim/spring/Spring;
    .locals 4

    .line 476
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v1, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    iput-wide v1, p0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    .line 477
    iget-object v3, p0, Lcom/pri/anim/spring/Spring;->mTempState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iput-wide v1, v3, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    const-wide/16 v1, 0x0

    .line 478
    iput-wide v1, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    return-object p0
.end method

.method public setCurrentValue(D)Lcom/pri/anim/spring/Spring;
    .locals 1

    const/4 v0, 0x1

    .line 104
    invoke-virtual {p0, p1, p2, v0}, Lcom/pri/anim/spring/Spring;->setCurrentValue(DZ)Lcom/pri/anim/spring/Spring;

    move-result-object p0

    return-object p0
.end method

.method public setCurrentValue(DZ)Lcom/pri/anim/spring/Spring;
    .locals 1

    .line 119
    iput-wide p1, p0, Lcom/pri/anim/spring/Spring;->mStartValue:D

    .line 120
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iput-wide p1, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->position:D

    .line 121
    iget-object p1, p0, Lcom/pri/anim/spring/Spring;->mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getId()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/pri/anim/spring/BaseSpringSystem;->activateSpring(Ljava/lang/String;)V

    .line 122
    iget-object p1, p0, Lcom/pri/anim/spring/Spring;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {p1}, Ljava/util/concurrent/CopyOnWriteArraySet;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/anim/spring/SpringListener;

    .line 123
    invoke-interface {p2, p0}, Lcom/pri/anim/spring/SpringListener;->onSpringUpdate(Lcom/pri/anim/spring/Spring;)V

    goto :goto_0

    :cond_0
    if-eqz p3, :cond_1

    .line 126
    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->setAtRest()Lcom/pri/anim/spring/Spring;

    :cond_1
    return-object p0
.end method

.method public setEndValue(D)Lcom/pri/anim/spring/Spring;
    .locals 2

    .line 170
    iget-wide v0, p0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    cmpl-double v0, v0, p1

    if-nez v0, :cond_0

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->isAtRest()Z

    move-result v0

    if-eqz v0, :cond_0

    return-object p0

    .line 173
    :cond_0
    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getCurrentValue()D

    move-result-wide v0

    iput-wide v0, p0, Lcom/pri/anim/spring/Spring;->mStartValue:D

    .line 174
    iput-wide p1, p0, Lcom/pri/anim/spring/Spring;->mEndValue:D

    .line 175
    iget-object p1, p0, Lcom/pri/anim/spring/Spring;->mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getId()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/pri/anim/spring/BaseSpringSystem;->activateSpring(Ljava/lang/String;)V

    .line 176
    iget-object p1, p0, Lcom/pri/anim/spring/Spring;->mListeners:Ljava/util/concurrent/CopyOnWriteArraySet;

    invoke-virtual {p1}, Ljava/util/concurrent/CopyOnWriteArraySet;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/pri/anim/spring/SpringListener;

    .line 177
    invoke-interface {p2, p0}, Lcom/pri/anim/spring/SpringListener;->onSpringEndStateChange(Lcom/pri/anim/spring/Spring;)V

    goto :goto_0

    :cond_1
    return-object p0
.end method

.method public setOvershootClampingEnabled(Z)Lcom/pri/anim/spring/Spring;
    .locals 0

    .line 253
    iput-boolean p1, p0, Lcom/pri/anim/spring/Spring;->mOvershootClampingEnabled:Z

    return-object p0
.end method

.method public setRestDisplacementThreshold(D)Lcom/pri/anim/spring/Spring;
    .locals 0

    .line 235
    iput-wide p1, p0, Lcom/pri/anim/spring/Spring;->mDisplacementFromRestThreshold:D

    return-object p0
.end method

.method public setRestSpeedThreshold(D)Lcom/pri/anim/spring/Spring;
    .locals 0

    .line 217
    iput-wide p1, p0, Lcom/pri/anim/spring/Spring;->mRestSpeedThreshold:D

    return-object p0
.end method

.method public setSpringConfig(Lcom/pri/anim/spring/SpringConfig;)Lcom/pri/anim/spring/Spring;
    .locals 0

    if-eqz p1, :cond_0

    .line 83
    iput-object p1, p0, Lcom/pri/anim/spring/Spring;->mSpringConfig:Lcom/pri/anim/spring/SpringConfig;

    return-object p0

    .line 81
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string/jumbo p1, "springConfig is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public setVelocity(D)Lcom/pri/anim/spring/Spring;
    .locals 3

    .line 195
    iget-object v0, p0, Lcom/pri/anim/spring/Spring;->mCurrentState:Lcom/pri/anim/spring/Spring$PhysicsState;

    iget-wide v1, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    cmpl-double v1, p1, v1

    if-nez v1, :cond_0

    return-object p0

    .line 198
    :cond_0
    iput-wide p1, v0, Lcom/pri/anim/spring/Spring$PhysicsState;->velocity:D

    .line 199
    iget-object p1, p0, Lcom/pri/anim/spring/Spring;->mSpringSystem:Lcom/pri/anim/spring/BaseSpringSystem;

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->getId()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/pri/anim/spring/BaseSpringSystem;->activateSpring(Ljava/lang/String;)V

    return-object p0
.end method

.method public systemShouldAdvance()Z
    .locals 1

    .line 449
    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->isAtRest()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/pri/anim/spring/Spring;->wasAtRest()Z

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

.method public wasAtRest()Z
    .locals 0

    .line 458
    iget-boolean p0, p0, Lcom/pri/anim/spring/Spring;->mWasAtRest:Z

    return p0
.end method
