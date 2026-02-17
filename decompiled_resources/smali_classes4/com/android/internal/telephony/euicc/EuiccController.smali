.class public Lcom/android/internal/telephony/euicc/EuiccController;
.super Lcom/android/internal/telephony/euicc/IEuiccController$Stub;
.source "EuiccController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/euicc/EuiccController$GetDefaultListCommandCallback;,
        Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;,
        Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;
    }
.end annotation


# static fields
.field private static final ERROR:I = 0x2

.field private static final EUICC_DUMP_TIME_OUT_SECONDS:I = 0x5

.field private static final EXTRA_EMBEDDED_SUBSCRIPTION_DOWNLOADABLE_SUBSCRIPTION:Ljava/lang/String; = "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_DOWNLOADABLE_SUBSCRIPTION"

.field static final EXTRA_OPERATION:Ljava/lang/String; = "operation"
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final OK:I = 0x0

.field private static final RESOLUTION_ACTIVITY_CLASS_NAME:Ljava/lang/String; = "com.android.phone.euicc.EuiccResolutionUiDispatcherActivity"

.field private static final RESOLUTION_ACTIVITY_PACKAGE_NAME:Ljava/lang/String; = "com.android.phone"

.field private static final RESOLVABLE_ERROR:I = 0x1

.field private static final TAG:Ljava/lang/String; = "EuiccController"

.field private static sInstance:Lcom/android/internal/telephony/euicc/EuiccController;


# instance fields
.field private final mAppOpsManager:Landroid/app/AppOpsManager;

.field private final mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

.field private final mContext:Landroid/content/Context;

.field private final mPackageManager:Landroid/content/pm/PackageManager;

.field private final mSubscriptionManager:Landroid/telephony/SubscriptionManager;

.field private mSupportedCountries:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private final mTelephonyManager:Landroid/telephony/TelephonyManager;

