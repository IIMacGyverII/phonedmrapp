.class public Lcom/android/internal/telephony/NetworkRegistrationManager;
.super Landroid/os/Handler;
.source "NetworkRegistrationManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkRegStateCallback;,
        Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection;,
        Lcom/android/internal/telephony/NetworkRegistrationManager$RegManagerDeathRecipient;
    }
.end annotation


# static fields
.field private static final EVENT_BIND_NETWORK_SERVICE:I = 0x1


# instance fields
.field private final mBroadcastReceiver:Landroid/content/BroadcastReceiver;

.field private final mCallbackTable:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkRegStateCallback;",
            "Landroid/os/Message;",
            ">;"
        }
    .end annotation
.end field

.field private final mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

.field private mDeathRecipient:Lcom/android/internal/telephony/NetworkRegistrationManager$RegManagerDeathRecipient;

.field private mINetworkService:Landroid/telephony/INetworkService;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mRegStateChangeRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private mServiceConnection:Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection;

.field private final mTag:Ljava/lang/String;

.field private mTargetBindingPackageName:Ljava/lang/String;

.field private final mTransportType:I


# direct methods
.method static bridge synthetic -$$Nest$fgetmCallbackTable(Lcom/android/internal/telephony/NetworkRegistrationManager;)Ljava/util/Map;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mCallbackTable:Ljava/util/Map;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDeathRecipient(Lcom/android/internal/telephony/NetworkRegistrationManager;)Lcom/android/internal/telephony/NetworkRegistrationManager$RegManagerDeathRecipient;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mDeathRecipient:Lcom/android/internal/telephony/NetworkRegistrationManager$RegManagerDeathRecipient;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmINetworkService(Lcom/android/internal/telephony/NetworkRegistrationManager;)Landroid/telephony/INetworkService;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mINetworkService:Landroid/telephony/INetworkService;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/NetworkRegistrationManager;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRegStateChangeRegistrants(Lcom/android/internal/telephony/NetworkRegistrationManager;)Lcom/android/internal/telephony/RegistrantList;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mRegStateChangeRegistrants:Lcom/android/internal/telephony/RegistrantList;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmTransportType(Lcom/android/internal/telephony/NetworkRegistrationManager;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTransportType:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fputmDeathRecipient(Lcom/android/internal/telephony/NetworkRegistrationManager;Lcom/android/internal/telephony/NetworkRegistrationManager$RegManagerDeathRecipient;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mDeathRecipient:Lcom/android/internal/telephony/NetworkRegistrationManager$RegManagerDeathRecipient;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmINetworkService(Lcom/android/internal/telephony/NetworkRegistrationManager;Landroid/telephony/INetworkService;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mINetworkService:Landroid/telephony/INetworkService;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmTargetBindingPackageName(Lcom/android/internal/telephony/NetworkRegistrationManager;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTargetBindingPackageName:Ljava/lang/String;

    return-void
.end method

.method static bridge synthetic -$$Nest$mlogd(Lcom/android/internal/telephony/NetworkRegistrationManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->logd(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mloge(Lcom/android/internal/telephony/NetworkRegistrationManager;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>(ILcom/android/internal/telephony/Phone;)V
    .locals 6

    .line 91
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 65
    new-instance v0, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v0}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mRegStateChangeRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 75
    new-instance v0, Lcom/android/internal/telephony/NetworkRegistrationManager$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/NetworkRegistrationManager$1;-><init>(Lcom/android/internal/telephony/NetworkRegistrationManager;)V

    iput-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    .line 147
    new-instance v1, Ljava/util/Hashtable;

    invoke-direct {v1}, Ljava/util/Hashtable;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mCallbackTable:Ljava/util/Map;

    .line 92
    iput p1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTransportType:I

    .line 93
    iput-object p2, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 95
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "-"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v3, 0x1

    if-ne p1, v3, :cond_0

    const-string p1, "C"

    goto :goto_0

    :cond_0
    const-string p1, "I"

    .line 96
    :goto_0
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 97
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "NRM"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTag:Ljava/lang/String;

    .line 99
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    const-string v1, "carrier_config"

    invoke-virtual {p1, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/CarrierConfigManager;

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    .line 102
    new-instance p1, Landroid/content/IntentFilter;

    invoke-direct {p1}, Landroid/content/IntentFilter;-><init>()V

    const-string v1, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 103
    invoke-virtual {p1, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const/4 v1, 0x0

    .line 105
    :try_start_0
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 106
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    invoke-virtual {p2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object p2

    const/4 v4, 0x0

    sget-object v5, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    .line 105
    invoke-virtual {v2, p2, v4, v5}, Landroid/content/Context;->createPackageContextAsUser(Ljava/lang/String;ILandroid/os/UserHandle;)Landroid/content/Context;

    move-result-object p2

    .line 107
    invoke-virtual {p2, v0, p1, v1, v1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception p1

    .line 110
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Package name not found: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/content/pm/PackageManager$NameNotFoundException;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    .line 112
    :goto_1
    invoke-static {p0, v3, v1}, Lcom/android/internal/telephony/PhoneConfigurationManager;->registerForMultiSimConfigChange(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 115
    invoke-virtual {p0, v3}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    return-void
.end method

.method private bindService(Ljava/lang/String;)V
    .locals 4

    .line 262
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    if-eqz v0, :cond_4

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v0

    if-nez v0, :cond_0

    goto/16 :goto_2

    .line 267
    :cond_0
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p1, "Can\'t find the binding package"

    .line 268
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    return-void

    .line 273
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->getClassName()Ljava/lang/String;

    move-result-object v0

    .line 274
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const-string v2, "android.telephony.NetworkService"

    if-eqz v1, :cond_2

    .line 275
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 276
    invoke-virtual {v0, p1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    goto :goto_0

    .line 278
    :cond_2
    new-instance v1, Landroid/content/ComponentName;

    invoke-direct {v1, p1, v0}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 279
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    move-result-object v0

    .line 285
    :goto_0
    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Trying to bind "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " for transport "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTransportType:I

    .line 286
    invoke-static {v2}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 285
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->logd(Ljava/lang/String;)V

    .line 287
    new-instance v1, Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection;

    const/4 v2, 0x0

    invoke-direct {v1, p0, v2}, Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection;-><init>(Lcom/android/internal/telephony/NetworkRegistrationManager;Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection-IA;)V

    iput-object v1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mServiceConnection:Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection;

    .line 288
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mServiceConnection:Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection;

    const/4 v3, 0x1

    invoke-virtual {v1, v0, v2, v3}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result v0

    if-nez v0, :cond_3

    const-string p1, "Cannot bind to the data service."

    .line 290
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    return-void

    .line 293
    :cond_3
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTargetBindingPackageName:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception p1

    .line 295
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "bindService failed "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    :goto_1
    return-void

    :cond_4
    :goto_2
    const-string p1, "can\'t bindService with invalid phone or phoneId."

    .line 263
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    return-void
.end method

.method private getClassName()Ljava/lang/String;
    .locals 3

    .line 351
    iget v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTransportType:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_1

    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    const v0, 0x10402ca

    const-string v1, "carrier_network_service_wlan_class_override_string"

    goto :goto_0

    .line 363
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Transport type not WWAN or WLAN. type="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTransportType:I

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_1
    const v0, 0x10402cf

    const-string v1, "carrier_network_service_wwan_class_override_string"

    .line 368
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    .line 370
    iget-object v2, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v2, p0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    if-eqz p0, :cond_2

    .line 372
    invoke-virtual {p0, v1}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_2

    .line 374
    invoke-virtual {p0, v1, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_2
    return-object v0
.end method

.method private getPackageName()Ljava/lang/String;
    .locals 3

    .line 317
    iget v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTransportType:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_1

    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    const v0, 0x10402cb

    const-string v1, "carrier_network_service_wlan_package_override_string"

    goto :goto_0

    .line 329
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Transport type not WWAN or WLAN. type="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTransportType:I

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_1
    const v0, 0x10402d0

    const-string v1, "carrier_network_service_wwan_package_override_string"

    .line 334
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    .line 336
    iget-object v2, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v2, p0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    if-eqz p0, :cond_2

    .line 338
    invoke-virtual {p0, v1}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_2

    .line 340
    invoke-virtual {p0, v1, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_2
    return-object v0
.end method

.method private logd(Ljava/lang/String;)V
    .locals 0

    .line 380
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 384
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private rebindService()V
    .locals 3

    .line 300
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 302
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-static {v1}, Landroid/telephony/SubscriptionManager;->isValidPhoneId(I)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTargetBindingPackageName:Ljava/lang/String;

    .line 303
    invoke-static {v0, v1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 304
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Service "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " already bound or being bound."

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->logd(Ljava/lang/String;)V

    return-void

    .line 308
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->unbindService()V

    .line 309
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->bindService(Ljava/lang/String;)V

    return-void
.end method

.method private unbindService()V
    .locals 3

    .line 243
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mINetworkService:Landroid/telephony/INetworkService;

    if-eqz v0, :cond_0

    invoke-interface {v0}, Landroid/telephony/INetworkService;->asBinder()Landroid/os/IBinder;

    move-result-object v0

    invoke-interface {v0}, Landroid/os/IBinder;->isBinderAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string/jumbo v0, "unbinding service"

    .line 244
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->logd(Ljava/lang/String;)V

    .line 247
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mINetworkService:Landroid/telephony/INetworkService;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-interface {v0, v1}, Landroid/telephony/INetworkService;->removeNetworkServiceProvider(I)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 249
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Cannot remove data service provider. "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    .line 253
    :cond_0
    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mServiceConnection:Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection;

    if-eqz v0, :cond_1

    .line 254
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mServiceConnection:Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unbindService(Landroid/content/ServiceConnection;)V

    :cond_1
    const/4 v0, 0x0

    .line 256
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mINetworkService:Landroid/telephony/INetworkService;

    .line 257
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mServiceConnection:Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkServiceConnection;

    .line 258
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mTargetBindingPackageName:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 125
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    .line 130
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unhandled event "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 127
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->rebindService()V

    :goto_0
    return-void
.end method

.method public isServiceConnected()Z
    .locals 0

    .line 135
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mINetworkService:Landroid/telephony/INetworkService;

    if-eqz p0, :cond_0

    invoke-interface {p0}, Landroid/telephony/INetworkService;->asBinder()Landroid/os/IBinder;

    move-result-object p0

    invoke-interface {p0}, Landroid/os/IBinder;->isBinderAlive()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public registerForNetworkRegistrationInfoChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    const-string v0, "registerForNetworkRegistrationInfoChanged"

    .line 143
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->logd(Ljava/lang/String;)V

    .line 144
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mRegStateChangeRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public requestNetworkRegistrationInfo(ILandroid/os/Message;)V
    .locals 4

    if-nez p2, :cond_0

    return-void

    .line 153
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->isServiceConnected()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_2

    .line 154
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "service not connected. Domain = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v2, 0x1

    if-ne p1, v2, :cond_1

    const-string p1, "CS"

    goto :goto_0

    :cond_1
    const-string p1, "PS"

    .line 155
    :goto_0
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 154
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    .line 156
    new-instance p0, Landroid/os/AsyncResult;

    iget-object p1, p2, Landroid/os/Message;->obj:Ljava/lang/Object;

    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v2, "Service not connected."

    invoke-direct {v0, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    invoke-direct {p0, p1, v1, v0}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    iput-object p0, p2, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 158
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    return-void

    .line 162
    :cond_2
    new-instance v0, Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkRegStateCallback;

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkRegStateCallback;-><init>(Lcom/android/internal/telephony/NetworkRegistrationManager;Lcom/android/internal/telephony/NetworkRegistrationManager$NetworkRegStateCallback-IA;)V

    .line 164
    :try_start_0
    iget-object v2, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mCallbackTable:Ljava/util/Map;

    invoke-interface {v2, v0, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 165
    iget-object v2, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mINetworkService:Landroid/telephony/INetworkService;

    iget-object v3, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    invoke-interface {v2, v3, p1, v0}, Landroid/telephony/INetworkService;->requestNetworkRegistrationInfo(IILandroid/telephony/INetworkServiceCallback;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception p1

    .line 167
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "requestNetworkRegistrationInfo RemoteException "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/NetworkRegistrationManager;->loge(Ljava/lang/String;)V

    .line 168
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mCallbackTable:Ljava/util/Map;

    invoke-interface {p0, v0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 169
    new-instance p0, Landroid/os/AsyncResult;

    iget-object v0, p2, Landroid/os/Message;->obj:Ljava/lang/Object;

    invoke-direct {p0, v0, v1, p1}, Landroid/os/AsyncResult;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Throwable;)V

    iput-object p0, p2, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 170
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    :goto_1
    return-void
.end method

.method public unregisterForNetworkRegistrationInfoChanged(Landroid/os/Handler;)V
    .locals 0

    .line 139
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkRegistrationManager;->mRegStateChangeRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method
