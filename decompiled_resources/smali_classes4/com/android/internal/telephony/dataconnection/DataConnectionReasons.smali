.class public Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;
.super Ljava/lang/Object;
.source "DataConnectionReasons.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;,
        Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;
    }
.end annotation


# instance fields
.field private mDataAllowedReason:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

.field private mDataDisallowedReasonSet:Ljava/util/HashSet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashSet<",
            "Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 27
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    .line 28
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->NONE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataAllowedReason:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    return-void
.end method


# virtual methods
.method add(Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;)V
    .locals 2

    .line 42
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    invoke-virtual {v0}, Ljava/util/HashSet;->clear()V

    .line 46
    invoke-virtual {p1}, Ljava/lang/Enum;->ordinal()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataAllowedReason:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    invoke-virtual {v1}, Ljava/lang/Enum;->ordinal()I

    move-result v1

    if-le v0, v1, :cond_0

    .line 47
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataAllowedReason:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    :cond_0
    return-void
.end method

.method add(Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;)V
    .locals 1

    .line 35
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->NONE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataAllowedReason:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    .line 36
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    invoke-virtual {p0, p1}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method allowed()Z
    .locals 0

    .line 72
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    invoke-virtual {p0}, Ljava/util/HashSet;->size()I

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method contains(Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;)Z
    .locals 0

    .line 97
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataAllowedReason:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public contains(Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;)Z
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 83
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    invoke-virtual {p0, p1}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method containsHardDisallowedReasons()Z
    .locals 1

    .line 101
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    invoke-virtual {p0}, Ljava/util/HashSet;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 102
    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->isHardReason()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public containsOnly(Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;)Z
    .locals 2

    .line 93
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    invoke-virtual {v0}, Ljava/util/HashSet;->size()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->contains(Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method copyFrom(Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;)V
    .locals 1

    .line 67
    iget-object v0, p1, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    .line 68
    iget-object p1, p1, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataAllowedReason:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataAllowedReason:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 53
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 54
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    invoke-virtual {v1}, Ljava/util/HashSet;->size()I

    move-result v1

    const-string v2, " "

    if-lez v1, :cond_0

    const-string v1, "Data disallowed reasons:"

    .line 55
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 56
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataDisallowedReasonSet:Ljava/util/HashSet;

    invoke-virtual {p0}, Ljava/util/HashSet;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 57
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    goto :goto_0

    :cond_0
    const-string v1, "Data allowed reason:"

    .line 60
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 61
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;->mDataAllowedReason:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 63
    :cond_1
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
