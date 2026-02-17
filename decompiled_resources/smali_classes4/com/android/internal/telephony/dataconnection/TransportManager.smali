.class public Lcom/android/internal/telephony/dataconnection/TransportManager;
.super Landroid/os/Handler;
.source "TransportManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;
    }
.end annotation


# static fields
.field private static final EVENT_EVALUATE_TRANSPORT_PREFERENCE:I = 0x2

.field private static final EVENT_QUALIFIED_NETWORKS_CHANGED:I = 0x1

.field private static final FALL_BACK_REEVALUATE_DELAY_MILLIS:J


# instance fields
.field private mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

.field private final mHandoverNeededEventRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mLogTag:Ljava/lang/String;

.field private final mPendingHandoverApns:Landroid/util/SparseIntArray;

.field private final mPhone:Lcom/android/internal/telephony/Phone;


# direct methods
.method public static synthetic $r8$lambda$LZWHj72eRdQFUv9LCRqk7lYws5s(Lcom/android/internal/telephony/dataconnection/TransportManager;IIZZ)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/dataconnection/TransportManager;->lambda$evaluateTransportPreference$0(IIZZ)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 87
    sget-object v0, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0x3

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/dataconnection/TransportManager;->FALL_BACK_REEVALUATE_DELAY_MILLIS:J

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;)V
    .locals 2

    .line 139
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 91
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x40

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 140
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 141
    new-instance v0, Landroid/util/SparseIntArray;

    invoke-direct {v0}, Landroid/util/SparseIntArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mPendingHandoverApns:Landroid/util/SparseIntArray;

    .line 142
    new-instance v0, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v0}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mHandoverNeededEventRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 143
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-class v1, Lcom/android/internal/telephony/dataconnection/TransportManager;

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mLogTag:Ljava/lang/String;

    .line 144
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getAccessNetworksManager()Lcom/android/internal/telephony/data/AccessNetworksManager;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    const/4 v0, 0x1

    .line 145
    invoke-virtual {p1, p0, v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->registerForQualifiedNetworksChanged(Landroid/os/Handler;I)V

    return-void
.end method

.method private evaluateTransportPreference()V
    .locals 6

    .line 186
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/TransportManager;->isHandoverPending()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const-string v0, "evaluateTransportPreference"

    .line 187
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/TransportManager;->logl(Ljava/lang/String;)V

    .line 188
    sget-object v0, Lcom/android/internal/telephony/data/AccessNetworksManager;->SUPPORTED_APN_TYPES:[I

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_2

    aget v3, v0, v2

    .line 189
    iget-object v4, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransport(I)I

    move-result v4

    .line 190
    iget-object v5, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v5, v3}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getCurrentTransport(I)I

    move-result v5

    if-eq v4, v5, :cond_1

    .line 191
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Handover started for APN type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 192
    invoke-static {v3}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", target transport: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 194
    invoke-static {v4}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 191
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/TransportManager;->logl(Ljava/lang/String;)V

    .line 195
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mPendingHandoverApns:Landroid/util/SparseIntArray;

    invoke-virtual {v0, v3, v4}, Landroid/util/SparseIntArray;->put(II)V

    .line 196
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mHandoverNeededEventRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance v1, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;

    new-instance v2, Lcom/android/internal/telephony/dataconnection/TransportManager$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0, v3, v4}, Lcom/android/internal/telephony/dataconnection/TransportManager$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/dataconnection/TransportManager;II)V

    invoke-direct {v1, v3, v4, v2}, Lcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams;-><init>(IILcom/android/internal/telephony/dataconnection/TransportManager$HandoverParams$HandoverCallback;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    return-void

    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    return-void
.end method

.method private isHandoverPending()Z
    .locals 0

    .line 177
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mPendingHandoverApns:Landroid/util/SparseIntArray;

    invoke-virtual {p0}, Landroid/util/SparseIntArray;->size()I

    move-result p0

    if-lez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$evaluateTransportPreference$0(IIZZ)V
    .locals 2

    if-eqz p3, :cond_0

    .line 201
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Handover succeeded for APN type "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 202
    invoke-static {p1}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    .line 201
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/dataconnection/TransportManager;->logl(Ljava/lang/String;)V

    goto :goto_0

    .line 204
    :cond_0
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "APN type "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 205
    invoke-static {p1}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " handover to "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 207
    invoke-static {p2}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " failed, fallback="

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    .line 204
    invoke-direct {p0, p3}, Lcom/android/internal/telephony/dataconnection/TransportManager;->logl(Ljava/lang/String;)V

    :goto_0
    const-wide/16 v0, 0x0

    if-eqz p4, :cond_1

    .line 218
    sget-wide v0, Lcom/android/internal/telephony/dataconnection/TransportManager;->FALL_BACK_REEVALUATE_DELAY_MILLIS:J

    goto :goto_1

    .line 223
    :cond_1
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/TransportManager;->setCurrentTransport(II)V

    .line 225
    :goto_1
    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mPendingHandoverApns:Landroid/util/SparseIntArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseIntArray;->delete(I)V

    const/4 p1, 0x2

    .line 226
    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 273
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 277
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private logl(Ljava/lang/String;)V
    .locals 0

    .line 268
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/TransportManager;->log(Ljava/lang/String;)V

    .line 269
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method private declared-synchronized setCurrentTransport(II)V
    .locals 1

    monitor-enter p0

    .line 173
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v0, p1, p2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->setCurrentTransport(II)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 174
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 3

    .line 151
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    const/4 v2, 0x2

    if-eq v0, v1, :cond_1

    if-eq v0, v2, :cond_0

    .line 161
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected event "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/TransportManager;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 158
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/TransportManager;->evaluateTransportPreference()V

    goto :goto_0

    .line 153
    :cond_1
    invoke-virtual {p0, v2}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p1

    if-nez p1, :cond_2

    .line 154
    invoke-virtual {p0, v2}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_2
    :goto_0
    return-void
.end method

.method public registerDataThrottler(Lcom/android/internal/telephony/dataconnection/DataThrottler;)V
    .locals 0

    .line 262
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    if-eqz p0, :cond_0

    .line 263
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->registerDataThrottler(Lcom/android/internal/telephony/dataconnection/DataThrottler;)V

    :cond_0
    return-void
.end method

.method public registerForHandoverNeededEvent(Landroid/os/Handler;I)V
    .locals 1

    if-eqz p1, :cond_0

    .line 245
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mHandoverNeededEventRegistrants:Lcom/android/internal/telephony/RegistrantList;

    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, v0}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    :cond_0
    return-void
.end method

.method public unregisterForHandoverNeededEvent(Landroid/os/Handler;)V
    .locals 0

    .line 255
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/TransportManager;->mHandoverNeededEventRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method
