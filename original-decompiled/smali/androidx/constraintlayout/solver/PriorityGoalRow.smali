.class public Landroidx/constraintlayout/solver/PriorityGoalRow;
.super Landroidx/constraintlayout/solver/ArrayRow;
.source "PriorityGoalRow.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;,
        Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;
    }
.end annotation


# static fields
.field private static final DEBUG:Z = false

.field private static final epsilon:F = 1.0E-4f

.field static sCache:Landroidx/constraintlayout/solver/Cache;

.field static sRowVariable:Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;


# instance fields
.field goals:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;",
            ">;"
        }
    .end annotation
.end field

.field keyedGoals:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;",
            ">;"
        }
    .end annotation
.end field

.field mCache:Landroidx/constraintlayout/solver/Cache;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 31
    new-instance v0, Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;

    invoke-direct {v0}, Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;-><init>()V

    sput-object v0, Landroidx/constraintlayout/solver/PriorityGoalRow;->sRowVariable:Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;

    return-void
.end method

.method public constructor <init>(Landroidx/constraintlayout/solver/Cache;)V
    .locals 1

    .line 138
    invoke-direct {p0, p1}, Landroidx/constraintlayout/solver/ArrayRow;-><init>(Landroidx/constraintlayout/solver/Cache;)V

    .line 26
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    .line 27
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->keyedGoals:Ljava/util/HashMap;

    .line 139
    iput-object p1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->mCache:Landroidx/constraintlayout/solver/Cache;

    return-void
.end method


# virtual methods
.method public addError(Landroidx/constraintlayout/solver/SolverVariable;)V
    .locals 4

    .line 168
    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->mCache:Landroidx/constraintlayout/solver/Cache;

    iget-object v0, v0, Landroidx/constraintlayout/solver/Cache;->goalVariablePool:Landroidx/constraintlayout/solver/Pools$Pool;

    invoke-interface {v0}, Landroidx/constraintlayout/solver/Pools$Pool;->acquire()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    if-nez v0, :cond_0

    .line 170
    new-instance v0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    invoke-direct {v0}, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;-><init>()V

    goto :goto_0

    .line 172
    :cond_0
    invoke-virtual {v0}, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->reset()V

    .line 174
    :goto_0
    iget-object v1, v0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    iget v2, p1, Landroidx/constraintlayout/solver/SolverVariable;->strength:I

    const/high16 v3, 0x3f800000    # 1.0f

    aput v3, v1, v2

    .line 175
    iget v1, p1, Landroidx/constraintlayout/solver/SolverVariable;->id:I

    iput v1, v0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    .line 176
    iget-object v1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 177
    iget-object v1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->keyedGoals:Ljava/util/HashMap;

    iget v2, v0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v1, v2, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 178
    invoke-virtual {p1, p0}, Landroidx/constraintlayout/solver/SolverVariable;->addToRow(Landroidx/constraintlayout/solver/ArrayRow;)V

    return-void
.end method

