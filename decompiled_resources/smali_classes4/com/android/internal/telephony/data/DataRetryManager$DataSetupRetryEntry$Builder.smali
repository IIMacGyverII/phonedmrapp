.class public Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;
.super Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;
.source "DataRetryManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "<T:",
        "Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder<",
        "TT;>;>",
        "Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder<",
        "TT;>;"
    }
.end annotation


# instance fields
.field private mDataProfile:Landroid/telephony/data/DataProfile;

.field private mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

.field private mSetupRetryType:I
    .annotation build Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$SetupRetryType;
    .end annotation
.end field

.field private mTransport:I


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 724
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;-><init>()V

    const/4 v0, 0x0

    .line 726
    iput v0, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mSetupRetryType:I

    const/4 v0, -0x1

    .line 735
    iput v0, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mTransport:I

    return-void
.end method


# virtual methods
.method public build()Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;
    .locals 10

    .line 789
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    if-eqz v2, :cond_4

    .line 792
    iget v4, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mTransport:I

    const/4 v0, 0x2

    const/4 v1, 0x1

    if-eq v4, v1, :cond_1

    if-ne v4, v0, :cond_0

    goto :goto_0

    .line 794
    :cond_0
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Invalid transport type "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mTransport:I

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 796
    :cond_1
    :goto_0
    iget v3, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mSetupRetryType:I

    if-eq v3, v1, :cond_3

    if-ne v3, v0, :cond_2

    goto :goto_1

    .line 798
    :cond_2
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Invalid setup retry type "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mSetupRetryType:I

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 801
    :cond_3
    :goto_1
    new-instance v9, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    iget-object v5, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mDataProfile:Landroid/telephony/data/DataProfile;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->mAppliedDataRetryRule:Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;

    move-object v6, v0

    check-cast v6, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;

    iget-wide v7, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->mRetryDelayMillis:J

    const/4 p0, 0x0

    move-object v0, v9

    move v1, v3

    move-object v3, v5

    move-object v5, v6

    move-wide v6, v7

    move-object v8, p0

    invoke-direct/range {v0 .. v8}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;-><init>(ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;JLcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry-IA;)V

    return-object v9

    .line 790
    :cond_4
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "network request list is not specified."

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public setDataProfile(Landroid/telephony/data/DataProfile;)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/telephony/data/DataProfile;",
            ")",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder<",
            "TT;>;"
        }
    .end annotation

    .line 768
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mDataProfile:Landroid/telephony/data/DataProfile;

    return-object p0
.end method

.method public setNetworkRequestList(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;",
            ")",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder<",
            "TT;>;"
        }
    .end annotation

    .line 757
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    return-object p0
.end method

.method public setSetupRetryType(I)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;
    .locals 0
    .param p1    # I
        .annotation build Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$SetupRetryType;
        .end annotation
    .end param
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder<",
            "TT;>;"
        }
    .end annotation

    .line 745
    iput p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mSetupRetryType:I

    return-object p0
.end method

.method public setTransport(I)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder<",
            "TT;>;"
        }
    .end annotation

    .line 779
    iput p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->mTransport:I

    return-object p0
.end method
