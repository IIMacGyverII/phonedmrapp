.class public Lcom/android/internal/telephony/data/DataEvaluation;
.super Ljava/lang/Object;
.source "DataEvaluation.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;,
        Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;,
        Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;
    }
.end annotation


# instance fields
.field private mCandidateDataProfile:Landroid/telephony/data/DataProfile;

.field private mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

.field private final mDataDisallowedReasons:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;",
            ">;"
        }
    .end annotation
.end field

.field private final mDataEvaluationReason:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field private mEvaluatedTime:J


# direct methods
.method public constructor <init>(Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)V
    .locals 2

    .line 57
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 42
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    .line 45
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->NONE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    const/4 v0, 0x0

    .line 47
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mCandidateDataProfile:Landroid/telephony/data/DataProfile;

    const-wide/16 v0, 0x0

    .line 50
    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mEvaluatedTime:J

    .line 58
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataEvaluationReason:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    return-void
.end method


# virtual methods
.method public addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V
    .locals 2

    .line 90
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    .line 94
    invoke-virtual {p1}, Ljava/lang/Enum;->ordinal()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v1}, Ljava/lang/Enum;->ordinal()I

    move-result v1

    if-le v0, v1, :cond_0

    .line 95
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    .line 97
    :cond_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mEvaluatedTime:J

    return-void
.end method

.method public addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V
    .locals 2

    .line 68
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->NONE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    .line 69
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 70
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mEvaluatedTime:J

    return-void
.end method

.method public contains(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)Z
    .locals 0

    .line 177
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public contains(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)Z
    .locals 0

    .line 144
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method public varargs containsAny([Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)Z
    .locals 5

    .line 164
    array-length v0, p1

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_1

    aget-object v3, p1, v2

    .line 165
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {v4, v3}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    return v1
.end method

.method public containsDisallowedReasons()Z
    .locals 0

    .line 134
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {p0}, Ljava/util/Set;->size()I

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public containsHardDisallowedReasons()Z
    .locals 1

    .line 184
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 185
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->isHardReason()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public containsOnly(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)Z
    .locals 2

    .line 154
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->size()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataEvaluation;->contains(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method public getCandidateDataProfile()Landroid/telephony/data/DataProfile;
    .locals 0

    .line 127
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mCandidateDataProfile:Landroid/telephony/data/DataProfile;

    return-object p0
.end method

.method public getDataAllowedReason()Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;
    .locals 0

    .line 111
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    return-object p0
.end method

.method public getDataDisallowedReasons()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;",
            ">;"
        }
    .end annotation

    .line 104
    new-instance v0, Ljava/util/ArrayList;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-direct {v0, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object v0
.end method

.method public removeDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V
    .locals 2

    .line 79
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {v0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 80
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mEvaluatedTime:J

    return-void
.end method

.method public setCandidateDataProfile(Landroid/telephony/data/DataProfile;)V
    .locals 0

    .line 120
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mCandidateDataProfile:Landroid/telephony/data/DataProfile;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 4

    .line 364
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 365
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Data evaluation: evaluation reason:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataEvaluationReason:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ", "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 366
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {v1}, Ljava/util/Set;->size()I

    move-result v1

    const-string v2, " "

    if-lez v1, :cond_0

    const-string v1, "Data disallowed reasons:"

    .line 367
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 368
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataDisallowedReasons:Ljava/util/Set;

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 369
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    goto :goto_0

    :cond_0
    const-string v1, "Data allowed reason:"

    .line 372
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 373
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 375
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, ", candidate profile="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mCandidateDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 376
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, ", time="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v2, p0, Lcom/android/internal/telephony/data/DataEvaluation;->mEvaluatedTime:J

    invoke-static {v2, v3}, Lcom/android/internal/telephony/data/DataUtils;->systemTimeToString(J)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 377
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
