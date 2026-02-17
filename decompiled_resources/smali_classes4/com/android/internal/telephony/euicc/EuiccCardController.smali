.class public Lcom/android/internal/telephony/euicc/EuiccCardController;
.super Lcom/android/internal/telephony/euicc/IEuiccCardController$Stub;
.source "EuiccCardController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/euicc/EuiccCardController$SimSlotStatusChangedBroadcastReceiver;
    }
.end annotation


# static fields
.field private static final KEY_LAST_BOOT_COUNT:Ljava/lang/String; = "last_boot_count"

.field private static final TAG:Ljava/lang/String; = "EuiccCardController"

.field private static sInstance:Lcom/android/internal/telephony/euicc/EuiccCardController;


# instance fields
.field private mAppOps:Landroid/app/AppOpsManager;

.field private mBestComponent:Landroid/content/pm/ComponentInfo;

.field private mCallingPackage:Ljava/lang/String;

.field private final mContext:Landroid/content/Context;

.field private mEuiccController:Lcom/android/internal/telephony/euicc/EuiccController;

.field private mEuiccMainThreadHandler:Landroid/os/Handler;

.field private mSimSlotStatusChangeReceiver:Lcom/android/internal/telephony/euicc/EuiccCardController$SimSlotStatusChangedBroadcastReceiver;

.field private mUiccController:Lcom/android/internal/telephony/uicc/UiccController;


