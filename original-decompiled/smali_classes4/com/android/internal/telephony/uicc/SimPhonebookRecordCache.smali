.class public Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;
.super Landroid/os/Handler;
.source "SimPhonebookRecordCache.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;
    }
.end annotation


# static fields
.field private static final DBG:Z = true

.field static final ENABLE_INFLATE_WITH_EMPTY_RECORDS:Z = true
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final EVENT_GET_PHONEBOOK_CAPACITY_DONE:I = 0x4

.field private static final EVENT_GET_PHONEBOOK_RECORDS_DONE:I = 0x3

.field private static final EVENT_GET_PHONEBOOK_RECORDS_RETRY:I = 0x7

.field private static final EVENT_PHONEBOOK_CHANGED:I = 0x1

.field private static final EVENT_PHONEBOOK_RECORDS_RECEIVED:I = 0x2

.field private static final EVENT_SIM_REFRESH:I = 0x6

.field private static final EVENT_UPDATE_PHONEBOOK_RECORD_DONE:I = 0x5

.field private static final INVALID_RECORD_ID:I = -0x1

.field private static final MAX_RETRY_COUNT:I = 0x3

.field private static final RETRY_INTERVAL:I = 0xbb8


# instance fields
.field private LOG_TAG:Ljava/lang/String;

.field private mAdnCapacity:Ljava/util/concurrent/atomic/AtomicReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/atomic/AtomicReference<",
            "Lcom/android/internal/telephony/uicc/AdnCapacity;",
            ">;"
        }
    .end annotation
.end field

.field mAdnLoadingWaiters:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Landroid/os/Message;",
            ">;"
        }
    .end annotation
.end field

.field private final mCi:Lcom/android/internal/telephony/CommandsInterface;

.field private mContext:Landroid/content/Context;

.field private mIsCacheInvalidated:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

.field mIsUpdateDone:Z

.field private mPhoneId:I

.field private mReadLock:Ljava/lang/Object;

.field private final mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/ConcurrentSkipListMap<",
            "Ljava/lang/Integer;",
            "Lcom/android/internal/telephony/uicc/AdnRecord;",
            ">;"
        }
    .end annotation
.end field

