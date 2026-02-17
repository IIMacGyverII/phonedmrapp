.class public Lcom/android/internal/telephony/data/DataNetwork;
.super Lcom/android/internal/telephony/StateMachine;
.source "DataNetwork.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;,
        Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;,
        Lcom/android/internal/telephony/data/DataNetwork$HandoverState;,
        Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;,
        Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;,
        Lcom/android/internal/telephony/data/DataNetwork$DefaultState;,
        Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;,
        Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;,
        Lcom/android/internal/telephony/data/DataNetwork$BandwidthEstimationSource;,
        Lcom/android/internal/telephony/data/DataNetwork$TearDownReason;
    }
.end annotation


# static fields
.field public static final BANDWIDTH_SOURCE_BANDWIDTH_ESTIMATOR:I = 0x3

.field public static final BANDWIDTH_SOURCE_CARRIER_CONFIG:I = 0x2

.field public static final BANDWIDTH_SOURCE_MODEM:I = 0x1

.field public static final BANDWIDTH_SOURCE_UNKNOWN:I = 0x0

.field private static final DEFAULT_INTERNET_NETWORK_SCORE:I = 0x32

.field private static final EVENT_ALLOCATE_PDU_SESSION_ID_RESPONSE:I = 0x5

.field private static final EVENT_ATTACH_NETWORK_REQUEST:I = 0x2

.field private static final EVENT_BANDWIDTH_ESTIMATE_FROM_MODEM_CHANGED:I = 0xb

.field private static final EVENT_CARRIER_PRIVILEGED_UIDS_CHANGED:I = 0x12

.field private static final EVENT_CSS_INDICATOR_CHANGED:I = 0x18

.field private static final EVENT_DATA_CONFIG_UPDATED:I = 0x1

.field private static final EVENT_DATA_STATE_CHANGED:I = 0x8

.field protected static final EVENT_DEACTIVATE_DATA_NETWORK_RESPONSE:I = 0x13

.field protected static final EVENT_DETACH_ALL_NETWORK_REQUESTS:I = 0xa

.field protected static final EVENT_DETACH_NETWORK_REQUEST:I = 0x3

.field private static final EVENT_DISPLAY_INFO_CHANGED:I = 0xd

.field private static final EVENT_HANDOVER_RESPONSE:I = 0xf

.field private static final EVENT_PCO_DATA_RECEIVED:I = 0x11

.field private static final EVENT_SERVICE_STATE_CHANGED:I = 0x9

.field protected static final EVENT_SETUP_DATA_NETWORK_RESPONSE:I = 0x6

.field private static final EVENT_START_HANDOVER:I = 0xe

.field private static final EVENT_STUCK_IN_TRANSIENT_STATE:I = 0x14

.field private static final EVENT_SUBSCRIPTION_PLAN_OVERRIDE:I = 0x10

.field protected static final EVENT_TEAR_DOWN_NETWORK:I = 0x7

.field private static final EVENT_VOICE_CALL_ENDED:I = 0x17

.field private static final EVENT_VOICE_CALL_STARTED:I = 0x16

.field private static final EVENT_WAITING_FOR_TEARING_DOWN_CONDITION_MET:I = 0x15

.field private static final INVALID_CID:I = -0x1

.field private static final MUTABLE_CAPABILITIES:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static final OTHER_NETWORK_SCORE:I = 0x2d

.field public static final TEAR_DOWN_REASON_AIRPLANE_MODE_ON:I = 0x3

.field public static final TEAR_DOWN_REASON_CDMA_EMERGENCY_CALLBACK_MODE:I = 0x16

.field public static final TEAR_DOWN_REASON_CONCURRENT_VOICE_DATA_NOT_ALLOWED:I = 0x8

.field public static final TEAR_DOWN_REASON_CONNECTIVITY_SERVICE_UNWANTED:I = 0x1

.field public static final TEAR_DOWN_REASON_DATA_CONFIG_NOT_READY:I = 0x13

.field public static final TEAR_DOWN_REASON_DATA_DISABLED:I = 0x4

.field public static final TEAR_DOWN_REASON_DATA_PROFILE_INVALID:I = 0x19

.field public static final TEAR_DOWN_REASON_DATA_PROFILE_NOT_PREFERRED:I = 0x1a

.field public static final TEAR_DOWN_REASON_DATA_SERVICE_NOT_READY:I = 0xa

.field public static final TEAR_DOWN_REASON_DATA_STALL:I = 0xc

.field public static final TEAR_DOWN_REASON_DATA_THROTTLED:I = 0x18

.field public static final TEAR_DOWN_REASON_DEFAULT_DATA_UNSELECTED:I = 0x11

.field public static final TEAR_DOWN_REASON_HANDOVER_FAILED:I = 0xd

.field public static final TEAR_DOWN_REASON_HANDOVER_NOT_ALLOWED:I = 0xe

.field public static final TEAR_DOWN_REASON_ILLEGAL_STATE:I = 0x1c

.field public static final TEAR_DOWN_REASON_NOT_ALLOWED_BY_POLICY:I = 0x1b

.field public static final TEAR_DOWN_REASON_NOT_IN_SERVICE:I = 0x12

.field public static final TEAR_DOWN_REASON_NO_LIVE_REQUEST:I = 0x5

.field public static final TEAR_DOWN_REASON_NO_SUITABLE_DATA_PROFILE:I = 0x15

.field public static final TEAR_DOWN_REASON_ONLY_ALLOWED_SINGLE_NETWORK:I = 0x1d

.field public static final TEAR_DOWN_REASON_PENDING_TEAR_DOWN_ALL:I = 0x14

.field public static final TEAR_DOWN_REASON_POWER_OFF_BY_CARRIER:I = 0xb

.field public static final TEAR_DOWN_REASON_PREFERRED_DATA_SWITCHED:I = 0x1e

.field public static final TEAR_DOWN_REASON_RAT_NOT_ALLOWED:I = 0x6

.field public static final TEAR_DOWN_REASON_RETRY_SCHEDULED:I = 0x17

.field public static final TEAR_DOWN_REASON_ROAMING_DISABLED:I = 0x7

.field public static final TEAR_DOWN_REASON_SIM_REMOVAL:I = 0x2

.field public static final TEAR_DOWN_REASON_VCN_REQUESTED:I = 0xf

.field public static final TEAR_DOWN_REASON_VOPS_NOT_SUPPORTED:I = 0x10

.field private static final VDBG:Z = false


# instance fields
.field private final mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

.field private mAdministratorUids:[I

.field protected final mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

.field private mCarrierServicePackageUid:I

.field protected final mCid:Landroid/util/SparseIntArray;

.field private mCongested:Z

.field protected mConnectedState:Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;

.field protected mConnectingState:Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;

.field private mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

.field private mDataCallResponse:Landroid/telephony/data/DataCallResponse;

.field protected final mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

.field protected final mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

.field protected final mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

.field protected final mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

.field private final mDataNetworkControllerCallback:Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;

.field protected mDataProfile:Landroid/telephony/data/DataProfile;

.field protected final mDataServiceManagers:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/data/DataServiceManager;",
            ">;"
        }
    .end annotation
.end field

.field protected mDefaultState:Lcom/android/internal/telephony/data/DataNetwork$DefaultState;

.field private mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

.field protected mDisconnectingState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;

.field private mEverConnected:Z

.field protected mFailCause:I

.field private mHandoverDataProfile:Landroid/telephony/data/DataProfile;

.field private mHandoverState:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

.field private mInitialNetworkAgentId:I

.field protected mInvokedDataDeactivation:Z

.field private mKeepaliveTracker:Lcom/android/internal/telephony/data/KeepaliveTracker;

.field private mLinkBandwidthEstimatorCallback:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;

.field private mLinkProperties:Landroid/net/LinkProperties;

.field private mLinkStatus:I

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field protected mLogTag:Ljava/lang/String;

.field protected mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

.field private mNetworkBandwidth:Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

.field protected mNetworkCapabilities:Landroid/net/NetworkCapabilities;

.field private mNetworkScore:I

.field private mNetworkSliceInfo:Landroid/telephony/data/NetworkSliceInfo;

.field private final mPcoData:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Landroid/telephony/PcoData;",
            ">;"
        }
    .end annotation
.end field

.field private mPduSessionId:I

.field protected final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mQosBearerSessions:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/data/QosBearerSession;",
            ">;"
        }
    .end annotation
.end field

.field private mQosCallbackTracker:Lcom/android/internal/telephony/data/QosCallbackTracker;

.field private mRetryDelayMillis:J

.field private final mRil:Lcom/android/internal/telephony/CommandsInterface;

.field private final mSubId:I

.field protected mSuspended:Z

.field private mTcpBufferSizes:Ljava/lang/String;

.field private mTelephonyDisplayInfo:Landroid/telephony/TelephonyDisplayInfo;

.field private mTempNotMetered:Z

.field private mTempNotMeteredSupported:Z

.field private final mTrafficDescriptors:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/data/TrafficDescriptor;",
            ">;"
        }
    .end annotation
.end field

.field protected mTransport:I

.field protected final mVcnManager:Landroid/net/vcn/VcnManager;

.field private mVcnPolicyChangeListener:Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;


