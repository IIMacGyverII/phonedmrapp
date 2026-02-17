.class Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;
.super Ljava/lang/Object;
.source "PriorityGoalRow.java"

# interfaces
.implements Ljava/lang/Comparable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/constraintlayout/solver/PriorityGoalRow;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "GoalVariable"
.end annotation


# instance fields
.field strengths:[F

.field variableId:I


# direct methods
.method constructor <init>()V
    .locals 1

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/16 v0, 0x8

    new-array v0, v0, [F

    .line 36
    iput-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    return-void
.end method


# virtual methods
.method public add(Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;)V
    .locals 4

    const/4 v0, 0x0

    :goto_0
    const/16 v1, 0x8

    if-ge v0, v1, :cond_1

    .line 64
    iget-object v1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    aget v2, v1, v0

    iget-object v3, p1, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    aget v3, v3, v0

    add-float/2addr v2, v3

    aput v2, v1, v0

    .line 66
    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v1

    const v2, 0x38d1b717    # 1.0E-4f

    cmpg-float v1, v1, v2

    if-gez v1, :cond_0

    .line 67
    iget-object v1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    const/4 v2, 0x0

    aput v2, v1, v0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method

.method public compareTo(Ljava/lang/Object;)I
    .locals 0

    .line 112
    check-cast p1, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    .line 113
    iget p0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    iget p1, p1, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    sub-int/2addr p0, p1

    return p0
.end method

.method public final isNegative()Z
    .locals 5

    const/4 v0, 0x7

    :goto_0
    const/4 v1, 0x0

    if-ltz v0, :cond_2

    .line 74
    iget-object v2, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    aget v2, v2, v0

    const/4 v3, 0x0

    cmpl-float v4, v2, v3

    if-lez v4, :cond_0

    return v1

    :cond_0
    cmpg-float v1, v2, v3

    if-gez v1, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    :cond_2
    return v1
.end method

.method public final isNull()Z
    .locals 4

    const/4 v0, 0x0

    move v1, v0

    :goto_0
    const/16 v2, 0x8

    if-ge v1, v2, :cond_1

    .line 103
    iget-object v2, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    aget v2, v2, v1

    const/4 v3, 0x0

    cmpl-float v2, v2, v3

    if-eqz v2, :cond_0

    return v0

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x1

    return p0
.end method

.method public final isSmallerThan(Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;)Z
    .locals 5

    const/4 v0, 0x7

    :goto_0
    const/4 v1, 0x0

    if-ltz v0, :cond_1

    .line 87
    iget-object v2, p1, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    aget v2, v2, v0

    .line 88
    iget-object v3, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    aget v3, v3, v0

    cmpl-float v4, v3, v2

    if-nez v4, :cond_0

    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    :cond_0
    cmpg-float p0, v3, v2

    if-gez p0, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    return v1
.end method

.method public reset()V
    .locals 2

    .line 40
    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    const/4 v1, 0x0

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([FF)V

    const/4 v0, -0x1

    .line 41
    iput v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 1

    .line 45
    sget-object v0, Landroidx/constraintlayout/solver/PriorityGoalRow;->sCache:Landroidx/constraintlayout/solver/Cache;

    invoke-virtual {p0, v0}, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->toString(Landroidx/constraintlayout/solver/Cache;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public toString(Landroidx/constraintlayout/solver/Cache;)Ljava/lang/String;
    .locals 3

    const-string v0, "[ "

    const/4 v1, 0x0

    :goto_0
    const/16 v2, 0x8

    if-ge v1, v2, :cond_0

    .line 51
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    aget v0, v0, v1

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v0, " "

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 53
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "] "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroidx/constraintlayout/solver/Cache;->mIndexedVariables:[Landroidx/constraintlayout/solver/SolverVariable;

    iget p0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    aget-object p0, p1, p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