.method public clear()V
    .locals 4

    .line 124
    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    if-lez v0, :cond_0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_0

    .line 127
    iget-object v2, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    .line 128
    iget-object v3, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->mCache:Landroidx/constraintlayout/solver/Cache;

    iget-object v3, v3, Landroidx/constraintlayout/solver/Cache;->goalVariablePool:Landroidx/constraintlayout/solver/Pools$Pool;

    invoke-interface {v3, v2}, Landroidx/constraintlayout/solver/Pools$Pool;->release(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 131
    :cond_0
    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    .line 132
    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->keyedGoals:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->clear()V

    const/4 v0, 0x0

    .line 133
    iput v0, p0, Landroidx/constraintlayout/solver/ArrayRow;->constantValue:F

    return-void
.end method

.method final create(Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;Landroidx/constraintlayout/solver/SolverVariable;F)Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;
    .locals 5

    .line 182
    new-instance p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    invoke-direct {p0}, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;-><init>()V

    const/4 v0, 0x0

    :goto_0
    const/16 v1, 0x8

    if-ge v0, v1, :cond_2

    .line 184
    iget-object v1, p1, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    aget v1, v1, v0

    const/4 v2, 0x0

    cmpl-float v3, v1, v2

    if-eqz v3, :cond_1

    mul-float/2addr v1, p3

    .line 187
    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v3

    const v4, 0x38d1b717    # 1.0E-4f

    cmpg-float v3, v3, v4

    if-gez v3, :cond_0

    goto :goto_1

    :cond_0
    move v2, v1

    .line 190
    :goto_1
    iget-object v1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->strengths:[F

    aput v2, v1, v0

    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 193
    :cond_2
    iget p1, p2, Landroidx/constraintlayout/solver/SolverVariable;->id:I

    iput p1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    return-object p0
.end method

.method final find(I)Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;
    .locals 0

    .line 242
    iget-object p0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->keyedGoals:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    return-object p0
.end method

.method public getPivotCandidate(Landroidx/constraintlayout/solver/LinearSystem;[Z)Landroidx/constraintlayout/solver/SolverVariable;
    .locals 5

    .line 144
    iget-object p1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->mCache:Landroidx/constraintlayout/solver/Cache;

    sput-object p1, Landroidx/constraintlayout/solver/PriorityGoalRow;->sCache:Landroidx/constraintlayout/solver/Cache;

    .line 146
    iget-object p1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result p1

    const/4 v0, 0x0

    const/4 v1, 0x0

    move-object v2, v0

    :goto_0
    if-ge v1, p1, :cond_3

    .line 148
    iget-object v3, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {v3, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    .line 149
    iget v4, v3, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    aget-boolean v4, p2, v4

    if-eqz v4, :cond_0

    goto :goto_2

    :cond_0
    if-nez v2, :cond_1

    .line 153
    invoke-virtual {v3}, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->isNegative()Z

    move-result v4

    if-eqz v4, :cond_2

    goto :goto_1

    .line 156
    :cond_1
    invoke-virtual {v3, v2}, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->isSmallerThan(Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;)Z

    move-result v4

    if-eqz v4, :cond_2

    :goto_1
    move-object v2, v3

    :cond_2
    :goto_2
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_3
    if-nez v2, :cond_4

    return-object v0

    .line 163
    :cond_4
    iget-object p0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->mCache:Landroidx/constraintlayout/solver/Cache;

    iget-object p0, p0, Landroidx/constraintlayout/solver/Cache;->mIndexedVariables:[Landroidx/constraintlayout/solver/SolverVariable;

    iget p1, v2, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    aget-object p0, p0, p1

    return-object p0
.end method

.method public toString()Ljava/lang/String;
    .locals 4

    .line 247
    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-static {v0}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 249
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, ""

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " goal -> ("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Landroidx/constraintlayout/solver/ArrayRow;->constantValue:F

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v1, ") : "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 250
    iget-object v1, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    .line 251
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->mCache:Landroidx/constraintlayout/solver/Cache;

    invoke-virtual {v2, v0}, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->toString(Landroidx/constraintlayout/solver/Cache;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public updateFromRow(Landroidx/constraintlayout/solver/ArrayRow;Z)V
    .locals 7

    .line 204
    iget-object p2, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->keyedGoals:Ljava/util/HashMap;

    iget-object v0, p1, Landroidx/constraintlayout/solver/ArrayRow;->variable:Landroidx/constraintlayout/solver/SolverVariable;

    iget v0, v0, Landroidx/constraintlayout/solver/SolverVariable;->id:I

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    if-nez p2, :cond_0

    return-void

    .line 208
    :cond_0
    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {v0, p2}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    .line 209
    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->keyedGoals:Ljava/util/HashMap;

    iget v1, p2, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 210
    iget-object v0, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->mCache:Landroidx/constraintlayout/solver/Cache;

    iget-object v0, v0, Landroidx/constraintlayout/solver/Cache;->goalVariablePool:Landroidx/constraintlayout/solver/Pools$Pool;

    invoke-interface {v0, p2}, Landroidx/constraintlayout/solver/Pools$Pool;->release(Ljava/lang/Object;)Z

    .line 212
    iget-object v0, p1, Landroidx/constraintlayout/solver/ArrayRow;->variables:Landroidx/constraintlayout/solver/ArrayLinkedVariables;

    invoke-virtual {v0}, Landroidx/constraintlayout/solver/ArrayLinkedVariables;->getHead()I

    move-result v0

    .line 213
    iget-object v1, p1, Landroidx/constraintlayout/solver/ArrayRow;->variables:Landroidx/constraintlayout/solver/ArrayLinkedVariables;

    invoke-virtual {v1}, Landroidx/constraintlayout/solver/ArrayLinkedVariables;->getCurrentSize()I

    move-result v1

    :goto_0
    const/4 v2, -0x1

    if-eq v0, v2, :cond_3

    if-lez v1, :cond_3

    .line 216
    iget-object v2, p1, Landroidx/constraintlayout/solver/ArrayRow;->variables:Landroidx/constraintlayout/solver/ArrayLinkedVariables;

    sget-object v3, Landroidx/constraintlayout/solver/PriorityGoalRow;->sRowVariable:Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;

    invoke-virtual {v2, v3, v0}, Landroidx/constraintlayout/solver/ArrayLinkedVariables;->getVariable(Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;I)I

    move-result v0

    .line 217
    sget-object v2, Landroidx/constraintlayout/solver/PriorityGoalRow;->sRowVariable:Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;

    .line 218
    iget v3, v2, Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;->variableId:I

    invoke-virtual {p0, v3}, Landroidx/constraintlayout/solver/PriorityGoalRow;->find(I)Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    move-result-object v3

    .line 219
    iget v4, v2, Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;->value:F

    .line 220
    iget-object v5, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->mCache:Landroidx/constraintlayout/solver/Cache;

    iget-object v5, v5, Landroidx/constraintlayout/solver/Cache;->mIndexedVariables:[Landroidx/constraintlayout/solver/SolverVariable;

    iget v2, v2, Landroidx/constraintlayout/solver/PriorityGoalRow$RowVariable;->variableId:I

    aget-object v2, v5, v2

    if-nez v3, :cond_1

    .line 222
    invoke-virtual {p0, p2, v2, v4}, Landroidx/constraintlayout/solver/PriorityGoalRow;->create(Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;Landroidx/constraintlayout/solver/SolverVariable;F)Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    move-result-object v3

    .line 223
    iget-object v5, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {v5, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 224
    iget-object v5, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->keyedGoals:Ljava/util/HashMap;

    iget v6, v3, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-virtual {v5, v6, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 225
    invoke-virtual {v2, p0}, Landroidx/constraintlayout/solver/SolverVariable;->addToRow(Landroidx/constraintlayout/solver/ArrayRow;)V

    goto :goto_1

    .line 227
    :cond_1
    invoke-virtual {p0, p2, v2, v4}, Landroidx/constraintlayout/solver/PriorityGoalRow;->create(Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;Landroidx/constraintlayout/solver/SolverVariable;F)Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;

    move-result-object v5

    .line 228
    invoke-virtual {v3, v5}, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->add(Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;)V

    .line 229
    invoke-virtual {v3}, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->isNull()Z

    move-result v5

    if-eqz v5, :cond_2

    .line 230
    iget-object v5, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->goals:Ljava/util/ArrayList;

    invoke-virtual {v5, v3}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    .line 231
    iget-object v5, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->keyedGoals:Ljava/util/HashMap;

    iget v6, v3, Landroidx/constraintlayout/solver/PriorityGoalRow$GoalVariable;->variableId:I

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 232
    iget-object v5, p0, Landroidx/constraintlayout/solver/PriorityGoalRow;->mCache:Landroidx/constraintlayout/solver/Cache;

    iget-object v5, v5, Landroidx/constraintlayout/solver/Cache;->goalVariablePool:Landroidx/constraintlayout/solver/Pools$Pool;

    invoke-interface {v5, v3}, Landroidx/constraintlayout/solver/Pools$Pool;->release(Ljava/lang/Object;)Z

    .line 233
    invoke-virtual {v2, p0}, Landroidx/constraintlayout/solver/SolverVariable;->removeFromRow(Landroidx/constraintlayout/solver/ArrayRow;)V

    .line 236
    :cond_2
    :goto_1
    iget v2, p0, Landroidx/constraintlayout/solver/ArrayRow;->constantValue:F

    iget v3, p1, Landroidx/constraintlayout/solver/ArrayRow;->constantValue:F

    mul-float/2addr v3, v4

    add-float/2addr v2, v3

    iput v2, p0, Landroidx/constraintlayout/solver/ArrayRow;->constantValue:F

    goto :goto_0

    :cond_3
    return-void
.end method