# direct methods
.method public static synthetic $r8$lambda$6gITRHuuike2RfrFLSFZ2JI8SnA(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$updateSuspendState$5()V

    return-void
.end method

.method public static synthetic $r8$lambda$ALTV-1RRaiRLCQvSgIRS3OG1MB4(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$onPcoDataReceived$12()V

    return-void
.end method

.method public static synthetic $r8$lambda$IKQK1VVDj1wJCO5ObLjEdlke6-w(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$onAttachNetworkRequests$0(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Ntb9qt2_0AFc_CbLQ-1dpQsbrjM(Ljava/lang/Integer;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$updateNetworkCapabilities$2(Ljava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$PlpbfLThzmDqkjaYKl9fRogxQpk(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$updateNetworkCapabilities$4()V

    return-void
.end method

.method public static synthetic $r8$lambda$Ubr8k8tZ5l0hV5IbEsIVYy85Pfc(Lcom/android/internal/telephony/data/DataNetwork;Landroid/telephony/data/DataCallResponse;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$onDataStateChanged$8(Landroid/telephony/data/DataCallResponse;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$YOJhmSiJSwAvO5yhwUZXquA8MbQ(Ljava/lang/Integer;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$getApnTypeNetworkCapability$9(Ljava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$_GFLyevUz81O2T01vmCQB2kblxY(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$onHandoverResponse$10()V

    return-void
.end method

.method public static synthetic $r8$lambda$dwRkYI7LpD1PZk5GlgbtqK5p5OM(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$tearDownWhenConditionMet$7(I)V

    return-void
.end method

.method public static synthetic $r8$lambda$fvOYrv1FxHe_pBGTTfwFMXMJA50(Landroid/net/LinkAddress;)Ljava/lang/Integer;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$isLinkPropertiesCompatible$1(Landroid/net/LinkAddress;)Ljava/lang/Integer;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$krB4Tj8D_XCsoRQ1XNgyxsHLky0(Lcom/android/internal/telephony/data/DataNetwork;JI)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$onHandoverResponse$11(JI)V

    return-void
.end method

.method public static synthetic $r8$lambda$mYs5wzuvUMobngr81EIaSQ3w_W8(Lcom/android/internal/telephony/data/DataNetwork;Ljava/lang/Integer;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$updateNetworkCapabilities$3(Ljava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$pLaUcrPcoqXAwCFJHqr1-ACgs58(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->lambda$updateDataNetwork$6()V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmAccessNetworksManager(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/AccessNetworksManager;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkControllerCallback:Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDisconnectedState(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmEverConnected(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mEverConnected:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmInitialNetworkAgentId(Lcom/android/internal/telephony/data/DataNetwork;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mInitialNetworkAgentId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmLinkProperties(Lcom/android/internal/telephony/data/DataNetwork;)Landroid/net/LinkProperties;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPduSessionId(Lcom/android/internal/telephony/data/DataNetwork;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmQosBearerSessions(Lcom/android/internal/telephony/data/DataNetwork;)Ljava/util/List;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mQosBearerSessions:Ljava/util/List;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmQosCallbackTracker(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/QosCallbackTracker;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mQosCallbackTracker:Lcom/android/internal/telephony/data/QosCallbackTracker;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRetryDelayMillis(Lcom/android/internal/telephony/data/DataNetwork;)J
    .locals 2

    iget-wide v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRetryDelayMillis:J

    return-wide v0
.end method

.method static bridge synthetic -$$Nest$fgetmRil(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/CommandsInterface;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRil:Lcom/android/internal/telephony/CommandsInterface;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmVcnPolicyChangeListener(Lcom/android/internal/telephony/data/DataNetwork;)Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnPolicyChangeListener:Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmAdministratorUids(Lcom/android/internal/telephony/data/DataNetwork;[I)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAdministratorUids:[I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmCarrierServicePackageUid(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCarrierServicePackageUid:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmEverConnected(Lcom/android/internal/telephony/data/DataNetwork;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mEverConnected:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmInitialNetworkAgentId(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mInitialNetworkAgentId:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmKeepaliveTracker(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/KeepaliveTracker;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mKeepaliveTracker:Lcom/android/internal/telephony/data/KeepaliveTracker;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmPduSessionId(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmQosCallbackTracker(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/QosCallbackTracker;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mQosCallbackTracker:Lcom/android/internal/telephony/data/QosCallbackTracker;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmRetryDelayMillis(Lcom/android/internal/telephony/data/DataNetwork;J)V
    .locals 0

    iput-wide p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRetryDelayMillis:J

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmVcnPolicyChangeListener(Lcom/android/internal/telephony/data/DataNetwork;Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnPolicyChangeListener:Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;

    return-void
.end method

.method static bridge synthetic -$$Nest$mallocatePduSessionId(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->allocatePduSessionId()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mcreateNetworkAgent(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/TelephonyNetworkAgent;
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->createNetworkAgent()Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mgetDataNetworkType(Lcom/android/internal/telephony/data/DataNetwork;)I
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getDataNetworkType()I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$monBandwidthUpdated(Lcom/android/internal/telephony/data/DataNetwork;II)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->onBandwidthUpdated(II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monBandwidthUpdatedFromModem(Lcom/android/internal/telephony/data/DataNetwork;Ljava/util/List;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->onBandwidthUpdatedFromModem(Ljava/util/List;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataConfigUpdated(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->onDataConfigUpdated()V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDataStateChanged(Lcom/android/internal/telephony/data/DataNetwork;ILjava/util/List;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->onDataStateChanged(ILjava/util/List;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monDisplayInfoChanged(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->onDisplayInfoChanged()V

    return-void
.end method

.method static bridge synthetic -$$Nest$monHandoverResponse(Lcom/android/internal/telephony/data/DataNetwork;ILandroid/telephony/data/DataCallResponse;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/DataNetwork;->onHandoverResponse(ILandroid/telephony/data/DataCallResponse;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monPcoDataReceived(Lcom/android/internal/telephony/data/DataNetwork;Landroid/telephony/PcoData;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->onPcoDataReceived(Landroid/telephony/PcoData;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monStartHandover(Lcom/android/internal/telephony/data/DataNetwork;ILcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->onStartHandover(ILcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mregisterForWwanEvents(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->registerForWwanEvents()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mreportAnomaly(Lcom/android/internal/telephony/data/DataNetwork;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$munregisterForWwanEvents(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->unregisterForWwanEvents()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateMeteredAndCongested(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateMeteredAndCongested()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateNetworkScore(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkScore()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 3

    const/16 v0, 0xd

    new-array v0, v0, [Ljava/lang/Integer;

    const/16 v1, 0xe

    .line 399
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const/16 v1, 0x10

    .line 400
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x1

    aput-object v1, v0, v2

    const/16 v1, 0x11

    .line 401
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x2

    aput-object v1, v0, v2

    const/16 v1, 0x12

    .line 402
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x3

    aput-object v1, v0, v2

    const/16 v1, 0x13

    .line 403
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x4

    aput-object v1, v0, v2

    const/16 v1, 0x14

    .line 404
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x5

    aput-object v1, v0, v2

    const/16 v1, 0x15

    .line 405
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x6

    aput-object v1, v0, v2

    const/16 v1, 0x18

    .line 406
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x7

    aput-object v1, v0, v2

    const/16 v1, 0x19

    .line 407
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/16 v2, 0x8

    aput-object v1, v0, v2

    const/16 v1, 0x1c

    .line 408
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/16 v2, 0x9

    aput-object v1, v0, v2

    const/16 v1, 0x20

    .line 409
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/16 v2, 0xa

    aput-object v1, v0, v2

    const/16 v1, 0xb

    .line 412
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v0, v1

    const/16 v1, 0x21

    .line 416
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/16 v2, 0xc

    aput-object v1, v0, v2

    .line 398
    invoke-static {v0}, Ljava/util/List;->of([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/data/DataNetwork;->MUTABLE_CAPABILITIES:Ljava/util/List;

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;Landroid/util/SparseArray;Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;ILcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;)V
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/Phone;",
            "Landroid/os/Looper;",
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/data/DataServiceManager;",
            ">;",
            "Landroid/telephony/data/DataProfile;",
            "Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;",
            "I",
            "Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;",
            "Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;",
            ")V"
        }
    .end annotation

    const-string v0, "DataNetwork"

    .line 839
    invoke-direct {p0, v0, p2}, Lcom/android/internal/telephony/StateMachine;-><init>(Ljava/lang/String;Landroid/os/Looper;)V

    .line 420
    new-instance p2, Lcom/android/internal/telephony/data/DataNetwork$DefaultState;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetwork$DefaultState;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDefaultState:Lcom/android/internal/telephony/data/DataNetwork$DefaultState;

    .line 427
    new-instance p2, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectingState:Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;

    .line 434
    new-instance p2, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectedState:Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;

    .line 441
    new-instance p2, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetwork$HandoverState;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mHandoverState:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

    .line 451
    new-instance p2, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectingState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;

    .line 458
    new-instance p2, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    const/4 p2, 0x0

    .line 477
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mInvokedDataDeactivation:Z

    .line 482
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mEverConnected:Z

    .line 488
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x80

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 505
    new-instance v0, Landroid/util/SparseIntArray;

    const/4 v1, 0x2

    invoke-direct {v0, v1}, Landroid/util/SparseIntArray;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    .line 515
    iput p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    .line 564
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTrafficDescriptors:Ljava/util/List;

    const/4 v3, -0x1

    .line 573
    iput v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkStatus:I

    .line 576
    new-instance v4, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    const/16 v5, 0xe

    invoke-direct {v4, v5, v5}, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;-><init>(II)V

    iput-object v4, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkBandwidth:Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    .line 585
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMeteredSupported:Z

    .line 588
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMetered:Z

    .line 591
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCongested:Z

    .line 594
    new-instance v4, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {v4}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>()V

    iput-object v4, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    const/4 v5, 0x0

    .line 603
    iput-object v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallResponse:Landroid/telephony/data/DataCallResponse;

    .line 609
    iput p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    const-wide/16 v5, -0x1

    .line 614
    iput-wide v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRetryDelayMillis:J

    .line 623
    iput-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSuspended:Z

    .line 638
    new-instance v5, Landroid/util/ArrayMap;

    invoke-direct {v5}, Landroid/util/ArrayMap;-><init>()V

    iput-object v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPcoData:Ljava/util/Map;

    .line 641
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    iput-object v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mQosBearerSessions:Ljava/util/List;

    new-array p2, p2, [I

    .line 646
    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAdministratorUids:[I

    .line 651
    iput v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCarrierServicePackageUid:I

    .line 842
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->mtkReplaceStates()V

    .line 848
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->initializeStateMachine()V

    .line 850
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 851
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p2

    iput p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSubId:I

    .line 852
    iget-object p2, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRil:Lcom/android/internal/telephony/CommandsInterface;

    .line 853
    new-instance p2, Landroid/net/LinkProperties;

    invoke-direct {p2}, Landroid/net/LinkProperties;-><init>()V

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    .line 854
    iput-object p3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataServiceManagers:Landroid/util/SparseArray;

    .line 855
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getAccessNetworksManager()Lcom/android/internal/telephony/data/AccessNetworksManager;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 856
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    const-class p3, Landroid/net/vcn/VcnManager;

    invoke-virtual {p2, p3}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/net/vcn/VcnManager;

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnManager:Landroid/net/vcn/VcnManager;

    .line 857
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    .line 858
    new-instance p3, Lcom/android/internal/telephony/data/DataNetwork$1;

    .line 859
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v5

    invoke-static {v5}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v6, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;

    invoke-direct {v6, v5}, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;-><init>(Landroid/os/Handler;)V

    invoke-direct {p3, p0, v6}, Lcom/android/internal/telephony/data/DataNetwork$1;-><init>(Lcom/android/internal/telephony/data/DataNetwork;Ljava/util/concurrent/Executor;)V

    iput-object p3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkControllerCallback:Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;

    .line 864
    invoke-virtual {p2, p3}, Lcom/android/internal/telephony/data/DataNetworkController;->registerDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    .line 866
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataConfigManager()Lcom/android/internal/telephony/data/DataConfigManager;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 867
    new-instance p3, Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;-><init>(Lcom/android/internal/telephony/Phone;)V

    iput-object p3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    .line 868
    iput-object p8, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    .line 869
    iput-object p4, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 870
    invoke-virtual {p4}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object p3

    if-eqz p3, :cond_0

    .line 874
    invoke-virtual {p4}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object p3

    invoke-interface {v2, p3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 876
    :cond_0
    iput p6, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    .line 877
    iput-object p7, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    .line 878
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide p6

    invoke-virtual {p4, p6, p7}, Landroid/telephony/data/DataProfile;->setLastSetupTimestamp(J)V

    .line 879
    invoke-virtual {v4, p5}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->addAll(Ljava/util/Collection;)Z

    const/4 p3, 0x1

    .line 880
    invoke-virtual {v0, p3, v3}, Landroid/util/SparseIntArray;->put(II)V

    .line 881
    invoke-virtual {v0, v1, v3}, Landroid/util/SparseIntArray;->put(II)V

    .line 882
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataConfigManager;->getDefaultTcpConfigString()Ljava/lang/String;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTcpBufferSizes:Ljava/lang/String;

    .line 883
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getDisplayInfoController()Lcom/android/internal/telephony/DisplayInfoController;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/DisplayInfoController;->getTelephonyDisplayInfo()Landroid/telephony/TelephonyDisplayInfo;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTelephonyDisplayInfo:Landroid/telephony/TelephonyDisplayInfo;

    .line 885
    invoke-virtual {p5}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 886
    invoke-virtual {p2, p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->setAttachedNetwork(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 887
    invoke-virtual {p2, p3}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->setState(I)V

    goto :goto_0

    .line 894
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkCapabilities()V

    return-void
.end method

.method static synthetic access$000(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    .line 157
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    return-void
.end method

.method static synthetic access$100(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    .line 157
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    return-void
.end method

.method static synthetic access$200(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    .line 157
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->removeDeferredMessages(I)V

    return-void
.end method

.method static synthetic access$300(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    .line 157
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    return-void
.end method

.method static synthetic access$400(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    .line 157
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    return-void
.end method

.method static synthetic access$500(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    .line 157
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    return-void
.end method

.method static synthetic access$600(Lcom/android/internal/telephony/data/DataNetwork;I)V
    .locals 0

    .line 157
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->removeDeferredMessages(I)V

    return-void
.end method

.method private allocatePduSessionId()V
    .locals 2

    .line 2107
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRil:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x5

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->allocatePduSessionId(Landroid/os/Message;)V

    return-void
.end method

.method private static areImmutableCapabilitiesChanged(Landroid/net/NetworkCapabilities;Landroid/net/NetworkCapabilities;)Z
    .locals 3

    const/4 v0, 0x0

    if-eqz p0, :cond_2

    .line 1788
    invoke-virtual {p0}, Landroid/net/NetworkCapabilities;->getCapabilities()[I

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/util/ArrayUtils;->isEmpty([I)Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_0

    .line 1792
    :cond_0
    invoke-virtual {p0}, Landroid/net/NetworkCapabilities;->getCapabilities()[I

    move-result-object p0

    invoke-static {p0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object p0

    .line 1793
    invoke-interface {p0}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object p0

    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    .line 1794
    sget-object v1, Lcom/android/internal/telephony/data/DataNetwork;->MUTABLE_CAPABILITIES:Ljava/util/List;

    invoke-interface {p0, v1}, Ljava/util/List;->removeAll(Ljava/util/Collection;)Z

    .line 1795
    invoke-virtual {p1}, Landroid/net/NetworkCapabilities;->getCapabilities()[I

    move-result-object p1

    invoke-static {p1}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object p1

    .line 1796
    invoke-interface {p1}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object p1

    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {p1, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/List;

    .line 1797
    invoke-interface {p1, v1}, Ljava/util/List;->removeAll(Ljava/util/Collection;)Z

    .line 1798
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v1

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v2

    if-ne v1, v2, :cond_1

    .line 1799
    invoke-interface {p0, p1}, Ljava/util/List;->containsAll(Ljava/util/Collection;)Z

    move-result p0

    if-nez p0, :cond_2

    :cond_1
    const/4 v0, 0x1

    :cond_2
    :goto_0
    return v0
.end method

.method private createNetworkAgent()Lcom/android/internal/telephony/data/TelephonyNetworkAgent;
    .locals 10

    .line 939
    new-instance v0, Landroid/net/NetworkAgentConfig$Builder;

    invoke-direct {v0}, Landroid/net/NetworkAgentConfig$Builder;-><init>()V

    const/4 v1, 0x0

    .line 940
    invoke-virtual {v0, v1}, Landroid/net/NetworkAgentConfig$Builder;->setLegacyType(I)Landroid/net/NetworkAgentConfig$Builder;

    const-string v2, "MOBILE"

    .line 941
    invoke-virtual {v0, v2}, Landroid/net/NetworkAgentConfig$Builder;->setLegacyTypeName(Ljava/lang/String;)Landroid/net/NetworkAgentConfig$Builder;

    .line 942
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getDataNetworkType()I

    move-result v2

    .line 943
    invoke-virtual {v0, v2}, Landroid/net/NetworkAgentConfig$Builder;->setLegacySubType(I)Landroid/net/NetworkAgentConfig$Builder;

    .line 944
    invoke-static {v2}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/net/NetworkAgentConfig$Builder;->setLegacySubTypeName(Ljava/lang/String;)Landroid/net/NetworkAgentConfig$Builder;

    .line 945
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    if-eqz v2, :cond_0

    .line 946
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/net/NetworkAgentConfig$Builder;->setLegacyExtraInfo(Ljava/lang/String;)Landroid/net/NetworkAgentConfig$Builder;

    .line 949
    :cond_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getCarrierSignalAgent()Lcom/android/internal/telephony/CarrierSignalAgent;

    move-result-object v2

    const-string v3, "android.telephony.action.CARRIER_SIGNAL_REDIRECTED"

    .line 950
    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/CarrierSignalAgent;->hasRegisteredReceivers(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 953
    invoke-virtual {v0, v1}, Landroid/net/NetworkAgentConfig$Builder;->setProvisioningNotificationEnabled(Z)Landroid/net/NetworkAgentConfig$Builder;

    .line 957
    :cond_1
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v2}, Lcom/android/internal/telephony/PhoneInternalInterface;->getSubscriberId()Ljava/lang/String;

    move-result-object v2

    .line 958
    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_2

    .line 959
    invoke-virtual {v0, v2}, Landroid/net/NetworkAgentConfig$Builder;->setSubscriberId(Ljava/lang/String;)Landroid/net/NetworkAgentConfig$Builder;

    .line 963
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->shouldSkip464Xlat()Z

    move-result v2

    if-eqz v2, :cond_3

    .line 964
    invoke-virtual {v0, v1}, Landroid/net/NetworkAgentConfig$Builder;->setNat64DetectionEnabled(Z)Landroid/net/NetworkAgentConfig$Builder;

    .line 967
    :cond_3
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 968
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    .line 967
    invoke-static {v1}, Lcom/android/internal/telephony/PhoneFactory;->getNetworkFactory(I)Lcom/android/internal/telephony/data/TelephonyNetworkFactory;

    move-result-object v1

    if-nez v1, :cond_4

    const/4 v1, 0x0

    goto :goto_0

    .line 969
    :cond_4
    invoke-virtual {v1}, Lcom/android/internal/telephony/NetworkFactory;->getProvider()Landroid/net/NetworkProvider;

    move-result-object v1

    :goto_0
    move-object v8, v1

    .line 971
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkScore()I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkScore:I

    .line 972
    new-instance v1, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v2

    invoke-virtual {v2}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v4

    new-instance v2, Landroid/net/NetworkScore$Builder;

    invoke-direct {v2}, Landroid/net/NetworkScore$Builder;-><init>()V

    iget v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkScore:I

    .line 973
    invoke-virtual {v2, v5}, Landroid/net/NetworkScore$Builder;->setLegacyInt(I)Landroid/net/NetworkScore$Builder;

    move-result-object v2

    invoke-virtual {v2}, Landroid/net/NetworkScore$Builder;->build()Landroid/net/NetworkScore;

    move-result-object v6

    .line 974
    invoke-virtual {v0}, Landroid/net/NetworkAgentConfig$Builder;->build()Landroid/net/NetworkAgentConfig;

    move-result-object v7

    new-instance v9, Lcom/android/internal/telephony/data/DataNetwork$2;

    .line 975
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v0

    invoke-static {v0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v2, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;

    invoke-direct {v2, v0}, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;-><init>(Landroid/os/Handler;)V

    invoke-direct {v9, p0, v2}, Lcom/android/internal/telephony/data/DataNetwork$2;-><init>(Lcom/android/internal/telephony/data/DataNetwork;Ljava/util/concurrent/Executor;)V

    move-object v2, v1

    move-object v5, p0

    invoke-direct/range {v2 .. v9}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;-><init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataNetwork;Landroid/net/NetworkScore;Landroid/net/NetworkAgentConfig;Landroid/net/NetworkProvider;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V

    return-object v1
.end method

.method protected static eventToString(I)Ljava/lang/String;
    .locals 2

    packed-switch p0, :pswitch_data_0

    .line 3377
    :pswitch_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :pswitch_1
    const-string p0, "EVENT_CSS_INDICATOR_CHANGED"

    return-object p0

    :pswitch_2
    const-string p0, "EVENT_VOICE_CALL_ENDED"

    return-object p0

    :pswitch_3
    const-string p0, "EVENT_VOICE_CALL_STARTED"

    return-object p0

    :pswitch_4
    const-string p0, "EVENT_WAITING_FOR_TEARING_DOWN_CONDITION_MET"

    return-object p0

    :pswitch_5
    const-string p0, "EVENT_STUCK_IN_TRANSIENT_STATE"

    return-object p0

    :pswitch_6
    const-string p0, "EVENT_DEACTIVATE_DATA_NETWORK_RESPONSE"

    return-object p0

    :pswitch_7
    const-string p0, "EVENT_CARRIER_PRIVILEGED_UIDS_CHANGED"

    return-object p0

    :pswitch_8
    const-string p0, "EVENT_PCO_DATA_RECEIVED"

    return-object p0

    :pswitch_9
    const-string p0, "EVENT_SUBSCRIPTION_PLAN_OVERRIDE"

    return-object p0

    :pswitch_a
    const-string p0, "EVENT_HANDOVER_RESPONSE"

    return-object p0

    :pswitch_b
    const-string p0, "EVENT_START_HANDOVER"

    return-object p0

    :pswitch_c
    const-string p0, "EVENT_DISPLAY_INFO_CHANGED"

    return-object p0

    :pswitch_d
    const-string p0, "EVENT_BANDWIDTH_ESTIMATE_FROM_MODEM_CHANGED"

    return-object p0

    :pswitch_e
    const-string p0, "EVENT_DETACH_ALL_NETWORK_REQUESTS"

    return-object p0

    :pswitch_f
    const-string p0, "EVENT_DATA_NETWORK_TYPE_REG_STATE_CHANGED"

    return-object p0

    :pswitch_10
    const-string p0, "EVENT_DATA_STATE_CHANGED"

    return-object p0

    :pswitch_11
    const-string p0, "EVENT_TEAR_DOWN_NETWORK"

    return-object p0

    :pswitch_12
    const-string p0, "EVENT_SETUP_DATA_NETWORK_RESPONSE"

    return-object p0

    :pswitch_13
    const-string p0, "EVENT_ALLOCATE_PDU_SESSION_ID_RESPONSE"

    return-object p0

    :pswitch_14
    const-string p0, "EVENT_DETACH_NETWORK_REQUEST"

    return-object p0

    :pswitch_15
    const-string p0, "EVENT_ATTACH_NETWORK_REQUEST"

    return-object p0

    :pswitch_16
    const-string p0, "EVENT_DATA_CONFIG_UPDATED"

    return-object p0

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
        :pswitch_e
        :pswitch_d
        :pswitch_0
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

.method private getDataNetworkType()I
    .locals 1

    .line 2816
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->getDataNetworkType(I)I

    move-result p0

    return p0
.end method

.method private getNetworkRegistrationInfo()Landroid/telephony/NetworkRegistrationInfo;
    .locals 3

    .line 2885
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    const/4 v2, 0x2

    .line 2886
    invoke-virtual {v0, v2, v1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v0

    if-nez v0, :cond_0

    .line 2888
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Can\'t get network registration info for "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    .line 2889
    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2888
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return-object p0

    :cond_0
    return-object v0
.end method

.method private getNetworkScore()I
    .locals 3

    .line 2871
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p0}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    const/16 v0, 0x2d

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    const/16 v2, 0xc

    .line 2872
    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 2873
    invoke-virtual {v1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getNetworkSpecifier()Landroid/net/NetworkSpecifier;

    move-result-object v1

    if-nez v1, :cond_0

    const/16 v0, 0x32

    goto :goto_0

    :cond_1
    return v0
.end method

.method private getPreciseDataConnectionState()Landroid/telephony/PreciseDataConnectionState;
    .locals 3

    .line 3050
    new-instance v0, Landroid/telephony/PreciseDataConnectionState$Builder;

    invoke-direct {v0}, Landroid/telephony/PreciseDataConnectionState$Builder;-><init>()V

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    .line 3051
    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setTransportType(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    .line 3052
    invoke-virtual {v1, v2}, Landroid/util/SparseIntArray;->get(I)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setId(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    .line 3053
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getState()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setState(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 3054
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    .line 3055
    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setLinkProperties(Landroid/net/LinkProperties;)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    .line 3056
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getDataNetworkType()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setNetworkType(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 3057
    invoke-virtual {v0, p0}, Landroid/telephony/PreciseDataConnectionState$Builder;->setFailCause(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object p0

    .line 3058
    invoke-virtual {p0}, Landroid/telephony/PreciseDataConnectionState$Builder;->build()Landroid/telephony/PreciseDataConnectionState;

    move-result-object p0

    return-object p0
.end method

.method private getState()I
    .locals 1

    .line 3001
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    if-eqz v0, :cond_6

    .line 3002
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 3004
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnecting()Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 p0, 0x1

    return p0

    .line 3006
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 3008
    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSuspended:Z

    if-eqz p0, :cond_2

    const/4 p0, 0x3

    return p0

    :cond_2
    const/4 p0, 0x2

    return p0

    .line 3012
    :cond_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnecting()Z

    move-result v0

    if-eqz v0, :cond_4

    const/4 p0, 0x4

    return p0

    .line 3014
    :cond_4
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isHandoverInProgress()Z

    move-result p0

    if-eqz p0, :cond_5

    const/4 p0, 0x5

    return p0

    :cond_5
    const/4 p0, -0x1

    return p0

    :cond_6
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method private getVcnPolicy(Landroid/net/NetworkCapabilities;)Landroid/net/vcn/VcnNetworkPolicyResult;
    .locals 1

    .line 3246
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnManager:Landroid/net/vcn/VcnManager;

    if-nez v0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 3250
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object p0

    invoke-virtual {v0, p1, p0}, Landroid/net/vcn/VcnManager;->applyVcnNetworkPolicy(Landroid/net/NetworkCapabilities;Landroid/net/LinkProperties;)Landroid/net/vcn/VcnNetworkPolicyResult;

    move-result-object p0

    return-object p0
.end method

.method private initializeStateMachine()V
    .locals 2

    .line 901
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDefaultState:Lcom/android/internal/telephony/data/DataNetwork$DefaultState;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;)V

    .line 902
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectingState:Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDefaultState:Lcom/android/internal/telephony/data/DataNetwork$DefaultState;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 903
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectedState:Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDefaultState:Lcom/android/internal/telephony/data/DataNetwork$DefaultState;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 904
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mHandoverState:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDefaultState:Lcom/android/internal/telephony/data/DataNetwork$DefaultState;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 905
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectingState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDefaultState:Lcom/android/internal/telephony/data/DataNetwork$DefaultState;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 906
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDefaultState:Lcom/android/internal/telephony/data/DataNetwork$DefaultState;

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 907
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectingState:Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->setInitialState(Lcom/android/internal/telephony/State;)V

    .line 908
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->start()V

    return-void
.end method

.method private isLinkPropertiesCompatible(Landroid/net/LinkProperties;Landroid/net/LinkProperties;)Z
    .locals 5

    .line 1750
    invoke-static {p1, p2}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    return v1

    .line 1752
    :cond_0
    invoke-static {p1, p2}, Lcom/android/internal/telephony/util/LinkPropertiesUtils;->isIdenticalAddresses(Landroid/net/LinkProperties;Landroid/net/LinkProperties;)Z

    move-result v0

    if-nez v0, :cond_3

    .line 1754
    new-instance v0, Lcom/android/internal/telephony/util/LinkPropertiesUtils$CompareOrUpdateResult;

    .line 1756
    invoke-virtual {p1}, Landroid/net/LinkProperties;->getLinkAddresses()Ljava/util/List;

    move-result-object v2

    .line 1757
    invoke-virtual {p2}, Landroid/net/LinkProperties;->getLinkAddresses()Ljava/util/List;

    move-result-object v3

    new-instance v4, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda4;

    invoke-direct {v4}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda4;-><init>()V

    invoke-direct {v0, v2, v3, v4}, Lcom/android/internal/telephony/util/LinkPropertiesUtils$CompareOrUpdateResult;-><init>(Ljava/util/Collection;Ljava/util/Collection;Ljava/util/function/Function;)V

    .line 1760
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "isLinkPropertiesCompatible: old="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " new="

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " result="

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 1762
    iget-object p0, v0, Lcom/android/internal/telephony/util/LinkPropertiesUtils$CompareOrUpdateResult;->added:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_1
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p1

    if-eqz p1, :cond_3

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/net/LinkAddress;

    .line 1763
    iget-object p2, v0, Lcom/android/internal/telephony/util/LinkPropertiesUtils$CompareOrUpdateResult;->removed:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :cond_2
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/net/LinkAddress;

    .line 1764
    invoke-virtual {v2}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v2

    invoke-virtual {p1}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v3

    invoke-static {v2, v3}, Lcom/android/internal/telephony/util/NetUtils;->addressTypeMatches(Ljava/net/InetAddress;Ljava/net/InetAddress;)Z

    move-result v2

    if-eqz v2, :cond_2

    const/4 p0, 0x0

    return p0

    :cond_3
    return v1
.end method

.method private isNetworkTypeUnmetered(I)Z
    .locals 11

    .line 2777
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetworkController;->getSubscriptionPlans()Ljava/util/List;

    move-result-object p0

    .line 2778
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    return v1

    .line 2780
    :cond_0
    invoke-static {}, Landroid/telephony/TelephonyManager;->getAllNetworkTypes()[I

    move-result-object v0

    invoke-static {v0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v0

    .line 2781
    invoke-interface {v0}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object v0

    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Set;

    .line 2782
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    const/4 v2, 0x1

    move v3, v2

    :cond_1
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_5

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/telephony/SubscriptionPlan;

    .line 2784
    invoke-virtual {v4}, Landroid/telephony/SubscriptionPlan;->getNetworkTypes()[I

    move-result-object v5

    invoke-static {v5}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v5

    invoke-interface {v5}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object v5

    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v6

    invoke-interface {v5, v6}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/util/Set;

    .line 2785
    invoke-interface {v5, v0}, Ljava/util/Set;->containsAll(Ljava/util/Collection;)Z

    move-result v5

    const-wide v6, 0x7fffffffffffffffL

    if-eqz v5, :cond_2

    .line 2786
    invoke-virtual {v4}, Landroid/telephony/SubscriptionPlan;->getDataLimitBytes()J

    move-result-wide v4

    cmp-long v4, v4, v6

    if-eqz v4, :cond_1

    move v3, v1

    goto :goto_0

    :cond_2
    if-eqz p1, :cond_1

    .line 2793
    invoke-virtual {v4}, Landroid/telephony/SubscriptionPlan;->getNetworkTypes()[I

    move-result-object v5

    array-length v8, v5

    move v9, v1

    :goto_1
    if-ge v9, v8, :cond_1

    aget v10, v5, v9

    if-ne v10, p1, :cond_4

    .line 2795
    invoke-virtual {v4}, Landroid/telephony/SubscriptionPlan;->getDataLimitBytes()J

    move-result-wide p0

    cmp-long p0, p0, v6

    if-nez p0, :cond_3

    move v1, v2

    :cond_3
    return v1

    :cond_4
    add-int/lit8 v9, v9, 0x1

    goto :goto_1

    :cond_5
    return v3
.end method

.method private static synthetic lambda$getApnTypeNetworkCapability$9(Ljava/lang/Integer;)Z
    .locals 0

    .line 2912
    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToApnType(I)I

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$isLinkPropertiesCompatible$1(Landroid/net/LinkAddress;)Ljava/lang/Integer;
    .locals 3

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/Object;

    .line 1758
    invoke-virtual {p0}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    .line 1759
    invoke-virtual {p0}, Landroid/net/LinkAddress;->getPrefixLength()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    const/4 v2, 0x1

    aput-object v1, v0, v2

    invoke-virtual {p0}, Landroid/net/LinkAddress;->getScope()I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    const/4 v1, 0x2

    aput-object p0, v0, v1

    .line 1758
    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    return-object p0
.end method

.method private synthetic lambda$onAttachNetworkRequests$0(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 1

    .line 1636
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    .line 1637
    invoke-virtual {v0, p0, p1}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onAttachFailed(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    return-void
.end method

.method private synthetic lambda$onDataStateChanged$8(Landroid/telephony/data/DataCallResponse;)Z
    .locals 1

    .line 2582
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {v0, p0}, Landroid/util/SparseIntArray;->get(I)I

    move-result p0

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result p1

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$onHandoverResponse$10()V
    .locals 1

    .line 3188
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onHandoverSucceeded(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method private synthetic lambda$onHandoverResponse$11(JI)V
    .locals 6

    .line 3197
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    move-object v1, p0

    move-wide v3, p1

    move v5, p3

    invoke-virtual/range {v0 .. v5}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onHandoverFailed(Lcom/android/internal/telephony/data/DataNetwork;IJI)V

    return-void
.end method

.method private synthetic lambda$onPcoDataReceived$12()V
    .locals 1

    .line 3217
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onPcoDataChanged(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method private synthetic lambda$tearDownWhenConditionMet$7(I)V
    .locals 0

    .line 2561
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->tearDown(I)V

    return-void
.end method

.method private synthetic lambda$updateDataNetwork$6()V
    .locals 2

    .line 2213
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkStatus:I

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onLinkStatusChanged(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-void
.end method

.method private static synthetic lambda$updateNetworkCapabilities$2(Ljava/lang/Integer;)Z
    .locals 0

    .line 1819
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

.method private synthetic lambda$updateNetworkCapabilities$3(Ljava/lang/Integer;)Z
    .locals 0

    .line 1919
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransportByNetworkCapability(I)I

    move-result p0

    const/4 p1, 0x1

    if-ne p0, p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    return p1
.end method

.method private synthetic lambda$updateNetworkCapabilities$4()V
    .locals 1

    .line 2020
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    .line 2021
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onNetworkCapabilitiesChanged(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method private synthetic lambda$updateSuspendState$5()V
    .locals 2

    .line 2098
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSuspended:Z

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onSuspendedStateChanged(Lcom/android/internal/telephony/data/DataNetwork;Z)V

    return-void
.end method

.method private onBandwidthUpdated(II)V
    .locals 2

    .line 2667
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onBandwidthUpdated: downlinkBandwidthKbps="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", uplinkBandwidthKbps="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2669
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTelephonyDisplayInfo:Landroid/telephony/TelephonyDisplayInfo;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getBandwidthForNetworkType(Landroid/telephony/TelephonyDisplayInfo;)Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    move-result-object v0

    const/4 v1, -0x1

    if-ne p2, v1, :cond_0

    if-eqz v0, :cond_0

    .line 2674
    iget p2, v0, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;->downlinkBandwidthKbps:I

    :cond_0
    if-ne p1, v1, :cond_1

    if-eqz v0, :cond_1

    .line 2679
    iget p1, v0, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;->uplinkBandwidthKbps:I

    .line 2683
    :cond_1
    invoke-static {p1, p2}, Ljava/lang/Math;->min(II)I

    move-result p1

    .line 2684
    new-instance v0, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    invoke-direct {v0, p2, p1}, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;-><init>(II)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkBandwidth:Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    .line 2686
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkCapabilities()V

    return-void
.end method

.method private onBandwidthUpdatedFromModem(Ljava/util/List;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/LinkCapacityEstimate;",
            ">;)V"
        }
    .end annotation

    .line 2640
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 2641
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 2644
    :cond_0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    const/4 v0, 0x0

    move v1, v0

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/LinkCapacityEstimate;

    .line 2645
    invoke-virtual {v2}, Landroid/telephony/LinkCapacityEstimate;->getType()I

    move-result v3

    const/4 v4, 0x2

    if-ne v3, v4, :cond_1

    .line 2646
    invoke-virtual {v2}, Landroid/telephony/LinkCapacityEstimate;->getUplinkCapacityKbps()I

    move-result v0

    .line 2647
    invoke-virtual {v2}, Landroid/telephony/LinkCapacityEstimate;->getDownlinkCapacityKbps()I

    move-result v1

    goto :goto_2

    .line 2649
    :cond_1
    invoke-virtual {v2}, Landroid/telephony/LinkCapacityEstimate;->getType()I

    move-result v3

    if-eqz v3, :cond_3

    .line 2650
    invoke-virtual {v2}, Landroid/telephony/LinkCapacityEstimate;->getType()I

    move-result v3

    const/4 v4, 0x1

    if-ne v3, v4, :cond_2

    goto :goto_1

    .line 2654
    :cond_2
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Invalid LinkCapacityEstimate type "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Landroid/telephony/LinkCapacityEstimate;->getType()I

    move-result v2

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 2651
    :cond_3
    :goto_1
    invoke-virtual {v2}, Landroid/telephony/LinkCapacityEstimate;->getUplinkCapacityKbps()I

    move-result v3

    add-int/2addr v0, v3

    .line 2652
    invoke-virtual {v2}, Landroid/telephony/LinkCapacityEstimate;->getDownlinkCapacityKbps()I

    move-result v2

    add-int/2addr v1, v2

    goto :goto_0

    .line 2657
    :cond_4
    :goto_2
    invoke-direct {p0, v0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->onBandwidthUpdated(II)V

    return-void
.end method

.method private onDataConfigUpdated()V
    .locals 1

    const-string v0, "onDataConfigUpdated"

    .line 2626
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2628
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateBandwidthFromDataConfig()V

    .line 2629
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateTcpBufferSizes()V

    .line 2630
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateMeteredAndCongested()V

    return-void
.end method

.method private onDataStateChanged(ILjava/util/List;)V
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/List<",
            "Landroid/telephony/data/DataCallResponse;",
            ">;)V"
        }
    .end annotation

    .line 2576
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataStateChanged: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->logv(Ljava/lang/String;)V

    .line 2577
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    if-ne p1, v0, :cond_5

    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    invoke-virtual {p1, v0}, Landroid/util/SparseIntArray;->get(I)I

    move-result p1

    const/4 v0, -0x1

    if-eq p1, v0, :cond_5

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result p1

    if-eqz p1, :cond_0

    goto/16 :goto_0

    .line 2581
    :cond_0
    invoke-interface {p2}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance p2, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda15;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda15;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 2582
    invoke-interface {p1, p2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 2583
    invoke-interface {p1}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object p1

    const/4 p2, 0x0

    .line 2584
    invoke-virtual {p1, p2}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/data/DataCallResponse;

    const-wide/16 v2, -0x1

    const v0, 0x1000b

    const-string v4, " data service."

    if-eqz p1, :cond_3

    .line 2586
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallResponse:Landroid/telephony/data/DataCallResponse;

    invoke-virtual {p1, p2}, Landroid/telephony/data/DataCallResponse;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_5

    .line 2587
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2588
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->validateDataCallResponse(Landroid/telephony/data/DataCallResponse;)V

    .line 2589
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallResponse:Landroid/telephony/data/DataCallResponse;

    .line 2590
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getLinkStatus()I

    move-result p2

    if-eqz p2, :cond_1

    .line 2591
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->updateDataNetwork(Landroid/telephony/data/DataCallResponse;)V

    goto :goto_0

    .line 2593
    :cond_1
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataStateChanged: PDN inactive reported by "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    .line 2594
    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 2593
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2596
    iget-boolean p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mEverConnected:Z

    if-eqz p2, :cond_2

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result v0

    .line 2597
    :cond_2
    iput v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 2598
    iput-wide v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRetryDelayMillis:J

    .line 2599
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto :goto_0

    .line 2606
    :cond_3
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataServiceManagers:Landroid/util/SparseArray;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {p1, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/data/DataServiceManager;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    iget v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {v1, v5}, Landroid/util/SparseIntArray;->get(I)I

    move-result v1

    const/4 v5, 0x1

    invoke-virtual {p1, v1, v5, p2}, Lcom/android/internal/telephony/data/DataServiceManager;->deactivateDataCall(IILandroid/os/Message;)V

    .line 2613
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "onDataStateChanged: PDN disconnected reported by "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    .line 2614
    invoke-static {p2}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2613
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2615
    iget-boolean p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mEverConnected:Z

    if-eqz p1, :cond_4

    const v0, 0x10004

    .line 2616
    :cond_4
    iput v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 2617
    iput-wide v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRetryDelayMillis:J

    .line 2618
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    :cond_5
    :goto_0
    return-void
.end method

.method private onDisplayInfoChanged()V
    .locals 1

    .line 2694
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDisplayInfoController()Lcom/android/internal/telephony/DisplayInfoController;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/DisplayInfoController;->getTelephonyDisplayInfo()Landroid/telephony/TelephonyDisplayInfo;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTelephonyDisplayInfo:Landroid/telephony/TelephonyDisplayInfo;

    .line 2695
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateBandwidthFromDataConfig()V

    .line 2696
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateTcpBufferSizes()V

    .line 2697
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateMeteredAndCongested()V

    return-void
.end method

.method private onHandoverResponse(ILandroid/telephony/data/DataCallResponse;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V
    .locals 3

    .line 3159
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onHandoverResponse: resultCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Landroid/telephony/data/DataServiceCallback;->resultCodeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", response="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 3161
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->getFailCauseFromDataCallResponse(ILandroid/telephony/data/DataCallResponse;)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 3162
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataNetwork;->validateDataCallResponse(Landroid/telephony/data/DataCallResponse;)V

    .line 3163
    iget p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    if-nez p1, :cond_3

    .line 3167
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataServiceManagers:Landroid/util/SparseArray;

    iget v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {p1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/data/DataServiceManager;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {v0, v1}, Landroid/util/SparseIntArray;->get(I)I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x3

    invoke-virtual {p1, v0, v2, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->deactivateDataCall(IILandroid/os/Message;)V

    .line 3170
    iget p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->getTargetTransport(I)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    .line 3172
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "DN-"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mInitialNetworkAgentId:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "-"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3173
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    const-string v0, "C"

    goto :goto_0

    :cond_0
    const-string v0, "I"

    :goto_0
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLogTag:Ljava/lang/String;

    .line 3176
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mHandoverDataProfile:Landroid/telephony/data/DataProfile;

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 3177
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataNetwork;->updateDataNetwork(Landroid/telephony/data/DataCallResponse;)V

    .line 3178
    iget p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    if-eq p1, v1, :cond_1

    .line 3180
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPcoData:Ljava/util/Map;

    invoke-interface {p1}, Ljava/util/Map;->clear()V

    .line 3181
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->unregisterForWwanEvents()V

    goto :goto_1

    .line 3184
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->registerForWwanEvents()V

    :goto_1
    if-eqz p3, :cond_2

    .line 3186
    invoke-virtual {p3, v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    .line 3187
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance p2, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda0;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    goto :goto_4

    :cond_3
    if-eqz p2, :cond_4

    .line 3191
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getRetryDurationMillis()J

    move-result-wide v0

    goto :goto_2

    :cond_4
    const-wide/16 v0, -0x1

    :goto_2
    if-eqz p2, :cond_5

    .line 3193
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getHandoverFailureMode()I

    move-result p1

    goto :goto_3

    :cond_5
    const/4 p1, 0x0

    :goto_3
    if-eqz p3, :cond_6

    const/4 p2, 0x2

    .line 3195
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    .line 3196
    :cond_6
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance p3, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda1;

    invoke-direct {p3, p0, v0, v1, p1}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/DataNetwork;JI)V

    invoke-virtual {p2, p3}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    .line 3199
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    iget p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->onHandoverFailure(I)V

    .line 3203
    :goto_4
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectedState:Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method private onPcoDataReceived(Landroid/telephony/PcoData;)V
    .locals 4

    .line 3212
    iget v0, p1, Landroid/telephony/PcoData;->cid:I

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getId()I

    move-result v1

    if-eq v0, v1, :cond_0

    return-void

    .line 3213
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPcoData:Ljava/util/Map;

    iget v1, p1, Landroid/telephony/PcoData;->pcoId:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/PcoData;

    .line 3214
    invoke-static {v0, p1}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 3215
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onPcoDataReceived: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 3216
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    .line 3218
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 3219
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getApnTypes()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 3220
    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.telephony.action.CARRIER_SIGNAL_PCO_VALUE"

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v3, "android.telephony.extra.APN_TYPE"

    .line 3221
    invoke-virtual {v2, v3, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 3222
    iget-object v1, p1, Landroid/telephony/PcoData;->bearerProto:Ljava/lang/String;

    .line 3223
    invoke-static {v1}, Landroid/telephony/data/ApnSetting;->getProtocolIntFromString(Ljava/lang/String;)I

    move-result v1

    const-string v3, "android.telephony.extra.APN_PROTOCOL"

    .line 3222
    invoke-virtual {v2, v3, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 3224
    iget v1, p1, Landroid/telephony/PcoData;->pcoId:I

    const-string v3, "android.telephony.extra.PCO_ID"

    invoke-virtual {v2, v3, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 3225
    iget-object v1, p1, Landroid/telephony/PcoData;->contents:[B

    const-string v3, "android.telephony.extra.PCO_VALUE"

    invoke-virtual {v2, v3, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;[B)Landroid/content/Intent;

    .line 3226
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getCarrierSignalAgent()Lcom/android/internal/telephony/CarrierSignalAgent;

    move-result-object v1

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/CarrierSignalAgent;->notifyCarrierSignalReceivers(Landroid/content/Intent;)V

    goto :goto_0

    :cond_1
    return-void
.end method

.method private onStartHandover(ILcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V
    .locals 13

    .line 3099
    iget v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    if-ne v0, p1, :cond_1

    .line 3100
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onStartHandover: The network is already on "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    .line 3101
    invoke-static {v0}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", handover is not needed."

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 3100
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    if-eqz p2, :cond_0

    const/4 p0, 0x4

    .line 3103
    invoke-virtual {p2, p0}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    :cond_0
    return-void

    .line 3110
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRoamingFromRegistration()Z

    move-result v4

    .line 3115
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getDataRoamingEnabled()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_3

    if-eqz v4, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 3116
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v0

    if-nez v0, :cond_2

    goto :goto_0

    :cond_2
    move v5, v1

    goto :goto_1

    :cond_3
    :goto_0
    const/4 v0, 0x1

    move v5, v0

    .line 3118
    :goto_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mHandoverDataProfile:Landroid/telephony/data/DataProfile;

    .line 3119
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->getDataNetworkType(I)I

    move-result v0

    if-eqz v0, :cond_4

    .line 3120
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    .line 3121
    invoke-virtual {v2}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_4

    .line 3122
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v2, v1}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 3123
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataProfileManager()Lcom/android/internal/telephony/data/DataProfileManager;

    move-result-object v2

    .line 3124
    invoke-virtual {v2, v1, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->getDataProfileForNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Landroid/telephony/data/DataProfile;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 3127
    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    if-eqz v1, :cond_4

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 3128
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    if-eqz v1, :cond_4

    .line 3129
    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 3130
    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v2

    .line 3129
    invoke-static {v1, v2}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_4

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 3131
    invoke-virtual {v0, v1}, Landroid/telephony/data/DataProfile;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_4

    .line 3132
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mHandoverDataProfile:Landroid/telephony/data/DataProfile;

    .line 3133
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Used different data profile for handover. "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 3137
    :cond_4
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Start handover from "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3138
    invoke-static {p1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 3137
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 3140
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataServiceManagers:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    move-object v1, v0

    check-cast v1, Lcom/android/internal/telephony/data/DataServiceManager;

    .line 3141
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->getDataNetworkType(I)I

    move-result p1

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataUtils;->networkTypeToAccessNetworkType(I)I

    move-result v2

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mHandoverDataProfile:Landroid/telephony/data/DataProfile;

    const/4 v6, 0x3

    iget-object v7, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    iget v8, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    iget-object v9, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkSliceInfo:Landroid/telephony/data/NetworkSliceInfo;

    .line 3144
    invoke-virtual {v3}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v10

    const/4 v11, 0x1

    const/16 p1, 0xf

    .line 3145
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v12

    .line 3140
    invoke-virtual/range {v1 .. v12}, Lcom/android/internal/telephony/data/DataServiceManager;->setupDataCall(ILandroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;ILandroid/telephony/data/NetworkSliceInfo;Landroid/telephony/data/TrafficDescriptor;ZLandroid/os/Message;)V

    .line 3146
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mHandoverState:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method private registerForBandwidthUpdate()V
    .locals 3

    .line 1684
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getBandwidthEstimateSource()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 1686
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 1687
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object p0

    const/16 v1, 0xb

    const/4 v2, 0x0

    .line 1686
    invoke-interface {v0, p0, v1, v2}, Lcom/android/internal/telephony/CommandsInterface;->registerForLceInfo(Landroid/os/Handler;ILjava/lang/Object;)V

    goto :goto_0

    :cond_0
    const/4 v1, 0x3

    if-ne v0, v1, :cond_1

    .line 1689
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkBandwidthEstimatorCallback:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;

    if-nez v0, :cond_2

    .line 1690
    new-instance v0, Lcom/android/internal/telephony/data/DataNetwork$3;

    .line 1691
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-static {v1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v2, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;

    invoke-direct {v2, v1}, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;-><init>(Landroid/os/Handler;)V

    invoke-direct {v0, p0, v2}, Lcom/android/internal/telephony/data/DataNetwork$3;-><init>(Lcom/android/internal/telephony/data/DataNetwork;Ljava/util/concurrent/Executor;)V

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkBandwidthEstimatorCallback:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;

    .line 1700
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getLinkBandwidthEstimator()Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkBandwidthEstimatorCallback:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->registerCallback(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V

    goto :goto_0

    .line 1704
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Invalid bandwidth source configuration: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    :cond_2
    :goto_0
    return-void
.end method

.method private registerForWwanEvents()V
    .locals 3

    .line 1567
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->registerForBandwidthUpdate()V

    .line 1568
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mKeepaliveTracker:Lcom/android/internal/telephony/data/KeepaliveTracker;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/KeepaliveTracker;->registerForKeepaliveStatus()V

    .line 1569
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRil:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object p0

    const/16 v1, 0x11

    const/4 v2, 0x0

    invoke-interface {v0, p0, v1, v2}, Lcom/android/internal/telephony/CommandsInterface;->registerForPcoData(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method private removeUnsatisfiedNetworkRequests()V
    .locals 4

    .line 1730
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 1731
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->canBeSatisfiedBy(Landroid/net/NetworkCapabilities;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 1732
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "removeUnsatisfiedNetworkRequests: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, " can\'t be satisfied anymore. Will be detached."

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 1734
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->detachNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    goto :goto_0

    :cond_1
    return-void
.end method

.method private reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 3402
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 3403
    invoke-static {p2}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object p2

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result p0

    invoke-static {p2, p1, p0}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V

    return-void
.end method

.method private shouldSkip464Xlat()Z
    .locals 3

    .line 915
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz v0, :cond_2

    .line 916
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getSkip464Xlat()I

    move-result v0

    if-eqz v0, :cond_1

    if-eq v0, v2, :cond_0

    goto :goto_0

    :cond_0
    return v2

    :cond_1
    return v1

    .line 928
    :cond_2
    :goto_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p0

    const/4 v0, 0x4

    .line 929
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_3

    const/16 v0, 0xc

    .line 930
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p0

    if-nez p0, :cond_3

    move v1, v2

    :cond_3
    return v1
.end method

.method public static tearDownReasonToString(I)Ljava/lang/String;
    .locals 2
    .param p0    # I
        .annotation build Lcom/android/internal/telephony/data/DataNetwork$TearDownReason;
        .end annotation
    .end param

    packed-switch p0, :pswitch_data_0

    .line 3320
    :pswitch_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :pswitch_1
    const-string p0, "TEAR_DOWN_REASON_PREFERRED_DATA_SWITCHED"

    return-object p0

    :pswitch_2
    const-string p0, "TEAR_DOWN_REASON_ONLY_ALLOWED_SINGLE_NETWORK"

    return-object p0

    :pswitch_3
    const-string p0, "TEAR_DOWN_REASON_ILLEGAL_STATE"

    return-object p0

    :pswitch_4
    const-string p0, "TEAR_DOWN_REASON_NOT_ALLOWED_BY_POLICY"

    return-object p0

    :pswitch_5
    const-string p0, "TEAR_DOWN_REASON_DATA_PROFILE_NOT_PREFERRED"

    return-object p0

    :pswitch_6
    const-string p0, "TEAR_DOWN_REASON_DATA_PROFILE_INVALID"

    return-object p0

    :pswitch_7
    const-string p0, "TEAR_DOWN_REASON_DATA_THROTTLED"

    return-object p0

    :pswitch_8
    const-string p0, "TEAR_DOWN_REASON_RETRY_SCHEDULED"

    return-object p0

    :pswitch_9
    const-string p0, "TEAR_DOWN_REASON_CDMA_EMERGENCY_CALLBACK_MODE"

    return-object p0

    :pswitch_a
    const-string p0, "TEAR_DOWN_REASON_NO_SUITABLE_DATA_PROFILE"

    return-object p0

    :pswitch_b
    const-string p0, "TEAR_DOWN_REASON_PENDING_TEAR_DOWN_ALL"

    return-object p0

    :pswitch_c
    const-string p0, "TEAR_DOWN_REASON_DATA_CONFIG_NOT_READY"

    return-object p0

    :pswitch_d
    const-string p0, "TEAR_DOWN_REASON_NOT_IN_SERVICE"

    return-object p0

    :pswitch_e
    const-string p0, "TEAR_DOWN_REASON_DEFAULT_DATA_UNSELECTED"

    return-object p0

    :pswitch_f
    const-string p0, "TEAR_DOWN_REASON_VOPS_NOT_SUPPORTED"

    return-object p0

    :pswitch_10
    const-string p0, "TEAR_DOWN_REASON_VCN_REQUESTED"

    return-object p0

    :pswitch_11
    const-string p0, "TEAR_DOWN_REASON_HANDOVER_NOT_ALLOWED"

    return-object p0

    :pswitch_12
    const-string p0, "TEAR_DOWN_REASON_HANDOVER_FAILED"

    return-object p0

    :pswitch_13
    const-string p0, "TEAR_DOWN_REASON_DATA_STALL"

    return-object p0

    :pswitch_14
    const-string p0, "TEAR_DOWN_REASON_POWER_OFF_BY_CARRIER"

    return-object p0

    :pswitch_15
    const-string p0, "TEAR_DOWN_REASON_DATA_SERVICE_NOT_READY"

    return-object p0

    :pswitch_16
    const-string p0, "TEAR_DOWN_REASON_CONCURRENT_VOICE_DATA_NOT_ALLOWED"

    return-object p0

    :pswitch_17
    const-string p0, "TEAR_DOWN_REASON_ROAMING_DISABLED"

    return-object p0

    :pswitch_18
    const-string p0, "TEAR_DOWN_REASON_RAT_NOT_ALLOWED"

    return-object p0

    :pswitch_19
    const-string p0, "TEAR_DOWN_REASON_NO_LIVE_REQUEST"

    return-object p0

    :pswitch_1a
    const-string p0, "DATA_DISABLED"

    return-object p0

    :pswitch_1b
    const-string p0, "AIRPLANE_MODE_ON"

    return-object p0

    :pswitch_1c
    const-string p0, "SIM_REMOVAL"

    return-object p0

    :pswitch_1d
    const-string p0, "CONNECTIVITY_SERVICE_UNWANTED"

    return-object p0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_1d
        :pswitch_1c
        :pswitch_1b
        :pswitch_1a
        :pswitch_19
        :pswitch_18
        :pswitch_17
        :pswitch_16
        :pswitch_0
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
    .end packed-switch
.end method

.method private unregisterForBandwidthUpdate()V
    .locals 3

    .line 1712
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getBandwidthEstimateSource()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 1714
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForLceInfo(Landroid/os/Handler;)V

    goto :goto_0

    :cond_0
    const/4 v1, 0x3

    if-ne v0, v1, :cond_1

    .line 1716
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkBandwidthEstimatorCallback:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;

    if-eqz v0, :cond_2

    .line 1717
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getLinkBandwidthEstimator()Lcom/android/internal/telephony/data/LinkBandwidthEstimator;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkBandwidthEstimatorCallback:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;

    .line 1718
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/LinkBandwidthEstimator;->unregisterCallback(Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;)V

    const/4 v0, 0x0

    .line 1719
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkBandwidthEstimatorCallback:Lcom/android/internal/telephony/data/LinkBandwidthEstimator$LinkBandwidthEstimatorCallback;

    goto :goto_0

    .line 1722
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Invalid bandwidth source configuration: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    :cond_2
    :goto_0
    return-void
.end method

.method private unregisterForWwanEvents()V
    .locals 1

    .line 1576
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->unregisterForBandwidthUpdate()V

    .line 1577
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mKeepaliveTracker:Lcom/android/internal/telephony/data/KeepaliveTracker;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/KeepaliveTracker;->unregisterForKeepaliveStatus()V

    .line 1578
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRil:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForPcoData(Landroid/os/Handler;)V

    return-void
.end method

.method private updateBandwidthFromDataConfig()V
    .locals 2

    .line 2705
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getBandwidthEstimateSource()I

    move-result v0

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    return-void

    :cond_0
    const-string/jumbo v0, "updateBandwidthFromDataConfig"

    .line 2708
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2709
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTelephonyDisplayInfo:Landroid/telephony/TelephonyDisplayInfo;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getBandwidthForNetworkType(Landroid/telephony/TelephonyDisplayInfo;)Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkBandwidth:Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    .line 2710
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkCapabilities()V

    return-void
.end method

.method private updateMeteredAndCongested()V
    .locals 6

    .line 2732
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTelephonyDisplayInfo:Landroid/telephony/TelephonyDisplayInfo;

    invoke-virtual {v0}, Landroid/telephony/TelephonyDisplayInfo;->getNetworkType()I

    move-result v0

    .line 2733
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTelephonyDisplayInfo:Landroid/telephony/TelephonyDisplayInfo;

    invoke-virtual {v1}, Landroid/telephony/TelephonyDisplayInfo;->getOverrideNetworkType()I

    move-result v1

    const/4 v2, 0x1

    if-eq v1, v2, :cond_1

    const/4 v3, 0x2

    if-eq v1, v3, :cond_1

    const/4 v3, 0x3

    if-eq v1, v3, :cond_0

    const/4 v3, 0x5

    if-eq v1, v3, :cond_0

    goto :goto_0

    :cond_0
    const/16 v0, 0x14

    goto :goto_0

    :cond_1
    const/16 v0, 0x13

    .line 2743
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "updateMeteredAndCongested: networkType="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2744
    invoke-static {v0}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 2743
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2746
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->isTempNotMeteredSupportedByCarrier()Z

    move-result v1

    iget-boolean v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMeteredSupported:Z

    const/4 v4, 0x0

    if-eq v1, v3, :cond_2

    xor-int/lit8 v1, v3, 0x1

    .line 2747
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMeteredSupported:Z

    .line 2749
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "updateMeteredAndCongested: mTempNotMeteredSupported changed to "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMeteredSupported:Z

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    move v1, v2

    goto :goto_1

    :cond_2
    move v1, v4

    .line 2752
    :goto_1
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataNetworkController;->getUnmeteredOverrideNetworkTypes()Ljava/util/Set;

    move-result-object v3

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-interface {v3, v5}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_3

    .line 2753
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->isNetworkTypeUnmetered(I)Z

    move-result v3

    if-eqz v3, :cond_4

    :cond_3
    move v4, v2

    :cond_4
    iget-boolean v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMetered:Z

    if-eq v4, v3, :cond_5

    xor-int/lit8 v1, v3, 0x1

    .line 2754
    iput-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMetered:Z

    .line 2756
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "updateMeteredAndCongested: mTempNotMetered changed to "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMetered:Z

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    move v1, v2

    .line 2758
    :cond_5
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataNetworkController;->getCongestedOverrideNetworkTypes()Ljava/util/Set;

    move-result-object v3

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {v3, v0}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v0

    iget-boolean v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCongested:Z

    if-eq v0, v3, :cond_6

    xor-int/lit8 v0, v3, 0x1

    .line 2760
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCongested:Z

    .line 2762
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateMeteredAndCongested: mCongested changed to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCongested:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    goto :goto_2

    :cond_6
    move v2, v1

    :goto_2
    if-eqz v2, :cond_7

    .line 2765
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkCapabilities()V

    :cond_7
    return-void
.end method

.method private updateNetworkScore()V
    .locals 3

    .line 2853
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkScore()I

    move-result v0

    .line 2854
    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkScore:I

    if-eq v0, v1, :cond_0

    .line 2855
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Updating score from "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkScore:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 2856
    iput v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkScore:I

    .line 2857
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    invoke-virtual {p0, v0}, Landroid/net/NetworkAgent;->sendNetworkScore(I)V

    :cond_0
    return-void
.end method

.method private updateTcpBufferSizes()V
    .locals 2

    const-string/jumbo v0, "updateTcpBufferSizes"

    .line 2717
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2718
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTelephonyDisplayInfo:Landroid/telephony/TelephonyDisplayInfo;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getTcpConfigString(Landroid/telephony/TelephonyDisplayInfo;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTcpBufferSizes:Ljava/lang/String;

    .line 2719
    new-instance v0, Landroid/net/LinkProperties;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-direct {v0, v1}, Landroid/net/LinkProperties;-><init>(Landroid/net/LinkProperties;)V

    .line 2720
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTcpBufferSizes:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/net/LinkProperties;->setTcpBufferSizes(Ljava/lang/String;)V

    .line 2721
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {v0, v1}, Landroid/net/LinkProperties;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 2722
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    .line 2723
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "sendLinkProperties "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2724
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {v0, p0}, Landroid/net/NetworkAgent;->sendLinkProperties(Landroid/net/LinkProperties;)V

    :cond_0
    return-void
.end method

.method private validateDataCallResponse(Landroid/telephony/data/DataCallResponse;)V
    .locals 3

    if-eqz p1, :cond_3

    .line 2439
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getLinkStatus()I

    move-result v0

    if-nez v0, :cond_0

    goto/16 :goto_0

    .line 2440
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result v0

    if-nez v0, :cond_2

    .line 2442
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 2443
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getAddresses()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_1

    .line 2445
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getLinkStatus()I

    move-result v0

    const/4 v1, -0x1

    if-lt v0, v1, :cond_1

    .line 2446
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getLinkStatus()I

    move-result v0

    const/4 v2, 0x2

    if-gt v0, v2, :cond_1

    .line 2447
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getProtocolType()I

    move-result v0

    if-lt v0, v1, :cond_1

    .line 2448
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getProtocolType()I

    move-result v0

    const/4 v2, 0x5

    if-gt v0, v2, :cond_1

    .line 2449
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getHandoverFailureMode()I

    move-result v0

    if-lt v0, v1, :cond_1

    .line 2451
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getHandoverFailureMode()I

    move-result v0

    const/4 v1, 0x3

    if-le v0, v1, :cond_3

    .line 2453
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Invalid DataCallResponse:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    const-string p1, "Invalid DataCallResponse detected"

    const-string v0, "1f273e9d-b09c-46eb-ad1c-421d01f61164"

    .line 2454
    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/data/DataNetwork;->reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 2457
    :cond_2
    invoke-static {v0}, Landroid/telephony/DataFailCause;->isFailCauseExisting(I)Z

    move-result v1

    if-nez v1, :cond_3

    .line 2458
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Invalid DataFailCause in "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    .line 2459
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Invalid DataFailCause: (0x"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ")"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "6b264f28-9f58-4cbd-9e0e-d7624ba30879"

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/data/DataNetwork;->reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V

    :cond_3
    :goto_0
    return-void
.end method


# virtual methods
.method public attachNetworkRequests(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Z
    .locals 1

    .line 1604
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x2

    .line 1608
    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    const/4 p0, 0x1

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method public detachNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V
    .locals 1

    .line 1674
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x3

    .line 1677
    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 3

    .line 3455
    new-instance v0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 3456
    invoke-super {p0, p1, v0, p3}, Lcom/android/internal/telephony/StateMachine;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 3457
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Tag: "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->name()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3458
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3459
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mSubId="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSubId:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3460
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mTransport="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3461
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "WWAN cid="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/util/SparseIntArray;->get(I)I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3462
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "WLAN cid="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    const/4 v2, 0x2

    invoke-virtual {v1, v2}, Landroid/util/SparseIntArray;->get(I)I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3463
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mNetworkScore="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkScore:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3464
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataAllowedReason="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3465
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mPduSessionId="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3466
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataProfile="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3467
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mNetworkCapabilities="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3468
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mLinkProperties="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3469
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mNetworkSliceInfo="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkSliceInfo:Landroid/telephony/data/NetworkSliceInfo;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3470
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mNetworkBandwidth="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkBandwidth:Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3471
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mTcpBufferSizes="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTcpBufferSizes:Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3472
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mTelephonyDisplayInfo="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTelephonyDisplayInfo:Landroid/telephony/TelephonyDisplayInfo;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3473
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mTempNotMeteredSupported="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMeteredSupported:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3474
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mTempNotMetered="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMetered:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3475
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCongested="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCongested:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3476
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mSuspended="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSuspended:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3477
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataCallResponse="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallResponse:Landroid/telephony/data/DataCallResponse;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3478
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mFailCause="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    invoke-static {v1}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3479
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mAdministratorUids="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAdministratorUids:[I

    invoke-static {v1}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3480
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCarrierServicePackageUid="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCarrierServicePackageUid:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3481
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mEverConnected="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mEverConnected:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3482
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mInvokedDataDeactivation="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mInvokedDataDeactivation:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Attached network requests:"

    .line 3484
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3485
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3486
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p2}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 3487
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/Object;)V

    goto :goto_0

    .line 3489
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3490
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mQosBearerSessions="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mQosBearerSessions:Ljava/util/List;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3492
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    const-string p2, "Local logs:"

    .line 3493
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 3494
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3495
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 3496
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 3497
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p0, "---------------"

    .line 3498
    invoke-virtual {v0, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    return-void
.end method

.method public getApnTypeNetworkCapability()I
    .locals 2

    .line 2907
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    .line 2909
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result p0

    return p0

    .line 2911
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v0

    invoke-virtual {v0}, Landroid/net/NetworkCapabilities;->getCapabilities()[I

    move-result-object v0

    invoke-static {v0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda7;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda7;-><init>()V

    .line 2912
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2914
    invoke-static {p0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda8;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda8;-><init>(Lcom/android/internal/telephony/data/DataConfigManager;)V

    invoke-static {v1}, Ljava/util/Comparator;->comparingInt(Ljava/util/function/ToIntFunction;)Ljava/util/Comparator;

    move-result-object p0

    invoke-interface {v0, p0}, Ljava/util/stream/Stream;->max(Ljava/util/Comparator;)Ljava/util/Optional;

    move-result-object p0

    const/4 v0, -0x1

    .line 2915
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0
.end method

.method public getAttachedNetworkRequestList()Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;
    .locals 0

    .line 2948
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    return-object p0
.end method

.method protected getDataNetworkType(I)I
    .locals 1

    const/4 v0, 0x2

    if-ne p1, v0, :cond_0

    const/16 p0, 0x12

    return p0

    .line 2833
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    .line 2834
    invoke-virtual {p0, v0, p1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 2837
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result p0

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public getDataProfile()Landroid/telephony/data/DataProfile;
    .locals 0

    .line 2045
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    return-object p0
.end method

.method protected getFailCauseFromDataCallResponse(ILandroid/telephony/data/DataCallResponse;)I
    .locals 0

    if-eqz p1, :cond_4

    const/4 p0, 0x1

    if-eq p1, p0, :cond_3

    const/4 p0, 0x2

    if-eq p1, p0, :cond_2

    const/4 p0, 0x3

    if-eq p1, p0, :cond_1

    const/4 p0, 0x4

    if-eq p1, p0, :cond_0

    const/4 p0, 0x5

    if-eq p1, p0, :cond_1

    goto :goto_0

    :cond_0
    const p0, 0x10001

    goto :goto_1

    :cond_1
    const p0, 0x10009

    goto :goto_1

    :cond_2
    const p0, 0x10002

    goto :goto_1

    :cond_3
    const p0, 0x1000a

    goto :goto_1

    :cond_4
    if-eqz p2, :cond_5

    .line 2183
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result p0

    invoke-static {p0}, Landroid/telephony/DataFailCause;->getFailCause(I)I

    move-result p0

    goto :goto_1

    :cond_5
    :goto_0
    const/4 p0, 0x0

    :goto_1
    return p0
.end method

.method public getId()I
    .locals 1

    .line 2809
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {v0, p0}, Landroid/util/SparseIntArray;->get(I)I

    move-result p0

    return p0
.end method

.method public getLinkProperties()Landroid/net/LinkProperties;
    .locals 0

    .line 2038
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    return-object p0
.end method

.method public getLinkStatus()I
    .locals 0

    .line 2846
    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkStatus:I

    return p0
.end method

.method public getNetworkCapabilities()Landroid/net/NetworkCapabilities;
    .locals 0

    .line 2031
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    return-object p0
.end method

.method public getPcoData()Ljava/util/Map;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Landroid/telephony/PcoData;",
            ">;"
        }
    .end annotation

    .line 3236
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPcoData:Ljava/util/Map;

    return-object p0
.end method

.method public getPriority()I
    .locals 3

    .line 2931
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 2933
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p0, v1}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getPriority()I

    move-result p0

    return p0

    .line 2937
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v0

    invoke-virtual {v0}, Landroid/net/NetworkCapabilities;->getCapabilities()[I

    move-result-object v0

    invoke-static {v0}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 2938
    invoke-static {p0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v2, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda2;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/DataConfigManager;)V

    invoke-interface {v0, v2}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda3;-><init>()V

    .line 2939
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->max(Ljava/util/Comparator;)Ljava/util/Optional;

    move-result-object p0

    .line 2940
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0
.end method

.method public getTransport()I
    .locals 0

    .line 2997
    iget p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    return p0
.end method

.method public isConnected()Z
    .locals 1

    .line 2962
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectedState:Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isConnecting()Z
    .locals 1

    .line 2955
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectingState:Lcom/android/internal/telephony/data/DataNetwork$ConnectingState;

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isDisconnected()Z
    .locals 1

    .line 2976
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isDisconnecting()Z
    .locals 1

    .line 2969
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectingState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectingState;

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isEmergencySupl()Z
    .locals 1

    .line 3041
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->EMERGENCY_SUPL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isHandoverInProgress()Z
    .locals 1

    .line 2983
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mHandoverState:Lcom/android/internal/telephony/data/DataNetwork$HandoverState;

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isInternetSupported()Z
    .locals 2

    .line 3025
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/16 v1, 0xc

    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/16 v1, 0xd

    .line 3026
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/16 v1, 0xe

    .line 3028
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/16 v1, 0x1c

    .line 3030
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/16 v0, 0xf

    .line 3032
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isSuspended()Z
    .locals 1

    .line 2990
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getState()I

    move-result p0

    const/4 v0, 0x3

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method protected log(Ljava/lang/String;)V
    .locals 3

    .line 3412
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLogTag:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v2

    if-eqz v2, :cond_0

    .line 3413
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p0

    invoke-interface {p0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ": "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, ""

    :goto_0
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 3412
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 3

    .line 3422
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLogTag:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v2

    if-eqz v2, :cond_0

    .line 3423
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p0

    invoke-interface {p0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ": "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, ""

    :goto_0
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 3422
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logl(Ljava/lang/String;)V
    .locals 3

    .line 3443
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 3444
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v2

    if-eqz v2, :cond_0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p0

    invoke-interface {p0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ": "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, ""

    :goto_0
    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logv(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method protected mtkGetCustomizedMtu(Landroid/telephony/data/ApnSetting;I)I
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected mtkHandleSetupResponse(ILandroid/telephony/data/DataCallResponse;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected mtkReplaceStates()V
    .locals 0

    return-void
.end method

.method protected mtkSkipDataStallAlarm(Ljava/lang/String;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected mtkUpdateNetworkCapabilities(Landroid/net/NetworkCapabilities$Builder;)V
    .locals 0

    return-void
.end method

.method public name()Ljava/lang/String;
    .locals 0

    .line 3392
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLogTag:Ljava/lang/String;

    return-object p0
.end method

.method protected notifyPreciseDataConnectionState()V
    .locals 3

    .line 3066
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getPreciseDataConnectionState()Landroid/telephony/PreciseDataConnectionState;

    move-result-object v0

    .line 3067
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "notifyPreciseDataConnectionState="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->logv(Ljava/lang/String;)V

    .line 3068
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/Phone;->notifyDataConnection(Landroid/telephony/PreciseDataConnectionState;)V

    return-void
.end method

.method public onAttachNetworkRequests(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V
    .locals 4

    .line 1618
    new-instance v0, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;-><init>()V

    .line 1619
    invoke-virtual {p1}, Ljava/util/LinkedList;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 1620
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->isNetworkRequestExisting(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 1621
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->add(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    .line 1622
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Attached failed. Network request was already removed. "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 1623
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->canBeSatisfiedBy(Landroid/net/NetworkCapabilities;)Z

    move-result v2

    if-nez v2, :cond_1

    .line 1624
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->add(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    .line 1625
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Attached failed. Cannot satisfy the network request "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 1628
    :cond_1
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;->add(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)Z

    .line 1629
    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->setAttachedNetwork(Lcom/android/internal/telephony/data/DataNetwork;)V

    const/4 v2, 0x1

    .line 1630
    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->setState(I)V

    .line 1632
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Successfully attached network request "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 1635
    :cond_2
    invoke-virtual {v0}, Ljava/util/LinkedList;->size()I

    move-result p1

    if-lez p1, :cond_3

    .line 1636
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda16;

    invoke-direct {v1, p0, v0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda16;-><init>(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)V

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    :cond_3
    return-void
.end method

.method protected onDeactivateResponse(I)V
    .locals 2

    .line 2471
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDeactivateResponse: resultCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2472
    invoke-static {p1}, Landroid/telephony/data/DataServiceCallback;->resultCodeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2471
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    const/4 v0, 0x4

    if-ne p1, v0, :cond_0

    const-string p1, "Remove network since deactivate request returned an error."

    .line 2474
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    const p1, 0x10001

    .line 2475
    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 2476
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto :goto_0

    .line 2477
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getHalVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object p1

    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_2_0:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 2478
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Remove network on deactivate data response on old HAL "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 2479
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getHalVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2478
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    const p1, 0x10004

    .line 2480
    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 2481
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    :cond_1
    :goto_0
    return-void
.end method

.method protected onDetachNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V
    .locals 1

    .line 1647
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v0, p1}, Ljava/util/LinkedList;->remove(Ljava/lang/Object;)Z

    const/4 v0, 0x0

    .line 1648
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->setState(I)V

    const/4 v0, 0x0

    .line 1649
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->setAttachedNetwork(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 1651
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p1}, Ljava/util/LinkedList;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_0

    const-string p1, "All network requests are detached."

    .line 1652
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    const/16 p1, 0x1e

    .line 1662
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->tearDown(I)V

    :cond_0
    return-void
.end method

.method protected onSetupResponse(ILandroid/telephony/data/DataCallResponse;)V
    .locals 7

    .line 2359
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onSetupResponse: resultCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Landroid/telephony/data/DataServiceCallback;->resultCodeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", response="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 2361
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->getFailCauseFromDataCallResponse(ILandroid/telephony/data/DataCallResponse;)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 2362
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataNetwork;->validateDataCallResponse(Landroid/telephony/data/DataCallResponse;)V

    .line 2364
    iget p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->mtkHandleSetupResponse(ILandroid/telephony/data/DataCallResponse;)Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 2367
    :cond_0
    iget p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    const-wide/16 v0, -0x1

    if-nez p1, :cond_5

    .line 2368
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->isNetworkInterfaceExisting(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 2369
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Interface "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " already existing. Silently tear down now."

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 2373
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getTrafficDescriptors()Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_1

    .line 2374
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Duplicate network interface "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " detected."

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "62f66e7e-8d71-45de-a57b-dc5c78223fd5"

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataNetwork;->reportAnomaly(Ljava/lang/String;Ljava/lang/String;)V

    .line 2380
    :cond_1
    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRetryDelayMillis:J

    const p1, 0x1000b

    .line 2381
    iput p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    .line 2382
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    return-void

    .line 2386
    :cond_2
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataNetwork;->updateDataNetwork(Landroid/telephony/data/DataCallResponse;)V

    .line 2392
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAttachedNetworkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {p1}, Ljava/util/LinkedList;->size()I

    move-result p1

    if-nez p1, :cond_3

    const-string p1, "Tear down the network since there is no live network request."

    .line 2393
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    const/4 p1, 0x5

    .line 2397
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->onTearDown(I)V

    return-void

    .line 2401
    :cond_3
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mVcnManager:Landroid/net/vcn/VcnManager;

    if-eqz p1, :cond_4

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p1, v0, v1}, Landroid/net/vcn/VcnManager;->applyVcnNetworkPolicy(Landroid/net/NetworkCapabilities;Landroid/net/LinkProperties;)Landroid/net/vcn/VcnNetworkPolicyResult;

    move-result-object p1

    .line 2402
    invoke-virtual {p1}, Landroid/net/vcn/VcnNetworkPolicyResult;->isTeardownRequested()Z

    move-result p1

    if-eqz p1, :cond_4

    const-string p1, "VCN service requested to tear down the network."

    .line 2403
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    const/16 p1, 0xf

    .line 2407
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->onTearDown(I)V

    return-void

    .line 2411
    :cond_4
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mConnectedState:Lcom/android/internal/telephony/data/DataNetwork$ConnectedState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto :goto_0

    :cond_5
    if-eqz p2, :cond_6

    .line 2414
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getRetryDurationMillis()J

    move-result-wide v0

    .line 2415
    :cond_6
    iput-wide v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mRetryDelayMillis:J

    .line 2416
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDisconnectedState:Lcom/android/internal/telephony/data/DataNetwork$DisconnectedState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    :goto_0
    const/4 p1, 0x0

    const/4 v0, -0x1

    .line 2421
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    if-eqz v1, :cond_7

    .line 2422
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getApnTypeBitmask()I

    move-result p1

    .line 2423
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getProtocol()I

    move-result v0

    :cond_7
    move v4, p1

    move v5, v0

    .line 2425
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    .line 2426
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getDataNetworkType()I

    move-result v3

    iget v6, p0, Lcom/android/internal/telephony/data/DataNetwork;->mFailCause:I

    move-object v2, p2

    .line 2425
    invoke-virtual/range {v1 .. v6}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->onSetupDataCallResponse(Landroid/telephony/data/DataCallResponse;IIII)V

    return-void
.end method

.method protected onTearDown(I)V
    .locals 4
    .param p1    # I
        .annotation build Lcom/android/internal/telephony/data/DataNetwork$TearDownReason;
        .end annotation
    .end param

    .line 2498
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onTearDown: reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataNetwork;->tearDownReasonToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    const/4 v0, 0x1

    if-ne p1, v0, :cond_1

    .line 2502
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v1

    if-eqz v1, :cond_1

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/4 v2, 0x4

    .line 2503
    invoke-virtual {v1, v2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v1

    if-nez v1, :cond_0

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/16 v2, 0xc

    .line 2504
    invoke-virtual {v1, v2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 2506
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;->onTrackNetworkUnwanted(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 2509
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataServiceManagers:Landroid/util/SparseArray;

    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {v1, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataServiceManager;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    iget v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {v2, v3}, Landroid/util/SparseIntArray;->get(I)I

    move-result v2

    const/4 v3, 0x3

    if-ne p1, v3, :cond_2

    const/4 p1, 0x2

    goto :goto_0

    :cond_2
    move p1, v0

    :goto_0
    const/16 v3, 0x13

    .line 2512
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v3

    .line 2509
    invoke-virtual {v1, v2, p1, v3}, Lcom/android/internal/telephony/data/DataServiceManager;->deactivateDataCall(IILandroid/os/Message;)V

    .line 2513
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->setDeactivateDataCallReason(I)V

    .line 2514
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mInvokedDataDeactivation:Z

    return-void
.end method

.method protected setupData()V
    .locals 19

    move-object/from16 v0, p0

    .line 2114
    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/data/DataNetwork;->getDataNetworkType()I

    move-result v1

    .line 2119
    iget-object v2, v0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v2}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getDataRoamingFromRegistration()Z

    move-result v2

    .line 2124
    iget-object v3, v0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v3}, Lcom/android/internal/telephony/PhoneInternalInterface;->getDataRoamingEnabled()Z

    move-result v3

    const/4 v4, 0x1

    if-nez v3, :cond_1

    if-eqz v2, :cond_0

    iget-object v3, v0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 2125
    invoke-interface {v3}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v3

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v3

    if-nez v3, :cond_0

    goto :goto_0

    :cond_0
    const/4 v14, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    move v14, v4

    .line 2128
    :goto_1
    iget-object v3, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v3}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v12

    if-eqz v12, :cond_3

    .line 2130
    invoke-virtual {v12}, Landroid/telephony/data/TrafficDescriptor;->getDataNetworkName()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_2

    goto :goto_2

    :cond_2
    const/4 v11, 0x0

    goto :goto_3

    :cond_3
    :goto_2
    move v11, v4

    .line 2132
    :goto_3
    invoke-static {v1}, Lcom/android/internal/telephony/data/DataUtils;->networkTypeToAccessNetworkType(I)I

    move-result v16

    .line 2134
    iget-object v3, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataServiceManagers:Landroid/util/SparseArray;

    iget v4, v0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {v3, v4}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/data/DataServiceManager;

    iget-object v5, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    const/4 v8, 0x1

    const/4 v9, 0x0

    iget v10, v0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    const/4 v13, 0x0

    const/4 v4, 0x6

    .line 2138
    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v17

    move/from16 v4, v16

    move v6, v2

    move v7, v14

    move/from16 v18, v11

    move-object v11, v13

    move/from16 v13, v18

    move v15, v14

    move-object/from16 v14, v17

    .line 2135
    invoke-virtual/range {v3 .. v14}, Lcom/android/internal/telephony/data/DataServiceManager;->setupDataCall(ILandroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;ILandroid/telephony/data/NetworkSliceInfo;Landroid/telephony/data/TrafficDescriptor;ZLandroid/os/Message;)V

    .line 2140
    iget-object v3, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v3}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v3

    if-eqz v3, :cond_4

    .line 2141
    iget-object v3, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v3}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v3

    invoke-virtual {v3}, Landroid/telephony/data/ApnSetting;->getApnTypeBitmask()I

    move-result v3

    goto :goto_4

    :cond_4
    const/4 v3, 0x0

    .line 2142
    :goto_4
    iget-object v4, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->onSetupDataCall(I)V

    .line 2144
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "setupData: accessNetwork="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2145
    invoke-static/range {v16 .. v16}, Landroid/telephony/AccessNetworkConstants$AccessNetworkType;->toString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, ", isModemRoaming="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", allowRoaming="

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v15}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", PDU session id="

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", matchAllRuleAllowed="

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v15, v18

    invoke-virtual {v3, v15}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 2144
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 2149
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v3

    iget-object v2, v0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v4

    .line 2150
    invoke-static {v1}, Landroid/telephony/ServiceState;->networkTypeToRilRadioTechnology(I)I

    move-result v5

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 2151
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getProfileId()I

    move-result v6

    iget-object v1, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApn()Ljava/lang/String;

    move-result-object v7

    iget-object v0, v0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->getProtocolType()I

    move-result v8

    .line 2149
    invoke-virtual/range {v3 .. v8}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeSetupDataCall(IIILjava/lang/String;I)V

    return-void
.end method

.method public shouldDelayImsTearDown()Z
    .locals 2

    .line 2522
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->isImsDelayTearDownEnabled()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    if-eqz v0, :cond_0

    const/16 v1, 0x21

    .line 2524
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 2525
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 2526
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/CallTracker;->getState()Lcom/android/internal/telephony/PhoneConstants$State;

    move-result-object p0

    sget-object v0, Lcom/android/internal/telephony/PhoneConstants$State;->IDLE:Lcom/android/internal/telephony/PhoneConstants$State;

    if-eq p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public startHandover(ILcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)Z
    .locals 2

    .line 3081
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnecting()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/16 v0, 0xe

    .line 3086
    invoke-virtual {p0, v0, p1, v1, p2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    const/4 p0, 0x1

    return p0

    :cond_1
    :goto_0
    if-eqz p2, :cond_2

    const/4 p0, 0x4

    .line 3083
    invoke-virtual {p2, p0}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    :cond_2
    return v1
.end method

.method public tearDown(I)V
    .locals 1
    .param p1    # I
        .annotation build Lcom/android/internal/telephony/data/DataNetwork$TearDownReason;
        .end annotation
    .end param

    .line 2491
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x7

    .line 2494
    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(II)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public tearDownWhenConditionMet(IJ)Ljava/lang/Runnable;
    .locals 2
    .param p1    # I
        .annotation build Lcom/android/internal/telephony/data/DataNetwork$TearDownReason;
        .end annotation
    .end param

    .line 2554
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnecting()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 2558
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "tearDownWhenConditionMet: reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataNetwork;->tearDownReasonToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", timeout="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2, p3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "ms."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    const/16 v0, 0x15

    long-to-int p2, p2

    .line 2560
    invoke-virtual {p0, v0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->sendMessage(III)V

    .line 2561
    new-instance p2, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda5;

    invoke-direct {p2, p0, p1}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/data/DataNetwork;I)V

    return-object p2

    .line 2555
    :cond_1
    :goto_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo p2, "tearDownWhenConditionMet: Not in the right state. State="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    const/4 p0, 0x0

    return-object p0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    .line 3383
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[DataNetwork: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLogTag:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    .line 3384
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    move-object v1, v2

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3385
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v1

    if-eqz v1, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p0

    invoke-interface {p0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object v2

    :cond_1
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "]"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method protected unhandledMessage(Landroid/os/Message;)V
    .locals 3

    .line 1583
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    .line 1584
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unhandled message "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " in state "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v0, :cond_0

    const-string p1, "null"

    goto :goto_0

    .line 1585
    :cond_0
    invoke-interface {v0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object p1

    :goto_0
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1584
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    return-void
.end method

.method protected updateDataNetwork(Landroid/telephony/data/DataCallResponse;)V
    .locals 11

    .line 2196
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCid:Landroid/util/SparseIntArray;

    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/util/SparseIntArray;->put(II)V

    .line 2197
    new-instance v0, Landroid/net/LinkProperties;

    invoke-direct {v0}, Landroid/net/LinkProperties;-><init>()V

    .line 2200
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/net/LinkProperties;->setInterfaceName(Ljava/lang/String;)V

    .line 2203
    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getPduSessionId()I

    move-result v2

    if-eq v1, v2, :cond_0

    .line 2204
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getPduSessionId()I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    .line 2205
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "PDU session id updated to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPduSessionId:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2209
    :cond_0
    iget v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkStatus:I

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getLinkStatus()I

    move-result v2

    if-eq v1, v2, :cond_1

    .line 2210
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getLinkStatus()I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkStatus:I

    .line 2211
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Link status updated to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkStatus:I

    invoke-static {v2}, Lcom/android/internal/telephony/data/DataUtils;->linkStatusToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2212
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v2, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda9;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda9;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    .line 2217
    :cond_1
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getAddresses()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-lez v1, :cond_3

    .line 2218
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getAddresses()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_2
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/net/LinkAddress;

    .line 2219
    invoke-virtual {v2}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v3

    invoke-virtual {v3}, Ljava/net/InetAddress;->isAnyLocalAddress()Z

    move-result v3

    if-nez v3, :cond_2

    .line 2220
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "addr/pl="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, "/"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Landroid/net/LinkAddress;->getPrefixLength()I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/DataNetwork;->logv(Ljava/lang/String;)V

    .line 2221
    invoke-virtual {v0, v2}, Landroid/net/LinkProperties;->addLinkAddress(Landroid/net/LinkAddress;)Z

    goto :goto_0

    .line 2225
    :cond_3
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "no address for ifname="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    .line 2229
    :cond_4
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getDnsAddresses()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-lez v1, :cond_6

    .line 2230
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getDnsAddresses()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_5
    :goto_1
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_7

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/net/InetAddress;

    .line 2231
    invoke-virtual {v2}, Ljava/net/InetAddress;->isAnyLocalAddress()Z

    move-result v3

    if-nez v3, :cond_5

    .line 2232
    invoke-virtual {v0, v2}, Landroid/net/LinkProperties;->addDnsServer(Ljava/net/InetAddress;)Z

    goto :goto_1

    :cond_6
    const-string v1, "Empty dns response"

    .line 2236
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    .line 2240
    :cond_7
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getPcscfAddresses()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-lez v1, :cond_8

    .line 2241
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getPcscfAddresses()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_2
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_8

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/net/InetAddress;

    .line 2242
    invoke-virtual {v0, v2}, Landroid/net/LinkProperties;->addPcscfServer(Ljava/net/InetAddress;)Z

    goto :goto_2

    .line 2247
    :cond_8
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getMtuV4()I

    move-result v1

    if-lez v1, :cond_9

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getMtuV4()I

    move-result v1

    goto :goto_3

    :cond_9
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getMtu()I

    move-result v1

    :goto_3
    if-gtz v1, :cond_c

    .line 2251
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    const/4 v3, 0x0

    invoke-virtual {p0, v2, v3}, Lcom/android/internal/telephony/data/DataNetwork;->mtkGetCustomizedMtu(Landroid/telephony/data/ApnSetting;I)I

    move-result v2

    if-lez v2, :cond_a

    move v1, v2

    goto :goto_4

    .line 2258
    :cond_a
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    if-eqz v2, :cond_b

    .line 2259
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getMtuV4()I

    move-result v1

    :cond_b
    if-gtz v1, :cond_c

    .line 2262
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getDefaultMtu()I

    move-result v1

    .line 2268
    :cond_c
    :goto_4
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getMtuV6()I

    move-result v2

    if-lez v2, :cond_d

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getMtuV6()I

    move-result v2

    goto :goto_5

    :cond_d
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getMtu()I

    move-result v2

    :goto_5
    if-gtz v2, :cond_10

    .line 2271
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v3}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v3

    const/4 v4, 0x1

    invoke-virtual {p0, v3, v4}, Lcom/android/internal/telephony/data/DataNetwork;->mtkGetCustomizedMtu(Landroid/telephony/data/ApnSetting;I)I

    move-result v3

    if-lez v3, :cond_e

    move v2, v3

    goto :goto_6

    .line 2278
    :cond_e
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v3}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v3

    if-eqz v3, :cond_f

    .line 2279
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getMtuV6()I

    move-result v2

    :cond_f
    if-gtz v2, :cond_10

    .line 2282
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataConfigManager;->getDefaultMtu()I

    move-result v2

    .line 2288
    :cond_10
    :goto_6
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getGatewayAddresses()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_7
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_12

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    move-object v7, v4

    check-cast v7, Ljava/net/InetAddress;

    .line 2289
    instance-of v4, v7, Ljava/net/Inet6Address;

    if-eqz v4, :cond_11

    move v10, v2

    goto :goto_8

    :cond_11
    move v10, v1

    .line 2290
    :goto_8
    new-instance v4, Landroid/net/RouteInfo;

    const/4 v6, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x1

    move-object v5, v4

    invoke-direct/range {v5 .. v10}, Landroid/net/RouteInfo;-><init>(Landroid/net/IpPrefix;Ljava/net/InetAddress;Ljava/lang/String;II)V

    invoke-virtual {v0, v4}, Landroid/net/LinkProperties;->addRoute(Landroid/net/RouteInfo;)Z

    goto :goto_7

    .line 2297
    :cond_12
    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/net/LinkProperties;->setMtu(I)V

    .line 2299
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    if-eqz v1, :cond_14

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 2300
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getProxyAddressAsString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_14

    .line 2301
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getProxyPort()I

    move-result v1

    const/4 v2, -0x1

    if-ne v1, v2, :cond_13

    const/16 v1, 0x1f90

    .line 2305
    :cond_13
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    .line 2306
    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getProxyAddressAsString()Ljava/lang/String;

    move-result-object v2

    .line 2305
    invoke-static {v2, v1}, Landroid/net/ProxyInfo;->buildDirectProxy(Ljava/lang/String;I)Landroid/net/ProxyInfo;

    move-result-object v1

    .line 2307
    invoke-virtual {v0, v1}, Landroid/net/LinkProperties;->setHttpProxy(Landroid/net/ProxyInfo;)V

    .line 2310
    :cond_14
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTcpBufferSizes:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/net/LinkProperties;->setTcpBufferSizes(Ljava/lang/String;)V

    .line 2312
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getSliceInfo()Landroid/telephony/data/NetworkSliceInfo;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkSliceInfo:Landroid/telephony/data/NetworkSliceInfo;

    .line 2314
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTrafficDescriptors:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->clear()V

    .line 2315
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTrafficDescriptors:Ljava/util/List;

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getTrafficDescriptors()Ljava/util/List;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 2317
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mQosBearerSessions:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->clear()V

    .line 2318
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mQosBearerSessions:Ljava/util/List;

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getQosBearerSessions()Ljava/util/List;

    move-result-object p1

    invoke-interface {v1, p1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 2319
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mQosCallbackTracker:Lcom/android/internal/telephony/data/QosCallbackTracker;

    if-eqz p1, :cond_15

    .line 2320
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mQosBearerSessions:Ljava/util/List;

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/data/QosCallbackTracker;->updateSessions(Ljava/util/List;)V

    .line 2323
    :cond_15
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {v0, p1}, Landroid/net/LinkProperties;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_18

    .line 2326
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result p1

    if-nez p1, :cond_16

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isHandoverInProgress()Z

    move-result p1

    if-eqz p1, :cond_17

    :cond_16
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    .line 2327
    invoke-direct {p0, v0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->isLinkPropertiesCompatible(Landroid/net/LinkProperties;Landroid/net/LinkProperties;)Z

    move-result p1

    if-nez p1, :cond_17

    .line 2328
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateDataNetwork: Incompatible link properties detected. Re-create the network agent. Changed from "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " to "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 2332
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    .line 2335
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->abandon()V

    .line 2338
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    .line 2339
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->createNetworkAgent()Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    .line 2340
    invoke-virtual {p1}, Landroid/net/NetworkAgent;->markConnected()V

    goto :goto_9

    .line 2342
    :cond_17
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    .line 2343
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "sendLinkProperties "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2344
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p1, v0}, Landroid/net/NetworkAgent;->sendLinkProperties(Landroid/net/LinkProperties;)V

    .line 2348
    :cond_18
    :goto_9
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkCapabilities()V

    return-void
.end method

.method protected updateNetworkCapabilities()V
    .locals 9

    .line 1806
    new-instance v0, Landroid/net/NetworkCapabilities$Builder;

    invoke-direct {v0}, Landroid/net/NetworkCapabilities$Builder;-><init>()V

    const/4 v1, 0x0

    .line 1807
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addTransportType(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object v0

    .line 1808
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v1

    .line 1810
    new-instance v2, Landroid/net/TelephonyNetworkSpecifier$Builder;

    invoke-direct {v2}, Landroid/net/TelephonyNetworkSpecifier$Builder;-><init>()V

    iget v3, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSubId:I

    .line 1811
    invoke-virtual {v2, v3}, Landroid/net/TelephonyNetworkSpecifier$Builder;->setSubscriptionId(I)Landroid/net/TelephonyNetworkSpecifier$Builder;

    move-result-object v2

    invoke-virtual {v2}, Landroid/net/TelephonyNetworkSpecifier$Builder;->build()Landroid/net/TelephonyNetworkSpecifier;

    move-result-object v2

    .line 1810
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->setNetworkSpecifier(Landroid/net/NetworkSpecifier;)Landroid/net/NetworkCapabilities$Builder;

    .line 1812
    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSubId:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-static {v2}, Ljava/util/Collections;->singleton(Ljava/lang/Object;)Ljava/util/Set;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->setSubscriptionIds(Ljava/util/Set;)Landroid/net/NetworkCapabilities$Builder;

    .line 1814
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    const/16 v3, 0xc

    if-eqz v2, :cond_0

    .line 1817
    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getApnTypes()Ljava/util/List;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v4

    new-instance v5, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda14;

    invoke-direct {v5}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda14;-><init>()V

    .line 1818
    invoke-interface {v4, v5}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v4

    new-instance v5, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda10;

    invoke-direct {v5}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda10;-><init>()V

    .line 1819
    invoke-interface {v4, v5}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v4

    .line 1820
    new-instance v5, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda11;

    invoke-direct {v5, v0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda11;-><init>(Landroid/net/NetworkCapabilities$Builder;)V

    invoke-interface {v4, v5}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 1821
    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getApnTypes()Ljava/util/List;

    move-result-object v2

    const/16 v4, 0x4000

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-interface {v2, v4}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 1822
    invoke-virtual {v0, v3}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1829
    :cond_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/4 v4, 0x1

    const/16 v5, 0x21

    if-eqz v2, :cond_1

    .line 1830
    invoke-virtual {v2, v5}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 1832
    invoke-virtual {v0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_0

    .line 1836
    :cond_1
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataProfile:Landroid/telephony/data/DataProfile;

    const/4 v6, 0x4

    invoke-virtual {v2, v6}, Landroid/telephony/data/DataProfile;->canSatisfy(I)Z

    move-result v2

    if-eqz v2, :cond_3

    .line 1837
    invoke-virtual {v0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1838
    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    if-ne v2, v4, :cond_3

    .line 1839
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkRegistrationInfo()Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v2

    if-eqz v2, :cond_3

    .line 1841
    invoke-virtual {v2}, Landroid/telephony/NetworkRegistrationInfo;->getDataSpecificInfo()Landroid/telephony/DataSpecificRegistrationInfo;

    move-result-object v2

    if-eqz v2, :cond_2

    .line 1843
    invoke-virtual {v2}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object v6

    if-eqz v6, :cond_2

    .line 1844
    invoke-virtual {v2}, Landroid/telephony/DataSpecificRegistrationInfo;->getVopsSupportInfo()Landroid/telephony/VopsSupportInfo;

    move-result-object v6

    invoke-virtual {v6}, Landroid/telephony/VopsSupportInfo;->isVopsSupported()Z

    move-result v6

    if-nez v6, :cond_2

    .line 1845
    invoke-virtual {v0, v5}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1847
    :cond_2
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v6, "updateNetworkCapabilities: dsri="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 1854
    :cond_3
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTrafficDescriptors:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_1
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_8

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/telephony/data/TrafficDescriptor;

    .line 1856
    :try_start_0
    invoke-virtual {v5}, Landroid/telephony/data/TrafficDescriptor;->getOsAppId()[B

    move-result-object v6

    if-nez v6, :cond_4

    goto :goto_1

    .line 1857
    :cond_4
    new-instance v6, Landroid/telephony/data/TrafficDescriptor$OsAppId;

    invoke-virtual {v5}, Landroid/telephony/data/TrafficDescriptor;->getOsAppId()[B

    move-result-object v7

    invoke-direct {v6, v7}, Landroid/telephony/data/TrafficDescriptor$OsAppId;-><init>([B)V

    .line 1858
    invoke-virtual {v6}, Landroid/telephony/data/TrafficDescriptor$OsAppId;->getOsId()Ljava/util/UUID;

    move-result-object v7

    sget-object v8, Landroid/telephony/data/TrafficDescriptor$OsAppId;->ANDROID_OS_ID:Ljava/util/UUID;

    invoke-virtual {v7, v8}, Ljava/util/UUID;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_5

    .line 1859
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Received non-Android OS id "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Landroid/telephony/data/TrafficDescriptor$OsAppId;->getOsId()Ljava/util/UUID;

    move-result-object v6

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    goto :goto_1

    .line 1863
    :cond_5
    invoke-virtual {v6}, Landroid/telephony/data/TrafficDescriptor$OsAppId;->getAppId()Ljava/lang/String;

    move-result-object v7

    .line 1862
    invoke-static {v7}, Lcom/android/internal/telephony/data/DataUtils;->getNetworkCapabilityFromString(Ljava/lang/String;)I

    move-result v7

    const/4 v8, 0x5

    if-eq v7, v8, :cond_7

    const/16 v8, 0x1d

    if-eq v7, v8, :cond_6

    const/16 v8, 0x22

    if-eq v7, v8, :cond_7

    const/16 v8, 0x23

    if-eq v7, v8, :cond_7

    .line 1877
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Invalid app id "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Landroid/telephony/data/TrafficDescriptor$OsAppId;->getAppId()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    goto :goto_1

    .line 1866
    :cond_6
    invoke-virtual {v0, v7}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1868
    invoke-virtual {v0, v3}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1869
    invoke-virtual {v6}, Landroid/telephony/data/TrafficDescriptor$OsAppId;->getDifferentiator()I

    move-result v6

    invoke-virtual {v0, v6}, Landroid/net/NetworkCapabilities$Builder;->addEnterpriseId(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    .line 1874
    :cond_7
    invoke-virtual {v0, v7}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto/16 :goto_1

    :catch_0
    move-exception v6

    .line 1880
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "Exception: "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v6, ". Failed to create osAppId from "

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance v6, Ljava/math/BigInteger;

    .line 1881
    invoke-virtual {v5}, Landroid/telephony/data/TrafficDescriptor;->getOsAppId()[B

    move-result-object v5

    invoke-direct {v6, v4, v5}, Ljava/math/BigInteger;-><init>(I[B)V

    const/16 v5, 0x10

    invoke-virtual {v6, v5}, Ljava/math/BigInteger;->toString(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 1880
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/data/DataNetwork;->loge(Ljava/lang/String;)V

    goto/16 :goto_1

    .line 1885
    :cond_8
    iget-boolean v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCongested:Z

    if-nez v2, :cond_9

    const/16 v2, 0x14

    .line 1886
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1889
    :cond_9
    iget-boolean v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMeteredSupported:Z

    if-eqz v2, :cond_a

    iget-boolean v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTempNotMetered:Z

    if-eqz v2, :cond_a

    const/16 v2, 0x19

    .line 1890
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    :cond_a
    const/16 v2, 0x1c

    .line 1895
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1896
    invoke-virtual {v0}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/android/internal/telephony/data/DataNetwork;->getVcnPolicy(Landroid/net/NetworkCapabilities;)Landroid/net/vcn/VcnNetworkPolicyResult;

    move-result-object v3

    if-eqz v3, :cond_b

    .line 1897
    invoke-virtual {v3}, Landroid/net/vcn/VcnNetworkPolicyResult;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v5

    .line 1898
    invoke-virtual {v5, v2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v5

    if-nez v5, :cond_b

    .line 1899
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    :cond_b
    if-nez v1, :cond_c

    const/16 v2, 0x12

    .line 1903
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1906
    :cond_c
    iget-boolean v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSuspended:Z

    if-nez v2, :cond_d

    const/16 v2, 0x15

    .line 1907
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1910
    :cond_d
    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCarrierServicePackageUid:I

    const/4 v5, -0x1

    if-eq v2, v5, :cond_e

    iget-object v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAdministratorUids:[I

    .line 1911
    invoke-static {v5, v2}, Lcom/android/internal/util/ArrayUtils;->contains([II)Z

    move-result v2

    if-eqz v2, :cond_e

    .line 1912
    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCarrierServicePackageUid:I

    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->setOwnerUid(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1913
    iget v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mCarrierServicePackageUid:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-static {v2}, Ljava/util/Collections;->singleton(Ljava/lang/Object;)Ljava/util/Set;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->setAllowedUids(Ljava/util/Set;)Landroid/net/NetworkCapabilities$Builder;

    .line 1915
    :cond_e
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mAdministratorUids:[I

    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->setAdministratorUids([I)Landroid/net/NetworkCapabilities$Builder;

    .line 1917
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 1918
    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getMeteredNetworkCapabilities(Z)Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda12;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda12;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 1919
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v1

    .line 1921
    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Set;

    .line 1922
    invoke-interface {v1}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v2

    .line 1923
    invoke-virtual {v0}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object v5

    invoke-virtual {v5}, Landroid/net/NetworkCapabilities;->getCapabilities()[I

    move-result-object v5

    invoke-static {v5}, Ljava/util/Arrays;->stream([I)Ljava/util/stream/IntStream;

    move-result-object v5

    invoke-interface {v5}, Ljava/util/stream/IntStream;->boxed()Ljava/util/stream/Stream;

    move-result-object v5

    .line 1924
    invoke-static {}, Ljava/util/stream/Collectors;->toSet()Ljava/util/stream/Collector;

    move-result-object v6

    invoke-interface {v5, v6}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/util/Set;

    invoke-static {v5}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v6, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda13;

    invoke-direct {v6, v5}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda13;-><init>(Ljava/util/Set;)V

    .line 1922
    invoke-interface {v2, v6}, Ljava/util/stream/Stream;->noneMatch(Ljava/util/function/Predicate;)Z

    move-result v2

    if-eqz v2, :cond_f

    const/16 v2, 0xb

    .line 1927
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    :cond_f
    const/16 v2, 0xd

    .line 1931
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1935
    iget-object v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    invoke-virtual {v5}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v5

    invoke-virtual {v5}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataEnabled()Z

    move-result v5

    if-eqz v5, :cond_10

    iget-object v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1936
    invoke-interface {v5}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v5

    invoke-virtual {v5}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v5

    if-eqz v5, :cond_16

    iget-object v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    .line 1937
    invoke-virtual {v5}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataSettingsManager()Lcom/android/internal/telephony/data/DataSettingsManager;

    move-result-object v5

    invoke-virtual {v5}, Lcom/android/internal/telephony/data/DataSettingsManager;->isDataRoamingEnabled()Z

    move-result v5

    if-nez v5, :cond_16

    .line 1942
    :cond_10
    iget-object v5, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->RESTRICTED_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    if-ne v5, v6, :cond_11

    .line 1943
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_3

    .line 1944
    :cond_11
    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->UNMETERED_USAGE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    if-eq v5, v6, :cond_12

    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->MMS_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    if-eq v5, v6, :cond_12

    sget-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->EMERGENCY_SUPL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    if-ne v5, v6, :cond_16

    .line 1949
    :cond_12
    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_13
    :goto_2
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_16

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/Integer;

    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I

    move-result v5

    if-nez v5, :cond_14

    .line 1953
    iget-object v6, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    sget-object v7, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->MMS_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    if-eq v6, v7, :cond_13

    :cond_14
    if-ne v5, v4, :cond_15

    iget-object v6, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataAllowedReason:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    sget-object v7, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->EMERGENCY_SUPL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    if-ne v6, v7, :cond_15

    goto :goto_2

    .line 1960
    :cond_15
    invoke-virtual {v0, v5}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_2

    .line 1967
    :cond_16
    :goto_3
    invoke-virtual {v0}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object v1

    invoke-static {v1}, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->inferRestrictedCapability(Landroid/net/NetworkCapabilities;)Z

    move-result v1

    if-nez v1, :cond_17

    if-eqz v3, :cond_18

    .line 1968
    invoke-virtual {v3}, Landroid/net/vcn/VcnNetworkPolicyResult;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v1

    .line 1969
    invoke-virtual {v1, v2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v1

    if-nez v1, :cond_18

    .line 1970
    :cond_17
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1974
    :cond_18
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkBandwidth:Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    iget v1, v1, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;->downlinkBandwidthKbps:I

    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->setLinkDownstreamBandwidthKbps(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1975
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkBandwidth:Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;

    iget v1, v1, Lcom/android/internal/telephony/data/DataNetwork$NetworkBandwidth;->uplinkBandwidthKbps:I

    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->setLinkUpstreamBandwidthKbps(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1978
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->mtkUpdateNetworkCapabilities(Landroid/net/NetworkCapabilities$Builder;)V

    .line 1981
    invoke-virtual {v0}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object v0

    .line 1982
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    if-eqz v1, :cond_1d

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    if-nez v2, :cond_19

    goto/16 :goto_6

    .line 1991
    :cond_19
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1c

    .line 1996
    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mEverConnected:Z

    if-eqz v1, :cond_1b

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-static {v1, v0}, Lcom/android/internal/telephony/data/DataNetwork;->areImmutableCapabilitiesChanged(Landroid/net/NetworkCapabilities;Landroid/net/NetworkCapabilities;)Z

    move-result v1

    if-eqz v1, :cond_1b

    .line 1997
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnected()Z

    move-result v1

    if-nez v1, :cond_1a

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isHandoverInProgress()Z

    move-result v1

    if-eqz v1, :cond_1b

    .line 2001
    :cond_1a
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "updateNetworkCapabilities: Immutable capabilities changed. Re-create the network agent. Attempted to change from "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 2005
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->abandon()V

    .line 2008
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    .line 2009
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->createNetworkAgent()Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    .line 2010
    invoke-virtual {v0}, Landroid/net/NetworkAgent;->markConnected()V

    goto :goto_4

    .line 2014
    :cond_1b
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    .line 2015
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Capabilities changed to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    .line 2016
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {v0, v1}, Landroid/net/NetworkAgent;->sendNetworkCapabilities(Landroid/net/NetworkCapabilities;)V

    .line 2019
    :goto_4
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->removeUnsatisfiedNetworkRequests()V

    .line 2020
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda14;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda14;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    goto :goto_5

    :cond_1c
    const-string/jumbo v0, "updateNetworkCapabilities: Capabilities not changed."

    .line 2023
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->log(Ljava/lang/String;)V

    :goto_5
    return-void

    .line 1986
    :cond_1d
    :goto_6
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    .line 1987
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Initial capabilities "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    return-void
.end method

.method protected updateSuspendState()V
    .locals 4

    .line 2052
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isConnecting()Z

    move-result v0

    if-nez v0, :cond_7

    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->isDisconnected()Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_3

    .line 2059
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkRegistrationInfo()Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v0

    if-nez v0, :cond_1

    return-void

    .line 2064
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkCapabilities:Landroid/net/NetworkCapabilities;

    const/16 v2, 0xa

    invoke-virtual {v1, v2}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-eqz v1, :cond_2

    goto :goto_1

    .line 2067
    :cond_2
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v1

    if-eq v1, v3, :cond_3

    .line 2069
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v0

    const/4 v1, 0x5

    if-eq v0, v1, :cond_3

    :goto_0
    move v2, v3

    goto :goto_1

    .line 2073
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isConcurrentVoiceAndDataAllowed()Z

    move-result v0

    if-nez v0, :cond_4

    iget v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mTransport:I

    if-ne v0, v3, :cond_4

    .line 2075
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/CallTracker;->getState()Lcom/android/internal/telephony/PhoneConstants$State;

    move-result-object v0

    sget-object v1, Lcom/android/internal/telephony/PhoneConstants$State;->IDLE:Lcom/android/internal/telephony/PhoneConstants$State;

    if-eq v0, v1, :cond_4

    goto :goto_0

    .line 2079
    :cond_4
    :goto_1
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSuspended:Z

    if-eq v0, v2, :cond_7

    .line 2080
    iput-boolean v2, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSuspended:Z

    .line 2081
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Network becomes "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSuspended:Z

    if-eqz v1, :cond_5

    const-string/jumbo v1, "suspended"

    goto :goto_2

    :cond_5
    const-string/jumbo v1, "unsuspended"

    :goto_2
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->logl(Ljava/lang/String;)V

    .line 2083
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->updateNetworkCapabilities()V

    .line 2093
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mSuspended:Z

    if-nez v0, :cond_6

    .line 2094
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mNetworkAgent:Lcom/android/internal/telephony/data/TelephonyNetworkAgent;

    invoke-virtual {v0}, Landroid/net/NetworkAgent;->markConnected()V

    .line 2096
    :cond_6
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataNetwork;->notifyPreciseDataConnectionState()V

    .line 2097
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataNetwork;->mDataNetworkCallback:Lcom/android/internal/telephony/data/DataNetwork$DataNetworkCallback;

    new-instance v1, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda17;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataNetwork$$ExternalSyntheticLambda17;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    :cond_7
    :goto_3
    return-void
.end method
