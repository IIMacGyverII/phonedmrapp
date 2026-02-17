.class public Lcom/android/internal/telephony/CarrierPrivilegesTracker;
.super Landroid/os/Handler;
.source "CarrierPrivilegesTracker.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;
    }
.end annotation


# static fields
.field private static final ACTION_CARRIER_CONFIG_CERTS_UPDATED:I = 0x3

.field private static final ACTION_CLEAR_UICC_RULES:I = 0x9

.field private static final ACTION_INITIALIZE_TRACKER:I = 0x7

.field private static final ACTION_PACKAGE_ADDED_REPLACED_OR_CHANGED:I = 0x5

.field private static final ACTION_PACKAGE_REMOVED_OR_DISABLED_BY_USER:I = 0x6

.field private static final ACTION_REGISTER_LISTENER:I = 0x1

.field private static final ACTION_SET_TEST_OVERRIDE_RULE:I = 0x8

.field private static final ACTION_SIM_STATE_UPDATED:I = 0x4

.field private static final ACTION_UICC_ACCESS_RULES_LOADED:I = 0xa

.field private static final ACTION_UNREGISTER_LISTENER:I = 0x2

.field private static final CLEAR_UICC_RULES_DELAY_MILLIS:J

.field private static final CLEAR_UICC_RULE_NOT_SCHEDULED:J = -0x1L

.field private static final INSTALLED_PACKAGES_QUERY_FLAGS:I = 0x28008000

.field private static final SHA_1:Ljava/lang/String; = "SHA-1"

.field private static final SHA_256:Ljava/lang/String; = "SHA-256"

.field private static final TAG:Ljava/lang/String;

.field private static final VDBG:Z = false


# instance fields
.field private final mCachedUids:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;>;"
        }
    .end annotation
.end field

.field private final mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

.field private final mCarrierConfigRules:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/UiccAccessRule;",
            ">;"
        }
    .end annotation
.end field

.field private mClearUiccRulesUptimeMillis:J

.field private final mContext:Landroid/content/Context;

.field private final mInstalledPackageCerts:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;>;"
        }
    .end annotation
.end field

.field private final mIntentReceiver:Landroid/content/BroadcastReceiver;

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mPackageManager:Landroid/content/pm/PackageManager;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;
    .annotation build Lcom/android/internal/annotations/GuardedBy;
        anyOf = {
            "mPrivilegedPackageInfoLock.readLock()",
            "mPrivilegedPackageInfoLock.writeLock()"
        }
    .end annotation
.end field

.field private final mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

.field private final mRegistrantList:Lcom/android/internal/telephony/RegistrantList;

.field private mSimIsReadyButNotLoaded:Z
    .annotation build Lcom/android/internal/annotations/GuardedBy;
        anyOf = {
            "mPrivilegedPackageInfoLock.readLock()",
            "mPrivilegedPackageInfoLock.writeLock()"
        }
    .end annotation
.end field

.field private final mTelephonyManager:Landroid/telephony/TelephonyManager;

.field private final mTelephonyRegistryManager:Landroid/telephony/TelephonyRegistryManager;

.field private mTestOverrideRules:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/UiccAccessRule;",
            ">;"
        }
    .end annotation
.end field

.field private final mUiccRules:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/UiccAccessRule;",
            ">;"
        }
    .end annotation
.end field

.field private final mUserManager:Landroid/os/UserManager;


