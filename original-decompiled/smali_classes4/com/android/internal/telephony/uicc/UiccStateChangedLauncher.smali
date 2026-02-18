.class public Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;
.super Landroid/os/Handler;
.source "UiccStateChangedLauncher.java"


# static fields
.field private static final EVENT_ICC_CHANGED:I = 0x1

.field private static final TAG:Ljava/lang/String;

.field private static sDeviceProvisioningPackage:Ljava/lang/String;


# instance fields
.field private mContext:Landroid/content/Context;

.field private mIsRestricted:[Z

.field private mUiccController:Lcom/android/internal/telephony/uicc/UiccController;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 41
    const-class v0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->TAG:Ljava/lang/String;

    const/4 v0, 0x0

    .line 44
    sput-object v0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->sDeviceProvisioningPackage:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/uicc/UiccController;)V
    .locals 3

    .line 49
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    const/4 v0, 0x0

    .line 47
    iput-object v0, p0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->mIsRestricted:[Z

    .line 50
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const v2, 0x1040254

    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->sDeviceProvisioningPackage:Ljava/lang/String;

    if-eqz v1, :cond_0

    .line 52
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    .line 53
    iput-object p1, p0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->mContext:Landroid/content/Context;

    .line 54
    iput-object p2, p0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    const/4 p1, 0x1

    .line 55
    invoke-virtual {p2, p0, p1, v0}, Lcom/android/internal/telephony/uicc/UiccController;->registerForIccChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    :cond_0
    return-void
.end method

.method private notifyStateChanged()V
    .locals 2

    .line 92
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.SIM_STATE_CHANGED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 93
    sget-object v1, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->sDeviceProvisioningPackage:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    .line 95
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->mContext:Landroid/content/Context;

    invoke-virtual {p0, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 97
    sget-object v0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->TAG:Ljava/lang/String;

    invoke-virtual {p0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 6

    .line 61
    iget p1, p1, Landroid/os/Message;->what:I

    const/4 v0, 0x1

    if-ne p1, v0, :cond_6

    .line 64
    iget-object p1, p0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->mIsRestricted:[Z

    const/4 v1, 0x0

    if-nez p1, :cond_0

    .line 65
    invoke-static {}, Landroid/telephony/TelephonyManager;->getDefault()Landroid/telephony/TelephonyManager;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/TelephonyManager;->getPhoneCount()I

    move-result p1

    new-array p1, p1, [Z

    iput-object p1, p0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->mIsRestricted:[Z

    move p1, v0

    goto :goto_0

    :cond_0
    move p1, v1

    :goto_0
    move v2, v1

    .line 68
    :goto_1
    iget-object v3, p0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->mIsRestricted:[Z

    array-length v3, v3

    if-ge v2, v3, :cond_4

    .line 71
    iget-object v3, p0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {v3, v2}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardForPhone(I)Lcom/android/internal/telephony/uicc/UiccCard;

    move-result-object v3

    if-eqz v3, :cond_2

    .line 73
    invoke-virtual {v3}, Lcom/android/internal/telephony/uicc/UiccCard;->getCardState()Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    move-result-object v3

    sget-object v4, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_RESTRICTED:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    if-eq v3, v4, :cond_1

    goto :goto_2

    :cond_1
    move v3, v1

    goto :goto_3

    :cond_2
    :goto_2
    move v3, v0

    :goto_3
    iget-object v4, p0, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->mIsRestricted:[Z

    aget-boolean v5, v4, v2

    if-eq v3, v5, :cond_3

    xor-int/lit8 p1, v5, 0x1

    .line 75
    aput-boolean p1, v4, v2

    move p1, v0

    :cond_3
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    :cond_4
    if-eqz p1, :cond_5

    .line 80
    invoke-direct {p0}, Lcom/android/internal/telephony/uicc/UiccStateChangedLauncher;->notifyStateChanged()V

    :cond_5
    return-void

    .line 84
    :cond_6
    new-instance p0, Ljava/lang/RuntimeException;

    const-string/jumbo p1, "unexpected event not handled"

    invoke-direct {p0, p1}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
