.class public Lcom/android/internal/telephony/dataconnection/DataConnection;
.super Lcom/android/internal/telephony/StateMachine;
.source "DataConnection.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;,
        Lcom/android/internal/telephony/dataconnection/DataConnection$HandoverState;
    }
.end annotation


# static fields
.field static final BASE:I = 0x40000

.field private static final CMD_TO_STRING_COUNT:I = 0x28

.field private static final DBG:Z = true

.field private static final DEFAULT_INTERNET_CONNECTION_SCORE:I = 0x32

.field static final EVENT_ALLOCATE_PDU_SESSION_ID:I = 0x40025

.field static final EVENT_BW_REFRESH_RESPONSE:I = 0x4000e

.field static final EVENT_CANCEL_HANDOVER:I = 0x40023

.field static final EVENT_CARRIER_CONFIG_LINK_BANDWIDTHS_CHANGED:I = 0x4001e

.field static final EVENT_CARRIER_PRIVILEGED_UIDS_CHANGED:I = 0x4001f

.field static final EVENT_CONNECT:I = 0x40000

.field static final EVENT_CSS_INDICATOR_CHANGED:I = 0x40020

.field static final EVENT_DATA_CONNECTION_CONGESTEDNESS_CHANGED:I = 0x40011

.field static final EVENT_DATA_CONNECTION_DRS_OR_RAT_CHANGED:I = 0x4000b

.field static final EVENT_DATA_CONNECTION_METEREDNESS_CHANGED:I = 0x4001c

.field static final EVENT_DATA_CONNECTION_ROAM_OFF:I = 0x4000d

.field static final EVENT_DATA_CONNECTION_ROAM_ON:I = 0x4000c

.field static final EVENT_DATA_CONNECTION_VOICE_CALL_ENDED:I = 0x40010

.field static final EVENT_DATA_CONNECTION_VOICE_CALL_STARTED:I = 0x4000f

.field static final EVENT_DATA_STATE_CHANGED:I = 0x40007

.field static final EVENT_DEACTIVATE_DONE:I = 0x40003

.field static final EVENT_DISCONNECT:I = 0x40004

.field static final EVENT_DISCONNECT_ALL:I = 0x40006

.field static final EVENT_KEEPALIVE_STARTED:I = 0x40013

.field static final EVENT_KEEPALIVE_START_REQUEST:I = 0x40015

.field static final EVENT_KEEPALIVE_STATUS:I = 0x40012

.field static final EVENT_KEEPALIVE_STOPPED:I = 0x40014

.field static final EVENT_KEEPALIVE_STOP_REQUEST:I = 0x40016

.field static final EVENT_LINK_BANDWIDTH_ESTIMATOR_UPDATE:I = 0x40027

.field static final EVENT_LINK_CAPACITY_CHANGED:I = 0x40017

.field static final EVENT_LOST_CONNECTION:I = 0x40009

.field static final EVENT_NR_FREQUENCY_CHANGED:I = 0x4001d

.field static final EVENT_NR_STATE_CHANGED:I = 0x4001b

.field static final EVENT_REEVALUATE_DATA_CONNECTION_PROPERTIES:I = 0x4001a

.field static final EVENT_REEVALUATE_RESTRICTED_STATE:I = 0x40019

.field static final EVENT_RELEASE_PDU_SESSION_ID:I = 0x40026

.field static final EVENT_RESET:I = 0x40018

.field static final EVENT_SETUP_DATA_CONNECTION_DONE:I = 0x40001

.field static final EVENT_START_HANDOVER:I = 0x40022

.field static final EVENT_START_HANDOVER_ON_TARGET:I = 0x40024

.field static final EVENT_TEAR_DOWN_NOW:I = 0x40008

.field static final EVENT_UPDATE_SUSPENDED_STATE:I = 0x40021

.field private static final HANDOVER_STATE_BEING_TRANSFERRED:I = 0x2

.field private static final HANDOVER_STATE_COMPLETED:I = 0x3

.field private static final HANDOVER_STATE_IDLE:I = 0x1

.field private static final NETWORK_TYPE:Ljava/lang/String; = "MOBILE"

.field private static final NULL_IP:Ljava/lang/String; = "0.0.0.0"

.field private static final OS_ID:Ljava/util/UUID;

.field private static final OTHER_CONNECTION_SCORE:I = 0x2d

.field private static final RAT_NAME_5G:Ljava/lang/String; = "nr"

.field private static final RAT_NAME_EVDO:Ljava/lang/String; = "evdo"

.field private static final TCP_BUFFER_SIZES_1XRTT:Ljava/lang/String; = "16384,32768,131072,4096,16384,102400"

.field private static final TCP_BUFFER_SIZES_EDGE:Ljava/lang/String; = "4093,26280,70800,4096,16384,70800"

.field private static final TCP_BUFFER_SIZES_EHRPD:Ljava/lang/String; = "131072,262144,1048576,4096,16384,524288"

.field private static final TCP_BUFFER_SIZES_EVDO:Ljava/lang/String; = "4094,87380,262144,4096,16384,262144"

.field private static final TCP_BUFFER_SIZES_GPRS:Ljava/lang/String; = "4092,8760,48000,4096,8760,48000"

.field private static final TCP_BUFFER_SIZES_HSDPA:Ljava/lang/String; = "61167,367002,1101005,8738,52429,262114"

.field private static final TCP_BUFFER_SIZES_HSPA:Ljava/lang/String; = "40778,244668,734003,16777,100663,301990"

.field private static final TCP_BUFFER_SIZES_HSPAP:Ljava/lang/String; = "122334,734003,2202010,32040,192239,576717"

.field private static final TCP_BUFFER_SIZES_LTE:Ljava/lang/String; = "524288,1048576,2097152,262144,524288,1048576"

.field private static final TCP_BUFFER_SIZES_LTE_CA:Ljava/lang/String; = "4096,6291456,12582912,4096,1048576,2097152"

.field private static final TCP_BUFFER_SIZES_NR:Ljava/lang/String; = "2097152,6291456,16777216,512000,2097152,8388608"

.field private static final TCP_BUFFER_SIZES_UMTS:Ljava/lang/String; = "58254,349525,1048576,58254,349525,1048576"

.field private static final VDBG:Z = true

.field private static mInstanceNumber:Ljava/util/concurrent/atomic/AtomicInteger;

.field private static sCmdToString:[Ljava/lang/String;


# instance fields
.field private mAc:Lcom/android/internal/telephony/AsyncChannel;

.field private mActivatingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;

.field private mActiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;

.field private mAdministratorUids:[I

.field private final mApnContexts:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/android/internal/telephony/dataconnection/ApnContext;",
            "Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;",
            ">;"
        }
    .end annotation
.end field

.field private volatile mApnSetting:Landroid/telephony/data/ApnSetting;

.field public mCid:I

.field private mCongestedOverride:Z

.field private mConnectionParams:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

.field private mCreateTime:J

.field private mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

.field private mDataRegState:I

.field private mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

.field private mDcController:Lcom/android/internal/telephony/dataconnection/DcController;

.field private mDcFailCause:I

.field private mDcTesterFailBringUpAll:Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;

.field private mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

.field private mDefaultQos:Landroid/telephony/data/Qos;

.field private mDefaultState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;

.field private mDisabledApnTypeBitMask:I

.field private mDisconnectParams:Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

.field private mDisconnectingErrorCreatingConnection:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection;

.field private mDisconnectingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState;

.field private mDoAllocatePduSessionId:Z

.field private mDownlinkBandwidth:I

.field private mEnterpriseUse:Z

.field private mHandoverFailureMode:I

.field private final mHandoverLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private mHandoverSourceNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

.field private mHandoverState:I

.field private mId:I

.field private mInactiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

.field private mIsSuspended:Z

.field private mLastFailCause:I

.field private mLastFailTime:J

.field private mLinkProperties:Landroid/net/LinkProperties;

.field private mMmsUseOnly:Z

.field private mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

.field private mPcscfAddr:[Ljava/lang/String;

.field private mPduSessionId:I

.field private mPhone:Lcom/android/internal/telephony/Phone;

.field private mQosBearerSessions:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/data/QosBearerSession;",
            ">;"
        }
    .end annotation
.end field

.field mReconnectIntent:Landroid/app/PendingIntent;

.field private mRestrictedNetworkOverride:Z

.field private mRilRat:I

.field private mScore:I

.field private mSliceInfo:Landroid/telephony/data/NetworkSliceInfo;

.field private mSubId:I

.field mTag:I

.field private final mTagSuffix:Ljava/lang/String;

.field private mTrafficDescriptors:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/data/TrafficDescriptor;",
            ">;"
        }
    .end annotation
.end field

.field private final mTransportType:I

.field private mUnmeteredOverride:Z

.field private mUnmeteredUseOnly:Z

.field private mUplinkBandwidth:I

.field private mUserData:Ljava/lang/Object;

.field private mVcnManager:Landroid/net/vcn/VcnManager;

.field private final mVcnPolicyChangeListener:Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;


# direct methods
.method public static synthetic $r8$lambda$1-zC7pfdvj8isv8ULGxkeJ57JTE(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/Integer;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZLjava/lang/Boolean;)V
    .locals 0

    invoke-direct/range {p0 .. p8}, Lcom/android/internal/telephony/dataconnection/DataConnection;->lambda$connect$0(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/Integer;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZLjava/lang/Boolean;)V

    return-void
.end method

