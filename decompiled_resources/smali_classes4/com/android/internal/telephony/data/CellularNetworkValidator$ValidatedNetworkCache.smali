.class Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;
.super Ljava/lang/Object;
.source "CellularNetworkValidator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/CellularNetworkValidator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ValidatedNetworkCache"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;
    }
.end annotation


# static fields
.field private static final VALIDATED_NETWORK_CACHE_SIZE:I = 0xa


# instance fields
.field private final mValidatedNetworkMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;",
            ">;"
        }
    .end annotation
.end field

.field private final mValidatedNetworkPQ:Ljava/util/PriorityQueue;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/PriorityQueue<",
            "Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;",
            ">;"
        }
    .end annotation
.end field

.field final synthetic this$0:Lcom/android/internal/telephony/data/CellularNetworkValidator;


# direct methods
.method public static synthetic $r8$lambda$ApagMnYZx_xEQLho9mSC7ZBE8Yc(Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;)I
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->lambda$new$0(Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;)I

    move-result p0

    return p0
.end method

.method private constructor <init>(Lcom/android/internal/telephony/data/CellularNetworkValidator;)V
    .locals 1

    .line 94
    iput-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->this$0:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 97
    new-instance p1, Ljava/util/PriorityQueue;

    new-instance v0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$$ExternalSyntheticLambda0;-><init>()V

    invoke-direct {p1, v0}, Ljava/util/PriorityQueue;-><init>(Ljava/util/Comparator;)V

    iput-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkPQ:Ljava/util/PriorityQueue;

    .line 107
    new-instance p1, Ljava/util/HashMap;

    invoke-direct {p1}, Ljava/util/HashMap;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkMap:Ljava/util/Map;

    return-void
.end method

