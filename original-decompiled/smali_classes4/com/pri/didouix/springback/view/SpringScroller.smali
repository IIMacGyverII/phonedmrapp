.class public Lcom/pri/didouix/springback/view/SpringScroller;
.super Ljava/lang/Object;
.source "SpringScroller.java"


# static fields
.field private static final MAX_DELTA_TIME:F = 0.016f

.field private static final TAG:Ljava/lang/String; = "SpringScroller"

.field private static final VALUE_THRESHOLD:F = 1.0f


# instance fields
.field private mCurrX:D

.field private mCurrY:D

.field private mCurrentTime:J

.field private mEndX:D

.field private mEndY:D

.field private mFinished:Z

.field private mFirstStep:I

.field private mLastStep:Z

.field private mOrientation:I

.field private mOriginStartX:D

.field private mOriginStartY:D

.field private mOriginVelocity:D

.field private mSpringOperator:Lcom/pri/didouix/springback/view/SpringOperator;

.field private mStartTime:J

.field private mStartX:D

.field private mStartY:D

.field private mVelocity:D


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 16
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mFinished:Z

    return-void
.end method


# virtual methods
.method public computeScrollOffset()Z
    .locals 18

    move-object/from16 v7, p0

    .line 55
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "computeScrollOffset this.mFinished: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mFinished:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v8, "SpringScroller"

    invoke-static {v8, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    .line 56
    iget-object v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mSpringOperator:Lcom/pri/didouix/springback/view/SpringOperator;

    const/4 v1, 0x0

    if-eqz v0, :cond_8

    iget-boolean v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mFinished:Z

    if-eqz v0, :cond_0

    goto/16 :goto_3

    .line 60
    :cond_0
    iget v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mFirstStep:I

    const/4 v9, 0x1

    if-eqz v0, :cond_2

    .line 62
    iget v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mOrientation:I

    if-ne v2, v9, :cond_1

    int-to-double v2, v0

    .line 63
    iput-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrX:D

    .line 64
    iput-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartX:D

    goto :goto_0

    :cond_1
    int-to-double v2, v0

    .line 66
    iput-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrY:D

    .line 67
    iput-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartY:D

    .line 69
    :goto_0
    iput v1, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mFirstStep:I

    const-string v0, "computeScrollOffset mFirstStep "

    .line 70
    invoke-static {v8, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    return v9

    .line 72
    :cond_2
    iget-boolean v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mLastStep:Z

    if-eqz v0, :cond_3

    .line 73
    iput-boolean v9, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mFinished:Z

    const-string v0, "computeScrollOffset mLastStep "

    .line 74
    invoke-static {v8, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    return v9

    .line 77
    :cond_3
    invoke-static {}, Landroid/view/animation/AnimationUtils;->currentAnimationTimeMillis()J

    move-result-wide v0

    iput-wide v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrentTime:J

    .line 78
    iget-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartTime:J

    sub-long/2addr v0, v2

    long-to-float v0, v0

    const/high16 v1, 0x447a0000    # 1000.0f

    div-float/2addr v0, v1

    const v1, 0x3c83126f    # 0.016f

    invoke-static {v0, v1}, Ljava/lang/Math;->min(FF)F

    move-result v0

    const/4 v2, 0x0

    cmpl-float v2, v0, v2

    if-nez v2, :cond_4

    goto :goto_1

    :cond_4
    move v1, v0

    .line 82
    :goto_1
    iget-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrentTime:J

    iput-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartTime:J

    .line 83
    iget v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mOrientation:I

    const/4 v2, 0x2

    if-ne v0, v2, :cond_6

    .line 84
    iget-object v10, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mSpringOperator:Lcom/pri/didouix/springback/view/SpringOperator;

    iget-wide v11, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mVelocity:D

    iget-wide v14, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mEndY:D

    iget-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartY:D

    move v13, v1

    move-wide/from16 v16, v2

    invoke-virtual/range {v10 .. v17}, Lcom/pri/didouix/springback/view/SpringOperator;->updateVelocity(DFDD)D

    move-result-wide v2

    .line 85
    iget-wide v4, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartY:D

    float-to-double v0, v1

    mul-double/2addr v0, v2

    add-double/2addr v4, v0

    iput-wide v4, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrY:D

    .line 86
    iput-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mVelocity:D

    .line 87
    iget-wide v10, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mOriginStartY:D

    iget-wide v12, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mEndY:D

    move-object/from16 v0, p0

    move-wide v1, v4

    move-wide v3, v10

    move-wide v5, v12

    invoke-virtual/range {v0 .. v6}, Lcom/pri/didouix/springback/view/SpringScroller;->isAtEquilibrium(DDD)Z

    move-result v0

    if-eqz v0, :cond_5

    .line 88
    iput-boolean v9, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mLastStep:Z

    .line 89
    iget-wide v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mEndY:D

    iput-wide v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrY:D

    goto :goto_2

    .line 91
    :cond_5
    iget-wide v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrY:D

    iput-wide v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartY:D

    goto :goto_2

    .line 94
    :cond_6
    iget-object v10, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mSpringOperator:Lcom/pri/didouix/springback/view/SpringOperator;

    iget-wide v11, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mVelocity:D

    iget-wide v14, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mEndX:D

    iget-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartX:D

    move v13, v1

    move-wide/from16 v16, v2

    invoke-virtual/range {v10 .. v17}, Lcom/pri/didouix/springback/view/SpringOperator;->updateVelocity(DFDD)D

    move-result-wide v2

    .line 95
    iget-wide v4, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartX:D

    float-to-double v0, v1

    mul-double/2addr v0, v2

    add-double/2addr v4, v0

    iput-wide v4, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrX:D

    .line 96
    iput-wide v2, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mVelocity:D

    .line 97
    iget-wide v10, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mOriginStartX:D

    iget-wide v12, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mEndX:D

    move-object/from16 v0, p0

    move-wide v1, v4

    move-wide v3, v10

    move-wide v5, v12

    invoke-virtual/range {v0 .. v6}, Lcom/pri/didouix/springback/view/SpringScroller;->isAtEquilibrium(DDD)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 98
    iput-boolean v9, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mLastStep:Z

    .line 99
    iget-wide v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mEndX:D

    iput-wide v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrX:D

    goto :goto_2

    .line 101
    :cond_7
    iget-wide v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrX:D

    iput-wide v0, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartX:D

    .line 104
    :goto_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "computeScrollOffset this.mStartY: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mStartY:D

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string v1, " mCurrY: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrY:D

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string v1, " this.mEndY: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mEndY:D

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    const-string v1, " this.mFirstStep: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mFirstStep:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " this.mLastStep: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mLastStep:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " this.mVelocity:  "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, v7, Lcom/pri/didouix/springback/view/SpringScroller;->mVelocity:D

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v8, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    return v9

    :cond_8
    :goto_3
    const-string v0, "computeScrollOffset mFinished ... "

    .line 57
    invoke-static {v8, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    return v1
.end method

.method public final forceStop()V
    .locals 1

    const/4 v0, 0x1

    .line 138
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mFinished:Z

    const/4 v0, 0x0

    .line 139
    iput v0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mFirstStep:I

    const-string p0, "SpringScroller"

    const-string v0, "SpringScroller forceStop ... "

    .line 140
    invoke-static {p0, v0}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public final getCurrX()I
    .locals 2

    .line 126
    iget-wide v0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrX:D

    double-to-int p0, v0

    return p0
.end method

.method public final getCurrY()I
    .locals 2

    .line 130
    iget-wide v0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrY:D

    double-to-int p0, v0

    return p0
.end method

.method public isAtEquilibrium(DDD)Z
    .locals 4

    cmpg-double v0, p3, p5

    const/4 v1, 0x1

    if-gez v0, :cond_0

    cmpl-double v0, p1, p5

    if-lez v0, :cond_0

    return v1

    .line 115
    :cond_0
    invoke-static {p3, p4, p5, p6}, Ljava/lang/Double;->compare(DD)I

    move-result p3

    if-lez p3, :cond_1

    cmpg-double p4, p1, p5

    if-gez p4, :cond_1

    return v1

    :cond_1
    if-nez p3, :cond_2

    .line 119
    iget-wide p3, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mOriginVelocity:D

    invoke-static {p3, p4}, Ljava/lang/Math;->signum(D)D

    move-result-wide p3

    invoke-static {p1, p2}, Ljava/lang/Math;->signum(D)D

    move-result-wide v2

    cmpl-double p0, p3, v2

    if-nez p0, :cond_3

    :cond_2
    sub-double/2addr p1, p5

    invoke-static {p1, p2}, Ljava/lang/Math;->abs(D)D

    move-result-wide p0

    const-wide/high16 p2, 0x3ff0000000000000L    # 1.0

    cmpl-double p0, p0, p2

    if-ltz p0, :cond_3

    const/4 p0, 0x0

    return p0

    :cond_3
    return v1
.end method

.method public final isFinished()Z
    .locals 0

    .line 134
    iget-boolean p0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mFinished:Z

    return p0
.end method

.method public scrollByFling(FFFFFIZ)V
    .locals 2

    const-string v0, "SpringScroller"

    const-string v1, "SpringScroller scrollByFling ... "

    .line 30
    invoke-static {v0, v1}, Lcom/pri/didouix/util/PrizeNestedScrollLog;->d(Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 31
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mFinished:Z

    .line 32
    iput-boolean v0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mLastStep:Z

    float-to-double v0, p1

    .line 34
    iput-wide v0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mStartX:D

    .line 35
    iput-wide v0, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mOriginStartX:D

    float-to-double p1, p2

    .line 36
    iput-wide p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mEndX:D

    float-to-double p1, p3

    .line 38
    iput-wide p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mStartY:D

    .line 39
    iput-wide p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mOriginStartY:D

    double-to-int p1, p1

    int-to-double p1, p1

    .line 40
    iput-wide p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mCurrY:D

    float-to-double p1, p4

    .line 41
    iput-wide p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mEndY:D

    float-to-double p1, p5

    .line 43
    iput-wide p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mOriginVelocity:D

    .line 44
    iput-wide p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mVelocity:D

    .line 45
    invoke-static {p1, p2}, Ljava/lang/Math;->abs(D)D

    move-result-wide p1

    const-wide p3, 0x40b3880000000000L    # 5000.0

    cmpg-double p1, p1, p3

    const/high16 p2, 0x3f800000    # 1.0f

    if-lez p1, :cond_1

    if-eqz p7, :cond_0

    goto :goto_0

    .line 48
    :cond_0
    new-instance p1, Lcom/pri/didouix/springback/view/SpringOperator;

    const p3, 0x3f0ccccd    # 0.55f

    invoke-direct {p1, p2, p3}, Lcom/pri/didouix/springback/view/SpringOperator;-><init>(FF)V

    iput-object p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mSpringOperator:Lcom/pri/didouix/springback/view/SpringOperator;

    goto :goto_1

    .line 46
    :cond_1
    :goto_0
    new-instance p1, Lcom/pri/didouix/springback/view/SpringOperator;

    const p3, 0x3ecccccd    # 0.4f

    invoke-direct {p1, p2, p3}, Lcom/pri/didouix/springback/view/SpringOperator;-><init>(FF)V

    iput-object p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mSpringOperator:Lcom/pri/didouix/springback/view/SpringOperator;

    .line 50
    :goto_1
    iput p6, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mOrientation:I

    .line 51
    invoke-static {}, Landroid/view/animation/AnimationUtils;->currentAnimationTimeMillis()J

    move-result-wide p1

    iput-wide p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mStartTime:J

    return-void
.end method

.method public setFirstStep(I)V
    .locals 0

    .line 144
    iput p1, p0, Lcom/pri/didouix/springback/view/SpringScroller;->mFirstStep:I

    return-void
.end method