.field private mUnsupportedCountries:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$V_ySsFE-Cog52iEv7sNhriidFcc(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/euicc/EuiccController;->lambda$refreshSubscriptionsAndSendResult$0(Landroid/app/PendingIntent;ILandroid/content/Intent;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmContext(Lcom/android/internal/telephony/euicc/EuiccController;)Landroid/content/Context;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$maddExtrasToResultIntent(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/content/Intent;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/euicc/EuiccController;->addExtrasToResultIntent(Landroid/content/Intent;I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mcheckCarrierPrivilegeInMetadata(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/telephony/euicc/DownloadableSubscription;Ljava/lang/String;)Z
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/euicc/EuiccController;->checkCarrierPrivilegeInMetadata(Landroid/telephony/euicc/DownloadableSubscription;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 145
    new-instance v0, Lcom/android/internal/telephony/euicc/EuiccConnector;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/euicc/EuiccConnector;-><init>(Landroid/content/Context;)V

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/euicc/EuiccController;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/euicc/EuiccConnector;)V

    .line 147
    invoke-static {}, Landroid/telephony/TelephonyFrameworkInitializer;->getTelephonyServiceManager()Landroid/os/TelephonyServiceManager;

    move-result-object p1

    invoke-virtual {p1}, Landroid/os/TelephonyServiceManager;->getEuiccControllerService()Landroid/os/TelephonyServiceManager$ServiceRegisterer;

    move-result-object p1

    invoke-virtual {p1, p0}, Landroid/os/TelephonyServiceManager$ServiceRegisterer;->register(Landroid/os/IBinder;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/euicc/EuiccConnector;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 151
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/IEuiccController$Stub;-><init>()V

    .line 152
    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    .line 153
    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    const-string/jumbo p2, "telephony_subscription_service"

    .line 155
    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/SubscriptionManager;

    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    const-string p2, "phone"

    .line 157
    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/TelephonyManager;

    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    const-string p2, "appops"

    .line 158
    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/app/AppOpsManager;

    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    .line 159
    invoke-virtual {p1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mPackageManager:Landroid/content/pm/PackageManager;

    return-void
.end method

.method private addExtrasToResultIntent(Landroid/content/Intent;I)V
    .locals 2

    ushr-int/lit8 v0, p2, 0x18

    const-string v1, "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_DETAILED_CODE"

    .line 532
    invoke-virtual {p1, v1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string v1, "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_OPERATION_CODE"

    .line 535
    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const/16 v1, 0xa

    if-ne v0, v1, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    if-eqz v0, :cond_1

    .line 542
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccController;->decodeSmdxSubjectAndReasonCode(I)Landroid/util/Pair;

    move-result-object p0

    .line 544
    iget-object p2, p0, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast p2, Ljava/lang/String;

    .line 545
    iget-object p0, p0, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p0, Ljava/lang/String;

    const-string v0, "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_SMDX_SUBJECT_CODE"

    .line 546
    invoke-virtual {p1, v0, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string p2, "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_SMDX_REASON_CODE"

    .line 548
    invoke-virtual {p1, p2, p0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    goto :goto_1

    :cond_1
    const p0, 0xffffff

    and-int/2addr p0, p2

    const-string p2, "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_ERROR_CODE"

    .line 551
    invoke-virtual {p1, p2, p0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    :goto_1
    return-void
.end method

.method private static awaitResult(Ljava/util/concurrent/CountDownLatch;Ljava/util/concurrent/atomic/AtomicReference;)Ljava/lang/Object;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Ljava/util/concurrent/CountDownLatch;",
            "Ljava/util/concurrent/atomic/AtomicReference<",
            "TT;>;)TT;"
        }
    .end annotation

    .line 1765
    :try_start_0
    invoke-virtual {p0}, Ljava/util/concurrent/CountDownLatch;->await()V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 1767
    :catch_0
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Thread;->interrupt()V

    .line 1769
    :goto_0
    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private blockingGetEidFromEuiccService(I)Ljava/lang/String;
    .locals 4

    .line 1708
    new-instance v0, Ljava/util/concurrent/CountDownLatch;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 1709
    new-instance v1, Ljava/util/concurrent/atomic/AtomicReference;

    invoke-direct {v1}, Ljava/util/concurrent/atomic/AtomicReference;-><init>()V

    .line 1710
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v3, Lcom/android/internal/telephony/euicc/EuiccController$11;

    invoke-direct {v3, p0, v1, v0}, Lcom/android/internal/telephony/euicc/EuiccController$11;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Ljava/util/concurrent/atomic/AtomicReference;Ljava/util/concurrent/CountDownLatch;)V

    invoke-virtual {v2, p1, v3}, Lcom/android/internal/telephony/euicc/EuiccConnector;->getEid(ILcom/android/internal/telephony/euicc/EuiccConnector$GetEidCommandCallback;)V

    .line 1722
    invoke-static {v0, v1}, Lcom/android/internal/telephony/euicc/EuiccController;->awaitResult(Ljava/util/concurrent/CountDownLatch;Ljava/util/concurrent/atomic/AtomicReference;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method private blockingGetEuiccInfoFromEuiccService(I)Landroid/telephony/euicc/EuiccInfo;
    .locals 4

    .line 1746
    new-instance v0, Ljava/util/concurrent/CountDownLatch;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 1747
    new-instance v1, Ljava/util/concurrent/atomic/AtomicReference;

    invoke-direct {v1}, Ljava/util/concurrent/atomic/AtomicReference;-><init>()V

    .line 1748
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v3, Lcom/android/internal/telephony/euicc/EuiccController$13;

    invoke-direct {v3, p0, v1, v0}, Lcom/android/internal/telephony/euicc/EuiccController$13;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Ljava/util/concurrent/atomic/AtomicReference;Ljava/util/concurrent/CountDownLatch;)V

    invoke-virtual {v2, p1, v3}, Lcom/android/internal/telephony/euicc/EuiccConnector;->getEuiccInfo(ILcom/android/internal/telephony/euicc/EuiccConnector$GetEuiccInfoCommandCallback;)V

    .line 1760
    invoke-static {v0, v1}, Lcom/android/internal/telephony/euicc/EuiccController;->awaitResult(Ljava/util/concurrent/CountDownLatch;Ljava/util/concurrent/atomic/AtomicReference;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/euicc/EuiccInfo;

    return-object p0
.end method

.method private blockingGetOtaStatusFromEuiccService(I)I
    .locals 4

    .line 1726
    new-instance v0, Ljava/util/concurrent/CountDownLatch;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 1727
    new-instance v1, Ljava/util/concurrent/atomic/AtomicReference;

    const/4 v2, 0x5

    .line 1728
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/util/concurrent/atomic/AtomicReference;-><init>(Ljava/lang/Object;)V

    .line 1729
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v3, Lcom/android/internal/telephony/euicc/EuiccController$12;

    invoke-direct {v3, p0, v1, v0}, Lcom/android/internal/telephony/euicc/EuiccController$12;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Ljava/util/concurrent/atomic/AtomicReference;Ljava/util/concurrent/CountDownLatch;)V

    invoke-virtual {v2, p1, v3}, Lcom/android/internal/telephony/euicc/EuiccConnector;->getOtaStatus(ILcom/android/internal/telephony/euicc/EuiccConnector$GetOtaStatusCommandCallback;)V

    .line 1741
    invoke-static {v0, v1}, Lcom/android/internal/telephony/euicc/EuiccController;->awaitResult(Ljava/util/concurrent/CountDownLatch;Ljava/util/concurrent/atomic/AtomicReference;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0
.end method

.method private callerCanReadPhoneStatePrivileged()Z
    .locals 1

    .line 1913
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    const-string v0, "android.permission.READ_PRIVILEGED_PHONE_STATE"

    invoke-virtual {p0, v0}, Landroid/content/Context;->checkCallingOrSelfPermission(Ljava/lang/String;)I

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private callerCanWriteEmbeddedSubscriptions()Z
    .locals 1

    .line 1919
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    const-string v0, "android.permission.WRITE_EMBEDDED_SUBSCRIPTIONS"

    invoke-virtual {p0, v0}, Landroid/content/Context;->checkCallingOrSelfPermission(Ljava/lang/String;)I

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private canManageActiveSubscriptionOnTargetSim(ILjava/lang/String;ZI)Z
    .locals 4

    .line 1815
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    const/4 v1, 0x0

    .line 1816
    invoke-virtual {v0, v1}, Landroid/telephony/SubscriptionManager;->getActiveSubscriptionInfoList(Z)Ljava/util/List;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 1817
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    if-nez v2, :cond_0

    goto :goto_0

    .line 1821
    :cond_0
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/SubscriptionInfo;

    const/4 v3, -0x1

    if-eq p1, v3, :cond_2

    .line 1826
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getCardId()I

    move-result v3

    if-ne v3, p1, :cond_1

    .line 1827
    :cond_2
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->isEmbedded()Z

    move-result v3

    if-eqz v3, :cond_1

    if-eqz p3, :cond_3

    .line 1828
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getPortIndex()I

    move-result v3

    if-ne v3, p4, :cond_1

    :cond_3
    iget-object v3, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    .line 1829
    invoke-virtual {v3, v2, p2}, Landroid/telephony/SubscriptionManager;->canManageSubscription(Landroid/telephony/SubscriptionInfo;Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_4
    :goto_0
    return v1
.end method

.method private canManageSubscriptionOnTargetSim(ILjava/lang/String;ZI)Z
    .locals 6

    .line 1847
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    const/4 v1, 0x0

    .line 1848
    invoke-virtual {v0, v1}, Landroid/telephony/SubscriptionManager;->getActiveSubscriptionInfoList(Z)Ljava/util/List;

    move-result-object v0

    if-eqz v0, :cond_c

    .line 1850
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    if-nez v2, :cond_0

    goto/16 :goto_2

    .line 1857
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->supportMultiActiveSlots()Z

    move-result v2

    const/4 v3, 0x1

    if-eqz v2, :cond_a

    .line 1859
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {v2}, Landroid/telephony/TelephonyManager;->getUiccCardsInfo()Ljava/util/List;

    move-result-object v2

    if-eqz v2, :cond_9

    .line 1860
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_1

    goto/16 :goto_1

    .line 1865
    :cond_1
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_2
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_3

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/telephony/UiccCardInfo;

    if-eqz v4, :cond_2

    .line 1866
    invoke-virtual {v4}, Landroid/telephony/UiccCardInfo;->getCardId()I

    move-result v5

    if-ne v5, p1, :cond_2

    invoke-virtual {v4}, Landroid/telephony/UiccCardInfo;->isEuicc()Z

    move-result v5

    if-eqz v5, :cond_2

    .line 1868
    invoke-virtual {v4}, Landroid/telephony/UiccCardInfo;->isMultipleEnabledProfilesSupported()Z

    move-result v2

    move v4, v3

    goto :goto_0

    :cond_3
    move v2, v1

    move v4, v2

    :goto_0
    if-nez v4, :cond_4

    const-string p0, "EuiccController"

    const-string p1, "The target SIM is not an eUICC."

    .line 1873
    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    .line 1880
    :cond_4
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_5
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_7

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/telephony/SubscriptionInfo;

    .line 1885
    invoke-virtual {v4}, Landroid/telephony/SubscriptionInfo;->isEmbedded()Z

    move-result v5

    if-eqz v5, :cond_5

    invoke-virtual {v4}, Landroid/telephony/SubscriptionInfo;->getCardId()I

    move-result v5

    if-ne v5, p1, :cond_5

    if-eqz v2, :cond_6

    if-eqz p3, :cond_6

    .line 1887
    invoke-virtual {v4}, Landroid/telephony/SubscriptionInfo;->getPortIndex()I

    move-result v5

    if-ne v5, p4, :cond_5

    .line 1888
    :cond_6
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    invoke-virtual {p0, v4, p2}, Landroid/telephony/SubscriptionManager;->canManageSubscription(Landroid/telephony/SubscriptionInfo;Ljava/lang/String;)Z

    move-result p0

    return p0

    .line 1894
    :cond_7
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide p3

    .line 1896
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {p0, p2}, Landroid/telephony/TelephonyManager;->checkCarrierPrivilegesForPackageAnyPhone(Ljava/lang/String;)I

    move-result p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-ne p0, v3, :cond_8

    move v1, v3

    .line 1899
    :cond_8
    invoke-static {p3, p4}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return v1

    :catchall_0
    move-exception p0

    invoke-static {p3, p4}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1900
    throw p0

    :cond_9
    :goto_1
    return v1

    .line 1902
    :cond_a
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_b
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p3

    if-eqz p3, :cond_c

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Landroid/telephony/SubscriptionInfo;

    .line 1903
    invoke-virtual {p3}, Landroid/telephony/SubscriptionInfo;->isEmbedded()Z

    move-result p4

    if-eqz p4, :cond_b

    iget-object p4, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    .line 1904
    invoke-virtual {p4, p3, p2}, Landroid/telephony/SubscriptionManager;->canManageSubscription(Landroid/telephony/SubscriptionInfo;Ljava/lang/String;)Z

    move-result p3

    if-eqz p3, :cond_b

    return v3

    :cond_c
    :goto_2
    return v1
.end method

.method private checkCarrierPrivilegeInMetadata(Landroid/telephony/euicc/DownloadableSubscription;Ljava/lang/String;)Z
    .locals 4

    .line 1776
    invoke-virtual {p1}, Landroid/telephony/euicc/DownloadableSubscription;->getAccessRules()Ljava/util/List;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 1778
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v0

    new-array v0, v0, [Landroid/telephony/UiccAccessRule;

    invoke-interface {p1, v0}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Landroid/telephony/UiccAccessRule;

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    const/4 v0, 0x0

    const-string v1, "EuiccController"

    if-nez p1, :cond_1

    const-string p0, "No access rules but caller is unprivileged"

    .line 1781
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    .line 1787
    :cond_1
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mPackageManager:Landroid/content/pm/PackageManager;

    const/high16 v2, 0x8000000

    invoke-virtual {p0, p2, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object p0
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    move p2, v0

    .line 1794
    :goto_1
    array-length v2, p1

    if-ge p2, v2, :cond_3

    .line 1795
    aget-object v2, p1, p2

    invoke-virtual {v2, p0}, Landroid/telephony/UiccAccessRule;->getCarrierPrivilegeStatus(Landroid/content/pm/PackageInfo;)I

    move-result v2

    const/4 v3, 0x1

    if-ne v2, v3, :cond_2

    const-string p0, "Calling package has carrier privilege to this profile"

    .line 1797
    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return v3

    :cond_2
    add-int/lit8 p2, p2, 0x1

    goto :goto_1

    :cond_3
    const-string p0, "Calling package doesn\'t have carrier privilege to this profile"

    .line 1801
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :catch_0
    const-string p0, "Calling package valid but gone"

    .line 1790
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0
.end method

.method public static get()Lcom/android/internal/telephony/euicc/EuiccController;
    .locals 3

    .line 134
    sget-object v0, Lcom/android/internal/telephony/euicc/EuiccController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccController;

    if-nez v0, :cond_1

    .line 135
    const-class v0, Lcom/android/internal/telephony/euicc/EuiccController;

    monitor-enter v0

    .line 136
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/euicc/EuiccController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccController;

    if-eqz v1, :cond_0

    .line 139
    monitor-exit v0

    goto :goto_0

    .line 137
    :cond_0
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "get() called before init()"

    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1

    :catchall_0
    move-exception v1

    .line 139
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 141
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/euicc/EuiccController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccController;

    return-object v0
.end method

.method private getNextAvailableInActivePortIndex(Lcom/android/internal/telephony/uicc/UiccSlot;)I
    .locals 4

    if-eqz p1, :cond_1

    .line 1295
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortList()[I

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget v2, p0, v1

    .line 1296
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/uicc/UiccSlot;->isPortActive(I)Z

    move-result v3

    if-nez v3, :cond_0

    return v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method private getRemovableNonEuiccSlot()Lcom/android/internal/telephony/uicc/UiccSlot;
    .locals 2

    .line 1345
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlots()[Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p0

    if-eqz p0, :cond_1

    const/4 v0, 0x0

    .line 1347
    :goto_0
    array-length v1, p0

    if-ge v0, v1, :cond_1

    .line 1348
    aget-object v1, p0, v0

    if-eqz v1, :cond_0

    invoke-virtual {v1}, Lcom/android/internal/telephony/uicc/UiccSlot;->isRemovable()Z

    move-result v1

    if-eqz v1, :cond_0

    aget-object v1, p0, v0

    .line 1349
    invoke-virtual {v1}, Lcom/android/internal/telephony/uicc/UiccSlot;->isEuicc()Z

    move-result v1

    if-nez v1, :cond_0

    .line 1350
    aget-object p0, p0, v0

    return-object p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private getResolvedPortIndexForDisableSubscription(ILjava/lang/String;Z)I
    .locals 4

    .line 1152
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    const/4 v1, 0x0

    .line 1153
    invoke-virtual {v0, v1}, Landroid/telephony/SubscriptionManager;->getActiveSubscriptionInfoList(Z)Ljava/util/List;

    move-result-object v0

    const/4 v1, -0x1

    if-eqz v0, :cond_4

    .line 1154
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    if-nez v2, :cond_0

    goto :goto_0

    .line 1159
    :cond_0
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/SubscriptionInfo;

    if-eq p1, v1, :cond_2

    .line 1164
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getCardId()I

    move-result v3

    if-ne v3, p1, :cond_1

    .line 1165
    :cond_2
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->isEmbedded()Z

    move-result v3

    if-eqz v3, :cond_1

    if-nez p3, :cond_3

    iget-object v3, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    .line 1167
    invoke-virtual {v3, v2, p2}, Landroid/telephony/SubscriptionManager;->canManageSubscription(Landroid/telephony/SubscriptionInfo;Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 1168
    :cond_3
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getPortIndex()I

    move-result p0

    return p0

    :cond_4
    :goto_0
    return v1
.end method

.method private getResolvedPortIndexForSubscriptionSwitch(I)I
    .locals 9

    .line 1179
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccController;->getSlotIndexFromCardId(I)I

    move-result p1

    .line 1181
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlot(I)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object v0

    const-string v1, "EuiccController"

    const/4 v2, 0x0

    if-nez v0, :cond_0

    .line 1184
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Switch to inactive slot, return default port index. slotIndex: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 1188
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccSlot;->isMultipleEnabledProfileSupported()Z

    move-result p1

    if-nez p1, :cond_1

    const-string p0, "Multiple enabled profiles is not supported, return default port index"

    .line 1189
    invoke-static {v1, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return v2

    .line 1192
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->getRemovableNonEuiccSlot()Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p1

    const/4 v1, 0x1

    if-eqz p1, :cond_2

    .line 1193
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->getRemovableNonEuiccSlot()Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/UiccSlot;->isActive()Z

    move-result p1

    if-eqz p1, :cond_2

    move p1, v1

    goto :goto_0

    :cond_2
    move p1, v2

    .line 1194
    :goto_0
    iget-object v3, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {v3}, Landroid/telephony/TelephonyManager;->getActiveModemCount()I

    move-result v3

    if-ne v3, v1, :cond_5

    if-eqz p1, :cond_3

    return v2

    .line 1207
    :cond_3
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortList()[I

    move-result-object p0

    array-length p1, p0

    :goto_1
    if-ge v2, p1, :cond_a

    aget v1, p0, v2

    .line 1208
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccSlot;->isPortActive(I)Z

    move-result v3

    if-eqz v3, :cond_4

    return v1

    :cond_4
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 1214
    :cond_5
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortList()[I

    move-result-object v3

    array-length v4, v3

    move v5, v2

    :goto_2
    if-ge v5, v4, :cond_8

    aget v6, v3, v5

    .line 1215
    invoke-virtual {v0, v6}, Lcom/android/internal/telephony/uicc/UiccSlot;->isPortActive(I)Z

    move-result v7

    if-eqz v7, :cond_7

    .line 1216
    iget-object v7, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    .line 1218
    invoke-virtual {v0, v6}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPhoneIdFromPortIndex(I)I

    move-result v8

    .line 1217
    invoke-virtual {v7, v8}, Landroid/telephony/SubscriptionManager;->getActiveSubscriptionInfoForSimSlotIndex(I)Landroid/telephony/SubscriptionInfo;

    move-result-object v7

    if-eqz v7, :cond_6

    .line 1219
    invoke-virtual {v7}, Landroid/telephony/SubscriptionInfo;->isOpportunistic()Z

    move-result v7

    if-eqz v7, :cond_7

    :cond_6
    return v6

    :cond_7
    add-int/lit8 v5, v5, 0x1

    goto :goto_2

    :cond_8
    if-eqz p1, :cond_9

    .line 1226
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->isRemovalNonEuiccSlotHasActiveSubscription()Z

    move-result p1

    if-nez p1, :cond_9

    move v2, v1

    :cond_9
    if-eqz v2, :cond_a

    .line 1232
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/euicc/EuiccController;->getNextAvailableInActivePortIndex(Lcom/android/internal/telephony/uicc/UiccSlot;)I

    move-result p0

    return p0

    :cond_a
    const/4 p0, -0x1

    return p0
.end method

.method private getSlotIndexFromCardId(I)I
    .locals 6

    .line 1308
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getUiccSlotsInfo()[Landroid/telephony/UiccSlotInfo;

    move-result-object p0

    const/4 v0, -0x1

    const-string v1, "EuiccController"

    if-eqz p0, :cond_5

    .line 1309
    array-length v2, p0

    if-nez v2, :cond_0

    goto :goto_2

    .line 1313
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object v2

    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/uicc/UiccController;->convertToCardString(I)Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    .line 1314
    :goto_0
    array-length v4, p0

    if-ge v3, v4, :cond_4

    .line 1315
    aget-object v4, p0, v3

    if-nez v4, :cond_1

    const-string v4, "e9517acf-e1a1-455f-9231-1b5515a0d0eb"

    .line 1317
    invoke-static {v4}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v4

    const-string v5, "EuiccController: Found UiccSlotInfo Null object."

    .line 1316
    invoke-static {v4, v5}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;)V

    .line 1320
    :cond_1
    aget-object v4, p0, v3

    if-eqz v4, :cond_2

    .line 1321
    invoke-virtual {v4}, Landroid/telephony/UiccSlotInfo;->getCardId()Ljava/lang/String;

    move-result-object v4

    goto :goto_1

    :cond_2
    const/4 v4, 0x0

    .line 1322
    :goto_1
    invoke-static {v2, v4}, Lcom/android/internal/telephony/uicc/IccUtils;->compareIgnoreTrailingFs(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_3

    return v3

    :cond_3
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 1326
    :cond_4
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "No UiccSlotInfo found for cardId: "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :cond_5
    :goto_2
    const-string p0, "UiccSlotInfo is null or empty"

    .line 1310
    invoke-static {v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0
.end method

.method private getSubscriptionForSubscriptionId(I)Landroid/telephony/SubscriptionInfo;
    .locals 4

    .line 1695
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    invoke-virtual {p0}, Landroid/telephony/SubscriptionManager;->getAvailableSubscriptionInfoList()Ljava/util/List;

    move-result-object p0

    const/4 v0, 0x0

    if-eqz p0, :cond_0

    .line 1696
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v1

    goto :goto_0

    :cond_0
    move v1, v0

    :goto_0
    if-ge v0, v1, :cond_2

    .line 1698
    invoke-interface {p0, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/SubscriptionInfo;

    .line 1699
    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v3

    if-ne p1, v3, :cond_1

    return-object v2

    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    return-object p0
.end method

.method public static init(Landroid/content/Context;)Lcom/android/internal/telephony/euicc/EuiccController;
    .locals 3

    .line 122
    const-class v0, Lcom/android/internal/telephony/euicc/EuiccController;

    monitor-enter v0

    .line 123
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/euicc/EuiccController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccController;

    if-nez v1, :cond_0

    .line 124
    new-instance v1, Lcom/android/internal/telephony/euicc/EuiccController;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/euicc/EuiccController;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/android/internal/telephony/euicc/EuiccController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccController;

    goto :goto_0

    :cond_0
    const-string p0, "EuiccController"

    .line 126
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "init() called multiple times! sInstance = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v2, Lcom/android/internal/telephony/euicc/EuiccController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccController;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {p0, v1}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    .line 128
    :goto_0
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 129
    sget-object p0, Lcom/android/internal/telephony/euicc/EuiccController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccController;

    return-object p0

    :catchall_0
    move-exception p0

    .line 128
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private isEsimSupportedCountry(Ljava/lang/String;)Z
    .locals 1

    .line 373
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSupportedCountries:Ljava/util/List;

    if-eqz v0, :cond_1

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 376
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSupportedCountries:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x1

    return p0
.end method

.method private isEsimUnsupportedCountry(Ljava/lang/String;)Z
    .locals 1

    .line 380
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mUnsupportedCountries:Ljava/util/List;

    if-eqz v0, :cond_1

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 383
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mUnsupportedCountries:Ljava/util/List;

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method private isRemovalNonEuiccSlotHasActiveSubscription()Z
    .locals 7

    .line 1331
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->getRemovableNonEuiccSlot()Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 1333
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortList()[I

    move-result-object v2

    array-length v3, v2

    move v4, v1

    :goto_0
    if-ge v4, v3, :cond_1

    aget v5, v2, v4

    .line 1334
    invoke-virtual {v0, v5}, Lcom/android/internal/telephony/uicc/UiccSlot;->isPortActive(I)Z

    move-result v6

    if-eqz v6, :cond_0

    iget-object v6, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    .line 1336
    invoke-virtual {v0, v5}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPhoneIdFromPortIndex(I)I

    move-result v5

    .line 1335
    invoke-virtual {v6, v5}, Landroid/telephony/SubscriptionManager;->getActiveSubscriptionInfoForSimSlotIndex(I)Landroid/telephony/SubscriptionInfo;

    move-result-object v5

    if-eqz v5, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_1
    return v1
.end method

.method private isTargetPortIndexValid(II)Z
    .locals 10

    const-string v0, "EuiccController"

    const/4 v1, 0x0

    if-gez p2, :cond_0

    .line 1248
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "Invalid portIndex: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    .line 1251
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccController;->getSlotIndexFromCardId(I)I

    move-result p1

    .line 1252
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object v2

    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlot(I)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p1

    if-eqz p1, :cond_6

    .line 1253
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortList()[I

    move-result-object v2

    array-length v2, v2

    if-eqz v2, :cond_6

    .line 1254
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortList()[I

    move-result-object v2

    array-length v2, v2

    if-lt p2, v2, :cond_1

    goto/16 :goto_2

    .line 1259
    :cond_1
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {v2}, Landroid/telephony/TelephonyManager;->getActiveModemCount()I

    move-result v2

    const-string v3, " , reject the switch request to portIndex "

    const/4 v4, 0x1

    if-ne v2, v4, :cond_3

    .line 1261
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortList()[I

    move-result-object p0

    array-length v2, p0

    move v5, v1

    :goto_0
    if-ge v5, v2, :cond_5

    aget v6, p0, v5

    .line 1262
    invoke-virtual {p1, v6}, Lcom/android/internal/telephony/uicc/UiccSlot;->isPortActive(I)Z

    move-result v7

    if-eqz v7, :cond_2

    if-eq v6, p2, :cond_2

    .line 1265
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "In SS Mode, slot already has active port on portIndex "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    :cond_2
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 1270
    :cond_3
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {v2}, Landroid/telephony/TelephonyManager;->getActiveModemCount()I

    move-result v2

    if-le v2, v4, :cond_5

    .line 1274
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->isRemovalNonEuiccSlotHasActiveSubscription()Z

    move-result v2

    if-eqz v2, :cond_5

    .line 1276
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortList()[I

    move-result-object v2

    array-length v5, v2

    move v6, v1

    :goto_1
    if-ge v6, v5, :cond_5

    aget v7, v2, v6

    .line 1277
    invoke-virtual {p1, v7}, Lcom/android/internal/telephony/uicc/UiccSlot;->isPortActive(I)Z

    move-result v8

    if-eqz v8, :cond_4

    iget-object v8, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    .line 1280
    invoke-virtual {p1, v7}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPhoneIdFromPortIndex(I)I

    move-result v9

    .line 1279
    invoke-virtual {v8, v9}, Landroid/telephony/SubscriptionManager;->getActiveSubscriptionInfoForSimSlotIndex(I)Landroid/telephony/SubscriptionInfo;

    move-result-object v8

    if-nez v8, :cond_4

    if-eq v7, p2, :cond_4

    .line 1282
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "In DSDS Mode, pSim has active subscription, eSim has empty active port on portIndex "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    :cond_4
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    :cond_5
    return v4

    :cond_6
    :goto_2
    const-string p0, "Invalid portIndex"

    .line 1255
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1
.end method

.method private synthetic lambda$refreshSubscriptionsAndSendResult$0(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    .locals 0

    .line 1590
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V

    return-void
.end method

.method private supportMultiActiveSlots()Z
    .locals 1

    .line 1806
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getSupportedModemCount()I

    move-result p0

    const/4 v0, 0x1

    if-le p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method


# virtual methods
.method public addResolutionIntent(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;IZLcom/android/internal/telephony/euicc/EuiccOperation;IIZI)V
    .locals 4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
        visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
    .end annotation

    .line 1619
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.telephony.euicc.action.RESOLVE_ERROR"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "com.android.phone"

    .line 1620
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    .line 1621
    new-instance v2, Landroid/content/ComponentName;

    const-string v3, "com.android.phone.euicc.EuiccResolutionUiDispatcherActivity"

    invoke-direct {v2, v1, v3}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v2}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    const-string v1, "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_RESOLUTION_ACTION"

    .line 1623
    invoke-virtual {v0, v1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string p2, "android.service.euicc.extra.RESOLUTION_CALLING_PACKAGE"

    .line 1625
    invoke-virtual {v0, p2, p3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string p2, "android.service.euicc.extra.RESOLVABLE_ERRORS"

    .line 1626
    invoke-virtual {v0, p2, p4}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string p2, "android.service.euicc.extra.RESOLUTION_CARD_ID"

    .line 1627
    invoke-virtual {v0, p2, p7}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string p2, "android.service.euicc.extra.RESOLUTION_SUBSCRIPTION_ID"

    .line 1628
    invoke-virtual {v0, p2, p10}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string p2, "android.service.euicc.extra.RESOLUTION_PORT_INDEX"

    .line 1629
    invoke-virtual {v0, p2, p8}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const-string p2, "android.service.euicc.extra.RESOLUTION_USE_PORT_INDEX"

    .line 1630
    invoke-virtual {v0, p2, p9}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    const-string p2, "android.service.euicc.extra.RESOLUTION_CONFIRMATION_CODE_RETRIED"

    .line 1631
    invoke-virtual {v0, p2, p5}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    const-string p2, "operation"

    .line 1633
    invoke-virtual {v0, p2, p6}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 1634
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    const/4 p2, 0x0

    const/high16 p3, 0x42000000    # 32.0f

    invoke-static {p0, p2, v0, p3}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object p0

    const-string p2, "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_RESOLUTION_INTENT"

    .line 1639
    invoke-virtual {p1, p2, p0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    return-void
.end method

.method public addResolutionIntentWithPort(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;IZLcom/android/internal/telephony/euicc/EuiccOperation;IIZ)V
    .locals 11

    const/4 v10, -0x1

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move v4, p4

    move/from16 v5, p5

    move-object/from16 v6, p6

    move/from16 v7, p7

    move/from16 v8, p8

    move/from16 v9, p9

    .line 1608
    invoke-virtual/range {v0 .. v10}, Lcom/android/internal/telephony/euicc/EuiccController;->addResolutionIntent(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;IZLcom/android/internal/telephony/euicc/EuiccOperation;IIZI)V

    return-void
.end method

.method public blockingGetEuiccProfileInfoList(I)Landroid/service/euicc/GetEuiccProfileInfoListResult;
    .locals 4

    .line 831
    new-instance v0, Ljava/util/concurrent/CountDownLatch;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 832
    new-instance v1, Ljava/util/concurrent/atomic/AtomicReference;

    invoke-direct {v1}, Ljava/util/concurrent/atomic/AtomicReference;-><init>()V

    .line 833
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v3, Lcom/android/internal/telephony/euicc/EuiccController$3;

    invoke-direct {v3, p0, v1, v0}, Lcom/android/internal/telephony/euicc/EuiccController$3;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Ljava/util/concurrent/atomic/AtomicReference;Ljava/util/concurrent/CountDownLatch;)V

    invoke-virtual {v2, p1, v3}, Lcom/android/internal/telephony/euicc/EuiccConnector;->getEuiccProfileInfoList(ILcom/android/internal/telephony/euicc/EuiccConnector$GetEuiccProfileInfoListCommandCallback;)V

    .line 848
    :try_start_0
    invoke-virtual {v0}, Ljava/util/concurrent/CountDownLatch;->await()V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 850
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "blockingGetEuiccInfoFromEuiccService got InterruptedException e: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "EuiccController"

    invoke-static {p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 851
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Thread;->interrupt()V

    .line 853
    :goto_0
    invoke-virtual {v1}, Ljava/util/concurrent/atomic/AtomicReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/service/euicc/GetEuiccProfileInfoListResult;

    return-object p0
.end method

.method public continueOperation(ILandroid/content/Intent;Landroid/os/Bundle;)V
    .locals 6

    const-string v0, "android.service.euicc.extra.RESOLUTION_USE_PORT_INDEX"

    .line 177
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result p0

    if-eqz p0, :cond_1

    .line 181
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v1

    :try_start_0
    const-string p0, "operation"

    .line 183
    invoke-virtual {p2, p0}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/euicc/EuiccOperation;

    if-eqz p0, :cond_0

    const-string v3, "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_RESOLUTION_CALLBACK_INTENT"

    .line 189
    invoke-virtual {p2, v3}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v3

    check-cast v3, Landroid/app/PendingIntent;

    const/4 v4, 0x0

    .line 191
    invoke-virtual {p2, v0, v4}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result p2

    .line 193
    invoke-virtual {p3, v0, p2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    const-string v0, "EuiccController"

    .line 194
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, " continueOperation portIndex: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "android.service.euicc.extra.RESOLUTION_PORT_INDEX"

    invoke-virtual {p3, v5}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " usePortIndex: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v0, p2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 196
    invoke-virtual {p0, p1, p3, v3}, Lcom/android/internal/telephony/euicc/EuiccOperation;->continueOperation(ILandroid/os/Bundle;Landroid/app/PendingIntent;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 198
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    .line 185
    :cond_0
    :try_start_1
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Invalid resolution intent"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :catchall_0
    move-exception p0

    .line 198
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 199
    throw p0

    .line 178
    :cond_1
    new-instance p0, Ljava/lang/SecurityException;

    const-string p1, "Must have WRITE_EMBEDDED_SUBSCRIPTIONS to continue operation"

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method decodeSmdxSubjectAndReasonCode(I)Landroid/util/Pair;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Landroid/util/Pair<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 491
    new-instance p0, Ljava/util/Stack;

    invoke-direct {p0}, Ljava/util/Stack;-><init>()V

    const/4 v0, 0x0

    :goto_0
    const/4 v1, 0x6

    if-ge v0, v1, :cond_0

    and-int/lit8 v1, p1, 0xf

    .line 496
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {p0, v1}, Ljava/util/Stack;->push(Ljava/lang/Object;)Ljava/lang/Object;

    ushr-int/lit8 p1, p1, 0x4

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 500
    :cond_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/util/Stack;->pop()Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, "."

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/util/Stack;->pop()Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/util/Stack;->pop()Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 501
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/util/Stack;->pop()Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/util/Stack;->pop()Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/util/Stack;->pop()Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "^(0\\.)*"

    const-string v1, ""

    .line 504
    invoke-virtual {p1, v0, v1}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 505
    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 507
    invoke-static {p1, p0}, Landroid/util/Pair;->create(Ljava/lang/Object;Ljava/lang/Object;)Landroid/util/Pair;

    move-result-object p0

    return-object p0
.end method

.method public deleteSubscription(IILjava/lang/String;Landroid/app/PendingIntent;)V
    .locals 7

    .line 955
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v0

    .line 956
    iget-object v1, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v2

    invoke-virtual {v1, v2, p3}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    .line 958
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v1

    .line 960
    :try_start_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccController;->getSubscriptionForSubscriptionId(I)Landroid/telephony/SubscriptionInfo;

    move-result-object v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "EuiccController"

    if-nez v3, :cond_0

    .line 962
    :try_start_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Cannot delete nonexistent subscription: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v6, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 963
    invoke-virtual {p0, p4, v5, v4}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 979
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :cond_0
    if-nez v0, :cond_1

    .line 970
    :try_start_2
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    .line 971
    invoke-virtual {v0, v3, p3}, Landroid/telephony/SubscriptionManager;->canManageSubscription(Landroid/telephony/SubscriptionInfo;Ljava/lang/String;)Z

    move-result p3

    if-nez p3, :cond_1

    .line 972
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "No permissions: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v6, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 973
    invoke-virtual {p0, p4, v5, v4}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 979
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    .line 977
    :cond_1
    :try_start_3
    invoke-virtual {v3}, Landroid/telephony/SubscriptionInfo;->getIccId()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p1, p2, p4}, Lcom/android/internal/telephony/euicc/EuiccController;->deleteSubscriptionPrivileged(ILjava/lang/String;Landroid/app/PendingIntent;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 979
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception p0

    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 980
    throw p0
.end method

.method deleteSubscriptionPrivileged(ILjava/lang/String;Landroid/app/PendingIntent;)V
    .locals 2

    .line 985
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v1, Lcom/android/internal/telephony/euicc/EuiccController$4;

    invoke-direct {v1, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccController$4;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/app/PendingIntent;)V

    invoke-virtual {v0, p1, p2, v1}, Lcom/android/internal/telephony/euicc/EuiccConnector;->deleteSubscription(ILjava/lang/String;Lcom/android/internal/telephony/euicc/EuiccConnector$DeleteCommandCallback;)V

    return-void
.end method

.method downloadSubscription(IILandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;ZLandroid/os/Bundle;Landroid/app/PendingIntent;)V
    .locals 20

    move-object/from16 v0, p0

    move/from16 v12, p1

    move-object/from16 v13, p3

    move/from16 v10, p4

    move-object/from16 v9, p5

    move/from16 v14, p6

    const-string v1, "EuiccController"

    .line 558
    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v2

    .line 559
    iget-object v3, v0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v4

    invoke-virtual {v3, v4, v9}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    const-wide/32 v3, 0xd628eb8

    .line 562
    invoke-virtual {v0, v9, v3, v4}, Lcom/android/internal/telephony/euicc/EuiccController;->isCompatChangeEnabled(Ljava/lang/String;J)Z

    move-result v3

    .line 565
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v7

    const/4 v11, 0x1

    const/4 v4, 0x0

    if-eqz v10, :cond_1

    const/4 v5, -0x1

    move/from16 v6, p2

    if-ne v6, v5, :cond_2

    if-eqz v3, :cond_0

    .line 571
    :try_start_0
    invoke-direct/range {p0 .. p1}, Lcom/android/internal/telephony/euicc/EuiccController;->getResolvedPortIndexForSubscriptionSwitch(I)I

    move-result v6

    goto :goto_0

    :cond_0
    move v6, v4

    :goto_0
    if-ne v6, v5, :cond_2

    move v4, v11

    goto :goto_1

    :cond_1
    move/from16 v6, p2

    :cond_2
    :goto_1
    move v15, v6

    .line 576
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, " downloadSubscription cardId: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " switchAfterDownload: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v6, " portIndex: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v15}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " forceDeactivateSim: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v14}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v6, " callingPackage: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " isConsentNeededToResolvePortIndex: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v6, " shouldResolvePortIndex:"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_3

    if-nez v4, :cond_3

    if-eqz v2, :cond_3

    move-object/from16 v1, p0

    move/from16 v2, p1

    move v3, v15

    move-wide v4, v7

    move-object/from16 v6, p3

    move-wide v12, v7

    move/from16 v7, p4

    move/from16 v8, p6

    move-object/from16 v9, p5

    move-object/from16 v10, p7

    move-object/from16 v11, p8

    .line 585
    :try_start_1
    invoke-virtual/range {v1 .. v11}, Lcom/android/internal/telephony/euicc/EuiccController;->downloadSubscriptionPrivileged(IIJLandroid/telephony/euicc/DownloadableSubscription;ZZLjava/lang/String;Landroid/os/Bundle;Landroid/app/PendingIntent;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 625
    invoke-static {v12, v13}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception v0

    move-wide/from16 v16, v12

    goto/16 :goto_3

    :cond_3
    if-nez v4, :cond_4

    .line 602
    :try_start_2
    invoke-direct {v0, v12, v9, v11, v15}, Lcom/android/internal/telephony/euicc/EuiccController;->canManageSubscriptionOnTargetSim(ILjava/lang/String;ZI)Z

    move-result v2

    if-eqz v2, :cond_4

    .line 604
    iget-object v11, v0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v6, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_3

    const/16 v16, 0x0

    move-object v1, v6

    move-object/from16 v2, p0

    move-wide v3, v7

    move-object/from16 v5, p3

    move-object v0, v6

    move/from16 v6, p4

    move-wide/from16 v17, v7

    move-object/from16 v7, p5

    move/from16 v8, p6

    move-object/from16 v9, p8

    move/from16 v10, v16

    move-object/from16 v19, v11

    move v11, v15

    :try_start_3
    invoke-direct/range {v1 .. v11}, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;JLandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;ZLandroid/app/PendingIntent;ZI)V

    move-object/from16 v1, v19

    invoke-virtual {v1, v12, v13, v14, v0}, Lcom/android/internal/telephony/euicc/EuiccConnector;->getDownloadableSubscriptionMetadata(ILandroid/telephony/euicc/DownloadableSubscription;ZLcom/android/internal/telephony/euicc/EuiccConnector$GetMetadataCommandCallback;)V

    move-wide/from16 v16, v17

    goto :goto_2

    :cond_4
    move-wide/from16 v17, v7

    const-string v2, "Caller can\'t manage subscription on target SIM or  User consent is required for resolving port index. Ask user\'s consent first"

    .line 610
    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 613
    new-instance v14, Landroid/content/Intent;

    invoke-direct {v14}, Landroid/content/Intent;-><init>()V

    const-string v3, "android.service.euicc.action.RESOLVE_NO_PRIVILEGES"
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    const/4 v5, 0x0

    const/4 v6, 0x0

    move-wide/from16 v7, v17

    .line 619
    :try_start_4
    invoke-static {v7, v8, v13, v10, v9}, Lcom/android/internal/telephony/euicc/EuiccOperation;->forDownloadNoPrivilegesOrDeactivateSimCheckMetadata(JLandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;)Lcom/android/internal/telephony/euicc/EuiccOperation;

    move-result-object v13
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_3

    move-object/from16 v1, p0

    move-object v2, v14

    move-object/from16 v4, p5

    move-wide/from16 v16, v7

    move-object v7, v13

    move/from16 v8, p1

    move v9, v15

    move/from16 v10, p4

    .line 614
    :try_start_5
    invoke-virtual/range {v1 .. v10}, Lcom/android/internal/telephony/euicc/EuiccController;->addResolutionIntentWithPort(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;IZLcom/android/internal/telephony/euicc/EuiccOperation;IIZ)V

    move-object/from16 v1, p8

    .line 622
    invoke-virtual {v0, v1, v11, v14}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    .line 625
    :goto_2
    invoke-static/range {v16 .. v17}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_1
    move-exception v0

    goto :goto_3

    :catchall_2
    move-exception v0

    move-wide/from16 v16, v17

    goto :goto_3

    :catchall_3
    move-exception v0

    move-wide/from16 v16, v7

    :goto_3
    invoke-static/range {v16 .. v17}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 626
    throw v0
.end method

.method public downloadSubscription(ILandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;Landroid/os/Bundle;Landroid/app/PendingIntent;)V
    .locals 9

    if-eqz p3, :cond_0

    const/4 v0, -0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    move v2, v0

    const/4 v6, 0x0

    move-object v0, p0

    move v1, p1

    move-object v3, p2

    move v4, p3

    move-object v5, p4

    move-object v7, p5

    move-object v8, p6

    .line 471
    invoke-virtual/range {v0 .. v8}, Lcom/android/internal/telephony/euicc/EuiccController;->downloadSubscription(IILandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;ZLandroid/os/Bundle;Landroid/app/PendingIntent;)V

    return-void
.end method

.method downloadSubscriptionPrivileged(IIJLandroid/telephony/euicc/DownloadableSubscription;ZZLjava/lang/String;Landroid/os/Bundle;Landroid/app/PendingIntent;)V
    .locals 12

    move-object v1, p0

    .line 727
    iget-object v10, v1, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v11, Lcom/android/internal/telephony/euicc/EuiccController$2;

    move-object v0, v11

    move-object/from16 v2, p5

    move/from16 v3, p6

    move-object/from16 v4, p10

    move-object/from16 v5, p8

    move-wide v6, p3

    move v8, p1

    move v9, p2

    invoke-direct/range {v0 .. v9}, Lcom/android/internal/telephony/euicc/EuiccController$2;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/telephony/euicc/DownloadableSubscription;ZLandroid/app/PendingIntent;Ljava/lang/String;JII)V

    move-object v0, v10

    move v1, p1

    move v2, p2

    move-object/from16 v3, p5

    move/from16 v4, p6

    move/from16 v5, p7

    move-object/from16 v6, p9

    move-object v7, v11

    invoke-virtual/range {v0 .. v7}, Lcom/android/internal/telephony/euicc/EuiccConnector;->downloadSubscription(IILandroid/telephony/euicc/DownloadableSubscription;ZZLandroid/os/Bundle;Lcom/android/internal/telephony/euicc/EuiccConnector$DownloadCommandCallback;)V

    return-void
.end method

.method downloadSubscriptionPrivilegedCheckMetadata(IIJLandroid/telephony/euicc/DownloadableSubscription;ZZLjava/lang/String;Landroid/os/Bundle;Landroid/app/PendingIntent;)V
    .locals 15

    move/from16 v0, p1

    move/from16 v12, p7

    .line 713
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, " downloadSubscriptionPrivilegedCheckMetadata cardId: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " switchAfterDownload: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v6, p6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " portIndex: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v11, p2

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " forceDeactivateSim: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v12}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "EuiccController"

    invoke-static {v2, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    move-object v2, p0

    .line 716
    iget-object v13, v2, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v14, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;

    const/4 v10, 0x1

    move-object v1, v14

    move-wide/from16 v3, p3

    move-object/from16 v5, p5

    move-object/from16 v7, p8

    move/from16 v8, p7

    move-object/from16 v9, p10

    invoke-direct/range {v1 .. v11}, Lcom/android/internal/telephony/euicc/EuiccController$DownloadSubscriptionGetMetadataCommandCallback;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;JLandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;ZLandroid/app/PendingIntent;ZI)V

    move-object/from16 v1, p5

    invoke-virtual {v13, v0, v1, v12, v14}, Lcom/android/internal/telephony/euicc/EuiccConnector;->getDownloadableSubscriptionMetadata(ILandroid/telephony/euicc/DownloadableSubscription;ZLcom/android/internal/telephony/euicc/EuiccConnector$GetMetadataCommandCallback;)V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 5

    const-string v0, "===== END EUICC CLINIC ====="

    .line 1645
    iget-object v1, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    const-string v2, "android.permission.DUMP"

    const-string v3, "Requires DUMP"

    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    .line 1646
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v1

    const-string v3, "===== BEGIN EUICC CLINIC ====="

    .line 1647
    invoke-virtual {p2, v3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    :try_start_0
    const-string v3, "===== EUICC CONNECTOR ====="

    .line 1649
    invoke-virtual {p2, v3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1650
    iget-object v3, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    invoke-virtual {v3, p1, p2, p3}, Lcom/android/internal/telephony/euicc/EuiccConnector;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1651
    new-instance p1, Ljava/util/concurrent/CountDownLatch;

    const/4 p3, 0x1

    invoke-direct {p1, p3}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 1652
    iget-object p3, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v3, Lcom/android/internal/telephony/euicc/EuiccController$10;

    invoke-direct {v3, p0, p2, p1}, Lcom/android/internal/telephony/euicc/EuiccController$10;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Ljava/io/PrintWriter;Ljava/util/concurrent/CountDownLatch;)V

    invoke-virtual {p3, v3}, Lcom/android/internal/telephony/euicc/EuiccConnector;->dumpEuiccService(Lcom/android/internal/telephony/euicc/EuiccConnector$DumpEuiccServiceCommandCallback;)V

    const-wide/16 v3, 0x5

    .line 1668
    sget-object p0, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-virtual {p1, v3, v4, p0}, Ljava/util/concurrent/CountDownLatch;->await(JLjava/util/concurrent/TimeUnit;)Z

    move-result p0

    if-nez p0, :cond_0

    const-string p0, "===== EUICC SERVICE TIMEOUT ====="

    .line 1669
    invoke-virtual {p2, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception p0

    goto :goto_1

    :catch_0
    :try_start_1
    const-string p0, "===== EUICC SERVICE INTERRUPTED ====="

    .line 1672
    invoke-virtual {p2, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1674
    :cond_0
    :goto_0
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1675
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    .line 1674
    :goto_1
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1675
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1676
    throw p0
.end method

.method public eraseSubscriptions(ILandroid/app/PendingIntent;)V
    .locals 4

    .line 1472
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1476
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 1478
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v3, Lcom/android/internal/telephony/euicc/EuiccController$7;

    invoke-direct {v3, p0, p2}, Lcom/android/internal/telephony/euicc/EuiccController$7;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/app/PendingIntent;)V

    invoke-virtual {v2, p1, v3}, Lcom/android/internal/telephony/euicc/EuiccConnector;->eraseSubscriptions(ILcom/android/internal/telephony/euicc/EuiccConnector$EraseCommandCallback;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1505
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1506
    throw p0

    .line 1473
    :cond_0
    new-instance p0, Ljava/lang/SecurityException;

    const-string p1, "Must have WRITE_EMBEDDED_SUBSCRIPTIONS to erase subscriptions"

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public eraseSubscriptionsWithOptions(IILandroid/app/PendingIntent;)V
    .locals 4

    .line 1512
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1516
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 1518
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v3, Lcom/android/internal/telephony/euicc/EuiccController$8;

    invoke-direct {v3, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccController$8;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/app/PendingIntent;)V

    invoke-virtual {v2, p1, p2, v3}, Lcom/android/internal/telephony/euicc/EuiccConnector;->eraseSubscriptionsWithOptions(IILcom/android/internal/telephony/euicc/EuiccConnector$EraseCommandCallback;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1545
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1546
    throw p0

    .line 1513
    :cond_0
    new-instance p0, Ljava/lang/SecurityException;

    const-string p1, "Must have WRITE_EMBEDDED_SUBSCRIPTIONS to erase subscriptions"

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public getDefaultDownloadableSubscriptionList(ILjava/lang/String;Landroid/app/PendingIntent;)V
    .locals 1

    const/4 v0, 0x0

    .line 859
    invoke-virtual {p0, p1, v0, p2, p3}, Lcom/android/internal/telephony/euicc/EuiccController;->getDefaultDownloadableSubscriptionList(IZLjava/lang/String;Landroid/app/PendingIntent;)V

    return-void
.end method

.method getDefaultDownloadableSubscriptionList(IZLjava/lang/String;Landroid/app/PendingIntent;)V
    .locals 10

    .line 865
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 869
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v1

    invoke-virtual {v0, v1, p3}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    .line 870
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 872
    :try_start_0
    iget-object v8, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v9, Lcom/android/internal/telephony/euicc/EuiccController$GetDefaultListCommandCallback;

    move-object v2, v9

    move-object v3, p0

    move-wide v4, v0

    move-object v6, p3

    move-object v7, p4

    invoke-direct/range {v2 .. v7}, Lcom/android/internal/telephony/euicc/EuiccController$GetDefaultListCommandCallback;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;JLjava/lang/String;Landroid/app/PendingIntent;)V

    invoke-virtual {v8, p1, p2, v9}, Lcom/android/internal/telephony/euicc/EuiccConnector;->getDefaultDownloadableSubscriptionList(IZLcom/android/internal/telephony/euicc/EuiccConnector$GetDefaultListCommandCallback;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 876
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 877
    throw p0

    .line 866
    :cond_0
    new-instance p0, Ljava/lang/SecurityException;

    const-string p1, "Must have WRITE_EMBEDDED_SUBSCRIPTIONS to get default list"

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public getDownloadableSubscriptionMetadata(ILandroid/telephony/euicc/DownloadableSubscription;Ljava/lang/String;Landroid/app/PendingIntent;)V
    .locals 6

    const/4 v3, 0x0

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v4, p3

    move-object v5, p4

    .line 287
    invoke-virtual/range {v0 .. v5}, Lcom/android/internal/telephony/euicc/EuiccController;->getDownloadableSubscriptionMetadata(ILandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;Landroid/app/PendingIntent;)V

    return-void
.end method

.method getDownloadableSubscriptionMetadata(ILandroid/telephony/euicc/DownloadableSubscription;ZLjava/lang/String;Landroid/app/PendingIntent;)V
    .locals 12

    move-object v0, p0

    .line 388
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 391
    iget-object v1, v0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v2

    move-object/from16 v6, p4

    invoke-virtual {v1, v2, v6}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    .line 392
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v8

    .line 394
    :try_start_0
    iget-object v10, v0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v11, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;

    move-object v1, v11

    move-object v2, p0

    move-wide v3, v8

    move-object v5, p2

    move-object/from16 v6, p4

    move-object/from16 v7, p5

    invoke-direct/range {v1 .. v7}, Lcom/android/internal/telephony/euicc/EuiccController$GetMetadataCommandCallback;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;JLandroid/telephony/euicc/DownloadableSubscription;Ljava/lang/String;Landroid/app/PendingIntent;)V

    move v0, p1

    move-object v1, p2

    move v2, p3

    invoke-virtual {v10, p1, p2, p3, v11}, Lcom/android/internal/telephony/euicc/EuiccConnector;->getDownloadableSubscriptionMetadata(ILandroid/telephony/euicc/DownloadableSubscription;ZLcom/android/internal/telephony/euicc/EuiccConnector$GetMetadataCommandCallback;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 399
    invoke-static {v8, v9}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception v0

    invoke-static {v8, v9}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 400
    throw v0

    .line 389
    :cond_0
    new-instance v0, Ljava/lang/SecurityException;

    const-string v1, "Must have WRITE_EMBEDDED_SUBSCRIPTIONS to get metadata"

    invoke-direct {v0, v1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public getEid(ILjava/lang/String;)Ljava/lang/String;
    .locals 5

    .line 211
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanReadPhoneStatePrivileged()Z

    move-result v0

    const/4 v1, -0x1

    const/4 v2, 0x0

    .line 213
    :try_start_0
    iget-object v3, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v4

    invoke-virtual {v3, v4, p2}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0

    .line 218
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v3

    if-nez v0, :cond_1

    .line 221
    :try_start_1
    invoke-direct {p0, p1, p2, v2, v1}, Lcom/android/internal/telephony/euicc/EuiccController;->canManageSubscriptionOnTargetSim(ILjava/lang/String;ZI)Z

    move-result p2

    if-eqz p2, :cond_0

    goto :goto_0

    .line 223
    :cond_0
    new-instance p0, Ljava/lang/SecurityException;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Must have carrier privileges on subscription to read EID for cardId="

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 228
    :cond_1
    :goto_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccController;->blockingGetEidFromEuiccService(I)Ljava/lang/String;

    move-result-object p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 230
    invoke-static {v3, v4}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-object p0

    :catchall_0
    move-exception p0

    invoke-static {v3, v4}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 231
    throw p0

    :catch_0
    move-exception p0

    const p1, 0x534e4554

    const/4 p2, 0x3

    new-array p2, p2, [Ljava/lang/Object;

    const-string v0, "159062405"

    aput-object v0, p2, v2

    const/4 v0, 0x1

    .line 215
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, p2, v0

    const/4 v0, 0x2

    const-string v1, "Missing UID checking"

    aput-object v1, p2, v0

    invoke-static {p1, p2}, Landroid/util/EventLog;->writeEvent(I[Ljava/lang/Object;)I

    .line 216
    throw p0
.end method

.method public getEuiccInfo(I)Landroid/telephony/euicc/EuiccInfo;
    .locals 2

    .line 944
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 946
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccController;->blockingGetEuiccInfoFromEuiccService(I)Landroid/telephony/euicc/EuiccInfo;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 948
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-object p0

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 949
    throw p0
.end method

.method public getOtaStatus(I)I
    .locals 2

    .line 242
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 245
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 247
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccController;->blockingGetOtaStatusFromEuiccService(I)I

    move-result p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 249
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return p0

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 250
    throw p0

    .line 243
    :cond_0
    new-instance p0, Ljava/lang/SecurityException;

    const-string p1, "Must have WRITE_EMBEDDED_SUBSCRIPTIONS to get OTA status"

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public getSupportedCountries(Z)Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(Z)",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 329
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v0

    if-eqz v0, :cond_2

    if-eqz p1, :cond_0

    .line 333
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSupportedCountries:Ljava/util/List;

    if-eqz v0, :cond_0

    return-object v0

    :cond_0
    if-nez p1, :cond_1

    .line 335
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mUnsupportedCountries:Ljava/util/List;

    if-eqz p0, :cond_1

    return-object p0

    .line 338
    :cond_1
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object p0

    return-object p0

    .line 330
    :cond_2
    new-instance p0, Ljava/lang/SecurityException;

    const-string p1, "Must have WRITE_EMBEDDED_SUBSCRIPTIONS to get supported countries"

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public hasCarrierPrivilegesForPackageOnAnyPhone(Ljava/lang/String;)Z
    .locals 2

    .line 1985
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v1

    invoke-virtual {v0, v1, p1}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    .line 1986
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 1990
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {p0, p1}, Landroid/telephony/TelephonyManager;->checkCarrierPrivilegesForPackageAnyPhone(Ljava/lang/String;)I

    move-result p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 p1, 0x1

    if-ne p0, p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 1993
    :goto_0
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return p1

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1994
    throw p0
.end method

.method public isCompatChangeEnabled(Ljava/lang/String;J)Z
    .locals 1

    .line 1999
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v0

    invoke-virtual {p0, v0, p1}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    .line 2003
    invoke-static {}, Landroid/os/Binder;->getCallingUserHandle()Landroid/os/UserHandle;

    move-result-object p0

    .line 2002
    invoke-static {p2, p3, p1, p0}, Landroid/app/compat/CompatChanges;->isChangeEnabled(JLjava/lang/String;Landroid/os/UserHandle;)Z

    move-result p0

    .line 2004
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "isCompatChangeEnabled changeId: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p2, " changeEnabled: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "EuiccController"

    invoke-static {p2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return p0
.end method

.method public isSimPortAvailable(IILjava/lang/String;)Z
    .locals 5

    .line 1927
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 1929
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getUiccCardsInfo()Ljava/util/List;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1931
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1933
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_a

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/UiccCardInfo;

    if-eqz v0, :cond_0

    .line 1934
    invoke-virtual {v0}, Landroid/telephony/UiccCardInfo;->getCardId()I

    move-result v2

    if-eq v2, p1, :cond_1

    goto :goto_0

    .line 1939
    :cond_1
    invoke-virtual {v0}, Landroid/telephony/UiccCardInfo;->isEuicc()Z

    move-result v2

    if-eqz v2, :cond_a

    const/4 v2, -0x1

    if-eq p2, v2, :cond_a

    .line 1940
    invoke-virtual {v0}, Landroid/telephony/UiccCardInfo;->getPorts()Ljava/util/Collection;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Collection;->size()I

    move-result v2

    if-lt p2, v2, :cond_2

    goto/16 :goto_2

    .line 1943
    :cond_2
    invoke-virtual {v0}, Landroid/telephony/UiccCardInfo;->getPorts()Ljava/util/Collection;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_3
    :goto_1
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_0

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/UiccPortInfo;

    if-eqz v3, :cond_3

    .line 1944
    invoke-virtual {v3}, Landroid/telephony/UiccPortInfo;->getPortIndex()I

    move-result v4

    if-eq v4, p2, :cond_4

    goto :goto_1

    .line 1948
    :cond_4
    invoke-virtual {v3}, Landroid/telephony/UiccPortInfo;->isActive()Z

    move-result p0

    if-nez p0, :cond_5

    return v1

    .line 1953
    :cond_5
    invoke-virtual {v3}, Landroid/telephony/UiccPortInfo;->getIccId()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    const/4 p1, 0x1

    if-eqz p0, :cond_6

    return p1

    .line 1957
    :cond_6
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object p0

    .line 1958
    invoke-virtual {v0}, Landroid/telephony/UiccCardInfo;->getPhysicalSlotIndex()I

    move-result v0

    .line 1957
    invoke-virtual {p0, v0, p2}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccPortForSlot(II)Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object p0

    if-eqz p0, :cond_7

    .line 1962
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccPort;->getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object p2

    if-eqz p2, :cond_7

    .line 1963
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccPort;->getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->isEmptyProfile()Z

    move-result p0

    if-eqz p0, :cond_7

    return p1

    .line 1966
    :cond_7
    invoke-virtual {v3}, Landroid/telephony/UiccPortInfo;->getLogicalSlotIndex()I

    move-result p0

    invoke-static {p0}, Lcom/android/internal/telephony/PhoneFactory;->getPhone(I)Lcom/android/internal/telephony/Phone;

    move-result-object p0

    const-string p2, "EuiccController"

    if-nez p0, :cond_8

    .line 1968
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "Invalid logical slot: "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Landroid/telephony/UiccPortInfo;->getLogicalSlotIndex()I

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    .line 1971
    :cond_8
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getCarrierPrivilegesTracker()Lcom/android/internal/telephony/CarrierPrivilegesTracker;

    move-result-object p0

    if-nez p0, :cond_9

    const-string p0, "No CarrierPrivilegesTracker"

    .line 1973
    invoke-static {p2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    .line 1976
    :cond_9
    invoke-virtual {p0, p3}, Lcom/android/internal/telephony/CarrierPrivilegesTracker;->getCarrierPrivilegeStatusForPackage(Ljava/lang/String;)I

    move-result p0

    if-ne p0, p1, :cond_a

    move v1, p1

    :cond_a
    :goto_2
    return v1

    :catchall_0
    move-exception p0

    .line 1931
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1932
    throw p0
.end method

.method public isSupportedCountry(Ljava/lang/String;)Z
    .locals 3

    .line 359
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 363
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSupportedCountries:Ljava/util/List;

    const-string v1, "EuiccController"

    if-eqz v0, :cond_1

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 367
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Using allow list supportedCountries="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSupportedCountries:Ljava/util/List;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 368
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccController;->isEsimSupportedCountry(Ljava/lang/String;)Z

    move-result p0

    return p0

    .line 364
    :cond_1
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Using deny list unsupportedCountries="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mUnsupportedCountries:Ljava/util/List;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 365
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccController;->isEsimUnsupportedCountry(Ljava/lang/String;)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0

    .line 360
    :cond_2
    new-instance p0, Ljava/lang/SecurityException;

    const-string p1, "Must have WRITE_EMBEDDED_SUBSCRIPTIONS to check if the country is supported"

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public refreshSubscriptionsAndSendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
        visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
    .end annotation

    .line 1588
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/android/internal/telephony/euicc/EuiccController$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/app/PendingIntent;ILandroid/content/Intent;)V

    .line 1589
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/SubscriptionController;->requestEmbeddedSubscriptionInfoListRefresh(Ljava/lang/Runnable;)V

    return-void
.end method

.method public retainSubscriptionsForFactoryReset(ILandroid/app/PendingIntent;)V
    .locals 4

    .line 1551
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    const-string v1, "android.permission.MASTER_CLEAR"

    const-string v2, "Must have MASTER_CLEAR to retain subscriptions for factory reset"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingPermission(Ljava/lang/String;Ljava/lang/String;)V

    .line 1553
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 1555
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v3, Lcom/android/internal/telephony/euicc/EuiccController$9;

    invoke-direct {v3, p0, p2}, Lcom/android/internal/telephony/euicc/EuiccController$9;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/app/PendingIntent;)V

    invoke-virtual {v2, p1, v3}, Lcom/android/internal/telephony/euicc/EuiccConnector;->retainSubscriptions(ILcom/android/internal/telephony/euicc/EuiccConnector$RetainSubscriptionsCommandCallback;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1580
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception p0

    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1581
    throw p0
.end method

.method public sendOtaStatusChangedBroadcast()V
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
        visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
    .end annotation

    .line 1685
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.telephony.euicc.action.OTA_STATUS_CHANGED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 1686
    iget-object v1, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/euicc/EuiccConnector;->findBestComponent(Landroid/content/pm/PackageManager;)Landroid/content/pm/ComponentInfo;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 1688
    iget-object v1, v1, Landroid/content/pm/ComponentInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    .line 1690
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    const-string v1, "android.permission.WRITE_EMBEDDED_SUBSCRIPTIONS"

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;Ljava/lang/String;)V

    return-void
.end method

.method public sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
        visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
    .end annotation

    .line 1597
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mContext:Landroid/content/Context;

    invoke-virtual {p1, p0, p2, p3}, Landroid/app/PendingIntent;->send(Landroid/content/Context;ILandroid/content/Intent;)V
    :try_end_0
    .catch Landroid/app/PendingIntent$CanceledException; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method

.method public setSupportedCountries(ZLjava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(Z",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 305
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v0

    if-eqz v0, :cond_1

    if-eqz p1, :cond_0

    .line 310
    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSupportedCountries:Ljava/util/List;

    goto :goto_0

    .line 312
    :cond_0
    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mUnsupportedCountries:Ljava/util/List;

    :goto_0
    return-void

    .line 306
    :cond_1
    new-instance p0, Ljava/lang/SecurityException;

    const-string p1, "Must have WRITE_EMBEDDED_SUBSCRIPTIONS to set supported countries"

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public startOtaUpdatingIfNecessary()V
    .locals 1

    .line 264
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getCardIdForDefaultEuicc()I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/euicc/EuiccController;->startOtaUpdatingIfNecessary(I)V

    return-void
.end method

.method public startOtaUpdatingIfNecessary(I)V
    .locals 2

    .line 271
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v1, Lcom/android/internal/telephony/euicc/EuiccController$1;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/euicc/EuiccController$1;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;)V

    invoke-virtual {v0, p1, v1}, Lcom/android/internal/telephony/euicc/EuiccConnector;->startOtaIfNecessary(ILcom/android/internal/telephony/euicc/EuiccConnector$OtaStatusChangedCallback;)V

    return-void
.end method

.method switchToSubscription(IIIZLjava/lang/String;Landroid/app/PendingIntent;Z)V
    .locals 17

    move-object/from16 v0, p0

    move/from16 v8, p1

    move/from16 v11, p2

    move/from16 v1, p3

    move-object/from16 v9, p5

    move-object/from16 v12, p6

    move/from16 v2, p7

    .line 1033
    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v3

    .line 1034
    iget-object v4, v0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v5

    invoke-virtual {v4, v5, v9}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    const-wide/32 v4, 0xd628eb8

    .line 1037
    invoke-virtual {v0, v9, v4, v5}, Lcom/android/internal/telephony/euicc/EuiccController;->isCompatChangeEnabled(Ljava/lang/String;J)Z

    move-result v4

    .line 1039
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, " subId: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " portIndex: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " forceDeactivateSim: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v6, p4

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, " usePortIndex: "

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, " callingPackage: "

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " shouldResolvePortIndex: "

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    const-string v7, "EuiccController"

    invoke-static {v7, v5}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1043
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v13

    if-eqz v3, :cond_0

    const/4 v10, 0x1

    goto :goto_0

    :cond_0
    move v10, v6

    :goto_0
    const/4 v5, -0x1

    const/4 v6, 0x2

    const/4 v15, 0x0

    if-ne v11, v5, :cond_5

    if-nez v2, :cond_2

    .line 1059
    :try_start_0
    invoke-direct {v0, v8, v9, v3}, Lcom/android/internal/telephony/euicc/EuiccController;->getResolvedPortIndexForDisableSubscription(ILjava/lang/String;Z)I

    move-result v1

    if-ne v1, v5, :cond_1

    const-string v1, "Disable is not permitted: no active subscription or cannot manage subscription"

    .line 1062
    invoke-static {v7, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1064
    invoke-virtual {v0, v12, v6, v15}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1142
    invoke-static {v13, v14}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :cond_1
    const/4 v2, 0x1

    :cond_2
    if-nez v3, :cond_4

    .line 1070
    :try_start_1
    invoke-direct {v0, v8, v9, v2, v1}, Lcom/android/internal/telephony/euicc/EuiccController;->canManageActiveSubscriptionOnTargetSim(ILjava/lang/String;ZI)Z

    move-result v3

    if-eqz v3, :cond_3

    goto :goto_1

    :cond_3
    const-string v1, "Not permitted to switch to empty subscription"

    .line 1074
    invoke-static {v7, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1075
    invoke-virtual {v0, v12, v6, v15}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1142
    invoke-static {v13, v14}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :cond_4
    :goto_1
    move/from16 v16, v2

    move-object v7, v15

    const/4 v3, 0x1

    const/4 v6, 0x0

    move v15, v1

    goto/16 :goto_6

    .line 1080
    :cond_5
    :try_start_2
    invoke-direct {v0, v11}, Lcom/android/internal/telephony/euicc/EuiccController;->getSubscriptionForSubscriptionId(I)Landroid/telephony/SubscriptionInfo;

    move-result-object v5

    if-nez v5, :cond_6

    .line 1082
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Cannot switch to nonexistent sub: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v7, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1083
    invoke-virtual {v0, v12, v6, v15}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 1142
    invoke-static {v13, v14}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :cond_6
    if-eqz v3, :cond_7

    :goto_2
    const/4 v3, 0x1

    goto :goto_3

    .line 1089
    :cond_7
    :try_start_3
    iget-object v3, v0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    invoke-virtual {v3, v5, v9}, Landroid/telephony/SubscriptionManager;->canManageSubscription(Landroid/telephony/SubscriptionInfo;Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_8

    .line 1090
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Not permitted to switch to sub: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v7, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1091
    invoke-virtual {v0, v12, v6, v15}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 1142
    invoke-static {v13, v14}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    .line 1095
    :cond_8
    :try_start_4
    invoke-direct {v0, v8, v9, v2, v1}, Lcom/android/internal/telephony/euicc/EuiccController;->canManageSubscriptionOnTargetSim(ILjava/lang/String;ZI)Z

    move-result v3

    if-eqz v3, :cond_9

    goto :goto_2

    :cond_9
    const/4 v3, 0x0

    .line 1100
    :goto_3
    invoke-virtual {v5}, Landroid/telephony/SubscriptionInfo;->getIccId()Ljava/lang/String;

    move-result-object v5

    if-eqz v2, :cond_b

    .line 1102
    invoke-direct {v0, v8, v1}, Lcom/android/internal/telephony/euicc/EuiccController;->isTargetPortIndexValid(II)Z

    move-result v4

    if-nez v4, :cond_a

    const-string v1, "Not permitted to switch to invalid portIndex"

    .line 1105
    invoke-static {v7, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1106
    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1}, Landroid/content/Intent;-><init>()V

    const-string v2, "android.telephony.euicc.extra.EMBEDDED_SUBSCRIPTION_ERROR_CODE"

    const/16 v3, 0x2721

    .line 1107
    invoke-virtual {v1, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 1109
    invoke-virtual {v0, v12, v6, v1}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 1142
    invoke-static {v13, v14}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :cond_a
    move v15, v1

    move/from16 v16, v2

    move-object v7, v5

    const/4 v6, 0x0

    goto :goto_6

    :cond_b
    if-eqz v4, :cond_c

    .line 1116
    :try_start_5
    invoke-direct/range {p0 .. p1}, Lcom/android/internal/telephony/euicc/EuiccController;->getResolvedPortIndexForSubscriptionSwitch(I)I

    move-result v1

    goto :goto_4

    :cond_c
    const/4 v1, 0x0

    :goto_4
    const/4 v2, -0x1

    if-ne v1, v2, :cond_d

    const/4 v6, 0x1

    goto :goto_5

    :cond_d
    const/4 v6, 0x0

    .line 1121
    :goto_5
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, " Resolved portIndex: "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v7, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    move v15, v1

    move-object v7, v5

    const/16 v16, 0x1

    :goto_6
    if-eqz v3, :cond_f

    if-eqz v6, :cond_e

    goto :goto_7

    :cond_e
    move-object/from16 v1, p0

    move/from16 v2, p1

    move v3, v15

    move-wide v4, v13

    move/from16 v6, p2

    move v8, v10

    move-object/from16 v9, p5

    move-object/from16 v10, p6

    move/from16 v11, v16

    .line 1139
    invoke-virtual/range {v1 .. v11}, Lcom/android/internal/telephony/euicc/EuiccController;->switchToSubscriptionPrivileged(IIJILjava/lang/String;ZLjava/lang/String;Landroid/app/PendingIntent;Z)V
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    .line 1142
    invoke-static {v13, v14}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    .line 1126
    :cond_f
    :goto_7
    :try_start_6
    new-instance v10, Landroid/content/Intent;

    invoke-direct {v10}, Landroid/content/Intent;-><init>()V

    const-string v3, "android.service.euicc.action.RESOLVE_NO_PRIVILEGES"

    const/4 v5, 0x0

    const/4 v6, 0x0

    .line 1132
    invoke-static {v13, v14, v11, v9}, Lcom/android/internal/telephony/euicc/EuiccOperation;->forSwitchNoPrivileges(JILjava/lang/String;)Lcom/android/internal/telephony/euicc/EuiccOperation;

    move-result-object v7

    move-object/from16 v1, p0

    move-object v2, v10

    move-object/from16 v4, p5

    move/from16 v8, p1

    move v9, v15

    move-object v15, v10

    move/from16 v10, v16

    move/from16 v11, p2

    .line 1127
    invoke-virtual/range {v1 .. v11}, Lcom/android/internal/telephony/euicc/EuiccController;->addResolutionIntent(Landroid/content/Intent;Ljava/lang/String;Ljava/lang/String;IZLcom/android/internal/telephony/euicc/EuiccOperation;IIZI)V

    const/4 v1, 0x1

    .line 1135
    invoke-virtual {v0, v12, v1, v15}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    .line 1142
    invoke-static {v13, v14}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception v0

    invoke-static {v13, v14}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1143
    throw v0
.end method

.method public switchToSubscription(IILjava/lang/String;Landroid/app/PendingIntent;)V
    .locals 8

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v7, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move-object v5, p3

    move-object v6, p4

    .line 1019
    invoke-virtual/range {v0 .. v7}, Lcom/android/internal/telephony/euicc/EuiccController;->switchToSubscription(IIIZLjava/lang/String;Landroid/app/PendingIntent;Z)V

    return-void
.end method

.method switchToSubscriptionPrivileged(IIJILjava/lang/String;ZLjava/lang/String;Landroid/app/PendingIntent;Z)V
    .locals 12

    move-object v1, p0

    .line 1372
    iget-object v10, v1, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    new-instance v11, Lcom/android/internal/telephony/euicc/EuiccController$5;

    move-object v0, v11

    move-object/from16 v2, p8

    move-wide v3, p3

    move/from16 v5, p5

    move v6, p1

    move v7, p2

    move/from16 v8, p10

    move-object/from16 v9, p9

    invoke-direct/range {v0 .. v9}, Lcom/android/internal/telephony/euicc/EuiccController$5;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Ljava/lang/String;JIIIZLandroid/app/PendingIntent;)V

    move-object v0, v10

    move v1, p1

    move v2, p2

    move-object/from16 v3, p6

    move/from16 v4, p7

    move-object v5, v11

    move/from16 v6, p10

    invoke-virtual/range {v0 .. v6}, Lcom/android/internal/telephony/euicc/EuiccConnector;->switchToSubscription(IILjava/lang/String;ZLcom/android/internal/telephony/euicc/EuiccConnector$SwitchCommandCallback;Z)V

    return-void
.end method

.method switchToSubscriptionPrivileged(IIJIZLjava/lang/String;Landroid/app/PendingIntent;Z)V
    .locals 11

    move-object v0, p0

    move/from16 v5, p5

    .line 1361
    invoke-direct {p0, v5}, Lcom/android/internal/telephony/euicc/EuiccController;->getSubscriptionForSubscriptionId(I)Landroid/telephony/SubscriptionInfo;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 1363
    invoke-virtual {v1}, Landroid/telephony/SubscriptionInfo;->getIccId()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    move-object v6, v1

    move-object v0, p0

    move v1, p1

    move v2, p2

    move-wide v3, p3

    move/from16 v5, p5

    move/from16 v7, p6

    move-object/from16 v8, p7

    move-object/from16 v9, p8

    move/from16 v10, p9

    .line 1365
    invoke-virtual/range {v0 .. v10}, Lcom/android/internal/telephony/euicc/EuiccController;->switchToSubscriptionPrivileged(IIJILjava/lang/String;ZLjava/lang/String;Landroid/app/PendingIntent;Z)V

    return-void
.end method

.method public switchToSubscriptionWithPort(IIILjava/lang/String;Landroid/app/PendingIntent;)V
    .locals 8

    const/4 v4, 0x0

    const/4 v7, 0x1

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move-object v5, p4

    move-object v6, p5

    .line 1026
    invoke-virtual/range {v0 .. v7}, Lcom/android/internal/telephony/euicc/EuiccController;->switchToSubscription(IIIZLjava/lang/String;Landroid/app/PendingIntent;Z)V

    return-void
.end method

.method public updateSubscriptionNickname(IILjava/lang/String;Ljava/lang/String;Landroid/app/PendingIntent;)V
    .locals 7

    .line 1416
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/EuiccController;->callerCanWriteEmbeddedSubscriptions()Z

    move-result v0

    .line 1417
    iget-object v1, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mAppOpsManager:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v2

    invoke-virtual {v1, v2, p4}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    .line 1419
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v1

    .line 1421
    :try_start_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccController;->getSubscriptionForSubscriptionId(I)Landroid/telephony/SubscriptionInfo;

    move-result-object v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v6, "EuiccController"

    if-nez v3, :cond_0

    .line 1423
    :try_start_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Cannot update nickname to nonexistent sub: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v6, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1424
    invoke-virtual {p0, p5, v5, v4}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1466
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :cond_0
    if-nez v0, :cond_1

    .line 1431
    :try_start_2
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    .line 1432
    invoke-virtual {v0, v3, p4}, Landroid/telephony/SubscriptionManager;->canManageSubscription(Landroid/telephony/SubscriptionInfo;Ljava/lang/String;)Z

    move-result p4

    if-nez p4, :cond_1

    .line 1433
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "No permissions: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v6, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 1434
    invoke-virtual {p0, p5, v5, v4}, Lcom/android/internal/telephony/euicc/EuiccController;->sendResult(Landroid/app/PendingIntent;ILandroid/content/Intent;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 1466
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    .line 1438
    :cond_1
    :try_start_3
    iget-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccController;->mConnector:Lcom/android/internal/telephony/euicc/EuiccConnector;

    .line 1439
    invoke-virtual {v3}, Landroid/telephony/SubscriptionInfo;->getIccId()Ljava/lang/String;

    move-result-object p4

    new-instance v0, Lcom/android/internal/telephony/euicc/EuiccController$6;

    invoke-direct {v0, p0, p5}, Lcom/android/internal/telephony/euicc/EuiccController$6;-><init>(Lcom/android/internal/telephony/euicc/EuiccController;Landroid/app/PendingIntent;)V

    .line 1438
    invoke-virtual {p2, p1, p4, p3, v0}, Lcom/android/internal/telephony/euicc/EuiccConnector;->updateSubscriptionNickname(ILjava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/EuiccConnector$UpdateNicknameCommandCallback;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 1466
    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void

    :catchall_0
    move-exception p0

    invoke-static {v1, v2}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    .line 1467
    throw p0
.end method
