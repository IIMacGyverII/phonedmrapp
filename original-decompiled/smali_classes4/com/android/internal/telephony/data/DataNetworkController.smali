.class public Lcom/android/internal/telephony/data/DataNetworkController;
.super Landroid/os/Handler;
.source "DataNetworkController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;,
        Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;,
        Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;
    }
.end annotation


# static fields
.field private static final EVENT_ADD_NETWORK_REQUEST:I = 0x2

.field private static final EVENT_DATA_CONFIG_UPDATED:I = 0x1

.field private static final EVENT_DATA_SERVICE_BINDING_CHANGED:I = 0x8

.field private static final EVENT_EMERGENCY_CALL_CHANGED:I = 0x14

.field private static final EVENT_EVALUATE_PREFERRED_TRANSPORT:I = 0x15

.field private static final EVENT_PS_RESTRICT_DISABLED:I = 0x7

.field private static final EVENT_PS_RESTRICT_ENABLED:I = 0x6

.field protected static final EVENT_REEVALUATE_EXISTING_DATA_NETWORKS:I = 0x10

.field protected static final EVENT_REEVALUATE_UNSATISFIED_NETWORK_REQUESTS:I = 0x5

.field private static final EVENT_REGISTER_ALL_EVENTS:I = 0x13

.field private static final EVENT_REGISTER_DATA_NETWORK_CONTROLLER_CALLBACK:I = 0xd

.field private static final EVENT_REMOVE_NETWORK_REQUEST:I = 0x3

.field protected static final EVENT_SERVICE_STATE_CHANGED:I = 0x11

.field private static final EVENT_SIM_STATE_CHANGED:I = 0x9

.field private static final EVENT_SLICE_CONFIG_CHANGED:I = 0x18

.field private static final EVENT_SUBSCRIPTION_CHANGED:I = 0xf

.field private static final EVENT_SUBSCRIPTION_OVERRIDE:I = 0x17

.field private static final EVENT_SUBSCRIPTION_PLANS_CHANGED:I = 0x16

.field private static final EVENT_TAC_CHANGED:I = 0x19

.field private static final EVENT_TEAR_DOWN_ALL_DATA_NETWORKS:I = 0xc

.field private static final EVENT_UNREGISTER_DATA_NETWORK_CONTROLLER_CALLBACK:I = 0xe

.field private static final EVENT_VOICE_CALL_ENDED:I = 0x12

.field private static final MAX_HISTORICAL_CONNECTED_DATA_NETWORKS:I = 0xa

.field private static final REEVALUATE_PREFERRED_TRANSPORT_DELAY_MILLIS:J

.field private static final REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_AFTER_CALL_END_DELAY_MILLIS:J

.field private static final REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_TAC_CHANGED_DELAY_MILLIS:J

.field private static final SUPPORTED_IMS_FEATURES:Ljava/util/Collection;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Collection<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static final VDBG:Z = false


# instance fields
.field private final mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

.field protected final mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

.field protected mAnyDataNetworkExisting:Z

.field private final mCongestedOverrideNetworkTypes:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mDataActivity:I

.field protected final mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

.field private final mDataNetworkControllerCallbacks:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;",
            ">;"
        }
    .end annotation
.end field

.field protected final mDataNetworkList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataNetwork;",
            ">;"
        }
    .end annotation
.end field

.field protected final mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

.field protected final mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

.field private final mDataServiceBound:Landroid/util/SparseBooleanArray;

.field protected final mDataServiceManagers:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/data/DataServiceManager;",
            ">;"
        }
    .end annotation
.end field

.field protected final mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

.field private final mDataStallRecoveryManager:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

.field private mImsDataNetworkState:I

.field private final mImsFeaturePackageName:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private final mImsFeatureRegistrationCallbacks:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Landroid/telephony/ims/RegistrationManager$RegistrationCallback;",
            ">;"
        }
    .end annotation
.end field

.field private final mImsManager:Landroid/telephony/ims/ImsManager;

.field private final mImsStateCallbacks:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Landroid/telephony/ims/ImsStateCallback;",
            ">;"
        }
    .end annotation
.end field

.field protected mImsThrottleCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

.field private final mIntentReceiver:Landroid/content/BroadcastReceiver;

.field private mInternetDataNetworkState:I

.field private mInternetLinkStatus:I

.field private mLastImsOperationIsRelease:Z

.field protected mLastReleasedImsRequestCapabilities:[I

.field protected final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field protected final mLogTag:Ljava/lang/String;

.field private final mNetworkPolicyManager:Landroid/net/NetworkPolicyManager;

.field private mNetworkUnwantedCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

.field private mNrAdvancedCapableByPco:Z

.field private final mPendingImsDeregDataNetworks:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/android/internal/telephony/data/DataNetwork;",
            "Ljava/lang/Runnable;",
            ">;"
        }
    .end annotation
.end field

.field private mPendingTearDownAllNetworks:Z

.field protected final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mPreviousConnectedDataNetworkList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataNetwork;",
            ">;"
        }
    .end annotation
.end field

.field private mPsRestricted:Z

.field private final mRegisteredImsFeatures:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mServiceState:Landroid/telephony/ServiceState;

.field private mSetupDataCallWlanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

.field private mSetupDataCallWwanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

.field private mSimState:I
    .annotation build Landroid/telephony/TelephonyManager$SimState;
    .end annotation
.end field

.field private mSubId:I

.field private final mSubscriptionPlans:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/SubscriptionPlan;",
            ">;"
        }
    .end annotation
.end field

