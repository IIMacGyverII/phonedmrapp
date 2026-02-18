.class public Lcom/android/internal/telephony/data/DataConfigManager;
.super Landroid/os/Handler;
.source "DataConfigManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;,
        Lcom/android/internal/telephony/data/DataConfigManager$DataConfigNetworkType;
    }
.end annotation


# static fields
.field private static final BANDWIDTH_SOURCE_BANDWIDTH_ESTIMATOR_STRING_VALUE:Ljava/lang/String; = "bandwidth_estimator"

.field private static final BANDWIDTH_SOURCE_CARRIER_CONFIG_STRING_VALUE:Ljava/lang/String; = "carrier_config"

.field private static final BANDWIDTH_SOURCE_MODEM_STRING_VALUE:Ljava/lang/String; = "modem"

.field private static final DATA_CONFIG_NETWORK_TYPE_1xRTT:Ljava/lang/String; = "1xRTT"

.field private static final DATA_CONFIG_NETWORK_TYPE_CDMA:Ljava/lang/String; = "CDMA"

.field private static final DATA_CONFIG_NETWORK_TYPE_EDGE:Ljava/lang/String; = "EDGE"

.field private static final DATA_CONFIG_NETWORK_TYPE_EHRPD:Ljava/lang/String; = "eHRPD"

.field private static final DATA_CONFIG_NETWORK_TYPE_EVDO_0:Ljava/lang/String; = "EvDo_0"

.field private static final DATA_CONFIG_NETWORK_TYPE_EVDO_A:Ljava/lang/String; = "EvDo_A"

.field private static final DATA_CONFIG_NETWORK_TYPE_EVDO_B:Ljava/lang/String; = "EvDo_B"

.field private static final DATA_CONFIG_NETWORK_TYPE_GPRS:Ljava/lang/String; = "GPRS"

.field private static final DATA_CONFIG_NETWORK_TYPE_GSM:Ljava/lang/String; = "GSM"

.field private static final DATA_CONFIG_NETWORK_TYPE_HSDPA:Ljava/lang/String; = "HSDPA"

.field private static final DATA_CONFIG_NETWORK_TYPE_HSPA:Ljava/lang/String; = "HSPA"

.field private static final DATA_CONFIG_NETWORK_TYPE_HSPAP:Ljava/lang/String; = "HSPA+"

.field private static final DATA_CONFIG_NETWORK_TYPE_HSUPA:Ljava/lang/String; = "HSUPA"

.field private static final DATA_CONFIG_NETWORK_TYPE_IDEN:Ljava/lang/String; = "iDEN"

.field private static final DATA_CONFIG_NETWORK_TYPE_IWLAN:Ljava/lang/String; = "IWLAN"

.field public static final DATA_CONFIG_NETWORK_TYPE_LTE:Ljava/lang/String; = "LTE"

.field private static final DATA_CONFIG_NETWORK_TYPE_LTE_CA:Ljava/lang/String; = "LTE_CA"

.field public static final DATA_CONFIG_NETWORK_TYPE_NR_NSA:Ljava/lang/String; = "NR_NSA"

.field public static final DATA_CONFIG_NETWORK_TYPE_NR_NSA_MMWAVE:Ljava/lang/String; = "NR_NSA_MMWAVE"

.field private static final DATA_CONFIG_NETWORK_TYPE_NR_SA:Ljava/lang/String; = "NR_SA"

.field private static final DATA_CONFIG_NETWORK_TYPE_NR_SA_MMWAVE:Ljava/lang/String; = "NR_SA_MMWAVE"

.field private static final DATA_CONFIG_NETWORK_TYPE_TD_SCDMA:Ljava/lang/String; = "TD_SCDMA"

.field private static final DATA_CONFIG_NETWORK_TYPE_UMTS:Ljava/lang/String; = "UMTS"

.field private static final DEFAULT_BANDWIDTH:I = 0xe

.field private static final DEFAULT_NETWORK_TRANSIT_STATE_TIMEOUT_MS:I = 0x493e0

.field private static final EVENT_CARRIER_CONFIG_CHANGED:I = 0x1

.field private static final EVENT_DEVICE_CONFIG_CHANGED:I = 0x2

.field private static final KEY_ANOMALY_IMS_RELEASE_REQUEST:Ljava/lang/String; = "anomaly_ims_release_request"

.field private static final KEY_ANOMALY_NETWORK_CONNECTING_TIMEOUT:Ljava/lang/String; = "anomaly_network_connecting_timeout"

.field private static final KEY_ANOMALY_NETWORK_DISCONNECTING_TIMEOUT:Ljava/lang/String; = "anomaly_network_disconnecting_timeout"

.field private static final KEY_ANOMALY_NETWORK_HANDOVER_TIMEOUT:Ljava/lang/String; = "anomaly_network_handover_timeout"

.field private static final KEY_ANOMALY_NETWORK_UNWANTED:Ljava/lang/String; = "anomaly_network_unwanted"

.field private static final KEY_ANOMALY_SETUP_DATA_CALL_FAILURE:Ljava/lang/String; = "anomaly_setup_data_call_failure"


# instance fields
.field private final mBandwidthMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;",
            ">;"
        }
    .end annotation
.end field

.field private mCarrierConfig:Landroid/os/PersistableBundle;

.field private final mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

.field private final mConfigUpdateRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private final mDataHandoverRetryRules:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;",
            ">;"
        }
    .end annotation
.end field

.field private final mDataSetupRetryRules:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;",
            ">;"
        }
    .end annotation
.end field

.field private final mHandoverRuleList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;",
            ">;"
        }
    .end annotation
.end field

.field private mImsReleaseRequestAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

.field protected final mLogTag:Ljava/lang/String;

