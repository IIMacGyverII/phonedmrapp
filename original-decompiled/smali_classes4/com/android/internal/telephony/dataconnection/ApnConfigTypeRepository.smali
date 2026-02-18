.class public Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;
.super Ljava/lang/Object;
.source "ApnConfigTypeRepository.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "ApnConfigTypeRepository"


# instance fields
.field private final mConfigTypeMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Lcom/android/internal/telephony/dataconnection/ApnConfigType;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>(Landroid/os/PersistableBundle;)V
    .locals 1

    .line 42
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 43
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->mConfigTypeMap:Ljava/util/Map;

    .line 44
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->setup(Landroid/os/PersistableBundle;)V

    return-void
.end method

.method private add(ILjava/util/Map;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 124
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {p2, v0}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 125
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->mConfigTypeMap:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/dataconnection/ApnConfigType;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {p2, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    invoke-direct {v1, p1, p2}, Lcom/android/internal/telephony/dataconnection/ApnConfigType;-><init>(II)V

    invoke-interface {p0, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_0
    return-void
.end method

.method private addApns(Ljava/util/Map;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    const/16 v0, 0x11

    .line 71
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/4 v0, 0x2

    .line 72
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/4 v0, 0x4

    .line 73
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x8

    .line 74
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x10

    .line 75
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x20

    .line 76
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x40

    .line 77
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x80

    .line 78
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x100

    .line 79
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x200

    .line 80
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x400

    .line 81
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x800

    .line 82
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    const/16 v0, 0x4000

    .line 83
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->add(ILjava/util/Map;)V

    return-void
.end method

.method private getCarrierApnTypeMap(Landroid/os/PersistableBundle;)Ljava/util/Map;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/os/PersistableBundle;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    if-nez p1, :cond_0

    .line 89
    sget-object p0, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->TAG:Ljava/lang/String;

    const-string p1, "carrier config is null"

    invoke-static {p0, p1}, Landroid/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 90
    new-instance p0, Landroid/util/ArrayMap;

    invoke-direct {p0}, Landroid/util/ArrayMap;-><init>()V

    return-object p0

    :cond_0
    const-string p0, "apn_priority_string_array"

    .line 94
    invoke-virtual {p1, p0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 96
    new-instance p1, Landroid/util/ArrayMap;

    invoke-direct {p1}, Landroid/util/ArrayMap;-><init>()V

    if-eqz p0, :cond_4

    .line 98
    array-length v0, p0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_4

    aget-object v3, p0, v2

    :try_start_0
    const-string v4, ":"

    .line 100
    invoke-virtual {v3, v4}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v4

    .line 101
    array-length v5, v4

    const/4 v6, 0x2

    if-eq v5, v6, :cond_1

    .line 102
    sget-object v4, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->TAG:Ljava/lang/String;

    const-string v5, "Apn type entry must have exactly one \':\'"

    invoke-static {v4, v5}, Landroid/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 103
    :cond_1
    aget-object v5, v4, v1

    const-string v6, ","

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v6, "Invalid apn type name, entry: "

    if-eqz v5, :cond_2

    .line 105
    :try_start_1
    sget-object v4, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->TAG:Ljava/lang/String;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 107
    :cond_2
    aget-object v5, v4, v1

    invoke-static {v5}, Landroid/telephony/data/ApnSetting;->getApnTypesBitmaskFromString(Ljava/lang/String;)I

    move-result v5

    if-lez v5, :cond_3

    .line 109
    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    const/4 v6, 0x1

    aget-object v4, v4, v6

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {p1, v5, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_1

    .line 111
    :cond_3
    sget-object v4, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->TAG:Ljava/lang/String;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_1

    :catch_0
    move-exception v4

    .line 116
    sget-object v5, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->TAG:Ljava/lang/String;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Exception on apn type entry: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\n"

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3, v4}, Landroid/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_0

    :cond_4
    return-object p1
.end method

.method private setup(Landroid/os/PersistableBundle;)V
    .locals 1

    .line 66
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->getCarrierApnTypeMap(Landroid/os/PersistableBundle;)Ljava/util/Map;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->addApns(Ljava/util/Map;)V

    .line 67
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->getCarrierApnTypeMap(Landroid/os/PersistableBundle;)Ljava/util/Map;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->addApns(Ljava/util/Map;)V

    return-void
.end method


# virtual methods
.method public getByType(I)Lcom/android/internal/telephony/dataconnection/ApnConfigType;
    .locals 0

    .line 62
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->mConfigTypeMap:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/dataconnection/ApnConfigType;

    return-object p0
.end method

.method public getTypes()Ljava/util/Collection;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Collection<",
            "Lcom/android/internal/telephony/dataconnection/ApnConfigType;",
            ">;"
        }
    .end annotation

    .line 52
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/ApnConfigTypeRepository;->mConfigTypeMap:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p0

    return-object p0
.end method