.field private final mUpdateRequests:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$-oMw9NAorlSWhtdad_xQOv577y4(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->lambda$populateAdnRecords$0(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$Ok3L2lotfD8E49MhDgPSZCPqxfM(Lcom/android/internal/telephony/uicc/AdnRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->lambda$populateAdnRecords$1(Lcom/android/internal/telephony/uicc/AdnRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$vF-FsIKa3qlE5kH6r8Nrr9nz1x0(Ljava/lang/Integer;Lcom/android/internal/telephony/uicc/AdnRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->lambda$invalidateSimPbCache$2(Ljava/lang/Integer;Lcom/android/internal/telephony/uicc/AdnRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;

    move-result-object p0

    return-object p0
.end method

.method public constructor <init>(Landroid/content/Context;ILcom/android/internal/telephony/CommandsInterface;)V
    .locals 3

    .line 106
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    const-string v0, "SimPhonebookRecordCache"

    .line 60
    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->LOG_TAG:Ljava/lang/String;

    .line 84
    new-instance v0, Ljava/util/concurrent/atomic/AtomicReference;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnCapacity:Ljava/util/concurrent/atomic/AtomicReference;

    .line 85
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mReadLock:Ljava/lang/Object;

    .line 86
    new-instance v0, Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-direct {v0}, Ljava/util/concurrent/ConcurrentSkipListMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    .line 88
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 89
    invoke-static {v0}, Ljava/util/Collections;->synchronizedList(Ljava/util/List;)Ljava/util/List;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mUpdateRequests:Ljava/util/List;

    .line 91
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v2, 0x0

    invoke-direct {v0, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsCacheInvalidated:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 92
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 93
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 94
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 97
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnLoadingWaiters:Ljava/util/ArrayList;

    .line 104
    iput-boolean v2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsUpdateDone:Z

    .line 107
    iput-object p3, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 108
    iput p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mPhoneId:I

    .line 109
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mContext:Landroid/content/Context;

    .line 110
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->LOG_TAG:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "["

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, "]"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->LOG_TAG:Ljava/lang/String;

    const/4 p1, 0x1

    .line 111
    invoke-interface {p3, p0, p1, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForSimPhonebookChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    const/4 p1, 0x6

    .line 112
    invoke-interface {p3, p0, p1, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForIccRefresh(Landroid/os/Handler;ILjava/lang/Object;)V

    const/4 p1, 0x2

    .line 113
    invoke-interface {p3, p0, p1, v1}, Lcom/android/internal/telephony/CommandsInterface;->registerForSimPhonebookRecordsReceived(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method private addOrChangeSimPbRecord(Lcom/android/internal/telephony/uicc/AdnRecord;I)V
    .locals 2

    .line 579
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Record number for the added or changed ADN is "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 580
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/uicc/AdnRecord;->setRecId(I)V

    .line 582
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {p0, p2, p1}, Ljava/util/concurrent/ConcurrentSkipListMap;->replace(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method private deleteSimPbRecord(I)V
    .locals 9

    .line 590
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Record number for the deleted ADN is "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 592
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    new-instance v8, Lcom/android/internal/telephony/uicc/AdnRecord;

    const/16 v2, 0x6f3a

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-object v1, v8

    move v3, p1

    invoke-direct/range {v1 .. v7}, Lcom/android/internal/telephony/uicc/AdnRecord;-><init>(IILjava/lang/String;Ljava/lang/String;[Ljava/lang/String;[Ljava/lang/String;)V

    invoke-virtual {p0, v0, v8}, Ljava/util/concurrent/ConcurrentSkipListMap;->replace(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method private fillCache()V
    .locals 2

    .line 189
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mReadLock:Ljava/lang/Object;

    monitor-enter v0

    .line 190
    :try_start_0
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->fillCacheWithoutWaiting()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 192
    :try_start_1
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mReadLock:Ljava/lang/Object;

    invoke-virtual {v1}, Ljava/lang/Object;->wait()V
    :try_end_1
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catch_0
    :try_start_2
    const-string v1, "Interrupted Exception in queryAdnRecord"

    .line 194
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->loge(Ljava/lang/String;)V

    .line 196
    :goto_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method

.method private fillCacheWithoutWaiting()V
    .locals 3

    const-string v0, "Start to queryAdnRecord"

    .line 200
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 201
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 202
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x3

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->getSimPhonebookRecords(Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string v0, "The loading is ongoing"

    .line 204
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method private getSimPhonebookCapacity()V
    .locals 2

    const-string v0, "Start to getSimPhonebookCapacity"

    .line 180
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 181
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x4

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->getSimPhonebookCapacity(Landroid/os/Message;)V

    return-void
.end method

.method private handlePhonebookCapacityChanged(Lcom/android/internal/telephony/uicc/AdnCapacity;)V
    .locals 2

    .line 435
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnCapacity:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/AdnCapacity;

    if-nez p1, :cond_0

    .line 437
    new-instance p1, Lcom/android/internal/telephony/uicc/AdnCapacity;

    invoke-direct {p1}, Lcom/android/internal/telephony/uicc/AdnCapacity;-><init>()V

    .line 439
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnCapacity:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v1, p1}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    if-nez v0, :cond_2

    .line 441
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->inflateWithEmptyRecords(Lcom/android/internal/telephony/uicc/AdnCapacity;)V

    .line 442
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/AdnCapacity;->isSimEmpty()Z

    move-result p1

    const/4 v0, 0x1

    if-nez p1, :cond_1

    .line 443
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsCacheInvalidated:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1, v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 444
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->fillCacheWithoutWaiting()V

    goto :goto_0

    .line 446
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->notifyAdnLoadingWaiters()V

    .line 448
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p0, v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    goto :goto_3

    .line 451
    :cond_2
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/AdnCapacity;->isSimEmpty()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_4

    .line 452
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/AdnCapacity;->isSimValid()Z

    move-result p1

    if-nez p1, :cond_3

    goto :goto_1

    .line 455
    :cond_3
    iget-boolean p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsUpdateDone:Z

    if-nez p1, :cond_5

    .line 456
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->invalidateSimPbCache()V

    .line 457
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->fillCacheWithoutWaiting()V

    goto :goto_2

    .line 453
    :cond_4
    :goto_1
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsCacheInvalidated:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 454
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->notifyAdnLoadingWaiters()V

    .line 459
    :cond_5
    :goto_2
    iput-boolean v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsUpdateDone:Z

    :goto_3
    return-void
.end method

.method private handlePhonebookChanged()V
    .locals 1

    .line 426
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mUpdateRequests:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 428
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->getSimPhonebookCapacity()V

    goto :goto_0

    :cond_0
    const-string v0, "Do nothing in the midst of multiple update"

    .line 430
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method private handlePhonebookRecordReceived(Lcom/android/internal/telephony/uicc/ReceivedPhonebookRecords;)V
    .locals 3

    const/4 v0, 0x1

    if-eqz p1, :cond_3

    .line 477
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/ReceivedPhonebookRecords;->isOk()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v0, "Partial data is received"

    .line 478
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 479
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/ReceivedPhonebookRecords;->getPhonebookRecords()Ljava/util/List;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->populateAdnRecords(Ljava/util/List;)V

    goto :goto_0

    .line 480
    :cond_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/ReceivedPhonebookRecords;->isCompleted()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_1

    const-string v0, "The whole loading process is finished"

    .line 481
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 482
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/ReceivedPhonebookRecords;->getPhonebookRecords()Ljava/util/List;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->populateAdnRecords(Ljava/util/List;)V

    .line 483
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 484
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 485
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsCacheInvalidated:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 486
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->notifyAdnLoadingWaiters()V

    .line 487
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->tryFireUpdatePendingList()V

    goto :goto_0

    .line 488
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/ReceivedPhonebookRecords;->isRetryNeeded()Z

    move-result p1

    if-eqz p1, :cond_2

    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p1

    if-nez p1, :cond_2

    const-string p1, "Start to retry as aborted"

    .line 489
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 490
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->sendGettingPhonebookRecordsRetry(I)V

    goto :goto_0

    :cond_2
    const-string p1, "Error happened"

    .line 492
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->loge(Ljava/lang/String;)V

    .line 495
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->responseToWaitersWithErrorOrSuccess(Z)V

    goto :goto_0

    :cond_3
    const-string p1, "No records there"

    .line 498
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->loge(Ljava/lang/String;)V

    .line 499
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->responseToWaitersWithErrorOrSuccess(Z)V

    :goto_0
    return-void
.end method

.method private handleSimRefresh(Lcom/android/internal/telephony/uicc/IccRefreshResponse;)V
    .locals 2

    if-eqz p1, :cond_2

    .line 543
    iget v0, p1, Lcom/android/internal/telephony/uicc/IccRefreshResponse;->refreshResult:I

    if-nez v0, :cond_0

    iget p1, p1, Lcom/android/internal/telephony/uicc/IccRefreshResponse;->efId:I

    const/16 v1, 0x4f30

    if-eq p1, v1, :cond_1

    const/16 v1, 0x6f3a

    if-eq p1, v1, :cond_1

    :cond_0
    const/4 p1, 0x1

    if-ne v0, p1, :cond_3

    .line 547
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->invalidateSimPbCache()V

    .line 548
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->getSimPhonebookCapacity()V

    goto :goto_0

    :cond_2
    const-string p1, "IccRefreshResponse received is null"

    .line 551
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    :cond_3
    :goto_0
    return-void
.end method

.method private handleUpdatePhonebookRecordDone(Landroid/os/AsyncResult;)V
    .locals 5

    .line 505
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;

    const/4 v1, 0x1

    .line 506
    iput-boolean v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsUpdateDone:Z

    .line 507
    iget-object v1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v1, :cond_3

    .line 508
    invoke-static {v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->-$$Nest$fgetmyRecordId(Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;)I

    move-result v1

    .line 509
    invoke-static {v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->-$$Nest$fgetadnRecord(Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;)Lcom/android/internal/telephony/uicc/AdnRecord;

    move-result-object v2

    .line 510
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [I

    const/4 v3, 0x0

    aget p1, p1, v3

    .line 511
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "my record ID = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, " new record ID = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    const/4 v3, -0x1

    if-eq v1, v3, :cond_1

    if-ne v1, p1, :cond_0

    goto :goto_0

    .line 519
    :cond_0
    new-instance p1, Ljava/lang/RuntimeException;

    const-string v1, "The record ID for update doesn\'t match"

    invoke-direct {p1, v1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    goto :goto_2

    .line 513
    :cond_1
    :goto_0
    invoke-virtual {v2}, Lcom/android/internal/telephony/uicc/AdnRecord;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_2

    .line 514
    invoke-direct {p0, v2, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->addOrChangeSimPbRecord(Lcom/android/internal/telephony/uicc/AdnRecord;I)V

    goto :goto_1

    .line 516
    :cond_2
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->deleteSimPbRecord(I)V

    :goto_1
    const/4 p1, 0x0

    goto :goto_2

    .line 523
    :cond_3
    new-instance v1, Ljava/lang/RuntimeException;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    const-string v2, "Update adn record failed"

    invoke-direct {v1, v2, p1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    move-object p1, v1

    .line 526
    :goto_2
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mUpdateRequests:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_4

    .line 527
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mUpdateRequests:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 528
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->responseResult(Ljava/lang/Exception;)V

    goto :goto_3

    :cond_4
    const-string/jumbo p1, "this update request isn\'t found"

    .line 530
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->loge(Ljava/lang/String;)V

    .line 532
    :goto_3
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->tryFireUpdatePendingList()V

    return-void
.end method

.method private inflateWithEmptyRecords(Lcom/android/internal/telephony/uicc/AdnCapacity;)V
    .locals 11

    const-string v0, "inflateWithEmptyRecords"

    .line 465
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    if-eqz p1, :cond_0

    .line 466
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-virtual {v0}, Ljava/util/concurrent/ConcurrentSkipListMap;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    .line 467
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/AdnCapacity;->getMaxAdnCount()I

    move-result v1

    if-gt v0, v1, :cond_0

    .line 468
    iget-object v8, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    new-instance v10, Lcom/android/internal/telephony/uicc/AdnRecord;

    const/16 v2, 0x6f3a

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-object v1, v10

    move v3, v0

    invoke-direct/range {v1 .. v7}, Lcom/android/internal/telephony/uicc/AdnRecord;-><init>(IILjava/lang/String;Ljava/lang/String;[Ljava/lang/String;[Ljava/lang/String;)V

    invoke-virtual {v8, v9, v10}, Ljava/util/concurrent/ConcurrentSkipListMap;->putIfAbsent(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method private invalidateSimPbCache()V
    .locals 2

    const-string v0, "invalidateSimPbCache"

    .line 602
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 603
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsCacheInvalidated:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 605
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    new-instance v0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda3;-><init>()V

    invoke-virtual {p0, v0}, Ljava/util/concurrent/ConcurrentSkipListMap;->replaceAll(Ljava/util/function/BiFunction;)V

    return-void
.end method

.method private isAdnCapacityInvalid()Z
    .locals 1

    .line 241
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->getAdnCapacity()Lcom/android/internal/telephony/uicc/AdnCapacity;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->getAdnCapacity()Lcom/android/internal/telephony/uicc/AdnCapacity;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/AdnCapacity;->isSimValid()Z

    move-result p0

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

.method private static synthetic lambda$invalidateSimPbCache$2(Ljava/lang/Integer;Lcom/android/internal/telephony/uicc/AdnRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;
    .locals 7

    .line 606
    new-instance p1, Lcom/android/internal/telephony/uicc/AdnRecord;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result v2

    const/16 v1, 0x6f3a

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    move-object v0, p1

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/uicc/AdnRecord;-><init>(IILjava/lang/String;Ljava/lang/String;[Ljava/lang/String;[Ljava/lang/String;)V

    return-object p1
.end method

.method private static synthetic lambda$populateAdnRecords$0(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;
    .locals 8

    .line 557
    new-instance v7, Lcom/android/internal/telephony/uicc/AdnRecord;

    .line 559
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;->getRecordId()I

    move-result v2

    .line 560
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;->getAlphaTag()Ljava/lang/String;

    move-result-object v3

    .line 561
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;->getNumber()Ljava/lang/String;

    move-result-object v4

    .line 562
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;->getEmails()[Ljava/lang/String;

    move-result-object v5

    .line 563
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord;->getAdditionalNumbers()[Ljava/lang/String;

    move-result-object v6

    const/16 v1, 0x6f3a

    move-object v0, v7

    invoke-direct/range {v0 .. v6}, Lcom/android/internal/telephony/uicc/AdnRecord;-><init>(IILjava/lang/String;Ljava/lang/String;[Ljava/lang/String;[Ljava/lang/String;)V

    return-object v7
.end method

.method private static synthetic lambda$populateAdnRecords$1(Lcom/android/internal/telephony/uicc/AdnRecord;)Lcom/android/internal/telephony/uicc/AdnRecord;
    .locals 0

    return-object p0
.end method

.method private logd(Ljava/lang/String;)V
    .locals 0

    .line 614
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->LOG_TAG:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 620
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->LOG_TAG:Ljava/lang/String;

    invoke-static {p0, p1}, Landroid/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private notifyAdnLoadingWaiters()V
    .locals 2

    .line 262
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mReadLock:Ljava/lang/Object;

    monitor-enter v0

    .line 263
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mReadLock:Ljava/lang/Object;

    invoke-virtual {v1}, Ljava/lang/Object;->notify()V

    .line 264
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 265
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->notifyAndClearWaiters()V

    return-void

    :catchall_0
    move-exception p0

    .line 264
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private notifyAndClearWaiters()V
    .locals 5

    .line 155
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mReadLock:Ljava/lang/Object;

    monitor-enter v0

    .line 156
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnLoadingWaiters:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/Message;

    if-eqz v2, :cond_0

    .line 158
    new-instance v3, Ljava/util/ArrayList;

    iget-object v4, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    .line 159
    invoke-virtual {v4}, Ljava/util/concurrent/ConcurrentSkipListMap;->values()Ljava/util/Collection;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    const/4 v4, 0x0

    .line 160
    invoke-static {v2, v3, v4}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 161
    invoke-virtual {v2}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    .line 164
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnLoadingWaiters:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->clear()V

    .line 165
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private populateAdnRecords(Ljava/util/List;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/SimPhonebookRecord;",
            ">;)V"
        }
    .end annotation

    if-eqz p1, :cond_0

    .line 557
    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda1;

    invoke-direct {v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda1;-><init>()V

    new-instance v1, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda2;

    invoke-direct {v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$$ExternalSyntheticLambda2;-><init>()V

    .line 564
    invoke-static {v0, v1}, Ljava/util/stream/Collectors;->toMap(Ljava/util/function/Function;Ljava/util/function/Function;)Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/Map;

    .line 565
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-virtual {p0, p1}, Ljava/util/concurrent/ConcurrentSkipListMap;->putAll(Ljava/util/Map;)V

    :cond_0
    return-void
.end method

.method private reset()V
    .locals 2

    .line 137
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnCapacity:Ljava/util/concurrent/atomic/AtomicReference;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    .line 138
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-virtual {v0}, Ljava/util/concurrent/ConcurrentSkipListMap;->clear()V

    .line 139
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsCacheInvalidated:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 140
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 141
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 142
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 143
    iput-boolean v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsUpdateDone:Z

    return-void
.end method

.method private responseToWaitersWithErrorOrSuccess(Z)V
    .locals 2

    .line 413
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "responseToWaitersWithErrorOrSuccess success = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 414
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 415
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    if-eqz p1, :cond_0

    .line 417
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->notifyAdnLoadingWaiters()V

    goto :goto_0

    .line 419
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->sendResponsesToWaitersWithError()V

    .line 422
    :goto_0
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->tryFireUpdatePendingList()V

    return-void
.end method

.method private sendErrorResponse(Landroid/os/Message;Ljava/lang/String;)V
    .locals 0

    if-eqz p1, :cond_0

    .line 148
    new-instance p0, Ljava/lang/RuntimeException;

    invoke-direct {p0, p2}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    .line 149
    invoke-static {p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;)Landroid/os/AsyncResult;

    move-result-object p2

    iput-object p0, p2, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    .line 150
    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    :cond_0
    return-void
.end method

.method private sendGettingPhonebookRecordsRetry(I)V
    .locals 2

    const/4 p1, 0x7

    .line 570
    invoke-virtual {p0, p1}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 571
    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeMessages(I)V

    .line 573
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    const/4 v0, 0x0

    .line 574
    invoke-virtual {p0, p1, v1, v0}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p1

    const-wide/16 v0, 0xbb8

    .line 575
    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method private sendResponsesToWaitersWithError()V
    .locals 4

    .line 169
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mReadLock:Ljava/lang/Object;

    monitor-enter v0

    .line 170
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mReadLock:Ljava/lang/Object;

    invoke-virtual {v1}, Ljava/lang/Object;->notify()V

    .line 172
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnLoadingWaiters:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/Message;

    const-string v3, "Query adn record failed"

    .line 173
    invoke-direct {p0, v2, v3}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->sendErrorResponse(Landroid/os/Message;Ljava/lang/String;)V

    goto :goto_0

    .line 175
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnLoadingWaiters:Ljava/util/ArrayList;

    invoke-virtual {p0}, Ljava/util/ArrayList;->clear()V

    .line 176
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private tryFireUpdatePendingList()V
    .locals 2

    .line 536
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mUpdateRequests:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    .line 537
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mUpdateRequests:Ljava/util/List;

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->updateSimPhonebook(Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;)V

    :cond_0
    return-void
.end method

.method private updateSimPhonebook(Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;)V
    .locals 3

    const-string/jumbo v0, "update Sim phonebook"

    .line 334
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 335
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-static {p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;->-$$Nest$fgetphonebookRecord(Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;)Lcom/android/internal/telephony/uicc/SimPhonebookRecord;

    move-result-object v1

    const/4 v2, 0x5

    .line 336
    invoke-virtual {p0, v2, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    .line 335
    invoke-interface {v0, v1, p0}, Lcom/android/internal/telephony/CommandsInterface;->updateSimPhonebookRecord(Lcom/android/internal/telephony/uicc/SimPhonebookRecord;Landroid/os/Message;)V

    return-void
.end method

.method private updateSimPhonebookByNewAdn(ILcom/android/internal/telephony/uicc/AdnRecord;Landroid/os/Message;)V
    .locals 2

    .line 307
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "update sim contact for record ID = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    const/4 v0, -0x1

    if-ne p1, v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    move v0, p1

    .line 309
    :goto_0
    new-instance v1, Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;

    invoke-direct {v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;-><init>()V

    .line 310
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;->setRecordId(I)Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;

    move-result-object v0

    .line 311
    invoke-virtual {p2}, Lcom/android/internal/telephony/uicc/AdnRecord;->getAlphaTag()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;->setAlphaTag(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;

    move-result-object v0

    .line 312
    invoke-virtual {p2}, Lcom/android/internal/telephony/uicc/AdnRecord;->getNumber()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;->setNumber(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;

    move-result-object v0

    .line 313
    invoke-virtual {p2}, Lcom/android/internal/telephony/uicc/AdnRecord;->getEmails()[Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;->setEmails([Ljava/lang/String;)Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;

    move-result-object v0

    .line 314
    invoke-virtual {p2}, Lcom/android/internal/telephony/uicc/AdnRecord;->getAdditionalNumbers()[Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;->setAdditionalNumbers([Ljava/lang/String;)Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;

    move-result-object v0

    .line 315
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecord$Builder;->build()Lcom/android/internal/telephony/uicc/SimPhonebookRecord;

    move-result-object v0

    .line 316
    new-instance v1, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;

    invoke-direct {v1, p1, p2, v0, p3}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;-><init>(ILcom/android/internal/telephony/uicc/AdnRecord;Lcom/android/internal/telephony/uicc/SimPhonebookRecord;Landroid/os/Message;)V

    .line 317
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mUpdateRequests:Ljava/util/List;

    invoke-interface {p1, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 318
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->isAdnCapacityInvalid()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 320
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->getSimPhonebookCapacity()V

    .line 322
    :cond_1
    iget-object p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p2

    if-nez p2, :cond_3

    iget-object p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p2

    if-nez p2, :cond_3

    iget-object p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mUpdateRequests:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p2

    const/4 p3, 0x1

    if-gt p2, p3, :cond_3

    iget-object p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 323
    invoke-virtual {p2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p2

    if-eqz p2, :cond_3

    if-eqz p1, :cond_2

    goto :goto_1

    .line 330
    :cond_2
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->updateSimPhonebook(Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache$UpdateRequest;)V

    return-void

    .line 324
    :cond_3
    :goto_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "It is pending on update as  mIsRecordLoading = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, " mIsInRetry = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 325
    invoke-virtual {p2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, " pending size = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mUpdateRequests:Ljava/util/List;

    .line 326
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, " mIsInitialized = "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 324
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public clear()V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    return-void
.end method

.method public dispose()V
    .locals 1

    .line 130
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->reset()V

    .line 131
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForSimPhonebookChanged(Landroid/os/Handler;)V

    .line 132
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForIccRefresh(Landroid/os/Handler;)V

    .line 133
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForSimPhonebookRecordsReceived(Landroid/os/Handler;)V

    return-void
.end method

.method public getAdnCapacity()Lcom/android/internal/telephony/uicc/AdnCapacity;
    .locals 0

    .line 185
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnCapacity:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/AdnCapacity;

    return-object p0
.end method

.method public getAdnRecords()Ljava/util/List;
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/AdnRecord;",
            ">;"
        }
    .end annotation

    .line 251
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-virtual {p0}, Ljava/util/concurrent/ConcurrentSkipListMap;->values()Ljava/util/Collection;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Collection;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    return-object p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 342
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x0

    packed-switch v0, :pswitch_data_0

    .line 407
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected event: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->loge(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 396
    :pswitch_0
    iget p1, p1, Landroid/os/Message;->arg1:I

    .line 397
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "EVENT_GET_PHONEBOOK_RECORDS_RETRY cnt = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    const/4 v0, 0x3

    if-ge p1, v0, :cond_0

    .line 399
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 400
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->fillCacheWithoutWaiting()V

    add-int/lit8 p1, p1, 0x1

    .line 401
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->sendGettingPhonebookRecordsRetry(I)V

    goto/16 :goto_0

    .line 403
    :cond_0
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->responseToWaitersWithErrorOrSuccess(Z)V

    goto/16 :goto_0

    :pswitch_1
    const-string v0, "EVENT_SIM_REFRESH"

    .line 387
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 388
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 389
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_1

    .line 390
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/uicc/IccRefreshResponse;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->handleSimRefresh(Lcom/android/internal/telephony/uicc/IccRefreshResponse;)V

    goto/16 :goto_0

    .line 392
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "SIM refresh Exception: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    goto/16 :goto_0

    :pswitch_2
    const-string v0, "EVENT_UPDATE_PHONEBOOK_RECORD_DONE"

    .line 382
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 383
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 384
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->handleUpdatePhonebookRecordDone(Landroid/os/AsyncResult;)V

    goto/16 :goto_0

    :pswitch_3
    const-string v0, "EVENT_GET_PHONEBOOK_CAPACITY_DONE"

    .line 359
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 360
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    if-eqz p1, :cond_2

    .line 361
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_2

    .line 362
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/uicc/AdnCapacity;

    .line 363
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->handlePhonebookCapacityChanged(Lcom/android/internal/telephony/uicc/AdnCapacity;)V

    goto :goto_0

    .line 365
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->isAdnCapacityInvalid()Z

    move-result p1

    if-nez p1, :cond_3

    .line 366
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnCapacity:Ljava/util/concurrent/atomic/AtomicReference;

    new-instance v0, Lcom/android/internal/telephony/uicc/AdnCapacity;

    invoke-direct {v0}, Lcom/android/internal/telephony/uicc/AdnCapacity;-><init>()V

    invoke-virtual {p1, v0}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    .line 368
    :cond_3
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->invalidateSimPbCache()V

    goto :goto_0

    :pswitch_4
    const-string v0, "EVENT_GET_PHONEBOOK_RECORDS_DONE"

    .line 348
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 349
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    if-eqz p1, :cond_5

    .line 350
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz p1, :cond_5

    const-string p1, "Failed to gain phonebook records"

    .line 351
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->loge(Ljava/lang/String;)V

    .line 352
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->invalidateSimPbCache()V

    .line 353
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p1

    if-nez p1, :cond_5

    .line 354
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->sendGettingPhonebookRecordsRetry(I)V

    goto :goto_0

    :pswitch_5
    const-string v0, "EVENT_PHONEBOOK_RECORDS_RECEIVED"

    .line 372
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 373
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 374
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v0, :cond_4

    const-string v0, "Unexpected exception happened"

    .line 375
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->loge(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 376
    iput-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    .line 379
    :cond_4
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/uicc/ReceivedPhonebookRecords;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->handlePhonebookRecordReceived(Lcom/android/internal/telephony/uicc/ReceivedPhonebookRecords;)V

    goto :goto_0

    :pswitch_6
    const-string p1, "EVENT_PHONEBOOK_CHANGED"

    .line 344
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 345
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->handlePhonebookChanged()V

    :cond_5
    :goto_0
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public isEnabled()Z
    .locals 2

    .line 123
    invoke-static {}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->getInstance()Lcom/android/internal/telephony/RadioInterfaceCapabilityController;

    move-result-object v0

    .line 124
    invoke-virtual {v0}, Lcom/android/internal/telephony/RadioInterfaceCapabilityController;->getCapabilities()Ljava/util/Set;

    move-result-object v0

    const-string v1, "CAPABILITY_SIM_PHONEBOOK_IN_MODEM"

    .line 125
    invoke-interface {v0, v1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v0

    .line 126
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p0

    if-nez p0, :cond_1

    if-eqz v0, :cond_0

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

.method public isLoading()Z
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 246
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p0

    return p0
.end method

.method public requestLoadAllPbRecords(Landroid/os/Message;)V
    .locals 3

    if-nez p1, :cond_0

    .line 209
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v0

    if-nez v0, :cond_0

    const-string p1, "Try to enforce flushing cache"

    .line 210
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 211
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->fillCacheWithoutWaiting()V

    return-void

    .line 215
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mReadLock:Ljava/lang/Object;

    monitor-enter v0

    .line 216
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnLoadingWaiters:Ljava/util/ArrayList;

    invoke-virtual {v1, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 217
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnLoadingWaiters:Ljava/util/ArrayList;

    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result p1

    .line 218
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->isAdnCapacityInvalid()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 220
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->getSimPhonebookCapacity()V

    :cond_1
    const/4 v2, 0x1

    if-gt p1, v2, :cond_4

    .line 222
    iget-object v2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v2

    if-nez v2, :cond_4

    iget-object v2, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 223
    invoke-virtual {v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v2

    if-eqz v2, :cond_4

    if-eqz v1, :cond_2

    goto :goto_0

    .line 229
    :cond_2
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 230
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsRecordLoading:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p1

    if-nez p1, :cond_3

    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p1

    if-nez p1, :cond_3

    const-string p1, "ADN cache has already filled in"

    .line 231
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 232
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsCacheInvalidated:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p1

    if-nez p1, :cond_3

    .line 233
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->notifyAndClearWaiters()V

    return-void

    .line 237
    :cond_3
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->fillCache()V

    return-void

    .line 224
    :cond_4
    :goto_0
    :try_start_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Add to the pending list as pending size = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " is retrying = "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInRetry:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 225
    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, " IsInitialized = "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mIsInitialized:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 226
    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 224
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->logd(Ljava/lang/String;)V

    .line 227
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    .line 229
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public updateSimPbAdnByRecordId(ILcom/android/internal/telephony/uicc/AdnRecord;Landroid/os/Message;)V
    .locals 2

    if-nez p2, :cond_0

    const-string p1, "There is an invalid new Adn for update"

    .line 270
    invoke-direct {p0, p3, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->sendErrorResponse(Landroid/os/Message;Ljava/lang/String;)V

    return-void

    .line 273
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/concurrent/ConcurrentSkipListMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string p1, "There is an invalid old Adn for update"

    .line 275
    invoke-direct {p0, p3, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->sendErrorResponse(Landroid/os/Message;Ljava/lang/String;)V

    return-void

    .line 278
    :cond_1
    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->updateSimPhonebookByNewAdn(ILcom/android/internal/telephony/uicc/AdnRecord;Landroid/os/Message;)V

    return-void
.end method

.method public updateSimPbAdnBySearch(Lcom/android/internal/telephony/uicc/AdnRecord;Lcom/android/internal/telephony/uicc/AdnRecord;Landroid/os/Message;)V
    .locals 4

    if-nez p2, :cond_0

    const-string p1, "There is an invalid new Adn for update"

    .line 283
    invoke-direct {p0, p3, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->sendErrorResponse(Landroid/os/Message;Ljava/lang/String;)V

    return-void

    :cond_0
    const/4 v0, -0x1

    if-eqz p1, :cond_2

    .line 289
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/AdnRecord;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_2

    .line 290
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mSimPbRecords:Ljava/util/concurrent/ConcurrentSkipListMap;

    invoke-virtual {v1}, Ljava/util/concurrent/ConcurrentSkipListMap;->values()Ljava/util/Collection;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_1
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/uicc/AdnRecord;

    .line 291
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/uicc/AdnRecord;->isEqual(Lcom/android/internal/telephony/uicc/AdnRecord;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 292
    invoke-virtual {v2}, Lcom/android/internal/telephony/uicc/AdnRecord;->getRecId()I

    move-result p1

    goto :goto_0

    :cond_2
    move p1, v0

    :goto_0
    if-ne p1, v0, :cond_3

    .line 297
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnCapacity:Ljava/util/concurrent/atomic/AtomicReference;

    .line 298
    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->mAdnCapacity:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/uicc/AdnCapacity;

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/AdnCapacity;->isSimFull()Z

    move-result v0

    if-eqz v0, :cond_3

    const-string p1, "SIM Phonebook record is full"

    .line 299
    invoke-direct {p0, p3, p1}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->sendErrorResponse(Landroid/os/Message;Ljava/lang/String;)V

    return-void

    .line 303
    :cond_3
    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/uicc/SimPhonebookRecordCache;->updateSimPhonebookByNewAdn(ILcom/android/internal/telephony/uicc/AdnRecord;Landroid/os/Message;)V

    return-void
.end method