.method public static synthetic $r8$lambda$3g1_bCu9bywlFbKdScLSm5b7LbY(Lcom/android/internal/telephony/dataconnection/DataConnection;ILjava/lang/Object;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->lambda$tearDownData$4(ILjava/lang/Object;)V

    return-void
.end method

.method public static synthetic $r8$lambda$EbEXXHBgI-Cwu0lUHcza-KwHsxY(ILjava/lang/Integer;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->lambda$isApnContextAttached$7(ILjava/lang/Integer;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$ODGbChdoA1p7OhOvni9mUqsyAhw(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/util/function/Consumer;Ljava/lang/Integer;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->lambda$startHandover$3(Ljava/util/function/Consumer;Ljava/lang/Integer;)V

    return-void
.end method

.method public static synthetic $r8$lambda$YO_ItBsE-dPsALCoqPpNZon0trA(Lcom/android/internal/telephony/dataconnection/ApnContext;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->lambda$isEnterpriseUse$5(Lcom/android/internal/telephony/dataconnection/ApnContext;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$qITDD4hwFbvsYVyNPebDti6rzFc(I)[Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->lambda$updatePcscfAddr$6(I)[Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$quIEEkXq3nKw7436rzTKMlYzteM(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;Landroid/telephony/data/TrafficDescriptor;ZLandroid/os/Message;Ljava/lang/Integer;)V
    .locals 0

    invoke-direct/range {p0 .. p10}, Lcom/android/internal/telephony/dataconnection/DataConnection;->lambda$connect$2(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;Landroid/telephony/data/TrafficDescriptor;ZLandroid/os/Message;Ljava/lang/Integer;)V

    return-void
.end method

.method public static synthetic $r8$lambda$yAGNOUh2zeSZIKWVG_6SJC1K00A(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZLjava/lang/Integer;)V
    .locals 0

    invoke-direct/range {p0 .. p7}, Lcom/android/internal/telephony/dataconnection/DataConnection;->lambda$connect$1(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZLjava/lang/Integer;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetmAc(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/AsyncChannel;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mAc:Lcom/android/internal/telephony/AsyncChannel;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmActivatingState(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mActivatingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmActiveState(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mActiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmApnContexts(Lcom/android/internal/telephony/dataconnection/DataConnection;)Ljava/util/Map;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmApnSetting(Lcom/android/internal/telephony/dataconnection/DataConnection;)Landroid/telephony/data/ApnSetting;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmCongestedOverride(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCongestedOverride:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmConnectionParams(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mConnectionParams:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDataCallSessionStats(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/metrics/DataCallSessionStats;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDataRegState(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataRegState:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmDataServiceManager(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataServiceManager;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDcController(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcController;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcController:Lcom/android/internal/telephony/dataconnection/DcController;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcFailCause:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmDct(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcTracker;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDisabledApnTypeBitMask(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisabledApnTypeBitMask:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmDisconnectParams(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectParams:Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDisconnectingErrorCreatingConnection(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectingErrorCreatingConnection:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmDisconnectingState(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmEnterpriseUse(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mEnterpriseUse:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmHandoverFailureMode(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverFailureMode:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmHandoverLocalLog(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/LocalLog;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverLocalLog:Lcom/android/internal/telephony/LocalLog;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmHandoverSourceNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverSourceNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmHandoverState(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmId(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmInactiveState(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mInactiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLinkProperties(Lcom/android/internal/telephony/dataconnection/DataConnection;)Landroid/net/LinkProperties;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmMmsUseOnly(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mMmsUseOnly:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;)Lcom/android/internal/telephony/Phone;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmRestrictedNetworkOverride(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRestrictedNetworkOverride:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmRilRat(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRilRat:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmScore(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mScore:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmSubId(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSubId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmTransportType(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmUnmeteredOverride(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredOverride:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmUnmeteredUseOnly(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredUseOnly:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmVcnManager(Lcom/android/internal/telephony/dataconnection/DataConnection;)Landroid/net/vcn/VcnManager;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mVcnManager:Landroid/net/vcn/VcnManager;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmVcnPolicyChangeListener(Lcom/android/internal/telephony/dataconnection/DataConnection;)Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mVcnPolicyChangeListener:Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmAc(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/AsyncChannel;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mAc:Lcom/android/internal/telephony/AsyncChannel;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmAdministratorUids(Lcom/android/internal/telephony/dataconnection/DataConnection;[I)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mAdministratorUids:[I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmApnSetting(Lcom/android/internal/telephony/dataconnection/DataConnection;Landroid/telephony/data/ApnSetting;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmCongestedOverride(Lcom/android/internal/telephony/dataconnection/DataConnection;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCongestedOverride:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmConnectionParams(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mConnectionParams:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmDataRegState(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataRegState:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmDataServiceManager(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataServiceManager;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmDcController(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DcController;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcController:Lcom/android/internal/telephony/dataconnection/DcController;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmDcFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcFailCause:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmDcTesterFailBringUpAll(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcTesterFailBringUpAll:Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmDct(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DcTracker;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmDisabledApnTypeBitMask(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisabledApnTypeBitMask:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmDisconnectParams(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectParams:Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmEnterpriseUse(Lcom/android/internal/telephony/dataconnection/DataConnection;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mEnterpriseUse:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmHandoverFailureMode(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverFailureMode:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmHandoverSourceNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverSourceNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmLastFailCause(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailCause:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmLinkProperties(Lcom/android/internal/telephony/dataconnection/DataConnection;Landroid/net/LinkProperties;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmMmsUseOnly(Lcom/android/internal/telephony/dataconnection/DataConnection;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mMmsUseOnly:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmPhone(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/Phone;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmRestrictedNetworkOverride(Lcom/android/internal/telephony/dataconnection/DataConnection;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRestrictedNetworkOverride:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmRilRat(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRilRat:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmScore(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mScore:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmSubId(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSubId:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmUnmeteredOverride(Lcom/android/internal/telephony/dataconnection/DataConnection;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredOverride:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmUnmeteredUseOnly(Lcom/android/internal/telephony/dataconnection/DataConnection;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredUseOnly:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmUserData(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/Object;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUserData:Ljava/lang/Object;

    return-void
.end method

.method static bridge synthetic -$$Nest$mcalculateScore(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->calculateScore()I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mcanHandleDefault(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->canHandleDefault()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mcancelHandover(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->cancelHandover()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mclearSettings(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->clearSettings()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mconnect(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)I
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->connect(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mgetApnTypeBitmask(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getApnTypeBitmask()I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mgetDisallowedApnTypes(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getDisallowedApnTypes()I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mgetHandoverSourceTransport(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getHandoverSourceTransport()I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mgetNetworkType(Lcom/android/internal/telephony/dataconnection/DataConnection;)I
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkType()I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mgetSuggestedRetryDelay(Lcom/android/internal/telephony/dataconnection/DataConnection;Landroid/telephony/data/DataCallResponse;)J
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getSuggestedRetryDelay(Landroid/telephony/data/DataCallResponse;)J

    move-result-wide p0

    return-wide p0
.end method

.method static bridge synthetic -$$Nest$minitConnection(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->initConnection(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misBandwidthSourceKey(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isBandwidthSourceKey(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misEnterpriseUse(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isEnterpriseUse()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misMmsUseOnly(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isMmsUseOnly()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misUnmeteredUseOnly(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isUnmeteredUseOnly()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mnotifyAllWithEvent(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/ApnContext;ILjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->notifyAllWithEvent(Lcom/android/internal/telephony/dataconnection/ApnContext;ILjava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mnotifyConnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;IIZ)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/dataconnection/DataConnection;->notifyConnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;IIZ)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mnotifyDataConnectionState(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->notifyDataConnectionState()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mnotifyDisconnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;Z)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->notifyDisconnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;Z)V

    return-void
.end method

.method static bridge synthetic -$$Nest$monSetupConnectionCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection;ILandroid/telephony/data/DataCallResponse;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->onSetupConnectionCompleted(ILandroid/telephony/data/DataCallResponse;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mshouldRestrictNetwork(Lcom/android/internal/telephony/dataconnection/DataConnection;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->shouldRestrictNetwork()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$msyncQosToNetworkAgent(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->syncQosToNetworkAgent()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtearDownData(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/Object;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->tearDownData(Ljava/lang/Object;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateLinkBandwidthsFromBandwidthEstimator(Lcom/android/internal/telephony/dataconnection/DataConnection;II)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateLinkBandwidthsFromBandwidthEstimator(II)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateLinkBandwidthsFromCarrierConfig(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateLinkBandwidthsFromCarrierConfig(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateLinkBandwidthsFromModem(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/util/List;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateLinkBandwidthsFromModem(Ljava/util/List;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateLinkPropertiesHttpProxy(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateLinkPropertiesHttpProxy()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateScore(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateScore()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateSuspendState(Lcom/android/internal/telephony/dataconnection/DataConnection;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateSuspendState()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateTcpBufferSizes(Lcom/android/internal/telephony/dataconnection/DataConnection;I)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateTcpBufferSizes(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$smmsgToString(Landroid/os/Message;)Ljava/lang/String;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->msgToString(Landroid/os/Message;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 3

    const-string v0, "97a498e3-fc92-5c94-8986-0333d06e4e47"

    .line 159
    invoke-static {v0}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->OS_ID:Ljava/util/UUID;

    .line 212
    new-instance v0, Ljava/util/concurrent/atomic/AtomicInteger;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicInteger;-><init>(I)V

    sput-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mInstanceNumber:Ljava/util/concurrent/atomic/AtomicInteger;

    const/16 v0, 0x28

    new-array v0, v0, [Ljava/lang/String;

    .line 402
    sput-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->sCmdToString:[Ljava/lang/String;

    const-string v2, "EVENT_CONNECT"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "EVENT_SETUP_DATA_CONNECTION_DONE"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "EVENT_DEACTIVATE_DONE"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "EVENT_DISCONNECT"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "EVENT_DISCONNECT_ALL"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "EVENT_DATA_STATE_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "EVENT_TEAR_DOWN_NOW"

    aput-object v2, v0, v1

    const/16 v1, 0x9

    const-string v2, "EVENT_LOST_CONNECTION"

    aput-object v2, v0, v1

    const/16 v1, 0xb

    const-string v2, "EVENT_DATA_CONNECTION_DRS_OR_RAT_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0xc

    const-string v2, "EVENT_DATA_CONNECTION_ROAM_ON"

    aput-object v2, v0, v1

    const/16 v1, 0xd

    const-string v2, "EVENT_DATA_CONNECTION_ROAM_OFF"

    aput-object v2, v0, v1

    const/16 v1, 0xe

    const-string v2, "EVENT_BW_REFRESH_RESPONSE"

    aput-object v2, v0, v1

    const/16 v1, 0xf

    const-string v2, "EVENT_DATA_CONNECTION_VOICE_CALL_STARTED"

    aput-object v2, v0, v1

    const/16 v1, 0x10

    const-string v2, "EVENT_DATA_CONNECTION_VOICE_CALL_ENDED"

    aput-object v2, v0, v1

    const/16 v1, 0x11

    const-string v2, "EVENT_DATA_CONNECTION_CONGESTEDNESS_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x12

    const-string v2, "EVENT_KEEPALIVE_STATUS"

    aput-object v2, v0, v1

    const/16 v1, 0x13

    const-string v2, "EVENT_KEEPALIVE_STARTED"

    aput-object v2, v0, v1

    const/16 v1, 0x14

    const-string v2, "EVENT_KEEPALIVE_STOPPED"

    aput-object v2, v0, v1

    const/16 v1, 0x15

    const-string v2, "EVENT_KEEPALIVE_START_REQUEST"

    aput-object v2, v0, v1

    const/16 v1, 0x16

    const-string v2, "EVENT_KEEPALIVE_STOP_REQUEST"

    aput-object v2, v0, v1

    const/16 v1, 0x17

    const-string v2, "EVENT_LINK_CAPACITY_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x18

    const-string v2, "EVENT_RESET"

    aput-object v2, v0, v1

    const/16 v1, 0x19

    const-string v2, "EVENT_REEVALUATE_RESTRICTED_STATE"

    aput-object v2, v0, v1

    const/16 v1, 0x1a

    const-string v2, "EVENT_REEVALUATE_DATA_CONNECTION_PROPERTIES"

    aput-object v2, v0, v1

    const/16 v1, 0x1b

    const-string v2, "EVENT_NR_STATE_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x1c

    const-string v2, "EVENT_DATA_CONNECTION_METEREDNESS_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x1d

    const-string v2, "EVENT_NR_FREQUENCY_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x1e

    const-string v2, "EVENT_CARRIER_CONFIG_LINK_BANDWIDTHS_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x1f

    const-string v2, "EVENT_CARRIER_PRIVILEGED_UIDS_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x20

    const-string v2, "EVENT_CSS_INDICATOR_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x21

    const-string v2, "EVENT_UPDATE_SUSPENDED_STATE"

    aput-object v2, v0, v1

    const/16 v1, 0x22

    const-string v2, "EVENT_START_HANDOVER"

    aput-object v2, v0, v1

    const/16 v1, 0x23

    const-string v2, "EVENT_CANCEL_HANDOVER"

    aput-object v2, v0, v1

    const/16 v1, 0x24

    const-string v2, "EVENT_START_HANDOVER_ON_TARGET"

    aput-object v2, v0, v1

    const/16 v1, 0x25

    const-string v2, "EVENT_ALLOCATE_PDU_SESSION_ID"

    aput-object v2, v0, v1

    const/16 v1, 0x26

    const-string v2, "EVENT_RELEASE_PDU_SESSION_ID"

    aput-object v2, v0, v1

    const/16 v1, 0x27

    const-string v2, "EVENT_LINK_BANDWIDTH_ESTIMATOR_UPDATE"

    aput-object v2, v0, v1

    return-void
.end method

.method private constructor <init>(Lcom/android/internal/telephony/Phone;Ljava/lang/String;ILcom/android/internal/telephony/dataconnection/DcTracker;Lcom/android/internal/telephony/dataconnection/DataServiceManager;Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;Lcom/android/internal/telephony/dataconnection/DcController;)V
    .locals 4

    .line 771
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DC-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0, p7}, Lcom/android/internal/telephony/StateMachine;-><init>(Ljava/lang/String;Landroid/os/Handler;)V

    const/4 v0, 0x0

    .line 216
    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    .line 222
    new-instance v1, Lcom/android/internal/telephony/LocalLog;

    const/16 v2, 0x40

    invoke-direct {v1, v2}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverLocalLog:Lcom/android/internal/telephony/LocalLog;

    const/4 v1, 0x0

    new-array v2, v1, [I

    .line 224
    iput-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mAdministratorUids:[I

    .line 312
    new-instance v2, Landroid/net/LinkProperties;

    invoke-direct {v2}, Landroid/net/LinkProperties;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    .line 322
    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRilRat:I

    const v2, 0x7fffffff

    .line 323
    iput v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataRegState:I

    const/16 v2, 0xe

    .line 329
    iput v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDownlinkBandwidth:I

    .line 330
    iput v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    .line 331
    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultQos:Landroid/telephony/data/Qos;

    .line 332
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mQosBearerSessions:Ljava/util/List;

    .line 334
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTrafficDescriptors:Ljava/util/List;

    .line 345
    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisabledApnTypeBitMask:I

    const/4 v2, 0x1

    .line 352
    iput v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    .line 354
    new-instance v3, Ljava/util/concurrent/ConcurrentHashMap;

    invoke-direct {v3}, Ljava/util/concurrent/ConcurrentHashMap;-><init>()V

    iput-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    .line 355
    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mReconnectIntent:Landroid/app/PendingIntent;

    .line 358
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;

    invoke-direct {v3, p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DataConnectionVcnNetworkPolicyChangeListener-IA;)V

    iput-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mVcnPolicyChangeListener:Landroid/net/vcn/VcnManager$VcnNetworkPolicyChangeListener;

    .line 1683
    iput-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredUseOnly:Z

    .line 1691
    iput-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mMmsUseOnly:Z

    .line 1712
    iput-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRestrictedNetworkOverride:Z

    .line 1720
    iput-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mEnterpriseUse:Z

    .line 2467
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;

    invoke-direct {v3, p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState-IA;)V

    iput-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;

    .line 2643
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

    invoke-direct {v3, p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState-IA;)V

    iput-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mInactiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

    .line 2828
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;

    invoke-direct {v3, p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState-IA;)V

    iput-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mActivatingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;

    .line 3410
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;

    invoke-direct {v3, p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState-IA;)V

    iput-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mActiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;

    .line 3470
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState;

    invoke-direct {v3, p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState-IA;)V

    iput-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState;

    .line 3523
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection;

    invoke-direct {v3, p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection-IA;)V

    iput-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectingErrorCreatingConnection:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection;

    .line 772
    iput-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTagSuffix:Ljava/lang/String;

    const/16 p2, 0x12c

    .line 773
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/StateMachine;->setLogRecSize(I)V

    .line 774
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/StateMachine;->setLogOnlyTransitions(Z)V

    const-string p2, "DataConnection created"

    .line 775
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 777
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 778
    iput-object p4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    .line 779
    iput-object p5, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    .line 780
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    const-class p2, Landroid/net/vcn/VcnManager;

    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/net/vcn/VcnManager;

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mVcnManager:Landroid/net/vcn/VcnManager;

    .line 781
    invoke-virtual {p5}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->getTransportType()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    .line 782
    iput-object p6, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcTesterFailBringUpAll:Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;

    .line 783
    iput-object p7, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcController:Lcom/android/internal/telephony/dataconnection/DcController;

    .line 784
    iput p3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mId:I

    const/4 p1, -0x1

    .line 785
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    .line 786
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataRegState:I

    .line 787
    iput-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mIsSuspended:Z

    .line 788
    new-instance p1, Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {p1, p2}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;-><init>(Lcom/android/internal/telephony/Phone;)V

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    .line 789
    iput-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDoAllocatePduSessionId:Z

    .line 791
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkType()I

    move-result p1

    .line 792
    invoke-static {p1}, Landroid/telephony/ServiceState;->networkTypeToRilRadioTechnology(I)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRilRat:I

    .line 793
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateLinkBandwidthsFromCarrierConfig(I)V

    .line 795
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;)V

    .line 796
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mInactiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 797
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mActivatingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;

    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 798
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mActiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;

    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 799
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState;

    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 800
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectingErrorCreatingConnection:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection;

    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDefaultState;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 801
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mInactiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->setInitialState(Lcom/android/internal/telephony/State;)V

    return-void
.end method

.method static synthetic access$000(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/String;)V
    .locals 0

    .line 146
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->logAndAddLogRec(Ljava/lang/String;)V

    return-void
.end method

.method private allocatePduSessionId(Ljava/util/function/Consumer;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/function/Consumer<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 1005
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDoAllocatePduSessionId:Z

    if-eqz v0, :cond_0

    const v0, 0x40025

    .line 1006
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 1007
    iput-object p1, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 1008
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object p0, p0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, v0}, Lcom/android/internal/telephony/CommandsInterface;->allocatePduSessionId(Landroid/os/Message;)V

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    .line 1010
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {p1, p0}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    :goto_0
    return-void
.end method

.method private calculateScore()I
    .locals 4

    .line 3941
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p0

    const/16 v0, 0x2d

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/dataconnection/ApnContext;

    .line 3942
    invoke-virtual {v1}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getNetworkRequests()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_1
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/net/NetworkRequest;

    const/16 v3, 0xc

    .line 3943
    invoke-virtual {v2, v3}, Landroid/net/NetworkRequest;->hasCapability(I)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 3944
    invoke-virtual {v2}, Landroid/net/NetworkRequest;->getNetworkSpecifier()Landroid/net/NetworkSpecifier;

    move-result-object v2

    if-nez v2, :cond_1

    const/16 v0, 0x32

    goto :goto_0

    :cond_2
    return v0
.end method

.method private canHandleDefault()Z
    .locals 1

    .line 2475
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isEnterpriseUse()Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    if-eqz v0, :cond_0

    .line 2476
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    const/16 v0, 0x11

    invoke-virtual {p0, v0}, Landroid/telephony/data/ApnSetting;->canHandleType(I)Z

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private cancelHandover()V
    .locals 3

    .line 1134
    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    const/4 v1, 0x2

    if-eq v0, v1, :cond_0

    .line 1135
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "cancelHandover: handover state is "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->handoverStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", expecting HANDOVER_STATE_BEING_TRANSFERRED"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 1138
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    const v2, 0x40023

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->cancelHandover(ILandroid/os/Message;)V

    const/4 v0, 0x1

    .line 1139
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->setHandoverState(I)V

    return-void
.end method

.method private checkSetMtu(Landroid/telephony/data/ApnSetting;Landroid/net/LinkProperties;)V
    .locals 1

    if-nez p2, :cond_0

    return-void

    :cond_0
    if-eqz p1, :cond_3

    .line 748
    invoke-virtual {p2}, Landroid/net/LinkProperties;->getMtu()I

    move-result v0

    if-eqz v0, :cond_1

    .line 749
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "MTU set by call response to: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/net/LinkProperties;->getMtu()I

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-void

    .line 753
    :cond_1
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMtuV4()I

    move-result v0

    if-eqz v0, :cond_2

    .line 754
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMtuV4()I

    move-result v0

    invoke-virtual {p2, v0}, Landroid/net/LinkProperties;->setMtu(I)V

    .line 755
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "MTU set by APN to: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMtuV4()I

    move-result p1

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-void

    .line 759
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    const v0, 0x10e00a0

    invoke-virtual {p1, v0}, Landroid/content/res/Resources;->getInteger(I)I

    move-result p1

    if-eqz p1, :cond_3

    .line 762
    invoke-virtual {p2, p1}, Landroid/net/LinkProperties;->setMtu(I)V

    .line 763
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "MTU set by config resource to: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    :cond_3
    return-void
.end method

.method private declared-synchronized clearSettings()V
    .locals 4

    monitor-enter p0

    :try_start_0
    const-string v0, "clearSettings"

    .line 1340
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    const-wide/16 v0, -0x1

    .line 1342
    iput-wide v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCreateTime:J

    .line 1343
    iput-wide v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailTime:J

    const/4 v0, 0x0

    .line 1344
    iput v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailCause:I

    const/4 v1, -0x1

    .line 1345
    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    const/4 v2, 0x5

    new-array v2, v2, [Ljava/lang/String;

    .line 1347
    iput-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPcscfAddr:[Ljava/lang/String;

    .line 1349
    new-instance v2, Landroid/net/LinkProperties;

    invoke-direct {v2}, Landroid/net/LinkProperties;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    .line 1350
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {v2}, Ljava/util/Map;->clear()V

    const/4 v2, 0x0

    .line 1351
    iput-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 1352
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredUseOnly:Z

    .line 1353
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mMmsUseOnly:Z

    .line 1354
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mEnterpriseUse:Z

    .line 1355
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRestrictedNetworkOverride:Z

    .line 1356
    iput v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcFailCause:I

    .line 1357
    iput v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisabledApnTypeBitMask:I

    .line 1358
    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSubId:I

    .line 1359
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCongestedOverride:Z

    .line 1360
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredOverride:Z

    const/16 v3, 0xe

    .line 1361
    iput v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDownlinkBandwidth:I

    .line 1362
    iput v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    .line 1363
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mIsSuspended:Z

    const/4 v3, 0x1

    .line 1364
    iput v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    .line 1365
    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverFailureMode:I

    .line 1366
    iput-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSliceInfo:Landroid/telephony/data/NetworkSliceInfo;

    .line 1367
    iput-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultQos:Landroid/telephony/data/Qos;

    .line 1368
    iput-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDoAllocatePduSessionId:Z

    .line 1369
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mQosBearerSessions:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 1370
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTrafficDescriptors:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1371
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method static cmdToString(I)Ljava/lang/String;
    .locals 3

    const/high16 v0, 0x40000

    sub-int/2addr p0, v0

    if-ltz p0, :cond_0

    .line 457
    sget-object v1, Lcom/android/internal/telephony/dataconnection/DataConnection;->sCmdToString:[Ljava/lang/String;

    array-length v2, v1

    if-ge p0, v2, :cond_0

    .line 458
    aget-object v1, v1, p0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    if-nez v1, :cond_1

    .line 461
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "0x"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/2addr p0, v0

    invoke-static {p0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :cond_1
    return-object v1
.end method

.method private connect(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)I
    .locals 16

    move-object/from16 v11, p0

    move-object/from16 v3, p1

    .line 858
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "connect: carrier=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getEntryName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\' APN=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 859
    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\' proxy=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 860
    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getProxyAddressAsString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\' port=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 861
    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getProxyPort()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, "\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 858
    invoke-virtual {v11, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 862
    iget-object v0, v3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    const-string v1, "DataConnection.connect"

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/ApnContext;->requestLog(Lcom/android/internal/telephony/dataconnection/ApnContext;Ljava/lang/String;)V

    .line 865
    iget-object v0, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcTesterFailBringUpAll:Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;->getDcFailBringUp()Lcom/android/internal/telephony/dataconnection/DcFailBringUp;

    move-result-object v0

    iget v0, v0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mCounter:I

    const v1, 0x40001

    const/4 v2, 0x0

    const/4 v4, 0x1

    const/4 v12, 0x0

    if-lez v0, :cond_0

    .line 866
    new-instance v0, Landroid/telephony/data/DataCallResponse$Builder;

    invoke-direct {v0}, Landroid/telephony/data/DataCallResponse$Builder;-><init>()V

    iget-object v5, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcTesterFailBringUpAll:Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;

    .line 867
    invoke-virtual {v5}, Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;->getDcFailBringUp()Lcom/android/internal/telephony/dataconnection/DcFailBringUp;

    move-result-object v5

    iget v5, v5, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mFailCause:I

    invoke-virtual {v0, v5}, Landroid/telephony/data/DataCallResponse$Builder;->setCause(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    iget-object v5, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcTesterFailBringUpAll:Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;

    .line 869
    invoke-virtual {v5}, Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;->getDcFailBringUp()Lcom/android/internal/telephony/dataconnection/DcFailBringUp;

    move-result-object v5

    iget-wide v5, v5, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mSuggestedRetryTime:J

    .line 868
    invoke-virtual {v0, v5, v6}, Landroid/telephony/data/DataCallResponse$Builder;->setRetryDurationMillis(J)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 870
    invoke-virtual {v0, v12}, Landroid/telephony/data/DataCallResponse$Builder;->setMtuV4(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 871
    invoke-virtual {v0, v12}, Landroid/telephony/data/DataCallResponse$Builder;->setMtuV6(I)Landroid/telephony/data/DataCallResponse$Builder;

    move-result-object v0

    .line 872
    invoke-virtual {v0}, Landroid/telephony/data/DataCallResponse$Builder;->build()Landroid/telephony/data/DataCallResponse;

    move-result-object v0

    .line 874
    invoke-virtual {v11, v1, v3}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v1

    .line 875
    invoke-static {v1, v0, v2}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 876
    invoke-virtual {v11, v1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    .line 878
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "connect: FailBringUpAll="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcTesterFailBringUpAll:Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;

    invoke-virtual {v2}, Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;->getDcFailBringUp()Lcom/android/internal/telephony/dataconnection/DcFailBringUp;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " send error response="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v11, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 881
    iget-object v0, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcTesterFailBringUpAll:Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;->getDcFailBringUp()Lcom/android/internal/telephony/dataconnection/DcFailBringUp;

    move-result-object v0

    iget v1, v0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mCounter:I

    sub-int/2addr v1, v4

    iput v1, v0, Lcom/android/internal/telephony/dataconnection/DcFailBringUp;->mCounter:I

    return v12

    :cond_0
    const-wide/16 v5, -0x1

    .line 885
    iput-wide v5, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCreateTime:J

    .line 886
    iput-wide v5, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailTime:J

    .line 887
    iput v12, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailCause:I

    .line 889
    invoke-virtual {v11, v1, v3}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v10

    .line 890
    iput-object v3, v10, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 892
    new-instance v0, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {v0}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    iget-object v1, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 893
    invoke-virtual {v0, v1}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v0

    iget-boolean v1, v3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mIsPreferredApn:Z

    .line 894
    invoke-virtual {v0, v1}, Landroid/telephony/data/DataProfile$Builder;->setPreferred(Z)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v0

    .line 895
    invoke-virtual {v0}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object v5

    .line 900
    iget-object v0, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRoamingFromRegistration()Z

    move-result v6

    .line 903
    iget-object v0, v3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    .line 904
    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeBitmask()I

    move-result v0

    iget-object v1, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 903
    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/ApnSettingUtils;->isMeteredApnType(ILcom/android/internal/telephony/Phone;)Z

    move-result v0

    xor-int/2addr v0, v4

    .line 909
    iget-object v1, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getDataRoamingEnabled()Z

    move-result v1

    if-nez v1, :cond_2

    if-eqz v6, :cond_1

    iget-object v1, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 910
    invoke-interface {v1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v1

    if-eqz v1, :cond_2

    if-eqz v0, :cond_1

    goto :goto_0

    :cond_1
    move v7, v12

    goto :goto_1

    :cond_2
    :goto_0
    move v7, v4

    .line 915
    :goto_1
    iget-object v1, v3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    invoke-virtual {v1}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeBitmask()I

    move-result v1

    const/16 v8, 0x4000

    if-ne v1, v8, :cond_3

    .line 916
    invoke-static {}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getEnterpriseOsAppId()[B

    move-result-object v1

    move-object v8, v2

    goto :goto_2

    .line 918
    :cond_3
    iget-object v1, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v1

    move-object v8, v1

    move-object v1, v2

    :goto_2
    if-nez v1, :cond_4

    if-nez v8, :cond_4

    goto :goto_3

    .line 921
    :cond_4
    new-instance v2, Landroid/telephony/data/TrafficDescriptor;

    invoke-direct {v2, v8, v1}, Landroid/telephony/data/TrafficDescriptor;-><init>(Ljava/lang/String;[B)V

    :goto_3
    move-object v8, v2

    if-eqz v8, :cond_6

    .line 922
    invoke-virtual {v8}, Landroid/telephony/data/TrafficDescriptor;->getOsAppId()[B

    move-result-object v1

    if-nez v1, :cond_5

    goto :goto_4

    :cond_5
    move v9, v12

    goto :goto_5

    :cond_6
    :goto_4
    move v9, v4

    .line 925
    :goto_5
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "allowRoaming="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", mPhone.getDataRoamingEnabled()="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 926
    invoke-interface {v2}, Lcom/android/internal/telephony/PhoneInternalInterface;->getDataRoamingEnabled()Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", isModemRoaming="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", mPhone.getServiceState().getDataRoaming()="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 929
    invoke-interface {v2}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", isUnmeteredApnType="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, ", trafficDescriptor="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, ", matchAllRuleAllowed="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v9}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 925
    invoke-virtual {v11, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    const/4 v13, 0x0

    const/4 v14, 0x1

    .line 939
    iget v0, v3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mRequestType:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_b

    .line 942
    iget-object v0, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct/range {p0 .. p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getHandoverSourceTransport()I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v0

    const v1, 0x10006

    if-eqz v0, :cond_a

    .line 943
    iget-object v2, v3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    if-nez v2, :cond_7

    goto :goto_7

    .line 952
    :cond_7
    invoke-virtual {v2}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnType()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getDataConnectionByApnType(Ljava/lang/String;)Lcom/android/internal/telephony/dataconnection/DataConnection;

    move-result-object v8

    if-nez v8, :cond_8

    const-string v0, "connect: Can\'t find data connection for handover."

    .line 954
    invoke-virtual {v11, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    return v1

    .line 959
    :cond_8
    iget-object v0, v8, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    if-nez v0, :cond_9

    const-string v0, "(null)"

    goto :goto_6

    .line 960
    :cond_9
    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->getTag()Ljava/lang/String;

    move-result-object v0

    .line 961
    :goto_6
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "connect: REQUEST_TYPE_HANDOVER - Request handover from "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ", targetDsm="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    .line 962
    invoke-virtual {v2}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->getTag()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ", sourceDsm="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 961
    invoke-virtual {v11, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 970
    new-instance v9, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda7;

    move-object v0, v9

    move-object/from16 v1, p0

    move-object v2, v8

    move-object/from16 v3, p1

    move-object v4, v10

    invoke-direct/range {v0 .. v7}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda7;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZ)V

    .line 978
    invoke-virtual {v8, v9}, Lcom/android/internal/telephony/dataconnection/DataConnection;->startHandover(Ljava/util/function/Consumer;)V

    return v12

    .line 944
    :cond_a
    :goto_7
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "connect: Handover failed. dcTracker="

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, ", apnContext="

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, v3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v11, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    return v1

    .line 983
    :cond_b
    iget v0, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    if-ne v0, v1, :cond_c

    goto :goto_8

    :cond_c
    move v4, v12

    :goto_8
    iput-boolean v4, v11, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDoAllocatePduSessionId:Z

    .line 984
    new-instance v15, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda8;

    move-object v0, v15

    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move-object v3, v5

    move v4, v6

    move v5, v7

    move v6, v14

    move-object v7, v13

    invoke-direct/range {v0 .. v10}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda8;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;Landroid/telephony/data/TrafficDescriptor;ZLandroid/os/Message;)V

    invoke-direct {v11, v15}, Lcom/android/internal/telephony/dataconnection/DataConnection;->allocatePduSessionId(Ljava/util/function/Consumer;)V

    return v12
.end method

.method private dumpToLog()V
    .locals 3

    .line 3910
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnection$1;

    new-instance v1, Ljava/io/StringWriter;

    const/4 v2, 0x0

    invoke-direct {v1, v2}, Ljava/io/StringWriter;-><init>(I)V

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection$1;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/io/Writer;)V

    const/4 v1, 0x0

    invoke-virtual {p0, v1, v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    return-void
.end method

.method private fallBackToCarrierConfigValues(ZZ)V
    .locals 3

    .line 1653
    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRilRat:I

    invoke-static {v0}, Landroid/telephony/ServiceState;->rilRadioTechnologyToString(I)Ljava/lang/String;

    move-result-object v0

    .line 1654
    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRilRat:I

    const/16 v2, 0xe

    if-ne v1, v2, :cond_1

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isNRConnected()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 1656
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1655
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getNrFrequencyRange()I

    move-result v0

    const/4 v1, 0x4

    if-ne v0, v1, :cond_0

    const-string v0, "NR_NSA_MMWAVE"

    goto :goto_0

    :cond_0
    const-string v0, "NR_NSA"

    .line 1659
    :cond_1
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getLinkBandwidthsFromCarrierConfig(Ljava/lang/String;)Landroid/util/Pair;

    move-result-object v0

    if-eqz v0, :cond_4

    if-nez p1, :cond_2

    .line 1662
    iget-object p1, v0, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDownlinkBandwidth:I

    :cond_2
    if-nez p2, :cond_3

    .line 1665
    iget-object p1, v0, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    .line 1667
    :cond_3
    iget p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    iget p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDownlinkBandwidth:I

    invoke-static {p1, p2}, Ljava/lang/Math;->min(II)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    :cond_4
    return-void
.end method

.method private getApnTypeBitmask()I
    .locals 1

    .line 2470
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isEnterpriseUse()Z

    move-result v0

    if-eqz v0, :cond_0

    const/16 p0, 0x4000

    goto :goto_0

    .line 2471
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    if-eqz v0, :cond_1

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {p0}, Landroid/telephony/data/ApnSetting;->getApnTypeBitmask()I

    move-result p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private getCarrierServicePackageUid()I
    .locals 2

    .line 2017
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 2018
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Landroid/telephony/TelephonyManager;

    .line 2019
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 2020
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/TelephonyManager;->getCarrierServicePackageNameForLogicalSlot(I)Ljava/lang/String;

    move-result-object v0

    .line 2022
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getFirstUidForPackage(Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method private getDisallowedApnTypes()I
    .locals 2

    .line 3886
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 3887
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "carrier_config"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    if-eqz v0, :cond_1

    .line 3890
    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSubId:I

    invoke-virtual {v0, v1}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 3892
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    const/4 v1, 0x1

    if-ne p0, v1, :cond_0

    const-string p0, "carrier_wwan_disallowed_apn_types_string_array"

    goto :goto_0

    :cond_0
    const-string p0, "carrier_wlan_disallowed_apn_types_string_array"

    .line 3895
    :goto_0
    invoke-virtual {v0, p0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 3897
    invoke-virtual {v0, p0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    const-string v0, ","

    invoke-static {v0, p0}, Landroid/text/TextUtils;->join(Ljava/lang/CharSequence;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    .line 3898
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 3899
    invoke-static {p0}, Landroid/telephony/data/ApnSetting;->getApnTypesBitmaskFromString(Ljava/lang/String;)I

    move-result p0

    goto :goto_1

    :cond_1
    const/4 p0, 0x0

    :goto_1
    return p0
.end method

.method public static getEnterpriseOsAppId()[B
    .locals 5
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    const/16 v0, 0x1d

    .line 833
    invoke-static {v0}, Landroid/net/NetworkCapabilities;->getCapabilityCarrierName(I)Ljava/lang/String;

    move-result-object v0

    .line 834
    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v0

    .line 836
    array-length v1, v0

    add-int/lit8 v1, v1, 0x11

    invoke-static {v1}, Ljava/nio/ByteBuffer;->allocate(I)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 837
    sget-object v2, Lcom/android/internal/telephony/dataconnection/DataConnection;->OS_ID:Ljava/util/UUID;

    invoke-virtual {v2}, Ljava/util/UUID;->getMostSignificantBits()J

    move-result-wide v3

    invoke-virtual {v1, v3, v4}, Ljava/nio/ByteBuffer;->putLong(J)Ljava/nio/ByteBuffer;

    .line 838
    invoke-virtual {v2}, Ljava/util/UUID;->getLeastSignificantBits()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Ljava/nio/ByteBuffer;->putLong(J)Ljava/nio/ByteBuffer;

    .line 839
    array-length v2, v0

    int-to-byte v2, v2

    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->put(B)Ljava/nio/ByteBuffer;

    .line 840
    invoke-virtual {v1, v0}, Ljava/nio/ByteBuffer;->put([B)Ljava/nio/ByteBuffer;

    .line 842
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getEnterpriseOsAppId: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 843
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->array()[B

    move-result-object v2

    invoke-static {v2}, Lcom/android/internal/telephony/uicc/IccUtils;->bytesToHexString([B)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "DataConnection"

    .line 842
    invoke-static {v2, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 845
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->array()[B

    move-result-object v0

    return-object v0
.end method

.method private getFirstUidForPackage(Ljava/lang/String;)I
    .locals 5

    const/4 v0, -0x1

    if-nez p1, :cond_0

    return v0

    .line 1997
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    const-class v2, Landroid/os/UserManager;

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/UserManager;

    invoke-virtual {v1}, Landroid/os/UserManager;->getUsers()Ljava/util/List;

    move-result-object v1

    .line 1998
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_1
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/content/pm/UserInfo;

    .line 1999
    invoke-virtual {v2}, Landroid/content/pm/UserInfo;->getUserHandle()Landroid/os/UserHandle;

    move-result-object v2

    invoke-virtual {v2}, Landroid/os/UserHandle;->getIdentifier()I

    move-result v2

    .line 2001
    :try_start_0
    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v3

    if-eqz v3, :cond_1

    .line 2004
    invoke-virtual {v3, p1, v2}, Landroid/content/pm/PackageManager;->getPackageUidAsUser(Ljava/lang/String;I)I

    move-result p0
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    .line 2008
    :catch_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Unable to find uid for package "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " and user "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "DataConnection"

    invoke-static {v3, v2}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_2
    return v0
.end method

.method private getHandoverSourceTransport()I
    .locals 1

    .line 822
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    const/4 v0, 0x2

    :cond_0
    return v0
.end method

.method private getNetworkType()I
    .locals 2

    .line 805
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    .line 808
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p0}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 811
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private getState()I
    .locals 1

    .line 3964
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isInactive()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 3966
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isActivating()Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 p0, 0x1

    return p0

    .line 3968
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isActive()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 3970
    iget-boolean p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mIsSuspended:Z

    if-eqz p0, :cond_2

    const/4 p0, 0x3

    return p0

    :cond_2
    const/4 p0, 0x2

    return p0

    .line 3974
    :cond_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isDisconnecting()Z

    move-result p0

    if-eqz p0, :cond_4

    const/4 p0, 0x4

    return p0

    :cond_4
    const/4 p0, -0x1

    return p0
.end method

.method private getSuggestedRetryDelay(Landroid/telephony/data/DataCallResponse;)J
    .locals 8

    const-wide/16 v0, -0x1

    if-nez p1, :cond_0

    return-wide v0

    .line 3673
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getRetryDurationMillis()J

    move-result-wide v2

    const-wide/16 v4, 0x0

    cmp-long p1, v2, v4

    if-gez p1, :cond_1

    const-string p1, "No suggested retry delay."

    .line 3677
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-wide v0

    .line 3679
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getHalVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object p1

    sget-object v0, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_6:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p1

    const-string v1, "Network suggested not retrying."

    const-wide v4, 0x7fffffffffffffffL

    if-eqz p1, :cond_2

    cmp-long p1, v2, v4

    if-nez p1, :cond_2

    .line 3681
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-wide v4

    .line 3683
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getHalVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object p1

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/HalVersion;->less(Lcom/android/internal/telephony/HalVersion;)Z

    move-result p1

    if-eqz p1, :cond_3

    const-wide/32 v6, 0x7fffffff

    cmp-long p1, v2, v6

    if-nez p1, :cond_3

    .line 3685
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-wide v4

    :cond_3
    return-wide v2
.end method

.method private getVcnPolicy(Landroid/net/NetworkCapabilities;)Landroid/net/vcn/VcnNetworkPolicyResult;
    .locals 1

    .line 2032
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mVcnManager:Landroid/net/vcn/VcnManager;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object p0

    invoke-virtual {v0, p1, p0}, Landroid/net/vcn/VcnManager;->applyVcnNetworkPolicy(Landroid/net/NetworkCapabilities;Landroid/net/LinkProperties;)Landroid/net/vcn/VcnNetworkPolicyResult;

    move-result-object p0

    return-object p0
.end method

.method private handoverStateToString(I)Ljava/lang/String;
    .locals 0

    const/4 p0, 0x1

    if-eq p1, p0, :cond_2

    const/4 p0, 0x2

    if-eq p1, p0, :cond_1

    const/4 p0, 0x3

    if-eq p1, p0, :cond_0

    const-string p0, "UNKNOWN"

    return-object p0

    :cond_0
    const-string p0, "COMPLETED"

    return-object p0

    :cond_1
    const-string p0, "BEING_TRANSFERRED"

    return-object p0

    :cond_2
    const-string p0, "IDLE"

    return-object p0
.end method

.method private initConnection(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)Z
    .locals 3

    .line 2191
    iget-object v0, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    .line 2192
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    if-nez v1, :cond_0

    .line 2195
    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 2197
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeBitmask()I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting;->canHandleType(I)Z

    move-result v1

    if-nez v1, :cond_1

    .line 2198
    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeBitmask()I

    move-result v1

    const/16 v2, 0x4000

    if-eq v1, v2, :cond_1

    goto :goto_0

    .line 2205
    :cond_1
    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    const/4 v2, 0x1

    add-int/2addr v1, v2

    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    .line 2206
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mConnectionParams:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    .line 2207
    iput v1, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mTag:I

    .line 2211
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {v1, v0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 2214
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "initConnection:  RefCount="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    .line 2215
    invoke-interface {v0}, Ljava/util/Map;->size()I

    move-result v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " mApnList="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, " mConnectionParams="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mConnectionParams:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2214
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return v2

    .line 2200
    :cond_2
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "initConnection: incompatible apnSetting in ConnectionParams cp="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, " dc="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0
.end method

.method private isApnContextAttached(IZ)Z
    .locals 2

    .line 3703
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda4;

    invoke-direct {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda4;-><init>()V

    .line 3704
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda5;

    invoke-direct {v1, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda5;-><init>(I)V

    .line 3705
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p1

    if-eqz p2, :cond_1

    .line 3707
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->size()I

    move-result p0

    const/4 p2, 0x1

    if-ne p0, p2, :cond_0

    goto :goto_0

    :cond_0
    const/4 p2, 0x0

    :goto_0
    and-int/2addr p1, p2

    :cond_1
    return p1
.end method

.method private isBandwidthSourceKey(Ljava/lang/String;)Z
    .locals 1

    .line 1672
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const v0, 0x104020f

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private isDnsOk([Ljava/lang/String;)Z
    .locals 4

    const/4 v0, 0x0

    .line 1444
    aget-object v1, p1, v0

    const-string v2, "0.0.0.0"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const/4 v3, 0x1

    if-eqz v1, :cond_0

    aget-object p1, p1, v3

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1445
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->isDnsCheckDisabled()Z

    move-result p1

    if-nez p1, :cond_0

    .line 1451
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMmsProxyAddressAsString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isIpAddress(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_0

    const/4 p1, 0x4

    new-array p1, p1, [Ljava/lang/Object;

    .line 1452
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 1454
    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getApnTypeBitmask()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, p1, v0

    const-string v1, "mms"

    aput-object v1, p1, v3

    const/4 v1, 0x2

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 1455
    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getMmsProxyAddressAsString()Ljava/lang/String;

    move-result-object v2

    aput-object v2, p1, v1

    const/4 v1, 0x3

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 1456
    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getMmsProxyAddressAsString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isIpAddress(Ljava/lang/String;)Z

    move-result v2

    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    aput-object v2, p1, v1

    const-string v1, "isDnsOk: return false apn.types=%d APN_TYPE_MMS=%s isIpAddress(%s)=%s"

    .line 1452
    invoke-static {v1, p1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return v0

    :cond_0
    return v3
.end method

.method private isEnterpriseUse()Z
    .locals 1

    .line 1818
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/Set;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda6;

    invoke-direct {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda6;-><init>()V

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0
.end method

.method public static isIpAddress(Ljava/lang/String;)Z
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const-string v0, "["

    .line 2074
    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "]"

    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    const/16 v0, 0x3a

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    const/4 v1, -0x1

    if-eq v0, v1, :cond_1

    .line 2075
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    .line 2077
    :cond_1
    invoke-static {p0}, Landroid/net/InetAddresses;->isNumericAddress(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private isMmsUseOnly()Z
    .locals 4

    .line 1804
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataEnabledSettings()Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    move-result-object v0

    .line 1805
    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isDataEnabled()Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isMmsAlwaysAllowed()Z

    move-result v0

    if-eqz v0, :cond_0

    move v0, v3

    goto :goto_0

    :cond_0
    move v0, v2

    :goto_0
    const/4 v1, 0x2

    .line 1806
    invoke-direct {p0, v1, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isApnContextAttached(IZ)Z

    move-result p0

    if-eqz v0, :cond_1

    if-eqz p0, :cond_1

    move v2, v3

    :cond_1
    return v2
.end method

.method private isNRConnected()Z
    .locals 1

    .line 3878
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getNrState()I

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

.method private static isResultCodeSuccess(I)Z
    .locals 1

    const/4 v0, 0x1

    if-eqz p0, :cond_1

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :cond_1
    :goto_0
    return v0
.end method

.method private isUnmeteredUseOnly()Z
    .locals 4

    .line 1774
    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    const/4 v1, 0x0

    const/4 v2, 0x2

    if-ne v0, v2, :cond_0

    return v1

    .line 1782
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataEnabledSettings()Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isDataEnabled()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1783
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getDataRoamingEnabled()Z

    move-result v0

    if-eqz v0, :cond_2

    :cond_1
    return v1

    .line 1790
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_3
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/dataconnection/ApnContext;

    .line 1791
    invoke-virtual {v2}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeBitmask()I

    move-result v2

    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v2, v3}, Lcom/android/internal/telephony/dataconnection/ApnSettingUtils;->isMeteredApnType(ILcom/android/internal/telephony/Phone;)Z

    move-result v2

    if-eqz v2, :cond_3

    return v1

    :cond_4
    const/4 p0, 0x1

    return p0
.end method

.method private synthetic lambda$connect$0(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/Integer;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZLjava/lang/Boolean;)V
    .locals 9

    .line 975
    invoke-virtual/range {p8 .. p8}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    .line 976
    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result v3

    move-object v0, p0

    move-object v2, p1

    move-object v4, p3

    move-object v5, p4

    move-object v6, p5

    move v7, p6

    move/from16 v8, p7

    .line 975
    invoke-direct/range {v0 .. v8}, Lcom/android/internal/telephony/dataconnection/DataConnection;->requestHandover(ZLcom/android/internal/telephony/dataconnection/DataConnection;ILcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZ)V

    return-void
.end method

.method private synthetic lambda$connect$1(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZLjava/lang/Integer;)V
    .locals 10

    .line 974
    new-instance v9, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;

    move-object v0, v9

    move-object v1, p0

    move-object v2, p1

    move-object/from16 v3, p7

    move-object v4, p2

    move-object v5, p3

    move-object v6, p4

    move v7, p5

    move/from16 v8, p6

    invoke-direct/range {v0 .. v8}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda9;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/lang/Integer;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZ)V

    const v0, 0x40024

    invoke-direct {p0, v0, v9}, Lcom/android/internal/telephony/dataconnection/DataConnection;->sendRunnableMessage(ILjava/util/function/Consumer;)V

    return-void
.end method

.method private synthetic lambda$connect$2(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;Landroid/telephony/data/TrafficDescriptor;ZLandroid/os/Message;Ljava/lang/Integer;)V
    .locals 15

    move-object v0, p0

    move-object/from16 v1, p1

    .line 985
    invoke-virtual/range {p10 .. p10}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->setPduSessionId(I)V

    .line 986
    iget-object v3, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    iget v2, v1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mRilRat:I

    .line 987
    invoke-static {v2}, Landroid/telephony/ServiceState;->rilRadioTechnologyToAccessNetworkType(I)I

    move-result v4

    .line 993
    invoke-virtual/range {p10 .. p10}, Ljava/lang/Integer;->intValue()I

    move-result v10

    const/4 v11, 0x0

    move-object/from16 v5, p2

    move/from16 v6, p3

    move/from16 v7, p4

    move/from16 v8, p5

    move-object/from16 v9, p6

    move-object/from16 v12, p7

    move/from16 v13, p8

    move-object/from16 v14, p9

    .line 986
    invoke-virtual/range {v3 .. v14}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->setupDataCall(ILandroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;ILandroid/telephony/data/NetworkSliceInfo;Landroid/telephony/data/TrafficDescriptor;ZLandroid/os/Message;)V

    .line 998
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v2

    iget-object v0, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    iget v1, v1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mRilRat:I

    .line 999
    invoke-virtual/range {p2 .. p2}, Landroid/telephony/data/DataProfile;->getProfileId()I

    move-result v3

    invoke-virtual/range {p2 .. p2}, Landroid/telephony/data/DataProfile;->getApn()Ljava/lang/String;

    move-result-object v4

    invoke-virtual/range {p2 .. p2}, Landroid/telephony/data/DataProfile;->getProtocolType()I

    move-result v5

    move-object p0, v2

    move/from16 p1, v0

    move/from16 p2, v1

    move/from16 p3, v3

    move-object/from16 p4, v4

    move/from16 p5, v5

    .line 998
    invoke-virtual/range {p0 .. p5}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeSetupDataCall(IIILjava/lang/String;I)V

    return-void
.end method

.method private static synthetic lambda$isApnContextAttached$7(ILjava/lang/Integer;)Z
    .locals 0

    .line 3705
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$isEnterpriseUse$5(Lcom/android/internal/telephony/dataconnection/ApnContext;)Z
    .locals 1

    .line 1819
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeBitmask()I

    move-result p0

    const/16 v0, 0x4000

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$startHandover$3(Ljava/util/function/Consumer;Ljava/lang/Integer;)V
    .locals 0

    .line 1110
    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    invoke-direct {p0, p2, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->onHandoverStarted(ILjava/util/function/Consumer;)V

    return-void
.end method

.method private synthetic lambda$tearDownData$4(ILjava/lang/Object;)V
    .locals 5

    const/4 v0, 0x0

    .line 1187
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->setPduSessionId(I)V

    .line 1188
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    iget v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    iget v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    const v4, 0x40003

    .line 1189
    invoke-virtual {p0, v4, v3, v0, p2}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object p2

    .line 1188
    invoke-virtual {v1, v2, p1, p2}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->deactivateDataCall(IILandroid/os/Message;)V

    .line 1190
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->setDeactivateDataCallReason(I)V

    return-void
.end method

.method private static synthetic lambda$updatePcscfAddr$6(I)[Ljava/lang/String;
    .locals 0

    .line 3645
    new-array p0, p0, [Ljava/lang/String;

    return-object p0
.end method

.method public static makeDataConnection(Lcom/android/internal/telephony/Phone;ILcom/android/internal/telephony/dataconnection/DcTracker;Lcom/android/internal/telephony/dataconnection/DataServiceManager;Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;Lcom/android/internal/telephony/dataconnection/DcController;)Lcom/android/internal/telephony/dataconnection/DataConnection;
    .locals 10

    .line 477
    invoke-virtual {p3}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->getTransportType()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    const-string v0, "C"

    goto :goto_0

    :cond_0
    const-string v0, "I"

    .line 481
    :goto_0
    new-instance v9, Lcom/android/internal/telephony/dataconnection/DataConnection;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "-"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mInstanceNumber:Ljava/util/concurrent/atomic/AtomicInteger;

    .line 482
    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicInteger;->incrementAndGet()I

    move-result v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    move-object v1, v9

    move-object v2, p0

    move v4, p1

    move-object v5, p2

    move-object v6, p3

    move-object v7, p4

    move-object v8, p5

    invoke-direct/range {v1 .. v8}, Lcom/android/internal/telephony/dataconnection/DataConnection;-><init>(Lcom/android/internal/telephony/Phone;Ljava/lang/String;ILcom/android/internal/telephony/dataconnection/DcTracker;Lcom/android/internal/telephony/dataconnection/DataServiceManager;Lcom/android/internal/telephony/dataconnection/DcTesterFailBringUpAll;Lcom/android/internal/telephony/dataconnection/DcController;)V

    .line 484
    invoke-virtual {v9}, Lcom/android/internal/telephony/StateMachine;->start()V

    .line 485
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p1, "Made "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v9, p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-object v9
.end method

.method private static msgToString(Landroid/os/Message;)Ljava/lang/String;
    .locals 5

    if-nez p0, :cond_0

    const-string p0, "null"

    goto :goto_0

    .line 3747
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "{what="

    .line 3749
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3750
    iget v1, p0, Landroid/os/Message;->what:I

    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->cmdToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " when="

    .line 3752
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3753
    invoke-virtual {p0}, Landroid/os/Message;->getWhen()J

    move-result-wide v1

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v3

    sub-long/2addr v1, v3

    invoke-static {v1, v2, v0}, Lcom/android/internal/telephony/TimeUtils;->formatDuration(JLjava/lang/StringBuilder;)V

    .line 3755
    iget v1, p0, Landroid/os/Message;->arg1:I

    if-eqz v1, :cond_1

    const-string v1, " arg1="

    .line 3756
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3757
    iget v1, p0, Landroid/os/Message;->arg1:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 3760
    :cond_1
    iget v1, p0, Landroid/os/Message;->arg2:I

    if-eqz v1, :cond_2

    const-string v1, " arg2="

    .line 3761
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3762
    iget v1, p0, Landroid/os/Message;->arg2:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 3765
    :cond_2
    iget-object v1, p0, Landroid/os/Message;->obj:Ljava/lang/Object;

    if-eqz v1, :cond_3

    const-string v1, " obj="

    .line 3766
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3767
    iget-object v1, p0, Landroid/os/Message;->obj:Ljava/lang/Object;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    :cond_3
    const-string v1, " target="

    .line 3770
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3771
    invoke-virtual {p0}, Landroid/os/Message;->getTarget()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " replyTo="

    .line 3773
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3774
    iget-object p0, p0, Landroid/os/Message;->replyTo:Landroid/os/Messenger;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string/jumbo p0, "}"

    .line 3776
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3778
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method private notifyAllWithEvent(Lcom/android/internal/telephony/dataconnection/ApnContext;ILjava/lang/String;)V
    .locals 5

    .line 1211
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    .line 1212
    iget-object v2, v1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    if-ne v2, p1, :cond_0

    goto :goto_0

    :cond_0
    if-eqz p3, :cond_1

    .line 1214
    invoke-virtual {v2, p3}, Lcom/android/internal/telephony/dataconnection/ApnContext;->setReason(Ljava/lang/String;)V

    .line 1215
    :cond_1
    new-instance v3, Landroid/util/Pair;

    iget v4, v1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mConnectionGeneration:I

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-direct {v3, v2, v4}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 1216
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    iget v1, v1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mRequestType:I

    const/4 v4, -0x1

    invoke-virtual {v2, p2, v1, v4, v3}, Landroid/os/Handler;->obtainMessage(IIILjava/lang/Object;)Landroid/os/Message;

    move-result-object v1

    .line 1218
    invoke-static {v1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;)Landroid/os/AsyncResult;

    .line 1219
    invoke-virtual {v1}, Landroid/os/Message;->sendToTarget()V

    goto :goto_0

    :cond_2
    return-void
.end method

.method private notifyConnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;IIZ)V
    .locals 5

    const/4 v0, 0x0

    if-eqz p1, :cond_2

    .line 1235
    iget-object v1, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mOnCompletedMsg:Landroid/os/Message;

    if-eqz v1, :cond_2

    .line 1238
    iput-object v0, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mOnCompletedMsg:Landroid/os/Message;

    .line 1239
    iget-object v0, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    .line 1241
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 1242
    iget p1, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mRequestType:I

    iput p1, v1, Landroid/os/Message;->arg1:I

    .line 1243
    iput p3, v1, Landroid/os/Message;->arg2:I

    if-nez p2, :cond_0

    .line 1246
    iput-wide v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCreateTime:J

    .line 1247
    invoke-static {v1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;)Landroid/os/AsyncResult;

    goto :goto_0

    .line 1249
    :cond_0
    iput p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailCause:I

    .line 1250
    iput-wide v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailTime:J

    if-nez p2, :cond_1

    const/high16 p2, 0x10000

    .line 1254
    :cond_1
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    new-instance p3, Ljava/lang/Throwable;

    .line 1255
    invoke-static {p2}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v4

    invoke-direct {p3, v4}, Ljava/lang/Throwable;-><init>(Ljava/lang/String;)V

    .line 1254
    invoke-static {v1, p1, p3}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 1258
    :goto_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "notifyConnectCompleted at "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string p3, " cause="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1259
    invoke-static {p2}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p3, " connectionCompletedMsg="

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1260
    invoke-static {v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->msgToString(Landroid/os/Message;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1258
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1263
    invoke-virtual {v1}, Landroid/os/Message;->sendToTarget()V

    :cond_2
    if-eqz p4, :cond_3

    .line 1266
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Send to all. "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p3, " "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    const p1, 0x42023

    .line 1268
    invoke-static {p2}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object p2

    .line 1267
    invoke-direct {p0, v0, p1, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->notifyAllWithEvent(Lcom/android/internal/telephony/dataconnection/ApnContext;ILjava/lang/String;)V

    :cond_3
    return-void
.end method

.method private notifyDataConnectionState()V
    .locals 2

    .line 2460
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isEnterpriseUse()Z

    move-result v0

    if-nez v0, :cond_0

    .line 2461
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getPreciseDataConnectionState()Landroid/telephony/PreciseDataConnectionState;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/Phone;->notifyDataConnection(Landroid/telephony/PreciseDataConnectionState;)V

    goto :goto_0

    .line 2463
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "notifyDataConnectionState: Skipping for enterprise; state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getState()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method private notifyDisconnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;Z)V
    .locals 7

    const-string v0, "NotifyDisconnectCompleted"

    .line 1278
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    if-eqz p1, :cond_2

    .line 1283
    iget-object v1, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;->mOnCompletedMsg:Landroid/os/Message;

    if-eqz v1, :cond_2

    .line 1286
    iput-object v0, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;->mOnCompletedMsg:Landroid/os/Message;

    .line 1287
    iget-object v2, v1, Landroid/os/Message;->obj:Ljava/lang/Object;

    instance-of v3, v2, Lcom/android/internal/telephony/dataconnection/ApnContext;

    if-eqz v3, :cond_0

    .line 1288
    move-object v0, v2

    check-cast v0, Lcom/android/internal/telephony/dataconnection/ApnContext;

    .line 1290
    :cond_0
    iget-object v2, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;->mReason:Ljava/lang/String;

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    .line 1292
    invoke-virtual {v1}, Landroid/os/Message;->toString()Ljava/lang/String;

    move-result-object v5

    aput-object v5, v3, v4

    const/4 v4, 0x1

    .line 1293
    iget-object v5, v1, Landroid/os/Message;->obj:Ljava/lang/Object;

    instance-of v6, v5, Ljava/lang/String;

    if-eqz v6, :cond_1

    check-cast v5, Ljava/lang/String;

    goto :goto_0

    :cond_1
    const-string v5, "<no-reason>"

    :goto_0
    aput-object v5, v3, v4

    const-string v4, "msg=%s msg.obj=%s"

    .line 1292
    invoke-static {v4, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1295
    invoke-static {v1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;)Landroid/os/AsyncResult;

    .line 1296
    invoke-virtual {v1}, Landroid/os/Message;->sendToTarget()V

    move-object v1, v0

    move-object v0, v2

    goto :goto_1

    :cond_2
    move-object v1, v0

    :goto_1
    if-eqz p2, :cond_4

    if-nez v0, :cond_3

    const/high16 p2, 0x10000

    .line 1300
    invoke-static {p2}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v0

    :cond_3
    const p2, 0x4200f

    .line 1302
    invoke-direct {p0, v1, p2, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->notifyAllWithEvent(Lcom/android/internal/telephony/dataconnection/ApnContext;ILjava/lang/String;)V

    .line 1304
    :cond_4
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "NotifyDisconnectCompleted DisconnectParams="

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-void
.end method

.method private onHandoverStarted(ILjava/util/function/Consumer;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/function/Consumer<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 1126
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onHandoverStarted: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->toStringSimple()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 1127
    invoke-static {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isResultCodeSuccess(I)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x1

    .line 1128
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->setHandoverState(I)V

    .line 1130
    :cond_0
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {p2, p0}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    return-void
.end method

.method private onRquestHandoverFailed(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V
    .locals 3

    const v0, 0x40023

    .line 1015
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    const/high16 v0, 0x10000

    const/4 v1, -0x1

    const/4 v2, 0x0

    .line 1016
    invoke-direct {p0, p1, v0, v1, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->notifyConnectCompleted(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;IIZ)V

    return-void
.end method

.method private onSetupConnectionCompleted(ILandroid/telephony/data/DataCallResponse;Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;
    .locals 2

    .line 1386
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onSetupConnectionCompleted: resultCode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", response="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1387
    iget v0, p3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mTag:I

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    if-eq v0, v1, :cond_0

    .line 1389
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "onSetupConnectionCompleted stale cp.tag="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mTag:I

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, ", mtag="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1391
    sget-object p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_STALE:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    goto/16 :goto_0

    :cond_0
    const/4 v0, 0x4

    const v1, 0x10001

    if-ne p1, v0, :cond_1

    .line 1393
    sget-object p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_RADIO_NOT_AVAILABLE:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 1394
    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->mFailCause:I

    goto/16 :goto_0

    :cond_1
    const/4 v0, 0x5

    if-ne p1, v0, :cond_2

    .line 1396
    sget-object p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_DATA_SERVICE_SPECIFIC_ERROR:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const p1, 0x10009

    .line 1397
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->mFailCause:I

    goto/16 :goto_0

    :cond_2
    const/4 v0, 0x2

    if-ne p1, v0, :cond_3

    .line 1399
    sget-object p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_INVALID_ARG:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const p1, 0x10002

    .line 1400
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->mFailCause:I

    goto/16 :goto_0

    .line 1401
    :cond_3
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result p1

    if-eqz p1, :cond_5

    .line 1402
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result p0

    if-ne p0, v1, :cond_4

    .line 1403
    sget-object p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_RADIO_NOT_AVAILABLE:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 1404
    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->mFailCause:I

    goto/16 :goto_0

    .line 1406
    :cond_4
    sget-object p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_DATA_SERVICE_SPECIFIC_ERROR:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 1407
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result p1

    invoke-static {p1}, Landroid/telephony/DataFailCause;->getFailCause(I)I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->mFailCause:I

    goto/16 :goto_0

    .line 1409
    :cond_5
    iget-object p1, p3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeBitmask()I

    move-result p1

    const/16 v0, 0x4000

    if-ne p1, v0, :cond_7

    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcController:Lcom/android/internal/telephony/dataconnection/DcController;

    .line 1410
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result v1

    invoke-virtual {p1, v1}, Lcom/android/internal/telephony/dataconnection/DcController;->getActiveDcByCid(I)Lcom/android/internal/telephony/dataconnection/DataConnection;

    move-result-object p1

    if-eqz p1, :cond_7

    .line 1411
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcController:Lcom/android/internal/telephony/dataconnection/DcController;

    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result p3

    invoke-virtual {p1, p3}, Lcom/android/internal/telephony/dataconnection/DcController;->getTrafficDescriptorsForCid(I)Ljava/util/List;

    move-result-object p1

    .line 1412
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getTrafficDescriptors()Ljava/util/List;

    move-result-object p3

    invoke-interface {p1, p3}, Ljava/util/List;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_6

    .line 1413
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Updating traffic descriptors: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getTrafficDescriptors()Ljava/util/List;

    move-result-object p3

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1414
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcController:Lcom/android/internal/telephony/dataconnection/DcController;

    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result p3

    invoke-virtual {p1, p3}, Lcom/android/internal/telephony/dataconnection/DcController;->getActiveDcByCid(I)Lcom/android/internal/telephony/dataconnection/DataConnection;

    move-result-object p1

    invoke-virtual {p1, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateTrafficDescriptors(Landroid/telephony/data/DataCallResponse;)V

    .line 1415
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    const p3, 0x42039

    invoke-virtual {p1, p3}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p1}, Landroid/os/Message;->sendToTarget()V

    .line 1417
    :cond_6
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "DataConnection already exists for cid: "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1418
    sget-object p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_DUPLICATE_CID:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const p1, 0x10007

    .line 1419
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->mFailCause:I

    goto :goto_0

    .line 1420
    :cond_7
    iget-object p1, p3, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnTypeBitmask()I

    move-result p1

    if-ne p1, v0, :cond_8

    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcController:Lcom/android/internal/telephony/dataconnection/DcController;

    .line 1421
    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/DcController;->isDefaultDataActive()Z

    move-result p1

    if-nez p1, :cond_8

    const-string p1, "No default data connection currently active"

    .line 1422
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1423
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    .line 1424
    sget-object p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_NO_DEFAULT_CONNECTION:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    const p1, 0x10008

    .line 1425
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->mFailCause:I

    goto :goto_0

    :cond_8
    const-string p1, "onSetupConnectionCompleted received successful DataCallResponse"

    .line 1427
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1428
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    .line 1429
    invoke-virtual {p2}, Landroid/telephony/data/DataCallResponse;->getPduSessionId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->setPduSessionId(I)V

    .line 1430
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updatePcscfAddr(Landroid/telephony/data/DataCallResponse;)V

    .line 1431
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateResponseFields(Landroid/telephony/data/DataCallResponse;)V

    .line 1432
    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateLinkProperty(Landroid/telephony/data/DataCallResponse;)Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;

    move-result-object p0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->setupResult:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    :goto_0
    return-object p0
.end method

.method private releasePduSessionId(Ljava/lang/Runnable;)V
    .locals 2

    .line 1197
    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    .line 1199
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getPduSessionId()I

    move-result v0

    if-eqz v0, :cond_0

    const v0, 0x40026

    .line 1200
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    .line 1201
    iput-object p1, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 1202
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object p1, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getPduSessionId()I

    move-result p0

    invoke-interface {p1, v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->releasePduSessionId(Landroid/os/Message;I)V

    goto :goto_0

    .line 1206
    :cond_0
    invoke-interface {p1}, Ljava/lang/Runnable;->run()V

    :goto_0
    return-void
.end method

.method private requestHandover(ZLcom/android/internal/telephony/dataconnection/DataConnection;ILcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;Landroid/os/Message;Landroid/telephony/data/DataProfile;ZZ)V
    .locals 15

    move-object v0, p0

    move-object/from16 v1, p2

    move-object/from16 v2, p4

    if-nez p1, :cond_2

    const-string v3, "requestHandover: Not in correct state"

    .line 1026
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 1027
    invoke-static/range {p3 .. p3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isResultCodeSuccess(I)Z

    move-result v3

    if-eqz v3, :cond_1

    if-eqz v1, :cond_0

    const-string v3, "requestHandover: Not in correct state - Success result code"

    .line 1029
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 1031
    invoke-direct/range {p2 .. p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->cancelHandover()V

    goto :goto_0

    :cond_0
    const-string v1, "requestHandover: Not in correct state - Success result code - srcdc = null"

    .line 1033
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 1037
    :cond_1
    :goto_0
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->onRquestHandoverFailed(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V

    return-void

    .line 1039
    :cond_2
    invoke-static/range {p3 .. p3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isResultCodeSuccess(I)Z

    move-result v3

    if-nez v3, :cond_3

    .line 1041
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "requestHandover: Non success result code from DataService, setupDataCall will not be called, result code = "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1043
    invoke-static/range {p3 .. p3}, Landroid/telephony/data/DataServiceCallback;->resultCodeToString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1041
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 1045
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->onRquestHandoverFailed(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V

    return-void

    :cond_3
    if-nez v1, :cond_4

    const-string v1, "requestHandover: Cannot find source data connection."

    .line 1050
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    .line 1051
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->onRquestHandoverFailed(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V

    return-void

    .line 1060
    :cond_4
    invoke-virtual/range {p2 .. p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkAgent()Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    move-result-object v3

    iput-object v3, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverSourceNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    if-nez v3, :cond_5

    .line 1062
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "requestHandover: Cannot get network agent from the source dc "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual/range {p2 .. p2}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    .line 1063
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->onRquestHandoverFailed(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V

    return-void

    .line 1067
    :cond_5
    invoke-virtual/range {p2 .. p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object v9

    if-eqz v9, :cond_8

    .line 1068
    invoke-virtual {v9}, Landroid/net/LinkProperties;->getLinkAddresses()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_6

    goto/16 :goto_2

    .line 1075
    :cond_6
    iget-object v3, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverLocalLog:Lcom/android/internal/telephony/LocalLog;

    const-string v4, "Handover started. Preserved the agent."

    invoke-virtual {v3, v4}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 1076
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Get the handover source network agent: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverSourceNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    const/4 v8, 0x3

    .line 1080
    invoke-virtual/range {p6 .. p6}, Landroid/telephony/data/DataProfile;->getApn()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    if-nez v3, :cond_7

    move-object v12, v4

    goto :goto_1

    .line 1081
    :cond_7
    new-instance v3, Landroid/telephony/data/TrafficDescriptor;

    invoke-virtual/range {p6 .. p6}, Landroid/telephony/data/DataProfile;->getApn()Ljava/lang/String;

    move-result-object v5

    invoke-direct {v3, v5, v4}, Landroid/telephony/data/TrafficDescriptor;-><init>(Ljava/lang/String;[B)V

    move-object v12, v3

    :goto_1
    const/4 v13, 0x1

    .line 1084
    iget-object v3, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    iget v4, v2, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mRilRat:I

    .line 1085
    invoke-static {v4}, Landroid/telephony/ServiceState;->rilRadioTechnologyToAccessNetworkType(I)I

    move-result v4

    .line 1091
    invoke-virtual/range {p2 .. p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getPduSessionId()I

    move-result v10

    .line 1092
    invoke-virtual/range {p2 .. p2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getSliceInfo()Landroid/telephony/data/NetworkSliceInfo;

    move-result-object v11

    move-object/from16 v5, p6

    move/from16 v6, p7

    move/from16 v7, p8

    move-object/from16 v14, p5

    .line 1084
    invoke-virtual/range {v3 .. v14}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->setupDataCall(ILandroid/telephony/data/DataProfile;ZZILandroid/net/LinkProperties;ILandroid/telephony/data/NetworkSliceInfo;Landroid/telephony/data/TrafficDescriptor;ZLandroid/os/Message;)V

    .line 1096
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v1

    iget-object v0, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    iget v2, v2, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;->mRilRat:I

    .line 1097
    invoke-virtual/range {p6 .. p6}, Landroid/telephony/data/DataProfile;->getProfileId()I

    move-result v3

    invoke-virtual/range {p6 .. p6}, Landroid/telephony/data/DataProfile;->getApn()Ljava/lang/String;

    move-result-object v4

    invoke-virtual/range {p6 .. p6}, Landroid/telephony/data/DataProfile;->getProtocolType()I

    move-result v5

    move-object p0, v1

    move/from16 p1, v0

    move/from16 p2, v2

    move/from16 p3, v3

    move-object/from16 p4, v4

    move/from16 p5, v5

    .line 1096
    invoke-virtual/range {p0 .. p5}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeSetupDataCall(IIILjava/lang/String;I)V

    return-void

    .line 1069
    :cond_8
    :goto_2
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "requestHandover: Can\'t find link properties of handover data connection. dc="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    .line 1071
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->onRquestHandoverFailed(Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;)V

    return-void
.end method

.method private sendRunnableMessage(ILjava/util/function/Consumer;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/function/Consumer<",
            "Ljava/lang/Boolean;",
            ">;)V"
        }
    .end annotation

    .line 1308
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/StateMachine;->sendMessage(ILjava/lang/Object;)V

    return-void
.end method

.method private setLinkProperties(Landroid/telephony/data/DataCallResponse;Landroid/net/LinkProperties;)Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;
    .locals 8

    .line 2083
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "net."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x2

    new-array v2, v1, [Ljava/lang/String;

    .line 2085
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "dns1"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    aput-object v3, v2, v4

    .line 2086
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "dns2"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v3, 0x1

    aput-object v0, v2, v3

    .line 2087
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isDnsOk([Ljava/lang/String;)Z

    move-result v0

    .line 2093
    invoke-virtual {p2}, Landroid/net/LinkProperties;->clear()V

    .line 2095
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result v3

    if-nez v3, :cond_c

    .line 2098
    :try_start_0
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p2, v3}, Landroid/net/LinkProperties;->setInterfaceName(Ljava/lang/String;)V

    .line 2101
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getAddresses()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    if-lez v3, :cond_b

    .line 2102
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getAddresses()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_0
    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_1

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/net/LinkAddress;

    .line 2103
    invoke-virtual {v5}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v6

    invoke-virtual {v6}, Ljava/net/InetAddress;->isAnyLocalAddress()Z

    move-result v6

    if-nez v6, :cond_0

    .line 2105
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "addr/pl="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Landroid/net/LinkAddress;->getAddress()Ljava/net/InetAddress;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v7, "/"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2106
    invoke-virtual {v5}, Landroid/net/LinkAddress;->getPrefixLength()I

    move-result v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 2105
    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2108
    invoke-virtual {p2, v5}, Landroid/net/LinkProperties;->addLinkAddress(Landroid/net/LinkAddress;)Z

    goto :goto_0

    .line 2117
    :cond_1
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getDnsAddresses()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    if-lez v3, :cond_3

    .line 2118
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getDnsAddresses()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_2
    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_6

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/net/InetAddress;

    .line 2119
    invoke-virtual {v1}, Ljava/net/InetAddress;->isAnyLocalAddress()Z

    move-result v2

    if-nez v2, :cond_2

    .line 2120
    invoke-virtual {p2, v1}, Landroid/net/LinkProperties;->addDnsServer(Ljava/net/InetAddress;)Z

    goto :goto_1

    :cond_3
    if-eqz v0, :cond_a

    :goto_2
    if-ge v4, v1, :cond_6

    .line 2124
    aget-object v0, v2, v4

    .line 2125
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 2126
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v3
    :try_end_0
    .catch Ljava/net/UnknownHostException; {:try_start_0 .. :try_end_0} :catch_1

    if-eqz v3, :cond_4

    goto :goto_3

    .line 2129
    :cond_4
    :try_start_1
    invoke-static {v0}, Landroid/net/InetAddresses;->parseNumericAddress(Ljava/lang/String;)Ljava/net/InetAddress;

    move-result-object v0
    :try_end_1
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/net/UnknownHostException; {:try_start_1 .. :try_end_1} :catch_1

    .line 2133
    :try_start_2
    invoke-virtual {v0}, Ljava/net/InetAddress;->isAnyLocalAddress()Z

    move-result v3

    if-nez v3, :cond_5

    .line 2134
    invoke-virtual {p2, v0}, Landroid/net/LinkProperties;->addDnsServer(Ljava/net/InetAddress;)Z

    :cond_5
    :goto_3
    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    .line 2131
    :catch_0
    new-instance v1, Ljava/net/UnknownHostException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Non-numeric dns addr="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/net/UnknownHostException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 2142
    :cond_6
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getPcscfAddresses()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lez v0, :cond_7

    .line 2143
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getPcscfAddresses()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_4
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_7

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/net/InetAddress;

    .line 2144
    invoke-virtual {p2, v1}, Landroid/net/LinkProperties;->addPcscfServer(Ljava/net/InetAddress;)Z

    goto :goto_4

    .line 2148
    :cond_7
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getGatewayAddresses()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_5
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_9

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    move-object v4, v1

    check-cast v4, Ljava/net/InetAddress;

    .line 2149
    instance-of v1, v4, Ljava/net/Inet6Address;

    if-eqz v1, :cond_8

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getMtuV6()I

    move-result v1

    goto :goto_6

    .line 2150
    :cond_8
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getMtuV4()I

    move-result v1

    :goto_6
    move v7, v1

    .line 2153
    new-instance v1, Landroid/net/RouteInfo;

    const/4 v3, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x1

    move-object v2, v1

    invoke-direct/range {v2 .. v7}, Landroid/net/RouteInfo;-><init>(Landroid/net/IpPrefix;Ljava/net/InetAddress;Ljava/lang/String;II)V

    invoke-virtual {p2, v1}, Landroid/net/LinkProperties;->addRoute(Landroid/net/RouteInfo;)Z

    goto :goto_5

    .line 2160
    :cond_9
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getMtu()I

    move-result v0

    invoke-virtual {p2, v0}, Landroid/net/LinkProperties;->setMtu(I)V

    .line 2162
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->SUCCESS:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    goto :goto_7

    .line 2138
    :cond_a
    new-instance v0, Ljava/net/UnknownHostException;

    const-string v1, "Empty dns response and no system default dns"

    invoke-direct {v0, v1}, Ljava/net/UnknownHostException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 2112
    :cond_b
    new-instance v0, Ljava/net/UnknownHostException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "no address for ifname="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2113
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getInterfaceName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/net/UnknownHostException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_2
    .catch Ljava/net/UnknownHostException; {:try_start_2 .. :try_end_2} :catch_1

    :catch_1
    move-exception v0

    .line 2164
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setLinkProperties: UnknownHostException "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2165
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_INVALID_ARG:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    goto :goto_7

    .line 2168
    :cond_c
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->ERROR_DATA_SERVICE_SPECIFIC_ERROR:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 2172
    :goto_7
    sget-object v1, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->SUCCESS:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    if-eq v0, v1, :cond_d

    .line 2174
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setLinkProperties: error clearing LinkProperties status="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2175
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getCause()I

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " result="

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2174
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 2177
    invoke-virtual {p2}, Landroid/net/LinkProperties;->clear()V

    :cond_d
    return-object v0
.end method

.method private shouldRestrictNetwork()Z
    .locals 4

    .line 1733
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/dataconnection/ApnContext;

    .line 1734
    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/dataconnection/ApnContext;->hasRestrictedRequests(Z)Z

    move-result v1

    if-eqz v1, :cond_0

    move v0, v2

    goto :goto_0

    :cond_1
    move v0, v3

    :goto_0
    if-nez v0, :cond_2

    return v3

    .line 1748
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/dataconnection/ApnSettingUtils;->isMetered(Landroid/telephony/data/ApnSetting;Lcom/android/internal/telephony/Phone;)Z

    move-result v0

    if-nez v0, :cond_3

    return v3

    .line 1754
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataEnabledSettings()Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DataEnabledSettings;->isDataEnabled()Z

    move-result v0

    if-nez v0, :cond_4

    return v2

    .line 1760
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-virtual {v0}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getDataRoamingEnabled()Z

    move-result v0

    if-nez v0, :cond_5

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result p0

    if-eqz p0, :cond_5

    return v2

    :cond_5
    return v3
.end method

.method static slog(Ljava/lang/String;)V
    .locals 1

    const-string v0, "DC"

    .line 3784
    invoke-static {v0, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private syncQosToNetworkAgent()V
    .locals 1

    .line 662
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    .line 663
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mQosBearerSessions:Ljava/util/List;

    if-nez p0, :cond_0

    .line 665
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->updateQosBearerSessions(Ljava/util/List;)V

    return-void

    .line 668
    :cond_0
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->updateQosBearerSessions(Ljava/util/List;)V

    return-void
.end method

.method private tearDownData(Ljava/lang/Object;)V
    .locals 6

    const/4 v0, 0x3

    const/4 v1, 0x1

    if-eqz p1, :cond_2

    .line 1167
    instance-of v2, p1, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    if-eqz v2, :cond_2

    .line 1168
    move-object v2, p1

    check-cast v2, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    .line 1169
    iget-object v3, v2, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;->mApnContext:Lcom/android/internal/telephony/dataconnection/ApnContext;

    .line 1170
    iget-object v4, v2, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;->mReason:Ljava/lang/String;

    const-string v5, "radioTurnedOff"

    invoke-static {v4, v5}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_1

    iget-object v4, v2, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;->mReason:Ljava/lang/String;

    const-string v5, "pdpReset"

    .line 1171
    invoke-static {v4, v5}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_0

    goto :goto_0

    .line 1173
    :cond_0
    iget v2, v2, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;->mReleaseType:I

    if-ne v2, v0, :cond_3

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x2

    goto :goto_1

    :cond_2
    const/4 v3, 0x0

    :cond_3
    move v0, v1

    .line 1178
    :goto_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "tearDownData. mCid="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ", reason="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1179
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1180
    invoke-static {v3, v1}, Lcom/android/internal/telephony/dataconnection/ApnContext;->requestLog(Lcom/android/internal/telephony/dataconnection/ApnContext;Ljava/lang/String;)V

    .line 1185
    new-instance v1, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;ILjava/lang/Object;)V

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->releasePduSessionId(Ljava/lang/Runnable;)V

    return-void
.end method

.method private updateLinkBandwidthsFromBandwidthEstimator(II)V
    .locals 2

    .line 1630
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateLinkBandwidthsFromBandwidthEstimator, UL= "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " DL= "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    const/4 v0, 0x1

    const/4 v1, 0x0

    if-lez p2, :cond_0

    .line 1636
    iput p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDownlinkBandwidth:I

    move p2, v0

    goto :goto_0

    :cond_0
    move p2, v1

    :goto_0
    if-lez p1, :cond_1

    .line 1640
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    goto :goto_1

    :cond_1
    move v0, v1

    :goto_1
    if-eqz p2, :cond_2

    if-nez v0, :cond_3

    .line 1645
    :cond_2
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->fallBackToCarrierConfigValues(ZZ)V

    .line 1647
    :cond_3
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    if-eqz p1, :cond_4

    .line 1648
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p2

    invoke-virtual {p1, p2, p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sendNetworkCapabilities(Landroid/net/NetworkCapabilities;Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    :cond_4
    return-void
.end method

.method private updateLinkBandwidthsFromCarrierConfig(I)V
    .locals 2

    .line 1586
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1587
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getDisplayInfoController()Lcom/android/internal/telephony/DisplayInfoController;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/DisplayInfoController;->getTelephonyDisplayInfo()Landroid/telephony/TelephonyDisplayInfo;

    move-result-object p1

    .line 1586
    invoke-static {p1}, Lcom/android/internal/telephony/data/DataConfigManager;->getDataConfigNetworkType(Landroid/telephony/TelephonyDisplayInfo;)Ljava/lang/String;

    move-result-object p1

    .line 1589
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateLinkBandwidthsFromCarrierConfig: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1591
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDct:Lcom/android/internal/telephony/dataconnection/DcTracker;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getLinkBandwidthsFromCarrierConfig(Ljava/lang/String;)Landroid/util/Pair;

    move-result-object p1

    if-nez p1, :cond_0

    .line 1593
    new-instance p1, Landroid/util/Pair;

    const/16 v0, 0xe

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-direct {p1, v1, v0}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 1595
    :cond_0
    iget-object v0, p1, Landroid/util/Pair;->first:Ljava/lang/Object;

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDownlinkBandwidth:I

    .line 1596
    iget-object p1, p1, Landroid/util/Pair;->second:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    return-void
.end method

.method private updateLinkBandwidthsFromModem(Ljava/util/List;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/LinkCapacityEstimate;",
            ">;)V"
        }
    .end annotation

    .line 1601
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateLinkBandwidthsFromModem: lceList="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 1604
    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/LinkCapacityEstimate;

    .line 1606
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getHalVersion()Lcom/android/internal/telephony/HalVersion;

    move-result-object v1

    sget-object v2, Lcom/android/internal/telephony/RIL;->RADIO_HAL_VERSION_1_2:Lcom/android/internal/telephony/HalVersion;

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/HalVersion;->greaterOrEqual(Lcom/android/internal/telephony/HalVersion;)Z

    move-result v1

    const/4 v2, 0x1

    if-nez v1, :cond_1

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1607
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getLceStatus()I

    move-result v1

    if-ne v1, v2, :cond_0

    goto :goto_0

    :cond_0
    move v2, v0

    goto :goto_3

    .line 1608
    :cond_1
    :goto_0
    invoke-virtual {p1}, Landroid/telephony/LinkCapacityEstimate;->getDownlinkCapacityKbps()I

    move-result v1

    const/4 v3, -0x1

    if-eq v1, v3, :cond_2

    .line 1609
    invoke-virtual {p1}, Landroid/telephony/LinkCapacityEstimate;->getDownlinkCapacityKbps()I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDownlinkBandwidth:I

    move v1, v2

    goto :goto_1

    :cond_2
    move v1, v0

    .line 1612
    :goto_1
    invoke-virtual {p1}, Landroid/telephony/LinkCapacityEstimate;->getUplinkCapacityKbps()I

    move-result v4

    if-eq v4, v3, :cond_3

    .line 1613
    invoke-virtual {p1}, Landroid/telephony/LinkCapacityEstimate;->getUplinkCapacityKbps()I

    move-result p1

    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    goto :goto_2

    :cond_3
    move v2, v0

    :goto_2
    move v0, v1

    :goto_3
    if-eqz v0, :cond_4

    if-nez v2, :cond_5

    .line 1619
    :cond_4
    invoke-direct {p0, v0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->fallBackToCarrierConfigValues(ZZ)V

    .line 1622
    :cond_5
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    if-eqz p1, :cond_6

    .line 1623
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v0

    invoke-virtual {p1, v0, p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sendNetworkCapabilities(Landroid/net/NetworkCapabilities;Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    :cond_6
    return-void
.end method

.method private updateLinkPropertiesHttpProxy()V
    .locals 3

    .line 538
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 539
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getProxyAddressAsString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 543
    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getProxyPort()I

    move-result v0

    const/4 v1, -0x1

    if-ne v0, v1, :cond_1

    const/16 v0, 0x1f90

    .line 547
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 548
    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting;->getProxyAddressAsString()Ljava/lang/String;

    move-result-object v1

    .line 547
    invoke-static {v1, v0}, Landroid/net/ProxyInfo;->buildDirectProxy(Ljava/lang/String;I)Landroid/net/ProxyInfo;

    move-result-object v0

    .line 549
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {v1, v0}, Landroid/net/LinkProperties;->setHttpProxy(Landroid/net/ProxyInfo;)V
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 551
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onDataSetupComplete: NumberFormatException making ProxyProperties ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 552
    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getProxyPort()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "): "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 551
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->loge(Ljava/lang/String;)V

    :cond_2
    :goto_0
    return-void
.end method

.method private updateScore()V
    .locals 3

    .line 3926
    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mScore:I

    .line 3927
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->calculateScore()I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mScore:I

    if-eq v0, v1, :cond_0

    .line 3928
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    if-eqz v1, :cond_0

    .line 3929
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Updating score from "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " to "

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mScore:I

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 3930
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mScore:I

    invoke-virtual {v0, v1, p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sendNetworkScore(ILcom/android/internal/telephony/dataconnection/DataConnection;)V

    :cond_0
    return-void
.end method

.method private updateSuspendState()V
    .locals 4

    .line 2425
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    if-nez v0, :cond_0

    .line 2426
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "Setting suspend state without a NetworkAgent"

    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 2431
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mActiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-ne v0, v1, :cond_3

    .line 2434
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->isEmergencyApn()Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_0

    .line 2437
    :cond_1
    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataRegState:I

    if-eqz v0, :cond_2

    goto :goto_1

    .line 2440
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isConcurrentVoiceAndDataAllowed()Z

    move-result v0

    if-nez v0, :cond_3

    .line 2441
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCallTracker()Lcom/android/internal/telephony/CallTracker;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/CallTracker;->getState()Lcom/android/internal/telephony/PhoneConstants$State;

    move-result-object v0

    sget-object v1, Lcom/android/internal/telephony/PhoneConstants$State;->IDLE:Lcom/android/internal/telephony/PhoneConstants$State;

    if-eq v0, v1, :cond_3

    goto :goto_1

    :cond_3
    :goto_0
    move v2, v3

    .line 2446
    :goto_1
    iget-boolean v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mIsSuspended:Z

    if-eq v0, v2, :cond_4

    .line 2447
    iput-boolean v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mIsSuspended:Z

    .line 2451
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isActive()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 2452
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->notifyDataConnectionState()V

    :cond_4
    return-void
.end method

.method private updateTcpBufferSizes(I)V
    .locals 10

    .line 1487
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    const/16 v1, 0xe

    const/16 v2, 0x13

    if-ne p1, v1, :cond_0

    .line 1489
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->isUsingCarrierAggregation()Z

    move-result v0

    if-eqz v0, :cond_0

    move p1, v2

    .line 1492
    :cond_0
    invoke-static {p1}, Landroid/telephony/ServiceState;->rilRadioTechnologyToString(I)Ljava/lang/String;

    move-result-object v0

    sget-object v3, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v0, v3}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v0

    const/4 v3, 0x7

    if-eq p1, v3, :cond_1

    const/16 v3, 0x8

    if-eq p1, v3, :cond_1

    const/16 v3, 0xc

    if-ne p1, v3, :cond_2

    :cond_1
    const-string v0, "evdo"

    .line 1503
    :cond_2
    iget v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    const-string v4, "nr"

    const/4 v5, 0x1

    if-ne v3, v5, :cond_4

    if-eq p1, v1, :cond_3

    if-ne p1, v2, :cond_4

    .line 1505
    :cond_3
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->isNRConnected()Z

    move-result v1

    if-eqz v1, :cond_4

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1506
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/ServiceStateTracker;->getNrContextIds()Ljava/util/Set;

    move-result-object v1

    iget v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v1, v3}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_4

    move-object v0, v4

    .line 1510
    :cond_4
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v3, "updateTcpBufferSizes: "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1513
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const v3, 0x1070081

    invoke-virtual {v1, v3}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v1

    const/4 v3, 0x0

    move v6, v3

    .line 1515
    :goto_0
    array-length v7, v1

    const/4 v8, 0x2

    if-ge v6, v7, :cond_6

    .line 1516
    aget-object v7, v1, v6

    const-string v9, ":"

    invoke-virtual {v7, v9}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v7

    .line 1517
    aget-object v9, v7, v3

    invoke-virtual {v0, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_5

    array-length v9, v7

    if-ne v9, v8, :cond_5

    .line 1518
    aget-object v1, v7, v5

    goto :goto_1

    :cond_5
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    :cond_6
    const/4 v1, 0x0

    :goto_1
    const-string v3, "2097152,6291456,16777216,512000,2097152,8388608"

    if-nez v1, :cond_e

    if-eq p1, v5, :cond_d

    if-eq p1, v8, :cond_c

    const/4 v5, 0x3

    if-eq p1, v5, :cond_b

    if-eq p1, v2, :cond_9

    const/16 v2, 0x14

    if-eq p1, v2, :cond_8

    packed-switch p1, :pswitch_data_0

    goto :goto_3

    :pswitch_0
    const-string v1, "122334,734003,2202010,32040,192239,576717"

    goto :goto_3

    .line 1557
    :pswitch_1
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_7

    goto :goto_2

    :cond_7
    const-string v1, "524288,1048576,2097152,262144,524288,1048576"

    goto :goto_3

    :pswitch_2
    const-string v1, "131072,262144,1048576,4096,16384,524288"

    goto :goto_3

    :pswitch_3
    const-string v1, "40778,244668,734003,16777,100663,301990"

    goto :goto_3

    :pswitch_4
    const-string v1, "61167,367002,1101005,8738,52429,262114"

    goto :goto_3

    :pswitch_5
    const-string v1, "4094,87380,262144,4096,16384,262144"

    goto :goto_3

    :pswitch_6
    const-string v1, "16384,32768,131072,4096,16384,102400"

    goto :goto_3

    :cond_8
    :goto_2
    move-object v1, v3

    goto :goto_3

    .line 1565
    :cond_9
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_a

    goto :goto_2

    :cond_a
    const-string v1, "4096,6291456,12582912,4096,1048576,2097152"

    goto :goto_3

    :cond_b
    const-string v1, "58254,349525,1048576,58254,349525,1048576"

    goto :goto_3

    :cond_c
    const-string v1, "4093,26280,70800,4096,16384,70800"

    goto :goto_3

    :cond_d
    const-string v1, "4092,8760,48000,4096,8760,48000"

    .line 1582
    :cond_e
    :goto_3
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p0, v1}, Landroid/net/LinkProperties;->setTcpBufferSizes(Ljava/lang/String;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x6
        :pswitch_6
        :pswitch_5
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_3
        :pswitch_5
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method


# virtual methods
.method public bringUp(Lcom/android/internal/telephony/dataconnection/ApnContext;IILandroid/os/Message;IIIZ)V
    .locals 13

    move-object v0, p0

    .line 3547
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "bringUp: apnContext="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object v2, p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v3, " onCompletedMsg="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object/from16 v7, p4

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 3550
    iget-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    if-nez v1, :cond_0

    .line 3551
    invoke-virtual {p1}, Lcom/android/internal/telephony/dataconnection/ApnContext;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    iput-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    :cond_0
    const/high16 v1, 0x40000

    .line 3554
    new-instance v12, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    move-object v3, v12

    move-object v4, p1

    move v5, p2

    move/from16 v6, p3

    move-object/from16 v7, p4

    move/from16 v8, p5

    move/from16 v9, p6

    move/from16 v10, p7

    move/from16 v11, p8

    invoke-direct/range {v3 .. v11}, Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;-><init>(Lcom/android/internal/telephony/dataconnection/ApnContext;IILandroid/os/Message;IIIZ)V

    invoke-virtual {p0, v1, v12}, Lcom/android/internal/telephony/StateMachine;->sendMessage(ILjava/lang/Object;)V

    return-void
.end method

.method dispose()V
    .locals 1

    const-string v0, "dispose: call quiteNow()"

    .line 490
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 491
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->quitNow()V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 3

    .line 4007
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, " "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    const-string p2, "DataConnection "

    .line 4008
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 4009
    invoke-super {p0, p1, v0, p3}, Lcom/android/internal/telephony/StateMachine;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 4010
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    .line 4011
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 4012
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "transport type="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    .line 4013
    invoke-static {v1}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 4012
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4014
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mApnContexts.size="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->size()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4015
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mApnContexts="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4016
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mApnSetting="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4017
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mTag="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4018
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCid="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4019
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mConnectionParams="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mConnectionParams:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4020
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDisconnectParams="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectParams:Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4021
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDcFailCause="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcFailCause:I

    invoke-static {v1}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4022
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mPhone="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4023
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mSubId="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSubId:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4024
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mLinkProperties="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4025
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    .line 4026
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDataRegState="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataRegState:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4027
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mHandoverState="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->handoverStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4028
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mRilRat="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRilRat:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4029
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mNetworkCapabilities="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4030
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCreateTime="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCreateTime:J

    invoke-static {v1, v2}, Lcom/android/internal/telephony/TimeUtils;->logTimeOfDay(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4031
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mLastFailTime="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailTime:J

    invoke-static {v1, v2}, Lcom/android/internal/telephony/TimeUtils;->logTimeOfDay(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4032
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mLastFailCause="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailCause:I

    invoke-static {v1}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4033
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mUserData="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUserData:Ljava/lang/Object;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4034
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mRestrictedNetworkOverride="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRestrictedNetworkOverride:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4035
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mUnmeteredUseOnly="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredUseOnly:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4036
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mMmsUseOnly="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mMmsUseOnly:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4037
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mEnterpriseUse="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mEnterpriseUse:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4038
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mUnmeteredOverride="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredOverride:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4039
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mCongestedOverride="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCongestedOverride:Z

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4040
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDownlinkBandwidth"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDownlinkBandwidth:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4041
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mUplinkBandwidth="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4042
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mDefaultQos="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultQos:Landroid/telephony/data/Qos;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4043
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mQosBearerSessions="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mQosBearerSessions:Ljava/util/List;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4044
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "disallowedApnTypes="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 4045
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getDisallowedApnTypes()I

    move-result v1

    invoke-static {v1}, Landroid/telephony/data/ApnSetting;->getApnTypesStringFromBitmask(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 4044
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4046
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mInstanceNumber="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/android/internal/telephony/dataconnection/DataConnection;->mInstanceNumber:Ljava/util/concurrent/atomic/AtomicInteger;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4047
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mAc="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mAc:Lcom/android/internal/telephony/AsyncChannel;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4048
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mScore="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mScore:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4049
    iget-object p2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    if-eqz p2, :cond_0

    .line 4050
    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    :cond_0
    const-string p2, "handover local log:"

    .line 4052
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 4053
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 4054
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 4055
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 4056
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 4057
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->println()V

    .line 4058
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method public getApnContexts()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/dataconnection/ApnContext;",
            ">;"
        }
    .end annotation

    .line 3693
    new-instance v0, Ljava/util/ArrayList;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-interface {p0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object v0
.end method

.method public getApnSetting()Landroid/telephony/data/ApnSetting;
    .locals 0

    .line 531
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    return-object p0
.end method

.method getCid()I
    .locals 0

    .line 524
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    return p0
.end method

.method public getConnectionParams()Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;
    .locals 0

    .line 3635
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mConnectionParams:Lcom/android/internal/telephony/dataconnection/DataConnection$ConnectionParams;

    return-object p0
.end method

.method public getDataConnectionId()I
    .locals 0

    .line 1327
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mId:I

    return p0
.end method

.method getLinkProperties()Landroid/net/LinkProperties;
    .locals 1

    .line 497
    new-instance v0, Landroid/net/LinkProperties;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-direct {v0, p0}, Landroid/net/LinkProperties;-><init>(Landroid/net/LinkProperties;)V

    return-object v0
.end method

.method getNetworkAgent()Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;
    .locals 0

    .line 3715
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    return-object p0
.end method

.method public getNetworkCapabilities()Landroid/net/NetworkCapabilities;
    .locals 14

    .line 1828
    new-instance v0, Landroid/net/NetworkCapabilities$Builder;

    invoke-direct {v0}, Landroid/net/NetworkCapabilities$Builder;-><init>()V

    const/4 v1, 0x0

    .line 1829
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addTransportType(I)Landroid/net/NetworkCapabilities$Builder;

    move-result-object v0

    .line 1832
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    const/16 v3, 0xc

    const/4 v4, 0x1

    const/4 v5, 0x2

    if-eqz v2, :cond_e

    iget-boolean v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mEnterpriseUse:Z

    if-nez v2, :cond_e

    iget-boolean v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mMmsUseOnly:Z

    if-nez v2, :cond_e

    .line 1833
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 1834
    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getApnTypeBitmask()I

    move-result v2

    iget v6, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisabledApnTypeBitMask:I

    not-int v6, v6

    and-int/2addr v2, v6

    .line 1833
    invoke-static {v2}, Landroid/telephony/data/ApnSetting;->getApnTypesFromBitmask(I)[I

    move-result-object v2

    .line 1835
    array-length v6, v2

    move v7, v1

    :goto_0
    if-ge v7, v6, :cond_d

    aget v8, v2, v7

    .line 1836
    iget-boolean v9, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRestrictedNetworkOverride:Z

    if-nez v9, :cond_0

    iget-boolean v9, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredUseOnly:Z

    if-eqz v9, :cond_0

    iget-object v9, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1837
    invoke-static {v8, v9}, Lcom/android/internal/telephony/dataconnection/ApnSettingUtils;->isMeteredApnType(ILcom/android/internal/telephony/Phone;)Z

    move-result v9

    if-eqz v9, :cond_0

    .line 1838
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    const-string v10, "Dropped the metered "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v8}, Landroid/telephony/data/ApnSetting;->getApnTypeString(I)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, " type for the unmetered data call."

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {p0, v8}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    goto/16 :goto_1

    :cond_0
    if-eq v8, v5, :cond_c

    const/4 v9, 0x4

    if-eq v8, v9, :cond_b

    const/16 v10, 0x8

    if-eq v8, v10, :cond_a

    const/16 v10, 0x11

    if-eq v8, v10, :cond_9

    const/16 v10, 0x20

    const/4 v11, 0x3

    if-eq v8, v10, :cond_8

    const/16 v10, 0x40

    if-eq v8, v10, :cond_7

    const/16 v10, 0x80

    const/4 v12, 0x5

    if-eq v8, v10, :cond_6

    const/16 v10, 0x200

    if-eq v8, v10, :cond_5

    const/16 v10, 0x400

    if-eq v8, v10, :cond_4

    const/16 v10, 0x800

    if-eq v8, v10, :cond_3

    const/16 v10, 0xff

    const/4 v13, 0x7

    if-eq v8, v10, :cond_2

    const/16 v9, 0x100

    if-eq v8, v9, :cond_1

    goto :goto_1

    .line 1883
    :cond_1
    invoke-virtual {v0, v13}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    .line 1844
    :cond_2
    invoke-virtual {v0, v3}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1845
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1846
    invoke-virtual {v0, v4}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1847
    invoke-virtual {v0, v11}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1848
    invoke-virtual {v0, v9}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1849
    invoke-virtual {v0, v12}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1850
    invoke-virtual {v0, v13}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1851
    invoke-virtual {v0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    :cond_3
    const/16 v8, 0x9

    .line 1895
    invoke-virtual {v0, v8}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    :cond_4
    const/16 v8, 0x17

    .line 1891
    invoke-virtual {v0, v8}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    :cond_5
    const/16 v8, 0xa

    .line 1887
    invoke-virtual {v0, v8}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    .line 1879
    :cond_6
    invoke-virtual {v0, v12}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    .line 1875
    :cond_7
    invoke-virtual {v0, v9}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    .line 1871
    :cond_8
    invoke-virtual {v0, v11}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    .line 1855
    :cond_9
    invoke-virtual {v0, v3}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    .line 1867
    :cond_a
    invoke-virtual {v0, v5}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    .line 1863
    :cond_b
    invoke-virtual {v0, v4}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_1

    .line 1859
    :cond_c
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    :goto_1
    add-int/lit8 v7, v7, 0x1

    goto/16 :goto_0

    .line 1902
    :cond_d
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    iget-object v6, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v2, v6}, Lcom/android/internal/telephony/dataconnection/ApnSettingUtils;->isMetered(Landroid/telephony/data/ApnSetting;Lcom/android/internal/telephony/Phone;)Z

    move-result v2

    if-nez v2, :cond_e

    goto :goto_2

    :cond_e
    move v4, v1

    :goto_2
    const/16 v2, 0xb

    if-nez v4, :cond_10

    .line 1910
    iget-boolean v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredUseOnly:Z

    if-eqz v4, :cond_f

    iget-boolean v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRestrictedNetworkOverride:Z

    if-nez v4, :cond_f

    goto :goto_3

    .line 1913
    :cond_f
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    goto :goto_4

    .line 1911
    :cond_10
    :goto_3
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1916
    :goto_4
    iget-boolean v4, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mEnterpriseUse:Z

    if-eqz v4, :cond_11

    const/16 v4, 0x1d

    .line 1917
    invoke-virtual {v0, v4}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1918
    invoke-virtual {v0, v3}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1921
    :cond_11
    invoke-virtual {v0}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object v3

    invoke-static {v3}, Lcom/android/internal/telephony/util/NetworkCapabilitiesUtils;->inferRestrictedCapability(Landroid/net/NetworkCapabilities;)Z

    move-result v3

    const/16 v4, 0xd

    if-eqz v3, :cond_12

    .line 1922
    invoke-virtual {v0, v4}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1925
    :cond_12
    iget-boolean v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mMmsUseOnly:Z

    if-eqz v3, :cond_14

    .line 1926
    iget-object v3, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-static {v5, v3}, Lcom/android/internal/telephony/dataconnection/ApnSettingUtils;->isMeteredApnType(ILcom/android/internal/telephony/Phone;)Z

    move-result v3

    if-eqz v3, :cond_13

    const-string v3, "Adding unmetered capability for the unmetered MMS-only data connection"

    .line 1927
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1928
    invoke-virtual {v0, v2}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    :cond_13
    const-string v2, "Adding MMS capability for the MMS-only data connection"

    .line 1930
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 1931
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1934
    :cond_14
    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRestrictedNetworkOverride:Z

    if-eqz v1, :cond_15

    .line 1935
    invoke-virtual {v0, v4}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1937
    invoke-virtual {v0, v5}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1940
    :cond_15
    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDownlinkBandwidth:I

    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->setLinkDownstreamBandwidthKbps(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1941
    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUplinkBandwidth:I

    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->setLinkUpstreamBandwidthKbps(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1943
    new-instance v1, Landroid/net/TelephonyNetworkSpecifier$Builder;

    invoke-direct {v1}, Landroid/net/TelephonyNetworkSpecifier$Builder;-><init>()V

    iget v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSubId:I

    .line 1944
    invoke-virtual {v1, v2}, Landroid/net/TelephonyNetworkSpecifier$Builder;->setSubscriptionId(I)Landroid/net/TelephonyNetworkSpecifier$Builder;

    move-result-object v1

    invoke-virtual {v1}, Landroid/net/TelephonyNetworkSpecifier$Builder;->build()Landroid/net/TelephonyNetworkSpecifier;

    move-result-object v1

    .line 1943
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->setNetworkSpecifier(Landroid/net/NetworkSpecifier;)Landroid/net/NetworkCapabilities$Builder;

    .line 1945
    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSubId:I

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v1}, Ljava/util/Collections;->singleton(Ljava/lang/Object;)Ljava/util/Set;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->setSubscriptionIds(Ljava/util/Set;)Landroid/net/NetworkCapabilities$Builder;

    .line 1947
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v1

    if-nez v1, :cond_16

    const/16 v1, 0x12

    .line 1948
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1951
    :cond_16
    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCongestedOverride:Z

    if-nez v1, :cond_17

    const/16 v1, 0x14

    .line 1952
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1955
    :cond_17
    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mUnmeteredOverride:Z

    if-eqz v1, :cond_18

    const/16 v1, 0x19

    .line 1956
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1959
    :cond_18
    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mIsSuspended:Z

    if-nez v1, :cond_19

    const/16 v1, 0x15

    .line 1960
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1963
    :cond_19
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getCarrierServicePackageUid()I

    move-result v1

    const/4 v2, -0x1

    if-eq v1, v2, :cond_1a

    .line 1967
    iget-object v2, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mAdministratorUids:[I

    .line 1968
    invoke-static {v2, v1}, Lcom/android/internal/telephony/util/ArrayUtils;->contains([II)Z

    move-result v2

    if-eqz v2, :cond_1a

    .line 1969
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->setOwnerUid(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1970
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v1}, Ljava/util/Collections;->singleton(Ljava/lang/Object;)Ljava/util/Set;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->setAllowedUids(Ljava/util/Set;)Landroid/net/NetworkCapabilities$Builder;

    .line 1972
    :cond_1a
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mAdministratorUids:[I

    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->setAdministratorUids([I)Landroid/net/NetworkCapabilities$Builder;

    const/16 v1, 0x1c

    .line 1976
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->addCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1977
    invoke-virtual {v0}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getVcnPolicy(Landroid/net/NetworkCapabilities;)Landroid/net/vcn/VcnNetworkPolicyResult;

    move-result-object p0

    .line 1978
    invoke-virtual {p0}, Landroid/net/vcn/VcnNetworkPolicyResult;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v2

    .line 1979
    invoke-virtual {v2, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v2

    if-nez v2, :cond_1b

    .line 1980
    invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1982
    :cond_1b
    invoke-virtual {p0}, Landroid/net/vcn/VcnNetworkPolicyResult;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p0

    .line 1983
    invoke-virtual {p0, v4}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p0

    if-nez p0, :cond_1c

    .line 1984
    invoke-virtual {v0, v4}, Landroid/net/NetworkCapabilities$Builder;->removeCapability(I)Landroid/net/NetworkCapabilities$Builder;

    .line 1987
    :cond_1c
    invoke-virtual {v0}, Landroid/net/NetworkCapabilities$Builder;->build()Landroid/net/NetworkCapabilities;

    move-result-object p0

    return-object p0
.end method

.method public getPcscfAddresses()[Ljava/lang/String;
    .locals 0

    .line 3652
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPcscfAddr:[Ljava/lang/String;

    return-object p0
.end method

.method public getPduSessionId()I
    .locals 0

    .line 625
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPduSessionId:I

    return p0
.end method

.method public getPreciseDataConnectionState()Landroid/telephony/PreciseDataConnectionState;
    .locals 2

    .line 3987
    new-instance v0, Landroid/telephony/PreciseDataConnectionState$Builder;

    invoke-direct {v0}, Landroid/telephony/PreciseDataConnectionState$Builder;-><init>()V

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTransportType:I

    .line 3988
    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setTransportType(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    .line 3989
    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setId(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    .line 3990
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getState()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setState(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    .line 3991
    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    .line 3992
    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setLinkProperties(Landroid/net/LinkProperties;)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    .line 3993
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkType()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/PreciseDataConnectionState$Builder;->setNetworkType(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object v0

    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcFailCause:I

    .line 3994
    invoke-virtual {v0, p0}, Landroid/telephony/PreciseDataConnectionState$Builder;->setFailCause(I)Landroid/telephony/PreciseDataConnectionState$Builder;

    move-result-object p0

    .line 3995
    invoke-virtual {p0}, Landroid/telephony/PreciseDataConnectionState$Builder;->build()Landroid/telephony/PreciseDataConnectionState;

    move-result-object p0

    return-object p0
.end method

.method public getSliceInfo()Landroid/telephony/data/NetworkSliceInfo;
    .locals 0

    .line 629
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSliceInfo:Landroid/telephony/data/NetworkSliceInfo;

    return-object p0
.end method

.method public getTrafficDescriptors()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/telephony/data/TrafficDescriptor;",
            ">;"
        }
    .end annotation

    .line 633
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTrafficDescriptors:Ljava/util/List;

    return-object p0
.end method

.method protected getWhatToString(I)Ljava/lang/String;
    .locals 0

    .line 3739
    invoke-static {p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->cmdToString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method hasBeenTransferred()Z
    .locals 1

    .line 520
    iget p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    const/4 v0, 0x3

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method isActivating()Z
    .locals 1

    .line 516
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mActivatingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActivatingState;

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isActive()Z
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 507
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mActiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcActiveState;

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method isDisconnecting()Z
    .locals 2

    .line 501
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectingState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectingState;

    if-eq v0, v1, :cond_1

    .line 502
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDisconnectingErrorCreatingConnection:Lcom/android/internal/telephony/dataconnection/DataConnection$DcDisconnectionErrorCreatingConnection;

    if-ne v0, p0, :cond_0

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

.method public isInactive()Z
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 512
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mInactiveState:Lcom/android/internal/telephony/dataconnection/DataConnection$DcInactiveState;

    if-ne v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isIpv4Connected()Z
    .locals 2

    .line 592
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p0}, Landroid/net/LinkProperties;->getAddresses()Ljava/util/List;

    move-result-object p0

    .line 594
    invoke-interface {p0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/net/InetAddress;

    .line 595
    instance-of v1, v0, Ljava/net/Inet4Address;

    if-eqz v1, :cond_0

    .line 596
    check-cast v0, Ljava/net/Inet4Address;

    .line 597
    invoke-virtual {v0}, Ljava/net/Inet4Address;->isAnyLocalAddress()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Ljava/net/Inet4Address;->isLinkLocalAddress()Z

    move-result v1

    if-nez v1, :cond_0

    .line 598
    invoke-virtual {v0}, Ljava/net/Inet4Address;->isLoopbackAddress()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Ljava/net/Inet4Address;->isMulticastAddress()Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isIpv6Connected()Z
    .locals 2

    .line 609
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p0}, Landroid/net/LinkProperties;->getAddresses()Ljava/util/List;

    move-result-object p0

    .line 611
    invoke-interface {p0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/net/InetAddress;

    .line 612
    instance-of v1, v0, Ljava/net/Inet6Address;

    if-eqz v1, :cond_0

    .line 613
    check-cast v0, Ljava/net/Inet6Address;

    .line 614
    invoke-virtual {v0}, Ljava/net/Inet6Address;->isAnyLocalAddress()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Ljava/net/Inet6Address;->isLinkLocalAddress()Z

    move-result v1

    if-nez v1, :cond_0

    .line 615
    invoke-virtual {v0}, Ljava/net/Inet6Address;->isLoopbackAddress()Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {v0}, Ljava/net/Inet6Address;->isMulticastAddress()Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isValidationRequired()Z
    .locals 1

    .line 2037
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p0

    if-eqz p0, :cond_0

    const/16 v0, 0xc

    .line 2039
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    const/16 v0, 0xd

    .line 2040
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    const/16 v0, 0xe

    .line 2041
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    const/16 v0, 0xf

    .line 2042
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

.method protected log(Ljava/lang/String;)V
    .locals 0

    .line 3794
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logd(Ljava/lang/String;)V
    .locals 0

    .line 3804
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 0

    .line 3844
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;Ljava/lang/Throwable;)V
    .locals 0

    .line 3855
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1, p2}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method protected logi(Ljava/lang/String;)V
    .locals 0

    .line 3824
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logv(Ljava/lang/String;)V
    .locals 0

    .line 3814
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->v(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logw(Ljava/lang/String;)V
    .locals 0

    .line 3834
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public onCongestednessChanged(Z)V
    .locals 1

    .line 1147
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    const v0, 0x40011

    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public onMeterednessChanged(Z)V
    .locals 1

    .line 1155
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    const v0, 0x4001c

    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method reevaluateDataConnectionProperties()V
    .locals 1

    const v0, 0x4001a

    .line 3627
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    const-string v0, "reevaluate data connection properties"

    .line 3628
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-void
.end method

.method reevaluateRestrictedState()V
    .locals 1

    const v0, 0x40019

    .line 3618
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    const-string v0, "reevaluate restricted state"

    .line 3619
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-void
.end method

.method public reset()V
    .locals 1

    const v0, 0x40018

    .line 3609
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    const-string v0, "reset"

    .line 3610
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-void
.end method

.method public setDataCallSessionStats(Lcom/android/internal/telephony/metrics/DataCallSessionStats;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 3731
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataCallSessionStats:Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    return-void
.end method

.method setHandoverState(I)V
    .locals 2

    .line 3719
    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    if-eq v0, p1, :cond_0

    .line 3720
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "State changed from "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->handoverStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3721
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->handoverStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 3722
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 3723
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 3724
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    :cond_0
    return-void
.end method

.method public setPduSessionId(I)V
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 731
    iget v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPduSessionId:I

    if-eq v0, p1, :cond_0

    .line 732
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Changing pdu session id from: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPduSessionId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " to: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", Handover state: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mHandoverState:I

    .line 733
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->handoverStateToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 732
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    .line 734
    iput p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPduSessionId:I

    :cond_0
    return-void
.end method

.method public shouldSkip464Xlat()Z
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 2050
    iget-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getSkip464Xlat()I

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    const/4 v2, 0x1

    if-eq v0, v2, :cond_1

    .line 2061
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object p0

    const/4 v0, 0x4

    .line 2062
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v0

    if-eqz v0, :cond_0

    const/16 v0, 0xc

    .line 2063
    invoke-virtual {p0, v0}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result p0

    if-nez p0, :cond_0

    move v1, v2

    :cond_0
    return v1

    :cond_1
    return v2

    :cond_2
    return v1
.end method

.method public startHandover(Ljava/util/function/Consumer;)V
    .locals 3
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/function/Consumer<",
            "Ljava/lang/Integer;",
            ">;)V"
        }
    .end annotation

    .line 1105
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "startHandover: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->toStringSimple()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->logd(Ljava/lang/String;)V

    const/4 v0, 0x2

    .line 1107
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->setHandoverState(I)V

    .line 1109
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/dataconnection/DataConnection;Ljava/util/function/Consumer;)V

    .line 1116
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDataServiceManager:Lcom/android/internal/telephony/dataconnection/DataServiceManager;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    const v2, 0x40022

    .line 1117
    invoke-virtual {p0, v2, v0}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    .line 1116
    invoke-virtual {p1, v1, p0}, Lcom/android/internal/telephony/dataconnection/DataServiceManager;->startHandover(ILandroid/os/Message;)V

    return-void
.end method

.method public tearDown(Lcom/android/internal/telephony/dataconnection/ApnContext;Ljava/lang/String;Landroid/os/Message;)V
    .locals 2

    .line 3569
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "tearDown: apnContext="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " onCompletedMsg="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 3572
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    const/4 v1, 0x2

    invoke-direct {v0, p1, p2, v1, p3}, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;-><init>(Lcom/android/internal/telephony/dataconnection/ApnContext;Ljava/lang/String;ILandroid/os/Message;)V

    const p1, 0x40004

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/StateMachine;->sendMessage(ILjava/lang/Object;)V

    return-void
.end method

.method public tearDownAll(Ljava/lang/String;ILandroid/os/Message;)V
    .locals 2

    .line 3598
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "tearDownAll: reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", releaseType="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3599
    invoke-static {p2}, Lcom/android/internal/telephony/dataconnection/DcTracker;->releaseTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 3598
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 3601
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p1, p2, p3}, Lcom/android/internal/telephony/dataconnection/DataConnection$DisconnectParams;-><init>(Lcom/android/internal/telephony/dataconnection/ApnContext;Ljava/lang/String;ILandroid/os/Message;)V

    const p1, 0x40006

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/StateMachine;->sendMessage(ILjava/lang/Object;)V

    return-void
.end method

.method tearDownNow()V
    .locals 1

    const-string/jumbo v0, "tearDownNow()"

    .line 3583
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    const v0, 0x40008

    .line 3584
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->sendMessage(Landroid/os/Message;)V

    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 3873
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "{"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->toStringSimple()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " mApnContexts="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string/jumbo p0, "}"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public declared-synchronized toStringSimple()Ljava/lang/String;
    .locals 3

    monitor-enter p0

    .line 3860
    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ": State="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v1

    invoke-interface {v1}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " mApnSetting="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " RefCount="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnContexts:Ljava/util/Map;

    .line 3861
    invoke-interface {v1}, Ljava/util/Map;->size()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " mCid="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCid:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " mCreateTime="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mCreateTime:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " mLastastFailTime="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailTime:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " mLastFailCause="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLastFailCause:I

    .line 3864
    invoke-static {v1}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " mTag="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTag:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " mLinkProperties="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " linkCapabilities="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 3867
    invoke-virtual {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " mRestrictedNetworkOverride="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRestrictedNetworkOverride:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 3860
    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public updateLinkProperty(Landroid/telephony/data/DataCallResponse;)Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 691
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;-><init>(Landroid/net/LinkProperties;)V

    if-nez p1, :cond_0

    return-object v0

    .line 695
    :cond_0
    new-instance v1, Landroid/net/LinkProperties;

    invoke-direct {v1}, Landroid/net/LinkProperties;-><init>()V

    iput-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->newLp:Landroid/net/LinkProperties;

    .line 698
    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->setLinkProperties(Landroid/telephony/data/DataCallResponse;Landroid/net/LinkProperties;)Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    move-result-object p1

    iput-object p1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->setupResult:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    .line 699
    sget-object v1, Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;->SUCCESS:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    if-eq p1, v1, :cond_1

    .line 700
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateLinkProperty failed : "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->setupResult:Lcom/android/internal/telephony/dataconnection/DataConnection$SetupResult;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    return-object v0

    .line 704
    :cond_1
    iget-object p1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->newLp:Landroid/net/LinkProperties;

    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {v1}, Landroid/net/LinkProperties;->getHttpProxy()Landroid/net/ProxyInfo;

    move-result-object v1

    invoke-virtual {p1, v1}, Landroid/net/LinkProperties;->setHttpProxy(Landroid/net/ProxyInfo;)V

    .line 706
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mApnSetting:Landroid/telephony/data/ApnSetting;

    iget-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->newLp:Landroid/net/LinkProperties;

    invoke-direct {p0, p1, v1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->checkSetMtu(Landroid/telephony/data/ApnSetting;Landroid/net/LinkProperties;)V

    .line 708
    iget-object p1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->newLp:Landroid/net/LinkProperties;

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    .line 710
    iget p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mRilRat:I

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateTcpBufferSizes(I)V

    .line 712
    iget-object p1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->oldLp:Landroid/net/LinkProperties;

    iget-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->newLp:Landroid/net/LinkProperties;

    invoke-virtual {p1, v1}, Landroid/net/LinkProperties;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_2

    .line 713
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateLinkProperty old LP="

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->oldLp:Landroid/net/LinkProperties;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 714
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateLinkProperty new LP="

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->newLp:Landroid/net/LinkProperties;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->log(Ljava/lang/String;)V

    .line 717
    :cond_2
    iget-object p1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->newLp:Landroid/net/LinkProperties;

    iget-object v1, v0, Lcom/android/internal/telephony/dataconnection/DataConnection$UpdateLinkPropertyResult;->oldLp:Landroid/net/LinkProperties;

    invoke-virtual {p1, v1}, Landroid/net/LinkProperties;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_3

    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    if-eqz p1, :cond_3

    .line 719
    iget-object v1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mLinkProperties:Landroid/net/LinkProperties;

    invoke-virtual {p1, v1, p0}, Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;->sendLinkProperties(Landroid/net/LinkProperties;Lcom/android/internal/telephony/dataconnection/DataConnection;)V

    :cond_3
    return-object v0
.end method

.method public updatePcscfAddr(Landroid/telephony/data/DataCallResponse;)V
    .locals 1

    .line 3644
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getPcscfAddresses()Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda2;

    invoke-direct {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda2;-><init>()V

    .line 3645
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lcom/android/internal/telephony/dataconnection/DataConnection$$ExternalSyntheticLambda3;-><init>()V

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->toArray(Ljava/util/function/IntFunction;)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Ljava/lang/String;

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mPcscfAddr:[Ljava/lang/String;

    return-void
.end method

.method public updateQosParameters(Landroid/telephony/data/DataCallResponse;)V
    .locals 1

    if-nez p1, :cond_0

    const/4 p1, 0x0

    .line 648
    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultQos:Landroid/telephony/data/Qos;

    .line 649
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mQosBearerSessions:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->clear()V

    return-void

    .line 653
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getDefaultQos()Landroid/telephony/data/Qos;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDefaultQos:Landroid/telephony/data/Qos;

    .line 654
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getQosBearerSessions()Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mQosBearerSessions:Ljava/util/List;

    .line 656
    iget-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mNetworkAgent:Lcom/android/internal/telephony/dataconnection/DcNetworkAgent;

    if-eqz p1, :cond_1

    .line 657
    invoke-direct {p0}, Lcom/android/internal/telephony/dataconnection/DataConnection;->syncQosToNetworkAgent()V

    :cond_1
    return-void
.end method

.method public updateResponseFields(Landroid/telephony/data/DataCallResponse;)V
    .locals 0

    .line 641
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateQosParameters(Landroid/telephony/data/DataCallResponse;)V

    .line 642
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateSliceInfo(Landroid/telephony/data/DataCallResponse;)V

    .line 643
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/dataconnection/DataConnection;->updateTrafficDescriptors(Landroid/telephony/data/DataCallResponse;)V

    return-void
.end method

.method public updateSliceInfo(Landroid/telephony/data/DataCallResponse;)V
    .locals 0

    .line 676
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getSliceInfo()Landroid/telephony/data/NetworkSliceInfo;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mSliceInfo:Landroid/telephony/data/NetworkSliceInfo;

    return-void
.end method

.method public updateTrafficDescriptors(Landroid/telephony/data/DataCallResponse;)V
    .locals 1

    .line 684
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getTrafficDescriptors()Ljava/util/List;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mTrafficDescriptors:Ljava/util/List;

    .line 685
    iget-object p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnection;->mDcController:Lcom/android/internal/telephony/dataconnection/DcController;

    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getId()I

    move-result v0

    .line 686
    invoke-virtual {p1}, Landroid/telephony/data/DataCallResponse;->getTrafficDescriptors()Ljava/util/List;

    move-result-object p1

    .line 685
    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/dataconnection/DcController;->updateTrafficDescriptorsForCid(ILjava/util/List;)V

    return-void
.end method
