.class public Lcom/android/internal/telephony/util/PerUidCounter;
.super Ljava/lang/Object;
.source "PerUidCounter.java"


# instance fields
.field private final mMaxCountPerUid:I

.field final mUidToCount:Landroid/util/SparseIntArray;
    .annotation build Lcom/android/net/module/annotation/GuardedBy;
        value = {
            "mUidToCount"
        }
    .end annotation

    .annotation build Lcom/android/net/module/annotation/VisibleForTesting;
    .end annotation
.end field


# direct methods
.method public constructor <init>(I)V
    .locals 1

    .line 43
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 34
    new-instance v0, Landroid/util/SparseIntArray;

    invoke-direct {v0}, Landroid/util/SparseIntArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/util/PerUidCounter;->mUidToCount:Landroid/util/SparseIntArray;

    if-lez p1, :cond_0

    .line 47
    iput p1, p0, Lcom/android/internal/telephony/util/PerUidCounter;->mMaxCountPerUid:I

    return-void

    .line 45
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Maximum counter value must be positive"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public decrementCountOrThrow(I)V
    .locals 1

    const/4 v0, 0x1

    .line 87
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/util/PerUidCounter;->decrementCountOrThrow(II)V

    return-void
.end method

.method public declared-synchronized decrementCountOrThrow(II)V
    .locals 3

    monitor-enter p0

    if-lez p2, :cond_2

    .line 94
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/util/PerUidCounter;->mUidToCount:Landroid/util/SparseIntArray;

    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Landroid/util/SparseIntArray;->get(II)I

    move-result v0

    sub-int/2addr v0, p2

    if-ltz v0, :cond_1

    if-nez v0, :cond_0

    .line 98
    iget-object p2, p0, Lcom/android/internal/telephony/util/PerUidCounter;->mUidToCount:Landroid/util/SparseIntArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseIntArray;->delete(I)V

    goto :goto_0

    .line 100
    :cond_0
    iget-object p2, p0, Lcom/android/internal/telephony/util/PerUidCounter;->mUidToCount:Landroid/util/SparseIntArray;

    invoke-virtual {p2, p1, v0}, Landroid/util/SparseIntArray;->put(II)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 102
    :goto_0
    monitor-exit p0

    return-void

    .line 96
    :cond_1
    :try_start_1
    new-instance p2, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "BUG: too small count "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " for UID "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p2, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p2

    :catchall_0
    move-exception p1

    goto :goto_1

    .line 92
    :cond_2
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Decrement count must be positive"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :goto_1
    monitor-exit p0

    throw p1
.end method

.method public incrementCountOrThrow(I)V
    .locals 1

    const/4 v0, 0x1

    .line 61
    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/util/PerUidCounter;->incrementCountOrThrow(II)V

    return-void
.end method

.method public declared-synchronized incrementCountOrThrow(II)V
    .locals 4

    monitor-enter p0

    if-lez p2, :cond_1

    .line 68
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/util/PerUidCounter;->mUidToCount:Landroid/util/SparseIntArray;

    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Landroid/util/SparseIntArray;->get(II)I

    move-result v0

    int-to-long v0, v0

    int-to-long v2, p2

    add-long/2addr v0, v2

    .line 69
    iget p2, p0, Lcom/android/internal/telephony/util/PerUidCounter;->mMaxCountPerUid:I

    int-to-long v2, p2

    cmp-long p2, v0, v2

    if-gtz p2, :cond_0

    .line 74
    iget-object p2, p0, Lcom/android/internal/telephony/util/PerUidCounter;->mUidToCount:Landroid/util/SparseIntArray;

    long-to-int v0, v0

    invoke-virtual {p2, p1, v0}, Landroid/util/SparseIntArray;->put(II)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 75
    monitor-exit p0

    return-void

    .line 70
    :cond_0
    :try_start_1
    new-instance p2, Ljava/lang/IllegalStateException;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Uid "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " exceeded its allowed limit"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p2, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p2

    :catchall_0
    move-exception p1

    goto :goto_0

    .line 66
    :cond_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Increment count must be positive"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :goto_0
    monitor-exit p0

    throw p1
.end method