.field private final mMeteredApnTypes:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private final mNetworkCapabilityPriorityMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mNetworkConnectingTimeout:I

.field private mNetworkDisconnectingTimeout:I

.field private mNetworkHandoverTimeout:I

.field private mNetworkUnwantedAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

.field protected final mPhone:Lcom/android/internal/telephony/Phone;

.field private mResources:Landroid/content/res/Resources;

.field private final mRoamingMeteredApnTypes:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private final mRoamingUnmeteredNetworkTypes:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mSetupDataCallAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

.field private final mSingleDataNetworkTypeList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private final mTcpBufferSizeMap:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private final mUnmeteredNetworkTypes:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$3nAtIoiyyE91VZMsoqtVaXOZeuE(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataConfigManager;->lambda$dump$5(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$91VTS79iztUpVcCQNL6YCsL2jkU(Ljava/lang/Integer;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->lambda$getMeteredNetworkCapabilities$1(Ljava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$N_vBsEPKT2INNIXmCrPFYc77TiE(Lcom/android/internal/telephony/data/DataConfigManager;ZLjava/lang/Integer;)Z
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataConfigManager;->lambda$isAnyMeteredCapability$2(ZLjava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$UAV30vNScrOMJMgqfsNIE25XK_8(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/String;Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataConfigManager;->lambda$dump$4(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/String;Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;)V

    return-void
.end method

.method public static synthetic $r8$lambda$kClr9uXqQ4XjRGeMlt4ADiMlgHc(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/Integer;Ljava/lang/Integer;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataConfigManager;->lambda$dump$3(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/Integer;Ljava/lang/Integer;)V

    return-void
.end method

.method public static synthetic $r8$lambda$lnTpg-os8uuijMQd0N3oDlv2fDI(Lcom/android/internal/telephony/data/DataConfigManager;Landroid/provider/DeviceConfig$Properties;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataConfigManager;->lambda$new$0(Landroid/provider/DeviceConfig$Properties;)V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)V
    .locals 4

    .line 289
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 246
    new-instance p2, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {p2}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mConfigUpdateRegistrants:Lcom/android/internal/telephony/RegistrantList;

    const/4 v0, 0x0

    .line 249
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    .line 250
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    .line 253
    new-instance v1, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v1}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkCapabilityPriorityMap:Ljava/util/Map;

    .line 256
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataSetupRetryRules:Ljava/util/List;

    .line 258
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataHandoverRetryRules:Ljava/util/List;

    .line 260
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mMeteredApnTypes:Ljava/util/Set;

    .line 262
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingMeteredApnTypes:Ljava/util/Set;

    .line 264
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mSingleDataNetworkTypeList:Ljava/util/List;

    .line 267
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mUnmeteredNetworkTypes:Ljava/util/Set;

    .line 270
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingUnmeteredNetworkTypes:Ljava/util/Set;

    .line 273
    new-instance v1, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v1}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mBandwidthMap:Ljava/util/Map;

    .line 276
    new-instance v1, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v1}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mTcpBufferSizeMap:Ljava/util/Map;

    .line 279
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mHandoverRuleList:Ljava/util/List;

    .line 290
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 291
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "DCM-"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mLogTag:Ljava/lang/String;

    const-string v1, "DataConfigManager created."

    .line 292
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataConfigManager;->log(Ljava/lang/String;)V

    .line 294
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    const-class v2, Landroid/telephony/CarrierConfigManager;

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/CarrierConfigManager;

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    .line 297
    new-instance v1, Landroid/content/IntentFilter;

    invoke-direct {v1}, Landroid/content/IntentFilter;-><init>()V

    const-string v2, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 298
    invoke-virtual {v1, v2}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 299
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/data/DataConfigManager$1;

    invoke-direct {v3, p0}, Lcom/android/internal/telephony/data/DataConfigManager$1;-><init>(Lcom/android/internal/telephony/data/DataConfigManager;)V

    invoke-virtual {v2, v3, v1, v0, p1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;

    .line 313
    new-instance p1, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda10;

    invoke-direct {p1, p0}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda10;-><init>(Lcom/android/internal/telephony/data/DataConfigManager;)V

    new-instance v0, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda11;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda11;-><init>(Lcom/android/internal/telephony/data/DataConfigManager;)V

    const-string/jumbo v1, "telephony"

    invoke-static {v1, p1, v0}, Landroid/provider/DeviceConfig;->addOnPropertiesChangedListener(Ljava/lang/String;Ljava/util/concurrent/Executor;Landroid/provider/DeviceConfig$OnPropertiesChangedListener;)V

    .line 323
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateCarrierConfig()V

    .line 324
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateDeviceConfig()V

    .line 325
    invoke-virtual {p2}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    return-void
.end method

.method public static getDataConfigNetworkType(Landroid/telephony/TelephonyDisplayInfo;)Ljava/lang/String;
    .locals 2

    .line 902
    invoke-virtual {p0}, Landroid/telephony/TelephonyDisplayInfo;->getNetworkType()I

    move-result v0

    .line 903
    invoke-virtual {p0}, Landroid/telephony/TelephonyDisplayInfo;->getOverrideNetworkType()I

    move-result p0

    const/4 v1, 0x1

    if-eq p0, v1, :cond_3

    const/4 v1, 0x2

    if-eq p0, v1, :cond_3

    const/4 v1, 0x3

    if-eq p0, v1, :cond_2

    const/4 v1, 0x5

    if-eq p0, v1, :cond_0

    .line 917
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->networkTypeToDataConfigNetworkType(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const/16 p0, 0x14

    if-ne v0, p0, :cond_1

    const-string p0, "NR_SA_MMWAVE"

    return-object p0

    :cond_1
    const-string p0, "NR_NSA_MMWAVE"

    return-object p0

    :cond_2
    const-string p0, "NR_NSA"

    return-object p0

    :cond_3
    const-string p0, "LTE_CA"

    return-object p0
.end method

.method private static synthetic lambda$dump$3(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/Integer;Ljava/lang/Integer;)V
    .locals 1

    .line 1191
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1192
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ":"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1191
    invoke-virtual {p0, p1}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    return-void
.end method

.method private static synthetic lambda$dump$4(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/String;Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;)V
    .locals 1

    .line 1221
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ":"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    return-void
.end method

.method private static synthetic lambda$dump$5(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    .line 1232
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ":"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    return-void
.end method

.method private static synthetic lambda$getMeteredNetworkCapabilities$1(Ljava/lang/Integer;)Z
    .locals 0

    .line 540
    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    if-ltz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$isAnyMeteredCapability$2(ZLjava/lang/Integer;)Z
    .locals 0

    .line 574
    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    invoke-virtual {p0, p2, p1}, Lcom/android/internal/telephony/data/DataConfigManager;->isMeteredCapability(IZ)Z

    move-result p0

    return p0
.end method

.method private synthetic lambda$new$0(Landroid/provider/DeviceConfig$Properties;)V
    .locals 1

    .line 317
    invoke-virtual {p1}, Landroid/provider/DeviceConfig$Properties;->getNamespace()Ljava/lang/String;

    move-result-object p1

    const-string/jumbo v0, "telephony"

    .line 316
    invoke-static {v0, p1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x2

    .line 318
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_0
    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 1166
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 1174
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static networkTypeToDataConfigNetworkType(I)Ljava/lang/String;
    .locals 0

    packed-switch p0, :pswitch_data_0

    const-string p0, ""

    return-object p0

    :pswitch_0
    const-string p0, "NR_SA"

    return-object p0

    :pswitch_1
    const-string p0, "LTE_CA"

    return-object p0

    :pswitch_2
    const-string p0, "IWLAN"

    return-object p0

    :pswitch_3
    const-string p0, "TD_SCDMA"

    return-object p0

    :pswitch_4
    const-string p0, "GSM"

    return-object p0

    :pswitch_5
    const-string p0, "HSPA+"

    return-object p0

    :pswitch_6
    const-string p0, "eHRPD"

    return-object p0

    :pswitch_7
    const-string p0, "LTE"

    return-object p0

    :pswitch_8
    const-string p0, "EvDo_B"

    return-object p0

    :pswitch_9
    const-string p0, "iDEN"

    return-object p0

    :pswitch_a
    const-string p0, "HSPA"

    return-object p0

    :pswitch_b
    const-string p0, "HSUPA"

    return-object p0

    :pswitch_c
    const-string p0, "HSDPA"

    return-object p0

    :pswitch_d
    const-string p0, "1xRTT"

    return-object p0

    :pswitch_e
    const-string p0, "EvDo_A"

    return-object p0

    :pswitch_f
    const-string p0, "EvDo_0"

    return-object p0

    :pswitch_10
    const-string p0, "CDMA"

    return-object p0

    :pswitch_11
    const-string p0, "UMTS"

    return-object p0

    :pswitch_12
    const-string p0, "EDGE"

    return-object p0

    :pswitch_13
    const-string p0, "GPRS"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_b
        :pswitch_a
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

.method private updateBandwidths()V
    .locals 10

    .line 655
    monitor-enter p0

    .line 656
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mBandwidthMap:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    .line 657
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v1, "bandwidth_string_array"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 659
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v2, "bandwidth_nr_nsa_use_lte_value_for_uplink_bool"

    invoke-virtual {v1, v2}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    if-eqz v0, :cond_3

    .line 662
    array-length v2, v0

    const/4 v3, 0x0

    move v4, v3

    :goto_0
    if-ge v4, v2, :cond_3

    aget-object v5, v0, v4

    const-string v6, ":"

    .line 665
    invoke-virtual {v5, v6}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v6

    .line 666
    array-length v7, v6

    const/4 v8, 0x2

    if-eq v7, v8, :cond_0

    .line 667
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Invalid bandwidth: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {p0, v5}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    goto :goto_1

    :cond_0
    const/4 v5, 0x1

    .line 672
    aget-object v7, v6, v5

    const-string v9, ","

    invoke-virtual {v7, v9}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v7

    .line 673
    array-length v9, v7

    if-eq v9, v8, :cond_1

    .line 674
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Invalid bandwidth values: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v7}, Ljava/util/Arrays;->toString([Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {p0, v5}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_1

    .line 679
    :cond_1
    :try_start_1
    aget-object v8, v7, v3

    invoke-static {v8}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v8

    .line 680
    aget-object v5, v7, v5

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5
    :try_end_1
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz v1, :cond_2

    .line 686
    :try_start_2
    aget-object v7, v6, v3

    const-string v9, "NR"

    invoke-virtual {v7, v9}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_2

    .line 689
    iget-object v5, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mBandwidthMap:Ljava/util/Map;

    const-string v7, "LTE"

    invoke-interface {v5, v7}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    iget v5, v5, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;->uplinkBandwidthKbps:I

    .line 692
    :cond_2
    iget-object v7, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mBandwidthMap:Ljava/util/Map;

    aget-object v6, v6, v3

    new-instance v9, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    invoke-direct {v9, v8, v5}, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;-><init>(II)V

    invoke-interface {v7, v6, v9}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_1

    :catch_0
    move-exception v5

    .line 682
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Exception parsing bandwidth values for network type "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v6, v6, v3

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ": "

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {p0, v5}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v4, v4, 0x1

    goto/16 :goto_0

    .line 696
    :cond_3
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw v0
.end method

.method private updateCarrierConfig()V
    .locals 2

    .line 384
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfigManager:Landroid/telephony/CarrierConfigManager;

    if-eqz v0, :cond_0

    .line 385
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    .line 387
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    if-nez v0, :cond_1

    .line 388
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    .line 390
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 391
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    .line 390
    invoke-static {v0, v1}, Landroid/telephony/SubscriptionManager;->getResourcesForSubId(Landroid/content/Context;I)Landroid/content/res/Resources;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    .line 393
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateNetworkCapabilityPriority()V

    .line 394
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateDataRetryRules()V

    .line 395
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateMeteredApnTypes()V

    .line 396
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateSingleDataNetworkTypeList()V

    .line 397
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateUnmeteredNetworkTypes()V

    .line 398
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateBandwidths()V

    .line 399
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateTcpBuffers()V

    .line 400
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateHandoverRules()V

    .line 402
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateMtkExtendConfig(Landroid/os/PersistableBundle;)V

    .line 403
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Data config updated. Config is "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->isConfigCarrierSpecific()Z

    move-result v1

    if-eqz v1, :cond_2

    const-string v1, ""

    goto :goto_0

    :cond_2
    const-string v1, "not "

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "carrier specific."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataConfigManager;->log(Ljava/lang/String;)V

    return-void
.end method

.method private updateDataRetryRules()V
    .locals 7

    .line 454
    monitor-enter p0

    .line 455
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataSetupRetryRules:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 456
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string/jumbo v1, "telephony_data_setup_retry_rules_string_array"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 459
    array-length v2, v0

    move v3, v1

    :goto_0
    if-ge v3, v2, :cond_0

    aget-object v4, v0, v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 461
    :try_start_1
    iget-object v5, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataSetupRetryRules:Ljava/util/List;

    new-instance v6, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;

    invoke-direct {v6, v4}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;-><init>(Ljava/lang/String;)V

    invoke-interface {v5, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v4

    .line 463
    :try_start_2
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v6, "updateDataRetryRules: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/IllegalArgumentException;->getMessage()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 468
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataHandoverRetryRules:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 469
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string/jumbo v2, "telephony_data_handover_retry_rules_string_array"

    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 472
    array-length v2, v0

    :goto_2
    if-ge v1, v2, :cond_1

    aget-object v3, v0, v1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 474
    :try_start_3
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataHandoverRetryRules:Ljava/util/List;

    new-instance v5, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;

    invoke-direct {v5, v3}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;-><init>(Ljava/lang/String;)V

    invoke-interface {v4, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_3
    .catch Ljava/lang/IllegalArgumentException; {:try_start_3 .. :try_end_3} :catch_1
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_3

    :catch_1
    move-exception v3

    .line 476
    :try_start_4
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v5, "updateDataRetryRules: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/IllegalArgumentException;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    :goto_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_2

    .line 480
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    throw v0
.end method

.method private updateDeviceConfig()V
    .locals 6

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/String;

    const-string/jumbo v1, "telephony"

    .line 349
    invoke-static {v1, v0}, Landroid/provider/DeviceConfig;->getProperties(Ljava/lang/String;[Ljava/lang/String;)Landroid/provider/DeviceConfig$Properties;

    move-result-object v0

    const-string v1, "anomaly_ims_release_request"

    const/4 v2, 0x0

    .line 352
    invoke-virtual {v0, v1, v2}, Landroid/provider/DeviceConfig$Properties;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-wide/16 v3, 0x0

    const/16 v5, 0xc

    .line 351
    invoke-virtual {p0, v1, v3, v4, v5}, Lcom/android/internal/telephony/data/DataConfigManager;->parseSlidingWindowCounterThreshold(Ljava/lang/String;JI)Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mImsReleaseRequestAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    const-string v1, "anomaly_network_unwanted"

    .line 356
    invoke-virtual {v0, v1, v2}, Landroid/provider/DeviceConfig$Properties;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 355
    invoke-virtual {p0, v1, v3, v4, v5}, Lcom/android/internal/telephony/data/DataConfigManager;->parseSlidingWindowCounterThreshold(Ljava/lang/String;JI)Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkUnwantedAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    const-string v1, "anomaly_setup_data_call_failure"

    .line 360
    invoke-virtual {v0, v1, v2}, Landroid/provider/DeviceConfig$Properties;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x2

    .line 359
    invoke-virtual {p0, v1, v3, v4, v2}, Lcom/android/internal/telephony/data/DataConfigManager;->parseSlidingWindowCounterThreshold(Ljava/lang/String;JI)Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mSetupDataCallAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    const-string v1, "anomaly_network_connecting_timeout"

    const v2, 0x493e0

    .line 363
    invoke-virtual {v0, v1, v2}, Landroid/provider/DeviceConfig$Properties;->getInt(Ljava/lang/String;I)I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkConnectingTimeout:I

    const-string v1, "anomaly_network_disconnecting_timeout"

    .line 365
    invoke-virtual {v0, v1, v2}, Landroid/provider/DeviceConfig$Properties;->getInt(Ljava/lang/String;I)I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkDisconnectingTimeout:I

    const-string v1, "anomaly_network_handover_timeout"

    .line 368
    invoke-virtual {v0, v1, v2}, Landroid/provider/DeviceConfig$Properties;->getInt(Ljava/lang/String;I)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkHandoverTimeout:I

    return-void
.end method

.method private updateHandoverRules()V
    .locals 6

    .line 923
    monitor-enter p0

    .line 924
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mHandoverRuleList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 925
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v1, "iwlan_handover_policy_string_array"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 928
    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget-object v3, v0, v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 930
    :try_start_1
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mHandoverRuleList:Ljava/util/List;

    new-instance v5, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;

    invoke-direct {v5, v3}, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;-><init>(Ljava/lang/String;)V

    invoke-interface {v4, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v3

    .line 932
    :try_start_2
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v5, "updateHandoverRules: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/IllegalArgumentException;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 936
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw v0
.end method

.method private updateMeteredApnTypes()V
    .locals 3

    .line 509
    monitor-enter p0

    .line 510
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mMeteredApnTypes:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    .line 511
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v1, "carrier_metered_apn_types_strings"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 514
    invoke-static {v0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda12;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda12;-><init>()V

    .line 515
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mMeteredApnTypes:Ljava/util/Set;

    .line 516
    invoke-static {v1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v2, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda13;

    invoke-direct {v2, v1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda13;-><init>(Ljava/util/Set;)V

    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 518
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingMeteredApnTypes:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    .line 519
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v1, "carrier_metered_roaming_apn_types_strings"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 522
    invoke-static {v0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda12;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda12;-><init>()V

    .line 523
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingMeteredApnTypes:Ljava/util/Set;

    .line 524
    invoke-static {v1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v2, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda13;

    invoke-direct {v2, v1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda13;-><init>(Ljava/util/Set;)V

    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 526
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private updateNetworkCapabilityPriority()V
    .locals 8

    .line 411
    monitor-enter p0

    .line 412
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkCapabilityPriorityMap:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    .line 413
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string/jumbo v1, "telephony_network_capability_priorities_string_array"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 416
    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, v0, v3

    .line 417
    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v4

    const-string v5, ":"

    .line 418
    invoke-virtual {v4, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    .line 419
    array-length v6, v5

    const/4 v7, 0x2

    if-eq v6, v7, :cond_0

    .line 420
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Invalid config \""

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "\""

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    goto :goto_1

    .line 424
    :cond_0
    aget-object v6, v5, v2

    invoke-static {v6}, Lcom/android/internal/telephony/data/DataUtils;->getNetworkCapabilityFromString(Ljava/lang/String;)I

    move-result v6

    if-gez v6, :cond_1

    .line 426
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Invalid config \""

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "\""

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    goto :goto_1

    :cond_1
    const/4 v4, 0x1

    .line 430
    aget-object v4, v5, v4

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    .line 431
    iget-object v5, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkCapabilityPriorityMap:Ljava/util/Map;

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {v5, v6, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 434
    :cond_2
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private updateSingleDataNetworkTypeList()V
    .locals 3

    .line 589
    monitor-enter p0

    .line 590
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mSingleDataNetworkTypeList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 591
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v1, "only_single_dc_allowed_int_array"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v0

    if-eqz v0, :cond_0

    .line 594
    invoke-static {v0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mSingleDataNetworkTypeList:Ljava/util/List;

    .line 595
    invoke-static {v1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v2, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda0;

    invoke-direct {v2, v1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda0;-><init>(Ljava/util/List;)V

    invoke-interface {v0, v2}, Ljava/util/stream/IntStream;->forEach(Ljava/util/function/IntConsumer;)V

    .line 597
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private updateTcpBuffers()V
    .locals 8

    .line 742
    monitor-enter p0

    .line 743
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mTcpBufferSizeMap:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    .line 744
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    const v1, 0x1070084

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 747
    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, v0, v3

    const-string v5, ":"

    .line 750
    invoke-virtual {v4, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    .line 751
    array-length v6, v5

    const/4 v7, 0x2

    if-eq v6, v7, :cond_0

    .line 752
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Invalid TCP buffer sizes entry: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    goto :goto_1

    :cond_0
    const/4 v4, 0x1

    .line 755
    aget-object v6, v5, v4

    const-string v7, ","

    invoke-virtual {v6, v7}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v6

    array-length v6, v6

    const/4 v7, 0x6

    if-eq v6, v7, :cond_1

    .line 756
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Invalid TCP buffer sizes for "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v7, v5, v2

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, ": "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v4, v5, v4

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    goto :goto_1

    .line 759
    :cond_1
    iget-object v6, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mTcpBufferSizeMap:Ljava/util/Map;

    aget-object v7, v5, v2

    aget-object v4, v5, v4

    invoke-interface {v6, v7, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 762
    :cond_2
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private updateUnmeteredNetworkTypes()V
    .locals 2

    .line 620
    monitor-enter p0

    .line 621
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mUnmeteredNetworkTypes:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    .line 622
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string/jumbo v1, "unmetered_network_types_string_array"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 625
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mUnmeteredNetworkTypes:Ljava/util/Set;

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v1, v0}, Ljava/util/Set;->addAll(Ljava/util/Collection;)Z

    .line 627
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingUnmeteredNetworkTypes:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    .line 628
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v1, "roaming_unmetered_network_types_string_array"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 631
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingUnmeteredNetworkTypes:Ljava/util/Set;

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v1, v0}, Ljava/util/Set;->addAll(Ljava/util/Collection;)Z

    .line 633
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 1185
    new-instance p1, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p3, "  "

    invoke-direct {p1, p2, p3}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 1186
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-class p3, Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {p3}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p3, "-"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p3}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, ":"

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1187
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1188
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "isConfigCarrierSpecific="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->isConfigCarrierSpecific()Z

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Network capability priority:"

    .line 1189
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1190
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1191
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkCapabilityPriorityMap:Ljava/util/Map;

    new-instance p3, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda3;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V

    invoke-interface {p2, p3}, Ljava/util/Map;->forEach(Ljava/util/function/BiConsumer;)V

    .line 1193
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1194
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->println()V

    const-string p2, "Data setup retry rules:"

    .line 1195
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1196
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1197
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataSetupRetryRules:Ljava/util/List;

    new-instance p3, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda4;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda4;-><init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V

    invoke-interface {p2, p3}, Ljava/util/List;->forEach(Ljava/util/function/Consumer;)V

    .line 1198
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1199
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "isIwlanHandoverPolicyEnabled="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->isIwlanHandoverPolicyEnabled()Z

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Data handover retry rules:"

    .line 1200
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1201
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1202
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataHandoverRetryRules:Ljava/util/List;

    new-instance p3, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda5;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V

    invoke-interface {p2, p3}, Ljava/util/List;->forEach(Ljava/util/function/Consumer;)V

    .line 1203
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1204
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mSetupDataCallAnomalyReport="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mSetupDataCallAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1205
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mNetworkUnwantedAnomalyReport="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkUnwantedAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1206
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mImsReleaseRequestAnomalyReport="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mImsReleaseRequestAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1207
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mNetworkConnectingTimeout="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkConnectingTimeout:I

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1208
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mNetworkDisconnectingTimeout="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkDisconnectingTimeout:I

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1209
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "mNetworkHandoverTimeout="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkHandoverTimeout:I

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1210
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Metered APN types="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mMeteredApnTypes:Ljava/util/Set;

    invoke-interface {p3}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p3

    new-instance v0, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda6;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda6;-><init>()V

    .line 1211
    invoke-interface {p3, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p3

    const-string v0, ","

    invoke-static {v0}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {p3, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Ljava/lang/String;

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 1210
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1212
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Roaming metered APN types="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingMeteredApnTypes:Ljava/util/Set;

    invoke-interface {p3}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p3

    new-instance v1, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda6;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda6;-><init>()V

    .line 1213
    invoke-interface {p3, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p3

    invoke-static {v0}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {p3, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Ljava/lang/String;

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 1212
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1214
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Single data network types="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mSingleDataNetworkTypeList:Ljava/util/List;

    invoke-interface {p3}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p3

    new-instance v1, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda7;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda7;-><init>()V

    .line 1215
    invoke-interface {p3, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p3

    invoke-static {v0}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {p3, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p3

    check-cast p3, Ljava/lang/String;

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 1214
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1216
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Unmetered network types="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mUnmeteredNetworkTypes:Ljava/util/Set;

    invoke-static {v0, p3}, Ljava/lang/String;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1217
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Roaming unmetered network types="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingUnmeteredNetworkTypes:Ljava/util/Set;

    .line 1218
    invoke-static {v0, p3}, Ljava/lang/String;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 1217
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Bandwidths:"

    .line 1219
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1220
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1221
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mBandwidthMap:Ljava/util/Map;

    new-instance p3, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda8;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda8;-><init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V

    invoke-interface {p2, p3}, Ljava/util/Map;->forEach(Ljava/util/function/BiConsumer;)V

    .line 1222
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1223
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p3, "shouldUseDataActivityForRrcDetection="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1224
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->shouldUseDataActivityForRrcDetection()Z

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 1223
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1225
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "isTempNotMeteredSupportedByCarrier="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->isTempNotMeteredSupportedByCarrier()Z

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1226
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p3, "shouldResetDataThrottlingWhenTacChanges="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1227
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->shouldResetDataThrottlingWhenTacChanges()Z

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 1226
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1228
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Data service package name="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->getDataServicePackageName()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1229
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Default MTU="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->getDefaultMtu()I

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "TCP buffer sizes by RAT:"

    .line 1230
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1231
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1232
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mTcpBufferSizeMap:Ljava/util/Map;

    new-instance p3, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda9;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda9;-><init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V

    invoke-interface {p2, p3}, Ljava/util/Map;->forEach(Ljava/util/function/BiConsumer;)V

    .line 1233
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1234
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Default TCP buffer sizes="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->getDefaultTcpConfigString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1235
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "getImsDeregistrationDelay="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->getImsDeregistrationDelay()J

    move-result-wide v0

    invoke-virtual {p2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1236
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p3, "shouldPersistIwlanDataNetworksWhenDataServiceRestarted="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1237
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->shouldPersistIwlanDataNetworksWhenDataServiceRestarted()Z

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 1236
    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1238
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Bandwidth estimation source="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p3, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    const v0, 0x104020f

    invoke-virtual {p3, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1240
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "isDelayTearDownImsEnabled="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->isImsDelayTearDownEnabled()Z

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1241
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "isEnhancedIwlanHandoverCheckEnabled="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->isEnhancedIwlanHandoverCheckEnabled()Z

    move-result p3

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1242
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "isTetheringProfileDisabledForRoaming="

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1243
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->isTetheringProfileDisabledForRoaming()Z

    move-result p0

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 1242
    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1244
    invoke-virtual {p1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-void
.end method

.method public getAllowedInitialAttachApnTypes()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 1120
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "allowed_initial_attach_apn_types_string_array"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 1123
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda1;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda1;-><init>()V

    .line 1124
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 1125
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    return-object p0

    .line 1128
    :cond_0
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public getAnomalyImsReleaseRequestThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;
    .locals 0

    .line 787
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mImsReleaseRequestAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    return-object p0
.end method

.method public getAnomalyNetworkConnectingTimeoutMs()I
    .locals 0

    .line 795
    iget p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkConnectingTimeout:I

    return p0
.end method

.method public getAnomalyNetworkDisconnectingTimeoutMs()I
    .locals 0

    .line 803
    iget p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkDisconnectingTimeout:I

    return p0
.end method

.method public getAnomalyNetworkUnwantedThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;
    .locals 0

    .line 779
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkUnwantedAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    return-object p0
.end method

.method public getAnomalySetupDataCallThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;
    .locals 0

    .line 770
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mSetupDataCallAnomalyReportThreshold:Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    return-object p0
.end method

.method public getBandwidthEstimateSource()I
    .locals 6
    .annotation build Lcom/android/internal/telephony/data/DataNetwork$BandwidthEstimationSource;
    .end annotation

    .line 878
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    const v1, 0x104020f

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object v0

    .line 880
    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v1

    const/4 v2, 0x2

    const/4 v3, 0x1

    const/4 v4, 0x0

    const/4 v5, -0x1

    sparse-switch v1, :sswitch_data_0

    goto :goto_0

    :sswitch_0
    const-string v1, "bandwidth_estimator"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    goto :goto_0

    :cond_0
    move v5, v2

    goto :goto_0

    :sswitch_1
    const-string v1, "modem"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1

    goto :goto_0

    :cond_1
    move v5, v3

    goto :goto_0

    :sswitch_2
    const-string v1, "carrier_config"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    goto :goto_0

    :cond_2
    move v5, v4

    :goto_0
    packed-switch v5, :pswitch_data_0

    .line 888
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Invalid bandwidth estimation source config: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    return v4

    :pswitch_0
    const/4 p0, 0x3

    return p0

    :pswitch_1
    return v3

    :pswitch_2
    return v2

    :sswitch_data_0
    .sparse-switch
        -0x488da597 -> :sswitch_2
        0x633fb2a -> :sswitch_1
        0xc19d372 -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public getBandwidthForNetworkType(Landroid/telephony/TelephonyDisplayInfo;)Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;
    .locals 0

    .line 707
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mBandwidthMap:Ljava/util/Map;

    .line 708
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataConfigManager;->getDataConfigNetworkType(Landroid/telephony/TelephonyDisplayInfo;)Ljava/lang/String;

    move-result-object p1

    .line 707
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    if-eqz p0, :cond_0

    return-object p0

    .line 712
    :cond_0
    new-instance p0, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    const/16 p1, 0xe

    invoke-direct {p0, p1, p1}, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;-><init>(II)V

    return-object p0
.end method

.method public getDataHandoverRetryRules()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;",
            ">;"
        }
    .end annotation

    .line 494
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataHandoverRetryRules:Ljava/util/List;

    invoke-static {p0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public getDataServicePackageName()Ljava/lang/String;
    .locals 1

    .line 727
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "carrier_data_service_wwan_package_override_string"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getDataSetupRetryRules()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;",
            ">;"
        }
    .end annotation

    .line 487
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mDataSetupRetryRules:Ljava/util/List;

    invoke-static {p0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public getDataStallRecoveryDelayMillis()[J
    .locals 1

    .line 1082
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "data_stall_recovery_timers_long_array"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getLongArray(Ljava/lang/String;)[J

    move-result-object p0

    return-object p0
.end method

.method public getDataStallRecoveryShouldSkipArray()[Z
    .locals 1

    .line 1092
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "data_stall_recovery_should_skip_bool_array"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getBooleanArray(Ljava/lang/String;)[Z

    move-result-object p0

    return-object p0
.end method

.method public getDefaultMtu()I
    .locals 1

    .line 735
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "default_mtu_int"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method public getDefaultPreferredApn()Ljava/lang/String;
    .locals 1

    .line 1101
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "default_preferred_apn_name_string"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Landroid/text/TextUtils;->emptyIfNull(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getDefaultTcpConfigString()Ljava/lang/String;
    .locals 1

    .line 835
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    const v0, 0x10402b3

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getHandoverRules()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;",
            ">;"
        }
    .end annotation

    .line 1011
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mHandoverRuleList:Ljava/util/List;

    invoke-static {p0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public getImsDeregistrationDelay()J
    .locals 2

    .line 843
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    const v0, 0x10e0055

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getInteger(I)I

    move-result p0

    int-to-long v0, p0

    return-wide v0
.end method

.method public getMeteredNetworkCapabilities(Z)Ljava/util/Set;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(Z)",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    if-eqz p1, :cond_0

    .line 537
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingMeteredApnTypes:Ljava/util/Set;

    goto :goto_0

    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mMeteredApnTypes:Ljava/util/Set;

    .line 538
    :goto_0
    invoke-interface {p0}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance p1, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda14;

    invoke-direct {p1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda14;-><init>()V

    .line 539
    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance p1, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda15;

    invoke-direct {p1}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda15;-><init>()V

    .line 540
    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 541
    invoke-static {}, Ljava/util/stream/Collectors;->toUnmodifiableSet()Ljava/util/stream/Collector;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Set;

    return-object p0
.end method

.method public getNetworkCapabilityPriority(I)I
    .locals 2

    .line 444
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkCapabilityPriorityMap:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 445
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkCapabilityPriorityMap:Ljava/util/Map;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public getNetworkHandoverTimeoutMs()I
    .locals 0

    .line 811
    iget p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mNetworkHandoverTimeout:I

    return p0
.end method

.method public getNetworkTypesOnlySupportSingleDataNetwork()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 604
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mSingleDataNetworkTypeList:Ljava/util/List;

    invoke-static {p0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public getNrAdvancedCapablePcoId()I
    .locals 1

    .line 1110
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "nr_advanced_capable_pco_id_int"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method public getRetrySetupAfterDisconnectMillis()J
    .locals 2

    .line 1018
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "carrier_data_call_apn_retry_after_disconnect_long"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getLong(Ljava/lang/String;)J

    move-result-wide v0

    return-wide v0
.end method

.method public getTcpConfigString(Landroid/telephony/TelephonyDisplayInfo;)Ljava/lang/String;
    .locals 1

    .line 824
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mTcpBufferSizeMap:Ljava/util/Map;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataConfigManager;->getDataConfigNetworkType(Landroid/telephony/TelephonyDisplayInfo;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    .line 825
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 826
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->getDefaultTcpConfigString()Ljava/lang/String;

    move-result-object p1

    :cond_0
    return-object p1
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 330
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_1

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    .line 342
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected message "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const-string p1, "EVENT_DEVICE_CONFIG_CHANGED"

    .line 337
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataConfigManager;->log(Ljava/lang/String;)V

    .line 338
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateDeviceConfig()V

    .line 339
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mConfigUpdateRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    goto :goto_0

    :cond_1
    const-string p1, "EVENT_CARRIER_CONFIG_CHANGED"

    .line 332
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataConfigManager;->log(Ljava/lang/String;)V

    .line 333
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->updateCarrierConfig()V

    .line 334
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mConfigUpdateRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :goto_0
    return-void
.end method

.method public isAnyMeteredCapability([IZ)Z
    .locals 1

    .line 573
    invoke-static {p1}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda2;

    invoke-direct {v0, p0, p2}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/DataConfigManager;Z)V

    .line 574
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0
.end method

.method public isConfigCarrierSpecific()Z
    .locals 1

    .line 377
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "carrier_config_applied_bool"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public isDataRoamingEnabledByDefault()Z
    .locals 1

    .line 501
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "carrier_default_data_roaming_enabled_bool"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public isEnhancedIwlanHandoverCheckEnabled()Z
    .locals 1

    .line 1139
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    const v0, 0x111014e

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result p0

    return p0
.end method

.method public isImsDelayTearDownEnabled()Z
    .locals 1

    .line 870
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "delay_ims_tear_down_until_call_end_bool"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public isIwlanHandoverPolicyEnabled()Z
    .locals 1

    .line 861
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    const v0, 0x111014b

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result p0

    return p0
.end method

.method public isMeteredCapability(IZ)Z
    .locals 0

    .line 560
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataConfigManager;->getMeteredNetworkCapabilities(Z)Ljava/util/Set;

    move-result-object p0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method public isNetworkTypeUnmetered(Landroid/telephony/TelephonyDisplayInfo;Landroid/telephony/ServiceState;)Z
    .locals 0

    .line 645
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataConfigManager;->getDataConfigNetworkType(Landroid/telephony/TelephonyDisplayInfo;)Ljava/lang/String;

    move-result-object p1

    .line 646
    invoke-virtual {p2}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result p2

    if-eqz p2, :cond_0

    .line 647
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mRoamingUnmeteredNetworkTypes:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p0

    goto :goto_0

    .line 648
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mUnmeteredNetworkTypes:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p0

    :goto_0
    return p0
.end method

.method public isTempNotMeteredSupportedByCarrier()Z
    .locals 1

    .line 612
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "network_temp_not_metered_supported_bool"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public isTetheringProfileDisabledForRoaming()Z
    .locals 1

    .line 548
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "disable_dun_apn_while_roaming_with_preset_apn_bool"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public parseSlidingWindowCounterThreshold(Ljava/lang/String;JI)Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const-string v0, ": "

    .line 978
    new-instance v1, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    invoke-direct {v1, p2, p3, p4}, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;-><init>(JI)V

    .line 979
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p2

    if-eqz p2, :cond_0

    return-object v1

    :cond_0
    const-string p2, ","

    .line 981
    invoke-virtual {p1, p2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p2

    .line 982
    array-length p3, p2

    const/4 p4, 0x2

    if-eq p3, p4, :cond_1

    .line 983
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Invalid format: "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "Format should be in \"time window in ms,occurrences\". Using default instead."

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    return-object v1

    :cond_1
    const/4 p1, 0x0

    .line 991
    :try_start_0
    aget-object p3, p2, p1

    invoke-virtual {p3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p3

    invoke-static {p3}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide p3
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_1

    const/4 p1, 0x1

    .line 997
    :try_start_1
    aget-object v2, p2, p1

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_1
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_1} :catch_0

    .line 1002
    new-instance p1, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    invoke-direct {p1, p3, p4, p0}, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;-><init>(JI)V

    return-object p1

    :catch_0
    move-exception p3

    .line 999
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Exception parsing SlidingWindow occurrence as integer "

    invoke-virtual {p4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object p1, p2, p1

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    return-object v1

    :catch_1
    move-exception p3

    .line 993
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Exception parsing SlidingWindow window span "

    invoke-virtual {p4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object p1, p2, p1

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataConfigManager;->loge(Ljava/lang/String;)V

    return-object v1
.end method

.method public registerForConfigUpdate(Landroid/os/Handler;I)V
    .locals 1

    .line 1150
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mConfigUpdateRegistrants:Lcom/android/internal/telephony/RegistrantList;

    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, v0}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public shouldPersistIwlanDataNetworksWhenDataServiceRestarted()Z
    .locals 1

    .line 852
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mResources:Landroid/content/res/Resources;

    const v0, 0x1110207

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result p0

    return p0
.end method

.method public shouldResetDataThrottlingWhenTacChanges()Z
    .locals 1

    .line 719
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string/jumbo v0, "unthrottle_data_retry_when_tac_changes_bool"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public shouldUseDataActivityForRrcDetection()Z
    .locals 1

    .line 581
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mCarrierConfig:Landroid/os/PersistableBundle;

    const-string v0, "lte_endc_using_user_data_for_rrc_detection_bool"

    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public unregisterForConfigUpdate(Landroid/os/Handler;)V
    .locals 0

    .line 1158
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataConfigManager;->mConfigUpdateRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method protected updateMtkExtendConfig(Landroid/os/PersistableBundle;)V
    .locals 0

    return-void
.end method
