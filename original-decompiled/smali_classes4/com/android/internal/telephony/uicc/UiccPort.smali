.class public Lcom/android/internal/telephony/uicc/UiccPort;
.super Ljava/lang/Object;
.source "UiccPort.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;
    }
.end annotation


# static fields
.field protected static final DBG:Z = true

.field protected static final LOG_TAG:Ljava/lang/String; = "UiccPort"


# instance fields
.field protected mCardId:Ljava/lang/String;

.field private mCi:Lcom/android/internal/telephony/CommandsInterface;

.field private mContext:Landroid/content/Context;

.field private mIccid:Ljava/lang/String;

.field protected final mLock:Ljava/lang/Object;

.field private final mOpenChannelRecords:Ljava/util/List;
    .annotation build Lcom/android/internal/annotations/GuardedBy;
        value = {
            "mOpenChannelRecords"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;",
            ">;"
        }
    .end annotation
.end field

.field private final mPhoneId:I

.field private mPhysicalSlotIndex:I

.field private mPortIdx:I

.field private mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;


# direct methods
.method static bridge synthetic -$$Nest$mloge(Lcom/android/internal/telephony/uicc/UiccPort;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->loge(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/uicc/IccCardStatus;ILjava/lang/Object;Lcom/android/internal/telephony/uicc/UiccCard;)V
    .locals 1

    .line 62
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 58
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mOpenChannelRecords:Ljava/util/List;

    const-string v0, "Creating"

    .line 63
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/UiccPort;->log(Ljava/lang/String;)V

    .line 64
    iput p4, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mPhoneId:I

    .line 65
    iput-object p5, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    .line 66
    invoke-virtual {p0, p1, p2, p3, p6}, Lcom/android/internal/telephony/uicc/UiccPort;->update(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/uicc/IccCardStatus;Lcom/android/internal/telephony/uicc/UiccCard;)V

    return-void
.end method

.method private addOpenLogicalChannelRecord(Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;)V
    .locals 1

    .line 427
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mOpenChannelRecords:Ljava/util/List;

    monitor-enter v0

    .line 428
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mOpenChannelRecords:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 429
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    const-string p0, "UiccPort"

    .line 354
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    const-string p0, "UiccPort"

    .line 358
    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private removeOpenLogicalChannelRecord(Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;)V
    .locals 1

    .line 433
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mOpenChannelRecords:Ljava/util/List;

    monitor-enter v0

    .line 434
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mOpenChannelRecords:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 435
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method


# virtual methods
.method public dispose()V
    .locals 2

    .line 93
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    monitor-enter v0

    :try_start_0
    const-string v1, "Disposing Port"

    .line 94
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/UiccPort;->log(Ljava/lang/String;)V

    .line 95
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz v1, :cond_0

    .line 96
    invoke-virtual {v1}, Lcom/android/internal/telephony/uicc/UiccProfile;->dispose()V

    :cond_0
    const/4 v1, 0x0

    .line 98
    iput-object v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    .line 99
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 3

    const-string v0, "UiccPort:"

    .line 362
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 363
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " this="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 364
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mPortIdx="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mPortIdx:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 365
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCi="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 366
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mIccid="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mIccid:Ljava/lang/String;

    invoke-static {v1}, Landroid/telephony/SubscriptionInfo;->givePrintableIccid(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 367
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mPhoneId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mPhoneId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 368
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mPhysicalSlotIndex="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mPhysicalSlotIndex:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 369
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mOpenChannelRecords:Ljava/util/List;

    monitor-enter v0

    .line 370
    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, " mOpenChannelRecords="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mOpenChannelRecords:Ljava/util/List;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 371
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 372
    invoke-virtual {p2}, Ljava/io/PrintWriter;->println()V

    .line 373
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 374
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/uicc/UiccProfile;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    :cond_0
    return-void

    :catchall_0
    move-exception p0

    .line 371
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method protected finalize()V
    .locals 1

    const-string v0, "UiccPort finalized"

    .line 104
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/UiccPort;->log(Ljava/lang/String;)V

    return-void
.end method

.method public getApplication(I)Lcom/android/internal/telephony/uicc/UiccCardApplication;
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 141
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 142
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 143
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/UiccProfile;->getApplication(I)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p0

    monitor-exit v0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    .line 145
    monitor-exit v0

    return-object p0

    :catchall_0
    move-exception p0

    .line 147
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public getApplicationByType(I)Lcom/android/internal/telephony/uicc/UiccCardApplication;
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 175
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 176
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 177
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/UiccProfile;->getApplicationByType(I)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p0

    monitor-exit v0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    .line 179
    monitor-exit v0

    return-object p0

    :catchall_0
    move-exception p0

    .line 181
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public getApplicationIndex(I)Lcom/android/internal/telephony/uicc/UiccCardApplication;
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 155
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 156
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 157
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/UiccProfile;->getApplicationIndex(I)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p0

    monitor-exit v0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    .line 159
    monitor-exit v0

    return-object p0

    :catchall_0
    move-exception p0

    .line 161
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public getIccId()Ljava/lang/String;
    .locals 1

    .line 344
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mIccid:Ljava/lang/String;

    if-eqz v0, :cond_0

    return-object v0

    .line 346
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_1

    .line 347
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->getIccId()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method public getNumApplications()I
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 297
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 298
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->getNumApplications()I

    move-result p0

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public getOpenLogicalChannelRecord(I)Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 415
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mOpenChannelRecords:Ljava/util/List;

    monitor-enter v0

    .line 416
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mOpenChannelRecords:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;

    .line 417
    iget-object v2, v1, Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;->mRequest:Lcom/android/internal/telephony/IccLogicalChannelRequest;

    if-eqz v2, :cond_0

    iget v2, v2, Lcom/android/internal/telephony/IccLogicalChannelRequest;->channel:I

    if-ne v2, p1, :cond_0

    .line 419
    monitor-exit v0

    return-object v1

    .line 422
    :cond_1
    monitor-exit v0

    const/4 p0, 0x0

    return-object p0

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public getOperatorBrandOverride()Ljava/lang/String;
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 333
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 334
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->getOperatorBrandOverride()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public getPhoneId()I
    .locals 0

    .line 305
    iget p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mPhoneId:I

    return p0
.end method

.method public getPortIdx()I
    .locals 0

    .line 309
    iget p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mPortIdx:I

    return p0
.end method

.method public getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;
    .locals 0

    .line 313
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    return-object p0
.end method

.method public getUniversalPinState()Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 127
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 128
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 129
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->getUniversalPinState()Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    move-result-object p0

    monitor-exit v0

    return-object p0

    .line 131
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;->PINSTATE_UNKNOWN:Lcom/android/internal/telephony/uicc/IccCardStatus$PinState;

    monitor-exit v0

    return-object p0

    :catchall_0
    move-exception p0

    .line 133
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public iccCloseLogicalChannel(ILandroid/os/Message;)V
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 223
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz v0, :cond_0

    .line 224
    invoke-virtual {v0, p1, p2}, Lcom/android/internal/telephony/uicc/UiccProfile;->iccCloseLogicalChannel(ILandroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string p1, "iccCloseLogicalChannel Failed!"

    .line 226
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public iccExchangeSimIO(IIIIILjava/lang/String;Landroid/os/Message;)V
    .locals 8
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 271
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz v0, :cond_0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    move-object v6, p6

    move-object v7, p7

    .line 272
    invoke-virtual/range {v0 .. v7}, Lcom/android/internal/telephony/uicc/UiccProfile;->iccExchangeSimIO(IIIIILjava/lang/String;Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string p1, "iccExchangeSimIO Failed!"

    .line 274
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public iccOpenLogicalChannel(Ljava/lang/String;ILandroid/os/Message;)V
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 209
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz v0, :cond_0

    .line 210
    invoke-virtual {v0, p1, p2, p3}, Lcom/android/internal/telephony/uicc/UiccProfile;->iccOpenLogicalChannel(Ljava/lang/String;ILandroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string p1, "iccOpenLogicalChannel Failed!"

    .line 212
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public iccTransmitApduBasicChannel(IIIIILjava/lang/String;Landroid/os/Message;)V
    .locals 8
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 256
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz v0, :cond_0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    move-object v6, p6

    move-object v7, p7

    .line 257
    invoke-virtual/range {v0 .. v7}, Lcom/android/internal/telephony/uicc/UiccProfile;->iccTransmitApduBasicChannel(IIIIILjava/lang/String;Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string p1, "iccTransmitApduBasicChannel Failed!"

    .line 259
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public iccTransmitApduLogicalChannel(IIIIIILjava/lang/String;Landroid/os/Message;)V
    .locals 9
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    move-object v0, p0

    .line 239
    iget-object v1, v0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz v1, :cond_0

    move-object v0, v1

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    move v5, p5

    move v6, p6

    move-object/from16 v7, p7

    move-object/from16 v8, p8

    .line 240
    invoke-virtual/range {v0 .. v8}, Lcom/android/internal/telephony/uicc/UiccProfile;->iccTransmitApduLogicalChannel(IIIIIILjava/lang/String;Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string v1, "iccTransmitApduLogicalChannel Failed!"

    .line 243
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/uicc/UiccPort;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public isApplicationOnIcc(Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;)Z
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 113
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 114
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 115
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/UiccProfile;->isApplicationOnIcc(Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppType;)Z

    move-result p0

    monitor-exit v0

    return p0

    :cond_0
    const/4 p0, 0x0

    .line 117
    monitor-exit v0

    return p0

    :catchall_0
    move-exception p0

    .line 119
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public onLogicalChannelClosed(I)V
    .locals 2

    .line 403
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->getOpenLogicalChannelRecord(I)Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 404
    iget-object v0, p1, Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;->mRequest:Lcom/android/internal/telephony/IccLogicalChannelRequest;

    if-eqz v0, :cond_0

    iget-object v0, v0, Lcom/android/internal/telephony/IccLogicalChannelRequest;->binder:Landroid/os/IBinder;

    if-eqz v0, :cond_0

    .line 405
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onLogicalChannelClosed: stop monitoring client "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/UiccPort;->log(Ljava/lang/String;)V

    .line 406
    iget-object v0, p1, Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;->mRequest:Lcom/android/internal/telephony/IccLogicalChannelRequest;

    iget-object v0, v0, Lcom/android/internal/telephony/IccLogicalChannelRequest;->binder:Landroid/os/IBinder;

    const/4 v1, 0x0

    invoke-interface {v0, p1, v1}, Landroid/os/IBinder;->unlinkToDeath(Landroid/os/IBinder$DeathRecipient;I)Z

    .line 407
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->removeOpenLogicalChannelRecord(Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;)V

    .line 408
    iget-object p0, p1, Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;->mRequest:Lcom/android/internal/telephony/IccLogicalChannelRequest;

    const/4 p1, 0x0

    iput-object p1, p0, Lcom/android/internal/telephony/IccLogicalChannelRequest;->binder:Landroid/os/IBinder;

    :cond_0
    return-void
.end method

.method public onLogicalChannelOpened(Lcom/android/internal/telephony/IccLogicalChannelRequest;)V
    .locals 2

    .line 385
    new-instance v0, Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;-><init>(Lcom/android/internal/telephony/uicc/UiccPort;Lcom/android/internal/telephony/IccLogicalChannelRequest;)V

    .line 387
    :try_start_0
    iget-object p1, p1, Lcom/android/internal/telephony/IccLogicalChannelRequest;->binder:Landroid/os/IBinder;

    const/4 v1, 0x0

    invoke-interface {p1, v0, v1}, Landroid/os/IBinder;->linkToDeath(Landroid/os/IBinder$DeathRecipient;I)V

    .line 388
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/uicc/UiccPort;->addOpenLogicalChannelRecord(Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;)V

    .line 389
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onLogicalChannelOpened: monitoring client "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->log(Ljava/lang/String;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/NullPointerException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const-string p1, "IccOpenLogicChannel client has died, clean up manually"

    .line 391
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->loge(Ljava/lang/String;)V

    .line 392
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccPort$OpenLogicalChannelRecord;->binderDied()V

    :goto_0
    return-void
.end method

.method public resetAppWithAid(Ljava/lang/String;Z)Z
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 193
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 194
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 195
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/uicc/UiccProfile;->resetAppWithAid(Ljava/lang/String;Z)Z

    move-result p0

    monitor-exit v0

    return p0

    :cond_0
    const/4 p0, 0x0

    .line 197
    monitor-exit v0

    return p0

    :catchall_0
    move-exception p0

    .line 199
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public sendEnvelopeWithStatus(Ljava/lang/String;Landroid/os/Message;)V
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 284
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz v0, :cond_0

    .line 285
    invoke-virtual {v0, p1, p2}, Lcom/android/internal/telephony/uicc/UiccProfile;->sendEnvelopeWithStatus(Ljava/lang/String;Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    const-string p1, "sendEnvelopeWithStatus Failed!"

    .line 287
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/uicc/UiccPort;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public setOperatorBrandOverride(Ljava/lang/String;)Z
    .locals 0
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 321
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-eqz p0, :cond_0

    .line 322
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/uicc/UiccProfile;->setOperatorBrandOverride(Ljava/lang/String;)Z

    move-result p0

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public update(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/uicc/IccCardStatus;Lcom/android/internal/telephony/uicc/UiccCard;)V
    .locals 8

    .line 73
    iget-object v0, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 74
    :try_start_0
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mContext:Landroid/content/Context;

    .line 75
    iput-object p2, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 76
    iget-object v1, p3, Lcom/android/internal/telephony/uicc/IccCardStatus;->iccid:Ljava/lang/String;

    iput-object v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mIccid:Ljava/lang/String;

    .line 77
    iget-object v1, p3, Lcom/android/internal/telephony/uicc/IccCardStatus;->mSlotPortMapping:Lcom/android/internal/telephony/uicc/IccSlotPortMapping;

    iget v2, v1, Lcom/android/internal/telephony/uicc/IccSlotPortMapping;->mPortIndex:I

    iput v2, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mPortIdx:I

    .line 78
    iget v1, v1, Lcom/android/internal/telephony/uicc/IccSlotPortMapping;->mPhysicalSlotIndex:I

    iput v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mPhysicalSlotIndex:I

    .line 79
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    if-nez v1, :cond_0

    .line 80
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p1

    const-class p2, Lcom/android/internal/telephony/uicc/UiccProfile;

    .line 81
    invoke-virtual {p2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mContext:Landroid/content/Context;

    iget-object v3, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget v5, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mPhoneId:I

    iget-object v7, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mLock:Ljava/lang/Object;

    move-object v4, p3

    move-object v6, p4

    invoke-virtual/range {v1 .. v7}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeUiccProfile(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/uicc/IccCardStatus;ILcom/android/internal/telephony/uicc/UiccCard;Ljava/lang/Object;)Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/uicc/UiccPort;->mUiccProfile:Lcom/android/internal/telephony/uicc/UiccProfile;

    goto :goto_0

    .line 84
    :cond_0
    invoke-virtual {v1, p1, p2, p3}, Lcom/android/internal/telephony/uicc/UiccProfile;->update(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Lcom/android/internal/telephony/uicc/IccCardStatus;)V

    .line 86
    :goto_0
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
