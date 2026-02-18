.class public Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;
.super Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;
.source "DataRetryManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "<T:",
        "Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder<",
        "TT;>;>",
        "Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder<",
        "TT;>;"
    }
.end annotation


# instance fields
.field public mDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 842
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;-><init>()V

    return-void
.end method


# virtual methods
.method public build()Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;
    .locals 5

    .line 864
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;->mDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->mAppliedDataRetryRule:Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;

    check-cast v2, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;

    iget-wide v3, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->mRetryDelayMillis:J

    invoke-direct {v0, v1, v2, v3, v4}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;-><init>(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;J)V

    return-object v0
.end method

.method public setDataNetwork(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/data/DataNetwork;",
            ")",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder<",
            "TT;>;"
        }
    .end annotation

    .line 854
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;->mDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    return-object p0
.end method