# direct methods
.method static bridge synthetic -$$Nest$fgetmContext(Lcom/android/internal/telephony/euicc/EuiccCardController;)Landroid/content/Context;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mContext:Landroid/content/Context;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmEuiccController(Lcom/android/internal/telephony/euicc/EuiccCardController;)Lcom/android/internal/telephony/euicc/EuiccController;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccController:Lcom/android/internal/telephony/euicc/EuiccController;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmEuiccMainThreadHandler(Lcom/android/internal/telephony/euicc/EuiccCardController;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSimSlotStatusChangeReceiver(Lcom/android/internal/telephony/euicc/EuiccCardController;)Lcom/android/internal/telephony/euicc/EuiccCardController$SimSlotStatusChangedBroadcastReceiver;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mSimSlotStatusChangeReceiver:Lcom/android/internal/telephony/euicc/EuiccCardController$SimSlotStatusChangedBroadcastReceiver;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmUiccController(Lcom/android/internal/telephony/euicc/EuiccCardController;)Lcom/android/internal/telephony/uicc/UiccController;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mgetResultCode(Lcom/android/internal/telephony/euicc/EuiccCardController;Ljava/lang/Throwable;)I
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getResultCode(Ljava/lang/Throwable;)I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$smloge(Ljava/lang/String;Ljava/lang/Throwable;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private constructor <init>(Landroid/content/Context;)V
    .locals 3

    .line 113
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    invoke-static {}, Lcom/android/internal/telephony/euicc/EuiccController;->get()Lcom/android/internal/telephony/euicc/EuiccController;

    move-result-object v1

    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object v2

    invoke-direct {p0, p1, v0, v1, v2}, Lcom/android/internal/telephony/euicc/EuiccCardController;-><init>(Landroid/content/Context;Landroid/os/Handler;Lcom/android/internal/telephony/euicc/EuiccController;Lcom/android/internal/telephony/uicc/UiccController;)V

    .line 115
    invoke-static {}, Landroid/telephony/TelephonyFrameworkInitializer;->getTelephonyServiceManager()Landroid/os/TelephonyServiceManager;

    move-result-object p1

    .line 116
    invoke-virtual {p1}, Landroid/os/TelephonyServiceManager;->getEuiccCardControllerServiceRegisterer()Landroid/os/TelephonyServiceManager$ServiceRegisterer;

    move-result-object p1

    .line 117
    invoke-virtual {p1, p0}, Landroid/os/TelephonyServiceManager$ServiceRegisterer;->register(Landroid/os/IBinder;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/os/Handler;Lcom/android/internal/telephony/euicc/EuiccController;Lcom/android/internal/telephony/uicc/UiccController;)V
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
        visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
    .end annotation

    .line 125
    invoke-direct {p0}, Lcom/android/internal/telephony/euicc/IEuiccCardController$Stub;-><init>()V

    .line 126
    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mContext:Landroid/content/Context;

    const-string v0, "appops"

    .line 127
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/AppOpsManager;

    iput-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mAppOps:Landroid/app/AppOpsManager;

    .line 129
    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    .line 130
    iput-object p4, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    .line 131
    iput-object p3, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccController:Lcom/android/internal/telephony/euicc/EuiccController;

    .line 133
    invoke-static {p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->isBootUp(Landroid/content/Context;)Z

    move-result p2

    if-eqz p2, :cond_0

    .line 134
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$SimSlotStatusChangedBroadcastReceiver;

    const/4 p3, 0x0

    invoke-direct {p2, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController$SimSlotStatusChangedBroadcastReceiver;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/EuiccCardController$SimSlotStatusChangedBroadcastReceiver-IA;)V

    iput-object p2, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mSimSlotStatusChangeReceiver:Lcom/android/internal/telephony/euicc/EuiccCardController$SimSlotStatusChangedBroadcastReceiver;

    .line 135
    new-instance p0, Landroid/content/IntentFilter;

    const-string p3, "android.telephony.action.SIM_SLOT_STATUS_CHANGED"

    invoke-direct {p0, p3}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p2, p0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    :cond_0
    return-void
.end method

.method private checkCallingPackage(Ljava/lang/String;)V
    .locals 2

    .line 194
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mAppOps:Landroid/app/AppOpsManager;

    invoke-static {}, Landroid/os/Binder;->getCallingUid()I

    move-result v1

    invoke-virtual {v0, v1, p1}, Landroid/app/AppOpsManager;->checkPackage(ILjava/lang/String;)V

    .line 195
    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mCallingPackage:Ljava/lang/String;

    .line 196
    iget-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mContext:Landroid/content/Context;

    invoke-virtual {p1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/euicc/EuiccConnector;->findBestComponent(Landroid/content/pm/PackageManager;)Landroid/content/pm/ComponentInfo;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mBestComponent:Landroid/content/pm/ComponentInfo;

    if-eqz p1, :cond_0

    .line 197
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mCallingPackage:Ljava/lang/String;

    iget-object p1, p1, Landroid/content/pm/ComponentInfo;->packageName:Ljava/lang/String;

    .line 198
    invoke-static {p0, p1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_0

    return-void

    .line 199
    :cond_0
    new-instance p0, Ljava/lang/SecurityException;

    const-string p1, "The calling package can only be LPA."

    invoke-direct {p0, p1}, Ljava/lang/SecurityException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static get()Lcom/android/internal/telephony/euicc/EuiccCardController;
    .locals 3

    .line 102
    sget-object v0, Lcom/android/internal/telephony/euicc/EuiccCardController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccCardController;

    if-nez v0, :cond_1

    .line 103
    const-class v0, Lcom/android/internal/telephony/euicc/EuiccCardController;

    monitor-enter v0

    .line 104
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/euicc/EuiccCardController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccCardController;

    if-eqz v1, :cond_0

    .line 107
    monitor-exit v0

    goto :goto_0

    .line 105
    :cond_0
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "get() called before init()"

    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v1

    :catchall_0
    move-exception v1

    .line 107
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1

    .line 109
    :cond_1
    :goto_0
    sget-object v0, Lcom/android/internal/telephony/euicc/EuiccCardController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccCardController;

    return-object v0
.end method

.method private getEuiccCard(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccCard;
    .locals 2

    .line 218
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getUiccSlotForEmbeddedCard(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 222
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccSlot;->getUiccCard()Lcom/android/internal/telephony/uicc/UiccCard;

    move-result-object p0

    if-nez p0, :cond_1

    .line 224
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UiccCard is null. cardId : "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;)V

    return-object v0

    .line 227
    :cond_1
    check-cast p0, Lcom/android/internal/telephony/uicc/euicc/EuiccCard;

    return-object p0
.end method

.method private getEuiccPort(Ljava/lang/String;I)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;
    .locals 2

    .line 262
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getEuiccCard(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccCard;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 266
    :cond_0
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/uicc/UiccCard;->getUiccPort(I)Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object p0

    if-nez p0, :cond_1

    .line 268
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UiccPort is null. cardId : "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " portIndex : "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;)V

    return-object v0

    .line 271
    :cond_1
    check-cast p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    return-object p0
.end method

.method private getEuiccPortFromIccId(Ljava/lang/String;Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;
    .locals 2

    .line 231
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getUiccSlotForEmbeddedCard(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 235
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccSlot;->getUiccCard()Lcom/android/internal/telephony/uicc/UiccCard;

    move-result-object v1

    if-nez v1, :cond_1

    .line 237
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "UiccCard is null. cardId : "

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;)V

    return-object v0

    .line 240
    :cond_1
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/uicc/UiccSlot;->getPortIndexFromIccId(Ljava/lang/String;)I

    move-result p0

    .line 241
    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/uicc/UiccCard;->getUiccPort(I)Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object p2

    if-nez p2, :cond_2

    .line 243
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UiccPort is null. cardId : "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " portIndex : "

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;)V

    return-object v0

    .line 246
    :cond_2
    check-cast p2, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    return-object p2
.end method

.method private getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;
    .locals 2

    .line 250
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getEuiccCard(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccCard;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 254
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccCard;->getUiccPortList()[Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object v1

    array-length v1, v1

    if-lez v1, :cond_1

    .line 255
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccCard;->getUiccPortList()[Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object p0

    const/4 p1, 0x0

    aget-object p0, p0, p1

    check-cast p0, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    return-object p0

    .line 257
    :cond_1
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "No active ports exists. cardId : "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;)V

    return-object v0
.end method

.method private getResultCode(Ljava/lang/Throwable;)I
    .locals 0

    .line 275
    instance-of p0, p1, Lcom/android/internal/telephony/uicc/euicc/EuiccCardErrorException;

    if-eqz p0, :cond_0

    .line 276
    check-cast p1, Lcom/android/internal/telephony/uicc/euicc/EuiccCardErrorException;

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/euicc/EuiccCardErrorException;->getErrorCode()I

    move-result p0

    return p0

    :cond_0
    const/4 p0, -0x1

    return p0
.end method

.method private getUiccSlotForEmbeddedCard(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/UiccSlot;
    .locals 4

    .line 204
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlotForCardId(Ljava/lang/String;)I

    move-result v0

    .line 205
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlot(I)Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p0

    const/4 v1, 0x0

    const-string v2, " cardId : "

    if-nez p0, :cond_0

    .line 207
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "UiccSlot is null. slotId : "

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;)V

    return-object v1

    .line 210
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccSlot;->isEuicc()Z

    move-result v3

    if-nez v3, :cond_1

    .line 211
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "UiccSlot is not embedded slot : "

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;)V

    return-object v1

    :cond_1
    return-object p0
.end method

.method public static init(Landroid/content/Context;)Lcom/android/internal/telephony/euicc/EuiccCardController;
    .locals 3

    .line 90
    const-class v0, Lcom/android/internal/telephony/euicc/EuiccCardController;

    monitor-enter v0

    .line 91
    :try_start_0
    sget-object v1, Lcom/android/internal/telephony/euicc/EuiccCardController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccCardController;

    if-nez v1, :cond_0

    .line 92
    new-instance v1, Lcom/android/internal/telephony/euicc/EuiccCardController;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/android/internal/telephony/euicc/EuiccCardController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccCardController;

    goto :goto_0

    :cond_0
    const-string p0, "EuiccCardController"

    .line 94
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "init() called multiple times! sInstance = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v2, Lcom/android/internal/telephony/euicc/EuiccCardController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccCardController;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {p0, v1}, Landroid/util/Log;->wtf(Ljava/lang/String;Ljava/lang/String;)I

    .line 96
    :goto_0
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 97
    sget-object p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->sInstance:Lcom/android/internal/telephony/euicc/EuiccCardController;

    return-object p0

    :catchall_0
    move-exception p0

    .line 96
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public static isBootUp(Landroid/content/Context;)Z
    .locals 4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
        visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
    .end annotation

    .line 148
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "boot_count"

    const/4 v2, -0x1

    .line 147
    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    .line 149
    invoke-static {p0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v1, "last_boot_count"

    .line 150
    invoke-interface {p0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v3

    if-eq v0, v2, :cond_1

    if-eq v3, v2, :cond_1

    if-eq v0, v3, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    return p0

    .line 152
    :cond_1
    :goto_0
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    const/4 p0, 0x1

    return p0
.end method

.method private static loge(Ljava/lang/String;)V
    .locals 1

    const-string v0, "EuiccCardController"

    .line 1475
    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static loge(Ljava/lang/String;Ljava/lang/Throwable;)V
    .locals 1

    const-string v0, "EuiccCardController"

    .line 1479
    invoke-static {v0, p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method


# virtual methods
.method public authenticateServer(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[B[B[B[BLcom/android/internal/telephony/euicc/IAuthenticateServerCallback;)V
    .locals 11

    move-object v0, p0

    move-object/from16 v1, p8

    const/4 v2, 0x0

    .line 1070
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    move-object v3, p2

    .line 1080
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object v3

    if-nez v3, :cond_0

    const/4 v0, -0x2

    .line 1083
    :try_start_1
    invoke-interface {v1, v0, v2}, Lcom/android/internal/telephony/euicc/IAuthenticateServerCallback;->onComplete(I[B)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    move-object v1, v0

    const-string v0, "authenticateServer callback failure."

    .line 1085
    invoke-static {v0, v1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 1090
    :cond_0
    new-instance v9, Lcom/android/internal/telephony/euicc/EuiccCardController$16;

    invoke-direct {v9, p0, v1}, Lcom/android/internal/telephony/euicc/EuiccCardController$16;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IAuthenticateServerCallback;)V

    .line 1111
    iget-object v10, v0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    move-object v4, p3

    move-object v5, p4

    move-object/from16 v6, p5

    move-object/from16 v7, p6

    move-object/from16 v8, p7

    invoke-virtual/range {v3 .. v10}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->authenticateServer(Ljava/lang/String;[B[B[B[BLcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 v0, -0x3

    .line 1073
    :try_start_2
    invoke-interface {v1, v0, v2}, Lcom/android/internal/telephony/euicc/IAuthenticateServerCallback;->onComplete(I[B)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception v0

    move-object v1, v0

    const-string v0, "callback onComplete failure after checkCallingPackage."

    .line 1075
    invoke-static {v0, v1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public cancelSession(Ljava/lang/String;Ljava/lang/String;[BILcom/android/internal/telephony/euicc/ICancelSessionCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 1221
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 1231
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 1234
    :try_start_1
    invoke-interface {p5, p0, v0}, Lcom/android/internal/telephony/euicc/ICancelSessionCallback;->onComplete(I[B)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "cancelSession callback failure."

    .line 1236
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 1241
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$19;

    invoke-direct {p2, p0, p5}, Lcom/android/internal/telephony/euicc/EuiccCardController$19;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/ICancelSessionCallback;)V

    .line 1262
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p4, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->cancelSession([BILcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 1224
    :try_start_2
    invoke-interface {p5, p0, v0}, Lcom/android/internal/telephony/euicc/ICancelSessionCallback;->onComplete(I[B)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 1226
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public deleteProfile(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IDeleteProfileCallback;)V
    .locals 1

    .line 628
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 638
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 641
    :try_start_1
    invoke-interface {p4, p0}, Lcom/android/internal/telephony/euicc/IDeleteProfileCallback;->onComplete(I)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "deleteProfile callback failure."

    .line 643
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 648
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/euicc/EuiccCardController$7;

    invoke-direct {v0, p0, p2, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$7;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IDeleteProfileCallback;)V

    .line 673
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, v0, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->deleteProfile(Ljava/lang/String;Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 631
    :try_start_2
    invoke-interface {p4, p0}, Lcom/android/internal/telephony/euicc/IDeleteProfileCallback;->onComplete(I)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 633
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public disableProfile(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLcom/android/internal/telephony/euicc/IDisableProfileCallback;)V
    .locals 0

    .line 466
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 476
    invoke-direct {p0, p2, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getEuiccPortFromIccId(Ljava/lang/String;Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 479
    :try_start_1
    invoke-interface {p5, p0}, Lcom/android/internal/telephony/euicc/IDisableProfileCallback;->onComplete(I)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "disableProfile callback failure."

    .line 481
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 486
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$4;

    invoke-direct {p2, p0, p5}, Lcom/android/internal/telephony/euicc/EuiccCardController$4;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IDisableProfileCallback;)V

    .line 507
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p4, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->disableProfile(Ljava/lang/String;ZLcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 469
    :try_start_2
    invoke-interface {p5, p0}, Lcom/android/internal/telephony/euicc/IDisableProfileCallback;->onComplete(I)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 471
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 3

    .line 1463
    iget-object v0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mContext:Landroid/content/Context;

    const-string v1, "android.permission.DUMP"

    const-string v2, "Requires DUMP"

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->enforceCallingOrSelfPermission(Ljava/lang/String;Ljava/lang/String;)V

    .line 1464
    invoke-static {}, Landroid/os/Binder;->clearCallingIdentity()J

    move-result-wide v0

    .line 1466
    invoke-super {p0, p1, p2, p3}, Lcom/android/internal/telephony/euicc/IEuiccCardController$Stub;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1468
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mCallingPackage="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mCallingPackage:Ljava/lang/String;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1469
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mBestComponent="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mBestComponent:Landroid/content/pm/ComponentInfo;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1471
    invoke-static {v0, v1}, Landroid/os/Binder;->restoreCallingIdentity(J)V

    return-void
.end method

.method public getAllProfiles(Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IGetAllProfilesCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 285
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 295
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 298
    :try_start_1
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetAllProfilesCallback;->onComplete(I[Landroid/service/euicc/EuiccProfileInfo;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "getAllProfiles callback failure."

    .line 300
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 305
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$1;

    invoke-direct {p2, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController$1;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IGetAllProfilesCallback;)V

    .line 327
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getAllProfiles(Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 288
    :try_start_2
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetAllProfilesCallback;->onComplete(I[Landroid/service/euicc/EuiccProfileInfo;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 290
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public getDefaultSmdpAddress(Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IGetDefaultSmdpAddressCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 732
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 742
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 745
    :try_start_1
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetDefaultSmdpAddressCallback;->onComplete(ILjava/lang/String;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "getDefaultSmdpAddress callback failure."

    .line 747
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 752
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$9;

    invoke-direct {p2, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController$9;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IGetDefaultSmdpAddressCallback;)V

    .line 773
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getDefaultSmdpAddress(Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 735
    :try_start_2
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetDefaultSmdpAddressCallback;->onComplete(ILjava/lang/String;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 737
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public getEnabledProfile(Ljava/lang/String;Ljava/lang/String;ILcom/android/internal/telephony/euicc/IGetProfileCallback;)V
    .locals 8

    const/4 v0, 0x0

    .line 382
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_3

    .line 395
    iget-object p1, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlots()[Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p1

    array-length v1, p1

    const/4 v2, 0x0

    move-object v4, v0

    move v3, v2

    :goto_0
    const/4 v5, 0x1

    if-ge v2, v1, :cond_1

    aget-object v6, p1, v2

    .line 396
    invoke-virtual {v6}, Lcom/android/internal/telephony/uicc/UiccSlot;->getEid()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_0

    .line 398
    invoke-virtual {v6, p3}, Lcom/android/internal/telephony/uicc/UiccSlot;->isValidPortIndex(I)Z

    move-result v7

    if-eqz v7, :cond_0

    .line 400
    invoke-virtual {v6, p3}, Lcom/android/internal/telephony/uicc/UiccSlot;->getIccId(I)Ljava/lang/String;

    move-result-object v4

    move v3, v5

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_1
    const/4 p1, -0x2

    if-nez v3, :cond_2

    .line 406
    :try_start_1
    invoke-interface {p4, p1, v0}, Lcom/android/internal/telephony/euicc/IGetProfileCallback;->onComplete(ILandroid/service/euicc/EuiccProfileInfo;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_1

    :catch_0
    move-exception p0

    const-string p1, "getEnabledProfile callback failure due to invalid port slot."

    .line 408
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void

    .line 414
    :cond_2
    invoke-static {v4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const-string v2, "getEnabledProfile callback failure."

    if-eqz v1, :cond_3

    .line 416
    :try_start_2
    invoke-interface {p4, v5, v0}, Lcom/android/internal/telephony/euicc/IGetProfileCallback;->onComplete(ILandroid/service/euicc/EuiccProfileInfo;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_2

    :catch_1
    move-exception p0

    .line 418
    invoke-static {v2, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_2
    return-void

    .line 423
    :cond_3
    invoke-direct {p0, p2, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getEuiccPort(Ljava/lang/String;I)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p3

    if-nez p3, :cond_4

    .line 426
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p3

    if-nez p3, :cond_4

    .line 429
    :try_start_3
    invoke-interface {p4, p1, v0}, Lcom/android/internal/telephony/euicc/IGetProfileCallback;->onComplete(ILandroid/service/euicc/EuiccProfileInfo;)V
    :try_end_3
    .catch Landroid/os/RemoteException; {:try_start_3 .. :try_end_3} :catch_2

    goto :goto_3

    :catch_2
    move-exception p0

    .line 431
    invoke-static {v2, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_3
    return-void

    .line 437
    :cond_4
    new-instance p1, Lcom/android/internal/telephony/euicc/EuiccCardController$3;

    invoke-direct {p1, p0, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$3;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IGetProfileCallback;)V

    .line 458
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p3, v4, p1, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getProfile(Ljava/lang/String;Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_3
    const/4 p0, -0x3

    .line 385
    :try_start_4
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/IGetProfileCallback;->onComplete(ILandroid/service/euicc/EuiccProfileInfo;)V
    :try_end_4
    .catch Landroid/os/RemoteException; {:try_start_4 .. :try_end_4} :catch_4

    goto :goto_4

    :catch_4
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 387
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_4
    return-void
.end method

.method public getEuiccChallenge(Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IGetEuiccChallengeCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 925
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 935
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 938
    :try_start_1
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetEuiccChallengeCallback;->onComplete(I[B)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "getEuiccChallenge callback failure."

    .line 940
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 945
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$13;

    invoke-direct {p2, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController$13;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IGetEuiccChallengeCallback;)V

    .line 966
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getEuiccChallenge(Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 928
    :try_start_2
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetEuiccChallengeCallback;->onComplete(I[B)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 930
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public getEuiccInfo1(Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IGetEuiccInfo1Callback;)V
    .locals 1

    const/4 v0, 0x0

    .line 973
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 983
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 986
    :try_start_1
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetEuiccInfo1Callback;->onComplete(I[B)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "getEuiccInfo1 callback failure."

    .line 988
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 993
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$14;

    invoke-direct {p2, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController$14;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IGetEuiccInfo1Callback;)V

    .line 1014
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getEuiccInfo1(Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 976
    :try_start_2
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetEuiccInfo1Callback;->onComplete(I[B)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 978
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public getEuiccInfo2(Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IGetEuiccInfo2Callback;)V
    .locals 1

    const/4 v0, 0x0

    .line 1021
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 1031
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 1034
    :try_start_1
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetEuiccInfo2Callback;->onComplete(I[B)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "getEuiccInfo2 callback failure."

    .line 1036
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 1041
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$15;

    invoke-direct {p2, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController$15;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IGetEuiccInfo2Callback;)V

    .line 1062
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getEuiccInfo2(Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 1024
    :try_start_2
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetEuiccInfo2Callback;->onComplete(I[B)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 1026
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public getProfile(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IGetProfileCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 334
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 344
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 347
    :try_start_1
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/IGetProfileCallback;->onComplete(ILandroid/service/euicc/EuiccProfileInfo;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "getProfile callback failure."

    .line 349
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 354
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$2;

    invoke-direct {p2, p0, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$2;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IGetProfileCallback;)V

    .line 375
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getProfile(Ljava/lang/String;Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 337
    :try_start_2
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/IGetProfileCallback;->onComplete(ILandroid/service/euicc/EuiccProfileInfo;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 339
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public getRulesAuthTable(Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IGetRulesAuthTableCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 876
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 886
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 889
    :try_start_1
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetRulesAuthTableCallback;->onComplete(ILandroid/telephony/euicc/EuiccRulesAuthTable;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "getRulesAuthTable callback failure."

    .line 891
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 896
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$12;

    invoke-direct {p2, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController$12;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IGetRulesAuthTableCallback;)V

    .line 918
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getRulesAuthTable(Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 879
    :try_start_2
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetRulesAuthTableCallback;->onComplete(ILandroid/telephony/euicc/EuiccRulesAuthTable;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 881
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public getSmdsAddress(Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IGetSmdsAddressCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 780
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 790
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 793
    :try_start_1
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetSmdsAddressCallback;->onComplete(ILjava/lang/String;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "getSmdsAddress callback failure."

    .line 795
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 800
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$10;

    invoke-direct {p2, p0, p3}, Lcom/android/internal/telephony/euicc/EuiccCardController$10;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IGetSmdsAddressCallback;)V

    .line 821
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getSmdsAddress(Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 783
    :try_start_2
    invoke-interface {p3, p0, v0}, Lcom/android/internal/telephony/euicc/IGetSmdsAddressCallback;->onComplete(ILjava/lang/String;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 785
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public isEmbeddedCardPresent()Z
    .locals 5
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
        visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
    .end annotation

    .line 177
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlots()[Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return v0

    .line 181
    :cond_0
    array-length v1, p0

    move v2, v0

    :goto_0
    if-ge v2, v1, :cond_2

    aget-object v3, p0, v2

    if-eqz v3, :cond_1

    .line 183
    invoke-virtual {v3}, Lcom/android/internal/telephony/uicc/UiccSlot;->isRemovable()Z

    move-result v4

    if-nez v4, :cond_1

    .line 184
    invoke-virtual {v3}, Lcom/android/internal/telephony/uicc/UiccSlot;->getCardState()Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    move-result-object v4

    if-eqz v4, :cond_1

    .line 185
    invoke-virtual {v3}, Lcom/android/internal/telephony/uicc/UiccSlot;->getCardState()Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->isCardPresent()Z

    move-result v3

    if-eqz v3, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    return v0
.end method

.method public isEmbeddedSlotActivated()Z
    .locals 4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
        visibility = .enum Lcom/android/internal/annotations/VisibleForTesting$Visibility;->PRIVATE:Lcom/android/internal/annotations/VisibleForTesting$Visibility;
    .end annotation

    .line 161
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccSlots()[Lcom/android/internal/telephony/uicc/UiccSlot;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return v0

    :cond_0
    move v1, v0

    .line 165
    :goto_0
    array-length v2, p0

    if-ge v1, v2, :cond_2

    .line 166
    aget-object v2, p0, v1

    if-eqz v2, :cond_1

    .line 167
    invoke-virtual {v2}, Lcom/android/internal/telephony/uicc/UiccSlot;->isRemovable()Z

    move-result v3

    if-nez v3, :cond_1

    invoke-virtual {v2}, Lcom/android/internal/telephony/uicc/UiccSlot;->isActive()Z

    move-result v2

    if-eqz v2, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_2
    return v0
.end method

.method public listNotifications(Ljava/lang/String;Ljava/lang/String;ILcom/android/internal/telephony/euicc/IListNotificationsCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 1269
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 1279
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 1282
    :try_start_1
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/IListNotificationsCallback;->onComplete(I[Landroid/telephony/euicc/EuiccNotification;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "listNotifications callback failure."

    .line 1284
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 1289
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$20;

    invoke-direct {p2, p0, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$20;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IListNotificationsCallback;)V

    .line 1311
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->listNotifications(ILcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 1272
    :try_start_2
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/IListNotificationsCallback;->onComplete(I[Landroid/telephony/euicc/EuiccNotification;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 1274
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public loadBoundProfilePackage(Ljava/lang/String;Ljava/lang/String;[BLcom/android/internal/telephony/euicc/ILoadBoundProfilePackageCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 1169
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 1179
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 1182
    :try_start_1
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/ILoadBoundProfilePackageCallback;->onComplete(I[B)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "loadBoundProfilePackage callback failure."

    .line 1184
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 1189
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/euicc/EuiccCardController$18;

    invoke-direct {v0, p0, p2, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$18;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Ljava/lang/String;Lcom/android/internal/telephony/euicc/ILoadBoundProfilePackageCallback;)V

    .line 1214
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, v0, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->loadBoundProfilePackage([BLcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 1172
    :try_start_2
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/ILoadBoundProfilePackageCallback;->onComplete(I[B)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 1174
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public prepareDownload(Ljava/lang/String;Ljava/lang/String;[B[B[B[BLcom/android/internal/telephony/euicc/IPrepareDownloadCallback;)V
    .locals 8

    const/4 v0, 0x0

    .line 1120
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 1130
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object v1

    if-nez v1, :cond_0

    const/4 p0, -0x2

    .line 1133
    :try_start_1
    invoke-interface {p7, p0, v0}, Lcom/android/internal/telephony/euicc/IPrepareDownloadCallback;->onComplete(I[B)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "prepareDownload callback failure."

    .line 1135
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 1140
    :cond_0
    new-instance v6, Lcom/android/internal/telephony/euicc/EuiccCardController$17;

    invoke-direct {v6, p0, p7}, Lcom/android/internal/telephony/euicc/EuiccCardController$17;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IPrepareDownloadCallback;)V

    .line 1161
    iget-object v7, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    move-object v2, p3

    move-object v3, p4

    move-object v4, p5

    move-object v5, p6

    invoke-virtual/range {v1 .. v7}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->prepareDownload([B[B[B[BLcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 1123
    :try_start_2
    invoke-interface {p7, p0, v0}, Lcom/android/internal/telephony/euicc/IPrepareDownloadCallback;->onComplete(I[B)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 1125
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public removeNotificationFromList(Ljava/lang/String;Ljava/lang/String;ILcom/android/internal/telephony/euicc/IRemoveNotificationFromListCallback;)V
    .locals 0

    .line 1416
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 1426
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 1429
    :try_start_1
    invoke-interface {p4, p0}, Lcom/android/internal/telephony/euicc/IRemoveNotificationFromListCallback;->onComplete(I)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "removeNotificationFromList callback failure."

    .line 1431
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 1436
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$23;

    invoke-direct {p2, p0, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$23;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IRemoveNotificationFromListCallback;)V

    .line 1458
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->removeNotificationFromList(ILcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 1419
    :try_start_2
    invoke-interface {p4, p0}, Lcom/android/internal/telephony/euicc/IRemoveNotificationFromListCallback;->onComplete(I)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 1421
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public resetMemory(Ljava/lang/String;Ljava/lang/String;ILcom/android/internal/telephony/euicc/IResetMemoryCallback;)V
    .locals 1

    .line 680
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 690
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 693
    :try_start_1
    invoke-interface {p4, p0}, Lcom/android/internal/telephony/euicc/IResetMemoryCallback;->onComplete(I)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "resetMemory callback failure."

    .line 695
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 700
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/euicc/EuiccCardController$8;

    invoke-direct {v0, p0, p2, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$8;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Ljava/lang/String;Lcom/android/internal/telephony/euicc/IResetMemoryCallback;)V

    .line 725
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, v0, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->resetMemory(ILcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 683
    :try_start_2
    invoke-interface {p4, p0}, Lcom/android/internal/telephony/euicc/IResetMemoryCallback;->onComplete(I)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 685
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public retrieveNotification(Ljava/lang/String;Ljava/lang/String;ILcom/android/internal/telephony/euicc/IRetrieveNotificationCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 1367
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 1377
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 1380
    :try_start_1
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/IRetrieveNotificationCallback;->onComplete(ILandroid/telephony/euicc/EuiccNotification;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "retrieveNotification callback failure."

    .line 1382
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 1387
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$22;

    invoke-direct {p2, p0, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$22;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IRetrieveNotificationCallback;)V

    .line 1409
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->retrieveNotification(ILcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 1370
    :try_start_2
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/IRetrieveNotificationCallback;->onComplete(ILandroid/telephony/euicc/EuiccNotification;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 1372
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public retrieveNotificationList(Ljava/lang/String;Ljava/lang/String;ILcom/android/internal/telephony/euicc/IRetrieveNotificationListCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 1318
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 1328
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 1331
    :try_start_1
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/IRetrieveNotificationListCallback;->onComplete(I[Landroid/telephony/euicc/EuiccNotification;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "retrieveNotificationList callback failure."

    .line 1333
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 1338
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$21;

    invoke-direct {p2, p0, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$21;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/IRetrieveNotificationListCallback;)V

    .line 1360
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->retrieveNotificationList(ILcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 1321
    :try_start_2
    invoke-interface {p4, p0, v0}, Lcom/android/internal/telephony/euicc/IRetrieveNotificationListCallback;->onComplete(I[Landroid/telephony/euicc/EuiccNotification;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 1323
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public setDefaultSmdpAddress(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/ISetDefaultSmdpAddressCallback;)V
    .locals 0

    .line 828
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 838
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 841
    :try_start_1
    invoke-interface {p4, p0}, Lcom/android/internal/telephony/euicc/ISetDefaultSmdpAddressCallback;->onComplete(I)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "setDefaultSmdpAddress callback failure."

    .line 843
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 848
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$11;

    invoke-direct {p2, p0, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController$11;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/ISetDefaultSmdpAddressCallback;)V

    .line 869
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->setDefaultSmdpAddress(Ljava/lang/String;Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 831
    :try_start_2
    invoke-interface {p4, p0}, Lcom/android/internal/telephony/euicc/ISetDefaultSmdpAddressCallback;->onComplete(I)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 833
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public setNickname(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/euicc/ISetNicknameCallback;)V
    .locals 0

    .line 580
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 590
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getFirstActiveEuiccPort(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 593
    :try_start_1
    invoke-interface {p5, p0}, Lcom/android/internal/telephony/euicc/ISetNicknameCallback;->onComplete(I)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string p1, "setNickname callback failure."

    .line 595
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 600
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$6;

    invoke-direct {p2, p0, p5}, Lcom/android/internal/telephony/euicc/EuiccCardController$6;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/ISetNicknameCallback;)V

    .line 621
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p4, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->setNickname(Ljava/lang/String;Ljava/lang/String;Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 583
    :try_start_2
    invoke-interface {p5, p0}, Lcom/android/internal/telephony/euicc/ISetNicknameCallback;->onComplete(I)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 585
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method

.method public switchToProfile(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IZLcom/android/internal/telephony/euicc/ISwitchToProfileCallback;)V
    .locals 7

    const/4 v0, 0x0

    .line 514
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/euicc/EuiccCardController;->checkCallingPackage(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_1

    .line 524
    invoke-direct {p0, p2, p4}, Lcom/android/internal/telephony/euicc/EuiccCardController;->getEuiccPort(Ljava/lang/String;I)Lcom/android/internal/telephony/uicc/euicc/EuiccPort;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p0, -0x2

    .line 527
    :try_start_1
    invoke-interface {p6, p0, v0}, Lcom/android/internal/telephony/euicc/ISwitchToProfileCallback;->onComplete(ILandroid/service/euicc/EuiccProfileInfo;)V
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 529
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p2, "switchToProfile callback failure for portIndex :"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_0
    return-void

    .line 534
    :cond_0
    new-instance p2, Lcom/android/internal/telephony/euicc/EuiccCardController$5;

    move-object v1, p2

    move-object v2, p0

    move-object v3, p6

    move-object v4, p1

    move-object v5, p3

    move v6, p5

    invoke-direct/range {v1 .. v6}, Lcom/android/internal/telephony/euicc/EuiccCardController$5;-><init>(Lcom/android/internal/telephony/euicc/EuiccCardController;Lcom/android/internal/telephony/euicc/ISwitchToProfileCallback;Lcom/android/internal/telephony/uicc/euicc/EuiccPort;Ljava/lang/String;Z)V

    .line 573
    iget-object p0, p0, Lcom/android/internal/telephony/euicc/EuiccCardController;->mEuiccMainThreadHandler:Landroid/os/Handler;

    invoke-virtual {p1, p3, p2, p0}, Lcom/android/internal/telephony/uicc/euicc/EuiccPort;->getProfile(Ljava/lang/String;Lcom/android/internal/telephony/uicc/euicc/async/AsyncResultCallback;Landroid/os/Handler;)V

    return-void

    :catch_1
    const/4 p0, -0x3

    .line 517
    :try_start_2
    invoke-interface {p6, p0, v0}, Lcom/android/internal/telephony/euicc/ISwitchToProfileCallback;->onComplete(ILandroid/service/euicc/EuiccProfileInfo;)V
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_1

    :catch_2
    move-exception p0

    const-string p1, "callback onComplete failure after checkCallingPackage."

    .line 519
    invoke-static {p1, p0}, Lcom/android/internal/telephony/euicc/EuiccCardController;->loge(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_1
    return-void
.end method
