.class public Lcom/android/internal/telephony/CarrierServiceStateTracker;
.super Landroid/os/Handler;
.source "CarrierServiceStateTracker.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/CarrierServiceStateTracker$EmergencyNetworkNotification;,
        Lcom/android/internal/telephony/CarrierServiceStateTracker$PrefNetworkNotification;,
        Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;,
        Lcom/android/internal/telephony/CarrierServiceStateTracker$AllowedNetworkTypesListener;
    }
.end annotation


# static fields
.field protected static final CARRIER_EVENT_BASE:I = 0x64

.field protected static final CARRIER_EVENT_DATA_DEREGISTRATION:I = 0x68

.field protected static final CARRIER_EVENT_DATA_REGISTRATION:I = 0x67

.field protected static final CARRIER_EVENT_IMS_CAPABILITIES_CHANGED:I = 0x69

.field protected static final CARRIER_EVENT_VOICE_DEREGISTRATION:I = 0x66

.field protected static final CARRIER_EVENT_VOICE_REGISTRATION:I = 0x65

.field public static final EMERGENCY_NOTIFICATION_TAG:Ljava/lang/String; = "EmergencyNetworkNotification"
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final LOG_TAG:Ljava/lang/String; = "CSST"

.field public static final NOTIFICATION_EMERGENCY_NETWORK:I = 0x3e9

.field public static final NOTIFICATION_PREF_NETWORK:I = 0x3e8

.field public static final PREF_NETWORK_NOTIFICATION_TAG:Ljava/lang/String; = "PrefNetworkNotification"
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private static final UNINITIALIZED_DELAY_VALUE:I = -0x1


# instance fields
.field private mAllowedNetworkType:J

.field private mAllowedNetworkTypesListener:Lcom/android/internal/telephony/CarrierServiceStateTracker$AllowedNetworkTypesListener;

.field private final mBroadcastReceiver:Landroid/content/BroadcastReceiver;

.field private final mNotificationTypeMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;",
            ">;"
        }
    .end annotation
.end field

.field private mPhone:Lcom/android/internal/telephony/Phone;

.field private mPreviousSubId:I

.field private mSST:Lcom/android/internal/telephony/ServiceStateTracker;

.field private mTelephonyManager:Landroid/telephony/TelephonyManager;


# direct methods
.method static bridge synthetic -$$Nest$fgetmAllowedNetworkType(Lcom/android/internal/telephony/CarrierServiceStateTracker;)J
    .locals 2

    iget-wide v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mAllowedNetworkType:J

    return-wide v0
.end method