# direct methods
.method static bridge synthetic -$$Nest$fgetmPackageManager(Lcom/android/internal/telephony/CarrierPrivilegesTracker;)Landroid/content/pm/PackageManager;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$sfgetTAG()Ljava/lang/String;
    .locals 1

    sget-object v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$smgetObfuscatedPackages(Ljava/util/Collection;Ljava/util/function/Function;)Ljava/lang/String;
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getObfuscatedPackages(Ljava/util/Collection;Ljava/util/function/Function;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 104
    const-class v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    .line 118
    sget-object v0, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0x0

    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->CLEAR_UICC_RULES_DELAY_MILLIS:J

    return-void
.end method

.method public constructor <init>(Landroid/os/Looper;Lcom/android/internal/telephony/Phone;Landroid/content/Context;)V
    .locals 2

    .line 367
    invoke-direct {p0, p1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 199
    new-instance p1, Lcom/android/internal/telephony/LocalLog;

    const/16 v0, 0x40

    invoke-direct {p1, v0}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 200
    new-instance p1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {p1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mRegistrantList:Lcom/android/internal/telephony/RegistrantList;

    .line 202
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCarrierConfigRules:Ljava/util/List;

    .line 204
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUiccRules:Ljava/util/List;

    const/4 p1, 0x0

    .line 209
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTestOverrideRules:Ljava/util/List;

    .line 211
    new-instance p1, Landroid/util/ArrayMap;

    invoke-direct {p1}, Landroid/util/ArrayMap;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mInstalledPackageCerts:Ljava/util/Map;

    .line 213
    new-instance p1, Landroid/util/ArrayMap;

    invoke-direct {p1}, Landroid/util/ArrayMap;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCachedUids:Ljava/util/Map;

    .line 218
    new-instance p1, Ljava/util/concurrent/locks/ReentrantReadWriteLock;

    invoke-direct {p1}, Ljava/util/concurrent/locks/ReentrantReadWriteLock;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    .line 220
    new-instance p1, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    invoke-direct {p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;-><init>()V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    const-wide/16 v0, -0x1

    .line 225
    iput-wide v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mClearUiccRulesUptimeMillis:J

    const/4 p1, 0x0

    .line 235
    iput-boolean p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z

    .line 291
    new-instance p1, Lcom/android/internal/telephony/CarrierPrivilegesTracker$1;

    invoke-direct {p1, p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker$1;-><init>(Lcom/android/internal/telephony/CarrierPrivilegesTracker;)V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    .line 368
    iput-object p3, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mContext:Landroid/content/Context;

    .line 369
    iput-object p2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 370
    invoke-virtual {p3}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    const-string/jumbo p2, "user"

    .line 371
    invoke-virtual {p3, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/os/UserManager;

    iput-object p2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUserManager:Landroid/os/UserManager;

    const-string p2, "carrier_config"

    .line 373
    invoke-virtual {p3, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/CarrierConfigManager;

    iput-object p2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    const-string p2, "phone"

    .line 374
    invoke-virtual {p3, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/TelephonyManager;

    iput-object p2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    const-string/jumbo p2, "telephony_registry"

    .line 377
    invoke-virtual {p3, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/TelephonyRegistryManager;

    iput-object p2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTelephonyRegistryManager:Landroid/telephony/TelephonyRegistryManager;

    .line 379
    new-instance p2, Landroid/content/IntentFilter;

    invoke-direct {p2}, Landroid/content/IntentFilter;-><init>()V

    const-string v0, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 380
    invoke-virtual {p2, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v0, "android.telephony.action.SIM_CARD_STATE_CHANGED"

    .line 381
    invoke-virtual {p2, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v0, "android.telephony.action.SIM_APPLICATION_STATE_CHANGED"

    .line 382
    invoke-virtual {p2, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 383
    invoke-virtual {p3, p1, p2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 385
    new-instance p2, Landroid/content/IntentFilter;

    invoke-direct {p2}, Landroid/content/IntentFilter;-><init>()V

    const-string v0, "android.intent.action.PACKAGE_ADDED"

    .line 386
    invoke-virtual {p2, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v0, "android.intent.action.PACKAGE_REPLACED"

    .line 387
    invoke-virtual {p2, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v0, "android.intent.action.PACKAGE_REMOVED"

    .line 388
    invoke-virtual {p2, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v0, "android.intent.action.PACKAGE_CHANGED"

    .line 389
    invoke-virtual {p2, v0}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v0, "package"

    .line 393
    invoke-virtual {p2, v0}, Landroid/content/IntentFilter;->addDataScheme(Ljava/lang/String;)V

    .line 394
    invoke-virtual {p3, p1, p2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    const/4 p1, 0x7

    .line 396
    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method private getCarrierConfigRules(I)Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Ljava/util/List<",
            "Landroid/telephony/UiccAccessRule;",
            ">;"
        }
    .end annotation

    .line 492
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    invoke-virtual {p0, p1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    .line 493
    invoke-static {p0}, Landroid/telephony/CarrierConfigManager;->isConfigForIdentifiedCarrier(Landroid/os/PersistableBundle;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 494
    sget-object p0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object p0

    :cond_0
    const-string p1, "carrier_certificate_string_array"

    .line 498
    invoke-virtual {p0, p1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_1

    .line 500
    sget-object p0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object p0

    .line 502
    :cond_1
    invoke-static {p0}, Landroid/telephony/UiccAccessRule;->decodeRulesFromCarrierConfig([Ljava/lang/String;)[Landroid/telephony/UiccAccessRule;

    move-result-object p0

    invoke-static {p0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method private getCarrierService(Ljava/util/Set;)Landroid/util/Pair;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)",
            "Landroid/util/Pair<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 1071
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.service.carrier.CarrierService"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->queryIntentServices(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object v0

    .line 1074
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/pm/ResolveInfo;

    .line 1075
    invoke-static {v1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getPackageName(Landroid/content/pm/ResolveInfo;)Ljava/lang/String;

    move-result-object v1

    .line 1076
    invoke-interface {p1, v1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    goto :goto_0

    :cond_1
    move-object v1, v2

    :goto_0
    if-nez v1, :cond_2

    .line 1082
    new-instance p0, Landroid/util/Pair;

    const/4 p1, -0x1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-direct {p0, v2, p1}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    goto :goto_1

    .line 1083
    :cond_2
    new-instance p1, Landroid/util/Pair;

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getPackageUid(Ljava/lang/String;)I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-direct {p1, v1, p0}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    move-object p0, p1

    :goto_1
    return-object p0
.end method

.method private getCurrentPrivilegedPackagesForAllUsers()Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;
    .locals 6

    .line 760
    new-instance v0, Landroid/util/ArraySet;

    invoke-direct {v0}, Landroid/util/ArraySet;-><init>()V

    .line 761
    new-instance v1, Landroid/util/ArraySet;

    invoke-direct {v1}, Landroid/util/ArraySet;-><init>()V

    .line 762
    iget-object v2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mInstalledPackageCerts:Ljava/util/Map;

    invoke-interface {v2}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_0
    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/util/Map$Entry;

    .line 763
    invoke-interface {v3}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-interface {v3}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/util/Set;

    invoke-direct {p0, v4, v5}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->isPackagePrivileged(Ljava/lang/String;Ljava/util/Set;)Z

    move-result v4

    if-eqz v4, :cond_0

    .line 764
    invoke-interface {v3}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    invoke-interface {v0, v4}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 765
    invoke-interface {v3}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    const/4 v4, 0x0

    invoke-direct {p0, v3, v4}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getUidsForPackage(Ljava/lang/String;Z)Ljava/util/Set;

    move-result-object v3

    invoke-interface {v1, v3}, Ljava/util/Set;->addAll(Ljava/util/Collection;)Z

    goto :goto_0

    .line 768
    :cond_1
    new-instance v2, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    .line 769
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getCarrierService(Ljava/util/Set;)Landroid/util/Pair;

    move-result-object p0

    invoke-direct {v2, v0, v1, p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;-><init>(Ljava/util/Set;Ljava/util/Set;Landroid/util/Pair;)V

    return-object v2
.end method

.method private static getObfuscatedPackages(Ljava/util/Collection;Ljava/util/function/Function;)Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Ljava/util/Collection<",
            "TT;>;",
            "Ljava/util/function/Function<",
            "TT;",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 678
    new-instance v0, Ljava/util/StringJoiner;

    const-string v1, ", "

    const-string/jumbo v2, "{"

    const-string/jumbo v3, "}"

    invoke-direct {v0, v1, v2, v3}, Ljava/util/StringJoiner;-><init>(Ljava/lang/CharSequence;Ljava/lang/CharSequence;Ljava/lang/CharSequence;)V

    .line 679
    invoke-interface {p0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    .line 680
    invoke-interface {p1, v1}, Ljava/util/function/Function;->apply(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    invoke-virtual {v0, v1}, Ljava/util/StringJoiner;->add(Ljava/lang/CharSequence;)Ljava/util/StringJoiner;

    goto :goto_0

    .line 682
    :cond_0
    invoke-virtual {v0}, Ljava/util/StringJoiner;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static getPackageName(Landroid/content/pm/ResolveInfo;)Ljava/lang/String;
    .locals 1

    .line 1063
    iget-object v0, p0, Landroid/content/pm/ResolveInfo;->activityInfo:Landroid/content/pm/ActivityInfo;

    if-eqz v0, :cond_0

    iget-object p0, v0, Landroid/content/pm/ActivityInfo;->packageName:Ljava/lang/String;

    return-object p0

    .line 1064
    :cond_0
    iget-object v0, p0, Landroid/content/pm/ResolveInfo;->serviceInfo:Landroid/content/pm/ServiceInfo;

    if-eqz v0, :cond_1

    iget-object p0, v0, Landroid/content/pm/ServiceInfo;->packageName:Ljava/lang/String;

    return-object p0

    .line 1065
    :cond_1
    iget-object p0, p0, Landroid/content/pm/ResolveInfo;->providerInfo:Landroid/content/pm/ProviderInfo;

    if-eqz p0, :cond_2

    iget-object p0, p0, Landroid/content/pm/ProviderInfo;->packageName:Ljava/lang/String;

    return-object p0

    :cond_2
    const/4 p0, 0x0

    return-object p0
.end method

.method private getPackageUid(Ljava/lang/String;)I
    .locals 2

    .line 831
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Landroid/content/pm/PackageManager;->getPackageUid(Ljava/lang/String;I)I

    move-result p0
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 833
    :catch_0
    sget-object p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unable to find uid for package "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, -0x1

    :goto_0
    return p0
.end method

.method private getSimRules()Ljava/util/List;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/telephony/UiccAccessRule;",
            ">;"
        }
    .end annotation

    .line 561
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/TelephonyManager;->hasIccCard(I)Z

    move-result v0

    if-nez v0, :cond_0

    .line 562
    sget-object p0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object p0

    .line 565
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getUiccPort()Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object v0

    if-nez v0, :cond_1

    .line 567
    sget-object v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Null UiccPort, but hasIccCard was present for phoneId "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 569
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 567
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 570
    sget-object p0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object p0

    .line 573
    :cond_1
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccPort;->getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object v0

    if-nez v0, :cond_2

    .line 575
    sget-object v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Null UiccProfile, but hasIccCard was true for phoneId "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 577
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 575
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 578
    sget-object p0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object p0

    .line 580
    :cond_2
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccProfile;->getCarrierPrivilegeAccessRules()Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method private getUidsForPackage(Ljava/lang/String;Z)Ljava/util/Set;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Z)",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    if-eqz p2, :cond_0

    .line 807
    iget-object p2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCachedUids:Ljava/util/Map;

    invoke-interface {p2, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 809
    :cond_0
    iget-object p2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCachedUids:Ljava/util/Map;

    invoke-interface {p2, p1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    .line 810
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCachedUids:Ljava/util/Map;

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Set;

    return-object p0

    .line 813
    :cond_1
    new-instance p2, Landroid/util/ArraySet;

    invoke-direct {p2}, Landroid/util/ArraySet;-><init>()V

    .line 814
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUserManager:Landroid/os/UserManager;

    invoke-virtual {v0}, Landroid/os/UserManager;->getUsers()Ljava/util/List;

    move-result-object v0

    .line 815
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/pm/UserInfo;

    .line 816
    invoke-virtual {v1}, Landroid/content/pm/UserInfo;->getUserHandle()Landroid/os/UserHandle;

    move-result-object v1

    invoke-virtual {v1}, Landroid/os/UserHandle;->getIdentifier()I

    move-result v1

    .line 818
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    invoke-virtual {v2, p1, v1}, Landroid/content/pm/PackageManager;->getPackageUidAsUser(Ljava/lang/String;I)I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {p2, v2}, Ljava/util/Set;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 821
    :catch_0
    sget-object v2, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Unable to find uid for package "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " and user "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 824
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCachedUids:Ljava/util/Map;

    invoke-interface {p0, p1, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-object p2
.end method

.method private handleCarrierConfigUpdated(II)V
    .locals 4

    .line 472
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    if-eq p2, v0, :cond_0

    return-void

    .line 474
    :cond_0
    sget-object v0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    const/4 v1, -0x1

    if-eq p1, v1, :cond_1

    .line 480
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getCarrierConfigRules(I)Ljava/util/List;

    move-result-object v0

    .line 483
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "CarrierConfigUpdated: subId="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " slotIndex="

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " updated CarrierConfig rules="

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 487
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCarrierConfigRules:Ljava/util/List;

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->maybeUpdateRulesAndNotifyRegistrants(Ljava/util/List;Ljava/util/List;)V

    return-void
.end method

.method private handleClearUiccRules()V
    .locals 2

    const-wide/16 v0, -0x1

    .line 554
    iput-wide v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mClearUiccRulesUptimeMillis:J

    const/16 v0, 0x9

    .line 555
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    .line 556
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUiccRules:Ljava/util/List;

    sget-object v1, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->maybeUpdateRulesAndNotifyRegistrants(Ljava/util/List;Ljava/util/List;)V

    return-void
.end method

.method private handleInitializeTracker()V
    .locals 2

    .line 639
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCarrierConfigRules:Ljava/util/List;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getCarrierConfigRules(I)Ljava/util/List;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 642
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUiccRules:Ljava/util/List;

    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getSimRules()Ljava/util/List;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 645
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->refreshInstalledPackageCache()V

    .line 648
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->maybeUpdatePrivilegedPackagesAndNotifyRegistrants()V

    .line 650
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Initializing state: CarrierConfig rules="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCarrierConfigRules:Ljava/util/List;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " SIM-loaded rules="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUiccRules:Ljava/util/List;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 660
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method private handlePackageAddedReplacedOrChanged(Ljava/lang/String;)V
    .locals 3

    if-nez p1, :cond_0

    return-void

    .line 588
    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    const v1, 0x28008000

    invoke-virtual {v0, p1, v1}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object p1
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    .line 594
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->updateCertsForPackage(Landroid/content/pm/PackageInfo;)V

    .line 598
    iget-object p1, p1, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    const/4 v0, 0x1

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getUidsForPackage(Ljava/lang/String;Z)Ljava/util/Set;

    .line 605
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->maybeUpdatePrivilegedPackagesAndNotifyRegistrants()V

    return-void

    :catch_0
    move-exception p0

    .line 590
    sget-object v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Error getting installed package: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method private handlePackageRemovedOrDisabledByUser(Ljava/lang/String;)V
    .locals 2

    if-nez p1, :cond_0

    return-void

    .line 625
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mInstalledPackageCerts:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCachedUids:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_1

    goto :goto_0

    .line 634
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->maybeUpdatePrivilegedPackagesAndNotifyRegistrants()V

    return-void

    .line 626
    :cond_2
    :goto_0
    sget-object p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown package was uninstalled or disabled by user: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private handleRegisterListener(Lcom/android/internal/telephony/Registrant;)V
    .locals 2

    .line 455
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mRegistrantList:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 456
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 459
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v0, v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    invoke-static {v0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->intSetToArray(Ljava/util/Set;)[I

    move-result-object v0

    .line 460
    array-length v1, v0

    .line 461
    invoke-static {v0, v1}, Ljava/util/Arrays;->copyOf([II)[I

    move-result-object v0

    .line 460
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/Registrant;->notifyResult(Ljava/lang/Object;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 463
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return-void

    :catchall_0
    move-exception p1

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 464
    throw p1
.end method

.method private handleSetTestOverrideRules(Ljava/lang/String;)V
    .locals 2

    if-nez p1, :cond_0

    const/4 p1, 0x0

    .line 910
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTestOverrideRules:Ljava/util/List;

    goto :goto_0

    .line 911
    :cond_0
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 912
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTestOverrideRules:Ljava/util/List;

    goto :goto_0

    :cond_1
    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    aput-object p1, v0, v1

    .line 914
    invoke-static {v0}, Landroid/telephony/UiccAccessRule;->decodeRulesFromCarrierConfig([Ljava/lang/String;)[Landroid/telephony/UiccAccessRule;

    move-result-object p1

    invoke-static {p1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTestOverrideRules:Ljava/util/List;

    .line 920
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->refreshInstalledPackageCache()V

    .line 922
    :goto_0
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->maybeUpdatePrivilegedPackagesAndNotifyRegistrants()V

    return-void
.end method

.method private handleSimStateChanged(II)V
    .locals 4

    .line 506
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    if-eq p1, v0, :cond_0

    return-void

    .line 508
    :cond_0
    sget-object p1, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    .line 510
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p1}, Ljava/util/concurrent/locks/ReadWriteLock;->writeLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/concurrent/locks/Lock;->lock()V

    const/4 p1, 0x5

    if-ne p2, p1, :cond_1

    const/4 p1, 0x1

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    .line 512
    :goto_0
    :try_start_0
    iput-boolean p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 514
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p1}, Ljava/util/concurrent/locks/ReadWriteLock;->writeLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/concurrent/locks/Lock;->unlock()V

    const/16 p1, 0xa

    if-ne p2, p1, :cond_2

    .line 519
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    const-string p2, "SIM fully loaded, handleUiccAccessRulesLoaded."

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 520
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handleUiccAccessRulesLoaded()V

    goto :goto_1

    .line 522
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUiccRules:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_3

    iget-wide v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mClearUiccRulesUptimeMillis:J

    const-wide/16 v2, -0x1

    cmp-long p1, v0, v2

    if-nez p1, :cond_3

    .line 525
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->CLEAR_UICC_RULES_DELAY_MILLIS:J

    add-long/2addr v0, v2

    iput-wide v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mClearUiccRulesUptimeMillis:J

    const/16 p1, 0x9

    .line 526
    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    iget-wide v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mClearUiccRulesUptimeMillis:J

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageAtTime(Landroid/os/Message;J)Z

    .line 528
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "SIM is gone, simState="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;->simStateString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ". Delay "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p2, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    .line 529
    invoke-virtual {p2, v2, v3}, Ljava/util/concurrent/TimeUnit;->toSeconds(J)J

    move-result-wide v0

    invoke-virtual {p1, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p2, " seconds to clear UICC rules."

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 528
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    goto :goto_1

    .line 532
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    const-string p1, "Ignore SIM gone event while UiccRules is empty or waiting to be emptied."

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    :goto_1
    return-void

    :catchall_0
    move-exception p1

    .line 514
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->writeLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 515
    throw p1
.end method

.method private handleUiccAccessRulesLoaded()V
    .locals 4

    const-wide/16 v0, -0x1

    .line 539
    iput-wide v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mClearUiccRulesUptimeMillis:J

    const/16 v0, 0x9

    .line 540
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    .line 542
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getSimRules()Ljava/util/List;

    move-result-object v0

    .line 543
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "UiccAccessRules loaded: updated SIM-loaded rules="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 545
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUiccRules:Ljava/util/List;

    invoke-direct {p0, v1, v0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->maybeUpdateRulesAndNotifyRegistrants(Ljava/util/List;Ljava/util/List;)V

    return-void
.end method

.method private handleUnregisterListener(Landroid/os/Handler;)V
    .locals 0

    .line 468
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mRegistrantList:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method private static intSetToArray(Ljava/util/Set;)[I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;)[I"
        }
    .end annotation

    .line 1088
    new-instance v0, Landroid/util/IntArray;

    invoke-interface {p0}, Ljava/util/Set;->size()I

    move-result v1

    invoke-direct {v0, v1}, Landroid/util/IntArray;-><init>(I)V

    .line 1089
    new-instance v1, Lcom/android/internal/telephony/CarrierPrivilegesTracker$$ExternalSyntheticLambda0;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker$$ExternalSyntheticLambda0;-><init>(Landroid/util/IntArray;)V

    invoke-interface {p0, v1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    .line 1090
    invoke-virtual {v0}, Landroid/util/IntArray;->toArray()[I

    move-result-object p0

    return-object p0
.end method

.method private isPackagePrivileged(Ljava/lang/String;Ljava/util/Set;)Z
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)Z"
        }
    .end annotation

    .line 780
    invoke-interface {p2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :cond_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_6

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 782
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTestOverrideRules:Ljava/util/List;

    const/4 v2, 0x1

    if-eqz v1, :cond_2

    .line 783
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_1
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/UiccAccessRule;

    .line 784
    invoke-virtual {v3, v0, p1}, Landroid/telephony/UiccAccessRule;->matches(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    return v2

    .line 789
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCarrierConfigRules:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_3
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_4

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/UiccAccessRule;

    .line 790
    invoke-virtual {v3, v0, p1}, Landroid/telephony/UiccAccessRule;->matches(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_3

    return v2

    .line 794
    :cond_4
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUiccRules:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_5
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/UiccAccessRule;

    .line 795
    invoke-virtual {v3, v0, p1}, Landroid/telephony/UiccAccessRule;->matches(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_5

    return v2

    :cond_6
    const/4 p0, 0x0

    return p0
.end method

.method private static synthetic lambda$dump$1(Ljava/util/Map$Entry;)Ljava/lang/String;
    .locals 3

    .line 863
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "pkg("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    invoke-interface {p0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/android/telephony/Rlog;->pii(Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ")="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$handleInitializeTracker$0(Ljava/util/Map$Entry;)Ljava/lang/String;
    .locals 3

    .line 658
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "pkg("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    invoke-interface {p0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/android/telephony/Rlog;->pii(Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ")="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private maybeUpdatePrivilegedPackagesAndNotifyRegistrants()V
    .locals 6

    .line 697
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getCurrentPrivilegedPackagesForAllUsers()Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    move-result-object v0

    .line 703
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v1}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 705
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->equals(Ljava/lang/Object;)Z

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    if-eqz v1, :cond_0

    .line 718
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return-void

    .line 707
    :cond_0
    :try_start_1
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Privileged packages info changed. New state = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 710
    iget-object v1, v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    iget-object v2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v2, v2, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    .line 711
    invoke-interface {v1, v2}, Ljava/util/Set;->equals(Ljava/lang/Object;)Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-nez v1, :cond_1

    move v1, v3

    goto :goto_0

    :cond_1
    move v1, v2

    .line 713
    :goto_0
    iget-object v4, v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    iget-object v5, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v5, v5, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    .line 714
    invoke-interface {v4, v5}, Ljava/util/Set;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_2

    move v2, v3

    .line 715
    :cond_2
    iget-object v4, v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    iget-object v5, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v5, v5, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    invoke-virtual {v4, v5}, Landroid/util/Pair;->equals(Ljava/lang/Object;)Z

    move-result v4
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    xor-int/2addr v3, v4

    .line 718
    iget-object v4, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v4}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 721
    iget-object v4, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v4}, Ljava/util/concurrent/locks/ReadWriteLock;->writeLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 723
    :try_start_2
    iput-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 725
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->writeLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 728
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->lock()V

    if-eqz v2, :cond_3

    .line 732
    :try_start_3
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v0, v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    invoke-static {v0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->intSetToArray(Ljava/util/Set;)[I

    move-result-object v0

    .line 733
    iget-object v4, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mRegistrantList:Lcom/android/internal/telephony/RegistrantList;

    array-length v5, v0

    invoke-static {v0, v5}, Ljava/util/Arrays;->copyOf([II)[I

    move-result-object v0

    invoke-virtual {v4, v0}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    goto :goto_1

    :catchall_0
    move-exception v0

    goto :goto_2

    :cond_3
    :goto_1
    if-nez v1, :cond_4

    if-eqz v2, :cond_5

    .line 737
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTelephonyRegistryManager:Landroid/telephony/TelephonyRegistryManager;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 738
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    iget-object v2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v2, v2, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    .line 739
    invoke-static {v2}, Ljava/util/Collections;->unmodifiableSet(Ljava/util/Set;)Ljava/util/Set;

    move-result-object v2

    iget-object v4, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v4, v4, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    .line 740
    invoke-static {v4}, Ljava/util/Collections;->unmodifiableSet(Ljava/util/Set;)Ljava/util/Set;

    move-result-object v4

    .line 737
    invoke-virtual {v0, v1, v2, v4}, Landroid/telephony/TelephonyRegistryManager;->notifyCarrierPrivilegesChanged(ILjava/util/Set;Ljava/util/Set;)V

    :cond_5
    if-eqz v3, :cond_6

    .line 744
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTelephonyRegistryManager:Landroid/telephony/TelephonyRegistryManager;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    iget-object v2, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v2, v2, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    iget-object v3, v2, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v3, Ljava/lang/String;

    iget-object v2, v2, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v2, Ljava/lang/Integer;

    .line 746
    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    .line 744
    invoke-virtual {v0, v1, v3, v2}, Landroid/telephony/TelephonyRegistryManager;->notifyCarrierServiceChanged(ILjava/lang/String;I)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 749
    :cond_6
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 753
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mContext:Landroid/content/Context;

    const-class v1, Landroid/app/ActivityManager;

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager;

    .line 754
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mContext:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    .line 755
    invoke-static {}, Landroid/app/ActivityManager;->getCurrentUser()I

    move-result v2

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mContext:Landroid/content/Context;

    .line 754
    invoke-static {v0, v1, v2, p0}, Lcom/android/internal/telephony/CarrierAppUtils;->disableCarrierAppsUntilPrivileged(Ljava/lang/String;Landroid/telephony/TelephonyManager;ILandroid/content/Context;)V

    return-void

    .line 749
    :goto_2
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 750
    throw v0

    :catchall_1
    move-exception v0

    .line 725
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->writeLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 726
    throw v0

    :catchall_2
    move-exception v0

    .line 718
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 719
    throw v0
.end method

.method private maybeUpdateRulesAndNotifyRegistrants(Ljava/util/List;Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/UiccAccessRule;",
            ">;",
            "Ljava/util/List<",
            "Landroid/telephony/UiccAccessRule;",
            ">;)V"
        }
    .end annotation

    .line 687
    invoke-interface {p1, p2}, Ljava/util/List;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 689
    :cond_0
    invoke-interface {p1}, Ljava/util/List;->clear()V

    .line 690
    invoke-interface {p1, p2}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 692
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->maybeUpdatePrivilegedPackagesAndNotifyRegistrants()V

    return-void
.end method

.method private refreshInstalledPackageCache()V
    .locals 3

    .line 664
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    sget-object v1, Landroid/os/UserHandle;->SYSTEM:Landroid/os/UserHandle;

    .line 666
    invoke-virtual {v1}, Landroid/os/UserHandle;->getIdentifier()I

    move-result v1

    const v2, 0x28008000

    .line 665
    invoke-virtual {v0, v2, v1}, Landroid/content/pm/PackageManager;->getInstalledPackagesAsUser(II)Ljava/util/List;

    move-result-object v0

    .line 667
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/pm/PackageInfo;

    .line 668
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->updateCertsForPackage(Landroid/content/pm/PackageInfo;)V

    .line 671
    iget-object v1, v1, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    const/4 v2, 0x1

    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getUidsForPackage(Ljava/lang/String;Z)Ljava/util/Set;

    goto :goto_0

    :cond_0
    return-void
.end method

.method private updateCertsForPackage(Landroid/content/pm/PackageInfo;)V
    .locals 4

    .line 609
    new-instance v0, Landroid/util/ArraySet;

    invoke-direct {v0}, Landroid/util/ArraySet;-><init>()V

    .line 610
    invoke-static {p1}, Landroid/telephony/UiccAccessRule;->getSignatures(Landroid/content/pm/PackageInfo;)Ljava/util/List;

    move-result-object v1

    .line 611
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/content/pm/Signature;

    const-string v3, "SHA-1"

    .line 612
    invoke-static {v2, v3}, Landroid/telephony/UiccAccessRule;->getCertHash(Landroid/content/pm/Signature;Ljava/lang/String;)[B

    move-result-object v3

    .line 613
    invoke-static {v3}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v3}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    const-string v3, "SHA-256"

    .line 615
    invoke-static {v2, v3}, Landroid/telephony/UiccAccessRule;->getCertHash(Landroid/content/pm/Signature;Ljava/lang/String;)[B

    move-result-object v2

    .line 616
    invoke-static {v2}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 619
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mInstalledPackageCerts:Ljava/util/Map;

    iget-object p1, p1, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-interface {p0, p1, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 842
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "CarrierPrivilegesTracker - phoneId: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string v0, "CarrierPrivilegesTracker - Log Begin ----"

    .line 843
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 844
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v0, p1, p2, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    const-string p1, "CarrierPrivilegesTracker - Log End ----"

    .line 845
    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 846
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p1}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 848
    :try_start_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "CarrierPrivilegesTracker - Privileged package info: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 851
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mSimIsReadyButNotLoaded: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p3, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 853
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p1}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 855
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "CarrierPrivilegesTracker - Test-override rules: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mTestOverrideRules:Ljava/util/List;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 856
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "CarrierPrivilegesTracker - SIM-loaded rules: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mUiccRules:Ljava/util/List;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 857
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "CarrierPrivilegesTracker - Carrier config rules: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mCarrierConfigRules:Ljava/util/List;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 865
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mClearUiccRulesUptimeMillis: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mClearUiccRulesUptimeMillis:J

    invoke-virtual {p1, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    return-void

    :catchall_0
    move-exception p1

    .line 853
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 854
    throw p1
.end method

.method public getCarrierPackageNamesForIntent(Landroid/content/Intent;)Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Intent;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 1024
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 1026
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z

    if-eqz v0, :cond_0

    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 1028
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return-object p1

    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 1033
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1034
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    const/4 v2, 0x0

    invoke-virtual {v1, p1, v2}, Landroid/content/pm/PackageManager;->queryBroadcastReceivers(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1035
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    invoke-virtual {v1, p1, v2}, Landroid/content/pm/PackageManager;->queryIntentActivities(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1036
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    invoke-virtual {v1, p1, v2}, Landroid/content/pm/PackageManager;->queryIntentServices(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1037
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPackageManager:Landroid/content/pm/PackageManager;

    invoke-virtual {v1, p1, v2}, Landroid/content/pm/PackageManager;->queryIntentContentProviders(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1040
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p1}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 1044
    :try_start_1
    iget-boolean p1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z

    if-eqz p1, :cond_1

    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1056
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return-object p1

    .line 1046
    :cond_1
    :try_start_2
    new-instance p1, Landroid/util/ArraySet;

    invoke-direct {p1}, Landroid/util/ArraySet;-><init>()V

    .line 1047
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_2
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/pm/ResolveInfo;

    .line 1048
    invoke-static {v1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getPackageName(Landroid/content/pm/ResolveInfo;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_2

    const/4 v2, 0x1

    .line 1050
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getCarrierPrivilegeStatusForPackage(Ljava/lang/String;)I

    move-result v3

    if-ne v2, v3, :cond_2

    .line 1051
    invoke-interface {p1, v1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 1054
    :cond_3
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0, p1}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 1056
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return-object v0

    :catchall_0
    move-exception p1

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 1057
    throw p1

    :catchall_1
    move-exception p1

    .line 1028
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 1029
    throw p1
.end method

.method public getCarrierPrivilegeStatusForPackage(Ljava/lang/String;)I
    .locals 2

    const/4 v0, 0x0

    if-nez p1, :cond_0

    return v0

    .line 934
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v1}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 936
    :try_start_0
    iget-boolean v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v1, :cond_1

    const/4 p1, -0x1

    .line 944
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return p1

    .line 938
    :cond_1
    :try_start_1
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v1, v1, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    invoke-interface {v1, p1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz p1, :cond_2

    const/4 p1, 0x1

    goto :goto_0

    .line 944
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return v0

    :catchall_0
    move-exception p1

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 945
    throw p1
.end method

.method public getCarrierPrivilegeStatusForUid(I)I
    .locals 1

    .line 969
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 971
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    const/4 p1, -0x1

    .line 979
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return p1

    .line 973
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v0, v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mUids:Ljava/util/Set;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz p1, :cond_1

    const/4 p1, 0x1

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    goto :goto_0

    :catchall_0
    move-exception p1

    .line 979
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 980
    throw p1
.end method

.method public getCarrierServicePackageName()Ljava/lang/String;
    .locals 1

    .line 990
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 994
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    .line 998
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return-object v0

    .line 996
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v0, v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    iget-object v0, v0, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v0, Ljava/lang/String;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v0

    .line 998
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 999
    throw v0
.end method

.method public getCarrierServicePackageUid()I
    .locals 1

    .line 1008
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 1010
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    const/4 v0, -0x1

    .line 1014
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return v0

    .line 1012
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v0, v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mCarrierService:Landroid/util/Pair;

    iget-object v0, v0, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v0

    .line 1014
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 1015
    throw v0
.end method

.method public getPackagesWithCarrierPrivileges()Ljava/util/Set;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 951
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {v0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/concurrent/locks/Lock;->lock()V

    .line 953
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mSimIsReadyButNotLoaded:Z

    if-eqz v0, :cond_0

    invoke-static {}, Ljava/util/Collections;->emptySet()Ljava/util/Set;

    move-result-object v0

    goto :goto_0

    .line 954
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfo:Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;

    iget-object v0, v0, Lcom/android/internal/telephony/CarrierPrivilegesTracker$PrivilegedPackageInfo;->mPackageNames:Ljava/util/Set;

    invoke-static {v0}, Ljava/util/Collections;->unmodifiableSet(Ljava/util/Set;)Ljava/util/Set;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 956
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    return-object v0

    :catchall_0
    move-exception v0

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->mPrivilegedPackageInfoLock:Ljava/util/concurrent/locks/ReadWriteLock;

    invoke-interface {p0}, Ljava/util/concurrent/locks/ReadWriteLock;->readLock()Ljava/util/concurrent/locks/Lock;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/concurrent/locks/Lock;->unlock()V

    .line 957
    throw v0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 401
    iget v0, p1, Landroid/os/Message;->what:I

    packed-switch v0, :pswitch_data_0

    .line 448
    sget-object p0, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->TAG:Ljava/lang/String;

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Received unknown msg type: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 444
    :pswitch_0
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handleUiccAccessRulesLoaded()V

    goto :goto_0

    .line 440
    :pswitch_1
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handleClearUiccRules()V

    goto :goto_0

    .line 435
    :pswitch_2
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    .line 436
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handleSetTestOverrideRules(Ljava/lang/String;)V

    goto :goto_0

    .line 431
    :pswitch_3
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handleInitializeTracker()V

    goto :goto_0

    .line 426
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    .line 427
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handlePackageRemovedOrDisabledByUser(Ljava/lang/String;)V

    goto :goto_0

    .line 421
    :pswitch_5
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Ljava/lang/String;

    .line 422
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handlePackageAddedReplacedOrChanged(Ljava/lang/String;)V

    goto :goto_0

    .line 417
    :pswitch_6
    iget v0, p1, Landroid/os/Message;->arg1:I

    iget p1, p1, Landroid/os/Message;->arg2:I

    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handleSimStateChanged(II)V

    goto :goto_0

    .line 411
    :pswitch_7
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 412
    iget p1, p1, Landroid/os/Message;->arg2:I

    .line 413
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handleCarrierConfigUpdated(II)V

    goto :goto_0

    .line 407
    :pswitch_8
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/Handler;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handleUnregisterListener(Landroid/os/Handler;)V

    goto :goto_0

    .line 403
    :pswitch_9
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/Registrant;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->handleRegisterListener(Lcom/android/internal/telephony/Registrant;)V

    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public onUiccAccessRulesLoaded()V
    .locals 1

    const/16 v0, 0xa

    .line 550
    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    return-void
.end method

.method public registerCarrierPrivilegesListener(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    .line 881
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    const/4 p1, 0x1

    invoke-virtual {p0, p1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public setTestOverrideCarrierPrivilegeRules(Ljava/lang/String;)V
    .locals 1

    const/16 v0, 0x8

    .line 905
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public unregisterCarrierPrivilegesListener(Landroid/os/Handler;)V
    .locals 1
    .annotation runtime Ljava/lang/Deprecated;
    .end annotation

    const/4 v0, 0x2

    .line 892
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method
