.class public abstract Lcom/android/internal/telephony/IntRangeManager;
.super Ljava/lang/Object;
.source "IntRangeManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/IntRangeManager$ClientRange;,
        Lcom/android/internal/telephony/IntRangeManager$IntRange;
    }
.end annotation


# static fields
.field private static final INITIAL_CLIENTS_ARRAY_SIZE:I = 0x4


# instance fields
.field private mRanges:Ljava/util/ArrayList;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/android/internal/telephony/IntRangeManager$IntRange;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method protected constructor <init>()V
    .locals 1

    .line 190
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 187
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    return-void
.end method

.method private populateAllClientRanges()V
    .locals 9

    .line 650
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_1

    .line 652
    iget-object v3, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 654
    iget-object v4, v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    move v5, v1

    :goto_1
    if-ge v5, v4, :cond_0

    .line 656
    iget-object v6, v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    invoke-virtual {v6, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    .line 657
    iget v7, v6, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mStartId:I

    iget v6, v6, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mEndId:I

    const/4 v8, 0x1

    invoke-virtual {p0, v7, v6, v8}, Lcom/android/internal/telephony/IntRangeManager;->addRange(IIZ)V

    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    return-void
.end method

.method private populateAllRanges()V
    .locals 4

    .line 637
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .line 639
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 640
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 641
    iget v2, v1, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    iget v1, v1, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    const/4 v3, 0x1

    invoke-virtual {p0, v2, v1, v3}, Lcom/android/internal/telephony/IntRangeManager;->addRange(IIZ)V

    goto :goto_0

    :cond_0
    return-void
.end method


# virtual methods
.method protected abstract addRange(IIZ)V
.end method

.method public declared-synchronized clearRanges()V
    .locals 1

    monitor-enter p0

    .line 196
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 197
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public declared-synchronized disableRange(IILjava/lang/String;)Z
    .locals 12

    monitor-enter p0

    .line 454
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_12

    .line 457
    iget-object v3, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v3, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 458
    iget v4, v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-ge p1, v4, :cond_0

    .line 459
    monitor-exit p0

    return v1

    .line 460
    :cond_0
    :try_start_1
    iget v4, v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    if-gt p2, v4, :cond_11

    .line 463
    iget-object v4, v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    .line 466
    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v5

    const/4 v6, 0x1

    if-ne v5, v6, :cond_3

    .line 468
    invoke-virtual {v4, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    .line 469
    iget v4, v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mStartId:I

    if-ne v4, p1, :cond_2

    iget p1, v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mEndId:I

    if-ne p1, p2, :cond_2

    iget-object p1, v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mClient:Ljava/lang/String;

    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 472
    iget-object p1, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p1, v2}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 473
    invoke-virtual {p0}, Lcom/android/internal/telephony/IntRangeManager;->updateRanges()Z

    move-result p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz p1, :cond_1

    .line 474
    monitor-exit p0

    return v6

    .line 477
    :cond_1
    :try_start_2
    iget-object p1, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p1, v2, v3}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 478
    monitor-exit p0

    return v1

    .line 481
    :cond_2
    monitor-exit p0

    return v1

    :cond_3
    const/high16 v7, -0x80000000

    move v8, v1

    :goto_1
    if-ge v8, v5, :cond_11

    .line 496
    :try_start_3
    invoke-virtual {v4, v8}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    .line 497
    iget v10, v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mStartId:I

    if-ne v10, p1, :cond_f

    iget v10, v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mEndId:I

    if-ne v10, p2, :cond_f

    iget-object v10, v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mClient:Ljava/lang/String;

    invoke-virtual {v10, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_f

    add-int/lit8 p1, v5, -0x1

    if-ne v8, p1, :cond_6

    .line 500
    iget p1, v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    if-ne p1, v7, :cond_4

    .line 503
    invoke-virtual {v4, v8}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 504
    monitor-exit p0

    return v6

    .line 507
    :cond_4
    :try_start_4
    invoke-virtual {v4, v8}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 508
    iput v7, v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 509
    invoke-virtual {p0}, Lcom/android/internal/telephony/IntRangeManager;->updateRanges()Z

    move-result p1
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    if-eqz p1, :cond_5

    .line 510
    monitor-exit p0

    return v6

    .line 512
    :cond_5
    :try_start_5
    invoke-virtual {v4, v8, v9}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V

    .line 513
    iget p1, v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mEndId:I

    iput p1, v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    .line 514
    monitor-exit p0

    return v1

    .line 522
    :cond_6
    :try_start_6
    new-instance p1, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    invoke-direct {p1, p0, v3, v8}, Lcom/android/internal/telephony/IntRangeManager$IntRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;Lcom/android/internal/telephony/IntRangeManager$IntRange;I)V

    if-nez v8, :cond_8

    .line 530
    invoke-virtual {v4, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    iget p3, p3, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mStartId:I

    .line 531
    iget v0, v3, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    if-eq p3, v0, :cond_7

    .line 533
    iput p3, p1, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    move p3, v6

    goto :goto_2

    :cond_7
    move p3, v1

    .line 536
    :goto_2
    invoke-virtual {v4, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    iget v7, v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mEndId:I

    goto :goto_3

    :cond_8
    move p3, v1

    .line 543
    :goto_3
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    add-int/2addr v8, v6

    :goto_4
    if-ge v8, v5, :cond_c

    .line 547
    invoke-virtual {v4, v8}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    .line 548
    iget v10, v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mStartId:I

    add-int/lit8 v11, v7, 0x1

    if-le v10, v11, :cond_9

    .line 550
    iput v7, p1, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 551
    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 552
    new-instance p1, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    invoke-direct {p1, p0, v9}, Lcom/android/internal/telephony/IntRangeManager$IntRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;Lcom/android/internal/telephony/IntRangeManager$ClientRange;)V

    move p3, v6

    goto :goto_5

    .line 554
    :cond_9
    iget v10, p1, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    iget v11, v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mEndId:I

    if-ge v10, v11, :cond_a

    .line 555
    iput v11, p1, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 557
    :cond_a
    iget-object v10, p1, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    invoke-virtual {v10, v9}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 559
    :goto_5
    iget v9, v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mEndId:I

    if-le v9, v7, :cond_b

    move v7, v9

    :cond_b
    add-int/lit8 v8, v8, 0x1

    goto :goto_4

    :cond_c
    if-ge v7, p2, :cond_d

    .line 567
    iput v7, p1, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    move p3, v6

    .line 569
    :cond_d
    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 572
    iget-object p1, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p1, v2}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 573
    iget-object p1, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p1, v2, v0}, Ljava/util/ArrayList;->addAll(ILjava/util/Collection;)Z

    if-eqz p3, :cond_e

    .line 574
    invoke-virtual {p0}, Lcom/android/internal/telephony/IntRangeManager;->updateRanges()Z

    move-result p1

    if-nez p1, :cond_e

    .line 576
    iget-object p1, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p1, v0}, Ljava/util/ArrayList;->removeAll(Ljava/util/Collection;)Z

    .line 577
    iget-object p1, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p1, v2, v3}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    .line 578
    monitor-exit p0

    return v1

    .line 581
    :cond_e
    monitor-exit p0

    return v6

    .line 584
    :cond_f
    :try_start_7
    iget v9, v9, Lcom/android/internal/telephony/IntRangeManager$ClientRange;->mEndId:I
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_0

    if-le v9, v7, :cond_10

    move v7, v9

    :cond_10
    add-int/lit8 v8, v8, 0x1

    goto/16 :goto_1

    :cond_11
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_0

    .line 592
    :cond_12
    monitor-exit p0

    return v1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized enableRange(IILjava/lang/String;)Z
    .locals 11

    monitor-enter p0

    .line 210
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_1

    .line 214
    invoke-virtual {p0, p1, p2, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 215
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    new-instance v1, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$IntRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 216
    monitor-exit p0

    return v2

    .line 218
    :cond_0
    monitor-exit p0

    return v1

    :cond_1
    move v3, v1

    :goto_0
    if-ge v3, v0, :cond_21

    .line 223
    :try_start_1
    iget-object v4, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v4, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 224
    iget v5, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    if-lt p1, v5, :cond_2

    iget v6, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    if-gt p2, v6, :cond_2

    .line 229
    new-instance v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    invoke-direct {v0, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$ClientRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v4, v0}, Lcom/android/internal/telephony/IntRangeManager$IntRange;->insert(Lcom/android/internal/telephony/IntRangeManager$ClientRange;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 230
    monitor-exit p0

    return v2

    :cond_2
    add-int/lit8 v6, p1, -0x1

    .line 231
    :try_start_2
    iget v7, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    if-ne v6, v7, :cond_8

    add-int/2addr v3, v2

    const/4 v5, 0x0

    if-ge v3, v0, :cond_4

    .line 237
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 238
    iget v3, v0, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    add-int/lit8 v6, v3, -0x1

    if-gt v6, p2, :cond_4

    .line 240
    iget v5, v0, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    if-gt p2, v5, :cond_3

    sub-int/2addr v3, v2

    goto :goto_1

    :cond_3
    move v3, p2

    :goto_1
    move-object v5, v0

    goto :goto_2

    :cond_4
    move v3, p2

    .line 249
    :goto_2
    invoke-virtual {p0, p1, v3, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 250
    iput p2, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 251
    new-instance v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    invoke-direct {v0, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$ClientRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v4, v0}, Lcom/android/internal/telephony/IntRangeManager$IntRange;->insert(Lcom/android/internal/telephony/IntRangeManager$ClientRange;)V

    if-eqz v5, :cond_6

    .line 255
    iget p1, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    iget p2, v5, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    if-ge p1, p2, :cond_5

    .line 257
    iput p2, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 259
    :cond_5
    iget-object p1, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    iget-object p2, v5, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    invoke-virtual {p1, p2}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    .line 260
    iget-object p1, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p1, v5}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 262
    :cond_6
    monitor-exit p0

    return v2

    .line 264
    :cond_7
    monitor-exit p0

    return v1

    :cond_8
    if-ge p1, v5, :cond_16

    add-int/lit8 v6, p2, 0x1

    if-ge v6, v5, :cond_a

    .line 273
    :try_start_3
    invoke-virtual {p0, p1, p2, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v0

    if-eqz v0, :cond_9

    .line 274
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    new-instance v1, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$IntRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v0, v3, v1}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 275
    monitor-exit p0

    return v2

    .line 277
    :cond_9
    monitor-exit p0

    return v1

    :cond_a
    if-gt p2, v7, :cond_c

    sub-int/2addr v5, v2

    .line 282
    :try_start_4
    invoke-virtual {p0, p1, v5, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v0

    if-eqz v0, :cond_b

    .line 283
    iput p1, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    .line 284
    iget-object v0, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    new-instance v3, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    invoke-direct {v3, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$ClientRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v0, v1, v3}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 285
    monitor-exit p0

    return v2

    .line 287
    :cond_b
    monitor-exit p0

    return v1

    :cond_c
    add-int/2addr v3, v2

    move v5, v3

    :goto_3
    if-ge v5, v0, :cond_13

    .line 292
    :try_start_5
    iget-object v7, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v7, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 293
    iget v8, v7, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    if-ge v6, v8, :cond_f

    .line 296
    invoke-virtual {p0, p1, p2, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v0

    if-eqz v0, :cond_e

    .line 297
    iput p1, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    .line 298
    iput p2, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 300
    iget-object v0, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    new-instance v6, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    invoke-direct {v6, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$ClientRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v0, v1, v6}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V

    move p1, v3

    :goto_4
    if-ge p1, v5, :cond_d

    .line 309
    iget-object p2, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 310
    iget-object p3, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    iget-object v0, p2, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    invoke-virtual {p3, v0}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    .line 311
    iget-object p3, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p3, p2}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    add-int/lit8 p1, p1, 0x1

    goto :goto_4

    .line 313
    :cond_d
    monitor-exit p0

    return v2

    .line 315
    :cond_e
    monitor-exit p0

    return v1

    .line 317
    :cond_f
    :try_start_6
    iget v9, v7, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    if-gt p2, v9, :cond_12

    sub-int/2addr v8, v2

    .line 321
    invoke-virtual {p0, p1, v8, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v0

    if-eqz v0, :cond_11

    .line 322
    iput p1, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    .line 323
    iget v0, v7, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    iput v0, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 325
    iget-object v0, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    new-instance v6, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    invoke-direct {v6, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$ClientRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v0, v1, v6}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V

    move p1, v3

    :goto_5
    if-gt p1, v5, :cond_10

    .line 333
    iget-object p2, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 334
    iget-object p3, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    iget-object v0, p2, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    invoke-virtual {p3, v0}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    .line 335
    iget-object p3, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p3, p2}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    add-int/lit8 p1, p1, 0x1

    goto :goto_5

    .line 337
    :cond_10
    monitor-exit p0

    return v2

    .line 339
    :cond_11
    monitor-exit p0

    return v1

    :cond_12
    add-int/lit8 v5, v5, 0x1

    goto :goto_3

    .line 346
    :cond_13
    :try_start_7
    invoke-virtual {p0, p1, p2, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v5

    if-eqz v5, :cond_15

    .line 347
    iput p1, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    .line 348
    iput p2, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 350
    iget-object v5, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    new-instance v6, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    invoke-direct {v6, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$ClientRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v5, v1, v6}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V

    move p1, v3

    :goto_6
    if-ge p1, v0, :cond_14

    .line 359
    iget-object p2, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 360
    iget-object p3, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    iget-object v1, p2, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    invoke-virtual {p3, v1}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    .line 361
    iget-object p3, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p3, p2}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_0

    add-int/lit8 p1, p1, 0x1

    goto :goto_6

    .line 363
    :cond_14
    monitor-exit p0

    return v2

    .line 365
    :cond_15
    monitor-exit p0

    return v1

    :cond_16
    add-int/lit8 v5, p1, 0x1

    if-gt v5, v7, :cond_20

    if-gt p2, v7, :cond_17

    .line 373
    :try_start_8
    new-instance v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    invoke-direct {v0, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$ClientRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v4, v0}, Lcom/android/internal/telephony/IntRangeManager$IntRange;->insert(Lcom/android/internal/telephony/IntRangeManager$ClientRange;)V
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_0

    .line 374
    monitor-exit p0

    return v2

    :cond_17
    add-int/lit8 v5, v3, 0x1

    move v7, v3

    move v6, v5

    :goto_7
    if-ge v6, v0, :cond_19

    .line 380
    :try_start_9
    iget-object v8, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v8, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    add-int/lit8 v9, p2, 0x1

    .line 381
    iget v8, v8, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    if-ge v9, v8, :cond_18

    goto :goto_8

    :cond_18
    add-int/lit8 v7, v6, 0x1

    move v10, v7

    move v7, v6

    move v6, v10

    goto :goto_7

    :cond_19
    :goto_8
    if-ne v7, v3, :cond_1b

    .line 392
    iget v0, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    add-int/2addr v0, v2

    invoke-virtual {p0, v0, p2, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v0

    if-eqz v0, :cond_1a

    .line 393
    iput p2, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 394
    new-instance v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    invoke-direct {v0, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$ClientRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v4, v0}, Lcom/android/internal/telephony/IntRangeManager$IntRange;->insert(Lcom/android/internal/telephony/IntRangeManager$ClientRange;)V
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_0

    .line 395
    monitor-exit p0

    return v2

    .line 397
    :cond_1a
    monitor-exit p0

    return v1

    .line 401
    :cond_1b
    :try_start_a
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {v0, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 406
    iget v3, v0, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    if-gt p2, v3, :cond_1c

    iget v3, v0, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mStartId:I

    sub-int/2addr v3, v2

    goto :goto_9

    :cond_1c
    move v3, p2

    .line 409
    :goto_9
    iget v6, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    add-int/2addr v6, v2

    invoke-virtual {p0, v6, v3, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v3

    if-eqz v3, :cond_1f

    .line 410
    iget v0, v0, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    if-gt p2, v0, :cond_1d

    goto :goto_a

    :cond_1d
    move v0, p2

    .line 411
    :goto_a
    iput v0, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mEndId:I

    .line 413
    new-instance v0, Lcom/android/internal/telephony/IntRangeManager$ClientRange;

    invoke-direct {v0, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$ClientRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v4, v0}, Lcom/android/internal/telephony/IntRangeManager$IntRange;->insert(Lcom/android/internal/telephony/IntRangeManager$ClientRange;)V

    move p1, v5

    :goto_b
    if-gt p1, v7, :cond_1e

    .line 421
    iget-object p2, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p2, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    .line 422
    iget-object p3, v4, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    iget-object v0, p2, Lcom/android/internal/telephony/IntRangeManager$IntRange;->mClients:Ljava/util/ArrayList;

    invoke-virtual {p3, v0}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    .line 423
    iget-object p3, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p3, p2}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z
    :try_end_a
    .catchall {:try_start_a .. :try_end_a} :catchall_0

    add-int/lit8 p1, p1, 0x1

    goto :goto_b

    .line 425
    :cond_1e
    monitor-exit p0

    return v2

    .line 427
    :cond_1f
    monitor-exit p0

    return v1

    :cond_20
    add-int/lit8 v3, v3, 0x1

    goto/16 :goto_0

    .line 435
    :cond_21
    :try_start_b
    invoke-virtual {p0, p1, p2, v2}, Lcom/android/internal/telephony/IntRangeManager;->tryAddRanges(IIZ)Z

    move-result v0

    if-eqz v0, :cond_22

    .line 436
    iget-object v0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    new-instance v1, Lcom/android/internal/telephony/IntRangeManager$IntRange;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager$IntRange;-><init>(Lcom/android/internal/telephony/IntRangeManager;IILjava/lang/String;)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_b
    .catchall {:try_start_b .. :try_end_b} :catchall_0

    .line 437
    monitor-exit p0

    return v2

    .line 439
    :cond_22
    monitor-exit p0

    return v1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method protected abstract finishUpdate()Z
.end method

.method public isEmpty()Z
    .locals 0

    .line 629
    iget-object p0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result p0

    return p0
.end method

.method protected abstract startUpdate()V
.end method

.method public toString()Ljava/lang/String;
    .locals 1

    .line 688
    iget-object p0, p0, Lcom/android/internal/telephony/IntRangeManager;->mRanges:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/IntRangeManager$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/IntRangeManager$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    const-string v0, ","

    invoke-static {v0}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method protected tryAddRanges(IIZ)Z
    .locals 0

    .line 617
    invoke-virtual {p0}, Lcom/android/internal/telephony/IntRangeManager;->startUpdate()V

    .line 618
    invoke-direct {p0}, Lcom/android/internal/telephony/IntRangeManager;->populateAllRanges()V

    .line 620
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/IntRangeManager;->addRange(IIZ)V

    .line 621
    invoke-virtual {p0}, Lcom/android/internal/telephony/IntRangeManager;->finishUpdate()Z

    move-result p0

    return p0
.end method

.method public updateRanges()Z
    .locals 0

    .line 602
    invoke-virtual {p0}, Lcom/android/internal/telephony/IntRangeManager;->startUpdate()V

    .line 604
    invoke-direct {p0}, Lcom/android/internal/telephony/IntRangeManager;->populateAllRanges()V

    .line 605
    invoke-virtual {p0}, Lcom/android/internal/telephony/IntRangeManager;->finishUpdate()Z

    move-result p0

    return p0
.end method