.field private final mUnmeteredOverrideNetworkTypes:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$-R23QDW-58DLpDeDIwN0BQaIaIE(ILcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkValidationStatusChanged$29(ILcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$-SuuOxYqvrclJkrZTiWO2ha8N0w(ILcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataServiceBindingChanged$37(ILcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$0OCNNWKwCSf1XhnEAGa3xz7MoHg(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkDisconnected$32(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$31OS2ve1HHEAwmGMaVD27HeeorI(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$isNetworkInterfaceExisting$17(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$3Iqrl82Kfp3Xq3I-StrAXMBLOwQ(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onLinkStatusChanged$41(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$3iALmEUoe-rUpbDz7K9JNe9rLww(Lcom/android/internal/telephony/data/DataNetworkController;ILjava/lang/Integer;)Landroid/telephony/ims/ImsStateCallback;
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$registerImsStateCallback$19(ILjava/lang/Integer;)Landroid/telephony/ims/ImsStateCallback;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$74xT2SwUsKvZ79amfupcI6o3q8g(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkSetupRetry$27(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$9IcElcwJYqZbIVSPOEtJF1BZS6c(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkSetupFailed$25(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$EsrTjp28NYZP65pMI6Ym7E1j5Ak(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$handleMessage$2(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$FXnn2OVx8fqz2q5JAePTNPZmsJg(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$updateOverallInternetDataState$44(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$HoUPwza6sh-jMfBOzAiOTysU4Dg(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onTearDownAllDataNetworks$49(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$JNZe5psruNuLl5Gw3fsqsHv9Cis(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$setupDataNetwork$22(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$JlTPNbCmv3Ht5GArIbHJ33L1tdU(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$evaluateDataNetwork$11(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$KgaFjlslTyNwFdtFlV8AWIIJ4iI(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$isDataDormant$15(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$KgqeOyHk45dV48NLA_pUMyuuEf0(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataStallReestablishInternet$35(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method public static synthetic $r8$lambda$LbJeXKI3DVv-KMJpnoN3GrJ3vTQ(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onLinkStatusChanged$40(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$LkPN79FFYEv_ihVsYqBiEEvAl6Q(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onPcoDataChanged$43(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$MDndwg3maXxX1PV5vZguNBDHKVg(Ljava/lang/String;Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$isNetworkInterfaceExisting$18(Ljava/lang/String;Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$MvJmLluqs0RtFvjKGRj2pKoK3dw(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkSetupFailed$24(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$NWUvbLGKiBATI8Pu_YszkxoHJ-c(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onLinkStatusChanged$38(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$O4VJnSQ3zAkdytOrGOwUZE4FlW0(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$isDataDormant$14(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$OU4PBrK365wFU-47zcaPdXZqd-E(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$evaluateNetworkRequest$9(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$OtabJsONkZ8CUtmDtpOoYsvCDfw(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$isInternetUnmetered$8(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$PMDA3WBxr1TSG6NoyefwJMMx32M(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onTearDownAllDataNetworks$50(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Q3bkTh3C2lh2rI33MvfrNRVeyyE(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$handleMessage$0(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Q8azSqKOdsB7ddwDOP6Wb6eWX-o(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onPcoDataChanged$42(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$QAGDFZhPQy7bP56j8_ow4puDM5M(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$evaluateDataNetwork$12(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$R5sAOgUG1WDp7nblAz6wrST2C7I(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$setupDataNetwork$23(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$SFu2iUGIqVgANzB68PWXn8H2CFg(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$updateOverallInternetDataState$48(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$TK2zIR-w_SgXGQ98ESjNvylYPn4(Ljava/util/List;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$updateOverallInternetDataState$47(Ljava/util/List;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Vq4HAFmS7MfspPHuPecz-al-tDg(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$evaluateDataNetworkHandover$13(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$aT6itP5UiecmxevR68UrgNvR2VA(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkDisconnected$31(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$bQgqv1IX9vGuJ8P7Xn-Uh3GAb1Q(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkSetupFailed$26(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$cxjnJGHqCz6erSvEquHw2Wgexsc(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkDisconnected$30(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$d2ACK5YEGYsn5PWNZngkrcxnOWI(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$updateOverallInternetDataState$45(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$dABW_dXIMJSrWhcxMzPjWMzlgU8(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$handleMessage$5(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$dQLHqvNwyaMsm7SVJgSjAOquYXk(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$isInternetUnmetered$7(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$ftmIaMyfEaDXwf1obA9zdCRVeUY(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$handleMessage$3(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$hLx6XDeVh_lD7U18KQ6IBj2FIXM(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$findCompatibleDataNetworkAndAttach$6(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$hPJPb3mOOjMahdJcKwXsWRVeMas(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkDisconnected$34(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$hegWB4rqNjmjIKaAjYJURjXI8-0(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;Ljava/util/List;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$updateOverallInternetDataState$46(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;Ljava/util/List;)V

    return-void
.end method

.method public static synthetic $r8$lambda$i8JAxyWMq3yImPldIcV0LavIGCQ(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$handleMessage$4(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$jucMnvz8sJeDsTshPwqeGEurjJU(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$findSatisfiableNetworkRequests$21(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$mXq3iUCrwVbD1cMa3hSF95y54LQ(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;I)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkValidationStatusChanged$28(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$nK1LUploLg5NI3rrXIQs_dMA0wE(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onRemoveNetworkRequest$16(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$pjpCpBc3xvnfvTuh-qMGs6QGUx0(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataNetworkDisconnected$33(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$pnexJ5vLouhlUmmtjlkbTWlzZY0(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$findSatisfiableNetworkRequests$20(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$uZ8VbQ33nAtY5tbPSYZyv8DszXQ(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$handleMessage$1(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$xtwlDLEvHt1UZmhRgjAIQH-mqYs(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;I)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onDataServiceBindingChanged$36(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$yhx4yC6wMc3qn9ijbcRcg6G0qOo(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onReevaluateUnsatisfiedNetworkRequests$10(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$zwzK7yk4ZIxwtBf0-kMvVVrjImg(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->lambda$onLinkStatusChanged$39(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmAccessNetworksManager(Lcom/android/internal/telephony/data/DataNetworkController;)Lcom/android/internal/telephony/data/AccessNetworksManager;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmImsFeaturePackageName(Lcom/android/internal/telephony/data/DataNetworkController;)Landroid/util/SparseArray;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsFeaturePackageName:Landroid/util/SparseArray;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRegisteredImsFeatures(Lcom/android/internal/telephony/data/DataNetworkController;)Ljava/util/Set;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mRegisteredImsFeatures:Ljava/util/Set;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSubId(Lcom/android/internal/telephony/data/DataNetworkController;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$mevaluatePendingImsDeregDataNetworks(Lcom/android/internal/telephony/data/DataNetworkController;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->evaluatePendingImsDeregDataNetworks()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mlog(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monAttachNetworkRequestsFailed(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->onAttachNetworkRequestsFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataNetworkConnected(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataNetworkConnected(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataNetworkDisconnected(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataNetworkDisconnected(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataNetworkHandoverFailed(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;IJI)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataNetworkHandoverFailed(Lcom/android/internal/telephony/data/DataNetwork;IJI)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataNetworkHandoverRetry(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataNetworkHandoverRetry(Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataNetworkHandoverSucceeded(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataNetworkHandoverSucceeded(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataNetworkSetupFailed(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataNetworkSetupFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataNetworkSetupRetry(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataNetworkSetupRetry(Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataNetworkSuspendedStateChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;Z)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataNetworkSuspendedStateChanged(Lcom/android/internal/telephony/data/DataNetwork;Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataNetworkValidationStatusChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;ILandroid/net/Uri;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataNetworkValidationStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;ILandroid/net/Uri;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataStallReestablishInternet(Lcom/android/internal/telephony/data/DataNetworkController;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataStallReestablishInternet()V

    return-void
.end method

.method static bridge synthetic -$$Nest$monEvaluatePreferredTransport(Lcom/android/internal/telephony/data/DataNetworkController;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onEvaluatePreferredTransport(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monLinkStatusChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->onLinkStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monNetworkCapabilitiesChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onNetworkCapabilitiesChanged(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monPcoDataChanged(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onPcoDataChanged(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monTrackNetworkUnwanted(Lcom/android/internal/telephony/data/DataNetworkController;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->onTrackNetworkUnwanted()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mregisterImsFeatureRegistrationState(Lcom/android/internal/telephony/data/DataNetworkController;II)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->registerImsFeatureRegistrationState(II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtearDownGracefully(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->tearDownGracefully(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$munregisterImsFeatureRegistrationState(Lcom/android/internal/telephony/data/DataNetworkController;II)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->unregisterImsFeatureRegistrationState(II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateDataActivity(Lcom/android/internal/telephony/data/DataNetworkController;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->updateDataActivity()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 3

    const/4 v0, 0x1

    .line 208
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    const/4 v1, 0x2

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v0, v1}, Ljava/util/List;->of(Ljava/lang/Object;Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/data/DataNetworkController;->SUPPORTED_IMS_FEATURES:Ljava/util/Collection;

    .line 217
    sget-object v0, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0x3

    .line 218
    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/data/DataNetworkController;->REEVALUATE_PREFERRED_TRANSPORT_DELAY_MILLIS:J

    .line 221
    sget-object v0, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0x1f4

    .line 222
    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v1

    sput-wide v1, Lcom/android/internal/telephony/data/DataNetworkController;->REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_AFTER_CALL_END_DELAY_MILLIS:J

    const-wide/16 v1, 0x64

    .line 226
    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/data/DataNetworkController;->REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_TAC_CHANGED_DELAY_MILLIS:J

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)V
    .locals 12

    .line 772
    invoke-direct {p0, p2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 230
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x80

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 240
    new-instance v5, Landroid/util/SparseArray;

    invoke-direct {v5}, Landroid/util/SparseArray;-><init>()V

    iput-object v5, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceManagers:Landroid/util/SparseArray;

    const/4 v0, -0x1

    .line 244
    iput v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubId:I

    .line 252
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubscriptionPlans:Ljava/util/List;

    .line 258
    new-instance v1, Landroid/util/ArraySet;

    invoke-direct {v1}, Landroid/util/ArraySet;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mUnmeteredOverrideNetworkTypes:Ljava/util/Set;

    .line 265
    new-instance v1, Landroid/util/ArraySet;

    invoke-direct {v1}, Landroid/util/ArraySet;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mCongestedOverrideNetworkTypes:Ljava/util/Set;

    .line 271
    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    .line 277
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    .line 285
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPreviousConnectedDataNetworkList:Ljava/util/List;

    const/4 v1, 0x0

    .line 291
    iput v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetDataNetworkState:I

    .line 296
    iput v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsDataNetworkState:I

    .line 299
    iput v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetLinkStatus:I

    .line 302
    new-instance v0, Landroid/util/ArraySet;

    invoke-direct {v0}, Landroid/util/ArraySet;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    .line 306
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPsRestricted:Z

    .line 309
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNrAdvancedCapableByPco:Z

    .line 315
    new-instance v0, Landroid/util/SparseBooleanArray;

    invoke-direct {v0}, Landroid/util/SparseBooleanArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceBound:Landroid/util/SparseBooleanArray;

    .line 318
    iput v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSimState:I

    .line 321
    iput v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataActivity:I

    .line 326
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsStateCallbacks:Landroid/util/SparseArray;

    .line 329
    new-instance v0, Landroid/util/ArraySet;

    invoke-direct {v0}, Landroid/util/ArraySet;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mRegisteredImsFeatures:Ljava/util/Set;

    .line 332
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsFeaturePackageName:Landroid/util/SparseArray;

    .line 338
    new-instance v0, Landroid/util/ArrayMap;

    invoke-direct {v0}, Landroid/util/ArrayMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingImsDeregDataNetworks:Ljava/util/Map;

    .line 346
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsFeatureRegistrationCallbacks:Landroid/util/SparseArray;

    .line 362
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingTearDownAllNetworks:Z

    .line 374
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$1;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    .line 773
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 774
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DNC-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLogTag:Ljava/lang/String;

    const-string v0, "DataNetworkController created."

    .line 775
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 777
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getAccessNetworksManager()Lcom/android/internal/telephony/data/AccessNetworksManager;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 778
    new-instance v1, Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v2, 0x1

    invoke-direct {v1, p1, p2, v2}, Lcom/android/internal/telephony/data/DataServiceManager;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;I)V

    invoke-virtual {v5, v2, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 780
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v0

    if-nez v0, :cond_0

    .line 781
    new-instance v0, Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v1, 0x2

    invoke-direct {v0, p1, p2, v1}, Lcom/android/internal/telephony/data/DataServiceManager;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;I)V

    invoke-virtual {v5, v1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 786
    :cond_0
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v0

    const-class v1, Lcom/android/internal/telephony/TelephonyComponentFactory;

    .line 787
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    .line 786
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v0

    .line 788
    invoke-virtual {v0, p1, p2}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeDataConfigManager(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;)Lcom/android/internal/telephony/data/DataConfigManager;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 792
    new-instance v1, Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 793
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyImsReleaseRequestThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v3

    iget-wide v3, v3, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->timeWindow:J

    .line 794
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyImsReleaseRequestThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v6

    iget v6, v6, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->eventNumOccurrence:I

    invoke-direct {v1, v3, v4, v6}, Lcom/android/internal/telephony/SlidingWindowEventCounter;-><init>(JI)V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsThrottleCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 795
    new-instance v1, Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 796
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyNetworkUnwantedThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v3

    iget-wide v3, v3, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->timeWindow:J

    .line 797
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyNetworkUnwantedThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v6

    iget v6, v6, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->eventNumOccurrence:I

    invoke-direct {v1, v3, v4, v6}, Lcom/android/internal/telephony/SlidingWindowEventCounter;-><init>(JI)V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNetworkUnwantedCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 798
    new-instance v1, Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 799
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalySetupDataCallThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v3

    iget-wide v3, v3, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->timeWindow:J

    .line 800
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalySetupDataCallThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v6

    iget v6, v6, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->eventNumOccurrence:I

    invoke-direct {v1, v3, v4, v6}, Lcom/android/internal/telephony/SlidingWindowEventCounter;-><init>(JI)V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSetupDataCallWlanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 801
    new-instance v1, Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 802
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalySetupDataCallThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v3

    iget-wide v3, v3, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->timeWindow:J

    .line 803
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalySetupDataCallThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v0

    iget v0, v0, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->eventNumOccurrence:I

    invoke-direct {v1, v3, v4, v0}, Lcom/android/internal/telephony/SlidingWindowEventCounter;-><init>(JI)V

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSetupDataCallWwanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 806
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v0

    const-class v1, Lcom/android/internal/telephony/data/DataSettingsManager;

    .line 807
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    .line 806
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$2;

    new-instance v3, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v3, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-direct {v1, p0, v3}, Lcom/android/internal/telephony/data/DataNetworkController$2;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/util/concurrent/Executor;)V

    .line 808
    invoke-virtual {v0, p1, p0, p2, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeDataSettingsManager(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataSettingsManager$DataSettingsManagerCallback;)Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    .line 851
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v0

    const-class v1, Lcom/android/internal/telephony/data/DataProfileManager;

    .line 852
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    .line 851
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v6

    .line 854
    invoke-virtual {v5, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    move-object v9, v0

    check-cast v9, Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v11, Lcom/android/internal/telephony/data/DataNetworkController$3;

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-direct {v11, p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController$3;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/util/concurrent/Executor;)V

    move-object v7, p1

    move-object v8, p0

    move-object v10, p2

    .line 853
    invoke-virtual/range {v6 .. v11}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeDataProfileManager(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)Lcom/android/internal/telephony/data/DataProfileManager;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

    .line 866
    new-instance v0, Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    .line 867
    invoke-virtual {v5, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    move-object v9, v1

    check-cast v9, Lcom/android/internal/telephony/data/DataServiceManager;

    new-instance v11, Lcom/android/internal/telephony/data/DataNetworkController$4;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-direct {v11, p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController$4;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/util/concurrent/Executor;)V

    move-object v6, v0

    invoke-direct/range {v6 .. v11}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataStallRecoveryManager$DataStallRecoveryManagerCallback;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataStallRecoveryManager:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    .line 874
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager;

    new-instance v7, Lcom/android/internal/telephony/data/DataNetworkController$5;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-direct {v7, p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController$5;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/util/concurrent/Executor;)V

    move-object v2, v0

    move-object v3, p1

    move-object v4, p0

    move-object v6, p2

    invoke-direct/range {v2 .. v7}, Lcom/android/internal/telephony/data/DataRetryManager;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Landroid/util/SparseArray;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    .line 914
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    const-class v0, Landroid/telephony/ims/ImsManager;

    invoke-virtual {p2, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/ims/ImsManager;

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsManager:Landroid/telephony/ims/ImsManager;

    .line 915
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    const-class v0, Landroid/net/NetworkPolicyManager;

    invoke-virtual {p2, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/net/NetworkPolicyManager;

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNetworkPolicyManager:Landroid/net/NetworkPolicyManager;

    .line 919
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    const/16 p1, 0x13

    .line 923
    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    return-void
.end method

.method private evaluateDataNetworkHandover(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataEvaluation;
    .locals 8

    .line 1833
    new-instance v0, Lcom/android/internal/telephony/data/DataEvaluation;

    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_HANDOVER:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/data/DataEvaluation;-><init>(Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)V

    .line 1834
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->isConnecting()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v1

    if-nez v1, :cond_0

    .line 1835
    sget-object p0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ILLEGAL_STATE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    return-object v0

    .line 1839
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->isAnyHandoverRetryScheduled(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 1840
    sget-object p0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->RETRY_SCHEDULED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    return-object v0

    .line 1845
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->isEnhancedIwlanHandoverCheckEnabled()Z

    move-result v1

    const/4 v2, 0x2

    if-eqz v1, :cond_5

    .line 1846
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v1

    invoke-static {v1}, Lcom/android/internal/telephony/data/DataUtils;->getTargetTransport(I)I

    move-result v1

    .line 1847
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v3, v2, v1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v1

    if-eqz v1, :cond_5

    .line 1852
    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v3

    if-nez v3, :cond_3

    .line 1853
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->isMtkImsDataSupport()Z

    move-result v3

    if-eqz v3, :cond_2

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v3

    const/4 v4, 0x4

    .line 1854
    invoke-virtual {v3, v4}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v3

    if-nez v3, :cond_3

    .line 1855
    :cond_2
    sget-object v3, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->NOT_IN_SERVICE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1861
    :cond_3
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getAttachedNetworkRequestList()Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    move-result-object v3

    .line 1862
    invoke-virtual {v3}, Ljava/util/LinkedList;->stream()Ljava/util/stream/Stream;

    move-result-object v3

    new-instance v4, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda0;

    invoke-direct {v4}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda0;-><init>()V

    invoke-interface {v3, v4}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v3

    if-eqz v3, :cond_4

    .line 1864
    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->getDataSpecificInfo()Landroid/telephony/DataSpecificRegistrationInfo;

    move-result-object v1

    if-eqz v1, :cond_4

    .line 1866
    invoke-virtual {v1}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object v3

    if-eqz v3, :cond_4

    .line 1867
    invoke-virtual {v1}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/VopsSupportInfo;->isVopsSupported()Z

    move-result v1

    if-nez v1, :cond_4

    .line 1868
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->VOPS_NOT_SUPPORTED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1873
    :cond_4
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result v1

    if-eqz v1, :cond_5

    return-object v0

    .line 1879
    :cond_5
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->isIwlanHandoverPolicyEnabled()Z

    move-result v1

    if-eqz v1, :cond_b

    .line 1880
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getHandoverRules()Ljava/util/List;

    move-result-object v1

    .line 1883
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v3

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataNetworkType(I)I

    move-result v3

    .line 1882
    invoke-static {v3}, Lcom/android/internal/telephony/data/DataUtils;->networkTypeToAccessNetworkType(I)I

    move-result v3

    .line 1885
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v4

    invoke-static {v4}, Lcom/android/internal/telephony/data/DataUtils;->getTargetTransport(I)I

    move-result v4

    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataNetworkType(I)I

    move-result v4

    .line 1884
    invoke-static {v4}, Lcom/android/internal/telephony/data/DataUtils;->networkTypeToAccessNetworkType(I)I

    move-result v4

    .line 1886
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p1

    .line 1887
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "evaluateDataNetworkHandover: source="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1888
    invoke-static {v3}, Landroid/telephony/AccessNetworkConstants$AccessNetworkType;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ", target="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1889
    invoke-static {v4}, Landroid/telephony/AccessNetworkConstants$AccessNetworkType;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, ", ServiceState="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v6, ", capabilities="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 1887
    invoke-direct {p0, v5}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1894
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_6
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_a

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;

    .line 1897
    iget-boolean v6, v5, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;->isOnlyForRoaming:Z

    if-eqz v6, :cond_7

    iget-object v6, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v6}, Landroid/telephony/ServiceState;->getDataRoamingFromRegistration()Z

    move-result v6

    if-nez v6, :cond_7

    goto :goto_0

    .line 1903
    :cond_7
    iget-object v6, v5, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;->sourceAccessNetworks:Ljava/util/Set;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v6, v7}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_6

    iget-object v6, v5, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;->targetAccessNetworks:Ljava/util/Set;

    .line 1904
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v6, v7}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_6

    .line 1908
    iget-object v6, v5, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;->networkCapabilities:Ljava/util/Set;

    invoke-interface {v6}, Ljava/util/Set;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_8

    iget-object v6, v5, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;->networkCapabilities:Ljava/util/Set;

    .line 1909
    invoke-interface {v6}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v6

    .line 1910
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v7, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda1;

    invoke-direct {v7, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda1;-><init>(Landroid/net/NetworkCapabilities;)V

    invoke-interface {v6, v7}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v6

    if-eqz v6, :cond_6

    .line 1911
    :cond_8
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "evaluateDataNetworkHandover: Matched "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1912
    iget p1, v5, Lcom/android/internal/telephony/data/DataNetworkController$HandoverRule;->type:I

    if-ne p1, v2, :cond_9

    .line 1913
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->NOT_ALLOWED_BY_POLICY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    goto :goto_1

    .line 1916
    :cond_9
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->NORMAL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    .line 1918
    :goto_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "evaluateDataNetworkHandover: "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-object v0

    :cond_a
    const-string p1, "evaluateDataNetworkHandover: Did not find matching rule."

    .line 1923
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    goto :goto_2

    :cond_b
    const-string p1, "evaluateDataNetworkHandover: IWLAN handover policy not enabled."

    .line 1925
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1929
    :goto_2
    sget-object p0, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->NORMAL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    return-object v0
.end method

.method private evaluatePendingImsDeregDataNetworks()V
    .locals 4

    .line 3447
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingImsDeregDataNetworks:Ljava/util/Map;

    .line 3448
    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .line 3449
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 3450
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 3451
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/DataNetwork;

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->isSafeToTearDown(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 3453
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "evaluatePendingImsDeregDataNetworks: Safe to tear down data network "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3454
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, " now."

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 3453
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3455
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Runnable;

    invoke-interface {v1}, Ljava/lang/Runnable;->run()V

    .line 3456
    invoke-interface {v0}, Ljava/util/Iterator;->remove()V

    goto :goto_0

    .line 3458
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Still not safe to tear down "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, "."

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    return-void
.end method

.method private findCompatibleDataNetworkAndAttach(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Z
    .locals 4

    .line 1273
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataNetwork;

    .line 1274
    invoke-virtual {p1}, Ljava/util/LinkedList;->stream()Ljava/util/stream/Stream;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda4;

    invoke-direct {v3, v1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda4;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 1275
    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v2

    .line 1277
    invoke-interface {v2}, Ljava/util/stream/Stream;->findAny()Ljava/util/Optional;

    move-result-object v2

    const/4 v3, 0x0

    .line 1278
    invoke-virtual {v2, v3}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    if-eqz v2, :cond_0

    goto :goto_0

    .line 1287
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Found a compatible data network "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ". Attaching "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->logv(Ljava/lang/String;)V

    .line 1289
    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/data/DataNetwork;->attachNetworkRequests(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Z

    move-result p0

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method private findCompatibleDataNetworkAndAttach(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 1

    .line 1252
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->findCompatibleDataNetworkAndAttach(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Z

    move-result p0

    return p0
.end method

.method private findSatisfiableNetworkRequests(Landroid/telephony/data/DataProfile;)Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;
    .locals 2

    .line 2326
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p0}, Ljava/util/LinkedList;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda29;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda29;-><init>()V

    .line 2327
    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda30;

    invoke-direct {v1, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda30;-><init>(Landroid/telephony/data/DataProfile;)V

    .line 2329
    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 2330
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>(Ljava/util/List;)V

    return-object v0
.end method

.method private getGroupedUnsatisfiedNetworkRequests()Ljava/util/List;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;",
            ">;"
        }
    .end annotation

    .line 1587
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>()V

    .line 1588
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p0}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 1589
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getState()I

    move-result v2

    if-nez v2, :cond_0

    .line 1590
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->add(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    goto :goto_0

    .line 1593
    :cond_1
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataUtils;->getGroupedNetworkRequestList(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method private static getTearDownReason(Lcom/android/internal/telephony/data/DataEvaluation;)I
    .locals 2
    .annotation build Lcom/android/internal/telephony/data/DataNetwork$TearDownReason;
    .end annotation

    .line 1941
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 1942
    sget-object v0, Lcom/android/internal/telephony/data/DataNetworkController$13;->$SwitchMap$com$android$internal$telephony$data$DataEvaluation$DataDisallowedReason:[I

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataEvaluation;->getDataDisallowedReasons()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {p0}, Ljava/lang/Enum;->ordinal()I

    move-result p0

    aget p0, v0, p0

    packed-switch p0, :pswitch_data_0

    goto :goto_0

    :pswitch_0
    const/16 p0, 0x1d

    return p0

    :pswitch_1
    const/16 p0, 0x10

    return p0

    :pswitch_2
    const/16 p0, 0x1c

    return p0

    :pswitch_3
    const/16 p0, 0x1b

    return p0

    :pswitch_4
    const/16 p0, 0x1a

    return p0

    :pswitch_5
    const/16 p0, 0x19

    return p0

    :pswitch_6
    const/16 p0, 0x18

    return p0

    :pswitch_7
    const/16 p0, 0x17

    return p0

    :pswitch_8
    const/16 p0, 0x16

    return p0

    :pswitch_9
    const/4 p0, 0x6

    return p0

    :pswitch_a
    const/16 p0, 0x15

    return p0

    :pswitch_b
    const/16 p0, 0xa

    return p0

    :pswitch_c
    const/16 p0, 0xb

    return p0

    :pswitch_d
    const/16 p0, 0x14

    return p0

    :pswitch_e
    const/4 p0, 0x3

    return p0

    :pswitch_f
    const/16 p0, 0x8

    return p0

    :pswitch_10
    const/4 p0, 0x2

    return p0

    :pswitch_11
    const/16 p0, 0x13

    return p0

    :pswitch_12
    const/16 p0, 0x12

    return p0

    :pswitch_13
    const/16 p0, 0x11

    return p0

    :pswitch_14
    const/4 p0, 0x7

    return p0

    :pswitch_15
    const/4 p0, 0x4

    return p0

    :cond_0
    :goto_0
    return v1

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_15
        :pswitch_14
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

.method private isDataDormant()Z
    .locals 2

    .line 2013
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda11;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda11;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    .line 2016
    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda12;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda12;-><init>()V

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->noneMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isImsGracefulTearDownSupported()Z
    .locals 4

    .line 3492
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataConfigManager;->getImsDeregistrationDelay()J

    move-result-wide v0

    const-wide/16 v2, 0x0

    cmp-long p0, v0, v2

    if-lez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isLegacyCs(I)Z
    .locals 1

    .line 1322
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->networkTypeToAccessNetworkType(I)I

    move-result p0

    const/4 p1, 0x1

    if-eq p0, p1, :cond_1

    const/4 v0, 0x2

    if-eq p0, v0, :cond_1

    const/4 v0, 0x4

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :cond_1
    :goto_0
    return p1
.end method

.method private isMtkImsDataSupport()Z
    .locals 1

    const-string p0, "ro.vendor.mtk_telephony_add_on_policy"

    const-string v0, "0"

    .line 3743
    invoke-static {p0, v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_1

    const-string p0, "ro.mtk.ims.data.feature_support"

    .line 3744
    invoke-static {p0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "1"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method private isOnlySingleDataNetworkAllowed(I)Z
    .locals 1

    const/4 v0, 0x2

    if-ne p1, v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 1334
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getNetworkTypesOnlySupportSingleDataNetwork()Ljava/util/List;

    move-result-object v0

    .line 1335
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataNetworkType(I)I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, p0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private isSafeToTearDown(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 4

    .line 3472
    sget-object v0, Lcom/android/internal/telephony/data/DataNetworkController;->SUPPORTED_IMS_FEATURES:Ljava/util/Collection;

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 3473
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsFeaturePackageName:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    if-eqz v2, :cond_0

    .line 3475
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getAttachedNetworkRequestList()Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    move-result-object v3

    .line 3476
    invoke-virtual {v3, v2}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->hasNetworkRequestsFromPackage(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 3477
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mRegisteredImsFeatures:Ljava/util/Set;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v2, v1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_1
    const/4 p0, 0x1

    return p0
.end method

.method private synthetic lambda$evaluateDataNetwork$11(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    .line 1670
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result p1

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 1672
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result p2

    .line 1671
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransportByNetworkCapability(I)I

    move-result p0

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$evaluateDataNetwork$12(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    .line 1673
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getPriority()I

    move-result p1

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getPriority()I

    move-result p0

    if-le p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$evaluateDataNetworkHandover$13(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 1

    const/16 v0, 0x21

    .line 1863
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$evaluateNetworkRequest$9(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 1

    .line 1496
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p0

    const/4 v0, 0x4

    .line 1497
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private static synthetic lambda$findCompatibleDataNetworkAndAttach$6(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    .line 1276
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p0

    .line 1275
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->canBeSatisfiedBy(Landroid/net/NetworkCapabilities;)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private static synthetic lambda$findSatisfiableNetworkRequests$20(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    .line 2327
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getState()I

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$findSatisfiableNetworkRequests$21(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    .line 2329
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->canBeSatisfiedBy(Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$handleMessage$0(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    .line 1117
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onSubscriptionPlanOverride()V

    return-void
.end method

.method private static synthetic lambda$handleMessage$1(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 1116
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda2;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$handleMessage$2(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    .line 1137
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onSubscriptionPlanOverride()V

    return-void
.end method

.method private static synthetic lambda$handleMessage$3(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 1136
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda8;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda8;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$handleMessage$4(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    .line 1151
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onSubscriptionPlanOverride()V

    return-void
.end method

.method private static synthetic lambda$handleMessage$5(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 1150
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda26;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda26;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$isDataDormant$14(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 1

    .line 2014
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getLinkStatus()I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private static synthetic lambda$isDataDormant$15(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 1

    .line 2017
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getLinkStatus()I

    move-result p0

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$isInternetUnmetered$7(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 1

    .line 1363
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnecting()Z

    move-result v0

    if-nez v0, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$isInternetUnmetered$8(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 2

    .line 1365
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v0

    const/16 v1, 0xb

    .line 1366
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1367
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p0

    const/16 v0, 0x19

    .line 1368
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method private static synthetic lambda$isNetworkInterfaceExisting$17(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    .line 2096
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnecting()Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private static synthetic lambda$isNetworkInterfaceExisting$18(Ljava/lang/String;Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    .line 2098
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object p1

    invoke-virtual {p1}, Landroid/net/LinkProperties;->getInterfaceName()Ljava/lang/String;

    move-result-object p1

    .line 2097
    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private synthetic lambda$onDataNetworkDisconnected$30(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    .line 2766
    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onAnyDataNetworkExistingChanged(Z)V

    return-void
.end method

.method private synthetic lambda$onDataNetworkDisconnected$31(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 2765
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda51;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda51;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onDataNetworkDisconnected$32(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 2

    .line 2770
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v0

    const/4 v1, 0x4

    .line 2771
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$onDataNetworkDisconnected$33(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 2780
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onAnyDataNetworkExistingChanged(Z)V

    return-void
.end method

.method private static synthetic lambda$onDataNetworkDisconnected$34(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 2779
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda36;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda36;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$onDataNetworkSetupFailed$24(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    .line 2501
    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onAnyDataNetworkExistingChanged(Z)V

    return-void
.end method

.method private synthetic lambda$onDataNetworkSetupFailed$25(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 2500
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda5;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$onDataNetworkSetupFailed$26(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    .line 2504
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p0, p1}, Ljava/util/LinkedList;->contains(Ljava/lang/Object;)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private synthetic lambda$onDataNetworkSetupRetry$27(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    .line 2593
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p0, p1}, Ljava/util/LinkedList;->contains(Ljava/lang/Object;)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private static synthetic lambda$onDataNetworkValidationStatusChanged$28(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;I)V
    .locals 0

    .line 2715
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onInternetDataNetworkValidationStatusChanged(I)V

    return-void
.end method

.method private static synthetic lambda$onDataNetworkValidationStatusChanged$29(ILcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 2714
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda46;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda46;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;I)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onDataServiceBindingChanged$36(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;I)V
    .locals 0

    .line 2901
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onDataServiceBound(I)V

    return-void
.end method

.method private static synthetic lambda$onDataServiceBindingChanged$37(ILcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 2900
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda54;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda54;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;I)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onDataStallReestablishInternet$35(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 1

    const/16 v0, 0xc

    .line 2885
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->tearDown(I)V

    return-void
.end method

.method private static synthetic lambda$onLinkStatusChanged$38(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 1

    .line 3021
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isInternetSupported()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$onLinkStatusChanged$39(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 1

    .line 3024
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isInternetSupported()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 3025
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getLinkStatus()I

    move-result p0

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$onLinkStatusChanged$40(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    .line 3035
    iget p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetLinkStatus:I

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onPhysicalLinkStatusChanged(I)V

    return-void
.end method

.method private synthetic lambda$onLinkStatusChanged$41(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 3034
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$onPcoDataChanged$42(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    .line 3064
    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNrAdvancedCapableByPco:Z

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onNrAdvancedCapableByPcoChanged(Z)V

    return-void
.end method

.method private synthetic lambda$onPcoDataChanged$43(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 3063
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda27;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda27;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onReevaluateUnsatisfiedNetworkRequests$10(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Ljava/lang/String;
    .locals 1

    const/4 v0, 0x0

    .line 1608
    invoke-virtual {p0, v0}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getCapabilities()[I

    move-result-object p0

    .line 1607
    invoke-static {p0}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilitiesToString([I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$onRemoveNetworkRequest$16(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    .line 2057
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$onTearDownAllDataNetworks$49(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    const/4 v0, 0x0

    .line 3433
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onAnyDataNetworkExistingChanged(Z)V

    return-void
.end method

.method private static synthetic lambda$onTearDownAllDataNetworks$50(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 3432
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda10;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda10;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$registerImsStateCallback$19(ILjava/lang/Integer;)Landroid/telephony/ims/ImsStateCallback;
    .locals 1

    .line 2184
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$11;

    invoke-direct {v0, p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController$11;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;ILjava/lang/Integer;)V

    return-object v0
.end method

.method private synthetic lambda$setupDataNetwork$22(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 0

    .line 2478
    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onAnyDataNetworkExistingChanged(Z)V

    return-void
.end method

.method private synthetic lambda$setupDataNetwork$23(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 2477
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda15;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda15;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$updateOverallInternetDataState$44(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 1

    .line 3246
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isInternetSupported()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 3247
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v0

    if-nez v0, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isHandoverInProgress()Z

    move-result p0

    if-eqz p0, :cond_1

    :cond_0
    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$updateOverallInternetDataState$45(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 1

    .line 3251
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v0

    if-nez v0, :cond_1

    .line 3252
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isHandoverInProgress()Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method private static synthetic lambda$updateOverallInternetDataState$46(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;Ljava/util/List;)V
    .locals 1

    .line 3275
    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda9;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda9;-><init>()V

    .line 3276
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 3277
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/List;

    .line 3274
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;->onInternetDataNetworkConnected(Ljava/util/List;)V

    return-void
.end method

.method private static synthetic lambda$updateOverallInternetDataState$47(Ljava/util/List;Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 3273
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda52;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda52;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;Ljava/util/List;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$updateOverallInternetDataState$48(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    .line 3284
    invoke-static {p0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda47;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda47;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    .line 3283
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 3552
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 3560
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private logv(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method private onAddNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V
    .locals 2

    .line 1179
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLastImsOperationIsRelease:Z

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    .line 1180
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLastImsOperationIsRelease:Z

    .line 1181
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLastReleasedImsRequestCapabilities:[I

    .line 1182
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getCapabilities()[I

    move-result-object v1

    .line 1181
    invoke-static {v0, v1}, Ljava/util/Arrays;->equals([I[I)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsThrottleCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 1183
    invoke-virtual {v0}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->addOccurrence()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1184
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNativeNetworkRequest()Landroid/net/NetworkRequest;

    move-result-object v1

    invoke-virtual {v1}, Landroid/net/NetworkRequest;->getRequestorPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " requested with same capabilities "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsThrottleCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 1186
    invoke-virtual {v1}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->getFrequencyString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ead6f8db-d2f2-4ed3-8da5-1d8560fe7daf"

    .line 1184
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V

    .line 1190
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->add(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1191
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onAddNetworkRequest: Duplicate network request. "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    return-void

    .line 1194
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onAddNetworkRequest: added "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1195
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onSatisfyNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    return-void
.end method

.method private onAttachNetworkRequestsFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 2

    .line 2871
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Failed to attach "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p2, " to "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void
.end method

.method private onDataConfigUpdated()V
    .locals 2

    .line 2264
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataConfigUpdated: config is "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2265
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->isConfigCarrierSpecific()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, ""

    goto :goto_0

    :cond_0
    const-string v1, "not "

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "carrier specific. mSimState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSimState:I

    .line 2267
    invoke-static {v1}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;->simStateString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ". DeviceConfig updated."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2264
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2270
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->updateAnomalySlidingWindowCounters()V

    .line 2271
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->updateNetworkRequestsPriority()V

    const/4 v0, 0x5

    .line 2272
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_CONFIG_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v0, v1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method private onDataNetworkConnected(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 2

    .line 2565
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataNetworkConnected: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    .line 2566
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPreviousConnectedDataNetworkList:Ljava/util/List;

    const/4 v1, 0x0

    invoke-interface {v0, v1, p1}, Ljava/util/List;->add(ILjava/lang/Object;)V

    .line 2568
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPreviousConnectedDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/16 v1, 0xa

    if-le v0, v1, :cond_0

    .line 2569
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPreviousConnectedDataNetworkList:Ljava/util/List;

    invoke-interface {v0, v1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 2572
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->updateOverallInternetDataState()V

    .line 2574
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p1

    const/4 v0, 0x4

    invoke-virtual {p1, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 2576
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "IMS data state changed from "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsDataNetworkState:I

    .line 2577
    invoke-static {v0}, Lcom/android/internal/telephony/util/TelephonyUtils;->dataStateToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " to CONNECTED."

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2576
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    const/4 p1, 0x2

    .line 2578
    iput p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsDataNetworkState:I

    :cond_1
    return-void
.end method

.method private onDataNetworkDisconnected(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 2

    .line 2747
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataNetworkDisconnected: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", cause="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2748
    invoke-static {p2}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, ")"

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 2747
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    .line 2749
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p2, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 2750
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingImsDeregDataNetworks:Ljava/util/Map;

    invoke-interface {p2, p1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 2751
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    invoke-virtual {p2, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->cancelPendingHandoverRetry(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 2752
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->updateOverallInternetDataState()V

    .line 2754
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p1

    const/4 p2, 0x4

    invoke-virtual {p1, p2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p1

    const/4 p2, 0x0

    if-eqz p1, :cond_0

    .line 2756
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "IMS data state changed from "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsDataNetworkState:I

    .line 2757
    invoke-static {v0}, Lcom/android/internal/telephony/util/TelephonyUtils;->dataStateToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " to DISCONNECTED."

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2756
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    .line 2758
    iput p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsDataNetworkState:I

    .line 2761
    :cond_0
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    if-eqz p1, :cond_1

    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_1

    const-string p1, "All data networks disconnected now."

    .line 2762
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2763
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingTearDownAllNetworks:Z

    .line 2764
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    .line 2765
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda55;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda55;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-interface {p1, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    .line 2768
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->isMtkImsDataSupport()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 2769
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda56;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda56;-><init>()V

    .line 2770
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p1

    .line 2772
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2

    .line 2773
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "data network exist "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " has ims "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " mDataNetworkList.size "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    .line 2774
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2773
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    :cond_2
    if-eqz p1, :cond_3

    .line 2776
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    const/4 v0, 0x1

    if-ne p1, v0, :cond_3

    const-string p1, "all data disconnect except ims, power off radio immediately"

    .line 2777
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2778
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingTearDownAllNetworks:Z

    .line 2779
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance p2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda57;

    invoke-direct {p2}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda57;-><init>()V

    invoke-interface {p1, p2}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    :cond_3
    const/4 p1, 0x5

    .line 2785
    sget-object p2, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->RETRY_AFTER_DISCONNECTED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, p1, p2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2787
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataConfigManager;->getRetrySetupAfterDisconnectMillis()J

    move-result-wide v0

    .line 2785
    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method private onDataNetworkHandoverFailed(Lcom/android/internal/telephony/data/DataNetwork;IJI)V
    .locals 7

    .line 2825
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Handover failed. "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", cause="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", retryDelayMillis="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "ms, handoverFailureMode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2827
    invoke-static {p5}, Landroid/telephony/data/DataCallResponse;->failureModeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2825
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    .line 2830
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_HANDOVER:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const/16 v1, 0x10

    invoke-virtual {p0, v1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 2833
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getAttachedNetworkRequestList()Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2834
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "onDataNetworkHandoverFailed: No network requests attached to "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ". No need to retry since the network will be torn down soon."

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void

    :cond_0
    const/4 v0, 0x1

    if-eq p5, v0, :cond_4

    if-nez p5, :cond_1

    const/16 v0, 0x8cb

    if-ne p2, v0, :cond_1

    goto :goto_1

    :cond_1
    const/4 v0, 0x3

    if-eq p5, v0, :cond_3

    if-nez p5, :cond_2

    goto :goto_0

    .line 2859
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/data/DataRetryManager;->evaluateDataHandoverRetry(Lcom/android/internal/telephony/data/DataNetwork;IJ)V

    goto :goto_2

    .line 2852
    :cond_3
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result p5

    invoke-static {p5}, Lcom/android/internal/telephony/data/DataUtils;->getTargetTransport(I)I

    move-result v2

    .line 2853
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v1

    .line 2854
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getAttachedNetworkRequestList()Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    move-result-object v3

    move v4, p2

    move-wide v5, p3

    .line 2853
    invoke-virtual/range {v0 .. v6}, Lcom/android/internal/telephony/data/DataRetryManager;->evaluateDataSetupRetry(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V

    const/16 p2, 0xd

    .line 2857
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->tearDownGracefully(Lcom/android/internal/telephony/data/DataNetwork;I)V

    goto :goto_2

    :cond_4
    :goto_1
    const/16 p2, 0x15

    .line 2847
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getApnTypeNetworkCapability()I

    move-result p1

    const/4 p3, 0x0

    .line 2846
    invoke-virtual {p0, p2, p1, p3}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p1

    sget-wide p2, Lcom/android/internal/telephony/data/DataNetworkController;->REEVALUATE_PREFERRED_TRANSPORT_DELAY_MILLIS:J

    invoke-virtual {p0, p1, p2, p3}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    :goto_2
    return-void
.end method

.method private onDataNetworkHandoverRetry(Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V
    .locals 5

    .line 2645
    iget-object v0, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;->dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    .line 2646
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v1

    const/4 v2, 0x4

    const-string v3, "onDataNetworkHandoverRetry: "

    if-nez v1, :cond_0

    .line 2647
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, " no longer exists."

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2648
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    return-void

    .line 2652
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v1

    if-nez v1, :cond_1

    .line 2653
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, " is not in the right state."

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2654
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    return-void

    .line 2658
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 2659
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->getApnTypeNetworkCapability()I

    move-result v4

    .line 2658
    invoke-virtual {v1, v4}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransportByNetworkCapability(I)I

    move-result v1

    .line 2660
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v4

    if-ne v4, v1, :cond_2

    .line 2661
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, " is already on the preferred transport "

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2662
    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "."

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2661
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2664
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    return-void

    .line 2668
    :cond_2
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Start handover "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, " to "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2669
    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ", "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 2668
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    .line 2671
    invoke-virtual {v0, v1, p1}, Lcom/android/internal/telephony/data/DataNetwork;->startHandover(ILcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)Z

    return-void
.end method

.method private onDataNetworkHandoverSucceeded(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 2

    .line 2796
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Handover successfully. "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2797
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v1

    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2796
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    .line 2802
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getApnTypeNetworkCapability()I

    move-result p1

    const/16 v0, 0x15

    const/4 v1, 0x0

    .line 2801
    invoke-virtual {p0, v0, p1, v1}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 2806
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_HANDOVER:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const/16 v0, 0x10

    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method private onDataNetworkSetupFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V
    .locals 7

    .line 2493
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataNetworkSetupDataFailed: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", cause="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2494
    invoke-static {p3}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", retryDelayMillis="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4, p5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "ms."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2493
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    .line 2495
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 2496
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->trackSetupDataCallFailure(I)V

    .line 2497
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    .line 2498
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingTearDownAllNetworks:Z

    .line 2499
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    .line 2500
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda38;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda38;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-interface {v0, v1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    .line 2504
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda39;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda39;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-virtual {p2, v0}, Ljava/util/LinkedList;->removeIf(Ljava/util/function/Predicate;)Z

    .line 2505
    invoke-virtual {p2}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p1, "onDataNetworkSetupFailed: All requests have been released. Will not evaluate retry."

    .line 2506
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void

    .line 2512
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v1

    .line 2513
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v2

    move-object v3, p2

    move v4, p3

    move-wide v5, p4

    .line 2512
    invoke-virtual/range {v0 .. v6}, Lcom/android/internal/telephony/data/DataRetryManager;->evaluateDataSetupRetry(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V

    return-void
.end method

.method private onDataNetworkSetupRetry(Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V
    .locals 5

    .line 2591
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    iget-object v1, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    .line 2593
    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda16;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda16;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-virtual {v0, v1}, Ljava/util/LinkedList;->removeIf(Ljava/util/function/Predicate;)Z

    .line 2594
    invoke-virtual {v0}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v1

    const/4 v2, 0x4

    if-eqz v1, :cond_0

    const-string v0, "onDataNetworkSetupRetry: Request list is empty. Abort retry."

    .line 2595
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    .line 2596
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    return-void

    :cond_0
    const/4 v1, 0x0

    .line 2599
    invoke-virtual {v0, v1}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 2601
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result v1

    .line 2602
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v3, v1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransportByNetworkCapability(I)I

    move-result v1

    .line 2604
    iget v3, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->transport:I

    if-eq v1, v3, :cond_1

    .line 2605
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Cannot re-satisfy "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, " on "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->transport:I

    .line 2606
    invoke-static {v0}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ". The preferred transport has switched to "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2608
    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ". "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2605
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2613
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    const/4 p1, 0x5

    .line 2614
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->PREFERRED_TRANSPORT_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, p1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void

    .line 2619
    :cond_1
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_RETRY:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->evaluateNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)Lcom/android/internal/telephony/data/DataEvaluation;

    move-result-object v0

    .line 2621
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result v1

    const/4 v2, 0x2

    if-nez v1, :cond_4

    .line 2622
    iget-object v1, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    if-nez v1, :cond_2

    .line 2624
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->getCandidateDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v1

    :cond_2
    if-eqz v1, :cond_3

    .line 2628
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->getDataAllowedReason()Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    move-result-object v0

    .line 2627
    invoke-direct {p0, v1, p1, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->setupDataNetwork(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_0

    :cond_3
    const-string v0, "onDataNetworkSetupRetry: Not able to find a suitable data profile to retry."

    .line 2630
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    .line 2631
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    goto :goto_0

    .line 2634
    :cond_4
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    :goto_0
    return-void
.end method

.method private onDataNetworkSuspendedStateChanged(Lcom/android/internal/telephony/data/DataNetwork;Z)V
    .locals 1

    .line 2727
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->updateOverallInternetDataState()V

    .line 2729
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p1

    const/4 v0, 0x4

    invoke-virtual {p1, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 2731
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "IMS data state changed from "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsDataNetworkState:I

    .line 2732
    invoke-static {v0}, Lcom/android/internal/telephony/util/TelephonyUtils;->dataStateToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " to "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p2, :cond_0

    const-string v0, "SUSPENDED"

    goto :goto_0

    :cond_0
    const-string v0, "CONNECTED"

    .line 2733
    :goto_0
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2731
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    if-eqz p2, :cond_1

    const/4 p1, 0x3

    goto :goto_1

    :cond_1
    const/4 p1, 0x2

    .line 2735
    :goto_1
    iput p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsDataNetworkState:I

    :cond_2
    return-void
.end method

.method private onDataNetworkValidationStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;ILandroid/net/Uri;)V
    .locals 3

    .line 2686
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataNetworkValidationStatusChanged: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", validation status="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2687
    invoke-static {p2}, Lcom/android/internal/telephony/data/DataUtils;->validationStatusToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p3, :cond_0

    .line 2688
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, ", "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    const-string v1, ""

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2686
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2689
    invoke-virtual {p3}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 2690
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.telephony.action.CARRIER_SIGNAL_REDIRECTED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "android.telephony.extra.REDIRECTION_URL"

    .line 2691
    invoke-virtual {v0, v1, p3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 2692
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getCarrierSignalAgent()Lcom/android/internal/telephony/CarrierSignalAgent;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/CarrierSignalAgent;->notifyCarrierSignalReceivers(Landroid/content/Intent;)V

    .line 2693
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Notify carrier signal receivers with redirectUri: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-direct {p0, p3}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    :cond_1
    const/4 p3, 0x1

    const/4 v0, 0x2

    if-eq p2, p3, :cond_2

    if-eq p2, v0, :cond_2

    .line 2698
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Invalid validation status "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, " received."

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    return-void

    .line 2702
    :cond_2
    iget-object p3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    invoke-virtual {p3}, Lcom/android/internal/telephony/data/DataSettingsManager;->isRecoveryOnBadNetworkEnabled()Z

    move-result p3

    if-nez p3, :cond_3

    const-string p1, "Ignore data network validation status changed because data stall recovery is disabled."

    .line 2703
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void

    .line 2708
    :cond_3
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->isInternetSupported()Z

    move-result p3

    if-eqz p3, :cond_6

    if-ne p2, v0, :cond_5

    .line 2710
    invoke-virtual {p1}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p3

    if-eqz p3, :cond_4

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result p1

    if-eqz p1, :cond_5

    :cond_4
    const-string p1, "Ignoring invalid validation status for disconnected DataNetwork"

    .line 2711
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void

    .line 2714
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance p1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda48;

    invoke-direct {p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda48;-><init>(I)V

    invoke-interface {p0, p1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    :cond_6
    return-void
.end method

.method private onDataServiceBindingChanged(IZ)V
    .locals 2

    .line 2896
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataServiceBindingChanged: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2897
    invoke-static {p1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " data service is "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p2, :cond_0

    const-string v1, "bound."

    goto :goto_0

    :cond_0
    const-string/jumbo v1, "unbound."

    .line 2898
    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2896
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    if-eqz p2, :cond_1

    .line 2900
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda37;

    invoke-direct {v1, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda37;-><init>(I)V

    invoke-interface {v0, v1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    .line 2903
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceBound:Landroid/util/SparseBooleanArray;

    invoke-virtual {p0, p1, p2}, Landroid/util/SparseBooleanArray;->put(IZ)V

    return-void
.end method

.method private onDataStallReestablishInternet()V
    .locals 1

    const-string v0, "onDataStallReestablishInternet: Tear down data networks that support internet."

    .line 2879
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2883
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda17;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda17;-><init>()V

    .line 2884
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda18;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda18;-><init>()V

    .line 2885
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method private onEvaluatePreferredTransport(I)V
    .locals 10

    .line 2939
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 2940
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransportByNetworkCapability(I)I

    move-result v0

    .line 2941
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onEvaluatePreferredTransport: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " preferred on "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2943
    invoke-static {v0}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 2941
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2944
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_7

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/data/DataNetwork;

    .line 2945
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataNetwork;->getApnTypeNetworkCapability()I

    move-result v4

    if-ne v4, p1, :cond_0

    .line 2947
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->shouldIgnoreHandover(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 2948
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "ignore handover for "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 2954
    :cond_1
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v4

    if-ne v4, v0, :cond_2

    .line 2955
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "onEvaluatePreferredTransport:"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, " already on "

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2956
    invoke-static {v0}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 2955
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 2963
    :cond_2
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataNetwork;->isHandoverInProgress()Z

    move-result v4

    if-eqz v4, :cond_3

    .line 2964
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, " handover in progress."

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 2968
    :cond_3
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->evaluateDataNetworkHandover(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataEvaluation;

    move-result-object v4

    .line 2969
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v6, ", "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-direct {p0, v5}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2970
    invoke-virtual {v4}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result v5

    if-nez v5, :cond_4

    .line 2971
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Start handover "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, " to "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2972
    invoke-static {v0}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 2971
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    const/4 v4, 0x0

    .line 2973
    invoke-virtual {v3, v0, v4}, Lcom/android/internal/telephony/data/DataNetwork;->startHandover(ILcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)Z

    goto/16 :goto_0

    :cond_4
    const/4 v5, 0x3

    new-array v5, v5, [Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 2974
    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->NOT_ALLOWED_BY_POLICY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const/4 v7, 0x0

    aput-object v6, v5, v7

    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->NOT_IN_SERVICE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const/4 v8, 0x1

    aput-object v6, v5, v8

    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->VOPS_NOT_SUPPORTED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const/4 v9, 0x2

    aput-object v6, v5, v9

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/data/DataEvaluation;->containsAny([Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)Z

    move-result v5

    if-eqz v5, :cond_5

    .line 2977
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "onEvaluatePreferredTransport: Handover not allowed. Tear down "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, " so a new network can be setup on "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2979
    invoke-static {v0}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "."

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 2977
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    const/16 v4, 0xe

    .line 2981
    invoke-direct {p0, v3, v4}, Lcom/android/internal/telephony/data/DataNetworkController;->tearDownGracefully(Lcom/android/internal/telephony/data/DataNetwork;I)V

    goto/16 :goto_0

    :cond_5
    new-array v5, v9, [Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 2983
    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ILLEGAL_STATE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    aput-object v6, v5, v7

    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->RETRY_SCHEDULED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    aput-object v6, v5, v8

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/data/DataEvaluation;->containsAny([Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)Z

    move-result v4

    if-eqz v4, :cond_6

    .line 2985
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "onEvaluatePreferredTransport: Handover not allowed. "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, " will remain on "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2987
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v3

    .line 2986
    invoke-static {v3}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 2985
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    goto/16 :goto_0

    :cond_6
    const-string v3, "onEvaluatePreferredTransport: Unexpected handover evaluation result."

    .line 2989
    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    goto/16 :goto_0

    :cond_7
    return-void
.end method

.method private onLinkStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 1

    .line 3020
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance p2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda23;

    invoke-direct {p2}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda23;-><init>()V

    .line 3021
    invoke-interface {p1, p2}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 3024
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    .line 3023
    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance p2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda24;

    invoke-direct {p2}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda24;-><init>()V

    .line 3024
    invoke-interface {p1, p2}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x2

    goto :goto_0

    :cond_0
    const/4 p1, 0x1

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    .line 3031
    :goto_0
    iget p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetLinkStatus:I

    if-eq p2, p1, :cond_2

    .line 3032
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Internet link status changed to "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->linkStatusToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3033
    iput p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetLinkStatus:I

    .line 3034
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance p2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda25;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda25;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-interface {p1, p2}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    .line 3038
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->updateDataActivity()V

    return-void
.end method

.method private onNetworkCapabilitiesChanged(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 4

    .line 3077
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>()V

    .line 3078
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v1}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 3079
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getState()I

    move-result v3

    if-nez v3, :cond_0

    .line 3080
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->canBeSatisfiedBy(Landroid/net/NetworkCapabilities;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 3081
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->add(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    goto :goto_0

    .line 3086
    :cond_1
    invoke-virtual {v0}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_2

    .line 3087
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Found more network requests that can be satisfied. "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3088
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataNetwork;->attachNetworkRequests(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Z

    :cond_2
    return-void
.end method

.method private onPcoDataChanged(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 5

    .line 3048
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataConfigManager;->getNrAdvancedCapablePcoId()I

    move-result p1

    if-eqz p1, :cond_2

    const/4 v0, 0x0

    .line 3051
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    const/4 v3, 0x1

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/DataNetwork;

    .line 3052
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataNetwork;->getPcoData()Ljava/util/Map;

    move-result-object v2

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {v2, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/PcoData;

    if-eqz v2, :cond_0

    .line 3053
    iget-object v2, v2, Landroid/telephony/PcoData;->contents:[B

    array-length v4, v2

    if-lez v4, :cond_0

    array-length v4, v2

    sub-int/2addr v4, v3

    aget-byte v2, v2, v4

    if-ne v2, v3, :cond_0

    move v0, v3

    .line 3060
    :cond_1
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNrAdvancedCapableByPco:Z

    if-eq v0, p1, :cond_2

    .line 3061
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onPcoDataChanged: mNrAdvancedCapableByPco = "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNrAdvancedCapableByPco:Z

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3062
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNrAdvancedCapableByPco:Z

    .line 3063
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda28;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda28;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-interface {p1, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    :cond_2
    return-void
.end method

.method private onReevaluateExistingDataNetworks(Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)V
    .locals 4

    .line 1807
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p1, "onReevaluateExistingDataNetworks: No existing data networks to re-evaluate."

    .line 1808
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void

    .line 1811
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Re-evaluating "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " existing data networks due to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1813
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_1
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataNetwork;

    .line 1814
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataNetwork;->isConnecting()Z

    move-result v2

    if-nez v2, :cond_2

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 1815
    :cond_2
    invoke-virtual {p0, v1, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->evaluateDataNetwork(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)Lcom/android/internal/telephony/data/DataEvaluation;

    move-result-object v2

    .line 1816
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result v3

    if-eqz v3, :cond_1

    .line 1817
    invoke-static {v2}, Lcom/android/internal/telephony/data/DataNetworkController;->getTearDownReason(Lcom/android/internal/telephony/data/DataEvaluation;)I

    move-result v2

    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->tearDownGracefully(Lcom/android/internal/telephony/data/DataNetwork;I)V

    goto :goto_0

    :cond_3
    return-void
.end method

.method private onReevaluateUnsatisfiedNetworkRequests(Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)V
    .locals 4

    .line 1603
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->getGroupedUnsatisfiedNetworkRequests()Ljava/util/List;

    move-result-object v0

    .line 1604
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Re-evaluating "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda13;

    invoke-direct {v3}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda13;-><init>()V

    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->mapToInt(Ljava/util/function/ToIntFunction;)Ljava/util/stream/IntStream;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/stream/IntStream;->sum()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " unsatisfied network requests in "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1605
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " groups, "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1606
    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda14;

    invoke-direct {v3}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda14;-><init>()V

    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v2

    const-string v3, ", "

    .line 1609
    invoke-static {v3}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v3

    invoke-interface {v2, v3}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " due to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1604
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1612
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    .line 1613
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->findCompatibleDataNetworkAndAttach(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Z

    move-result v2

    if-eqz v2, :cond_1

    goto :goto_0

    :cond_1
    const/4 v2, 0x0

    .line 1620
    invoke-virtual {v1, v2}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {p0, v1, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->evaluateNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)Lcom/android/internal/telephony/data/DataEvaluation;

    move-result-object v1

    .line 1621
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result v2

    if-nez v2, :cond_0

    .line 1622
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataEvaluation;->getCandidateDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v2

    if-eqz v2, :cond_0

    const/4 v3, 0x0

    .line 1625
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataEvaluation;->getDataAllowedReason()Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    move-result-object v1

    .line 1624
    invoke-direct {p0, v2, v3, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->setupDataNetwork(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_0

    :cond_2
    return-void
.end method

.method private onServiceStateChanged()V
    .locals 13

    .line 3189
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    .line 3190
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "onServiceStateChanged: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 3193
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v2, v0}, Landroid/telephony/ServiceState;->equals(Ljava/lang/Object;)Z

    move-result v2

    const/4 v3, 0x0

    if-nez v2, :cond_7

    .line 3194
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "onServiceStateChanged: changed to "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3195
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v2

    array-length v4, v2

    move v5, v3

    move v6, v5

    :goto_0
    if-ge v3, v4, :cond_6

    aget v7, v2, v3

    .line 3196
    iget-object v8, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    const/4 v9, 0x2

    invoke-virtual {v8, v9, v7}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v8

    .line 3198
    invoke-virtual {v0, v9, v7}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v9

    const-string v10, "["

    .line 3200
    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3201
    invoke-static {v7}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v10

    .line 3200
    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, ": "

    .line 3201
    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v10, 0x0

    if-eqz v8, :cond_0

    .line 3203
    invoke-virtual {v8}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v11

    .line 3202
    invoke-static {v11}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object v11

    goto :goto_1

    :cond_0
    move-object v11, v10

    :goto_1
    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v11, "->"

    .line 3204
    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v9, :cond_1

    .line 3206
    invoke-virtual {v9}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v12

    .line 3205
    invoke-static {v12}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object v12

    goto :goto_2

    :cond_1
    move-object v12, v10

    .line 3204
    :goto_2
    invoke-virtual {v1, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v12, ", "

    .line 3206
    invoke-virtual {v1, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v8, :cond_2

    .line 3209
    invoke-virtual {v8}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v12

    .line 3208
    invoke-static {v12}, Landroid/telephony/NetworkRegistrationInfo;->registrationStateToString(I)Ljava/lang/String;

    move-result-object v12

    goto :goto_3

    :cond_2
    move-object v12, v10

    .line 3207
    :goto_3
    invoke-virtual {v1, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3210
    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v9, :cond_3

    .line 3212
    invoke-virtual {v9}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v10

    .line 3211
    invoke-static {v10}, Landroid/telephony/NetworkRegistrationInfo;->registrationStateToString(I)Ljava/lang/String;

    move-result-object v10

    .line 3210
    :cond_3
    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v10, "] "

    .line 3212
    invoke-virtual {v1, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3213
    invoke-direct {p0, v8, v9}, Lcom/android/internal/telephony/data/DataNetworkController;->shouldReevaluateDataNetworks(Landroid/telephony/NetworkRegistrationInfo;Landroid/telephony/NetworkRegistrationInfo;)Z

    move-result v8

    const/4 v9, 0x1

    if-eqz v8, :cond_4

    const/16 v8, 0x10

    .line 3214
    invoke-virtual {p0, v8}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v10

    if-nez v10, :cond_4

    .line 3215
    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_SERVICE_STATE_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v8, v6}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v6

    invoke-virtual {p0, v6}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    move v6, v9

    .line 3220
    :cond_4
    iget-object v8, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-direct {p0, v8, v0, v7}, Lcom/android/internal/telephony/data/DataNetworkController;->shouldReevaluateNetworkRequests(Landroid/telephony/ServiceState;Landroid/telephony/ServiceState;I)Z

    move-result v7

    if-eqz v7, :cond_5

    const/4 v7, 0x5

    .line 3221
    invoke-virtual {p0, v7}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v8

    if-nez v8, :cond_5

    .line 3222
    sget-object v5, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_SERVICE_STATE_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v7, v5}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v5

    invoke-virtual {p0, v5}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    move v5, v9

    :cond_5
    add-int/lit8 v3, v3, 0x1

    goto/16 :goto_0

    .line 3228
    :cond_6
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    move v3, v5

    goto :goto_4

    :cond_7
    const-string v0, "not changed"

    .line 3230
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v6, v3

    :goto_4
    const-string v0, ". Evaluating network requests is "

    .line 3232
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ""

    const-string v2, "not "

    if-eqz v3, :cond_8

    move-object v3, v0

    goto :goto_5

    :cond_8
    move-object v3, v2

    :goto_5
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "needed, evaluating existing data networks is "

    .line 3233
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v6, :cond_9

    goto :goto_6

    :cond_9
    move-object v0, v2

    .line 3234
    :goto_6
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "needed."

    .line 3235
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3236
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void
.end method

.method private onSimStateChanged(I)V
    .locals 2
    .param p1    # I
        .annotation build Landroid/telephony/TelephonyManager$SimState;
        .end annotation
    .end param

    .line 2921
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onSimStateChanged: state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;->simStateString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2922
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSimState:I

    if-eq v0, p1, :cond_1

    .line 2923
    iput p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSimState:I

    const/4 v0, 0x1

    if-ne p1, v0, :cond_0

    .line 2925
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->onSimAbsent()V

    goto :goto_0

    :cond_0
    const/16 v0, 0xa

    if-ne p1, v0, :cond_1

    const/4 p1, 0x5

    .line 2927
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->SIM_LOADED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, p1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    :cond_1
    :goto_0
    return-void
.end method

.method private onSubscriptionChanged()V
    .locals 2

    .line 2245
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubId:I

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    if-eq v0, v1, :cond_2

    .line 2246
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataConfigUpdated: mSubId changed from "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 2247
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2246
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2248
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->isImsGracefulTearDownSupported()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2249
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2250
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->registerImsStateCallback(I)V

    goto :goto_0

    .line 2252
    :cond_0
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubId:I

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->unregisterImsStateCallbacks(I)V

    .line 2255
    :cond_1
    :goto_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubId:I

    .line 2256
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->updateSubscriptionPlans()V

    :cond_2
    return-void
.end method

.method private onTrackNetworkUnwanted()V
    .locals 2

    .line 2311
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNetworkUnwantedCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->addOccurrence()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2312
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Network Unwanted called "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNetworkUnwantedCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 2313
    invoke-virtual {v1}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->getFrequencyString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "9f3bc55b-bfa6-4e26-afaa-5031426a66d3"

    .line 2312
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method private registerImsFeatureRegistrationState(II)V
    .locals 3

    .line 2110
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$10;

    invoke-direct {v0, p0, p2}, Lcom/android/internal/telephony/data/DataNetworkController$10;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;I)V

    const/4 v1, 0x1

    if-eq p2, v1, :cond_1

    const/4 v1, 0x2

    if-eq p2, v1, :cond_0

    goto :goto_0

    .line 2137
    :cond_0
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsManager:Landroid/telephony/ims/ImsManager;

    invoke-virtual {v1, p1}, Landroid/telephony/ims/ImsManager;->getImsRcsManager(I)Landroid/telephony/ims/ImsRcsManager;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-virtual {v1, v2, v0}, Landroid/telephony/ims/ImsRcsManager;->registerImsRegistrationCallback(Ljava/util/concurrent/Executor;Landroid/telephony/ims/RegistrationManager$RegistrationCallback;)V

    goto :goto_0

    .line 2133
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsManager:Landroid/telephony/ims/ImsManager;

    invoke-virtual {v1, p1}, Landroid/telephony/ims/ImsManager;->getImsMmTelManager(I)Landroid/telephony/ims/ImsMmTelManager;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-virtual {v1, v2, v0}, Landroid/telephony/ims/ImsMmTelManager;->registerImsRegistrationCallback(Ljava/util/concurrent/Executor;Landroid/telephony/ims/RegistrationManager$RegistrationCallback;)V

    .line 2143
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsFeatureRegistrationCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v1, p2, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 2144
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Successfully register "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Lcom/android/internal/telephony/data/DataUtils;->imsFeatureToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " registration state. subId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V
    :try_end_0
    .catch Landroid/telephony/ims/ImsException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception v0

    .line 2147
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "updateImsFeatureRegistrationStateListening: subId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", imsFeature="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2148
    invoke-static {p2}, Lcom/android/internal/telephony/data/DataUtils;->imsFeatureToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2147
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    :goto_1
    return-void
.end method

.method private registerImsStateCallback(I)V
    .locals 5

    .line 2183
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda45;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda45;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;I)V

    const/4 v1, 0x1

    .line 2207
    :try_start_0
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/function/Function;->apply(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/ims/ImsStateCallback;

    .line 2208
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsManager:Landroid/telephony/ims/ImsManager;

    invoke-virtual {v3, p1}, Landroid/telephony/ims/ImsManager;->getImsMmTelManager(I)Landroid/telephony/ims/ImsMmTelManager;

    move-result-object v3

    new-instance v4, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v4, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-virtual {v3, v4, v2}, Landroid/telephony/ims/ImsMmTelManager;->registerImsStateCallback(Ljava/util/concurrent/Executor;Landroid/telephony/ims/ImsStateCallback;)V

    .line 2210
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsStateCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v3, v1, v2}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 2211
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Successfully register MMTEL state on sub "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    const/4 v1, 0x2

    .line 2213
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/function/Function;->apply(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/ims/ImsStateCallback;

    .line 2214
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsManager:Landroid/telephony/ims/ImsManager;

    invoke-virtual {v2, p1}, Landroid/telephony/ims/ImsManager;->getImsRcsManager(I)Landroid/telephony/ims/ImsRcsManager;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v3, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-virtual {v2, v3, v0}, Landroid/telephony/ims/ImsRcsManager;->registerImsStateCallback(Ljava/util/concurrent/Executor;Landroid/telephony/ims/ImsStateCallback;)V

    .line 2215
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsStateCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v2, v1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 2216
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Successfully register RCS state on sub "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V
    :try_end_0
    .catch Landroid/telephony/ims/ImsException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 2218
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Exception when registering IMS state callback. "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method private reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 2555
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    .line 2556
    invoke-static {p2}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object p2

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result p0

    invoke-static {p2, p1, p0}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V

    return-void
.end method

.method private serviceStateAllowsPSAttach(Landroid/telephony/ServiceState;I)Z
    .locals 2

    .line 1306
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataRegistrationState(Landroid/telephony/ServiceState;I)I

    move-result p2

    const/4 v0, 0x1

    if-eq p2, v0, :cond_2

    const/4 v1, 0x5

    if-ne p2, v1, :cond_0

    goto :goto_0

    .line 1312
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getVoiceRegState()I

    move-result p2

    if-nez p2, :cond_1

    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1313
    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p2

    invoke-static {}, Lcom/android/internal/telephony/data/PhoneSwitcher;->getInstance()Lcom/android/internal/telephony/data/PhoneSwitcher;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/PhoneSwitcher;->getPreferredDataPhoneId()I

    move-result v1

    if-eq p2, v1, :cond_1

    .line 1314
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getVoiceNetworkType()I

    move-result p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->isLegacyCs(I)Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    :cond_2
    :goto_0
    return v0
.end method

.method private setupDataNetwork(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V
    .locals 12

    .line 2344
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onSetupDataNetwork: dataProfile="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", retryEntry="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", allowed reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", service state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2347
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    const/4 v2, 0x4

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataNetwork;

    .line 2348
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataNetwork;->getDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v3

    invoke-virtual {v3, p1}, Landroid/telephony/data/DataProfile;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 2349
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "onSetupDataNetwork: Found existing data network "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p3, " has the same data profile."

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    if-eqz p2, :cond_1

    .line 2352
    invoke-virtual {p2, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    :cond_1
    return-void

    .line 2358
    :cond_2
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->findSatisfiableNetworkRequests(Landroid/telephony/data/DataProfile;)Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    move-result-object v8

    .line 2360
    invoke-virtual {v8}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    const-string p1, "Can\'t find any unsatisfied network requests that can be satisfied by this data profile."

    .line 2361
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    if-eqz p2, :cond_3

    .line 2364
    invoke-virtual {p2, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    :cond_3
    return-void

    .line 2370
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    const/4 v1, 0x0

    .line 2371
    invoke-virtual {v8, v1}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result v2

    .line 2370
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransportByNetworkCapability(I)I

    move-result v9

    .line 2372
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Creating data network on "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2373
    invoke-static {v9}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " with "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ", and attaching "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2374
    invoke-virtual {v8}, Ljava/util/LinkedList;->size()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " network requests to it."

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2372
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    .line 2376
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_5

    .line 2378
    invoke-virtual {v8, v1}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->getProfileID(I)I

    move-result v1

    .line 2379
    invoke-virtual {v0, v1}, Landroid/telephony/data/ApnSetting;->setProfileId(I)V

    if-nez p2, :cond_5

    .line 2381
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->resetMdDataRetryCount(Landroid/telephony/data/ApnSetting;)V

    .line 2387
    :cond_5
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v0

    const-class v1, Lcom/android/internal/telephony/TelephonyComponentFactory;

    .line 2388
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    .line 2387
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v3

    .line 2389
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v5

    iget-object v6, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceManagers:Landroid/util/SparseArray;

    new-instance v11, Lcom/android/internal/telephony/data/DataNetworkController$12;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-direct {v11, p0, v1, p2}, Lcom/android/internal/telephony/data/DataNetworkController$12;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/util/concurrent/Executor;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V

    move-object v7, p1

    move-object v10, p3

    invoke-virtual/range {v3 .. v11}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeDataNetwork(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;Landroid/util/SparseArray;Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;ILcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;)Lcom/android/internal/telephony/data/DataNetwork;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 2475
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    if-nez p1, :cond_6

    const/4 p1, 0x1

    .line 2476
    iput-boolean p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    .line 2477
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance p2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda7;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda7;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-interface {p1, p2}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    :cond_6
    return-void
.end method

.method private shouldReevaluateDataNetworks(Landroid/telephony/NetworkRegistrationInfo;Landroid/telephony/NetworkRegistrationInfo;)Z
    .locals 3

    const/4 p0, 0x0

    if-eqz p1, :cond_7

    if-nez p2, :cond_0

    goto :goto_1

    .line 3102
    :cond_0
    invoke-virtual {p2}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v0

    if-nez v0, :cond_1

    return p0

    .line 3108
    :cond_1
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v0

    invoke-virtual {p2}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v1

    const/4 v2, 0x1

    if-ne v0, v1, :cond_6

    .line 3109
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->isRoaming()Z

    move-result v0

    if-nez v0, :cond_2

    invoke-virtual {p2}, Landroid/telephony/NetworkRegistrationInfo;->isRoaming()Z

    move-result v0

    if-eqz v0, :cond_2

    goto :goto_0

    .line 3113
    :cond_2
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getDataSpecificInfo()Landroid/telephony/DataSpecificRegistrationInfo;

    move-result-object p1

    .line 3114
    invoke-virtual {p2}, Landroid/telephony/NetworkRegistrationInfo;->getDataSpecificInfo()Landroid/telephony/DataSpecificRegistrationInfo;

    move-result-object p2

    if-nez p2, :cond_3

    return p0

    :cond_3
    if-eqz p1, :cond_4

    .line 3117
    invoke-virtual {p1}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 3118
    invoke-virtual {p1}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/VopsSupportInfo;->isVopsSupported()Z

    move-result p1

    if-eqz p1, :cond_5

    .line 3119
    :cond_4
    invoke-virtual {p2}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object p1

    if-eqz p1, :cond_5

    invoke-virtual {p2}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object p1

    .line 3120
    invoke-virtual {p1}, Landroid/telephony/VopsSupportInfo;->isVopsSupported()Z

    move-result p1

    if-nez p1, :cond_5

    return v2

    :cond_5
    return p0

    :cond_6
    :goto_0
    return v2

    :cond_7
    :goto_1
    return p0
.end method

.method private shouldReevaluateNetworkRequests(Landroid/telephony/ServiceState;Landroid/telephony/ServiceState;I)Z
    .locals 6

    const/4 v0, 0x2

    .line 3140
    invoke-virtual {p1, v0, p3}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v1

    .line 3142
    invoke-virtual {p2, v0, p3}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v0

    const/4 v2, 0x0

    if-nez v0, :cond_0

    return v2

    .line 3146
    :cond_0
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v3

    if-nez v3, :cond_1

    return v2

    :cond_1
    const/4 v3, 0x1

    if-eqz v1, :cond_7

    .line 3153
    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v4

    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v5

    if-ne v4, v5, :cond_7

    .line 3154
    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v4

    if-nez v4, :cond_2

    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v4

    if-eqz v4, :cond_2

    goto :goto_0

    .line 3159
    :cond_2
    invoke-direct {p0, p1, p3}, Lcom/android/internal/telephony/data/DataNetworkController;->serviceStateAllowsPSAttach(Landroid/telephony/ServiceState;I)Z

    move-result p1

    if-nez p1, :cond_3

    .line 3160
    invoke-direct {p0, p2, p3}, Lcom/android/internal/telephony/data/DataNetworkController;->serviceStateAllowsPSAttach(Landroid/telephony/ServiceState;I)Z

    move-result p0

    if-eqz p0, :cond_3

    return v3

    .line 3164
    :cond_3
    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->getDataSpecificInfo()Landroid/telephony/DataSpecificRegistrationInfo;

    move-result-object p0

    .line 3165
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getDataSpecificInfo()Landroid/telephony/DataSpecificRegistrationInfo;

    move-result-object p1

    if-nez p0, :cond_4

    return v2

    :cond_4
    if-eqz p1, :cond_5

    .line 3168
    invoke-virtual {p1}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object p2

    if-eqz p2, :cond_5

    .line 3169
    invoke-virtual {p1}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/VopsSupportInfo;->isVopsSupported()Z

    move-result p1

    if-eqz p1, :cond_6

    .line 3170
    :cond_5
    invoke-virtual {p0}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object p1

    if-eqz p1, :cond_6

    invoke-virtual {p0}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object p0

    .line 3171
    invoke-virtual {p0}, Landroid/telephony/VopsSupportInfo;->isVopsSupported()Z

    move-result p0

    if-nez p0, :cond_6

    return v3

    :cond_6
    return v2

    :cond_7
    :goto_0
    return v3
.end method

.method private tearDownGracefully(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 7
    .param p2    # I
        .annotation build Lcom/android/internal/telephony/data/DataNetwork$TearDownReason;
        .end annotation
    .end param

    .line 3501
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getImsDeregistrationDelay()J

    move-result-wide v0

    .line 3502
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->isImsGracefulTearDownSupported()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->isSafeToTearDown(Lcom/android/internal/telephony/data/DataNetwork;)Z

    move-result v2

    if-nez v2, :cond_3

    .line 3503
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "tearDownGracefully: Not safe to tear down "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, " at this point. Wait for IMS de-registration or timeout. MMTEL="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3505
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mRegisteredImsFeatures:Ljava/util/Set;

    const/4 v4, 0x1

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {v3, v4}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v3

    const-string v4, "registered"

    const-string v5, "not registered"

    if-eqz v3, :cond_0

    move-object v3, v4

    goto :goto_0

    :cond_0
    move-object v3, v5

    .line 3506
    :goto_0
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ", RCS="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3508
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mRegisteredImsFeatures:Ljava/util/Set;

    const/4 v6, 0x2

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-interface {v3, v6}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    goto :goto_1

    :cond_1
    move-object v4, v5

    .line 3509
    :goto_1
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 3503
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3511
    invoke-virtual {p1, p2, v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->tearDownWhenConditionMet(IJ)Ljava/lang/Runnable;

    move-result-object p2

    if-eqz p2, :cond_2

    .line 3513
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingImsDeregDataNetworks:Ljava/util/Map;

    invoke-interface {p0, p1, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_2

    .line 3515
    :cond_2
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " is being torn down already."

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    goto :goto_2

    .line 3519
    :cond_3
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "tearDownGracefully: Safe to tear down "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3520
    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->tearDown(I)V

    :goto_2
    return-void
.end method

.method private trackSetupDataCallFailure(I)V
    .locals 1

    const/4 v0, 0x1

    if-eq p1, v0, :cond_1

    const/4 v0, 0x2

    if-eq p1, v0, :cond_0

    const-string/jumbo p1, "trackSetupDataCallFailure: INVALID transport."

    .line 2544
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 2537
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSetupDataCallWlanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    invoke-virtual {p1}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->addOccurrence()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 2538
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "IWLAN data service fails setup data call request "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSetupDataCallWlanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 2539
    invoke-virtual {v0}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->getFrequencyString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "e2248d8b-d55f-42bd-871c-0cfd80c3ddd1"

    .line 2538
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 2526
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSignalStrength()Landroid/telephony/SignalStrength;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/SignalStrength;->getLevel()I

    move-result p1

    if-gt p1, v0, :cond_2

    return-void

    .line 2530
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSetupDataCallWwanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    invoke-virtual {p1}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->addOccurrence()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 2531
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "RIL fails setup data call request "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSetupDataCallWwanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 2532
    invoke-virtual {v0}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->getFrequencyString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "e6a98b97-9e34-4977-9a92-01d52a6691f6"

    .line 2531
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V

    :cond_3
    :goto_0
    return-void
.end method

.method private unregisterImsFeatureRegistrationState(II)V
    .locals 2

    .line 2161
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsFeatureRegistrationCallbacks:Landroid/util/SparseArray;

    .line 2162
    invoke-virtual {v0, p2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/ims/RegistrationManager$RegistrationCallback;

    if-eqz v0, :cond_2

    const/4 v1, 0x1

    if-ne p2, v1, :cond_0

    .line 2165
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsManager:Landroid/telephony/ims/ImsManager;

    invoke-virtual {v1, p1}, Landroid/telephony/ims/ImsManager;->getImsMmTelManager(I)Landroid/telephony/ims/ImsMmTelManager;

    move-result-object v1

    .line 2166
    invoke-virtual {v1, v0}, Landroid/telephony/ims/ImsMmTelManager;->unregisterImsRegistrationCallback(Landroid/telephony/ims/RegistrationManager$RegistrationCallback;)V

    goto :goto_0

    :cond_0
    const/4 v1, 0x2

    if-ne p2, v1, :cond_1

    .line 2168
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsManager:Landroid/telephony/ims/ImsManager;

    invoke-virtual {v1, p1}, Landroid/telephony/ims/ImsManager;->getImsRcsManager(I)Landroid/telephony/ims/ImsRcsManager;

    move-result-object v1

    .line 2169
    invoke-virtual {v1, v0}, Landroid/telephony/ims/ImsRcsManager;->unregisterImsRegistrationCallback(Landroid/telephony/ims/RegistrationManager$RegistrationCallback;)V

    .line 2171
    :cond_1
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Successfully unregistered "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Lcom/android/internal/telephony/data/DataUtils;->imsFeatureToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " registration state. sudId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2173
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsFeatureRegistrationCallbacks:Landroid/util/SparseArray;

    invoke-virtual {p0, p2}, Landroid/util/SparseArray;->remove(I)V

    :cond_2
    return-void
.end method

.method private unregisterImsStateCallbacks(I)V
    .locals 3

    .line 2228
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsStateCallbacks:Landroid/util/SparseArray;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/ims/ImsStateCallback;

    if-eqz v0, :cond_0

    .line 2230
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsManager:Landroid/telephony/ims/ImsManager;

    invoke-virtual {v2, p1}, Landroid/telephony/ims/ImsManager;->getImsMmTelManager(I)Landroid/telephony/ims/ImsMmTelManager;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/telephony/ims/ImsMmTelManager;->unregisterImsStateCallback(Landroid/telephony/ims/ImsStateCallback;)V

    .line 2231
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsStateCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->remove(I)V

    .line 2232
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unregister MMTEL state on sub "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2235
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsStateCallbacks:Landroid/util/SparseArray;

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/ims/ImsStateCallback;

    if-eqz v0, :cond_1

    .line 2237
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsManager:Landroid/telephony/ims/ImsManager;

    invoke-virtual {v2, p1}, Landroid/telephony/ims/ImsManager;->getImsRcsManager(I)Landroid/telephony/ims/ImsRcsManager;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/telephony/ims/ImsRcsManager;->unregisterImsStateCallback(Landroid/telephony/ims/ImsStateCallback;)V

    .line 2238
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsStateCallbacks:Landroid/util/SparseArray;

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->remove(I)V

    .line 2239
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unregister RCS state on sub "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    :cond_1
    return-void
.end method

.method private updateAnomalySlidingWindowCounters()V
    .locals 4

    .line 2289
    new-instance v0, Lcom/android/internal/telephony/SlidingWindowEventCounter;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2290
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyImsReleaseRequestThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v1

    iget-wide v1, v1, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->timeWindow:J

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2291
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyImsReleaseRequestThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v3

    iget v3, v3, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->eventNumOccurrence:I

    invoke-direct {v0, v1, v2, v3}, Lcom/android/internal/telephony/SlidingWindowEventCounter;-><init>(JI)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsThrottleCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 2292
    new-instance v0, Lcom/android/internal/telephony/SlidingWindowEventCounter;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2293
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyNetworkUnwantedThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v1

    iget-wide v1, v1, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->timeWindow:J

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2294
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalyNetworkUnwantedThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v3

    iget v3, v3, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->eventNumOccurrence:I

    invoke-direct {v0, v1, v2, v3}, Lcom/android/internal/telephony/SlidingWindowEventCounter;-><init>(JI)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNetworkUnwantedCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 2295
    new-instance v0, Lcom/android/internal/telephony/SlidingWindowEventCounter;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2296
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalySetupDataCallThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v1

    iget-wide v1, v1, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->timeWindow:J

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2297
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalySetupDataCallThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v3

    iget v3, v3, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->eventNumOccurrence:I

    invoke-direct {v0, v1, v2, v3}, Lcom/android/internal/telephony/SlidingWindowEventCounter;-><init>(JI)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSetupDataCallWwanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    .line 2298
    new-instance v0, Lcom/android/internal/telephony/SlidingWindowEventCounter;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2299
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalySetupDataCallThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v1

    iget-wide v1, v1, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->timeWindow:J

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2300
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataConfigManager;->getAnomalySetupDataCallThreshold()Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;

    move-result-object v3

    iget v3, v3, Lcom/android/internal/telephony/data/DataConfigManager$EventFrequency;->eventNumOccurrence:I

    invoke-direct {v0, v1, v2, v3}, Lcom/android/internal/telephony/SlidingWindowEventCounter;-><init>(JI)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSetupDataCallWlanFailureCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    return-void
.end method

.method private updateDataActivity()V
    .locals 3

    .line 2026
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->isDataDormant()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x4

    goto :goto_0

    .line 2028
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getLinkBandwidthEstimator()Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 2029
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getLinkBandwidthEstimator()Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->getDataActivity()I

    move-result v0

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    .line 2032
    :goto_0
    iget v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataActivity:I

    if-eq v1, v0, :cond_2

    .line 2033
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "updateDataActivity: dataActivity="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2034
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataUtils;->dataActivityToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 2033
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->logv(Ljava/lang/String;)V

    .line 2035
    iput v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataActivity:I

    .line 2036
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->notifyDataActivity()V

    :cond_2
    return-void
.end method

.method private updateNetworkRequestsPriority()V
    .locals 1

    .line 2280
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p0}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 2281
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->updatePriority()V

    goto :goto_0

    :cond_0
    return-void
.end method

.method private updateOverallInternetDataState()V
    .locals 6

    .line 3245
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda40;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda40;-><init>()V

    .line 3246
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v0

    .line 3249
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda17;

    invoke-direct {v2}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda17;-><init>()V

    .line 3250
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda41;

    invoke-direct {v2}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda41;-><init>()V

    .line 3251
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v1

    .line 3253
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/List;

    .line 3254
    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result v2

    const/4 v3, 0x0

    if-nez v2, :cond_0

    .line 3255
    invoke-interface {v1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v2

    new-instance v4, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda42;

    invoke-direct {v4}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda42;-><init>()V

    invoke-interface {v2, v4}, Ljava/util/stream/Stream;->allMatch(Ljava/util/function/Predicate;)Z

    move-result v2

    if-eqz v2, :cond_0

    const/4 v2, 0x1

    goto :goto_0

    :cond_0
    move v2, v3

    .line 3256
    :goto_0
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "isSuspended="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v5, ", anyInternetConnected="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v5, ", mDataNetworkList="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataNetworkController;->logv(Ljava/lang/String;)V

    const/4 v4, 0x3

    const/4 v5, 0x2

    if-eqz v2, :cond_1

    move v3, v4

    goto :goto_1

    :cond_1
    if-eqz v0, :cond_2

    move v3, v5

    .line 3266
    :cond_2
    :goto_1
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetDataNetworkState:I

    if-eq v0, v3, :cond_6

    .line 3267
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Internet data state changed from "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetDataNetworkState:I

    .line 3268
    invoke-static {v2}, Lcom/android/internal/telephony/util/TelephonyUtils;->dataStateToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " to "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3269
    invoke-static {v3}, Lcom/android/internal/telephony/util/TelephonyUtils;->dataStateToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "."

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 3267
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->logl(Ljava/lang/String;)V

    if-ne v3, v5, :cond_3

    .line 3271
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetDataNetworkState:I

    if-nez v0, :cond_3

    .line 3273
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda43;

    invoke-direct {v2, v1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda43;-><init>(Ljava/util/List;)V

    invoke-interface {v0, v2}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    goto :goto_2

    :cond_3
    if-nez v3, :cond_5

    .line 3278
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetDataNetworkState:I

    if-eq v0, v5, :cond_4

    if-ne v0, v4, :cond_5

    .line 3283
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda44;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda44;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    .line 3286
    :cond_5
    :goto_2
    iput v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetDataNetworkState:I

    :cond_6
    return-void
.end method

.method private updateSubscriptionPlans()V
    .locals 3

    .line 2999
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNetworkPolicyManager:Landroid/net/NetworkPolicyManager;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubId:I

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 3000
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v2

    .line 2999
    invoke-virtual {v0, v1, v2}, Landroid/net/NetworkPolicyManager;->getSubscriptionPlans(ILjava/lang/String;)[Landroid/telephony/SubscriptionPlan;

    move-result-object v0

    .line 3001
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubscriptionPlans:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->clear()V

    .line 3002
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubscriptionPlans:Ljava/util/List;

    if-eqz v0, :cond_0

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    goto :goto_0

    :cond_0
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v0

    :goto_0
    invoke-interface {v1, v0}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 3003
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mCongestedOverrideNetworkTypes:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    .line 3004
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mUnmeteredOverrideNetworkTypes:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->clear()V

    .line 3005
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Subscription plans initialized: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubscriptionPlans:Ljava/util/List;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public addNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V
    .locals 1

    const/4 v0, 0x2

    .line 1169
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 5

    .line 3588
    new-instance v0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 3589
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-class v1, Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "-"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3590
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Current data networks:"

    .line 3591
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3592
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3593
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataNetwork;

    .line 3594
    invoke-virtual {v1, p1, v0, p3}, Lcom/android/internal/telephony/data/DataNetwork;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    goto :goto_0

    .line 3596
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Pending tear down data networks:"

    .line 3598
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3599
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3600
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingImsDeregDataNetworks:Ljava/util/Map;

    invoke-interface {p2}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_1
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataNetwork;

    .line 3601
    invoke-virtual {v1, p1, v0, p3}, Lcom/android/internal/telephony/data/DataNetwork;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    goto :goto_1

    .line 3603
    :cond_1
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Previously connected data networks: (up to 10)"

    .line 3605
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3607
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3608
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPreviousConnectedDataNetworkList:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :cond_2
    :goto_2
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataNetwork;

    .line 3610
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_2

    .line 3611
    invoke-virtual {v1, p1, v0, p3}, Lcom/android/internal/telephony/data/DataNetwork;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    goto :goto_2

    .line 3614
    :cond_3
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "All telephony network requests:"

    .line 3616
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3617
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3618
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p2}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_3
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_4

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 3619
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/Object;)V

    goto :goto_3

    .line 3621
    :cond_4
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3623
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "IMS features registration state: MMTEL="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3624
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mRegisteredImsFeatures:Ljava/util/Set;

    const/4 v2, 0x1

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v1

    const-string v2, "registered"

    const-string v3, "not registered"

    if-eqz v1, :cond_5

    move-object v1, v2

    goto :goto_4

    :cond_5
    move-object v1, v3

    .line 3625
    :goto_4
    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", RCS="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3627
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mRegisteredImsFeatures:Ljava/util/Set;

    const/4 v4, 0x2

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {v1, v4}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_6

    goto :goto_5

    :cond_6
    move-object v2, v3

    .line 3628
    :goto_5
    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 3623
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3629
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mServiceState="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3630
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mPsRestricted="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPsRestricted:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3631
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mAnyDataNetworkExisting="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAnyDataNetworkExisting:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3632
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mInternetDataNetworkState="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetDataNetworkState:I

    .line 3633
    invoke-static {v1}, Lcom/android/internal/telephony/util/TelephonyUtils;->dataStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 3632
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3634
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mImsDataNetworkState="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsDataNetworkState:I

    .line 3635
    invoke-static {v1}, Lcom/android/internal/telephony/util/TelephonyUtils;->dataStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 3634
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3636
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataServiceBound="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceBound:Landroid/util/SparseBooleanArray;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3637
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mSimState="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSimState:I

    invoke-static {v1}, Lcom/android/internal/telephony/SubscriptionInfoUpdater;->simStateString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3638
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataNetworkControllerCallbacks="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Subscription plans:"

    .line 3639
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3640
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3641
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubscriptionPlans:Ljava/util/List;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda59;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda59;-><init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V

    invoke-interface {p2, v1}, Ljava/util/List;->forEach(Ljava/util/function/Consumer;)V

    .line 3642
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3643
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unmetered override network types="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mUnmeteredOverrideNetworkTypes:Ljava/util/Set;

    invoke-interface {v1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda7;

    invoke-direct {v2}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda7;-><init>()V

    .line 3644
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v1

    const-string v2, ","

    invoke-static {v2}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v3

    invoke-interface {v1, v3}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 3643
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3645
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Congested override network types="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mCongestedOverrideNetworkTypes:Ljava/util/Set;

    invoke-interface {v1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v3, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda7;

    invoke-direct {v3}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda7;-><init>()V

    .line 3646
    invoke-interface {v1, v3}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v1

    invoke-static {v2}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 3645
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3647
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mImsThrottleCounter="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsThrottleCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3648
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mNetworkUnwantedCounter="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNetworkUnwantedCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Local logs:"

    .line 3649
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3650
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3651
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 3652
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "-------------------------------------"

    .line 3654
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3655
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

    invoke-virtual {v1, p1, v0, p3}, Lcom/android/internal/telephony/data/DataProfileManager;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 3656
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3657
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    invoke-virtual {v1, p1, v0, p3}, Lcom/android/internal/telephony/data/DataRetryManager;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 3658
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3659
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    invoke-virtual {v1, p1, v0, p3}, Lcom/android/internal/telephony/data/DataSettingsManager;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 3660
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3661
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataStallRecoveryManager:Lcom/android/internal/telephony/data/DataStallRecoveryManager;

    invoke-virtual {v1, p1, v0, p3}, Lcom/android/internal/telephony/data/DataStallRecoveryManager;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 3662
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3663
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/data/DataConfigManager;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 3665
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-void
.end method

.method protected evaluateDataNetwork(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)Lcom/android/internal/telephony/data/DataEvaluation;
    .locals 9

    .line 1643
    new-instance v0, Lcom/android/internal/telephony/data/DataEvaluation;

    invoke-direct {v0, p2}, Lcom/android/internal/telephony/data/DataEvaluation;-><init>(Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)V

    .line 1645
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v1

    const/16 v2, 0xa

    invoke-virtual {v1, v2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 1647
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->EMERGENCY_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    .line 1648
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-object v0

    .line 1653
    :cond_0
    iget v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSimState:I

    if-eq v1, v2, :cond_1

    .line 1654
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->SIM_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1658
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->isInCdmaEcm()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 1659
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->CDMA_EMERGENCY_CALLBACK_MODE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1664
    :cond_2
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->isOnlySingleDataNetworkAllowed(I)Z

    move-result v1

    if-eqz v1, :cond_4

    .line 1665
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v1

    const/4 v2, 0x4

    .line 1666
    invoke-virtual {v1, v2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v1

    if-nez v1, :cond_4

    .line 1669
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v1}, Ljava/util/LinkedList;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda34;

    invoke-direct {v2, p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda34;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 1670
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda35;

    invoke-direct {v2, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda35;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 1673
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 1674
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ONLY_ALLOWED_SINGLE_NETWORK:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    goto :goto_0

    .line 1677
    :cond_3
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "evaluateDataNetwork: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " has the highest priority. No need to tear down"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1684
    :cond_4
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getAttachedNetworkRequestList()Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    move-result-object v1

    const/4 v2, 0x1

    new-array v3, v2, [I

    const/4 v4, 0x0

    const/16 v5, 0x21

    aput v5, v3, v4

    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->get([I)Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    move-result-object v1

    const/4 v3, 0x2

    if-eqz v1, :cond_6

    .line 1688
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->shouldDelayImsTearDown()Z

    move-result v1

    if-nez v1, :cond_5

    .line 1689
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v1

    if-ne v1, v2, :cond_6

    .line 1690
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v1, v3, v2}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v1

    if-eqz v1, :cond_6

    .line 1694
    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->getDataSpecificInfo()Landroid/telephony/DataSpecificRegistrationInfo;

    move-result-object v1

    if-eqz v1, :cond_6

    .line 1695
    invoke-virtual {v1}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object v4

    if-eqz v4, :cond_6

    .line 1696
    invoke-virtual {v1}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/VopsSupportInfo;->isVopsSupported()Z

    move-result v1

    if-nez v1, :cond_6

    .line 1697
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->VOPS_NOT_SUPPORTED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    goto :goto_1

    :cond_5
    const-string v1, "Ignored VoPS check due to delay IMS tear down until call ends."

    .line 1703
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1709
    :cond_6
    :goto_1
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabled()Z

    move-result v1

    xor-int/2addr v1, v2

    .line 1714
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v4}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v4

    if-eqz v4, :cond_7

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    invoke-virtual {v4}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataRoamingEnabled()Z

    move-result v4

    if-nez v4, :cond_7

    .line 1715
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ROAMING_DISABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1722
    :cond_7
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v4

    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataNetworkType(I)I

    move-result v4

    .line 1723
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v5

    .line 1724
    invoke-virtual {v5}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v6

    if-eqz v6, :cond_8

    .line 1726
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    iget-object v6, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 1728
    invoke-static {v6, v5}, Lcom/android/internal/telephony/data/DataUtils;->getHighestPriorityNetworkCapabilityFromDataProfile(Lcom/android/internal/telephony/data/DataConfigManager;Landroid/telephony/data/DataProfile;)I

    move-result v6

    .line 1727
    invoke-static {v6}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToApnType(I)I

    move-result v6

    .line 1726
    invoke-virtual {v1, v6}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabled(I)Z

    move-result v1

    xor-int/2addr v1, v2

    if-eqz v4, :cond_8

    .line 1734
    invoke-virtual {v5}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v6

    invoke-virtual {v6, v4}, Landroid/telephony/data/ApnSetting;->canSupportLingeringNetworkType(I)Z

    move-result v6

    if-nez v6, :cond_8

    .line 1735
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "networkType="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v4}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", networkTypeBitmask="

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1737
    invoke-virtual {v5}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/data/ApnSetting;->getNetworkTypeBitmask()I

    move-result v4

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ", lingeringNetworkTypeBitmask="

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1739
    invoke-virtual {v5}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/data/ApnSetting;->getLingeringNetworkTypeBitmask()J

    move-result-wide v7

    invoke-virtual {v6, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 1735
    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1740
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_NETWORK_TYPE_NOT_ALLOWED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    :cond_8
    if-eqz v1, :cond_9

    .line 1746
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_DISABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1752
    :cond_9
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

    invoke-virtual {v1, v5}, Lcom/android/internal/telephony/data/DataProfileManager;->isDataProfileCompatible(Landroid/telephony/data/DataProfile;)Z

    move-result v1

    if-nez v1, :cond_a

    .line 1753
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_PROFILE_INVALID:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1757
    :cond_a
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->isInternetSupported()Z

    move-result v1

    if-eqz v1, :cond_b

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

    .line 1758
    invoke-virtual {v1, v5}, Lcom/android/internal/telephony/data/DataProfileManager;->isDataProfilePreferred(Landroid/telephony/data/DataProfile;)Z

    move-result v1

    if-nez v1, :cond_b

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

    .line 1759
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataProfileManager;->isAnyPreferredDataProfileExisting()Z

    move-result v1

    if-eqz v1, :cond_b

    .line 1760
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_PROFILE_NOT_PREFERRED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1764
    :cond_b
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v1

    invoke-virtual {p0, v0, p1, p2, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->mtkEvaluateDataNetwork(Lcom/android/internal/telephony/data/DataEvaluation;Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;I)V

    .line 1767
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result p2

    if-nez p2, :cond_c

    .line 1769
    sget-object p2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->NORMAL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_2

    .line 1770
    :cond_c
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->containsHardDisallowedReasons()Z

    move-result p2

    if-nez p2, :cond_11

    .line 1774
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->isInEmergencyCall()Z

    move-result p2

    if-nez p2, :cond_d

    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result p2

    if-eqz p2, :cond_e

    :cond_d
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->isEmergencySupl()Z

    move-result p2

    if-eqz p2, :cond_e

    .line 1776
    sget-object p2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->EMERGENCY_SUPL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_2

    .line 1777
    :cond_e
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p2

    const/16 v1, 0xd

    invoke-virtual {p2, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p2

    if-nez p2, :cond_f

    .line 1780
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p2

    invoke-virtual {p2, v3}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p2

    if-nez p2, :cond_f

    .line 1783
    sget-object p2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->RESTRICTED_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_2

    .line 1784
    :cond_f
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result p2

    if-ne p2, v3, :cond_10

    .line 1786
    sget-object p2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->UNMETERED_USAGE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_2

    .line 1788
    :cond_10
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 1789
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v1

    .line 1790
    invoke-virtual {v1}, Landroid/net/NetworkCapabilities;->getCapabilities()[I

    move-result-object v1

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v3

    .line 1788
    invoke-virtual {p2, v1, v3}, Lcom/android/internal/telephony/data/DataConfigManager;->isAnyMeteredCapability([IZ)Z

    move-result p2

    xor-int/2addr p2, v2

    if-eqz p2, :cond_11

    .line 1792
    sget-object p2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->UNMETERED_USAGE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    .line 1797
    :cond_11
    :goto_2
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Evaluated "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, ", "

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-object v0
.end method

.method protected evaluateNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)Lcom/android/internal/telephony/data/DataEvaluation;
    .locals 6

    .line 1396
    new-instance v0, Lcom/android/internal/telephony/data/DataEvaluation;

    invoke-direct {v0, p2}, Lcom/android/internal/telephony/data/DataEvaluation;-><init>(Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)V

    .line 1397
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 1398
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result v2

    .line 1397
    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransportByNetworkCapability(I)I

    move-result v1

    const/16 v2, 0xa

    .line 1401
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 1402
    sget-object p2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->EMERGENCY_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    .line 1403
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

    .line 1404
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataNetworkType(I)I

    move-result v1

    .line 1403
    invoke-virtual {p2, p1, v1}, Lcom/android/internal/telephony/data/DataProfileManager;->getDataProfileForNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Landroid/telephony/data/DataProfile;

    move-result-object p2

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/data/DataEvaluation;->setCandidateDataProfile(Landroid/telephony/data/DataProfile;)V

    .line 1405
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->setEvaluation(Lcom/android/internal/telephony/data/DataEvaluation;)V

    .line 1406
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-object v0

    .line 1410
    :cond_0
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-direct {p0, v3, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->serviceStateAllowsPSAttach(Landroid/telephony/ServiceState;I)Z

    move-result v3

    if-nez v3, :cond_1

    .line 1411
    sget-object v3, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->NOT_IN_SERVICE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1415
    :cond_1
    iget v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSimState:I

    if-eq v3, v2, :cond_2

    .line 1416
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->SIM_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1420
    :cond_2
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataConfigManager;->isConfigCarrierSpecific()Z

    move-result v2

    if-nez v2, :cond_3

    .line 1421
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_CONFIG_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1425
    :cond_3
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v2

    invoke-virtual {v2}, Lcom/android/internal/telephony/CallTracker;->getState()Lcom/android/internal/telephony/PhoneConstants$State;

    move-result-object v2

    sget-object v3, Lcom/android/internal/telephony/PhoneConstants$State;->IDLE:Lcom/android/internal/telephony/PhoneConstants$State;

    if-eq v2, v3, :cond_4

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1426
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v2

    invoke-virtual {v2}, Lcom/android/internal/telephony/ServiceStateTracker;->isConcurrentVoiceAndDataAllowed()Z

    move-result v2

    if-nez v2, :cond_4

    .line 1427
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->CONCURRENT_VOICE_DATA_NOT_ALLOWED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    :cond_4
    const/4 v2, 0x2

    const/4 v3, 0x1

    if-ne v1, v3, :cond_5

    const/16 v4, 0x21

    .line 1433
    invoke-virtual {p1, v4}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v4

    if-eqz v4, :cond_5

    .line 1434
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v4, v2, v3}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v4

    if-eqz v4, :cond_5

    .line 1437
    invoke-virtual {v4}, Landroid/telephony/NetworkRegistrationInfo;->getDataSpecificInfo()Landroid/telephony/DataSpecificRegistrationInfo;

    move-result-object v4

    if-eqz v4, :cond_5

    .line 1438
    invoke-virtual {v4}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object v5

    if-eqz v5, :cond_5

    .line 1439
    invoke-virtual {v4}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/VopsSupportInfo;->isVopsSupported()Z

    move-result v4

    if-nez v4, :cond_5

    .line 1440
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->VOPS_NOT_SUPPORTED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1447
    :cond_5
    invoke-static {}, Landroid/telephony/SubscriptionManager;->getDefaultDataSubscriptionId()I

    move-result v4

    .line 1446
    invoke-static {v4}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v4

    if-nez v4, :cond_6

    .line 1448
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DEFAULT_DATA_UNSELECTED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1452
    :cond_6
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    invoke-virtual {v4}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v4

    if-eqz v4, :cond_7

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    invoke-virtual {v4}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataRoamingEnabled()Z

    move-result v4

    if-nez v4, :cond_7

    .line 1453
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ROAMING_DISABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1457
    :cond_7
    iget-boolean v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPsRestricted:Z

    if-eqz v4, :cond_8

    .line 1458
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_RESTRICTED_BY_NETWORK:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1462
    :cond_8
    iget-boolean v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingTearDownAllNetworks:Z

    if-eqz v4, :cond_9

    .line 1463
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->PENDING_TEAR_DOWN_ALL:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    :cond_9
    if-ne v1, v3, :cond_b

    .line 1469
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1470
    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v4

    invoke-virtual {v4}, Lcom/android/internal/telephony/ServiceStateTracker;->getDesiredPowerState()Z

    move-result v4

    if-eqz v4, :cond_a

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object v4, v4, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 1471
    invoke-interface {v4}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v4

    if-eq v4, v3, :cond_b

    .line 1472
    :cond_a
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->RADIO_POWER_OFF:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1476
    :cond_b
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v4

    invoke-virtual {v4}, Lcom/android/internal/telephony/ServiceStateTracker;->getPowerStateFromCarrier()Z

    move-result v4

    if-nez v4, :cond_c

    .line 1477
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->RADIO_DISABLED_BY_CARRIER:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1481
    :cond_c
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceBound:Landroid/util/SparseBooleanArray;

    invoke-virtual {v4, v1}, Landroid/util/SparseBooleanArray;->get(I)Z

    move-result v4

    if-nez v4, :cond_d

    .line 1482
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_SERVICE_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1486
    :cond_d
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->isInCdmaEcm()Z

    move-result v4

    if-eqz v4, :cond_e

    .line 1487
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->CDMA_EMERGENCY_CALLBACK_MODE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1492
    :cond_e
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->isOnlySingleDataNetworkAllowed(I)Z

    move-result v4

    if-eqz v4, :cond_f

    const/4 v4, 0x4

    .line 1493
    invoke-virtual {p1, v4}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v4

    if-nez v4, :cond_f

    .line 1495
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v4}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v4

    new-instance v5, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda58;

    invoke-direct {v5}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda58;-><init>()V

    .line 1496
    invoke-interface {v4, v5}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result v4

    if-eqz v4, :cond_f

    .line 1498
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ONLY_ALLOWED_SINGLE_NETWORK:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1503
    :cond_f
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    invoke-virtual {v4}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataInitialized()Z

    move-result v4

    if-eqz v4, :cond_10

    .line 1504
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    .line 1505
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result v5

    .line 1504
    invoke-static {v5}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToApnType(I)I

    move-result v5

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabled(I)Z

    move-result v4

    if-nez v4, :cond_11

    .line 1506
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_DISABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    goto :goto_0

    .line 1509
    :cond_10
    sget-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_SETTINGS_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1513
    :cond_11
    :goto_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result v4

    if-nez v4, :cond_12

    .line 1514
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->NORMAL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    .line 1516
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabled()Z

    move-result v2

    if-nez v2, :cond_17

    const/4 v2, 0x0

    .line 1517
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v2

    if-eqz v2, :cond_17

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    .line 1518
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataSettingsManager;->isMmsAlwaysAllowed()Z

    move-result v2

    if-eqz v2, :cond_17

    .line 1522
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->MMS_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_1

    .line 1524
    :cond_12
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->containsHardDisallowedReasons()Z

    move-result v4

    if-nez v4, :cond_17

    .line 1525
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->isInEmergencyCall()Z

    move-result v4

    if-nez v4, :cond_13

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result v4

    if-eqz v4, :cond_14

    .line 1526
    :cond_13
    invoke-virtual {p1, v3}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v4

    if-eqz v4, :cond_14

    .line 1528
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->EMERGENCY_SUPL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_1

    :cond_14
    const/16 v4, 0xd

    .line 1529
    invoke-virtual {p1, v4}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v4

    if-nez v4, :cond_15

    .line 1532
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v4

    if-nez v4, :cond_15

    .line 1534
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->RESTRICTED_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_1

    :cond_15
    if-ne v1, v2, :cond_16

    .line 1537
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->UNMETERED_USAGE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_1

    :cond_16
    if-ne v1, v3, :cond_17

    .line 1539
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->isMeteredRequest()Z

    move-result v2

    if-nez v2, :cond_17

    .line 1540
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->UNMETERED_USAGE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataAllowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    .line 1546
    :cond_17
    :goto_1
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

    .line 1547
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataNetworkType(I)I

    move-result v3

    invoke-virtual {v2, p1, v3}, Lcom/android/internal/telephony/data/DataProfileManager;->getDataProfileForNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Landroid/telephony/data/DataProfile;

    move-result-object v2

    if-nez v2, :cond_18

    .line 1549
    sget-object v3, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->NO_SUITABLE_DATA_PROFILE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    goto :goto_2

    .line 1550
    :cond_18
    sget-object v3, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->NEW_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    if-ne p2, v3, :cond_1a

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    .line 1551
    invoke-virtual {v3, v2, v1}, Lcom/android/internal/telephony/data/DataRetryManager;->isAnySetupRetryScheduled(Landroid/telephony/data/DataProfile;I)Z

    move-result v3

    if-nez v3, :cond_19

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    .line 1552
    invoke-virtual {v3, p1, v1}, Lcom/android/internal/telephony/data/DataRetryManager;->isSimilarNetworkRequestRetryScheduled(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z

    move-result v3

    if-eqz v3, :cond_1a

    .line 1557
    :cond_19
    sget-object v3, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->RETRY_SCHEDULED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    goto :goto_2

    .line 1558
    :cond_1a
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    invoke-virtual {v3, v2, v1}, Lcom/android/internal/telephony/data/DataRetryManager;->isDataProfileThrottled(Landroid/telephony/data/DataProfile;I)Z

    move-result v3

    if-eqz v3, :cond_1b

    .line 1559
    sget-object v3, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_THROTTLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/data/DataEvaluation;->addDataDisallowedReason(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)V

    .line 1563
    :cond_1b
    :goto_2
    invoke-virtual {p0, v0, p1, p2, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->mtkEvaluateNetworkRequest(Lcom/android/internal/telephony/data/DataEvaluation;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;I)V

    .line 1565
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result v3

    if-nez v3, :cond_1c

    .line 1566
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataEvaluation;->setCandidateDataProfile(Landroid/telephony/data/DataProfile;)V

    .line 1569
    :cond_1c
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->setEvaluation(Lcom/android/internal/telephony/data/DataEvaluation;)V

    .line 1571
    sget-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->EXTERNAL_QUERY:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    if-eq p2, v2, :cond_1d

    .line 1572
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataEvaluation;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ", network type="

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1573
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataNetworkType(I)I

    move-result v2

    invoke-static {v2}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ", reg state="

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    .line 1576
    invoke-virtual {p0, v2, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataRegistrationState(Landroid/telephony/ServiceState;I)I

    move-result v1

    .line 1575
    invoke-static {v1}, Landroid/telephony/NetworkRegistrationInfo;->registrationStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1572
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    :cond_1d
    return-object v0
.end method

.method public getCongestedOverrideNetworkTypes()Ljava/util/Set;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 3339
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mCongestedOverrideNetworkTypes:Ljava/util/Set;

    return-object p0
.end method

.method public getDataActivity()I
    .locals 0

    .line 3378
    iget p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataActivity:I

    return p0
.end method

.method public getDataConfigManager()Lcom/android/internal/telephony/data/DataConfigManager;
    .locals 0

    .line 3294
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    return-object p0
.end method

.method protected getDataNetworkType(I)I
    .locals 1

    .line 3349
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mServiceState:Landroid/telephony/ServiceState;

    const/4 v0, 0x2

    invoke-virtual {p0, v0, p1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 3352
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result p0

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public getDataProfileManager()Lcom/android/internal/telephony/data/DataProfileManager;
    .locals 0

    .line 3301
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

    return-object p0
.end method

.method protected getDataRegistrationState(Landroid/telephony/ServiceState;I)I
    .locals 0

    const/4 p0, 0x2

    .line 3366
    invoke-virtual {p1, p0, p2}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 3369
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result p0

    return p0

    :cond_0
    const/4 p0, 0x4

    return p0
.end method

.method public getDataRetryManager()Lcom/android/internal/telephony/data/DataRetryManager;
    .locals 0

    .line 3315
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataRetryManager:Lcom/android/internal/telephony/data/DataRetryManager;

    return-object p0
.end method

.method public getDataServicePackages()Ljava/util/List;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 3540
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const/4 v1, 0x0

    .line 3541
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceManagers:Landroid/util/SparseArray;

    invoke-virtual {v2}, Landroid/util/SparseArray;->size()I

    move-result v2

    if-ge v1, v2, :cond_0

    .line 3542
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceManagers:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/DataServiceManager;

    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataServiceManager;->getDataServicePackageName()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    return-object v0
.end method

.method public getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;
    .locals 0

    .line 3308
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataSettingsManager:Lcom/android/internal/telephony/data/DataSettingsManager;

    return-object p0
.end method

.method public getInternetDataDisallowedReasons()Ljava/util/List;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;",
            ">;"
        }
    .end annotation

    .line 1376
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    new-instance v1, Landroid/net/NetworkRequest$Builder;

    invoke-direct {v1}, Landroid/net/NetworkRequest$Builder;-><init>()V

    const/16 v2, 0xc

    .line 1378
    invoke-virtual {v1, v2}, Landroid/net/NetworkRequest$Builder;->addCapability(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v1

    const/4 v2, 0x0

    .line 1379
    invoke-virtual {v1, v2}, Landroid/net/NetworkRequest$Builder;->addTransportType(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v1

    .line 1380
    invoke-virtual {v1}, Landroid/net/NetworkRequest$Builder;->build()Landroid/net/NetworkRequest;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;-><init>(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/Phone;)V

    .line 1381
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->EXTERNAL_QUERY:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->evaluateNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)Lcom/android/internal/telephony/data/DataEvaluation;

    move-result-object p0

    .line 1383
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataEvaluation;->getDataDisallowedReasons()Ljava/util/List;

    move-result-object p0

    return-object p0
.end method

.method public getInternetDataNetworkState()I
    .locals 0

    .line 3533
    iget p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mInternetDataNetworkState:I

    return p0
.end method

.method protected getProfileID(I)I
    .locals 1

    if-eqz p1, :cond_9

    const/4 p0, 0x1

    if-eq p1, p0, :cond_8

    const/4 v0, 0x2

    if-eq p1, v0, :cond_7

    const/4 p0, 0x3

    if-eq p1, p0, :cond_7

    const/4 p0, 0x4

    if-eq p1, p0, :cond_6

    const/4 v0, 0x5

    if-eq p1, v0, :cond_5

    const/16 p0, 0x9

    if-eq p1, p0, :cond_4

    const/16 p0, 0xa

    if-eq p1, p0, :cond_3

    const/16 p0, 0x17

    if-eq p1, p0, :cond_2

    const/16 p0, 0x1e

    if-eq p1, p0, :cond_1

    const/16 p0, 0x1f

    if-eq p1, p0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const/16 p0, 0x3ef

    return p0

    :cond_1
    const/16 p0, 0x3f0

    return p0

    :cond_2
    const/16 p0, 0x3f1

    return p0

    :cond_3
    const/16 p0, 0x3ec

    return p0

    :cond_4
    const/16 p0, 0x3ed

    :cond_5
    return p0

    :cond_6
    return v0

    :cond_7
    return p0

    :cond_8
    const/16 p0, 0x3ea

    return p0

    :cond_9
    const/16 p0, 0x3e9

    return p0
.end method

.method public getSubscriptionPlans()Ljava/util/List;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/telephony/SubscriptionPlan;",
            ">;"
        }
    .end annotation

    .line 3323
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubscriptionPlans:Ljava/util/List;

    return-object p0
.end method

.method public getUnmeteredOverrideNetworkTypes()Ljava/util/Set;
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 3331
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mUnmeteredOverrideNetworkTypes:Ljava/util/Set;

    return-object p0
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 6

    .line 1022
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v1, 0x10

    const/4 v2, 0x0

    const/4 v3, 0x5

    const/4 v4, 0x1

    packed-switch v0, :pswitch_data_0

    .line 1157
    :pswitch_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected event "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    goto/16 :goto_5

    .line 1070
    :pswitch_1
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->TAC_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v3, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    sget-wide v0, Lcom/android/internal/telephony/data/DataNetworkController;->REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_TAC_CHANGED_DELAY_MILLIS:J

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto/16 :goto_5

    .line 1056
    :pswitch_2
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->SLICE_CONFIG_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v3, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto/16 :goto_5

    .line 1120
    :pswitch_3
    iget v0, p1, Landroid/os/Message;->arg1:I

    .line 1121
    iget v1, p1, Landroid/os/Message;->arg2:I

    if-eqz v1, :cond_0

    move v1, v4

    goto :goto_0

    :cond_0
    move v1, v2

    .line 1122
    :goto_0
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, [I

    const-string v3, ","

    const-string v5, ", networkTypes="

    if-ne v0, v4, :cond_3

    .line 1125
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Unmetered subscription override: override="

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1126
    invoke-static {p1}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v4

    new-instance v5, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda20;

    invoke-direct {v5}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda20;-><init>()V

    .line 1127
    invoke-interface {v4, v5}, Ljava/util/stream/IntStream;->mapToObj(Ljava/util/function/IntFunction;)Ljava/util/stream/Stream;

    move-result-object v4

    .line 1128
    invoke-static {v3}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v3

    invoke-interface {v4, v3}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1125
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1129
    array-length v0, p1

    :goto_1
    if-ge v2, v0, :cond_2

    aget v3, p1, v2

    if-eqz v1, :cond_1

    .line 1131
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mUnmeteredOverrideNetworkTypes:Ljava/util/Set;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v4, v3}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_2

    .line 1133
    :cond_1
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mUnmeteredOverrideNetworkTypes:Ljava/util/Set;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v4, v3}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 1136
    :cond_2
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance p1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda21;

    invoke-direct {p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda21;-><init>()V

    invoke-interface {p0, p1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    goto/16 :goto_5

    :cond_3
    const/4 v4, 0x2

    if-ne v0, v4, :cond_6

    .line 1139
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Congested subscription override: override="

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1140
    invoke-static {p1}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v4

    new-instance v5, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda20;

    invoke-direct {v5}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda20;-><init>()V

    .line 1141
    invoke-interface {v4, v5}, Ljava/util/stream/IntStream;->mapToObj(Ljava/util/function/IntFunction;)Ljava/util/stream/Stream;

    move-result-object v4

    .line 1142
    invoke-static {v3}, Ljava/util/stream/Collectors;->joining(Ljava/lang/CharSequence;)Ljava/util/stream/Collector;

    move-result-object v3

    invoke-interface {v4, v3}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1139
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1143
    array-length v0, p1

    :goto_3
    if-ge v2, v0, :cond_5

    aget v3, p1, v2

    if-eqz v1, :cond_4

    .line 1145
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mCongestedOverrideNetworkTypes:Ljava/util/Set;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v4, v3}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_4

    .line 1147
    :cond_4
    iget-object v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mCongestedOverrideNetworkTypes:Ljava/util/Set;

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v4, v3}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    :goto_4
    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    .line 1150
    :cond_5
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance p1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda22;

    invoke-direct {p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda22;-><init>()V

    invoke-interface {p0, p1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    goto/16 :goto_5

    .line 1153
    :cond_6
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown override mask: "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    goto/16 :goto_5

    .line 1112
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, [Landroid/telephony/SubscriptionPlan;

    .line 1113
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Subscription plans changed: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Ljava/util/Arrays;->toString([Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 1114
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubscriptionPlans:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 1115
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mSubscriptionPlans:Ljava/util/List;

    invoke-static {p1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1116
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance p1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda19;

    invoke-direct {p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda19;-><init>()V

    invoke-interface {p0, p1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    goto/16 :goto_5

    .line 1109
    :pswitch_5
    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onEvaluatePreferredTransport(I)V

    goto/16 :goto_5

    .line 1100
    :pswitch_6
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->isInEcm()Z

    move-result p1

    if-eqz p1, :cond_7

    .line 1101
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->EMERGENCY_CALL_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v1, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto/16 :goto_5

    .line 1104
    :cond_7
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->EMERGENCY_CALL_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v3, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto/16 :goto_5

    .line 1027
    :pswitch_7
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->onRegisterAllEvents()V

    goto/16 :goto_5

    .line 1046
    :pswitch_8
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->VOICE_CALL_ENDED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v1, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 1051
    invoke-virtual {p0, v3, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    sget-wide v0, Lcom/android/internal/telephony/data/DataNetworkController;->REEVALUATE_UNSATISFIED_NETWORK_REQUESTS_AFTER_CALL_END_DELAY_MILLIS:J

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto/16 :goto_5

    .line 1097
    :pswitch_9
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->onServiceStateChanged()V

    goto/16 :goto_5

    .line 1037
    :pswitch_a
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 1038
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onReevaluateExistingDataNetworks(Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)V

    goto :goto_5

    .line 1094
    :pswitch_b
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->onSubscriptionChanged()V

    goto :goto_5

    .line 1091
    :pswitch_c
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    goto :goto_5

    .line 1088
    :pswitch_d
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    goto :goto_5

    .line 1085
    :pswitch_e
    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onTearDownAllDataNetworks(I)V

    goto :goto_5

    .line 1081
    :pswitch_f
    iget p1, p1, Landroid/os/Message;->arg1:I

    .line 1082
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onSimStateChanged(I)V

    goto :goto_5

    .line 1075
    :pswitch_10
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1076
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 1077
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    .line 1078
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataServiceBindingChanged(IZ)V

    goto :goto_5

    .line 1063
    :pswitch_11
    iput-boolean v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPsRestricted:Z

    .line 1064
    sget-object p1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_RESTRICTED_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v3, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_5

    .line 1060
    :pswitch_12
    iput-boolean v4, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPsRestricted:Z

    goto :goto_5

    .line 1033
    :pswitch_13
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 1034
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onReevaluateUnsatisfiedNetworkRequests(Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)V

    goto :goto_5

    .line 1041
    :pswitch_14
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onRemoveNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    goto :goto_5

    .line 1030
    :pswitch_15
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->onAddNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    goto :goto_5

    .line 1024
    :pswitch_16
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->onDataConfigUpdated()V

    :goto_5
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_16
        :pswitch_15
        :pswitch_14
        :pswitch_0
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_0
        :pswitch_0
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
    .end packed-switch
.end method

.method public isInternetDataAllowed()Z
    .locals 3

    .line 1348
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    new-instance v1, Landroid/net/NetworkRequest$Builder;

    invoke-direct {v1}, Landroid/net/NetworkRequest$Builder;-><init>()V

    const/16 v2, 0xc

    .line 1350
    invoke-virtual {v1, v2}, Landroid/net/NetworkRequest$Builder;->addCapability(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v1

    const/4 v2, 0x0

    .line 1351
    invoke-virtual {v1, v2}, Landroid/net/NetworkRequest$Builder;->addTransportType(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v1

    .line 1352
    invoke-virtual {v1}, Landroid/net/NetworkRequest$Builder;->build()Landroid/net/NetworkRequest;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;-><init>(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/Phone;)V

    .line 1353
    sget-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->EXTERNAL_QUERY:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->evaluateNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)Lcom/android/internal/telephony/data/DataEvaluation;

    move-result-object p0

    .line 1355
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method public isInternetNetwork(I)Z
    .locals 2

    .line 1998
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataNetwork;

    .line 1999
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->getId()I

    move-result v1

    if-ne v1, p1, :cond_0

    .line 2000
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2001
    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v0

    const/16 v1, 0xc

    .line 2002
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public isInternetUnmetered()Z
    .locals 1

    .line 1362
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda49;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda49;-><init>()V

    .line 1363
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda17;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda17;-><init>()V

    .line 1364
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda50;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda50;-><init>()V

    .line 1365
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->allMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0
.end method

.method public isNetworkInterfaceExisting(Ljava/lang/String;)Z
    .locals 1

    .line 2095
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda31;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda31;-><init>()V

    .line 2096
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda32;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda32;-><init>(Ljava/lang/String;)V

    .line 2097
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0
.end method

.method public isNetworkRequestExisting(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z
    .locals 0

    .line 2085
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p0, p1}, Ljava/util/LinkedList;->contains(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method protected logl(Ljava/lang/String;)V
    .locals 0

    .line 3576
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3577
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected mtkEvaluateDataNetwork(Lcom/android/internal/telephony/data/DataEvaluation;Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;I)V
    .locals 0

    return-void
.end method

.method protected mtkEvaluateNetworkRequest(Lcom/android/internal/telephony/data/DataEvaluation;Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;I)V
    .locals 0

    return-void
.end method

.method protected onRegisterAllEvents()V
    .locals 5

    .line 930
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    const-string v1, "android.telephony.action.SIM_CARD_STATE_CHANGED"

    .line 931
    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v1, "android.telephony.action.SIM_APPLICATION_STATE_CHANGED"

    .line 932
    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 933
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 v4, 0x0

    invoke-virtual {v1, v2, v0, v4, v3}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;

    .line 935
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$6;

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-direct {v1, p0, v2}, Lcom/android/internal/telephony/data/DataNetworkController$6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/util/concurrent/Executor;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->registerCallback(Lcom/android/internal/telephony/data/AccessNetworksManager$AccessNetworksManagerCallback;)V

    .line 954
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mNetworkPolicyManager:Landroid/net/NetworkPolicyManager;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$7;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$7;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-virtual {v0, v1}, Landroid/net/NetworkPolicyManager;->registerSubscriptionCallback(Landroid/net/NetworkPolicyManager$SubscriptionCallback;)V

    .line 970
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    const/16 v1, 0x11

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForServiceStateChanged(Landroid/os/Handler;I)V

    .line 972
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    const/4 v2, 0x1

    invoke-virtual {v0, p0, v2}, Lcom/android/internal/telephony/data/DataConfigManager;->registerForConfigUpdate(Landroid/os/Handler;I)V

    .line 973
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    const/4 v3, 0x6

    invoke-virtual {v0, p0, v3, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForPsRestrictedEnabled(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 975
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    const/4 v3, 0x7

    invoke-virtual {v0, p0, v3, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForPsRestrictedDisabled(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 977
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    const/16 v3, 0x19

    invoke-virtual {v0, p0, v3, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForAreaCodeChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 978
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    const/16 v3, 0x14

    invoke-virtual {v0, p0, v3, v4}, Lcom/android/internal/telephony/Phone;->registerForEmergencyCallToggle(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 979
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceManagers:Landroid/util/SparseArray;

    invoke-virtual {v0, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataServiceManager;

    const/16 v2, 0x8

    .line 980
    invoke-virtual {v0, p0, v2}, Lcom/android/internal/telephony/data/DataServiceManager;->registerForServiceBindingChanged(Landroid/os/Handler;I)V

    .line 982
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v0

    if-nez v0, :cond_0

    .line 983
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForServiceStateChanged(Landroid/os/Handler;I)V

    .line 985
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataServiceManagers:Landroid/util/SparseArray;

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataServiceManager;

    .line 986
    invoke-virtual {v0, p0, v2}, Lcom/android/internal/telephony/data/DataServiceManager;->registerForServiceBindingChanged(Landroid/os/Handler;I)V

    .line 989
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Landroid/telephony/TelephonyRegistryManager;

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyRegistryManager;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$8;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetworkController$8;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    .line 990
    invoke-virtual {v0, v1, v2}, Landroid/telephony/TelephonyRegistryManager;->addOnSubscriptionsChangedListener(Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;Ljava/util/concurrent/Executor;)V

    .line 1002
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    const/16 v1, 0x12

    invoke-virtual {v0, p0, v1, v4}, Lcom/android/internal/telephony/CallTracker;->registerForVoiceCallEnded(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 1004
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 1005
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    invoke-virtual {v0, p0, v1, v4}, Lcom/android/internal/telephony/CallTracker;->registerForVoiceCallEnded(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 1008
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0x18

    invoke-interface {v0, p0, v1, v4}, Lcom/android/internal/telephony/CommandsInterface;->registerForSlicingConfigChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 1010
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getLinkBandwidthEstimator()Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$9;

    new-instance v2, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;)V

    invoke-direct {v1, p0, v2}, Lcom/android/internal/telephony/data/DataNetworkController$9;-><init>(Lcom/android/internal/telephony/data/DataNetworkController;Ljava/util/concurrent/Executor;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->registerCallback(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V

    return-void
.end method

.method protected onRemoveNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V
    .locals 2

    .line 2056
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda33;

    invoke-direct {v1, p1}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda33;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    .line 2057
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 2058
    invoke-interface {p1}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object p1

    const/4 v0, 0x0

    .line 2059
    invoke-virtual {p1, v0}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    if-eqz p1, :cond_3

    .line 2060
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mAllNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0, p1}, Ljava/util/LinkedList;->remove(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x4

    .line 2065
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 2066
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mImsThrottleCounter:Lcom/android/internal/telephony/SlidingWindowEventCounter;

    invoke-virtual {v0}, Lcom/android/internal/telephony/SlidingWindowEventCounter;->addOccurrence()Z

    .line 2067
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getCapabilities()[I

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLastReleasedImsRequestCapabilities:[I

    const/4 v0, 0x1

    .line 2068
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mLastImsOperationIsRelease:Z

    .line 2071
    :cond_1
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getAttachedNetwork()Lcom/android/internal/telephony/data/DataNetwork;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 2072
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getAttachedNetwork()Lcom/android/internal/telephony/data/DataNetwork;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->detachNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    .line 2074
    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onRemoveNetworkRequest: Removed "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void

    .line 2061
    :cond_3
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onRemoveNetworkRequest: Network request does not exist. "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->loge(Ljava/lang/String;)V

    return-void
.end method

.method protected onSatisfyNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V
    .locals 2

    .line 1207
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getState()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 1208
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Already satisfied. "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->logv(Ljava/lang/String;)V

    return-void

    .line 1214
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->findCompatibleDataNetworkAndAttach(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 1221
    :cond_1
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->NEW_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->evaluateNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;)Lcom/android/internal/telephony/data/DataEvaluation;

    move-result-object p1

    .line 1223
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataEvaluation;->containsDisallowedReasons()Z

    move-result v0

    if-nez v0, :cond_2

    .line 1224
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataEvaluation;->getCandidateDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v0

    if-eqz v0, :cond_3

    const/4 v1, 0x0

    .line 1227
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataEvaluation;->getDataAllowedReason()Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    move-result-object p1

    .line 1226
    invoke-direct {p0, v0, v1, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->setupDataNetwork(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;)V

    goto :goto_0

    .line 1229
    :cond_2
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ONLY_ALLOWED_SINGLE_NETWORK:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataEvaluation;->contains(Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;)Z

    move-result p1

    if-eqz p1, :cond_3

    const/16 p1, 0x10

    .line 1233
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->SINGLE_DATA_NETWORK_ARBITRATION:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {p0, p1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    :cond_3
    :goto_0
    return-void
.end method

.method protected onSimAbsent()V
    .locals 2

    const-string v0, "onSimAbsent"

    .line 2910
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 2911
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->SIM_REMOVAL:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const/16 v1, 0x10

    invoke-virtual {p0, v1, v0}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public onTearDownAllDataNetworks(I)V
    .locals 5
    .param p1    # I
        .annotation build Lcom/android/internal/telephony/data/DataNetwork$TearDownReason;
        .end annotation
    .end param

    .line 3416
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onTearDownAllDataNetworks: reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataNetwork;->tearDownReasonToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3417
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string/jumbo p1, "tearDownAllDataNetworks: No pending networks. All disconnected now."

    .line 3418
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 3422
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingTearDownAllNetworks:Z

    .line 3423
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_1
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/DataNetwork;

    .line 3424
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->isMtkImsDataSupport()Z

    move-result v3

    if-eqz v3, :cond_2

    const/4 v3, 0x3

    if-ne p1, v3, :cond_2

    .line 3425
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v3

    const/4 v4, 0x4

    invoke-virtual {v3, v4}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v3

    if-eqz v3, :cond_2

    .line 3427
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "onTearDownAllDataNetworks: ignore ims reason="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3428
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataNetwork;->tearDownReasonToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 3427
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    .line 3429
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkList:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    if-ne v2, v0, :cond_1

    const-string v2, "all data disconnect except ims, power off radio immediately"

    .line 3430
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->log(Ljava/lang/String;)V

    const/4 v2, 0x0

    .line 3431
    iput-boolean v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mPendingTearDownAllNetworks:Z

    .line 3432
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetworkController;->mDataNetworkControllerCallbacks:Ljava/util/Set;

    new-instance v3, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda53;

    invoke-direct {v3}, Lcom/android/internal/telephony/data/DataNetworkController$$ExternalSyntheticLambda53;-><init>()V

    invoke-interface {v2, v3}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    goto :goto_0

    .line 3437
    :cond_2
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnecting()Z

    move-result v3

    if-nez v3, :cond_1

    .line 3438
    invoke-direct {p0, v2, p1}, Lcom/android/internal/telephony/data/DataNetworkController;->tearDownGracefully(Lcom/android/internal/telephony/data/DataNetwork;I)V

    goto :goto_0

    :cond_3
    return-void
.end method

.method public registerDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    const/16 v0, 0xd

    .line 3388
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public removeNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V
    .locals 1

    const/4 v0, 0x3

    .line 2049
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method protected resetMdDataRetryCount(Landroid/telephony/data/ApnSetting;)V
    .locals 0

    return-void
.end method

.method protected shouldIgnoreHandover(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method public tearDownAllDataNetworks(I)V
    .locals 2
    .param p1    # I
        .annotation build Lcom/android/internal/telephony/data/DataNetwork$TearDownReason;
        .end annotation
    .end param

    const/16 v0, 0xc

    const/4 v1, 0x0

    .line 3407
    invoke-virtual {p0, v0, p1, v1}, Landroid/os/Handler;->obtainMessage(III)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public unregisterDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V
    .locals 1

    const/16 v0, 0xe

    .line 3398
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method