.method static bridge synthetic -$$Nest$fgetmNotificationTypeMap(Lcom/android/internal/telephony/CarrierServiceStateTracker;)Ljava/util/Map;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mNotificationTypeMap:Ljava/util/Map;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/CarrierServiceStateTracker;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPreviousSubId(Lcom/android/internal/telephony/CarrierServiceStateTracker;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPreviousSubId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmSST(Lcom/android/internal/telephony/CarrierServiceStateTracker;)Lcom/android/internal/telephony/ServiceStateTracker;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmTelephonyManager(Lcom/android/internal/telephony/CarrierServiceStateTracker;)Landroid/telephony/TelephonyManager;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmAllowedNetworkType(Lcom/android/internal/telephony/CarrierServiceStateTracker;J)V
    .locals 0

    iput-wide p1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mAllowedNetworkType:J

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmPreviousSubId(Lcom/android/internal/telephony/CarrierServiceStateTracker;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPreviousSubId:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmTelephonyManager(Lcom/android/internal/telephony/CarrierServiceStateTracker;Landroid/telephony/TelephonyManager;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    return-void
.end method

.method static bridge synthetic -$$Nest$mhandleAllowedNetworkTypeChanged(Lcom/android/internal/telephony/CarrierServiceStateTracker;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->handleAllowedNetworkTypeChanged()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mhandleConfigChanges(Lcom/android/internal/telephony/CarrierServiceStateTracker;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->handleConfigChanges()V

    return-void
.end method

.method static bridge synthetic -$$Nest$misGlobalMode(Lcom/android/internal/telephony/CarrierServiceStateTracker;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->isGlobalMode()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misPhoneRegisteredForWifiCalling(Lcom/android/internal/telephony/CarrierServiceStateTracker;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->isPhoneRegisteredForWifiCalling()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misPhoneStillRegistered(Lcom/android/internal/telephony/CarrierServiceStateTracker;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->isPhoneStillRegistered()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mregisterAllowedNetworkTypesListener(Lcom/android/internal/telephony/CarrierServiceStateTracker;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->registerAllowedNetworkTypesListener()V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/ServiceStateTracker;)V
    .locals 2

    .line 100
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 66
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mNotificationTypeMap:Ljava/util/Map;

    const/4 v0, -0x1

    .line 67
    iput v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPreviousSubId:I

    const-wide/16 v0, -0x1

    .line 77
    iput-wide v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mAllowedNetworkType:J

    .line 351
    new-instance v0, Lcom/android/internal/telephony/CarrierServiceStateTracker$2;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker$2;-><init>(Lcom/android/internal/telephony/CarrierServiceStateTracker;)V

    iput-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mBroadcastReceiver:Landroid/content/BroadcastReceiver;

    .line 101
    iput-object p1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 102
    iput-object p2, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    .line 103
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    const-class v1, Landroid/telephony/TelephonyManager;

    invoke-virtual {p2, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/TelephonyManager;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 104
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {p2, v1}, Landroid/telephony/TelephonyManager;->createForSubscriptionId(I)Landroid/telephony/TelephonyManager;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    .line 105
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    new-instance p2, Landroid/content/IntentFilter;

    const-string v1, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    invoke-direct {p2, v1}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, v0, p2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 108
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Landroid/telephony/SubscriptionManager;->from(Landroid/content/Context;)Landroid/telephony/SubscriptionManager;

    move-result-object p1

    new-instance p2, Lcom/android/internal/telephony/CarrierServiceStateTracker$1;

    .line 109
    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {p2, p0, v0}, Lcom/android/internal/telephony/CarrierServiceStateTracker$1;-><init>(Lcom/android/internal/telephony/CarrierServiceStateTracker;Landroid/os/Looper;)V

    .line 108
    invoke-virtual {p1, p2}, Landroid/telephony/SubscriptionManager;->addOnSubscriptionsChangedListener(Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;)V

    .line 122
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->registerNotificationTypes()V

    .line 123
    iget-object p1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 p2, 0x0

    .line 124
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/Phone;->getAllowedNetworkTypes(I)J

    move-result-wide p1

    long-to-int p1, p1

    .line 123
    invoke-static {p1}, Landroid/telephony/RadioAccessFamily;->getNetworkTypeFromRaf(I)I

    move-result p1

    int-to-long p1, p1

    iput-wide p1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mAllowedNetworkType:J

    .line 126
    new-instance p1, Lcom/android/internal/telephony/CarrierServiceStateTracker$AllowedNetworkTypesListener;

    invoke-direct {p1, p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker$AllowedNetworkTypesListener;-><init>(Lcom/android/internal/telephony/CarrierServiceStateTracker;)V

    iput-object p1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mAllowedNetworkTypesListener:Lcom/android/internal/telephony/CarrierServiceStateTracker$AllowedNetworkTypesListener;

    .line 127
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->registerAllowedNetworkTypesListener()V

    return-void
.end method

.method private checkSupportedBitmask(JJ)Z
    .locals 0

    and-long p0, p3, p1

    cmp-long p0, p0, p3

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private evaluateSendingMessageOrCancelNotification(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)V
    .locals 4

    .line 309
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->evaluateSendingMessage(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)Z

    move-result v0

    const-string v1, "CSST"

    if-eqz v0, :cond_0

    .line 310
    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getTypeId()I

    move-result v0

    const/4 v2, 0x0

    invoke-virtual {p0, v0, v2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    .line 311
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "starting timer for notifications."

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getTypeId()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 312
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->getDelay(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)I

    move-result p1

    int-to-long v1, p1

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_0

    .line 314
    :cond_0
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->cancelNotification(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)V

    .line 315
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "canceling notifications: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getTypeId()I

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method private handleAllowedNetworkTypeChanged()V
    .locals 2

    .line 294
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mNotificationTypeMap:Ljava/util/Map;

    const/16 v1, 0x3e8

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;

    if-eqz v0, :cond_0

    .line 296
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->evaluateSendingMessageOrCancelNotification(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)V

    :cond_0
    return-void
.end method

.method private handleConfigChanges()V
    .locals 2

    .line 287
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mNotificationTypeMap:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 288
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;

    .line 289
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->evaluateSendingMessageOrCancelNotification(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private handleImsCapabilitiesChanged()V
    .locals 2

    .line 301
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mNotificationTypeMap:Ljava/util/Map;

    const/16 v1, 0x3e9

    .line 302
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;

    if-eqz v0, :cond_0

    .line 304
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->evaluateSendingMessageOrCancelNotification(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)V

    :cond_0
    return-void
.end method

.method private isCarrierConfigEnableNr(Landroid/content/Context;)Z
    .locals 3

    const-string v0, "carrier_config"

    .line 266
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/CarrierConfigManager;

    const/4 v0, 0x0

    const-string v1, "CSST"

    if-nez p1, :cond_0

    const-string p0, "isCarrierConfigEnableNr: CarrierConfigManager is null"

    .line 268
    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    .line 271
    :cond_0
    iget-object v2, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {p1, v2}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p1

    if-nez p1, :cond_1

    .line 273
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isCarrierConfigEnableNr: Cannot get config "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :cond_1
    const-string p0, "carrier_nr_availabilities_int_array"

    .line 276
    invoke-virtual {p1, p0}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object p0

    .line 278
    invoke-static {p0}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty([I)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private isGlobalMode()Z
    .locals 3

    const/4 v0, 0x1

    .line 227
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 228
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    .line 227
    invoke-static {v1}, Lcom/android/internal/telephony/PhoneFactory;->calculatePreferredNetworkType(I)I

    move-result v1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 234
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->isNrSupported()Z

    move-result p0

    const/4 v2, 0x0

    if-eqz p0, :cond_1

    const/16 p0, 0x1b

    .line 236
    invoke-static {p0}, Landroid/telephony/RadioAccessFamily;->getRafFromNetworkType(I)I

    move-result p0

    if-ne v1, p0, :cond_0

    goto :goto_0

    :cond_0
    move v0, v2

    :goto_0
    return v0

    :cond_1
    const/16 p0, 0xa

    .line 239
    invoke-static {p0}, Landroid/telephony/RadioAccessFamily;->getRafFromNetworkType(I)I

    move-result p0

    if-ne v1, p0, :cond_2

    goto :goto_1

    :cond_2
    move v0, v2

    :goto_1
    return v0

    :catch_0
    const-string p0, "CSST"

    const-string v1, "Unable to get PREFERRED_NETWORK_MODE."

    .line 230
    invoke-static {p0, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v0
.end method

.method private isNrSupported()Z
    .locals 8

    .line 245
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "phone"

    .line 246
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/TelephonyManager;

    iget-object v2, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 247
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/TelephonyManager;->createForSubscriptionId(I)Landroid/telephony/TelephonyManager;

    move-result-object v1

    .line 249
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->isCarrierConfigEnableNr(Landroid/content/Context;)Z

    move-result v0

    .line 251
    invoke-virtual {v1}, Landroid/telephony/TelephonyManager;->getSupportedRadioAccessFamily()J

    move-result-wide v2

    const-wide/32 v4, 0x80000

    .line 250
    invoke-direct {p0, v2, v3, v4, v5}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->checkSupportedBitmask(JJ)Z

    move-result v2

    const/4 v3, 0x2

    .line 253
    invoke-virtual {v1, v3}, Landroid/telephony/TelephonyManager;->getAllowedNetworkTypesForReason(I)J

    move-result-wide v6

    .line 252
    invoke-direct {p0, v6, v7, v4, v5}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->checkSupportedBitmask(JJ)Z

    move-result p0

    .line 257
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "isNrSupported:  carrierConfigEnabled: "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, ", AccessFamilySupported: "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, ", isNrNetworkTypeAllowed: "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v3, "CSST"

    invoke-static {v3, v1}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz v0, :cond_0

    if-eqz v2, :cond_0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isPhoneRegisteredForWifiCalling()Z
    .locals 2

    .line 200
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isPhoneRegisteredForWifiCalling: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->isWifiCallingEnabled()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "CSST"

    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 201
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->isWifiCallingEnabled()Z

    move-result p0

    return p0
.end method

.method private isPhoneStillRegistered()Z
    .locals 2

    .line 192
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    const/4 v1, 0x1

    if-nez v0, :cond_0

    return v1

    .line 195
    :cond_0
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    if-eqz v0, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 196
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result p0

    if-nez p0, :cond_1

    goto :goto_0

    :cond_1
    const/4 v1, 0x0

    :cond_2
    :goto_0
    return v1
.end method

.method private registerAllowedNetworkTypesListener()V
    .locals 2

    .line 139
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 140
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->unregisterAllowedNetworkTypesListener()V

    .line 141
    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 142
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    if-eqz v0, :cond_0

    .line 143
    new-instance v1, Landroid/os/HandlerExecutor;

    invoke-direct {v1, p0}, Landroid/os/HandlerExecutor;-><init>(Landroid/os/Handler;)V

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mAllowedNetworkTypesListener:Lcom/android/internal/telephony/CarrierServiceStateTracker$AllowedNetworkTypesListener;

    invoke-virtual {v0, v1, p0}, Landroid/telephony/TelephonyManager;->registerTelephonyCallback(Ljava/util/concurrent/Executor;Landroid/telephony/TelephonyCallback;)V

    :cond_0
    return-void
.end method

.method private registerNotificationTypes()V
    .locals 4

    .line 162
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mNotificationTypeMap:Ljava/util/Map;

    const/16 v1, 0x3e8

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/CarrierServiceStateTracker$PrefNetworkNotification;

    invoke-direct {v3, p0, v1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$PrefNetworkNotification;-><init>(Lcom/android/internal/telephony/CarrierServiceStateTracker;I)V

    invoke-interface {v0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 164
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mNotificationTypeMap:Ljava/util/Map;

    const/16 v1, 0x3e9

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/CarrierServiceStateTracker$EmergencyNetworkNotification;

    invoke-direct {v3, p0, v1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$EmergencyNetworkNotification;-><init>(Lcom/android/internal/telephony/CarrierServiceStateTracker;I)V

    invoke-interface {v0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method private unregisterAllowedNetworkTypesListener()V
    .locals 1

    .line 150
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mTelephonyManager:Landroid/telephony/TelephonyManager;

    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mAllowedNetworkTypesListener:Lcom/android/internal/telephony/CarrierServiceStateTracker$AllowedNetworkTypesListener;

    invoke-virtual {v0, p0}, Landroid/telephony/TelephonyManager;->unregisterTelephonyCallback(Landroid/telephony/TelephonyCallback;)V

    return-void
.end method


# virtual methods
.method public cancelNotification(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)V
    .locals 2

    .line 391
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 392
    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getTypeId()I

    move-result v1

    invoke-virtual {p0, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 393
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->getNotificationManager(Landroid/content/Context;)Landroid/app/NotificationManager;

    move-result-object p0

    .line 394
    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getNotificationTag()Ljava/lang/String;

    move-result-object v0

    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getNotificationId()I

    move-result p1

    .line 393
    invoke-virtual {p0, v0, p1}, Landroid/app/NotificationManager;->cancel(Ljava/lang/String;I)V

    return-void
.end method

.method public dispose()V
    .locals 0

    .line 401
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->unregisterAllowedNetworkTypesListener()V

    return-void
.end method

.method public evaluateSendingMessage(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)Z
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 324
    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->sendMessage()Z

    move-result p0

    return p0
.end method

.method public getAllowedNetworkTypesChangedListener()Lcom/android/internal/telephony/CarrierServiceStateTracker$AllowedNetworkTypesListener;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 135
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mAllowedNetworkTypesListener:Lcom/android/internal/telephony/CarrierServiceStateTracker$AllowedNetworkTypesListener;

    return-object p0
.end method

.method public getDelay(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)I
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 332
    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getDelay()I

    move-result p0

    return p0
.end method

.method public getNotificationBuilder(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)Landroid/app/Notification$Builder;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 340
    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getNotificationBuilder()Landroid/app/Notification$Builder;

    move-result-object p0

    return-object p0
.end method

.method public getNotificationManager(Landroid/content/Context;)Landroid/app/NotificationManager;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const-string p0, "notification"

    .line 348
    invoke-virtual {p1, p0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/NotificationManager;

    return-object p0
.end method

.method public getNotificationTypeMap()Ljava/util/Map;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;",
            ">;"
        }
    .end annotation

    .line 158
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mNotificationTypeMap:Ljava/util/Map;

    return-object p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 170
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v1, 0x3e8

    if-eq v0, v1, :cond_0

    const/16 v1, 0x3e9

    if-eq v0, v1, :cond_0

    packed-switch v0, :pswitch_data_0

    goto :goto_0

    .line 178
    :pswitch_0
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->handleImsCapabilitiesChanged()V

    goto :goto_0

    .line 175
    :pswitch_1
    invoke-direct {p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->handleConfigChanges()V

    goto :goto_0

    .line 182
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "sending notification after delay: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "CSST"

    invoke-static {v1, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 183
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mNotificationTypeMap:Ljava/util/Map;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;

    if-eqz p1, :cond_1

    .line 185
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->sendNotification(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)V

    :cond_1
    :goto_0
    return-void

    :pswitch_data_0
    .packed-switch 0x65
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public isRadioOffOrAirplaneMode()Z
    .locals 4
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 209
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x1

    .line 212
    :try_start_0
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v2, "airplane_mode_on"

    const/4 v3, 0x0

    invoke-static {v0, v2, v3}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 218
    iget-object p0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mSST:Lcom/android/internal/telephony/ServiceStateTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->isRadioOn()Z

    move-result p0

    if-eqz p0, :cond_1

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    move v1, v3

    :cond_1
    :goto_0
    return v1

    :catch_0
    const-string p0, "CSST"

    const-string v0, "Unable to get AIRPLACE_MODE_ON."

    .line 215
    invoke-static {p0, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1
.end method

.method public sendNotification(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)V
    .locals 5
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 371
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->evaluateSendingMessage(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 375
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/CarrierServiceStateTracker;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 376
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->getNotificationBuilder(Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;)Landroid/app/Notification$Builder;

    move-result-object v1

    .line 378
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Landroid/app/Notification$Builder;->setWhen(J)Landroid/app/Notification$Builder;

    move-result-object v2

    const/4 v3, 0x1

    .line 379
    invoke-virtual {v2, v3}, Landroid/app/Notification$Builder;->setAutoCancel(Z)Landroid/app/Notification$Builder;

    move-result-object v2

    const v3, 0x108008a

    .line 380
    invoke-virtual {v2, v3}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object v2

    .line 381
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x106001c

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getColor(I)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/app/Notification$Builder;->setColor(I)Landroid/app/Notification$Builder;

    .line 383
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->getNotificationManager(Landroid/content/Context;)Landroid/app/NotificationManager;

    move-result-object p0

    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getNotificationTag()Ljava/lang/String;

    move-result-object v0

    .line 384
    invoke-interface {p1}, Lcom/android/internal/telephony/CarrierServiceStateTracker$NotificationType;->getNotificationId()I

    move-result p1

    invoke-virtual {v1}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v1

    .line 383
    invoke-virtual {p0, v0, p1, v1}, Landroid/app/NotificationManager;->notify(Ljava/lang/String;ILandroid/app/Notification;)V

    return-void
.end method
