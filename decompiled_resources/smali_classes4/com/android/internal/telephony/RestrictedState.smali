.class public Lcom/android/internal/telephony/RestrictedState;
.super Ljava/lang/Object;
.source "RestrictedState.java"


# instance fields
.field private mCsEmergencyRestricted:Z

.field private mCsNormalRestricted:Z

.field private mPsRestricted:Z


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    .line 35
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RestrictedState;->setPsRestricted(Z)V

    .line 36
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RestrictedState;->setCsNormalRestricted(Z)V

    .line 37
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RestrictedState;->setCsEmergencyRestricted(Z)V

    return-void
.end method


# virtual methods
.method public equals(Ljava/lang/Object;)Z
    .locals 3

    const/4 v0, 0x0

    .line 95
    :try_start_0
    move-object v1, p1

    check-cast v1, Lcom/android/internal/telephony/RestrictedState;
    :try_end_0
    .catch Ljava/lang/ClassCastException; {:try_start_0 .. :try_end_0} :catch_0

    if-nez p1, :cond_0

    return v0

    .line 104
    :cond_0
    iget-boolean p1, p0, Lcom/android/internal/telephony/RestrictedState;->mPsRestricted:Z

    iget-boolean v2, v1, Lcom/android/internal/telephony/RestrictedState;->mPsRestricted:Z

    if-ne p1, v2, :cond_1

    iget-boolean p1, p0, Lcom/android/internal/telephony/RestrictedState;->mCsNormalRestricted:Z

    iget-boolean v2, v1, Lcom/android/internal/telephony/RestrictedState;->mCsNormalRestricted:Z

    if-ne p1, v2, :cond_1

    iget-boolean p0, p0, Lcom/android/internal/telephony/RestrictedState;->mCsEmergencyRestricted:Z

    iget-boolean p1, v1, Lcom/android/internal/telephony/RestrictedState;->mCsEmergencyRestricted:Z

    if-ne p0, p1, :cond_1

    const/4 v0, 0x1

    :catch_0
    :cond_1
    return v0
.end method

.method public isAnyCsRestricted()Z
    .locals 1

    .line 87
    iget-boolean v0, p0, Lcom/android/internal/telephony/RestrictedState;->mCsNormalRestricted:Z

    if-nez v0, :cond_1

    iget-boolean p0, p0, Lcom/android/internal/telephony/RestrictedState;->mCsEmergencyRestricted:Z

    if-eqz p0, :cond_0

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

.method public isCsEmergencyRestricted()Z
    .locals 0

    .line 51
    iget-boolean p0, p0, Lcom/android/internal/telephony/RestrictedState;->mCsEmergencyRestricted:Z

    return p0
.end method

.method public isCsNormalRestricted()Z
    .locals 0

    .line 65
    iget-boolean p0, p0, Lcom/android/internal/telephony/RestrictedState;->mCsNormalRestricted:Z

    return p0
.end method

.method public isCsRestricted()Z
    .locals 1

    .line 83
    iget-boolean v0, p0, Lcom/android/internal/telephony/RestrictedState;->mCsNormalRestricted:Z

    if-eqz v0, :cond_0

    iget-boolean p0, p0, Lcom/android/internal/telephony/RestrictedState;->mCsEmergencyRestricted:Z

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isPsRestricted()Z
    .locals 0

    .line 79
    iget-boolean p0, p0, Lcom/android/internal/telephony/RestrictedState;->mPsRestricted:Z

    return p0
.end method

.method public setCsEmergencyRestricted(Z)V
    .locals 0

    .line 44
    iput-boolean p1, p0, Lcom/android/internal/telephony/RestrictedState;->mCsEmergencyRestricted:Z

    return-void
.end method

.method public setCsNormalRestricted(Z)V
    .locals 0

    .line 58
    iput-boolean p1, p0, Lcom/android/internal/telephony/RestrictedState;->mCsNormalRestricted:Z

    return-void
.end method

.method public setPsRestricted(Z)V
    .locals 0

    .line 72
    iput-boolean p1, p0, Lcom/android/internal/telephony/RestrictedState;->mPsRestricted:Z

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 113
    iget-boolean v0, p0, Lcom/android/internal/telephony/RestrictedState;->mCsEmergencyRestricted:Z

    if-eqz v0, :cond_0

    iget-boolean v1, p0, Lcom/android/internal/telephony/RestrictedState;->mCsNormalRestricted:Z

    if-eqz v1, :cond_0

    const-string v0, "all"

    goto :goto_0

    :cond_0
    if-eqz v0, :cond_1

    .line 115
    iget-boolean v1, p0, Lcom/android/internal/telephony/RestrictedState;->mCsNormalRestricted:Z

    if-nez v1, :cond_1

    const-string v0, "emergency"

    goto :goto_0

    :cond_1
    if-nez v0, :cond_2

    .line 117
    iget-boolean v0, p0, Lcom/android/internal/telephony/RestrictedState;->mCsNormalRestricted:Z

    if-eqz v0, :cond_2

    const-string v0, "normal call"

    goto :goto_0

    :cond_2
    const-string v0, "none"

    .line 121
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Restricted State CS: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " PS:"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p0, p0, Lcom/android/internal/telephony/RestrictedState;->mPsRestricted:Z

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