.method synthetic constructor <init>(Lcom/android/internal/telephony/data/CellularNetworkValidator;Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;-><init>(Lcom/android/internal/telephony/data/CellularNetworkValidator;)V

    return-void
.end method

.method private getValidationCacheTtl(I)J
    .locals 2

    .line 190
    iget-object p0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->this$0:Lcom/android/internal/telephony/data/CellularNetworkValidator;

    invoke-static {p0}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->-$$Nest$fgetmContext(Lcom/android/internal/telephony/data/CellularNetworkValidator;)Landroid/content/Context;

    move-result-object p0

    const-string v0, "carrier_config"

    .line 191
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/CarrierConfigManager;

    if-eqz p0, :cond_0

    .line 193
    invoke-virtual {p0, p1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    if-eqz p0, :cond_0

    const-string p1, "data_switch_validation_min_gap_long"

    .line 195
    invoke-virtual {p0, p1}, Landroid/os/PersistableBundle;->getLong(Ljava/lang/String;)J

    move-result-wide p0

    goto :goto_0

    :cond_0
    const-wide/16 p0, 0x0

    .line 199
    :goto_0
    sget-wide v0, Lcom/android/internal/telephony/data/CellularNetworkValidator;->MAX_VALIDATION_CACHE_TTL:J

    invoke-static {p0, p1, v0, v1}, Ljava/lang/Math;->min(JJ)J

    move-result-wide p0

    return-wide p0
.end method

.method private getValidationNetworkIdentity(I)Ljava/lang/String;
    .locals 4

    .line 166
    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->isUsableSubscriptionId(I)Z

    move-result p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 167
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object p0

    if-nez p0, :cond_1

    return-object v0

    .line 169
    :cond_1
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/SubscriptionController;->getPhoneId(I)I

    move-result p0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    if-eqz p0, :cond_5

    .line 170
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    if-nez v1, :cond_2

    goto :goto_0

    .line 172
    :cond_2
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    const/4 v1, 0x2

    const/4 v2, 0x1

    invoke-virtual {p0, v1, v2}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_5

    .line 174
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v1

    if-nez v1, :cond_3

    goto :goto_0

    .line 176
    :cond_3
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object p0

    .line 178
    invoke-virtual {p0}, Landroid/telephony/CellIdentity;->getType()I

    move-result v1

    const/4 v2, 0x3

    if-ne v1, v2, :cond_5

    .line 179
    invoke-virtual {p0}, Landroid/telephony/CellIdentity;->getMccString()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_5

    invoke-virtual {p0}, Landroid/telephony/CellIdentity;->getMncString()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_5

    move-object v1, p0

    check-cast v1, Landroid/telephony/CellIdentityLte;

    .line 180
    invoke-virtual {v1}, Landroid/telephony/CellIdentityLte;->getTac()I

    move-result v2

    const v3, 0x7fffffff

    if-ne v2, v3, :cond_4

    goto :goto_0

    .line 184
    :cond_4
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Landroid/telephony/CellIdentity;->getMccString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/telephony/CellIdentity;->getMncString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "_"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 185
    invoke-virtual {v1}, Landroid/telephony/CellIdentityLte;->getTac()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_5
    :goto_0
    return-object v0
.end method

.method private static synthetic lambda$new$0(Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;)I
    .locals 3

    .line 99
    iget-wide v0, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;->mValidationTimeStamp:J

    iget-wide p0, p1, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;->mValidationTimeStamp:J

    cmp-long v2, v0, p0

    if-gez v2, :cond_0

    const/4 p0, -0x1

    return p0

    :cond_0
    cmp-long p0, v0, p0

    if-lez p0, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method


# virtual methods
.method declared-synchronized isRecentlyValidated(I)Z
    .locals 8

    monitor-enter p0

    .line 122
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->getValidationCacheTtl(I)J

    move-result-wide v0

    .line 123
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->getValidationNetworkIdentity(I)Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    if-eqz v2, :cond_2

    .line 124
    iget-object v4, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkMap:Ljava/util/Map;

    invoke-interface {v4, v2}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_0

    goto :goto_0

    .line 127
    :cond_0
    iget-object v4, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkMap:Ljava/util/Map;

    invoke-interface {v4, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;

    iget-wide v4, v2, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;->mValidationTimeStamp:J

    .line 128
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    sub-long/2addr v6, v4

    cmp-long v0, v6, v0

    if-gez v0, :cond_1

    const/4 v3, 0x1

    .line 129
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isRecentlyValidated on subId "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " ? "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->-$$Nest$smlogd(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 130
    monitor-exit p0

    return v3

    .line 125
    :cond_2
    :goto_0
    monitor-exit p0

    return v3

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method declared-synchronized storeLastValidationResult(IZ)V
    .locals 3

    monitor-enter p0

    .line 134
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->getValidationNetworkIdentity(I)Ljava/lang/String;

    move-result-object v0

    .line 135
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "storeLastValidationResult for subId "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    if-eqz p2, :cond_0

    const-string p1, " validated."

    goto :goto_0

    :cond_0
    const-string p1, " not validated."

    .line 136
    :goto_0
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 135
    invoke-static {p1}, Lcom/android/internal/telephony/data/CellularNetworkValidator;->-$$Nest$smlogd(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez v0, :cond_1

    .line 137
    monitor-exit p0

    return-void

    :cond_1
    if-nez p2, :cond_2

    .line 141
    :try_start_1
    iget-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkPQ:Ljava/util/PriorityQueue;

    iget-object p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkMap:Ljava/util/Map;

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/util/PriorityQueue;->remove(Ljava/lang/Object;)Z

    .line 142
    iget-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkMap:Ljava/util/Map;

    invoke-interface {p1, v0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 143
    monitor-exit p0

    return-void

    .line 145
    :cond_2
    :try_start_2
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p1

    .line 146
    iget-object v1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkMap:Ljava/util/Map;

    invoke-interface {v1, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;

    if-eqz v1, :cond_3

    .line 149
    invoke-virtual {v1, p1, p2}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;->update(J)V

    .line 151
    iget-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkPQ:Ljava/util/PriorityQueue;

    invoke-virtual {p1, v1}, Ljava/util/PriorityQueue;->remove(Ljava/lang/Object;)Z

    .line 152
    iget-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkPQ:Ljava/util/PriorityQueue;

    invoke-virtual {p1, v1}, Ljava/util/PriorityQueue;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 154
    :cond_3
    new-instance v1, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;

    invoke-direct {v1, p0, v0, p1, p2}, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;-><init>(Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;Ljava/lang/String;J)V

    .line 155
    iget-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkMap:Ljava/util/Map;

    invoke-interface {p1, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 156
    iget-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkPQ:Ljava/util/PriorityQueue;

    invoke-virtual {p1, v1}, Ljava/util/PriorityQueue;->add(Ljava/lang/Object;)Z

    .line 159
    :goto_1
    iget-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkPQ:Ljava/util/PriorityQueue;

    invoke-virtual {p1}, Ljava/util/PriorityQueue;->size()I

    move-result p1

    const/16 p2, 0xa

    if-le p1, p2, :cond_4

    .line 160
    iget-object p1, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkPQ:Ljava/util/PriorityQueue;

    invoke-virtual {p1}, Ljava/util/PriorityQueue;->poll()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;

    .line 161
    iget-object p2, p0, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache;->mValidatedNetworkMap:Ljava/util/Map;

    iget-object p1, p1, Lcom/android/internal/telephony/data/CellularNetworkValidator$ValidatedNetworkCache$ValidatedNetwork;->mValidationIdentity:Ljava/lang/String;

    invoke-interface {p2, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 163
    :cond_4
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
