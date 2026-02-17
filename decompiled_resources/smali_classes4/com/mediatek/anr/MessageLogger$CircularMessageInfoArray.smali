.class public Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;
.super Ljava/lang/Object;
.source "MessageLogger.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/mediatek/anr/MessageLogger;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1
    name = "CircularMessageInfoArray"
.end annotation


# instance fields
.field private mElem:[Lcom/mediatek/anr/MessageLogger$MessageInfo;

.field private mHead:I

.field private mLastElem:Lcom/mediatek/anr/MessageLogger$MessageInfo;

.field private mSize:I

.field private mTail:I

.field final synthetic this$0:Lcom/mediatek/anr/MessageLogger;


# direct methods
.method public constructor <init>(Lcom/mediatek/anr/MessageLogger;I)V
    .locals 4

    .line 388
    iput-object p1, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->this$0:Lcom/mediatek/anr/MessageLogger;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    add-int/lit8 p2, p2, 0x1

    .line 390
    new-array v0, p2, [Lcom/mediatek/anr/MessageLogger$MessageInfo;

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mElem:[Lcom/mediatek/anr/MessageLogger$MessageInfo;

    const/4 v0, 0x0

    move v1, v0

    :goto_0
    if-ge v1, p2, :cond_0

    .line 392
    iget-object v2, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mElem:[Lcom/mediatek/anr/MessageLogger$MessageInfo;

    new-instance v3, Lcom/mediatek/anr/MessageLogger$MessageInfo;

    invoke-direct {v3, p1}, Lcom/mediatek/anr/MessageLogger$MessageInfo;-><init>(Lcom/mediatek/anr/MessageLogger;)V

    aput-object v3, v2, v1

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 394
    :cond_0
    iput v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mHead:I

    .line 395
    iput v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mTail:I

    const/4 p1, 0x0

    .line 396
    iput-object p1, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mLastElem:Lcom/mediatek/anr/MessageLogger$MessageInfo;

    .line 397
    iput p2, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mSize:I

    return-void
.end method

.method private getLocked(I)Lcom/mediatek/anr/MessageLogger$MessageInfo;
    .locals 4

    .line 417
    iget v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mHead:I

    add-int v1, v0, p1

    iget v2, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mSize:I

    add-int/lit8 v3, v2, -0x1

    if-gt v1, v3, :cond_0

    .line 418
    iget-object p0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mElem:[Lcom/mediatek/anr/MessageLogger$MessageInfo;

    add-int/2addr v0, p1

    aget-object p0, p0, v0

    return-object p0

    .line 420
    :cond_0
    iget-object p0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mElem:[Lcom/mediatek/anr/MessageLogger$MessageInfo;

    add-int/2addr v0, p1

    sub-int/2addr v0, v2

    aget-object p0, p0, v0

    return-object p0
.end method


# virtual methods
.method public declared-synchronized add()Lcom/mediatek/anr/MessageLogger$MessageInfo;
    .locals 4

    monitor-enter p0

    .line 437
    :try_start_0
    invoke-virtual {p0}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->full()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 438
    iget v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mHead:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mHead:I

    .line 439
    iget v2, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mSize:I

    if-ne v0, v2, :cond_0

    .line 440
    iput v1, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mHead:I

    .line 444
    :cond_0
    iget-object v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mElem:[Lcom/mediatek/anr/MessageLogger$MessageInfo;

    iget v2, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mTail:I

    aget-object v0, v0, v2

    iput-object v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mLastElem:Lcom/mediatek/anr/MessageLogger$MessageInfo;

    add-int/lit8 v2, v2, 0x1

    .line 446
    iput v2, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mTail:I

    .line 447
    iget v3, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mSize:I

    if-ne v2, v3, :cond_1

    .line 448
    iput v1, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mTail:I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 451
    :cond_1
    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public empty()Z
    .locals 2

    .line 401
    iget v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mHead:I

    iget v1, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mTail:I

    if-eq v0, v1, :cond_1

    iget-object p0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mElem:[Lcom/mediatek/anr/MessageLogger$MessageInfo;

    if-nez p0, :cond_0

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

.method public full()Z
    .locals 4

    .line 405
    iget v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mTail:I

    iget v1, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mHead:I

    add-int/lit8 v2, v1, -0x1

    const/4 v3, 0x1

    if-eq v0, v2, :cond_1

    sub-int/2addr v0, v1

    iget p0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mSize:I

    sub-int/2addr p0, v3

    if-ne v0, p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v3, 0x0

    :cond_1
    :goto_0
    return v3
.end method

.method public declared-synchronized get(I)Lcom/mediatek/anr/MessageLogger$MessageInfo;
    .locals 1

    monitor-enter p0

    if-ltz p1, :cond_0

    .line 425
    :try_start_0
    invoke-virtual {p0}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->size()I

    move-result v0

    if-ge p1, v0, :cond_0

    .line 426
    invoke-direct {p0, p1}, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->getLocked(I)Lcom/mediatek/anr/MessageLogger$MessageInfo;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1

    :cond_0
    const/4 p1, 0x0

    .line 428
    monitor-exit p0

    return-object p1
.end method

.method public declared-synchronized getLast()Lcom/mediatek/anr/MessageLogger$MessageInfo;
    .locals 1

    monitor-enter p0

    .line 433
    :try_start_0
    iget-object v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mLastElem:Lcom/mediatek/anr/MessageLogger$MessageInfo;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public size()I
    .locals 3

    .line 409
    iget v0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mTail:I

    iget v1, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mHead:I

    sub-int v2, v0, v1

    if-ltz v2, :cond_0

    sub-int/2addr v0, v1

    return v0

    .line 412
    :cond_0
    iget p0, p0, Lcom/mediatek/anr/MessageLogger$CircularMessageInfoArray;->mSize:I

    add-int/2addr p0, v0

    sub-int/2addr p0, v1

    return p0
.end method
