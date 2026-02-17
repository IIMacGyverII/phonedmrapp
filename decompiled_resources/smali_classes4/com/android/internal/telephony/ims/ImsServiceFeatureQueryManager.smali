.class public Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;
.super Ljava/lang/Object;
.source "ImsServiceFeatureQueryManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;,
        Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$ImsServiceFeatureQuery;
    }
.end annotation


# instance fields
.field private final mActiveQueries:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/content/ComponentName;",
            "Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$ImsServiceFeatureQuery;",
            ">;"
        }
    .end annotation
.end field

.field private final mContext:Landroid/content/Context;

.field private final mListener:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;

.field private final mLock:Ljava/lang/Object;


# direct methods
.method static bridge synthetic -$$Nest$fgetmActiveQueries(Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;)Ljava/util/Map;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mActiveQueries:Ljava/util/Map;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmContext(Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;)Landroid/content/Context;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mContext:Landroid/content/Context;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmListener(Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;)Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mListener:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLock(Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;)Ljava/lang/Object;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mLock:Ljava/lang/Object;

    return-object p0
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;)V
    .locals 1

    .line 166
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 161
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mActiveQueries:Ljava/util/Map;

    .line 164
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mLock:Ljava/lang/Object;

    .line 167
    iput-object p1, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mContext:Landroid/content/Context;

    .line 168
    iput-object p2, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mListener:Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$Listener;

    return-void
.end method


# virtual methods
.method public isQueryInProgress()Z
    .locals 1

    .line 193
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 194
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mActiveQueries:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->isEmpty()Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    monitor-exit v0

    return p0

    :catchall_0
    move-exception p0

    .line 195
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public startQuery(Landroid/content/ComponentName;Ljava/lang/String;)Z
    .locals 2

    .line 178
    iget-object v0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mLock:Ljava/lang/Object;

    monitor-enter v0

    .line 179
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mActiveQueries:Ljava/util/Map;

    invoke-interface {v1, p1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const/4 p0, 0x1

    .line 181
    monitor-exit v0

    return p0

    .line 183
    :cond_0
    new-instance v1, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$ImsServiceFeatureQuery;

    invoke-direct {v1, p0, p1, p2}, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$ImsServiceFeatureQuery;-><init>(Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;Landroid/content/ComponentName;Ljava/lang/String;)V

    .line 184
    iget-object p0, p0, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager;->mActiveQueries:Ljava/util/Map;

    invoke-interface {p0, p1, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 185
    invoke-virtual {v1}, Lcom/android/internal/telephony/ims/ImsServiceFeatureQueryManager$ImsServiceFeatureQuery;->start()Z

    move-result p0

    monitor-exit v0

    return p0

    :catchall_0
    move-exception p0

    .line 186
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
