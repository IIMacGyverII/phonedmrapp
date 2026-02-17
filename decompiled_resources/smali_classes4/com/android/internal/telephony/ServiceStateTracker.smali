.class public Lcom/android/internal/telephony/ServiceStateTracker;
.super Landroid/os/Handler;
.source "ServiceStateTracker.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/ServiceStateTracker$SstSubscriptionsChangedListener;,
        Lcom/android/internal/telephony/ServiceStateTracker$CarrierNameDisplayBitmask;
    }
.end annotation


# static fields
.field public static final CARRIER_NAME_DISPLAY_BITMASK_SHOW_PLMN:I = 0x2

.field public static final CARRIER_NAME_DISPLAY_BITMASK_SHOW_SPN:I = 0x1

.field private static final CELL_INFO_LIST_QUERY_TIMEOUT:J = 0x7d0L

.field public static final CS_DISABLED:I = 0x3ec

.field public static final CS_EMERGENCY_ENABLED:I = 0x3ee

.field public static final CS_ENABLED:I = 0x3eb

.field public static final CS_NORMAL_ENABLED:I = 0x3ed

.field public static final CS_NOTIFICATION:I = 0x3e7

.field public static final CS_REJECT_CAUSE_DISABLED:I = 0x7d2

.field public static final CS_REJECT_CAUSE_ENABLED:I = 0x7d1

.field public static final CS_REJECT_CAUSE_NOTIFICATION:I = 0x6f

.field static final DBG:Z = true

.field public static final DEFAULT_GPRS_CHECK_PERIOD_MILLIS:I = 0xea60

.field public static final DEFAULT_MNC:Ljava/lang/String; = "00"

.field protected static final EVENT_ALL_DATA_DISCONNECTED:I = 0x31

.field protected static final EVENT_CARRIER_CONFIG_CHANGED:I = 0x39

.field protected static final EVENT_CDMA_PRL_VERSION_CHANGED:I = 0x28

.field protected static final EVENT_CDMA_SUBSCRIPTION_SOURCE_CHANGED:I = 0x27

.field protected static final EVENT_CELL_LOCATION_RESPONSE:I = 0x38

.field protected static final EVENT_CHANGE_IMS_STATE:I = 0x2d

.field protected static final EVENT_CHECK_REPORT_GPRS:I = 0x16

.field protected static final EVENT_GET_ALLOWED_NETWORK_TYPES:I = 0x13

.field protected static final EVENT_GET_CELL_INFO_LIST:I = 0x2b

.field protected static final EVENT_GET_LOC_DONE:I = 0xf

.field public static final EVENT_ICC_CHANGED:I = 0x2a

.field protected static final EVENT_IMS_CAPABILITY_CHANGED:I = 0x30

.field protected static final EVENT_IMS_SERVICE_STATE_CHANGED:I = 0x35

.field protected static final EVENT_IMS_STATE_CHANGED:I = 0x2e

.field protected static final EVENT_IMS_STATE_DONE:I = 0x2f

.field protected static final EVENT_LOCATION_UPDATES_ENABLED:I = 0x12

.field protected static final EVENT_NETWORK_STATE_CHANGED:I = 0x2

.field protected static final EVENT_NITZ_TIME:I = 0xb

.field protected static final EVENT_NV_READY:I = 0x23

.field protected static final EVENT_OTA_PROVISION_STATUS_CHANGE:I = 0x25

.field protected static final EVENT_PHONE_TYPE_SWITCHED:I = 0x32

.field protected static final EVENT_PHYSICAL_CHANNEL_CONFIG:I = 0x37

.field protected static final EVENT_POLL_STATE_CDMA_SUBSCRIPTION:I = 0x22

.field protected static final EVENT_POLL_STATE_CS_CELLULAR_REGISTRATION:I = 0x4

.field protected static final EVENT_POLL_STATE_NETWORK_SELECTION_MODE:I = 0xe

.field protected static final EVENT_POLL_STATE_OPERATOR:I = 0x7

.field protected static final EVENT_POLL_STATE_PS_CELLULAR_REGISTRATION:I = 0x5

.field protected static final EVENT_POLL_STATE_PS_IWLAN_REGISTRATION:I = 0x6

.field private static final EVENT_POLL_STATE_REQUEST:I = 0x3a

.field protected static final EVENT_POWER_OFF_RADIO_IMS_DEREG_TIMEOUT:I = 0x3e

.field protected static final EVENT_RADIO_ON:I = 0x29

.field protected static final EVENT_RADIO_POWER_FROM_CARRIER:I = 0x33

.field protected static final EVENT_RADIO_POWER_OFF_DONE:I = 0x36

.field protected static final EVENT_RADIO_STATE_CHANGED:I = 0x1

.field private static final EVENT_REGISTER_DATA_NETWORK_EXISTING_CHANGED:I = 0x40

.field protected static final EVENT_RESET_ALLOWED_NETWORK_TYPES:I = 0x15

.field protected static final EVENT_RESET_LAST_KNOWN_CELL_IDENTITY:I = 0x3f

.field protected static final EVENT_RESTRICTED_STATE_CHANGED:I = 0x17

.field protected static final EVENT_RUIM_READY:I = 0x1a

.field protected static final EVENT_RUIM_RECORDS_LOADED:I = 0x1b

.field protected static final EVENT_SET_ALLOWED_NETWORK_TYPES:I = 0x14

.field protected static final EVENT_SET_RADIO_POWER_OFF:I = 0x26

.field protected static final EVENT_SIM_READY:I = 0x11

.field protected static final EVENT_SIM_RECORDS_LOADED:I = 0x10

.field protected static final EVENT_TELECOM_VOICE_SERVICE_STATE_OVERRIDE_CHANGED:I = 0x41

.field protected static final EVENT_UNSOL_CELL_INFO_LIST:I = 0x2c

.field public static final INVALID_MCC:Ljava/lang/String; = "000"

.field static final LOG_TAG:Ljava/lang/String; = "SST"

.field private static final MS_PER_HOUR:I = 0x36ee80

.field private static final POWER_OFF_ALL_DATA_NETWORKS_DISCONNECTED_TIMEOUT:J

.field protected static final PROP_FORCE_ROAMING:Ljava/lang/String; = "telephony.test.forceRoaming"

.field public static final PS_DISABLED:I = 0x3ea

.field public static final PS_ENABLED:I = 0x3e9

.field public static final PS_NOTIFICATION:I = 0x378

.field protected static final REGISTRATION_DENIED_AUTH:Ljava/lang/String; = "Authentication Failure"

.field protected static final REGISTRATION_DENIED_GEN:Ljava/lang/String; = "General"

.field private static final SERVICE_STATE:Ljava/lang/String; = "service_state"

.field public static final UNACTIVATED_MIN2_VALUE:Ljava/lang/String; = "000000"

.field public static final UNACTIVATED_MIN_VALUE:Ljava/lang/String; = "1111110111"

.field private static final VDBG:Z = false


# instance fields
.field protected final mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

.field private final mAirplaneModeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private mAllowedNetworkTypes:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mAnyDataExisting:Z

.field protected final mAreaCodeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private final mAttachLog:Lcom/android/internal/telephony/LocalLog;

.field protected mAttachedRegistrants:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/RegistrantList;",
            ">;"
        }
    .end annotation
.end field

.field protected final mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field protected mCSEmergencyOnly:Z

.field private mCSST:Lcom/android/internal/telephony/CarrierServiceStateTracker;

.field private mCdmaForSubscriptionInfoReadyRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field protected mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

.field protected mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

.field private final mCdnrLogs:Lcom/android/internal/telephony/LocalLog;

.field protected mCellIdentity:Landroid/telephony/CellIdentity;

.field private mCellInfoMinIntervalMs:I

.field protected mCi:Lcom/android/internal/telephony/CommandsInterface;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private final mCr:Landroid/content/ContentResolver;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mCssIndicatorChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field protected mCurDataSpn:Ljava/lang/String;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mCurPlmn:Ljava/lang/String;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mCurShowPlmn:Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mCurShowSpn:Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mCurSpn:Ljava/lang/String;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mCurrentCarrier:Ljava/lang/String;

.field private mCurrentOtaspMode:I

.field private mDataRegStateOrRatChangedRegistrants:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/RegistrantList;",
            ">;"
        }
    .end annotation
.end field

.field protected mDataRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field protected mDataRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field protected mDefaultRoamingIndicator:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mDesiredPowerState:Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field protected mDetachedRegistrants:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/RegistrantList;",
            ">;"
        }
    .end annotation
.end field

.field protected mDeviceShuttingDown:Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mEmergencyOnly:Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected final mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

.field protected mEriText:Ljava/lang/String;

.field protected mGsmDataRoaming:Z

.field protected mGsmVoiceRoaming:Z

.field protected mHbpcdUtils:Lcom/android/internal/telephony/HbpcdUtils;

.field private mHomeNetworkId:[I

.field private mHomeSystemId:[I

.field protected mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mImsCapabilityChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private mImsRegistered:Z

.field protected mImsRegistrationOnOff:Z

.field protected mIntentReceiver:Landroid/content/BroadcastReceiver;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mIsEriTextLoaded:Z

.field protected mIsInPrl:Z

.field protected mIsMinInfoReady:Z

.field private mIsPendingCellInfoRequest:Z

.field protected mIsSimReady:Z

.field protected mIsSubscriptionFromRuim:Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mLastCellInfoList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/CellInfo;",
            ">;"
        }
    .end annotation
.end field

.field protected mLastCellInfoReqTime:J

.field protected mLastKnownAreaCode:I

.field protected mLastKnownCellIdentity:Landroid/telephony/CellIdentity;

.field protected mLastKnownNetworkCountry:Ljava/lang/String;

.field protected mLastNitzData:Lcom/android/internal/telephony/NitzData;

.field protected mLastPhysicalChannelConfigList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/PhysicalChannelConfig;",
            ">;"
        }
    .end annotation
.end field

.field protected final mLocaleTracker:Lcom/android/internal/telephony/LocaleTracker;

.field protected mMaxDataCalls:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mMdn:Ljava/lang/String;

.field protected mMin:Ljava/lang/String;

.field protected mNetworkAttachedRegistrants:Lcom/android/internal/telephony/RegistrantList;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field protected mNetworkDetachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field protected mNewMaxDataCalls:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mNewReasonDataDenied:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mNewRejectCode:I

.field protected mNewSS:Landroid/telephony/ServiceState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected final mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

.field private mNotification:Landroid/app/Notification;

.field protected mNrFrequencyChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field protected mNrStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private final mOnSubscriptionsChangedListener:Lcom/android/internal/telephony/ServiceStateTracker$SstSubscriptionsChangedListener;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mOperatorNameStringPattern:Ljava/util/regex/Pattern;

.field private final mOutOfServiceSS:Landroid/telephony/ServiceState;

.field protected mPSEmergencyOnly:Z

.field private mPendingCellInfoRequests:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/os/Message;",
            ">;"
        }
    .end annotation
.end field

.field protected mPendingRadioPowerOffAfterDataOff:Z

.field private mPendingRadioPowerOffAfterDataOffTag:I

.field protected final mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private final mPhoneTypeLog:Lcom/android/internal/telephony/LocalLog;

.field public mPollingContext:[I
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field protected mPrevSubId:I

.field protected mPrlVersion:Ljava/lang/String;

.field protected mPsRestrictDisabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private mPsRestrictEnabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field protected mRadioDisabledByCarrier:Z

.field protected final mRadioPowerLog:Lcom/android/internal/telephony/LocalLog;

.field protected final mRadioPowerOffReasons:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private final mRatLog:Lcom/android/internal/telephony/LocalLog;

.field protected final mRatRatcheter:Lcom/android/internal/telephony/RatRatcheter;

.field protected mReasonDataDenied:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected final mRegStateManagers:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/NetworkRegistrationManager;",
            ">;"
        }
    .end annotation
.end field

.field protected mRegistrationDeniedReason:Ljava/lang/String;

.field protected mRegistrationState:I

.field protected mRejectCode:I

.field protected mReportedGprsNoReg:Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field public mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

.field protected mRoamingIndicator:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private final mRoamingLog:Lcom/android/internal/telephony/LocalLog;

.field public mSS:Landroid/telephony/ServiceState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mServiceStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field private mServiceStateStats:Lcom/android/internal/telephony/metrics/ServiceStateStats;

.field protected mSpnUpdatePending:Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mStartedGprsRegCheck:Z
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field public mSubId:I
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field protected mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mSubscriptionManager:Landroid/telephony/SubscriptionManager;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field protected mUiccController:Lcom/android/internal/telephony/uicc/UiccController;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation
.end field

.field private mVoiceCapable:Z

.field private mVoiceRegStateOrRatChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

.field protected mVoiceRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field protected mVoiceRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field private mWantContinuousLocationUpdates:Z

.field private mWantSingleLocationUpdate:Z


# direct methods
.method public static synthetic $r8$lambda$I4NJ6eXdEb6gxqtc2D4bktBciFs(Landroid/telephony/NetworkRegistrationInfo;)Landroid/telephony/CellIdentity;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->lambda$getPrioritizedCellIdentities$3(Landroid/telephony/NetworkRegistrationInfo;)Landroid/telephony/CellIdentity;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$KeZkZp1AVp-C8Wyxv2XTqivkaTA(Landroid/telephony/NetworkRegistrationInfo;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->lambda$getPrioritizedCellIdentities$1(Landroid/telephony/NetworkRegistrationInfo;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$ihEATESr5EHnRVF5kzfTdYbTI8c(Landroid/telephony/NetworkRegistrationInfo;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->lambda$getPrioritizedCellIdentities$0(Landroid/telephony/NetworkRegistrationInfo;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$s7YDMSdLxrT99ZWSGr1_ypao1QM(Landroid/telephony/NetworkRegistrationInfo;)Ljava/lang/Integer;
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->lambda$getPrioritizedCellIdentities$2(Landroid/telephony/NetworkRegistrationInfo;)Ljava/lang/Integer;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmAnyDataExisting(Lcom/android/internal/telephony/ServiceStateTracker;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAnyDataExisting:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmOutOfServiceSS(Lcom/android/internal/telephony/ServiceStateTracker;)Landroid/telephony/ServiceState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mOutOfServiceSS:Landroid/telephony/ServiceState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmAnyDataExisting(Lcom/android/internal/telephony/ServiceStateTracker;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAnyDataExisting:Z

    return-void
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 255
    sget-object v0, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0xa

    .line 256
    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v0

    sput-wide v0, Lcom/android/internal/telephony/ServiceStateTracker;->POWER_OFF_ALL_DATA_NETWORKS_DISCONNECTED_TIMEOUT:J

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/GsmCdmaPhone;Lcom/android/internal/telephony/CommandsInterface;)V
    .locals 12

    .line 690
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    const/4 v0, 0x0

    .line 146
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    .line 148
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    .line 150
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    const/16 v1, 0x7d0

    .line 175
    iput v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellInfoMinIntervalMs:I

    .line 185
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoList:Ljava/util/List;

    .line 186
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    .line 188
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerOffReasons:Ljava/util/Set;

    .line 205
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 207
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 209
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 211
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 214
    new-instance v1, Landroid/util/SparseArray;

    invoke-direct {v1}, Landroid/util/SparseArray;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    .line 215
    new-instance v1, Landroid/util/SparseArray;

    invoke-direct {v1}, Landroid/util/SparseArray;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    .line 216
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRegStateOrRatChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 217
    new-instance v1, Landroid/util/SparseArray;

    invoke-direct {v1}, Landroid/util/SparseArray;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRegStateOrRatChangedRegistrants:Landroid/util/SparseArray;

    .line 219
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNetworkAttachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 221
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNetworkDetachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 225
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mServiceStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 227
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPsRestrictEnabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 229
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPsRestrictDisabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 231
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsCapabilityChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 233
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNrStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 234
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNrFrequencyChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 235
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCssIndicatorChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 236
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 238
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAirplaneModeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 240
    new-instance v1, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v1}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAreaCodeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    const/4 v1, 0x0

    .line 245
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    .line 247
    iput v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    .line 340
    new-instance v2, Ljava/util/LinkedList;

    invoke-direct {v2}, Ljava/util/LinkedList;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingCellInfoRequests:Ljava/util/List;

    .line 342
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsPendingCellInfoRequest:Z

    .line 351
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistrationOnOff:Z

    .line 354
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioDisabledByCarrier:Z

    .line 356
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    .line 359
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSpnUpdatePending:Z

    .line 361
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurSpn:Ljava/lang/String;

    .line 363
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurDataSpn:Ljava/lang/String;

    .line 365
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurPlmn:Ljava/lang/String;

    .line 367
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurShowPlmn:Z

    .line 369
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurShowSpn:Z

    const/4 v2, -0x1

    .line 372
    iput v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    .line 376
    iput v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrevSubId:I

    .line 379
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistered:Z

    .line 387
    new-instance v3, Lcom/android/internal/telephony/ServiceStateTracker$SstSubscriptionsChangedListener;

    invoke-direct {v3, p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker$SstSubscriptionsChangedListener;-><init>(Lcom/android/internal/telephony/ServiceStateTracker;Lcom/android/internal/telephony/ServiceStateTracker$SstSubscriptionsChangedListener-IA;)V

    iput-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mOnSubscriptionsChangedListener:Lcom/android/internal/telephony/ServiceStateTracker$SstSubscriptionsChangedListener;

    .line 397
    new-instance v4, Lcom/android/internal/telephony/LocalLog;

    const/16 v5, 0x8

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingLog:Lcom/android/internal/telephony/LocalLog;

    .line 398
    new-instance v4, Lcom/android/internal/telephony/LocalLog;

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachLog:Lcom/android/internal/telephony/LocalLog;

    .line 399
    new-instance v4, Lcom/android/internal/telephony/LocalLog;

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhoneTypeLog:Lcom/android/internal/telephony/LocalLog;

    .line 400
    new-instance v4, Lcom/android/internal/telephony/LocalLog;

    const/16 v5, 0x10

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRatLog:Lcom/android/internal/telephony/LocalLog;

    .line 402
    new-instance v4, Lcom/android/internal/telephony/LocalLog;

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerLog:Lcom/android/internal/telephony/LocalLog;

    .line 404
    new-instance v4, Lcom/android/internal/telephony/LocalLog;

    const/16 v5, 0x40

    invoke-direct {v4, v5}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnrLogs:Lcom/android/internal/telephony/LocalLog;

    const/4 v4, 0x1

    .line 536
    iput v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMaxDataCalls:I

    .line 538
    iput v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewMaxDataCalls:I

    .line 540
    iput v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mReasonDataDenied:I

    .line 542
    iput v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewReasonDataDenied:I

    .line 556
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mGsmVoiceRoaming:Z

    .line 561
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mGsmDataRoaming:Z

    .line 565
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEmergencyOnly:Z

    .line 567
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSEmergencyOnly:Z

    .line 568
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPSEmergencyOnly:Z

    .line 600
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSimReady:Z

    const-string v6, ""

    .line 602
    iput-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownNetworkCountry:Ljava/lang/String;

    .line 606
    new-instance v6, Lcom/android/internal/telephony/ServiceStateTracker$1;

    invoke-direct {v6, p0}, Lcom/android/internal/telephony/ServiceStateTracker$1;-><init>(Lcom/android/internal/telephony/ServiceStateTracker;)V

    iput-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    .line 636
    iput v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurrentOtaspMode:I

    .line 646
    iput v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegistrationState:I

    .line 648
    new-instance v2, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {v2}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaForSubscriptionInfoReadyRegistrants:Lcom/android/internal/telephony/RegistrantList;

    .line 652
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    .line 653
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeNetworkId:[I

    .line 657
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsMinInfoReady:Z

    .line 659
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsEriTextLoaded:Z

    .line 662
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    .line 669
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHbpcdUtils:Lcom/android/internal/telephony/HbpcdUtils;

    .line 673
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurrentCarrier:Ljava/lang/String;

    .line 677
    new-instance v2, Landroid/util/SparseArray;

    invoke-direct {v2}, Landroid/util/SparseArray;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegStateManagers:Landroid/util/SparseArray;

    const v2, 0x7fffffff

    .line 680
    iput v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownAreaCode:I

    .line 688
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAnyDataExisting:Z

    .line 691
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    const-class v6, Lcom/android/internal/telephony/NitzStateMachine;

    .line 692
    invoke-virtual {v6}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v2, v6}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object v2

    .line 693
    invoke-virtual {v2, p1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeNitzStateMachine(Lcom/android/internal/telephony/GsmCdmaPhone;)Lcom/android/internal/telephony/NitzStateMachine;

    move-result-object v2

    iput-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    .line 694
    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 695
    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 697
    new-instance p2, Lcom/android/internal/telephony/metrics/ServiceStateStats;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/ServiceStateStats;-><init>(Lcom/android/internal/telephony/Phone;)V

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mServiceStateStats:Lcom/android/internal/telephony/metrics/ServiceStateStats;

    .line 699
    new-instance p2, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;-><init>(Lcom/android/internal/telephony/GsmCdmaPhone;)V

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    .line 702
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    invoke-static {p2}, Lcom/android/internal/telephony/uicc/UiccController;->isCdmaSupported(Landroid/content/Context;)Z

    move-result p2

    if-eqz p2, :cond_0

    .line 703
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p2

    const-class v2, Lcom/android/internal/telephony/cdma/EriManager;

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p2, v2}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p2

    .line 704
    invoke-virtual {p2, p1, v1}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeEriManager(Lcom/android/internal/telephony/Phone;I)Lcom/android/internal/telephony/cdma/EriManager;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

    goto :goto_0

    .line 706
    :cond_0
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

    .line 709
    :goto_0
    new-instance p2, Lcom/android/internal/telephony/RatRatcheter;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/RatRatcheter;-><init>(Lcom/android/internal/telephony/Phone;)V

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRatRatcheter:Lcom/android/internal/telephony/RatRatcheter;

    .line 710
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    const-string v2, "phone"

    .line 711
    invoke-virtual {p2, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/telephony/TelephonyManager;

    .line 712
    invoke-virtual {p2}, Landroid/telephony/TelephonyManager;->isVoiceCapable()Z

    move-result p2

    iput-boolean p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceCapable:Z

    .line 713
    invoke-static {}, Lcom/android/internal/telephony/uicc/UiccController;->getInstance()Lcom/android/internal/telephony/uicc/UiccController;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    const/16 v2, 0x2a

    .line 715
    invoke-virtual {p2, p0, v2, v0}, Lcom/android/internal/telephony/uicc/UiccController;->registerForIccChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 716
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v2, 0x2c

    invoke-interface {p2, p0, v2, v0}, Lcom/android/internal/telephony/CommandsInterface;->registerForCellInfoList(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 717
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v2, 0x37

    invoke-interface {p2, p0, v2, v0}, Lcom/android/internal/telephony/CommandsInterface;->registerForPhysicalChannelConfiguration(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 719
    invoke-static {}, Lcom/android/internal/telephony/SubscriptionController;->getInstance()Lcom/android/internal/telephony/SubscriptionController;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    .line 720
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    invoke-static {p2}, Landroid/telephony/SubscriptionManager;->from(Landroid/content/Context;)Landroid/telephony/SubscriptionManager;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    .line 721
    new-instance v2, Landroid/os/HandlerExecutor;

    invoke-direct {v2, p0}, Landroid/os/HandlerExecutor;-><init>(Landroid/os/Handler;)V

    invoke-virtual {p2, v2, v3}, Landroid/telephony/SubscriptionManager;->addOnSubscriptionsChangedListener(Ljava/util/concurrent/Executor;Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;)V

    .line 723
    new-instance p2, Lcom/android/internal/telephony/RestrictedState;

    invoke-direct {p2}, Lcom/android/internal/telephony/RestrictedState;-><init>()V

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    .line 725
    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->getAccessNetworksManager()Lcom/android/internal/telephony/data/AccessNetworksManager;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 726
    new-instance v2, Landroid/telephony/ServiceState;

    invoke-direct {v2}, Landroid/telephony/ServiceState;-><init>()V

    iput-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mOutOfServiceSS:Landroid/telephony/ServiceState;

    .line 727
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v3

    invoke-virtual {v2, v3, v1}, Landroid/telephony/ServiceState;->setOutOfService(ZZ)V

    .line 729
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object p2

    array-length v2, p2

    move v3, v1

    :goto_1
    if-ge v3, v2, :cond_1

    aget v6, p2, v3

    .line 730
    iget-object v7, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegStateManagers:Landroid/util/SparseArray;

    new-instance v8, Lcom/android/internal/telephony/NetworkRegistrationManager;

    invoke-direct {v8, v6, p1}, Lcom/android/internal/telephony/NetworkRegistrationManager;-><init>(ILcom/android/internal/telephony/Phone;)V

    invoke-virtual {v7, v6, v8}, Landroid/util/SparseArray;->append(ILjava/lang/Object;)V

    .line 732
    iget-object v7, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegStateManagers:Landroid/util/SparseArray;

    invoke-virtual {v7, v6}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lcom/android/internal/telephony/NetworkRegistrationManager;

    const/4 v7, 0x2

    invoke-virtual {v6, p0, v7, v0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->registerForNetworkRegistrationInfoChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 735
    :cond_1
    invoke-static {}, Lcom/android/internal/telephony/TelephonyComponentFactory;->getInstance()Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p2

    const-class v2, Lcom/android/internal/telephony/LocaleTracker;

    .line 736
    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p2, v2}, Lcom/android/internal/telephony/TelephonyComponentFactory;->inject(Ljava/lang/String;)Lcom/android/internal/telephony/TelephonyComponentFactory;

    move-result-object p2

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    .line 737
    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object v6

    invoke-virtual {p2, v2, v3, v6}, Lcom/android/internal/telephony/TelephonyComponentFactory;->makeLocaleTracker(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/NitzStateMachine;Landroid/os/Looper;)Lcom/android/internal/telephony/LocaleTracker;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLocaleTracker:Lcom/android/internal/telephony/LocaleTracker;

    .line 739
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v2, 0x2e

    invoke-interface {p2, p0, v2, v0}, Lcom/android/internal/telephony/CommandsInterface;->registerForImsNetworkStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 740
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p2, p0, v4, v0}, Lcom/android/internal/telephony/CommandsInterface;->registerForRadioStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 741
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v2, 0xb

    invoke-interface {p2, p0, v2, v0}, Lcom/android/internal/telephony/CommandsInterface;->setOnNITZTime(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 743
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    invoke-virtual {p2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p2

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCr:Landroid/content/ContentResolver;

    const-string v2, "airplane_mode_on"

    .line 745
    invoke-static {p2, v2, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v2

    const-string v3, "enable_cellular_on_boot"

    .line 746
    invoke-static {p2, v3, v4}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p2

    if-lez p2, :cond_2

    if-gtz v2, :cond_2

    move v3, v4

    goto :goto_2

    :cond_2
    move v3, v1

    .line 748
    :goto_2
    iput-boolean v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDesiredPowerState:Z

    if-nez v3, :cond_3

    .line 750
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerOffReasons:Ljava/util/Set;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-interface {v3, v6}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 752
    :cond_3
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerLog:Lcom/android/internal/telephony/LocalLog;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "init : airplane mode = "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " enableCellularOnBoot = "

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v3, p2}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 756
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getCarrierActionAgent()Lcom/android/internal/telephony/CarrierActionAgent;

    move-result-object v6

    const/4 v7, 0x1

    const/16 v9, 0x33

    const/4 v10, 0x0

    const/4 v11, 0x0

    move-object v8, p0

    invoke-virtual/range {v6 .. v11}, Lcom/android/internal/telephony/CarrierActionAgent;->registerForCarrierAction(ILandroid/os/Handler;ILjava/lang/Object;Z)V

    .line 760
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p2

    .line 761
    new-instance v2, Landroid/content/IntentFilter;

    invoke-direct {v2}, Landroid/content/IntentFilter;-><init>()V

    const-string v3, "android.intent.action.LOCALE_CHANGED"

    .line 762
    invoke-virtual {v2, v3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v3, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 763
    invoke-virtual {v2, v3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v3, "android.telephony.action.NETWORK_COUNTRY_CHANGED"

    .line 764
    invoke-virtual {v2, v3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 765
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {p2, v3, v2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 767
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p2, v1}, Lcom/android/internal/telephony/Phone;->notifyOtaspChanged(I)V

    .line 769
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0x17

    invoke-interface {p2, p0, v1, v0}, Lcom/android/internal/telephony/CommandsInterface;->setOnRestrictedStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 770
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updatePhoneType()V

    .line 772
    new-instance p2, Lcom/android/internal/telephony/CarrierServiceStateTracker;

    invoke-direct {p2, p1, p0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;-><init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/ServiceStateTracker;)V

    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSST:Lcom/android/internal/telephony/CarrierServiceStateTracker;

    const/16 p1, 0x65

    .line 774
    invoke-virtual {p0, p2, p1, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForNetworkAttached(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 776
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSST:Lcom/android/internal/telephony/CarrierServiceStateTracker;

    const/16 p2, 0x66

    invoke-virtual {p0, p1, p2, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForNetworkDetached(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 778
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSST:Lcom/android/internal/telephony/CarrierServiceStateTracker;

    const/16 p2, 0x67

    invoke-virtual {p0, v4, p1, p2, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForDataConnectionAttached(ILandroid/os/Handler;ILjava/lang/Object;)V

    .line 780
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSST:Lcom/android/internal/telephony/CarrierServiceStateTracker;

    const/16 p2, 0x68

    invoke-virtual {p0, v4, p1, p2, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForDataConnectionDetached(ILandroid/os/Handler;ILjava/lang/Object;)V

    .line 782
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSST:Lcom/android/internal/telephony/CarrierServiceStateTracker;

    const/16 p2, 0x69

    invoke-virtual {p0, p1, p2, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForImsCapabilityChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 785
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p1

    if-eqz p1, :cond_4

    .line 786
    invoke-virtual {p0, v5}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    :cond_4
    return-void
.end method

.method private cancelAllNotifications()V
    .locals 3

    .line 4656
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "cancelAllNotifications: mPrevSubId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrevSubId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 4657
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 4658
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "notification"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/NotificationManager;

    .line 4659
    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrevSubId:I

    invoke-static {v1}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 4660
    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrevSubId:I

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    const/16 v2, 0x378

    invoke-virtual {v0, v1, v2}, Landroid/app/NotificationManager;->cancel(Ljava/lang/String;I)V

    .line 4661
    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrevSubId:I

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    const/16 v2, 0x3e7

    invoke-virtual {v0, v1, v2}, Landroid/app/NotificationManager;->cancel(Ljava/lang/String;I)V

    .line 4662
    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrevSubId:I

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    const/16 v2, 0x6f

    invoke-virtual {v0, v1, v2}, Landroid/app/NotificationManager;->cancel(Ljava/lang/String;I)V

    .line 4665
    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrevSubId:I

    const-string v2, "EmergencyNetworkNotification"

    invoke-virtual {v0, v2, v1}, Landroid/app/NotificationManager;->cancel(Ljava/lang/String;I)V

    .line 4667
    iget p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrevSubId:I

    const-string v1, "PrefNetworkNotification"

    invoke-virtual {v0, v1, p0}, Landroid/app/NotificationManager;->cancel(Ljava/lang/String;I)V

    :cond_0
    return-void
.end method

.method private currentMccEqualsSimMcc(Landroid/telephony/ServiceState;)Z
    .locals 2

    .line 4384
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "phone"

    .line 4385
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    .line 4386
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/telephony/TelephonyManager;->getSimOperatorNumericForPhone(I)Ljava/lang/String;

    move-result-object p0

    .line 4387
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object p1

    const/4 v0, 0x3

    const/4 v1, 0x0

    .line 4391
    :try_start_0
    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    .line 4392
    invoke-virtual {p1, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 p0, 0x1

    :goto_0
    return p0
.end method

.method private dumpCellInfoList(Ljava/io/PrintWriter;)V
    .locals 2

    const-string v0, " mLastCellInfoList={"

    .line 5474
    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 5475
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoList:Ljava/util/List;

    if-eqz p0, :cond_1

    const/4 v0, 0x1

    .line 5477
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/CellInfo;

    if-nez v0, :cond_0

    const-string v0, ","

    .line 5479
    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    :cond_0
    const/4 v0, 0x0

    .line 5482
    invoke-virtual {v1}, Landroid/telephony/CellInfo;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    const-string/jumbo p0, "}"

    .line 5485
    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    return-void
.end method

.method protected static getAreaCodeFromCellIdentity(Landroid/telephony/CellIdentity;)I
    .locals 3

    const v0, 0x7fffffff

    if-nez p0, :cond_0

    return v0

    .line 2585
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/CellIdentity;->getType()I

    move-result v1

    const/4 v2, 0x1

    if-eq v1, v2, :cond_5

    const/4 v2, 0x3

    if-eq v1, v2, :cond_4

    const/4 v2, 0x4

    if-eq v1, v2, :cond_3

    const/4 v2, 0x5

    if-eq v1, v2, :cond_2

    const/4 v2, 0x6

    if-eq v1, v2, :cond_1

    return v0

    .line 2590
    :cond_1
    check-cast p0, Landroid/telephony/CellIdentityNr;

    invoke-virtual {p0}, Landroid/telephony/CellIdentityNr;->getTac()I

    move-result p0

    return p0

    .line 2588
    :cond_2
    check-cast p0, Landroid/telephony/CellIdentityTdscdma;

    invoke-virtual {p0}, Landroid/telephony/CellIdentityTdscdma;->getLac()I

    move-result p0

    return p0

    .line 2587
    :cond_3
    check-cast p0, Landroid/telephony/CellIdentityWcdma;

    invoke-virtual {p0}, Landroid/telephony/CellIdentityWcdma;->getLac()I

    move-result p0

    return p0

    .line 2589
    :cond_4
    check-cast p0, Landroid/telephony/CellIdentityLte;

    invoke-virtual {p0}, Landroid/telephony/CellIdentityLte;->getTac()I

    move-result p0

    return p0

    .line 2586
    :cond_5
    check-cast p0, Landroid/telephony/CellIdentityGsm;

    invoke-virtual {p0}, Landroid/telephony/CellIdentityGsm;->getLac()I

    move-result p0

    return p0
.end method

.method private static getBandwidthsFromConfigs(Ljava/util/List;)[I
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/PhysicalChannelConfig;",
            ">;)[I"
        }
    .end annotation

    .line 1834
    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda0;-><init>()V

    .line 1835
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;

    invoke-direct {v0}, Lcom/android/internal/telephony/RILUtils$$ExternalSyntheticLambda5;-><init>()V

    .line 1836
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->mapToInt(Ljava/util/function/ToIntFunction;)Ljava/util/stream/IntStream;

    move-result-object p0

    .line 1837
    invoke-interface {p0}, Ljava/util/stream/IntStream;->toArray()[I

    move-result-object p0

    return-object p0
.end method

.method private static getCellIdentityFromCellInfo(Ljava/util/List;)Landroid/telephony/CellIdentity;
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/CellInfo;",
            ">;)",
            "Landroid/telephony/CellIdentity;"
        }
    .end annotation

    const/4 v0, 0x0

    if-eqz p0, :cond_3

    .line 4599
    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v1

    if-lez v1, :cond_3

    .line 4601
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    move-object v1, v0

    :cond_0
    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/CellInfo;

    .line 4602
    invoke-virtual {v2}, Landroid/telephony/CellInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v2

    .line 4603
    instance-of v3, v2, Landroid/telephony/CellIdentityLte;

    const-wide/16 v4, -0x1

    if-eqz v3, :cond_1

    if-nez v1, :cond_1

    .line 4604
    invoke-static {v2}, Lcom/android/internal/telephony/ServiceStateTracker;->getCidFromCellIdentity(Landroid/telephony/CellIdentity;)J

    move-result-wide v6

    cmp-long v3, v6, v4

    if-eqz v3, :cond_0

    move-object v1, v2

    goto :goto_0

    .line 4607
    :cond_1
    invoke-static {v2}, Lcom/android/internal/telephony/ServiceStateTracker;->getCidFromCellIdentity(Landroid/telephony/CellIdentity;)J

    move-result-wide v6

    cmp-long v3, v6, v4

    if-eqz v3, :cond_0

    move-object v0, v2

    :cond_2
    if-nez v0, :cond_3

    if-eqz v1, :cond_3

    move-object v0, v1

    :cond_3
    return-object v0
.end method

.method protected static getCidFromCellIdentity(Landroid/telephony/CellIdentity;)J
    .locals 6

    const-wide/16 v0, -0x1

    if-nez p0, :cond_0

    return-wide v0

    .line 2563
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/CellIdentity;->getType()I

    move-result v2

    const/4 v3, 0x1

    const/4 v4, 0x6

    if-eq v2, v3, :cond_5

    const/4 v3, 0x3

    if-eq v2, v3, :cond_4

    const/4 v3, 0x4

    if-eq v2, v3, :cond_3

    const/4 v3, 0x5

    if-eq v2, v3, :cond_2

    if-eq v2, v4, :cond_1

    move-wide v2, v0

    goto :goto_1

    .line 2568
    :cond_1
    move-object v2, p0

    check-cast v2, Landroid/telephony/CellIdentityNr;

    invoke-virtual {v2}, Landroid/telephony/CellIdentityNr;->getNci()J

    move-result-wide v2

    goto :goto_1

    .line 2566
    :cond_2
    move-object v2, p0

    check-cast v2, Landroid/telephony/CellIdentityTdscdma;

    invoke-virtual {v2}, Landroid/telephony/CellIdentityTdscdma;->getCid()I

    move-result v2

    goto :goto_0

    .line 2565
    :cond_3
    move-object v2, p0

    check-cast v2, Landroid/telephony/CellIdentityWcdma;

    invoke-virtual {v2}, Landroid/telephony/CellIdentityWcdma;->getCid()I

    move-result v2

    goto :goto_0

    .line 2567
    :cond_4
    move-object v2, p0

    check-cast v2, Landroid/telephony/CellIdentityLte;

    invoke-virtual {v2}, Landroid/telephony/CellIdentityLte;->getCi()I

    move-result v2

    goto :goto_0

    .line 2564
    :cond_5
    move-object v2, p0

    check-cast v2, Landroid/telephony/CellIdentityGsm;

    invoke-virtual {v2}, Landroid/telephony/CellIdentityGsm;->getCid()I

    move-result v2

    :goto_0
    int-to-long v2, v2

    .line 2572
    :goto_1
    invoke-virtual {p0}, Landroid/telephony/CellIdentity;->getType()I

    move-result p0

    if-ne p0, v4, :cond_6

    const-wide v4, 0x7fffffffffffffffL

    goto :goto_2

    :cond_6
    const-wide/32 v4, 0x7fffffff

    :goto_2
    cmp-long p0, v2, v4

    if-nez p0, :cond_7

    goto :goto_3

    :cond_7
    move-wide v0, v2

    :goto_3
    return-wide v0
.end method

.method private static getPrimaryPhysicalChannelConfigForCell(Ljava/util/List;Landroid/telephony/CellIdentity;)Landroid/telephony/PhysicalChannelConfig;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/PhysicalChannelConfig;",
            ">;",
            "Landroid/telephony/CellIdentity;",
            ")",
            "Landroid/telephony/PhysicalChannelConfig;"
        }
    .end annotation

    .line 2683
    invoke-static {p0}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty(Ljava/util/Collection;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_3

    instance-of v0, p1, Landroid/telephony/CellIdentityLte;

    if-nez v0, :cond_0

    instance-of v2, p1, Landroid/telephony/CellIdentityNr;

    if-nez v2, :cond_0

    goto :goto_1

    :cond_0
    if-eqz v0, :cond_1

    const/16 v0, 0xd

    .line 2691
    check-cast p1, Landroid/telephony/CellIdentityLte;

    invoke-virtual {p1}, Landroid/telephony/CellIdentityLte;->getPci()I

    move-result p1

    goto :goto_0

    :cond_1
    const/16 v0, 0x14

    .line 2694
    check-cast p1, Landroid/telephony/CellIdentityNr;

    invoke-virtual {p1}, Landroid/telephony/CellIdentityNr;->getPci()I

    move-result p1

    .line 2697
    :goto_0
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_2
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/PhysicalChannelConfig;

    .line 2698
    invoke-virtual {v2}, Landroid/telephony/PhysicalChannelConfig;->getConnectionStatus()I

    move-result v3

    const/4 v4, 0x1

    if-ne v3, v4, :cond_2

    .line 2699
    invoke-virtual {v2}, Landroid/telephony/PhysicalChannelConfig;->getNetworkType()I

    move-result v3

    if-ne v3, v0, :cond_2

    invoke-virtual {v2}, Landroid/telephony/PhysicalChannelConfig;->getPhysicalCellId()I

    move-result v3

    if-ne v3, p1, :cond_2

    return-object v2

    :cond_3
    :goto_1
    return-object v1
.end method

.method public static getPrioritizedCellIdentities(Landroid/telephony/ServiceState;)Ljava/util/List;
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/telephony/ServiceState;",
            ")",
            "Ljava/util/List<",
            "Landroid/telephony/CellIdentity;",
            ">;"
        }
    .end annotation

    .line 3556
    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfoList()Ljava/util/List;

    move-result-object p0

    .line 3557
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object p0

    return-object p0

    .line 3559
    :cond_0
    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda1;

    invoke-direct {v0}, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda1;-><init>()V

    .line 3560
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda2;

    invoke-direct {v0}, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda2;-><init>()V

    .line 3561
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda3;

    invoke-direct {v0}, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda3;-><init>()V

    .line 3563
    invoke-static {v0}, Ljava/util/Comparator;->comparing(Ljava/util/function/Function;)Ljava/util/Comparator;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda4;

    invoke-direct {v1}, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda4;-><init>()V

    .line 3564
    invoke-interface {v0, v1}, Ljava/util/Comparator;->thenComparing(Ljava/util/function/Function;)Ljava/util/Comparator;

    move-result-object v0

    .line 3565
    invoke-interface {v0}, Ljava/util/Comparator;->reversed()Ljava/util/Comparator;

    move-result-object v0

    .line 3562
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->sorted(Ljava/util/Comparator;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda5;

    invoke-direct {v0}, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda5;-><init>()V

    .line 3566
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 3567
    invoke-interface {p0}, Ljava/util/stream/Stream;->distinct()Ljava/util/stream/Stream;

    move-result-object p0

    .line 3568
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    return-object p0
.end method

.method private getRegistrationInfo(I)Landroid/util/Pair;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I)",
            "Landroid/util/Pair<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 957
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    const/4 v1, 0x2

    invoke-virtual {v0, v1, p1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 961
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v0

    .line 960
    invoke-static {v0}, Landroid/telephony/ServiceState;->networkTypeToRilRadioTechnology(I)I

    move-result v0

    .line 962
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->regCodeToServiceState(I)I

    move-result p0

    .line 963
    new-instance p1, Landroid/util/Pair;

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-direct {p1, p0, v0}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    return-object p1

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method protected static getRilDataRadioTechnologyForWwan(Landroid/telephony/ServiceState;)I
    .locals 2

    const/4 v0, 0x2

    const/4 v1, 0x1

    .line 6048
    invoke-virtual {p0, v0, v1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 6052
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result p0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    .line 6054
    :goto_0
    invoke-static {p0}, Landroid/telephony/ServiceState;->networkTypeToRilRadioTechnology(I)I

    move-result p0

    return p0
.end method

.method private iccCardExists()Z
    .locals 2

    .line 5339
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    const/4 v0, 0x0

    if-eqz p0, :cond_0

    .line 5340
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getState()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    move-result-object p0

    sget-object v1, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;->APPSTATE_UNKNOWN:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    if-eq p0, v1, :cond_0

    const/4 p0, 0x1

    move v0, p0

    :cond_0
    return v0
.end method

.method private isInNetwork(Landroid/os/BaseBundle;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 0

    .line 5877
    invoke-virtual {p1, p3}, Landroid/os/BaseBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 5879
    invoke-static {p0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0, p2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method private isInternetPhysicalChannelConfig(Landroid/telephony/PhysicalChannelConfig;)Z
    .locals 6

    .line 2233
    invoke-virtual {p1}, Landroid/telephony/PhysicalChannelConfig;->getContextIds()[I

    move-result-object p1

    array-length v0, p1

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_2

    aget v3, p1, v2

    .line 2234
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v4

    const/4 v5, 0x1

    if-eqz v4, :cond_0

    .line 2235
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object v4

    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->isInternetNetwork(I)Z

    move-result v3

    if-eqz v3, :cond_1

    return v5

    .line 2239
    :cond_0
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v4, v5}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v4

    .line 2241
    invoke-virtual {v4, v3}, Lcom/android/internal/telephony/dataconnection/DcTracker;->getDataConnectionByContextId(I)Lcom/android/internal/telephony/dataconnection/DataConnection;

    move-result-object v3

    if-eqz v3, :cond_1

    .line 2242
    invoke-virtual {v3}, Lcom/android/internal/telephony/dataconnection/DataConnection;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v3

    const/16 v4, 0xc

    invoke-virtual {v3, v4}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z

    move-result v3

    if-eqz v3, :cond_1

    return v5

    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    return v1
.end method

.method private isNrPhysicalChannelConfig(Landroid/telephony/PhysicalChannelConfig;)Z
    .locals 0

    .line 2229
    invoke-virtual {p1}, Landroid/telephony/PhysicalChannelConfig;->getNetworkType()I

    move-result p0

    const/16 p1, 0x14

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isSameNamedOperators(Landroid/telephony/ServiceState;)Z
    .locals 1

    .line 4374
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->currentMccEqualsSimMcc(Landroid/telephony/ServiceState;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->isSameOperatorNameFromSimAndSS(Landroid/telephony/ServiceState;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isSameOperatorNameFromSimAndSS(Landroid/telephony/ServiceState;)Z
    .locals 4

    .line 4351
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "phone"

    .line 4352
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    .line 4353
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/telephony/TelephonyManager;->getSimOperatorNameForPhone(I)Ljava/lang/String;

    move-result-object p0

    .line 4357
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaLong()Ljava/lang/String;

    move-result-object v0

    .line 4358
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaShort()Ljava/lang/String;

    move-result-object p1

    .line 4360
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-nez v1, :cond_0

    invoke-virtual {p0, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    move v0, v2

    goto :goto_0

    :cond_0
    move v0, v3

    .line 4361
    :goto_0
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_1

    invoke-virtual {p0, p1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_1

    move p0, v2

    goto :goto_1

    :cond_1
    move p0, v3

    :goto_1
    if-nez v0, :cond_3

    if-eqz p0, :cond_2

    goto :goto_2

    :cond_2
    move v2, v3

    :cond_3
    :goto_2
    return v2
.end method

.method private isSimAbsent()Z
    .locals 2

    .line 1820
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    const/4 v1, 0x1

    if-nez v0, :cond_0

    goto :goto_0

    .line 1823
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCard(I)Lcom/android/internal/telephony/uicc/UiccCard;

    move-result-object p0

    if-nez p0, :cond_1

    goto :goto_0

    .line 1827
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccCard;->getCardState()Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    move-result-object p0

    sget-object v0, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_ABSENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    if-ne p0, v0, :cond_2

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    move v1, p0

    :goto_0
    return v1
.end method

.method private static isValidLteBandwidthKhz(I)Z
    .locals 1

    const/16 v0, 0x578

    if-eq p0, v0, :cond_0

    const/16 v0, 0xbb8

    if-eq p0, v0, :cond_0

    const/16 v0, 0x1388

    if-eq p0, v0, :cond_0

    const/16 v0, 0x2710

    if-eq p0, v0, :cond_0

    const/16 v0, 0x3a98

    if-eq p0, v0, :cond_0

    const/16 v0, 0x4e20

    if-eq p0, v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method private static isValidNrBandwidthKhz(I)Z
    .locals 0

    sparse-switch p0, :sswitch_data_0

    const/4 p0, 0x0

    return p0

    :sswitch_0
    const/4 p0, 0x1

    return p0

    nop

    :sswitch_data_0
    .sparse-switch
        0x1388 -> :sswitch_0
        0x2710 -> :sswitch_0
        0x3a98 -> :sswitch_0
        0x4e20 -> :sswitch_0
        0x61a8 -> :sswitch_0
        0x7530 -> :sswitch_0
        0x9c40 -> :sswitch_0
        0xc350 -> :sswitch_0
        0xea60 -> :sswitch_0
        0x11170 -> :sswitch_0
        0x13880 -> :sswitch_0
        0x15f90 -> :sswitch_0
        0x186a0 -> :sswitch_0
    .end sparse-switch
.end method

.method private static synthetic lambda$getPrioritizedCellIdentities$0(Landroid/telephony/NetworkRegistrationInfo;)Z
    .locals 0

    .line 3560
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$getPrioritizedCellIdentities$1(Landroid/telephony/NetworkRegistrationInfo;)Z
    .locals 1

    .line 3561
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getTransportType()I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private static synthetic lambda$getPrioritizedCellIdentities$2(Landroid/telephony/NetworkRegistrationInfo;)Ljava/lang/Integer;
    .locals 0

    .line 3564
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getDomain()I

    move-result p0

    and-int/lit8 p0, p0, 0x1

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getPrioritizedCellIdentities$3(Landroid/telephony/NetworkRegistrationInfo;)Landroid/telephony/CellIdentity;
    .locals 0

    .line 3566
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object p0

    return-object p0
.end method

.method private networkCountryIsoChanged(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 2

    .line 5320
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p1, "countryIsoChanged: no new country ISO code"

    .line 5322
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    const/4 p0, 0x0

    return p0

    .line 5327
    :cond_0
    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_1

    const-string p1, "countryIsoChanged: no previous country ISO code"

    .line 5329
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return v1

    .line 5333
    :cond_1
    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    xor-int/2addr p0, v1

    return p0
.end method

.method private notifyCdmaSubscriptionInfoReady()V
    .locals 1

    .line 4888
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaForSubscriptionInfoReadyRegistrants:Lcom/android/internal/telephony/RegistrantList;

    if-eqz v0, :cond_0

    const-string v0, "CDMA_SUBSCRIPTION: call notifyRegistrants()"

    .line 4889
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 4890
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaForSubscriptionInfoReadyRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_0
    return-void
.end method

.method private onCarrierConfigChanged()V
    .locals 3

    .line 5271
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    .line 5272
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "CarrierConfigChange "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5275
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

    if-eqz v1, :cond_0

    .line 5276
    invoke-virtual {v1}, Lcom/android/internal/telephony/cdma/EriManager;->loadEriFile()V

    .line 5277
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getOperatorNameFromEri()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfForEri(Ljava/lang/String;)V

    .line 5280
    :cond_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOperatorNamePattern(Landroid/os/PersistableBundle;)V

    .line 5281
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfFromCarrierConfig(Landroid/os/PersistableBundle;)V

    .line 5282
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifyCallForwardingIndicator()V

    const/4 v0, 0x0

    .line 5287
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateInternal(Z)V

    return-void
.end method

.method private onRestrictedStateChanged(Landroid/os/AsyncResult;)V
    .locals 5

    .line 4457
    new-instance v0, Lcom/android/internal/telephony/RestrictedState;

    invoke-direct {v0}, Lcom/android/internal/telephony/RestrictedState;-><init>()V

    .line 4459
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onRestrictedStateChanged: E rs "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 4461
    iget-object v1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v1, :cond_14

    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz p1, :cond_14

    .line 4462
    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    and-int/lit8 v1, p1, 0x1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-nez v1, :cond_1

    and-int/lit8 v1, p1, 0x4

    if-eqz v1, :cond_0

    goto :goto_0

    :cond_0
    move v1, v2

    goto :goto_1

    :cond_1
    :goto_0
    move v1, v3

    .line 4464
    :goto_1
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/RestrictedState;->setCsEmergencyRestricted(Z)V

    .line 4468
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    if-eqz v1, :cond_5

    invoke-virtual {v1}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getState()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    move-result-object v1

    sget-object v4, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;->APPSTATE_READY:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    if-ne v1, v4, :cond_5

    and-int/lit8 v1, p1, 0x2

    if-nez v1, :cond_3

    and-int/lit8 v1, p1, 0x4

    if-eqz v1, :cond_2

    goto :goto_2

    :cond_2
    move v1, v2

    goto :goto_3

    :cond_3
    :goto_2
    move v1, v3

    .line 4469
    :goto_3
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/RestrictedState;->setCsNormalRestricted(Z)V

    and-int/lit8 p1, p1, 0x10

    if-eqz p1, :cond_4

    move v2, v3

    .line 4472
    :cond_4
    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/RestrictedState;->setPsRestricted(Z)V

    .line 4476
    :cond_5
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onRestrictedStateChanged: new rs "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 4478
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RestrictedState;->isPsRestricted()Z

    move-result p1

    if-nez p1, :cond_6

    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isPsRestricted()Z

    move-result p1

    if-eqz p1, :cond_6

    .line 4479
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPsRestrictEnabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    const/16 p1, 0x3e9

    .line 4480
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto :goto_4

    .line 4481
    :cond_6
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RestrictedState;->isPsRestricted()Z

    move-result p1

    if-eqz p1, :cond_7

    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isPsRestricted()Z

    move-result p1

    if-nez p1, :cond_7

    .line 4482
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPsRestrictDisabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    const/16 p1, 0x3ea

    .line 4483
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    .line 4491
    :cond_7
    :goto_4
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RestrictedState;->isCsRestricted()Z

    move-result p1

    const/16 v1, 0x3ed

    const/16 v2, 0x3ee

    const/16 v3, 0x3ec

    if-eqz p1, :cond_a

    .line 4492
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isAnyCsRestricted()Z

    move-result p1

    if-nez p1, :cond_8

    .line 4494
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto/16 :goto_5

    .line 4495
    :cond_8
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isCsNormalRestricted()Z

    move-result p1

    if-nez p1, :cond_9

    .line 4497
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto/16 :goto_5

    .line 4498
    :cond_9
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isCsEmergencyRestricted()Z

    move-result p1

    if-nez p1, :cond_13

    .line 4500
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto/16 :goto_5

    .line 4502
    :cond_a
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RestrictedState;->isCsEmergencyRestricted()Z

    move-result p1

    const/16 v4, 0x3eb

    if-eqz p1, :cond_d

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    .line 4503
    invoke-virtual {p1}, Lcom/android/internal/telephony/RestrictedState;->isCsNormalRestricted()Z

    move-result p1

    if-nez p1, :cond_d

    .line 4504
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isAnyCsRestricted()Z

    move-result p1

    if-nez p1, :cond_b

    .line 4506
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto :goto_5

    .line 4507
    :cond_b
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isCsRestricted()Z

    move-result p1

    if-eqz p1, :cond_c

    .line 4509
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto :goto_5

    .line 4510
    :cond_c
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isCsNormalRestricted()Z

    move-result p1

    if-eqz p1, :cond_13

    .line 4512
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto :goto_5

    .line 4514
    :cond_d
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {p1}, Lcom/android/internal/telephony/RestrictedState;->isCsEmergencyRestricted()Z

    move-result p1

    if-nez p1, :cond_10

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    .line 4515
    invoke-virtual {p1}, Lcom/android/internal/telephony/RestrictedState;->isCsNormalRestricted()Z

    move-result p1

    if-eqz p1, :cond_10

    .line 4516
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isAnyCsRestricted()Z

    move-result p1

    if-nez p1, :cond_e

    .line 4518
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto :goto_5

    .line 4519
    :cond_e
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isCsRestricted()Z

    move-result p1

    if-eqz p1, :cond_f

    .line 4521
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto :goto_5

    .line 4522
    :cond_f
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isCsEmergencyRestricted()Z

    move-result p1

    if-eqz p1, :cond_13

    .line 4524
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto :goto_5

    .line 4527
    :cond_10
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isCsRestricted()Z

    move-result p1

    if-eqz p1, :cond_11

    .line 4529
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto :goto_5

    .line 4530
    :cond_11
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isCsEmergencyRestricted()Z

    move-result p1

    if-eqz p1, :cond_12

    .line 4532
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    goto :goto_5

    .line 4533
    :cond_12
    invoke-virtual {v0}, Lcom/android/internal/telephony/RestrictedState;->isCsNormalRestricted()Z

    move-result p1

    if-eqz p1, :cond_13

    .line 4535
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    .line 4539
    :cond_13
    :goto_5
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    .line 4541
    :cond_14
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "onRestrictedStateChanged: X rs "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void
.end method

.method private saveCdmaSubscriptionSource(I)V
    .locals 3

    .line 5437
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Storing cdma subscription source: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5438
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string/jumbo v1, "subscription_mode"

    invoke-static {v0, v1, p1}, Landroid/provider/Settings$Global;->putInt(Landroid/content/ContentResolver;Ljava/lang/String;I)Z

    .line 5441
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Read from settings: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const/4 v2, -0x1

    invoke-static {v0, v1, v2}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void
.end method

.method private selectResourceForRejectCode(IZ)I
    .locals 0

    const/4 p0, 0x1

    if-eq p1, p0, :cond_6

    const/4 p0, 0x2

    if-eq p1, p0, :cond_4

    const/4 p0, 0x3

    if-eq p1, p0, :cond_2

    const/4 p0, 0x6

    if-eq p1, p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    if-eqz p2, :cond_1

    const p0, 0x10405bd

    goto :goto_0

    :cond_1
    const p0, 0x10405bc

    goto :goto_0

    :cond_2
    if-eqz p2, :cond_3

    const p0, 0x10405bf

    goto :goto_0

    :cond_3
    const p0, 0x10405be

    goto :goto_0

    :cond_4
    if-eqz p2, :cond_5

    const p0, 0x10405c1

    goto :goto_0

    :cond_5
    const p0, 0x10405c0

    goto :goto_0

    :cond_6
    if-eqz p2, :cond_7

    const p0, 0x10405bb

    goto :goto_0

    :cond_7
    const p0, 0x10405ba

    :goto_0
    return p0
.end method

.method private updateOperatorNameForCellIdentity(Landroid/telephony/CellIdentity;)V
    .locals 1

    if-nez p1, :cond_0

    return-void

    .line 6002
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/CellIdentity;->getOperatorAlphaLong()Ljava/lang/CharSequence;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->filterOperatorNameByPattern(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 6001
    invoke-virtual {p1, v0}, Landroid/telephony/CellIdentity;->setOperatorAlphaLong(Ljava/lang/String;)V

    .line 6004
    invoke-virtual {p1}, Landroid/telephony/CellIdentity;->getOperatorAlphaShort()Ljava/lang/CharSequence;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->filterOperatorNameByPattern(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 6003
    invoke-virtual {p1, p0}, Landroid/telephony/CellIdentity;->setOperatorAlphaShort(Ljava/lang/String;)V

    return-void
.end method

.method private updateOperatorNamePattern(Landroid/os/PersistableBundle;)V
    .locals 1

    const-string v0, "operator_name_filter_pattern_string"

    .line 5963
    invoke-virtual {p1, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 5965
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 5966
    invoke-static {p1}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mOperatorNameStringPattern:Ljava/util/regex/Pattern;

    .line 5968
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "mOperatorNameStringPattern: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mOperatorNameStringPattern:Ljava/util/regex/Pattern;

    invoke-virtual {v0}, Ljava/util/regex/Pattern;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method private updateSpnDisplayCdnr()V
    .locals 1

    const-string/jumbo v0, "updateSpnDisplayCdnr+"

    .line 2901
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2902
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getCarrierDisplayNameData()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object v0

    .line 2903
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->notifySpnDisplayUpdate(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)V

    const-string/jumbo v0, "updateSpnDisplayCdnr-"

    .line 2904
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method protected final alwaysOnHomeNetwork(Landroid/os/BaseBundle;)Z
    .locals 0

    const-string p0, "force_home_network_bool"

    .line 5862
    invoke-virtual {p1, p0}, Landroid/os/BaseBundle;->getBoolean(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method protected cancelDelayRadioOffWaitingForImsDeregTimeout()V
    .locals 2

    const/16 v0, 0x3e

    .line 3266
    invoke-virtual {p0, v0}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "cancelDelayRadioOffWaitingForImsDeregTimeout: cancelling."

    .line 3267
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3268
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V

    :cond_0
    return-void
.end method

.method protected declared-synchronized cancelPendingRadioPowerOff()V
    .locals 1

    monitor-enter p0

    .line 3252
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    if-eqz v0, :cond_0

    const-string v0, "cancelPendingRadioPowerOff: cancelling."

    .line 3253
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 3254
    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    const/16 v0, 0x26

    .line 3255
    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeMessages(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 3257
    :cond_0
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method protected cancelPollState()V
    .locals 1

    const/4 v0, 0x1

    new-array v0, v0, [I

    .line 5309
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    return-void
.end method

.method protected checkCorrectThread()V
    .locals 1

    .line 5609
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Looper;->getThread()Ljava/lang/Thread;

    move-result-object p0

    if-ne v0, p0, :cond_0

    return-void

    .line 5610
    :cond_0
    new-instance p0, Ljava/lang/RuntimeException;

    const-string v0, "ServiceStateTracker must be used from within one thread"

    invoke-direct {p0, v0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public clearAllRadioOffReasons()V
    .locals 0

    .line 1126
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerOffReasons:Ljava/util/Set;

    invoke-interface {p0}, Ljava/util/Set;->clear()V

    return-void
.end method

.method protected combinePsRegistrationStates(Landroid/telephony/ServiceState;)V
    .locals 6

    const/4 v0, 0x2

    .line 2263
    invoke-virtual {p1, v0, v0}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v1

    const/4 v2, 0x1

    .line 2265
    invoke-virtual {p1, v0, v2}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v0

    .line 2269
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v3}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isAnyApnOnIwlan()Z

    move-result v3

    .line 2270
    invoke-virtual {p1, v3}, Landroid/telephony/ServiceState;->setIwlanPreferred(Z)V

    if-eqz v1, :cond_0

    .line 2272
    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v4

    const/16 v5, 0x12

    if-ne v4, v5, :cond_0

    .line 2274
    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v1

    if-ne v1, v2, :cond_0

    if-eqz v3, :cond_0

    const/4 v0, 0x0

    .line 2277
    invoke-virtual {p1, v0}, Landroid/telephony/ServiceState;->setDataRegState(I)V

    goto :goto_0

    :cond_0
    if-eqz v0, :cond_1

    .line 2281
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v0

    .line 2282
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->regCodeToServiceState(I)I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/telephony/ServiceState;->setDataRegState(I)V

    .line 2285
    :cond_1
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "combinePsRegistrationStates: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void
.end method

.method public disableLocationUpdates()V
    .locals 2

    const/4 v0, 0x0

    .line 1237
    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantContinuousLocationUpdates:Z

    .line 1238
    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantSingleLocationUpdate:Z

    if-nez v1, :cond_0

    .line 1239
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1, v1}, Lcom/android/internal/telephony/CommandsInterface;->setLocationUpdates(ZLandroid/os/WorkSource;Landroid/os/Message;)V

    :cond_0
    return-void
.end method

.method protected disableSingleLocationUpdate()V
    .locals 2

    const/4 v0, 0x0

    .line 1230
    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantSingleLocationUpdate:Z

    .line 1231
    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantContinuousLocationUpdates:Z

    if-nez v1, :cond_0

    .line 1232
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1, v1}, Lcom/android/internal/telephony/CommandsInterface;->setLocationUpdates(ZLandroid/os/WorkSource;Landroid/os/Message;)V

    :cond_0
    return-void
.end method

.method public dispose()V
    .locals 2

    .line 908
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/SignalStrengthController;->dispose()V

    .line 909
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/uicc/UiccController;->unregisterForIccChanged(Landroid/os/Handler;)V

    .line 910
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForCellInfoList(Landroid/os/Handler;)V

    .line 911
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForPhysicalChannelConfiguration(Landroid/os/Handler;)V

    .line 912
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubscriptionManager:Landroid/telephony/SubscriptionManager;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mOnSubscriptionsChangedListener:Lcom/android/internal/telephony/ServiceStateTracker$SstSubscriptionsChangedListener;

    .line 913
    invoke-virtual {v0, v1}, Landroid/telephony/SubscriptionManager;->removeOnSubscriptionsChangedListener(Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;)V

    .line 914
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForImsNetworkStateChanged(Landroid/os/Handler;)V

    .line 915
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCarrierActionAgent()Lcom/android/internal/telephony/CarrierActionAgent;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/CarrierActionAgent;->unregisterForCarrierAction(Landroid/os/Handler;I)V

    .line 917
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 918
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSST:Lcom/android/internal/telephony/CarrierServiceStateTracker;

    if-eqz v0, :cond_0

    .line 919
    invoke-virtual {v0}, Lcom/android/internal/telephony/CarrierServiceStateTracker;->dispose()V

    const/4 v0, 0x0

    .line 920
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSST:Lcom/android/internal/telephony/CarrierServiceStateTracker;

    :cond_0
    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 4

    const-string v0, "ServiceStateTracker:"

    .line 5489
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5490
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mSubId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5491
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mSS="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5492
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mNewSS="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5493
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mVoiceCapable="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceCapable:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5494
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mRestrictedState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5495
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, " mPollingContext="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, " - "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 5496
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    const/4 v3, 0x0

    if-eqz v2, :cond_0

    aget v2, v2, v3

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    goto :goto_0

    :cond_0
    const-string v2, ""

    :goto_0
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 5495
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5497
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, " mDesiredPowerState="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDesiredPowerState:Z

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5498
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5499
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mPendingRadioPowerOffAfterDataOff="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5500
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mPendingRadioPowerOffAfterDataOffTag="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5501
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCellIdentity="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    invoke-static {v3, v1}, Lcom/android/telephony/Rlog;->pii(ZLjava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5502
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mLastCellInfoReqTime="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoReqTime:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5503
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->dumpCellInfoList(Ljava/io/PrintWriter;)V

    .line 5504
    invoke-virtual {p2}, Ljava/io/PrintWriter;->flush()V

    .line 5505
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mAllowedNetworkTypes="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAllowedNetworkTypes:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5506
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mAnyDataExisting="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAnyDataExisting:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5507
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mMaxDataCalls="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMaxDataCalls:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5508
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mNewMaxDataCalls="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewMaxDataCalls:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5509
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mReasonDataDenied="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mReasonDataDenied:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5510
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mNewReasonDataDenied="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewReasonDataDenied:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5511
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mGsmVoiceRoaming="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mGsmVoiceRoaming:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5512
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mGsmDataRoaming="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mGsmDataRoaming:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5513
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mEmergencyOnly="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEmergencyOnly:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5514
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCSEmergencyOnly="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSEmergencyOnly:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5515
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mPSEmergencyOnly="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPSEmergencyOnly:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5516
    invoke-virtual {p2}, Ljava/io/PrintWriter;->flush()V

    .line 5517
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {v0, p2}, Lcom/android/internal/telephony/NitzStateMachine;->dumpState(Ljava/io/PrintWriter;)V

    .line 5518
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mLastNitzData="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastNitzData:Lcom/android/internal/telephony/NitzData;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5519
    invoke-virtual {p2}, Ljava/io/PrintWriter;->flush()V

    .line 5520
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mStartedGprsRegCheck="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mStartedGprsRegCheck:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5521
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mReportedGprsNoReg="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mReportedGprsNoReg:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5522
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mNotification="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNotification:Landroid/app/Notification;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5523
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCurSpn="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurSpn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5524
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCurDataSpn="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurDataSpn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5525
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCurShowSpn="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurShowSpn:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5526
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCurPlmn="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurPlmn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5527
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCurShowPlmn="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurShowPlmn:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5528
    invoke-virtual {p2}, Ljava/io/PrintWriter;->flush()V

    .line 5529
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCurrentOtaspMode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurrentOtaspMode:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5530
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mRoamingIndicator="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingIndicator:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5531
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mIsInPrl="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsInPrl:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5532
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mDefaultRoamingIndicator="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDefaultRoamingIndicator:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5533
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mRegistrationState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegistrationState:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5534
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mMdn="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMdn:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5535
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mHomeSystemId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5536
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mHomeNetworkId="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeNetworkId:[I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5537
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mMin="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5538
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mPrlVersion="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrlVersion:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5539
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mIsMinInfoReady="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsMinInfoReady:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5540
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mIsEriTextLoaded="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsEriTextLoaded:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5541
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mIsSubscriptionFromRuim="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5542
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCdmaSSM="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5543
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mRegistrationDeniedReason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegistrationDeniedReason:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5544
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCurrentCarrier="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurrentCarrier:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5545
    invoke-virtual {p2}, Ljava/io/PrintWriter;->flush()V

    .line 5546
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mImsRegistered="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistered:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5547
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mImsRegistrationOnOff="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistrationOnOff:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5548
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " pending radio off event="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x3e

    .line 5549
    invoke-virtual {p0, v1}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 5548
    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5550
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mRadioDisabledByCarrier"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioDisabledByCarrier:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5551
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mDeviceShuttingDown="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5552
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mSpnUpdatePending="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSpnUpdatePending:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5553
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mCellInfoMinIntervalMs="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellInfoMinIntervalMs:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5554
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, " mEriManager="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5556
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLocaleTracker:Lcom/android/internal/telephony/LocaleTracker;

    invoke-virtual {v0, p1, p2, p3}, Lcom/android/internal/telephony/LocaleTracker;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 5557
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, "    "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 5559
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->dump(Lcom/android/internal/telephony/IndentingPrintWriter;)V

    const-string p2, " Carrier Display Name update records:"

    .line 5561
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5562
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 5563
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnrLogs:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 5564
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, " Roaming Log:"

    .line 5566
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5567
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 5568
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 5569
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, " Attach Log:"

    .line 5571
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5572
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 5573
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 5574
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, " Phone Change Log:"

    .line 5576
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5577
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 5578
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhoneTypeLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 5579
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, " Rat Change Log:"

    .line 5581
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5582
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 5583
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRatLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 5584
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string p2, " Radio power Log:"

    .line 5586
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 5587
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 5588
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p2, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 5589
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 5591
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {p0, p1, v0, p3}, Lcom/android/internal/telephony/NitzStateMachine;->dumpLogs(Ljava/io/FileDescriptor;Lcom/android/internal/telephony/IndentingPrintWriter;[Ljava/lang/String;)V

    .line 5593
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method public enableLocationUpdates()V
    .locals 4

    .line 1224
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantSingleLocationUpdate:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantContinuousLocationUpdates:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    .line 1225
    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantContinuousLocationUpdates:Z

    .line 1226
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v2, 0x0

    const/16 v3, 0x12

    invoke-virtual {p0, v3}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v1, v0, v2, p0}, Lcom/android/internal/telephony/CommandsInterface;->setLocationUpdates(ZLandroid/os/WorkSource;Landroid/os/Message;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public enableSingleLocationUpdate(Landroid/os/WorkSource;)V
    .locals 3

    .line 1218
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantSingleLocationUpdate:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantContinuousLocationUpdates:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    .line 1219
    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mWantSingleLocationUpdate:Z

    .line 1220
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v2, 0x12

    invoke-virtual {p0, v2}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v1, v0, p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->setLocationUpdates(ZLandroid/os/WorkSource;Landroid/os/Message;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public filterOperatorNameByPattern(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 6030
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mOperatorNameStringPattern:Ljava/util/regex/Pattern;

    if-eqz v0, :cond_2

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 6033
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mOperatorNameStringPattern:Ljava/util/regex/Pattern;

    invoke-virtual {v0, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    .line 6034
    invoke-virtual {v0}, Ljava/util/regex/Matcher;->find()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 6035
    invoke-virtual {v0}, Ljava/util/regex/Matcher;->groupCount()I

    move-result v1

    if-lez v1, :cond_1

    const/4 p0, 0x1

    .line 6036
    invoke-virtual {v0, p0}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object p1

    goto :goto_0

    :cond_1
    const-string v0, "filterOperatorNameByPattern: pattern no group"

    .line 6038
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    :cond_2
    :goto_0
    return-object p1
.end method

.method protected fixUnknownMcc(Ljava/lang/String;I)Ljava/lang/String;
    .locals 5
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    if-gtz p2, :cond_0

    return-object p1

    .line 4297
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastNitzData:Lcom/android/internal/telephony/NitzData;

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_2

    .line 4299
    invoke-virtual {v0}, Lcom/android/internal/telephony/NitzData;->getLocalOffsetMillis()I

    move-result v3

    const v4, 0x36ee80

    div-int/2addr v3, v4

    .line 4300
    invoke-virtual {v0}, Lcom/android/internal/telephony/NitzData;->getDstAdjustmentMillis()Ljava/lang/Integer;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 4301
    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    if-eqz v0, :cond_1

    move v2, v1

    :cond_1
    move v0, v2

    move v2, v3

    goto :goto_0

    :cond_2
    move v0, v2

    move v1, v0

    .line 4304
    :goto_0
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHbpcdUtils:Lcom/android/internal/telephony/HbpcdUtils;

    invoke-virtual {p0, p2, v2, v0, v1}, Lcom/android/internal/telephony/HbpcdUtils;->getMcc(IIIZ)I

    move-result p0

    if-lez p0, :cond_3

    .line 4306
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "00"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    :cond_3
    return-object p1
.end method

.method public getAllCellInfo()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/telephony/CellInfo;",
            ">;"
        }
    .end annotation

    .line 5351
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoList:Ljava/util/List;

    return-object p0
.end method

.method protected getCarrierConfig()Landroid/os/PersistableBundle;
    .locals 2

    .line 5941
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "carrier_config"

    .line 5942
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CarrierConfigManager;

    if-eqz v0, :cond_0

    .line 5945
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    if-eqz p0, :cond_0

    return-object p0

    .line 5951
    :cond_0
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object p0

    return-object p0
.end method

.method public getCarrierNameDisplayBitmask(Landroid/telephony/ServiceState;)I
    .locals 4

    .line 4168
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    .line 4169
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getOperatorBrandOverride()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const/4 v2, 0x1

    if-nez v1, :cond_0

    return v2

    .line 4173
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceProviderName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const/4 v3, 0x2

    if-eqz v1, :cond_1

    return v3

    :cond_1
    const-string/jumbo v1, "spn_display_rule_use_roaming_from_service_state_bool"

    .line 4178
    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    .line 4181
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-nez v1, :cond_2

    const/4 v1, 0x0

    goto :goto_0

    :cond_2
    invoke-virtual {v1}, Lcom/android/internal/telephony/uicc/IccRecords;->getCarrierNameDisplayCondition()I

    move-result v1

    :goto_0
    if-eqz v0, :cond_3

    .line 4185
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getRoaming()Z

    move-result p0

    goto :goto_2

    .line 4187
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p0, :cond_4

    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/IccRecords;->getHomePlmns()[Ljava/lang/String;

    move-result-object p0

    goto :goto_1

    :cond_4
    const/4 p0, 0x0

    .line 4188
    :goto_1
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/internal/telephony/util/ArrayUtils;->contains([Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    xor-int/2addr p0, v2

    :goto_2
    const/4 p1, 0x3

    if-eqz p0, :cond_6

    and-int/lit8 p0, v1, 0x2

    if-ne p0, v3, :cond_5

    goto :goto_3

    :cond_5
    move v2, v3

    goto :goto_4

    :cond_6
    and-int/lit8 p0, v1, 0x1

    if-ne p0, v2, :cond_7

    :goto_3
    move v2, p1

    :cond_7
    :goto_4
    return v2
.end method

.method getCdmaEriText(II)Ljava/lang/String;
    .locals 0

    .line 5959
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

    if-eqz p0, :cond_0

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/cdma/EriManager;->getCdmaEriText(II)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "no ERI"

    :goto_0
    return-object p0
.end method

.method public getCdmaMin()Ljava/lang/String;
    .locals 0

    .line 1879
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    return-object p0
.end method

.method public getCellIdentity()Landroid/telephony/CellIdentity;
    .locals 1

    .line 4557
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    if-eqz v0, :cond_0

    return-object v0

    .line 4559
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getAllCellInfo()Ljava/util/List;

    move-result-object v0

    invoke-static {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCellIdentityFromCellInfo(Ljava/util/List;)Landroid/telephony/CellIdentity;

    move-result-object v0

    if-eqz v0, :cond_1

    return-object v0

    .line 4562
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getPhoneType()I

    move-result p0

    const/4 v0, 0x2

    if-ne p0, v0, :cond_2

    .line 4563
    new-instance p0, Landroid/telephony/CellIdentityCdma;

    invoke-direct {p0}, Landroid/telephony/CellIdentityCdma;-><init>()V

    goto :goto_0

    :cond_2
    new-instance p0, Landroid/telephony/CellIdentityGsm;

    invoke-direct {p0}, Landroid/telephony/CellIdentityGsm;-><init>()V

    :goto_0
    return-object p0
.end method

.method public getCombinedRegState(Landroid/telephony/ServiceState;)I
    .locals 3

    .line 5912
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    .line 5913
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v1

    const/4 v2, 0x1

    if-eq v0, v2, :cond_0

    const/4 v2, 0x3

    if-ne v0, v2, :cond_2

    :cond_0
    if-nez v1, :cond_2

    .line 5917
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getDataNetworkType()I

    move-result p1

    const/16 v2, 0x12

    if-ne p1, v2, :cond_1

    .line 5918
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object p1

    if-eqz p1, :cond_2

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->isWifiCallingEnabled()Z

    move-result p1

    if-eqz p1, :cond_2

    const-string p1, "getCombinedRegState: return STATE_IN_SERVICE for IWLAN as Data is in service and WFC is enabled"

    .line 5919
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    const-string p1, "getCombinedRegState: return STATE_IN_SERVICE as Data is in service"

    .line 5924
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    :goto_0
    move v0, v1

    :cond_2
    return v0
.end method

.method protected getContentValuesForServiceState(Landroid/telephony/ServiceState;)Landroid/content/ContentValues;
    .locals 2

    .line 6188
    new-instance p0, Landroid/content/ContentValues;

    invoke-direct {p0}, Landroid/content/ContentValues;-><init>()V

    .line 6189
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v0

    const/4 v1, 0x0

    .line 6190
    invoke-virtual {p1, v0, v1}, Landroid/telephony/ServiceState;->writeToParcel(Landroid/os/Parcel;I)V

    .line 6193
    invoke-virtual {v0}, Landroid/os/Parcel;->marshall()[B

    move-result-object p1

    const-string v0, "service_state"

    invoke-virtual {p0, v0, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    return-object p0
.end method

.method public getCurrentDataConnectionState()I
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 3377
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result p0

    return p0
.end method

.method public getDesiredPowerState()Z
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 926
    iget-boolean p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDesiredPowerState:Z

    return p0
.end method

.method protected getHomeOperatorNumeric()Ljava/lang/String;
    .locals 2

    .line 5760
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "phone"

    .line 5761
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 5762
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/TelephonyManager;->getSimOperatorNumericForPhone(I)Ljava/lang/String;

    move-result-object v0

    .line 5763
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p0

    if-nez p0, :cond_0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_0

    const-string p0, "ro.cdma.home.operator.numeric"

    const-string v0, ""

    .line 5764
    invoke-static {p0, v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_0
    return-object v0
.end method

.method public getImsi()Ljava/lang/String;
    .locals 2

    .line 1892
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "phone"

    .line 1893
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 1894
    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/telephony/TelephonyManager;->getSimOperatorNumericForPhone(I)Ljava/lang/String;

    move-result-object v0

    .line 1896
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCdmaMin()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 1897
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCdmaMin()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const/4 p0, 0x0

    return-object p0
.end method

.method public getLastKnownCellIdentity()Landroid/telephony/CellIdentity;
    .locals 0

    .line 6224
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownCellIdentity:Landroid/telephony/CellIdentity;

    return-object p0
.end method

.method public getLocaleTracker()Lcom/android/internal/telephony/LocaleTracker;
    .locals 0

    .line 5955
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLocaleTracker:Lcom/android/internal/telephony/LocaleTracker;

    return-object p0
.end method

.method public getMdnNumber()Ljava/lang/String;
    .locals 0

    .line 1875
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMdn:Ljava/lang/String;

    return-object p0
.end method

.method public getNrContextIds()Ljava/util/Set;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 6140
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    .line 6142
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    invoke-static {v1}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty(Ljava/util/Collection;)Z

    move-result v1

    if-nez v1, :cond_1

    .line 6143
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/PhysicalChannelConfig;

    .line 6144
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->isNrPhysicalChannelConfig(Landroid/telephony/PhysicalChannelConfig;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 6145
    invoke-virtual {v2}, Landroid/telephony/PhysicalChannelConfig;->getContextIds()[I

    move-result-object v2

    array-length v3, v2

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v3, :cond_0

    aget v5, v2, v4

    .line 6146
    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    invoke-interface {v0, v5}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_1
    return-object v0
.end method

.method protected getOperatorBrandOverride()Ljava/lang/String;
    .locals 1

    .line 4219
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getUiccPort()Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object p0

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 4221
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccPort;->getUiccProfile()Lcom/android/internal/telephony/uicc/UiccProfile;

    move-result-object p0

    if-nez p0, :cond_1

    return-object v0

    .line 4223
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/uicc/UiccProfile;->getOperatorBrandOverride()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method protected getOperatorNameFromEri()Ljava/lang/String;
    .locals 5

    .line 4073
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v0

    const v1, 0x1040841

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v0, :cond_1

    .line 4074
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v0

    if-ne v0, v2, :cond_7

    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    if-nez v0, :cond_7

    .line 4077
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    if-nez v0, :cond_0

    .line 4078
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCdmaEriText()Ljava/lang/String;

    move-result-object v3

    goto/16 :goto_2

    .line 4082
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0, v1}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object p0

    .line 4083
    invoke-interface {p0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v3

    goto/16 :goto_2

    .line 4086
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v0

    if-eqz v0, :cond_7

    .line 4087
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getPhoneId()I

    move-result v4

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccPort(I)Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    .line 4088
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getPhoneId()I

    move-result v4

    invoke-virtual {v0, v4}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccPort(I)Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccPort;->getOperatorBrandOverride()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    move v0, v2

    goto :goto_0

    :cond_2
    const/4 v0, 0x0

    :goto_0
    if-nez v0, :cond_6

    .line 4089
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v0

    if-ne v0, v2, :cond_6

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

    if-eqz v0, :cond_6

    .line 4090
    invoke-virtual {v0}, Lcom/android/internal/telephony/cdma/EriManager;->isEriFileLoaded()Z

    move-result v0

    if-eqz v0, :cond_6

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 4091
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v0

    invoke-static {v0}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v0

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 4092
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v4, 0x111000f

    invoke-virtual {v0, v4}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 4095
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getOperatorAlpha()Ljava/lang/String;

    move-result-object v3

    .line 4097
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    if-nez v0, :cond_4

    .line 4098
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCdmaEriText()Ljava/lang/String;

    move-result-object v3

    goto :goto_1

    .line 4099
    :cond_4
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    const/4 v4, 0x3

    if-ne v0, v4, :cond_5

    .line 4100
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceProviderName()Ljava/lang/String;

    move-result-object v3

    .line 4101
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_6

    const-string v0, "ro.cdma.home.operator.alpha"

    .line 4104
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    goto :goto_1

    .line 4106
    :cond_5
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v0

    if-eqz v0, :cond_6

    .line 4109
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 4110
    invoke-virtual {v0, v1}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v3

    .line 4114
    :cond_6
    :goto_1
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getState()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    move-result-object v0

    sget-object v1, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;->APPSTATE_READY:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    if-ne v0, v1, :cond_7

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v0, :cond_7

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 4115
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCombinedRegState(Landroid/telephony/ServiceState;)I

    move-result v0

    if-nez v0, :cond_7

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 4116
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v0

    invoke-static {v0}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v0

    if-nez v0, :cond_7

    .line 4120
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    check-cast v0, Lcom/android/internal/telephony/uicc/RuimRecords;

    .line 4121
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/RuimRecords;->getCsimSpnDisplayCondition()Z

    move-result v0

    .line 4122
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getCdmaEriIconIndex()I

    move-result v1

    if-eqz v0, :cond_7

    if-ne v1, v2, :cond_7

    .line 4124
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 4125
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getCdmaSystemId()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getCdmaNetworkId()I

    move-result v1

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->isInHomeSidNid(II)Z

    move-result v0

    if-eqz v0, :cond_7

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v0, :cond_7

    .line 4127
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceProviderName()Ljava/lang/String;

    move-result-object v3

    :cond_7
    :goto_2
    return-object v3
.end method

.method public getOtasp()I
    .locals 6

    .line 1918
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getIccRecordsLoaded()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    const-string v0, "getOtasp: otasp uninitialized due to sim not loaded"

    .line 1919
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return v1

    .line 1923
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v2, 0x3

    if-eqz v0, :cond_1

    const-string v0, "getOtasp: otasp not needed for GSM"

    .line 1924
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return v2

    .line 1928
    :cond_1
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    const/4 v3, 0x2

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    if-nez v0, :cond_2

    return v3

    .line 1931
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    if-eqz v0, :cond_5

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v4, 0x6

    if-ge v0, v4, :cond_3

    goto :goto_0

    .line 1935
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    const-string v5, "1111110111"

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_4

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    .line 1936
    invoke-virtual {v0, v1, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    const-string v4, "000000"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_4

    const-string/jumbo v0, "test_cdma_setup"

    .line 1937
    invoke-static {v0, v1}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_6

    :cond_4
    move v2, v3

    goto :goto_1

    .line 1932
    :cond_5
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getOtasp: bad mMin=\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\'"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    const/4 v2, 0x1

    .line 1943
    :cond_6
    :goto_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getOtasp: state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return v2
.end method

.method protected getPhone()Lcom/android/internal/telephony/Phone;
    .locals 0

    .line 1997
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    return-object p0
.end method

.method protected getPhoneId()I
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 5771
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    return p0
.end method

.method public getPhysicalChannelConfigList()Ljava/util/List;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/telephony/PhysicalChannelConfig;",
            ">;"
        }
    .end annotation

    .line 931
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    return-object p0
.end method

.method public getPowerStateFromCarrier()Z
    .locals 0

    .line 928
    iget-boolean p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioDisabledByCarrier:Z

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method public getPrlVersion()Ljava/lang/String;
    .locals 0

    .line 1884
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrlVersion:Ljava/lang/String;

    return-object p0
.end method

.method public getRadioPowerOffDelayTimeoutForImsRegistration()I
    .locals 1
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 903
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const v0, 0x10e0055

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getInteger(I)I

    move-result p0

    return p0
.end method

.method public getRadioPowerOffReasons()Ljava/util/Set;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 1118
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerOffReasons:Ljava/util/Set;

    return-object p0
.end method

.method public getServiceProviderName()Ljava/lang/String;
    .locals 2

    .line 4140
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getOperatorBrandOverride()Ljava/lang/String;

    move-result-object v0

    .line 4141
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    return-object v0

    .line 4145
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/IccRecords;->getServiceProviderName()Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_1
    const-string v0, ""

    .line 4146
    :goto_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object p0

    const-string v1, "carrier_name_override_bool"

    .line 4147
    invoke-virtual {p0, v1}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_3

    .line 4148
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_2

    goto :goto_1

    :cond_2
    return-object v0

    :cond_3
    :goto_1
    const-string v0, "carrier_name_string"

    .line 4149
    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public getServiceState()Landroid/telephony/ServiceState;
    .locals 1

    .line 1855
    new-instance v0, Landroid/telephony/ServiceState;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-direct {v0, p0}, Landroid/telephony/ServiceState;-><init>(Landroid/telephony/ServiceState;)V

    return-object v0
.end method

.method public getServiceStateStats()Lcom/android/internal/telephony/metrics/ServiceStateStats;
    .locals 0

    .line 6168
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mServiceStateStats:Lcom/android/internal/telephony/metrics/ServiceStateStats;

    return-object p0
.end method

.method protected getSubscriptionInfoAndStartPollingThreads()V
    .locals 2

    .line 5448
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0x22

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/android/internal/telephony/CommandsInterface;->getCDMASubscription(Landroid/os/Message;)V

    const/4 v0, 0x0

    .line 5451
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateInternal(Z)V

    return-void
.end method

.method public getSystemProperty(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 5347
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-static {p0, p1, p2}, Landroid/telephony/TelephonyManager;->getTelephonyProperty(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method protected getUiccCardApplication()Lcom/android/internal/telephony/uicc/UiccCardApplication;
    .locals 2

    .line 4878
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 4879
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    const/4 v1, 0x1

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p0

    return-object p0

    .line 4882
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    const/4 v1, 0x2

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccCardApplication(II)Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object p0

    return-object p0
.end method

.method protected handleCdmaSubscriptionSource(I)V
    .locals 2

    .line 5457
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Subscription Source : "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    if-nez p1, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 5458
    :goto_0
    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    .line 5460
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isFromRuim: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5461
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->saveCdmaSubscriptionSource(I)V

    .line 5462
    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    if-nez p1, :cond_1

    const/16 p1, 0x23

    .line 5464
    invoke-virtual {p0, p1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    :cond_1
    return-void
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 14

    .line 1250
    iget v0, p1, Landroid/os/Message;->what:I

    const/16 v1, 0xe

    const/4 v2, 0x3

    const/4 v3, 0x2

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x1

    packed-switch v0, :pswitch_data_0

    .line 1813
    :pswitch_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unhandled message with number: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto/16 :goto_8

    :pswitch_1
    const-string p1, "EVENT_TELECOM_VOICE_SERVICE_STATE_OVERRIDE_CHANGED"

    .line 1804
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1807
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getState()I

    move-result p1

    if-eqz p1, :cond_20

    .line 1808
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifyServiceStateChanged(Landroid/telephony/ServiceState;)V

    goto/16 :goto_8

    .line 1536
    :pswitch_2
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/ServiceStateTracker$2;

    new-instance v1, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/ServiceStateTracker$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/ServiceStateTracker;)V

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker$2;-><init>(Lcom/android/internal/telephony/ServiceStateTracker;Ljava/util/concurrent/Executor;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataNetworkController;->registerDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    goto/16 :goto_8

    :pswitch_3
    const-string p1, "EVENT_RESET_LAST_KNOWN_CELL_IDENTITY triggered"

    .line 1798
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1799
    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownCellIdentity:Landroid/telephony/CellIdentity;

    goto/16 :goto_8

    :pswitch_4
    const-string p1, "EVENT_POWER_OFF_RADIO_IMS_DEREG_TIMEOUT triggered"

    .line 1792
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1793
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->powerOffRadioSafely()V

    goto/16 :goto_8

    .line 1788
    :pswitch_5
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateInternal(Z)V

    goto/16 :goto_8

    .line 1784
    :pswitch_6
    invoke-direct {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->onCarrierConfigChanged()V

    goto/16 :goto_8

    .line 1769
    :pswitch_7
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    if-nez p1, :cond_0

    const-string p1, "Invalid null response to getCellIdentity!"

    .line 1771
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    goto/16 :goto_8

    .line 1778
    :cond_0
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Landroid/os/Message;

    .line 1779
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object p0

    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-static {v0, p0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 1780
    invoke-virtual {v0}, Landroid/os/Message;->sendToTarget()V

    goto/16 :goto_8

    .line 1736
    :pswitch_8
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1737
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_20

    .line 1738
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/util/List;

    .line 1743
    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    .line 1745
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateNrStateFromPhysicalChannelConfigs(Ljava/util/List;Landroid/telephony/ServiceState;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1746
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNrStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    move v5, v6

    .line 1749
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateNrFrequencyRangeFromPhysicalChannelConfigs(Ljava/util/List;Landroid/telephony/ServiceState;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1750
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNrFrequencyChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    goto :goto_0

    :cond_2
    move v6, v5

    .line 1754
    :goto_0
    invoke-static {p1}, Lcom/android/internal/telephony/ServiceStateTracker;->getBandwidthsFromConfigs(Ljava/util/List;)[I

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-static {v0, v1}, Lcom/android/internal/telephony/RatRatcheter;->updateBandwidths([ILandroid/telephony/ServiceState;)Z

    move-result v0

    or-int/2addr v0, v6

    .line 1756
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1, p1}, Lcom/android/internal/telephony/Phone;->notifyPhysicalChannelConfig(Ljava/util/List;)V

    if-eqz v0, :cond_20

    .line 1759
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifyServiceStateChanged(Landroid/telephony/ServiceState;)V

    .line 1760
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object p1

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 1761
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 1760
    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeServiceStateChanged(ILandroid/telephony/ServiceState;)V

    .line 1762
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getVoiceCallSessionStats()Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;

    move-result-object p1

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->onServiceStateChanged(Landroid/telephony/ServiceState;)V

    .line 1763
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mServiceStateStats:Lcom/android/internal/telephony/metrics/ServiceStateStats;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->onServiceStateChanged(Landroid/telephony/ServiceState;)V

    goto/16 :goto_8

    :pswitch_9
    const-string p1, "EVENT_RADIO_POWER_OFF_DONE"

    .line 1365
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1366
    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    if-eqz p1, :cond_20

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p1}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result p1

    if-eq p1, v3, :cond_20

    .line 1371
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, v4}, Lcom/android/internal/telephony/CommandsInterface;->requestShutdown(Landroid/os/Message;)V

    goto/16 :goto_8

    :pswitch_a
    const-string p1, "EVENT_IMS_SERVICE_STATE_CHANGED"

    .line 1591
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1594
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getState()I

    move-result p1

    if-eqz p1, :cond_20

    .line 1595
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifyServiceStateChanged(Landroid/telephony/ServiceState;)V

    goto/16 :goto_8

    .line 1727
    :pswitch_b
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1728
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_20

    .line 1729
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Ljava/lang/Boolean;

    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p1

    .line 1730
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "EVENT_RADIO_POWER_FROM_CARRIER: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1731
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->setRadioPowerFromCarrier(Z)V

    goto/16 :goto_8

    .line 1553
    :pswitch_c
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p1

    if-eqz p1, :cond_4

    const-string p1, "EVENT_ALL_DATA_DISCONNECTED"

    .line 1554
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1555
    monitor-enter p0

    .line 1556
    :try_start_0
    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    if-eqz p1, :cond_3

    const-string p1, "EVENT_ALL_DATA_DISCONNECTED, turn radio off now."

    .line 1557
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1558
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->cancelPendingRadioPowerOff()V

    .line 1559
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->hangupAndPowerOff()V

    .line 1561
    :cond_3
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1

    .line 1564
    :cond_4
    invoke-static {}, Landroid/telephony/SubscriptionManager;->getDefaultDataSubscriptionId()I

    move-result p1

    .line 1565
    invoke-static {}, Lcom/android/internal/telephony/ProxyController;->getInstance()Lcom/android/internal/telephony/ProxyController;

    move-result-object v0

    invoke-virtual {v0, p1, p0}, Lcom/android/internal/telephony/ProxyController;->unregisterForAllDataDisconnected(ILandroid/os/Handler;)V

    .line 1566
    monitor-enter p0

    .line 1567
    :try_start_1
    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    if-eqz p1, :cond_5

    const-string p1, "EVENT_ALL_DATA_DISCONNECTED, turn radio off now."

    .line 1568
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1569
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->hangupAndPowerOff()V

    .line 1570
    iget p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    add-int/2addr p1, v6

    iput p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    .line 1571
    iput-boolean v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    goto :goto_1

    :cond_5
    const-string p1, "EVENT_ALL_DATA_DISCONNECTED is stale"

    .line 1573
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1575
    :goto_1
    monitor-exit p0

    goto/16 :goto_8

    :catchall_1
    move-exception p1

    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    throw p1

    :pswitch_d
    const-string p1, "EVENT_IMS_CAPABILITY_CHANGED"

    .line 1585
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1586
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateSpnDisplay()V

    .line 1587
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsCapabilityChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    goto/16 :goto_8

    .line 1355
    :pswitch_e
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1356
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_20

    .line 1357
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [I

    .line 1358
    aget p1, p1, v5

    if-ne p1, v6, :cond_6

    move v5, v6

    .line 1359
    :cond_6
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1, v5}, Lcom/android/internal/telephony/GsmCdmaPhone;->setImsRegistrationState(Z)V

    .line 1360
    iput-boolean v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistered:Z

    goto/16 :goto_8

    .line 1351
    :pswitch_f
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x2f

    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->getImsRegistrationState(Landroid/os/Message;)V

    goto/16 :goto_8

    :pswitch_10
    const-string p1, "EVENT_CHANGE_IMS_STATE:"

    .line 1579
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1581
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->setPowerStateToDesired()V

    goto/16 :goto_8

    .line 1298
    :pswitch_11
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    if-eqz p1, :cond_9

    .line 1299
    check-cast p1, Landroid/os/AsyncResult;

    .line 1300
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-eqz v0, :cond_7

    .line 1301
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "EVENT_GET_CELL_INFO_LIST: error ret null, e="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1302
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    goto :goto_3

    .line 1303
    :cond_7
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-nez p1, :cond_8

    const-string p1, "Invalid CellInfo result"

    .line 1304
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    goto :goto_2

    .line 1306
    :cond_8
    check-cast p1, Ljava/util/List;

    .line 1307
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOperatorNameForCellInfo(Ljava/util/List;)V

    .line 1308
    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoList:Ljava/util/List;

    .line 1309
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/Phone;->notifyCellInfo(Ljava/util/List;)V

    move-object v13, v4

    move-object v4, p1

    move-object p1, v13

    goto :goto_3

    .line 1315
    :cond_9
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingCellInfoRequests:Ljava/util/List;

    monitor-enter p1

    .line 1318
    :try_start_2
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsPendingCellInfoRequest:Z

    if-nez v0, :cond_a

    monitor-exit p1

    goto/16 :goto_8

    .line 1322
    :cond_a
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    .line 1323
    iget-wide v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoReqTime:J

    sub-long/2addr v0, v2

    const-wide/16 v2, 0x7d0

    cmp-long v0, v0, v2

    if-gez v0, :cond_b

    .line 1324
    monitor-exit p1

    goto/16 :goto_8

    :cond_b
    const-string v0, "Timeout waiting for CellInfo; (everybody panic)!"

    .line 1328
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    .line 1329
    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoList:Ljava/util/List;

    .line 1332
    monitor-exit p1
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_3

    :goto_2
    move-object p1, v4

    .line 1334
    :goto_3
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingCellInfoRequests:Ljava/util/List;

    monitor-enter v0

    .line 1337
    :try_start_3
    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsPendingCellInfoRequest:Z

    if-eqz v1, :cond_d

    .line 1339
    iput-boolean v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsPendingCellInfoRequest:Z

    .line 1340
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingCellInfoRequests:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_4
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_c

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/Message;

    .line 1341
    invoke-static {v2, v4, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 1342
    invoke-virtual {v2}, Landroid/os/Message;->sendToTarget()V

    goto :goto_4

    .line 1344
    :cond_c
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingCellInfoRequests:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->clear()V

    .line 1346
    :cond_d
    monitor-exit v0

    goto/16 :goto_8

    :catchall_2
    move-exception p0

    monitor-exit v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    throw p0

    :catchall_3
    move-exception p0

    .line 1332
    :try_start_4
    monitor-exit p1
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_3

    throw p0

    .line 1273
    :pswitch_12
    invoke-direct {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->isSimAbsent()Z

    move-result p1

    if-eqz p1, :cond_e

    const-string p1, "EVENT_ICC_CHANGED: SIM absent"

    .line 1274
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1276
    invoke-direct {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->cancelAllNotifications()V

    .line 1278
    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMdn:Ljava/lang/String;

    .line 1279
    iput-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    .line 1280
    iput-boolean v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsMinInfoReady:Z

    .line 1283
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {p1, v4}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfFromRuim(Lcom/android/internal/telephony/uicc/RuimRecords;)V

    .line 1284
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {p1, v4}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfFromUsim(Lcom/android/internal/telephony/uicc/SIMRecords;)V

    .line 1286
    :cond_e
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->onUpdateIccAvailability()V

    .line 1287
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    if-eqz p1, :cond_f

    .line 1288
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getState()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    move-result-object p1

    sget-object v0, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;->APPSTATE_READY:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    if-eq p1, v0, :cond_20

    .line 1289
    :cond_f
    iput-boolean v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSimReady:Z

    .line 1290
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateSpnDisplay()V

    goto/16 :goto_8

    .line 1719
    :pswitch_13
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1720
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_20

    .line 1721
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [I

    .line 1722
    aget p1, p1, v5

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrlVersion:Ljava/lang/String;

    goto/16 :goto_8

    .line 1601
    :pswitch_14
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;->getCdmaSubscriptionSource()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->handleCdmaSubscriptionSource(I)V

    goto/16 :goto_8

    .line 1252
    :pswitch_15
    monitor-enter p0

    .line 1253
    :try_start_5
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-eqz v0, :cond_10

    const-string p1, "Wait for all data networks torn down timed out. Power off now."

    .line 1254
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1255
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->cancelPendingRadioPowerOff()V

    .line 1256
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->hangupAndPowerOff()V

    .line 1257
    monitor-exit p0

    return-void

    .line 1259
    :cond_10
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    if-eqz v0, :cond_11

    iget v0, p1, Landroid/os/Message;->arg1:I

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    if-ne v0, v1, :cond_11

    const-string p1, "EVENT_SET_RADIO_OFF, turn radio off now."

    .line 1261
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1262
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->hangupAndPowerOff()V

    .line 1263
    iget p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    add-int/2addr p1, v6

    iput p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    .line 1264
    iput-boolean v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    goto :goto_5

    .line 1266
    :cond_11
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "EVENT_SET_RADIO_OFF is stale arg1="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->arg1:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "!= tag="

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1269
    :goto_5
    monitor-exit p0

    goto/16 :goto_8

    :catchall_4
    move-exception p1

    monitor-exit p0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_4

    throw p1

    .line 1706
    :pswitch_16
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1707
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_20

    .line 1708
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [I

    .line 1709
    aget p1, p1, v5

    const/16 v0, 0x8

    if-eq p1, v0, :cond_12

    const/16 v0, 0xa

    if-ne p1, v0, :cond_20

    :cond_12
    const-string p1, "EVENT_OTA_PROVISION_STATUS_CHANGE: Complete, Reload MDN"

    .line 1712
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1713
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v0, 0x22

    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->getCDMASubscription(Landroid/os/Message;)V

    goto/16 :goto_8

    .line 1620
    :pswitch_17
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updatePhoneObject()V

    .line 1623
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-interface {p1, v0}, Lcom/android/internal/telephony/CommandsInterface;->getNetworkSelectionMode(Landroid/os/Message;)V

    .line 1628
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getSubscriptionInfoAndStartPollingThreads()V

    goto/16 :goto_8

    .line 1632
    :pswitch_18
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_20

    .line 1633
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1635
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_20

    .line 1636
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [Ljava/lang/String;

    if-eqz p1, :cond_14

    .line 1637
    array-length v0, p1

    const/4 v1, 0x5

    if-lt v0, v1, :cond_14

    .line 1638
    aget-object v0, p1, v5

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMdn:Ljava/lang/String;

    .line 1639
    aget-object v0, p1, v6

    aget-object v1, p1, v3

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->parseSidNid(Ljava/lang/String;Ljava/lang/String;)V

    .line 1641
    aget-object v0, p1, v2

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    const/4 v0, 0x4

    .line 1642
    aget-object p1, p1, v0

    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrlVersion:Ljava/lang/String;

    .line 1643
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "GET_CDMA_SUBSCRIPTION: MDN="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMdn:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1645
    iput-boolean v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsMinInfoReady:Z

    .line 1647
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOtaspState()V

    .line 1649
    invoke-direct {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->notifyCdmaSubscriptionInfoReady()V

    .line 1651
    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    if-nez p1, :cond_13

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz p1, :cond_13

    const-string p1, "GET_CDMA_SUBSCRIPTION set imsi in mIccRecords"

    .line 1653
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1655
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getImsi()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/uicc/IccRecords;->setImsi(Ljava/lang/String;)V

    goto/16 :goto_8

    :cond_13
    const-string p1, "GET_CDMA_SUBSCRIPTION either mIccRecords is null or NV type device - not setting Imsi in mIccRecords"

    .line 1658
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto/16 :goto_8

    .line 1664
    :cond_14
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "GET_CDMA_SUBSCRIPTION: error parsing cdmaSubscription params num="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length p1, p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto/16 :goto_8

    .line 1673
    :pswitch_19
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_20

    .line 1674
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "EVENT_RUIM_RECORDS_LOADED: what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1675
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    check-cast v0, Lcom/android/internal/telephony/uicc/RuimRecords;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfFromRuim(Lcom/android/internal/telephony/uicc/RuimRecords;)V

    .line 1676
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updatePhoneObject()V

    .line 1677
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result p1

    if-eqz p1, :cond_15

    .line 1678
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateSpnDisplay()V

    goto/16 :goto_8

    .line 1680
    :cond_15
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    check-cast p1, Lcom/android/internal/telephony/uicc/RuimRecords;

    if-eqz p1, :cond_17

    .line 1687
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/RuimRecords;->getMdn()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMdn:Ljava/lang/String;

    .line 1688
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/RuimRecords;->isProvisioned()Z

    move-result v0

    if-eqz v0, :cond_16

    .line 1689
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/RuimRecords;->getMin()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    .line 1690
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/RuimRecords;->getSid()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/RuimRecords;->getNid()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->parseSidNid(Ljava/lang/String;Ljava/lang/String;)V

    .line 1691
    invoke-virtual {p1}, Lcom/android/internal/telephony/uicc/RuimRecords;->getPrlVersion()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrlVersion:Ljava/lang/String;

    .line 1692
    iput-boolean v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsMinInfoReady:Z

    .line 1694
    :cond_16
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOtaspState()V

    .line 1696
    invoke-direct {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->notifyCdmaSubscriptionInfoReady()V

    .line 1701
    :cond_17
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateInternal(Z)V

    goto/16 :goto_8

    .line 1605
    :pswitch_1a
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->getLteOnCdmaMode()I

    move-result p1

    if-ne p1, v6, :cond_18

    const-string p1, "Receive EVENT_RUIM_READY"

    .line 1607
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1608
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateInternal(Z)V

    goto :goto_6

    :cond_18
    const-string p1, "Receive EVENT_RUIM_READY and Send Request getCDMASubscription."

    .line 1610
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1611
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getSubscriptionInfoAndStartPollingThreads()V

    .line 1615
    :goto_6
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {p1, p0}, Lcom/android/internal/telephony/CommandsInterface;->getNetworkSelectionMode(Landroid/os/Message;)V

    goto/16 :goto_8

    .line 1523
    :pswitch_1b
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_20

    const-string v0, "EVENT_RESTRICTED_STATE_CHANGED"

    .line 1527
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1529
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1531
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->onRestrictedStateChanged(Landroid/os/AsyncResult;)V

    goto/16 :goto_8

    .line 1509
    :pswitch_1c
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p1

    if-eqz p1, :cond_19

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    if-eqz p1, :cond_19

    .line 1510
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result p1

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isGprsConsistent(II)Z

    move-result p1

    if-nez p1, :cond_19

    const p1, 0xc3bb

    new-array v0, v3, [Ljava/lang/Object;

    .line 1515
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 1516
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v1

    aput-object v1, v0, v5

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    invoke-static {v1}, Lcom/android/internal/telephony/ServiceStateTracker;->getCidFromCellIdentity(Landroid/telephony/CellIdentity;)J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    aput-object v1, v0, v6

    .line 1515
    invoke-static {p1, v0}, Landroid/util/EventLog;->writeEvent(I[Ljava/lang/Object;)I

    .line 1517
    iput-boolean v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mReportedGprsNoReg:Z

    .line 1519
    :cond_19
    iput-boolean v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mStartedGprsRegCheck:Z

    goto/16 :goto_8

    .line 1483
    :pswitch_1d
    iget-object p0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p0, Landroid/os/AsyncResult;

    .line 1484
    iget-object p1, p0, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    if-eqz p1, :cond_20

    .line 1485
    check-cast p1, Landroid/os/Message;

    invoke-static {p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;)Landroid/os/AsyncResult;

    move-result-object p1

    iget-object v0, p0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    iput-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    .line 1487
    iget-object p0, p0, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast p0, Landroid/os/Message;

    invoke-virtual {p0}, Landroid/os/Message;->sendToTarget()V

    goto/16 :goto_8

    .line 1476
    :pswitch_1e
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    const/16 v0, 0x15

    .line 1478
    iget-object p1, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 1479
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iget p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAllowedNetworkTypes:I

    invoke-interface {v0, p0, p1}, Lcom/android/internal/telephony/CommandsInterface;->setAllowedNetworkTypesBitmap(ILandroid/os/Message;)V

    goto/16 :goto_8

    .line 1492
    :pswitch_1f
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1494
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    const/4 v1, 0x7

    if-nez v0, :cond_1a

    .line 1495
    iget-object v0, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast v0, [I

    aget v0, v0, v5

    iput v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAllowedNetworkTypes:I

    goto :goto_7

    .line 1497
    :cond_1a
    invoke-static {v1}, Landroid/telephony/RadioAccessFamily;->getRafFromNetworkType(I)I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAllowedNetworkTypes:I

    :goto_7
    const/16 v0, 0x14

    .line 1501
    iget-object p1, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    .line 1502
    invoke-static {v1}, Landroid/telephony/RadioAccessFamily;->getRafFromNetworkType(I)I

    move-result v0

    .line 1505
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0, v0, p1}, Lcom/android/internal/telephony/CommandsInterface;->setAllowedNetworkTypesBitmap(ILandroid/os/Message;)V

    goto/16 :goto_8

    .line 1466
    :pswitch_20
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1468
    iget-object p1, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez p1, :cond_20

    .line 1469
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegStateManagers:Landroid/util/SparseArray;

    invoke-virtual {p1, v6}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/NetworkRegistrationManager;

    const/16 v0, 0xf

    .line 1471
    invoke-virtual {p0, v0, v4}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    .line 1470
    invoke-virtual {p1, v6, p0}, Lcom/android/internal/telephony/NetworkRegistrationManager;->requestNetworkRegistrationInfo(ILandroid/os/Message;)V

    goto/16 :goto_8

    :pswitch_21
    const/4 p1, -0x1

    .line 1379
    iput p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrevSubId:I

    .line 1380
    iput-boolean v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSimReady:Z

    .line 1381
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateInternal(Z)V

    goto/16 :goto_8

    .line 1456
    :pswitch_22
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "EVENT_SIM_RECORDS_LOADED: what="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1457
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updatePhoneObject()V

    .line 1458
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOtaspState()V

    .line 1459
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p1

    if-eqz p1, :cond_20

    .line 1460
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    check-cast v0, Lcom/android/internal/telephony/uicc/SIMRecords;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfFromUsim(Lcom/android/internal/telephony/uicc/SIMRecords;)V

    .line 1461
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateSpnDisplay()V

    goto/16 :goto_8

    .line 1401
    :pswitch_23
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1402
    iget-object v0, p1, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez v0, :cond_1b

    .line 1403
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/NetworkRegistrationInfo;

    .line 1404
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object p1

    .line 1405
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOperatorNameForCellIdentity(Landroid/telephony/CellIdentity;)V

    .line 1406
    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    .line 1407
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifyLocationChanged(Landroid/telephony/CellIdentity;)V

    .line 1412
    :cond_1b
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->disableSingleLocationUpdate()V

    goto/16 :goto_8

    :pswitch_24
    const-string v0, "EVENT_POLL_STATE_NETWORK_SELECTION_MODE"

    .line 1424
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1425
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v0, Landroid/os/AsyncResult;

    .line 1426
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-eqz v1, :cond_1c

    .line 1427
    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {p0, p1, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->handlePollStateResult(ILandroid/os/AsyncResult;)V

    goto/16 :goto_8

    .line 1429
    :cond_1c
    iget-object p1, v0, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    if-nez p1, :cond_1d

    iget-object p1, v0, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    if-eqz p1, :cond_1d

    .line 1430
    check-cast p1, [I

    .line 1431
    aget p1, p1, v5

    if-ne p1, v6, :cond_20

    .line 1432
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/Phone;->setNetworkSelectionModeAutomatic(Landroid/os/Message;)V

    goto :goto_8

    :cond_1d
    const-string p1, "Unable to getNetworkSelectionMode"

    .line 1435
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto :goto_8

    .line 1441
    :pswitch_25
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1443
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [Ljava/lang/Object;

    .line 1444
    aget-object v0, p1, v5

    move-object v8, v0

    check-cast v8, Ljava/lang/String;

    .line 1445
    aget-object v0, p1, v6

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v9

    const-wide/16 v0, 0x0

    .line 1447
    array-length v4, p1

    if-lt v4, v2, :cond_1e

    .line 1448
    aget-object p1, p1, v3

    check-cast p1, Ljava/lang/Long;

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    :cond_1e
    move-wide v11, v0

    move-object v7, p0

    .line 1451
    invoke-virtual/range {v7 .. v12}, Lcom/android/internal/telephony/ServiceStateTracker;->setTimeFromNITZString(Ljava/lang/String;JJ)V

    goto :goto_8

    .line 1419
    :pswitch_26
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 1420
    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->handlePollStateResult(ILandroid/os/AsyncResult;)V

    goto :goto_8

    .line 1397
    :pswitch_27
    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateInternal(Z)V

    goto :goto_8

    .line 1386
    :pswitch_28
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p1

    if-nez p1, :cond_1f

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 1387
    invoke-interface {p1}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result p1

    if-ne p1, v6, :cond_1f

    .line 1388
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    invoke-virtual {p1}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;->getCdmaSubscriptionSource()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->handleCdmaSubscriptionSource(I)V

    .line 1391
    :cond_1f
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->setPowerStateToDesired()V

    .line 1393
    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateInternal(Z)V

    :cond_20
    :goto_8
    return-void

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_28
        :pswitch_27
        :pswitch_0
        :pswitch_26
        :pswitch_26
        :pswitch_26
        :pswitch_26
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_25
        :pswitch_0
        :pswitch_0
        :pswitch_24
        :pswitch_23
        :pswitch_22
        :pswitch_21
        :pswitch_20
        :pswitch_1f
        :pswitch_1e
        :pswitch_1d
        :pswitch_1c
        :pswitch_1b
        :pswitch_0
        :pswitch_0
        :pswitch_1a
        :pswitch_19
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_18
        :pswitch_17
        :pswitch_0
        :pswitch_16
        :pswitch_15
        :pswitch_14
        :pswitch_13
        :pswitch_0
        :pswitch_12
        :pswitch_11
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
        :pswitch_d
        :pswitch_c
        :pswitch_28
        :pswitch_b
        :pswitch_0
        :pswitch_a
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_0
        :pswitch_0
        :pswitch_0
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method protected handlePollStateResult(ILandroid/os/AsyncResult;)V
    .locals 4

    .line 2002
    iget-object v0, p2, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    if-eq v0, v1, :cond_0

    return-void

    .line 2004
    :cond_0
    iget-object v0, p2, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz v0, :cond_5

    const/4 p1, 0x0

    .line 2007
    instance-of v0, v0, Ljava/lang/IllegalStateException;

    if-eqz v0, :cond_1

    .line 2008
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "handlePollStateResult exception "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p2, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2011
    :cond_1
    iget-object v0, p2, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    instance-of v3, v0, Lcom/android/internal/telephony/CommandException;

    if-eqz v3, :cond_2

    .line 2012
    check-cast v0, Lcom/android/internal/telephony/CommandException;

    invoke-virtual {v0}, Lcom/android/internal/telephony/CommandException;->getCommandError()Lcom/android/internal/telephony/CommandException$Error;

    move-result-object p1

    .line 2015
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v0

    if-eq v0, v2, :cond_3

    const-string p1, "handlePollStateResult: Invalid response due to radio off or unavailable. Set ServiceState to out of service."

    .line 2016
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2018
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateInternal(Z)V

    return-void

    .line 2022
    :cond_3
    sget-object v0, Lcom/android/internal/telephony/CommandException$Error;->RADIO_NOT_AVAILABLE:Lcom/android/internal/telephony/CommandException$Error;

    if-ne p1, v0, :cond_4

    const-string p1, "handlePollStateResult: RIL returned RADIO_NOT_AVAILABLE when radio is on."

    .line 2023
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    .line 2024
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->cancelPollState()V

    return-void

    .line 2028
    :cond_4
    sget-object v0, Lcom/android/internal/telephony/CommandException$Error;->OP_NOT_ALLOWED_BEFORE_REG_NW:Lcom/android/internal/telephony/CommandException$Error;

    if-eq p1, v0, :cond_6

    .line 2029
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handlePollStateResult: RIL returned an error where it must succeed: "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p2, Landroid/os/AsyncResult;->exception:Ljava/lang/Throwable;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 2033
    :cond_5
    :try_start_0
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->handlePollStateResultMessage(ILandroid/os/AsyncResult;)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 2035
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Exception while polling service state. Probably malformed RIL response."

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    .line 2038
    :cond_6
    :goto_0
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    aget p2, p1, v1

    sub-int/2addr p2, v2

    aput p2, p1, v1

    if-nez p2, :cond_16

    .line 2041
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget-boolean p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEmergencyOnly:Z

    invoke-virtual {p1, p2}, Landroid/telephony/ServiceState;->setEmergencyOnly(Z)V

    .line 2042
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->combinePsRegistrationStates(Landroid/telephony/ServiceState;)V

    .line 2043
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOperatorNameForServiceState(Landroid/telephony/ServiceState;)V

    .line 2044
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p1

    if-eqz p1, :cond_7

    .line 2045
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateRoamingState()V

    goto/16 :goto_5

    .line 2048
    :cond_7
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->isSidsAllZeros()Z

    move-result p1

    if-nez p1, :cond_8

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getCdmaSystemId()I

    move-result p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->isHomeSid(I)Z

    move-result p1

    if-eqz p1, :cond_8

    move p1, v2

    goto :goto_1

    :cond_8
    move p1, v1

    .line 2053
    :goto_1
    iget-boolean p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    if-eqz p2, :cond_9

    .line 2054
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2055
    invoke-virtual {p2}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result p2

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2054
    invoke-virtual {p0, p2, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isRoamingBetweenOperators(ZLandroid/telephony/ServiceState;)Z

    move-result p2

    .line 2056
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v0

    if-eq p2, v0, :cond_9

    .line 2057
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "isRoamingBetweenOperators="

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, ". Override CDMA voice roaming to "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2059
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, p2}, Landroid/telephony/ServiceState;->setVoiceRoaming(Z)V

    .line 2068
    :cond_9
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-static {p2}, Lcom/android/internal/telephony/ServiceStateTracker;->getRilDataRadioTechnologyForWwan(Landroid/telephony/ServiceState;)I

    move-result p2

    .line 2069
    invoke-static {p2}, Landroid/telephony/ServiceState;->isCdma(I)Z

    move-result p2

    if-eqz p2, :cond_c

    .line 2070
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2071
    invoke-virtual {p2}, Landroid/telephony/ServiceState;->getState()I

    move-result p2

    if-nez p2, :cond_a

    move v1, v2

    :cond_a
    if-eqz v1, :cond_b

    .line 2073
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p2}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result p2

    .line 2074
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v0

    if-eq v0, p2, :cond_c

    .line 2075
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Data roaming != Voice roaming. Override data roaming to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2077
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, p2}, Landroid/telephony/ServiceState;->setDataRoaming(Z)V

    goto :goto_2

    .line 2085
    :cond_b
    iget p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingIndicator:I

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->isRoamIndForHomeSystem(I)Z

    move-result p2

    .line 2086
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v0

    if-ne v0, p2, :cond_c

    .line 2087
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isRoamIndForHomeSystem="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", override data roaming to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    xor-int/lit8 v1, p2, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2089
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    xor-int/2addr p2, v2

    invoke-virtual {v0, p2}, Landroid/telephony/ServiceState;->setDataRoaming(Z)V

    .line 2095
    :cond_c
    :goto_2
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDefaultRoamingIndicator:I

    invoke-virtual {p2, v0}, Landroid/telephony/ServiceState;->setCdmaDefaultRoamingIndicator(I)V

    .line 2096
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingIndicator:I

    invoke-virtual {p2, v0}, Landroid/telephony/ServiceState;->setCdmaRoamingIndicator(I)V

    .line 2098
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrlVersion:Ljava/lang/String;

    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p2

    xor-int/2addr p2, v2

    if-eqz p2, :cond_13

    .line 2101
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v0

    if-nez v0, :cond_d

    goto :goto_3

    .line 2105
    :cond_d
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->isSidsAllZeros()Z

    move-result v0

    if-nez v0, :cond_14

    if-nez p1, :cond_e

    .line 2106
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsInPrl:Z

    if-nez v0, :cond_e

    .line 2108
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDefaultRoamingIndicator:I

    invoke-virtual {v0, v1}, Landroid/telephony/ServiceState;->setCdmaRoamingIndicator(I)V

    goto :goto_4

    :cond_e
    const/4 v0, 0x2

    if-eqz p1, :cond_10

    .line 2109
    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsInPrl:Z

    if-nez v1, :cond_10

    .line 2111
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v1

    invoke-static {v1}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v1

    if-eqz v1, :cond_f

    const-string v0, "Turn off roaming indicator as voice is LTE or NR"

    .line 2112
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2113
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v2}, Landroid/telephony/ServiceState;->setCdmaRoamingIndicator(I)V

    goto :goto_4

    .line 2115
    :cond_f
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1, v0}, Landroid/telephony/ServiceState;->setCdmaRoamingIndicator(I)V

    goto :goto_4

    :cond_10
    if-nez p1, :cond_11

    .line 2117
    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsInPrl:Z

    if-eqz v1, :cond_11

    .line 2119
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingIndicator:I

    invoke-virtual {v0, v1}, Landroid/telephony/ServiceState;->setCdmaRoamingIndicator(I)V

    goto :goto_4

    .line 2122
    :cond_11
    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingIndicator:I

    if-gt v1, v0, :cond_12

    .line 2123
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v2}, Landroid/telephony/ServiceState;->setCdmaRoamingIndicator(I)V

    goto :goto_4

    .line 2126
    :cond_12
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v1}, Landroid/telephony/ServiceState;->setCdmaRoamingIndicator(I)V

    goto :goto_4

    :cond_13
    :goto_3
    const-string v0, "Turn off roaming indicator if !isPrlLoaded or voice RAT is unknown"

    .line 2103
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2104
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v2}, Landroid/telephony/ServiceState;->setCdmaRoamingIndicator(I)V

    .line 2131
    :cond_14
    :goto_4
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

    if-eqz v0, :cond_15

    .line 2132
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getCdmaRoamingIndicator()I

    move-result v0

    .line 2133
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

    iget v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDefaultRoamingIndicator:I

    invoke-virtual {v2, v0, v3}, Lcom/android/internal/telephony/cdma/EriManager;->getCdmaEriIconIndex(II)I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/ServiceState;->setCdmaEriIconIndex(I)V

    .line 2135
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEriManager:Lcom/android/internal/telephony/cdma/EriManager;

    iget v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDefaultRoamingIndicator:I

    invoke-virtual {v2, v0, v3}, Lcom/android/internal/telephony/cdma/EriManager;->getCdmaEriIconMode(II)I

    move-result v0

    invoke-virtual {v1, v0}, Landroid/telephony/ServiceState;->setCdmaEriIconMode(I)V

    .line 2143
    :cond_15
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Set CDMA Roaming Indicator to: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getCdmaRoamingIndicator()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ". voiceRoaming = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2144
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ". dataRoaming = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2145
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", isPrlLoaded = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p2, ". namMatch = "

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, " , mIsInPrl = "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsInPrl:Z

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, ", mRoamingIndicator = "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingIndicator:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", mDefaultRoamingIndicator= "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDefaultRoamingIndicator:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2143
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2152
    :goto_5
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateDone()V

    :cond_16
    return-void
.end method

.method protected handlePollStateResultMessage(ILandroid/os/AsyncResult;)V
    .locals 9

    const/4 v0, 0x4

    const/4 v1, 0x3

    const/4 v2, 0x2

    const/4 v3, 0x0

    const/4 v4, 0x1

    if-eq p1, v0, :cond_15

    const/4 v0, 0x0

    const/4 v5, 0x5

    if-eq p1, v5, :cond_b

    const/4 v6, 0x6

    if-eq p1, v6, :cond_a

    const/4 v6, 0x7

    if-eq p1, v6, :cond_2

    const/16 v1, 0xe

    if-eq p1, v1, :cond_0

    .line 2512
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handlePollStateResultMessage: Unexpected RIL response received: "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    goto/16 :goto_9

    .line 2496
    :cond_0
    iget-object p1, p2, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [I

    .line 2497
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    aget v1, p1, v3

    if-ne v1, v4, :cond_1

    move v1, v4

    goto :goto_0

    :cond_1
    move v1, v3

    :goto_0
    invoke-virtual {p2, v1}, Landroid/telephony/ServiceState;->setIsManualSelection(Z)V

    .line 2498
    aget p1, p1, v3

    if-ne p1, v4, :cond_1f

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->shouldForceAutoNetworkSelect()Z

    move-result p1

    if-eqz p1, :cond_1f

    .line 2504
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/Phone;->setNetworkSelectionModeAutomatic(Landroid/os/Message;)V

    const-string p1, " Forcing Automatic Network Selection, manual selection is not allowed"

    .line 2505
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto/16 :goto_9

    .line 2442
    :cond_2
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p1

    if-eqz p1, :cond_4

    .line 2443
    iget-object p1, p2, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [Ljava/lang/String;

    if-eqz p1, :cond_1f

    .line 2445
    array-length p2, p1

    if-lt p2, v1, :cond_1f

    .line 2446
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    aget-object v0, p1, v3

    invoke-virtual {p2, v0}, Landroid/telephony/ServiceState;->setOperatorAlphaLongRaw(Ljava/lang/String;)V

    .line 2447
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    aget-object v0, p1, v4

    invoke-virtual {p2, v0}, Landroid/telephony/ServiceState;->setOperatorAlphaShortRaw(Ljava/lang/String;)V

    .line 2449
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getOperatorBrandOverride()Ljava/lang/String;

    move-result-object p2

    .line 2450
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfForBrandOverride(Ljava/lang/String;)V

    if-eqz p2, :cond_3

    .line 2452
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "EVENT_POLL_STATE_OPERATOR: use brandOverride="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2453
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    aget-object p1, p1, v2

    invoke-virtual {p0, p2, p2, p1}, Landroid/telephony/ServiceState;->setOperatorName(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_9

    .line 2455
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    aget-object p2, p1, v3

    aget-object v0, p1, v4

    aget-object p1, p1, v2

    invoke-virtual {p0, p2, v0, p1}, Landroid/telephony/ServiceState;->setOperatorName(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_9

    .line 2459
    :cond_4
    iget-object p1, p2, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, [Ljava/lang/String;

    if-eqz p1, :cond_9

    .line 2461
    array-length p2, p1

    if-lt p2, v1, :cond_9

    .line 2464
    aget-object p2, p1, v2

    const-string v0, "00000"

    if-eqz p2, :cond_5

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result p2

    if-lt p2, v5, :cond_5

    aget-object p2, p1, v2

    .line 2465
    invoke-virtual {v0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_6

    :cond_5
    const-string p2, "ro.cdma.home.operator.numeric"

    .line 2466
    invoke-static {p2, v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    aput-object p2, p1, v2

    .line 2469
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "RIL_REQUEST_OPERATOR.response[2], the numeric,  is bad. Using SystemProperties \'ro.cdma.home.operator.numeric\'= "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v0, p1, v2

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2476
    :cond_6
    iget-boolean p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    if-nez p2, :cond_7

    .line 2478
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    aget-object p2, p1, v3

    aget-object v0, p1, v4

    aget-object p1, p1, v2

    invoke-virtual {p0, p2, v0, p1}, Landroid/telephony/ServiceState;->setOperatorName(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_9

    .line 2480
    :cond_7
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getOperatorBrandOverride()Ljava/lang/String;

    move-result-object p2

    .line 2481
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {v0, p2}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfForBrandOverride(Ljava/lang/String;)V

    if-eqz p2, :cond_8

    .line 2483
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    aget-object p1, p1, v2

    invoke-virtual {p0, p2, p2, p1}, Landroid/telephony/ServiceState;->setOperatorName(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_9

    .line 2485
    :cond_8
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    aget-object p2, p1, v3

    aget-object v0, p1, v4

    aget-object p1, p1, v2

    invoke-virtual {p0, p2, v0, p1}, Landroid/telephony/ServiceState;->setOperatorName(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_9

    :cond_9
    const-string p1, "EVENT_POLL_STATE_OPERATOR_CDMA: error parsing opNames"

    .line 2489
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto/16 :goto_9

    .line 2365
    :cond_a
    iget-object p1, p2, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/NetworkRegistrationInfo;

    .line 2366
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p2, p1}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    .line 2369
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handlePollStateResultMessage: PS IWLAN. "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto/16 :goto_9

    .line 2375
    :cond_b
    iget-object p1, p2, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/NetworkRegistrationInfo;

    .line 2376
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p2, p1}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    .line 2378
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getDataSpecificInfo()Landroid/telephony/DataSpecificRegistrationInfo;

    move-result-object p2

    .line 2379
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v1

    .line 2380
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->regCodeToServiceState(I)I

    move-result v2

    .line 2382
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v5

    .line 2381
    invoke-static {v5}, Landroid/telephony/ServiceState;->networkTypeToRilRadioTechnology(I)I

    move-result v5

    .line 2385
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "handlePollStateResultMessage: PS cellular. "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    if-ne v2, v4, :cond_c

    .line 2392
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    .line 2395
    :cond_c
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->isEmergencyEnabled()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPSEmergencyOnly:Z

    .line 2396
    iget-boolean v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSEmergencyOnly:Z

    if-nez v2, :cond_d

    if-eqz v0, :cond_e

    :cond_d
    move v3, v4

    :cond_e
    iput-boolean v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEmergencyOnly:Z

    .line 2397
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_f

    .line 2398
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getRejectCause()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewReasonDataDenied:I

    .line 2399
    iget p2, p2, Landroid/telephony/DataSpecificRegistrationInfo;->maxDataCalls:I

    iput p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewMaxDataCalls:I

    .line 2400
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->regCodeIsRoaming(I)Z

    move-result p2

    iput-boolean p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mGsmDataRoaming:Z

    .line 2403
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, p2}, Landroid/telephony/ServiceState;->setDataRoamingFromRegistration(Z)V

    goto :goto_1

    .line 2404
    :cond_f
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result p2

    if-eqz p2, :cond_10

    .line 2405
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->regCodeIsRoaming(I)Z

    move-result p2

    .line 2406
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, p2}, Landroid/telephony/ServiceState;->setDataRoaming(Z)V

    .line 2409
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, p2}, Landroid/telephony/ServiceState;->setDataRoamingFromRegistration(Z)V

    goto :goto_1

    .line 2418
    :cond_10
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-static {p2}, Lcom/android/internal/telephony/ServiceStateTracker;->getRilDataRadioTechnologyForWwan(Landroid/telephony/ServiceState;)I

    move-result p2

    if-nez p2, :cond_11

    if-nez v5, :cond_13

    .line 2421
    :cond_11
    invoke-static {p2}, Landroid/telephony/ServiceState;->isCdma(I)Z

    move-result v0

    if-eqz v0, :cond_12

    .line 2422
    invoke-static {v5}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v0

    if-nez v0, :cond_13

    .line 2423
    :cond_12
    invoke-static {p2}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result p2

    if-eqz p2, :cond_14

    .line 2424
    invoke-static {v5}, Landroid/telephony/ServiceState;->isCdma(I)Z

    move-result p2

    if-eqz p2, :cond_14

    .line 2425
    :cond_13
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object p2

    invoke-virtual {p2}, Lcom/android/internal/telephony/SignalStrengthController;->getSignalStrengthFromCi()V

    .line 2429
    :cond_14
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->regCodeIsRoaming(I)Z

    move-result p2

    .line 2430
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, p2}, Landroid/telephony/ServiceState;->setDataRoaming(Z)V

    .line 2433
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, p2}, Landroid/telephony/ServiceState;->setDataRoamingFromRegistration(Z)V

    .line 2436
    :goto_1
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p2}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object p2

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2437
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object p1

    .line 2436
    invoke-virtual {p2, p0, p1}, Lcom/android/internal/telephony/SignalStrengthController;->updateServiceStateArfcnRsrpBoost(Landroid/telephony/ServiceState;Landroid/telephony/CellIdentity;)V

    goto/16 :goto_9

    .line 2293
    :cond_15
    iget-object p1, p2, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    check-cast p1, Landroid/telephony/NetworkRegistrationInfo;

    .line 2295
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getVoiceSpecificInfo()Landroid/telephony/VoiceSpecificRegistrationInfo;

    move-result-object p2

    .line 2297
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v0

    .line 2298
    iget-boolean v5, p2, Landroid/telephony/VoiceSpecificRegistrationInfo;->cssSupported:Z

    .line 2300
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v6

    .line 2299
    invoke-static {v6}, Landroid/telephony/ServiceState;->networkTypeToRilRadioTechnology(I)I

    .line 2301
    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->regCodeToServiceState(I)I

    move-result v7

    invoke-virtual {v6, v7}, Landroid/telephony/ServiceState;->setVoiceRegState(I)V

    .line 2302
    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v6, v5}, Landroid/telephony/ServiceState;->setCssIndicator(I)V

    .line 2303
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v5, p1}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    .line 2305
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v6

    invoke-virtual {p0, v5, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->setPhyCellInfoFromCellIdentity(Landroid/telephony/ServiceState;Landroid/telephony/CellIdentity;)V

    .line 2308
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getRejectCause()I

    move-result v5

    .line 2309
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->isEmergencyEnabled()Z

    move-result v6

    iput-boolean v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCSEmergencyOnly:Z

    if-nez v6, :cond_17

    .line 2310
    iget-boolean v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPSEmergencyOnly:Z

    if-eqz v6, :cond_16

    goto :goto_2

    :cond_16
    move v6, v3

    goto :goto_3

    :cond_17
    :goto_2
    move v6, v4

    :goto_3
    iput-boolean v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mEmergencyOnly:Z

    .line 2311
    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v6}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v6

    if-eqz v6, :cond_18

    .line 2313
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->regCodeIsRoaming(I)Z

    move-result p2

    iput-boolean p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mGsmVoiceRoaming:Z

    .line 2314
    iput v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewRejectCode:I

    goto/16 :goto_8

    .line 2316
    :cond_18
    iget v6, p2, Landroid/telephony/VoiceSpecificRegistrationInfo;->roamingIndicator:I

    .line 2319
    iget v7, p2, Landroid/telephony/VoiceSpecificRegistrationInfo;->systemIsInPrl:I

    .line 2322
    iget p2, p2, Landroid/telephony/VoiceSpecificRegistrationInfo;->defaultRoamingIndicator:I

    .line 2324
    iput v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegistrationState:I

    .line 2329
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->regCodeIsRoaming(I)Z

    move-result v0

    if-eqz v0, :cond_19

    .line 2330
    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->isRoamIndForHomeSystem(I)Z

    move-result v0

    if-nez v0, :cond_19

    move v0, v4

    goto :goto_4

    :cond_19
    move v0, v3

    .line 2331
    :goto_4
    iget-object v8, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v8, v0}, Landroid/telephony/ServiceState;->setVoiceRoaming(Z)V

    .line 2332
    iput v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingIndicator:I

    if-nez v7, :cond_1a

    move v0, v3

    goto :goto_5

    :cond_1a
    move v0, v4

    .line 2333
    :goto_5
    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsInPrl:Z

    .line 2334
    iput p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDefaultRoamingIndicator:I

    .line 2338
    invoke-virtual {p1}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object p2

    if-eqz p2, :cond_1b

    .line 2339
    invoke-virtual {p2}, Landroid/telephony/CellIdentity;->getType()I

    move-result v0

    if-ne v0, v2, :cond_1b

    .line 2340
    check-cast p2, Landroid/telephony/CellIdentityCdma;

    invoke-virtual {p2}, Landroid/telephony/CellIdentityCdma;->getSystemId()I

    move-result v3

    .line 2341
    invoke-virtual {p2}, Landroid/telephony/CellIdentityCdma;->getNetworkId()I

    move-result p2

    goto :goto_6

    :cond_1b
    move p2, v3

    .line 2343
    :goto_6
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v3, p2}, Landroid/telephony/ServiceState;->setCdmaSystemAndNetworkId(II)V

    if-nez v5, :cond_1c

    const-string p2, "General"

    .line 2346
    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegistrationDeniedReason:Ljava/lang/String;

    goto :goto_7

    :cond_1c
    if-ne v5, v4, :cond_1d

    const-string p2, "Authentication Failure"

    .line 2348
    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegistrationDeniedReason:Ljava/lang/String;

    goto :goto_7

    :cond_1d
    const-string p2, ""

    .line 2350
    iput-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegistrationDeniedReason:Ljava/lang/String;

    .line 2353
    :goto_7
    iget p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegistrationState:I

    if-ne p2, v1, :cond_1e

    .line 2354
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Registration denied, "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegistrationDeniedReason:Ljava/lang/String;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2359
    :cond_1e
    :goto_8
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "handlePollStateResultMessage: CS cellular. "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    :cond_1f
    :goto_9
    return-void
.end method

.method protected hangupAndPowerOff()V
    .locals 3

    .line 5294
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 5296
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isInCall()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 5297
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget-object v0, v0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mRingingCall:Lcom/android/internal/telephony/GsmCdmaCall;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->hangupIfAlive()V

    .line 5298
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget-object v0, v0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mBackgroundCall:Lcom/android/internal/telephony/GsmCdmaCall;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->hangupIfAlive()V

    .line 5299
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget-object v0, v0, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v0, v0, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mForegroundCall:Lcom/android/internal/telephony/GsmCdmaCall;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Call;->hangupIfAlive()V

    .line 5302
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x0

    const/16 v2, 0x36

    invoke-virtual {p0, v2}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v0, v1, p0}, Lcom/android/internal/telephony/CommandsInterface;->setRadioPower(ZLandroid/os/Message;)V

    return-void
.end method

.method protected inSameCountry(Ljava/lang/String;)Z
    .locals 5

    .line 5625
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_7

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v2, 0x5

    if-ge v0, v2, :cond_0

    goto/16 :goto_2

    .line 5629
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getHomeOperatorNumeric()Ljava/lang/String;

    move-result-object v0

    .line 5630
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_7

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v3

    if-ge v3, v2, :cond_1

    goto :goto_2

    :cond_1
    const/4 v2, 0x3

    .line 5635
    invoke-virtual {p1, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    .line 5636
    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    .line 5637
    invoke-static {p1}, Lcom/android/internal/telephony/MccTable;->countryCodeForMcc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 5638
    invoke-static {v0}, Lcom/android/internal/telephony/MccTable;->countryCodeForMcc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 5640
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLocaleTracker:Lcom/android/internal/telephony/LocaleTracker;

    if-eqz v2, :cond_2

    invoke-virtual {v2}, Lcom/android/internal/telephony/LocaleTracker;->getCountryOverride()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_2

    const-string p1, "inSameCountry:  countryOverride var set.  This should only be set for testing purposes to override the device location."

    .line 5641
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5643
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLocaleTracker:Lcom/android/internal/telephony/LocaleTracker;

    invoke-virtual {p0}, Lcom/android/internal/telephony/LocaleTracker;->getCountryOverride()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0

    .line 5646
    :cond_2
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p0

    if-nez p0, :cond_7

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_3

    goto :goto_2

    .line 5650
    :cond_3
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_4

    return p0

    :cond_4
    const-string/jumbo v1, "us"

    .line 5655
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const/4 v3, 0x1

    const-string/jumbo v4, "vi"

    if-eqz v2, :cond_5

    invoke-virtual {v4, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_5

    :goto_0
    move p0, v3

    goto :goto_1

    .line 5657
    :cond_5
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_6

    goto :goto_0

    :cond_6
    :goto_1
    return p0

    :cond_7
    :goto_2
    return v1
.end method

.method protected isCallerOnDifferentThread()Z
    .locals 1

    .line 5616
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {p0}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;

    move-result-object p0

    invoke-virtual {p0}, Landroid/os/Looper;->getThread()Ljava/lang/Thread;

    move-result-object p0

    if-eq v0, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public isConcurrentVoiceAndDataAllowed()Z
    .locals 4
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 3386
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getCssIndicator()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    return v1

    .line 3389
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    const/4 v2, 0x0

    if-eqz v0, :cond_3

    .line 3390
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v0

    if-nez v0, :cond_1

    .line 3393
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3394
    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v3

    if-eqz v3, :cond_1

    .line 3395
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v0

    :cond_1
    if-eqz v0, :cond_2

    .line 3400
    invoke-static {v0}, Landroid/telephony/ServiceState;->rilRadioTechnologyToAccessNetworkType(I)I

    move-result p0

    if-eq p0, v1, :cond_2

    goto :goto_0

    :cond_2
    move v1, v2

    :goto_0
    return v1

    :cond_3
    return v2
.end method

.method public isDeviceShuttingDown()Z
    .locals 0

    .line 5903
    iget-boolean p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    return p0
.end method

.method protected isGprsConsistent(II)Z
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    if-nez p2, :cond_1

    if-nez p1, :cond_0

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

.method protected isHomeSid(I)Z
    .locals 4

    .line 1864
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    move v0, v1

    .line 1865
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    array-length v3, v2

    if-ge v0, v3, :cond_1

    .line 1866
    aget v2, v2, v0

    if-ne p1, v2, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    return v1
.end method

.method public isImsRegistered()Z
    .locals 0
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 5598
    iget-boolean p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistered:Z

    return p0
.end method

.method protected isInHomeSidNid(II)Z
    .locals 5
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 4237
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->isSidsAllZeros()Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    return v1

    .line 4240
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    array-length v0, v0

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeNetworkId:[I

    array-length v2, v2

    if-eq v0, v2, :cond_1

    return v1

    :cond_1
    if-nez p1, :cond_2

    return v1

    :cond_2
    const/4 v0, 0x0

    move v2, v0

    .line 4244
    :goto_0
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    array-length v4, v3

    if-ge v2, v4, :cond_5

    .line 4247
    aget v3, v3, v2

    if-ne v3, p1, :cond_4

    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeNetworkId:[I

    aget v3, v3, v2

    if-eqz v3, :cond_3

    const v4, 0xffff

    if-eq v3, v4, :cond_3

    if-eqz p2, :cond_3

    if-eq p2, v4, :cond_3

    if-ne v3, p2, :cond_4

    :cond_3
    return v1

    :cond_4
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_5
    return v0
.end method

.method protected isInvalidOperatorNumeric(Ljava/lang/String;)Z
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    if-eqz p1, :cond_1

    .line 4279
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    const/4 v0, 0x5

    if-lt p0, v0, :cond_1

    const-string p0, "000"

    .line 4280
    invoke-virtual {p1, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

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

.method public isMinInfoReady()Z
    .locals 0

    .line 1909
    iget-boolean p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsMinInfoReady:Z

    return p0
.end method

.method protected final isNonRoamingInCdmaNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z
    .locals 1

    const-string v0, "cdma_nonroaming_networks_string_array"

    .line 5898
    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isInNetwork(Landroid/os/BaseBundle;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method protected final isNonRoamingInGsmNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z
    .locals 1

    const-string v0, "gsm_nonroaming_networks_string_array"

    .line 5890
    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isInNetwork(Landroid/os/BaseBundle;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method protected isOperatorConsideredNonRoaming(Landroid/telephony/ServiceState;)Z
    .locals 5

    .line 4412
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object p1

    .line 4414
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object p0

    const-string v0, "non_roaming_operator_string_array"

    .line 4415
    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 4418
    invoke-static {p0}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty([Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_2

    if-nez p1, :cond_0

    goto :goto_1

    .line 4422
    :cond_0
    array-length v0, p0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_2

    aget-object v3, p0, v2

    .line 4423
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_1

    invoke-virtual {p1, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    :goto_1
    return v1
.end method

.method protected isOperatorConsideredRoaming(Landroid/telephony/ServiceState;)Z
    .locals 5

    .line 4433
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object p1

    .line 4434
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object p0

    const-string v0, "roaming_operator_string_array"

    .line 4435
    invoke-virtual {p0, v0}, Landroid/os/PersistableBundle;->getStringArray(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 4437
    invoke-static {p0}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty([Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_2

    if-nez p1, :cond_0

    goto :goto_1

    .line 4441
    :cond_0
    array-length v0, p0

    move v2, v1

    :goto_0
    if-ge v2, v0, :cond_2

    aget-object v3, p0, v2

    .line 4442
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_1

    invoke-virtual {p1, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    :goto_1
    return v1
.end method

.method public isRadioOn()Z
    .locals 1

    .line 3443
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method protected isRoamIndForHomeSystem(I)Z
    .locals 5

    .line 2718
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    const-string v1, "cdma_enhanced_roaming_indicator_for_home_network_int_array"

    .line 2719
    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v0

    .line 2722
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isRoamIndForHomeSystem: homeRoamIndicators="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 2727
    array-length v2, v0

    move v3, v1

    :goto_0
    if-ge v3, v2, :cond_1

    aget v4, v0, v3

    if-ne v4, p1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 2733
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "isRoamIndForHomeSystem: No match found against list for roamInd="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return v1

    :cond_2
    const-string p1, "isRoamIndForHomeSystem: No list found"

    .line 2738
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return v1
.end method

.method protected isRoamingBetweenOperators(ZLandroid/telephony/ServiceState;)Z
    .locals 0

    if-eqz p1, :cond_0

    .line 2166
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->isSameOperatorNameFromSimAndSS(Landroid/telephony/ServiceState;)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method protected final isRoamingInCdmaNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z
    .locals 1

    const-string v0, "cdma_roaming_networks_string_array"

    .line 5894
    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isInNetwork(Landroid/os/BaseBundle;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method protected final isRoamingInGsmNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z
    .locals 1

    const-string v0, "gsm_roaming_networks_string_array"

    .line 5886
    invoke-direct {p0, p1, p2, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isInNetwork(Landroid/os/BaseBundle;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method protected isSidsAllZeros()Z
    .locals 4

    .line 1841
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    if-eqz v0, :cond_1

    const/4 v0, 0x0

    move v1, v0

    .line 1842
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    array-length v3, v2

    if-ge v1, v3, :cond_1

    .line 1843
    aget v2, v2, v1

    if-eqz v2, :cond_0

    return v0

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x1

    return p0
.end method

.method protected log(Ljava/lang/String;)V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 3361
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "] "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "SST"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logAttachChange()V
    .locals 1

    .line 3342
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachLog:Lcom/android/internal/telephony/LocalLog;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logPhoneTypeChange()V
    .locals 1

    .line 3348
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhoneTypeLog:Lcom/android/internal/telephony/LocalLog;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getPhoneType()I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logRatChange()V
    .locals 1

    .line 3354
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRatLog:Lcom/android/internal/telephony/LocalLog;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logRoamingChange()V
    .locals 1

    .line 3336
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRoamingLog:Lcom/android/internal/telephony/LocalLog;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 3368
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "] "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "SST"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected mtkHangupAllCalls()V
    .locals 0

    return-void
.end method

.method protected mtkHangupAllImsCall()V
    .locals 0

    return-void
.end method

.method protected mtkPowerOffNonDdsPhone()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected notifyDataRegStateRilRadioTechnologyChanged(I)V
    .locals 1

    .line 974
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRegStateOrRatChangedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/RegistrantList;

    if-eqz v0, :cond_0

    .line 976
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->getRegistrationInfo(I)Landroid/util/Pair;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 978
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    :cond_0
    return-void
.end method

.method protected notifySpnDisplayUpdate(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)V
    .locals 11

    .line 2855
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    .line 2857
    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    if-ne v1, v0, :cond_0

    .line 2858
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowPlmn()Z

    move-result v1

    iget-boolean v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurShowPlmn:Z

    if-ne v1, v2, :cond_0

    .line 2859
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowSpn()Z

    move-result v1

    iget-boolean v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurShowSpn:Z

    if-ne v1, v2, :cond_0

    .line 2860
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getSpn()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurSpn:Ljava/lang/String;

    invoke-static {v1, v2}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2861
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getDataSpn()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurDataSpn:Ljava/lang/String;

    invoke-static {v1, v2}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 2862
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getPlmn()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurPlmn:Ljava/lang/String;

    invoke-static {v1, v2}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_1

    :cond_0
    const/4 v1, 0x7

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    .line 2864
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 2867
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierNameDisplayBitmask(Landroid/telephony/ServiceState;)I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v1, v2

    .line 2868
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowPlmn()Z

    move-result v2

    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    const/4 v3, 0x1

    aput-object v2, v1, v3

    const/4 v2, 0x2

    .line 2869
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getPlmn()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v1, v2

    const/4 v2, 0x3

    .line 2870
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowSpn()Z

    move-result v4

    invoke-static {v4}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v4

    aput-object v4, v1, v2

    const/4 v2, 0x4

    .line 2871
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getSpn()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v1, v2

    const/4 v2, 0x5

    .line 2872
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getDataSpn()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v1, v2

    const/4 v2, 0x6

    .line 2873
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v1, v2

    const-string/jumbo v2, "updateSpnDisplay: changed sending intent, rule=%d, showPlmn=\'%b\', plmn=\'%s\', showSpn=\'%b\', spn=\'%s\', dataSpn=\'%s\', subId=\'%d\'"

    .line 2864
    invoke-static {v2, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    .line 2874
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnrLogs:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 2875
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "updateSpnDisplay: "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2877
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.telephony.action.SERVICE_PROVIDERS_UPDATED"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 2878
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowSpn()Z

    move-result v2

    const-string v4, "android.telephony.extra.SHOW_SPN"

    invoke-virtual {v1, v4, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 2879
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getSpn()Ljava/lang/String;

    move-result-object v2

    const-string v4, "android.telephony.extra.SPN"

    invoke-virtual {v1, v4, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 2880
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getDataSpn()Ljava/lang/String;

    move-result-object v2

    const-string v4, "android.telephony.extra.DATA_SPN"

    invoke-virtual {v1, v4, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 2881
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowPlmn()Z

    move-result v2

    const-string v4, "android.telephony.extra.SHOW_PLMN"

    invoke-virtual {v1, v4, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 2882
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getPlmn()Ljava/lang/String;

    move-result-object v2

    const-string v4, "android.telephony.extra.PLMN"

    invoke-virtual {v1, v4, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 2883
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    invoke-static {v1, v2}, Landroid/telephony/SubscriptionManager;->putPhoneIdAndSubIdExtra(Landroid/content/Intent;I)V

    .line 2884
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    sget-object v4, Landroid/os/UserHandle;->ALL:Landroid/os/UserHandle;

    invoke-virtual {v2, v1, v4}, Landroid/content/Context;->sendStickyBroadcastAsUser(Landroid/content/Intent;Landroid/os/UserHandle;)V

    .line 2886
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v6

    .line 2887
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowPlmn()Z

    move-result v7

    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getPlmn()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowSpn()Z

    move-result v9

    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getSpn()Ljava/lang/String;

    move-result-object v10

    .line 2886
    invoke-virtual/range {v5 .. v10}, Lcom/android/internal/telephony/SubscriptionController;->setPlmnSpn(IZLjava/lang/String;ZLjava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_1

    .line 2888
    iput-boolean v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSpnUpdatePending:Z

    .line 2892
    :cond_1
    iput v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    .line 2893
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowSpn()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurShowSpn:Z

    .line 2894
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowPlmn()Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurShowPlmn:Z

    .line 2895
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getSpn()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurSpn:Ljava/lang/String;

    .line 2896
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getDataSpn()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurDataSpn:Ljava/lang/String;

    .line 2897
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getPlmn()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurPlmn:Ljava/lang/String;

    return-void
.end method

.method protected notifyVoiceRegStateRilRadioTechnologyChanged()V
    .locals 4

    .line 940
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v0

    .line 941
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getState()I

    move-result v1

    .line 942
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "notifyVoiceRegStateRilRadioTechnologyChanged: vrs="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " rat="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 944
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRegStateOrRatChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    new-instance v2, Landroid/util/Pair;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-direct {v2, v1, v0}, Landroid/util/Pair;-><init>(Ljava/lang/Object;Ljava/lang/Object;)V

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    return-void
.end method

.method public onAirplaneModeChanged(Z)V
    .locals 1

    const/4 v0, 0x0

    .line 1991
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastNitzData:Lcom/android/internal/telephony/NitzData;

    .line 1992
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {v0, p1}, Lcom/android/internal/telephony/NitzStateMachine;->handleAirplaneModeChanged(Z)V

    .line 1993
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAirplaneModeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->notifyResult(Ljava/lang/Object;)V

    return-void
.end method

.method public onImsCapabilityChanged()V
    .locals 1

    const/16 v0, 0x30

    .line 3439
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public onImsServiceStateChanged()V
    .locals 1

    const/16 v0, 0x35

    .line 3409
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public onTelecomVoiceServiceStateOverrideChanged()V
    .locals 1

    const/16 v0, 0x41

    .line 5470
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method protected onUpdateIccAvailability()V
    .locals 4

    .line 3290
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    if-nez v0, :cond_0

    return-void

    .line 3294
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getUiccCardApplication()Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object v0

    .line 3296
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    if-eq v1, v0, :cond_6

    .line 3299
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    instance-of v2, v1, Lcom/android/internal/telephony/uicc/SIMRecords;

    const/4 v3, 0x0

    if-eqz v2, :cond_1

    .line 3300
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfFromUsim(Lcom/android/internal/telephony/uicc/SIMRecords;)V

    goto :goto_0

    .line 3301
    :cond_1
    instance-of v1, v1, Lcom/android/internal/telephony/uicc/RuimRecords;

    if-eqz v1, :cond_2

    .line 3302
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdnr:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;

    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->updateEfFromRuim(Lcom/android/internal/telephony/uicc/RuimRecords;)V

    .line 3305
    :cond_2
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    if-eqz v1, :cond_4

    const-string v1, "Removing stale icc objects."

    .line 3306
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3307
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->unregisterForReady(Landroid/os/Handler;)V

    .line 3308
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v1, :cond_3

    .line 3309
    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/uicc/IccRecords;->unregisterForRecordsLoaded(Landroid/os/Handler;)V

    .line 3311
    :cond_3
    iput-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    .line 3312
    iput-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    :cond_4
    if-eqz v0, :cond_6

    const-string v1, "New card found"

    .line 3315
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3316
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    .line 3317
    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getIccRecords()Lcom/android/internal/telephony/uicc/IccRecords;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    .line 3318
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 3319
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    const/16 v1, 0x11

    invoke-virtual {v0, p0, v1, v3}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->registerForReady(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 3320
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v0, :cond_6

    const/16 v1, 0x10

    .line 3321
    invoke-virtual {v0, p0, v1, v3}, Lcom/android/internal/telephony/uicc/IccRecords;->registerForRecordsLoaded(Landroid/os/Handler;ILjava/lang/Object;)V

    goto :goto_1

    .line 3323
    :cond_5
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    if-eqz v0, :cond_6

    .line 3324
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccApplcation:Lcom/android/internal/telephony/uicc/UiccCardApplication;

    const/16 v1, 0x1a

    invoke-virtual {v0, p0, v1, v3}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->registerForReady(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 3325
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v0, :cond_6

    const/16 v1, 0x1b

    .line 3326
    invoke-virtual {v0, p0, v1, v3}, Lcom/android/internal/telephony/uicc/IccRecords;->registerForRecordsLoaded(Landroid/os/Handler;ILjava/lang/Object;)V

    :cond_6
    :goto_1
    return-void
.end method

.method protected parseSidNid(Ljava/lang/String;Ljava/lang/String;)V
    .locals 7

    const/4 v0, 0x0

    const-string v1, ","

    if-eqz p1, :cond_0

    .line 1949
    invoke-virtual {p1, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    .line 1950
    array-length v3, v2

    new-array v3, v3, [I

    iput-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    move v3, v0

    .line 1951
    :goto_0
    array-length v4, v2

    if-ge v3, v4, :cond_0

    .line 1953
    :try_start_0
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeSystemId:[I

    aget-object v5, v2, v3

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    aput v5, v4, v3
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception v4

    .line 1955
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "error parsing system id: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 1959
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "CDMA_SUBSCRIPTION: SID="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    if-eqz p2, :cond_1

    .line 1962
    invoke-virtual {p2, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p1

    .line 1963
    array-length v1, p1

    new-array v1, v1, [I

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeNetworkId:[I

    .line 1964
    :goto_2
    array-length v1, p1

    if-ge v0, v1, :cond_1

    .line 1966
    :try_start_1
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHomeNetworkId:[I

    aget-object v2, p1, v0

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    aput v2, v1, v0
    :try_end_1
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_3

    :catch_1
    move-exception v1

    .line 1968
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "CDMA_SUBSCRIPTION: error parsing network id: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    :goto_3
    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 1972
    :cond_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "CDMA_SUBSCRIPTION: NID="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void
.end method

.method public pollState()V
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    const/16 v0, 0x3a

    .line 3456
    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    return-void
.end method

.method protected pollStateDone()V
    .locals 37

    move-object/from16 v0, p0

    .line 3574
    iget-object v1, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-nez v1, :cond_0

    .line 3575
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateRoamingState()V

    .line 3578
    :cond_0
    sget-boolean v1, Lcom/android/internal/telephony/util/TelephonyUtils;->IS_DEBUGGABLE:Z

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_1

    const-string/jumbo v1, "telephony.test.forceRoaming"

    .line 3579
    invoke-static {v1, v3}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 3580
    iget-object v1, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1, v2}, Landroid/telephony/ServiceState;->setRoaming(Z)V

    .line 3582
    :cond_1
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->useDataRegStateForDataOnlyDevices()V

    .line 3583
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->processIwlanRegistrationInfo()V

    .line 3585
    sget-boolean v1, Lcom/android/internal/telephony/util/TelephonyUtils;->IS_DEBUGGABLE:Z

    if-eqz v1, :cond_2

    iget-object v1, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget-object v1, v1, Lcom/android/internal/telephony/Phone;->mTelephonyTester:Lcom/android/internal/telephony/TelephonyTester;

    if-eqz v1, :cond_2

    .line 3586
    iget-object v4, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1, v4}, Lcom/android/internal/telephony/TelephonyTester;->overrideServiceState(Landroid/telephony/ServiceState;)V

    .line 3589
    :cond_2
    iget-object v1, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    const/4 v4, 0x2

    invoke-virtual {v1, v4, v2}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v1

    .line 3591
    iget-object v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    iget-object v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v5, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->updateNrFrequencyRangeFromPhysicalChannelConfigs(Ljava/util/List;Landroid/telephony/ServiceState;)Z

    .line 3592
    iget-object v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    iget-object v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v5, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->updateNrStateFromPhysicalChannelConfigs(Ljava/util/List;Landroid/telephony/ServiceState;)Z

    .line 3593
    iget-object v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v1

    invoke-virtual {v0, v5, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->setPhyCellInfoFromCellIdentity(Landroid/telephony/ServiceState;Landroid/telephony/CellIdentity;)V

    .line 3596
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Poll ServiceState done:  oldSS=["

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, "] newSS=["

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v5, "] oldMaxDataCalls="

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mMaxDataCalls:I

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " mNewMaxDataCalls="

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewMaxDataCalls:I

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " oldReasonDataDenied="

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mReasonDataDenied:I

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " mNewReasonDataDenied="

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewReasonDataDenied:I

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3604
    iget-object v1, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3605
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getState()I

    move-result v1

    if-eqz v1, :cond_3

    iget-object v1, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 3606
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getState()I

    move-result v1

    if-nez v1, :cond_3

    move v1, v2

    goto :goto_0

    :cond_3
    move v1, v3

    .line 3608
    :goto_0
    iget-object v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3609
    invoke-virtual {v5}, Landroid/telephony/ServiceState;->getState()I

    move-result v5

    if-nez v5, :cond_4

    iget-object v5, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 3610
    invoke-virtual {v5}, Landroid/telephony/ServiceState;->getState()I

    move-result v5

    if-eqz v5, :cond_4

    move v5, v2

    goto :goto_1

    :cond_4
    move v5, v3

    .line 3612
    :goto_1
    iget-object v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3613
    invoke-virtual {v6}, Landroid/telephony/ServiceState;->getState()I

    move-result v6

    const/4 v7, 0x3

    if-eq v6, v7, :cond_5

    iget-object v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 3614
    invoke-virtual {v6}, Landroid/telephony/ServiceState;->getState()I

    move-result v6

    if-ne v6, v7, :cond_5

    move v6, v2

    goto :goto_2

    :cond_5
    move v6, v3

    .line 3615
    :goto_2
    iget-object v8, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3616
    invoke-virtual {v8}, Landroid/telephony/ServiceState;->getState()I

    move-result v8

    if-ne v8, v7, :cond_6

    iget-object v8, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 3617
    invoke-virtual {v8}, Landroid/telephony/ServiceState;->getState()I

    move-result v8

    if-eq v8, v7, :cond_6

    move v8, v2

    goto :goto_3

    :cond_6
    move v8, v3

    .line 3619
    :goto_3
    new-instance v9, Landroid/util/SparseBooleanArray;

    iget-object v10, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 3620
    invoke-virtual {v10}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v10

    array-length v10, v10

    invoke-direct {v9, v10}, Landroid/util/SparseBooleanArray;-><init>(I)V

    .line 3621
    new-instance v10, Landroid/util/SparseBooleanArray;

    iget-object v11, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 3622
    invoke-virtual {v11}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v11

    array-length v11, v11

    invoke-direct {v10, v11}, Landroid/util/SparseBooleanArray;-><init>(I)V

    .line 3623
    new-instance v11, Landroid/util/SparseBooleanArray;

    iget-object v12, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 3624
    invoke-virtual {v12}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v12

    array-length v12, v12

    invoke-direct {v11, v12}, Landroid/util/SparseBooleanArray;-><init>(I)V

    .line 3625
    new-instance v12, Landroid/util/SparseBooleanArray;

    iget-object v13, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    .line 3626
    invoke-virtual {v13}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v13

    array-length v13, v13

    invoke-direct {v12, v13}, Landroid/util/SparseBooleanArray;-><init>(I)V

    .line 3629
    iget-object v13, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3630
    invoke-virtual {v13}, Landroid/telephony/ServiceState;->getOperatorAlphaLongRaw()Ljava/lang/String;

    move-result-object v13

    iget-object v14, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v14}, Landroid/telephony/ServiceState;->getOperatorAlphaLongRaw()Ljava/lang/String;

    move-result-object v14

    invoke-static {v13, v14}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v13

    if-eqz v13, :cond_8

    iget-object v13, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3631
    invoke-virtual {v13}, Landroid/telephony/ServiceState;->getOperatorAlphaShortRaw()Ljava/lang/String;

    move-result-object v13

    iget-object v14, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 3632
    invoke-virtual {v14}, Landroid/telephony/ServiceState;->getOperatorAlphaShortRaw()Ljava/lang/String;

    move-result-object v14

    .line 3631
    invoke-static {v13, v14}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v13

    if-nez v13, :cond_7

    goto :goto_4

    :cond_7
    move v13, v3

    goto :goto_5

    :cond_8
    :goto_4
    move v13, v2

    .line 3634
    :goto_5
    iget-object v14, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v14}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v14

    array-length v15, v14

    move v7, v3

    move/from16 v17, v7

    move/from16 v18, v17

    :goto_6
    if-ge v7, v15, :cond_18

    aget v2, v14, v7

    .line 3635
    iget-object v3, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3, v4, v2}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v3

    move-object/from16 v22, v14

    .line 3637
    iget-object v14, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v14, v4, v2}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v14

    if-eqz v3, :cond_9

    .line 3645
    invoke-virtual {v3}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v23

    if-eqz v23, :cond_9

    if-eqz v6, :cond_a

    :cond_9
    if-eqz v14, :cond_a

    .line 3646
    invoke-virtual {v14}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v23

    if-eqz v23, :cond_a

    const/4 v4, 0x1

    goto :goto_7

    :cond_a
    const/4 v4, 0x0

    .line 3647
    :goto_7
    invoke-virtual {v9, v2, v4}, Landroid/util/SparseBooleanArray;->put(IZ)V

    if-eqz v3, :cond_c

    .line 3649
    invoke-virtual {v3}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v4

    if-eqz v4, :cond_c

    if-eqz v14, :cond_b

    .line 3650
    invoke-virtual {v14}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v4

    if-nez v4, :cond_c

    :cond_b
    const/4 v4, 0x1

    goto :goto_8

    :cond_c
    const/4 v4, 0x0

    .line 3651
    :goto_8
    invoke-virtual {v10, v2, v4}, Landroid/util/SparseBooleanArray;->put(IZ)V

    if-eqz v3, :cond_d

    .line 3653
    invoke-virtual {v3}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v4

    goto :goto_9

    :cond_d
    const/4 v4, 0x0

    :goto_9
    if-eqz v14, :cond_e

    .line 3655
    invoke-virtual {v14}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v24

    move/from16 v36, v24

    move/from16 v24, v15

    move/from16 v15, v36

    goto :goto_a

    :cond_e
    move/from16 v24, v15

    const/4 v15, 0x0

    :goto_a
    if-eqz v3, :cond_f

    .line 3658
    invoke-virtual {v3}, Landroid/telephony/NetworkRegistrationInfo;->isUsingCarrierAggregation()Z

    move-result v25

    move/from16 v36, v25

    move/from16 v25, v8

    move/from16 v8, v36

    goto :goto_b

    :cond_f
    move/from16 v25, v8

    const/4 v8, 0x0

    :goto_b
    if-eqz v14, :cond_10

    .line 3659
    invoke-virtual {v14}, Landroid/telephony/NetworkRegistrationInfo;->isUsingCarrierAggregation()Z

    move-result v26

    move/from16 v36, v26

    move/from16 v26, v6

    move/from16 v6, v36

    goto :goto_c

    :cond_10
    move/from16 v26, v6

    const/4 v6, 0x0

    :goto_c
    if-ne v4, v15, :cond_12

    if-ne v8, v6, :cond_12

    if-eqz v13, :cond_11

    goto :goto_d

    :cond_11
    const/4 v6, 0x0

    goto :goto_e

    :cond_12
    :goto_d
    const/4 v6, 0x1

    .line 3663
    :goto_e
    invoke-virtual {v11, v2, v6}, Landroid/util/SparseBooleanArray;->put(IZ)V

    if-eq v4, v15, :cond_13

    const/16 v17, 0x1

    :cond_13
    if-eqz v3, :cond_14

    .line 3669
    invoke-virtual {v3}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v3

    goto :goto_f

    :cond_14
    const/4 v3, 0x4

    :goto_f
    if-eqz v14, :cond_15

    .line 3671
    invoke-virtual {v14}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v4

    goto :goto_10

    :cond_15
    const/4 v4, 0x4

    :goto_10
    if-eq v3, v4, :cond_16

    const/4 v6, 0x1

    goto :goto_11

    :cond_16
    const/4 v6, 0x0

    .line 3673
    :goto_11
    invoke-virtual {v12, v2, v6}, Landroid/util/SparseBooleanArray;->put(IZ)V

    if-eq v3, v4, :cond_17

    const/16 v18, 0x1

    :cond_17
    add-int/lit8 v7, v7, 0x1

    move-object/from16 v14, v22

    move/from16 v15, v24

    move/from16 v8, v25

    move/from16 v6, v26

    const/4 v3, 0x0

    const/4 v4, 0x2

    goto/16 :goto_6

    :cond_18
    move/from16 v26, v6

    move/from16 v25, v8

    if-nez v17, :cond_19

    .line 3681
    iget-object v2, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3682
    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v2

    iget-object v3, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v3

    if-eq v2, v3, :cond_19

    const/4 v2, 0x1

    goto :goto_12

    :cond_19
    const/4 v2, 0x0

    .line 3684
    :goto_12
    iget-object v3, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3685
    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getState()I

    move-result v3

    iget-object v4, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v4}, Landroid/telephony/ServiceState;->getState()I

    move-result v4

    if-eq v3, v4, :cond_1a

    const/4 v3, 0x1

    goto :goto_13

    :cond_1a
    const/4 v3, 0x0

    .line 3687
    :goto_13
    iget-object v4, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3688
    invoke-virtual {v4}, Landroid/telephony/ServiceState;->getNrFrequencyRange()I

    move-result v4

    iget-object v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v6}, Landroid/telephony/ServiceState;->getNrFrequencyRange()I

    move-result v6

    if-eq v4, v6, :cond_1b

    const/4 v4, 0x1

    goto :goto_14

    :cond_1b
    const/4 v4, 0x0

    .line 3690
    :goto_14
    iget-object v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v6}, Landroid/telephony/ServiceState;->getNrState()I

    move-result v6

    iget-object v7, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v7}, Landroid/telephony/ServiceState;->getNrState()I

    move-result v7

    if-eq v6, v7, :cond_1c

    const/4 v6, 0x1

    goto :goto_15

    :cond_1c
    const/4 v6, 0x0

    .line 3692
    :goto_15
    iget-object v7, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-static {v7}, Lcom/android/internal/telephony/ServiceStateTracker;->getPrioritizedCellIdentities(Landroid/telephony/ServiceState;)Ljava/util/List;

    move-result-object v7

    .line 3694
    invoke-interface {v7}, Ljava/util/List;->isEmpty()Z

    move-result v8

    if-eqz v8, :cond_1d

    const/4 v8, 0x0

    goto :goto_16

    :cond_1d
    const/4 v8, 0x0

    .line 3695
    invoke-interface {v7, v8}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v13

    move-object v8, v13

    check-cast v8, Landroid/telephony/CellIdentity;

    .line 3697
    :goto_16
    iget-object v13, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    if-nez v13, :cond_1e

    if-eqz v8, :cond_1f

    goto :goto_17

    .line 3698
    :cond_1e
    invoke-virtual {v13, v8}, Landroid/telephony/CellIdentity;->isSameCell(Landroid/telephony/CellIdentity;)Z

    move-result v13

    if-nez v13, :cond_1f

    :goto_17
    const/4 v13, 0x1

    goto :goto_18

    :cond_1f
    const/4 v13, 0x0

    .line 3701
    :goto_18
    iget-object v14, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    const/4 v15, 0x1

    invoke-virtual {v14, v15}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfoListForTransportType(I)Ljava/util/List;

    move-result-object v14

    invoke-interface {v14}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v14

    const/4 v15, 0x0

    :goto_19
    invoke-interface {v14}, Ljava/util/Iterator;->hasNext()Z

    move-result v22

    if-eqz v22, :cond_20

    invoke-interface {v14}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v22

    check-cast v22, Landroid/telephony/NetworkRegistrationInfo;

    .line 3703
    invoke-virtual/range {v22 .. v22}, Landroid/telephony/NetworkRegistrationInfo;->isRegistered()Z

    move-result v22

    or-int v15, v15, v22

    goto :goto_19

    :cond_20
    if-eqz v15, :cond_21

    if-nez v13, :cond_21

    .line 3708
    iget-object v14, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mRatRatcheter:Lcom/android/internal/telephony/RatRatcheter;

    iget-object v15, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    move-object/from16 v22, v7

    iget-object v7, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v14, v15, v7}, Lcom/android/internal/telephony/RatRatcheter;->ratchet(Landroid/telephony/ServiceState;Landroid/telephony/ServiceState;)V

    goto :goto_1a

    :cond_21
    move-object/from16 v22, v7

    .line 3711
    :goto_1a
    iget-object v7, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3712
    invoke-virtual {v7}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v7

    iget-object v14, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v14}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v14

    if-eq v7, v14, :cond_22

    const/4 v7, 0x1

    goto :goto_1b

    :cond_22
    const/4 v7, 0x0

    .line 3714
    :goto_1b
    iget-object v14, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget-object v15, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v14, v15}, Landroid/telephony/ServiceState;->equals(Ljava/lang/Object;)Z

    move-result v14

    const/4 v15, 0x1

    xor-int/2addr v14, v15

    .line 3716
    iget-object v15, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v15

    if-nez v15, :cond_23

    iget-object v15, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v15

    if-eqz v15, :cond_23

    move-object/from16 v24, v8

    const/4 v15, 0x1

    goto :goto_1c

    :cond_23
    move-object/from16 v24, v8

    const/4 v15, 0x0

    .line 3718
    :goto_1c
    iget-object v8, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v8}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v8

    if-eqz v8, :cond_24

    iget-object v8, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v8}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v8

    if-nez v8, :cond_24

    move/from16 v27, v3

    const/4 v8, 0x1

    goto :goto_1d

    :cond_24
    move/from16 v27, v3

    const/4 v8, 0x0

    .line 3720
    :goto_1d
    iget-object v3, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v3

    if-nez v3, :cond_25

    iget-object v3, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v3

    if-eqz v3, :cond_25

    move/from16 v28, v6

    const/4 v3, 0x1

    goto :goto_1e

    :cond_25
    move/from16 v28, v6

    const/4 v3, 0x0

    .line 3722
    :goto_1e
    iget-object v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v6}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v6

    if-eqz v6, :cond_26

    iget-object v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v6}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v6

    if-nez v6, :cond_26

    move/from16 v29, v4

    const/4 v6, 0x1

    goto :goto_1f

    :cond_26
    move/from16 v29, v4

    const/4 v6, 0x0

    .line 3724
    :goto_1f
    iget v4, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mRejectCode:I

    move/from16 v30, v13

    iget v13, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewRejectCode:I

    if-eq v4, v13, :cond_27

    const/4 v4, 0x1

    goto :goto_20

    :cond_27
    const/4 v4, 0x0

    .line 3726
    :goto_20
    iget-object v13, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v13}, Landroid/telephony/ServiceState;->getCssIndicator()I

    move-result v13

    move/from16 v31, v4

    iget-object v4, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v4}, Landroid/telephony/ServiceState;->getCssIndicator()I

    move-result v4

    if-eq v13, v4, :cond_28

    const/4 v4, 0x1

    goto :goto_21

    :cond_28
    const/4 v4, 0x0

    .line 3728
    :goto_21
    iget-object v13, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v13}, Landroid/telephony/ServiceState;->getCellBandwidths()[I

    move-result-object v13

    move/from16 v32, v4

    iget-object v4, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v4}, Landroid/telephony/ServiceState;->getCellBandwidths()[I

    move-result-object v4

    if-eq v13, v4, :cond_29

    const/4 v4, 0x1

    goto :goto_22

    :cond_29
    const/4 v4, 0x0

    .line 3733
    :goto_22
    iget-object v13, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v13}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v13

    if-eqz v13, :cond_30

    .line 3734
    iget-object v13, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-static {v13}, Lcom/android/internal/telephony/ServiceStateTracker;->getRilDataRadioTechnologyForWwan(Landroid/telephony/ServiceState;)I

    move-result v13

    move/from16 v33, v4

    .line 3735
    iget-object v4, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-static {v4}, Lcom/android/internal/telephony/ServiceStateTracker;->getRilDataRadioTechnologyForWwan(Landroid/telephony/ServiceState;)I

    move-result v4

    move/from16 v34, v6

    .line 3736
    iget-object v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v6}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v6

    const/16 v0, 0xd

    if-nez v6, :cond_2c

    .line 3737
    invoke-static {v13}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v6

    if-eqz v6, :cond_2a

    if-eq v4, v0, :cond_2b

    :cond_2a
    if-ne v13, v0, :cond_2c

    .line 3740
    invoke-static {v4}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v6

    if-eqz v6, :cond_2c

    :cond_2b
    const/4 v6, 0x1

    goto :goto_23

    :cond_2c
    const/4 v6, 0x0

    .line 3742
    :goto_23
    invoke-static {v4}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v35

    if-nez v35, :cond_2d

    if-ne v4, v0, :cond_2e

    .line 3744
    :cond_2d
    invoke-static {v13}, Landroid/telephony/ServiceState;->isPsOnlyTech(I)Z

    move-result v35

    if-nez v35, :cond_2e

    if-eq v13, v0, :cond_2e

    const/4 v0, 0x1

    goto :goto_24

    :cond_2e
    const/4 v0, 0x0

    :goto_24
    const/4 v13, 0x4

    if-lt v4, v13, :cond_2f

    const/16 v13, 0x8

    if-gt v4, v13, :cond_2f

    const/4 v4, 0x1

    goto :goto_25

    :cond_2f
    const/4 v4, 0x0

    goto :goto_25

    :cond_30
    move/from16 v33, v4

    move/from16 v34, v6

    const/4 v0, 0x0

    const/4 v4, 0x0

    const/4 v6, 0x0

    .line 3752
    :goto_25
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    move/from16 v35, v4

    const-string v4, "pollStateDone: hasRegistered = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasDeregistered = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v5}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasDataAttached = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, " hasDataDetached = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, " hasDataRegStateChanged = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, " hasRilVoiceRadioTechnologyChanged = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasRilDataRadioTechnologyChanged = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, " hasDataTransportPreferenceChanged = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasChanged = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasVoiceRoamingOn = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v15}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasVoiceRoamingOff = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasDataRoamingOn ="

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasDataRoamingOff = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v4, v34

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasLocationChanged = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v4, v30

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " has4gHandoff = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasMultiApnSupport = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, " hasLostMultiApnSupport = "

    invoke-virtual {v13, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v4, v35

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v0, " hasCssIndicatorChanged = "

    invoke-virtual {v13, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v0, v32

    invoke-virtual {v13, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasNrFrequencyRangeChanged = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v4, v29

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasNrStateChanged = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v4, v28

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v4, " hasBandwidthChanged = "

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v4, v33

    invoke-virtual {v13, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move/from16 v32, v3

    const-string v3, " hasAirplaneModeOnlChanged = "

    invoke-virtual {v13, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v3, v26

    invoke-virtual {v13, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    move-object/from16 v13, p0

    invoke-virtual {v13, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    if-nez v27, :cond_32

    if-eqz v18, :cond_31

    goto :goto_26

    :cond_31
    move/from16 v18, v8

    move-object/from16 v26, v10

    move/from16 v20, v15

    const/4 v10, 0x3

    goto :goto_28

    .line 3779
    :cond_32
    :goto_26
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v3

    if-eqz v3, :cond_33

    const v3, 0xc3c2

    goto :goto_27

    :cond_33
    const v3, 0xc3c4

    :goto_27
    move/from16 v18, v8

    const/4 v8, 0x4

    new-array v8, v8, [Ljava/lang/Object;

    move/from16 v20, v15

    .line 3780
    iget-object v15, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3781
    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getState()I

    move-result v15

    invoke-static {v15}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v15

    const/16 v21, 0x0

    aput-object v15, v8, v21

    iget-object v15, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v15

    invoke-static {v15}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v15

    const/16 v19, 0x1

    aput-object v15, v8, v19

    iget-object v15, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 3782
    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getState()I

    move-result v15

    invoke-static {v15}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v15

    const/16 v23, 0x2

    aput-object v15, v8, v23

    iget-object v15, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v15

    invoke-static {v15}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v15

    move-object/from16 v26, v10

    const/4 v10, 0x3

    aput-object v15, v8, v10

    .line 3779
    invoke-static {v3, v8}, Landroid/util/EventLog;->writeEvent(I[Ljava/lang/Object;)I

    .line 3785
    :goto_28
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v3

    if-eqz v3, :cond_35

    move-object v3, v9

    if-eqz v7, :cond_34

    .line 3790
    invoke-static/range {v24 .. v24}, Lcom/android/internal/telephony/ServiceStateTracker;->getCidFromCellIdentity(Landroid/telephony/CellIdentity;)J

    move-result-wide v8

    new-array v10, v10, [Ljava/lang/Object;

    .line 3795
    invoke-static {v8, v9}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v16

    const/16 v21, 0x0

    aput-object v16, v10, v21

    iget-object v15, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3796
    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v15

    invoke-static {v15}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v15

    const/16 v19, 0x1

    aput-object v15, v10, v19

    iget-object v15, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 3797
    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v15

    invoke-static {v15}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v15

    const/16 v23, 0x2

    aput-object v15, v10, v23

    const v15, 0xc3cb

    .line 3795
    invoke-static {v15, v10}, Landroid/util/EventLog;->writeEvent(I[Ljava/lang/Object;)I

    .line 3799
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v15, "RAT switched "

    invoke-virtual {v10, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v15, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3801
    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v15

    .line 3800
    invoke-static {v15}, Landroid/telephony/ServiceState;->rilRadioTechnologyToString(I)Ljava/lang/String;

    move-result-object v15

    invoke-virtual {v10, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v15, " -> "

    invoke-virtual {v10, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v15, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 3804
    invoke-virtual {v15}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result v15

    .line 3803
    invoke-static {v15}, Landroid/telephony/ServiceState;->rilRadioTechnologyToString(I)Ljava/lang/String;

    move-result-object v15

    invoke-virtual {v10, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v15, " at cell "

    invoke-virtual {v10, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v8, v9}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    .line 3799
    invoke-virtual {v13, v8}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3808
    :cond_34
    iget v8, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewReasonDataDenied:I

    iput v8, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mReasonDataDenied:I

    .line 3809
    iget v8, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewMaxDataCalls:I

    iput v8, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mMaxDataCalls:I

    .line 3810
    iget v8, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewRejectCode:I

    iput v8, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mRejectCode:I

    goto :goto_29

    :cond_35
    move-object v3, v9

    .line 3813
    :goto_29
    iget-object v8, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    iget-object v9, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-static {v8, v9}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_36

    .line 3814
    iget-object v8, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mServiceStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v8}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 3817
    :cond_36
    new-instance v8, Landroid/telephony/ServiceState;

    iget-object v9, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v9}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v9

    invoke-direct {v8, v9}, Landroid/telephony/ServiceState;-><init>(Landroid/telephony/ServiceState;)V

    .line 3818
    new-instance v9, Landroid/telephony/ServiceState;

    iget-object v10, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-direct {v9, v10}, Landroid/telephony/ServiceState;-><init>(Landroid/telephony/ServiceState;)V

    iput-object v9, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3820
    iget-object v9, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget-object v10, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v10}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v10

    const/4 v15, 0x0

    invoke-virtual {v9, v10, v15}, Landroid/telephony/ServiceState;->setOutOfService(ZZ)V

    move-object/from16 v9, v24

    .line 3822
    iput-object v9, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    .line 3823
    iget-object v10, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v10}, Landroid/telephony/ServiceState;->getState()I

    move-result v10

    const/16 v15, 0x3f

    if-nez v10, :cond_37

    if-eqz v9, :cond_37

    .line 3824
    iget-object v9, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    iput-object v9, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownCellIdentity:Landroid/telephony/CellIdentity;

    .line 3825
    invoke-virtual {v13, v15}, Landroid/os/Handler;->removeMessages(I)V

    :cond_37
    if-eqz v5, :cond_38

    .line 3828
    invoke-virtual {v13, v15}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v9

    if-nez v9, :cond_38

    .line 3829
    sget-object v9, Ljava/util/concurrent/TimeUnit;->DAYS:Ljava/util/concurrent/TimeUnit;

    move v10, v2

    move-object/from16 v16, v3

    const-wide/16 v2, 0x1

    .line 3830
    invoke-virtual {v9, v2, v3}, Ljava/util/concurrent/TimeUnit;->toMillis(J)J

    move-result-wide v2

    .line 3829
    invoke-virtual {v13, v15, v2, v3}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    goto :goto_2a

    :cond_38
    move v10, v2

    move-object/from16 v16, v3

    .line 3833
    :goto_2a
    iget-object v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    invoke-static {v2}, Lcom/android/internal/telephony/ServiceStateTracker;->getAreaCodeFromCellIdentity(Landroid/telephony/CellIdentity;)I

    move-result v2

    .line 3834
    iget v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownAreaCode:I

    if-eq v2, v3, :cond_39

    const v3, 0x7fffffff

    if-eq v2, v3, :cond_39

    .line 3835
    iput v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownAreaCode:I

    .line 3836
    iget-object v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mAreaCodeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v2}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_39
    if-eqz v7, :cond_3a

    .line 3840
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updatePhoneObject()V

    .line 3843
    :cond_3a
    iget-object v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    const-string v3, "phone"

    invoke-virtual {v2, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/TelephonyManager;

    if-eqz v17, :cond_3b

    .line 3846
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    iget-object v9, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v9}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v9

    invoke-virtual {v2, v3, v9}, Landroid/telephony/TelephonyManager;->setDataNetworkTypeForPhone(II)V

    const/16 v3, 0x4c

    .line 3847
    iget-object v9, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3849
    invoke-virtual {v9}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v9

    .line 3848
    invoke-static {v9}, Landroid/telephony/ServiceState;->rilRadioTechnologyToNetworkType(I)I

    move-result v9

    iget-object v15, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 3849
    invoke-virtual {v15}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v15

    .line 3847
    invoke-static {v3, v9, v15}, Lcom/android/internal/telephony/TelephonyStatsLog;->write(III)V

    :cond_3b
    if-eqz v1, :cond_3c

    .line 3853
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNetworkAttachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v3}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 3854
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {v3}, Lcom/android/internal/telephony/NitzStateMachine;->handleNetworkAvailable()V

    :cond_3c
    if-eqz v5, :cond_3d

    .line 3858
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNetworkDetachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v3}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 3859
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {v3}, Lcom/android/internal/telephony/NitzStateMachine;->handleNetworkUnavailable()V

    :cond_3d
    if-eqz v0, :cond_3e

    .line 3863
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mCssIndicatorChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_3e
    if-eqz v4, :cond_3f

    .line 3867
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_3f
    if-eqz v31, :cond_40

    const/16 v0, 0x7d1

    .line 3871
    invoke-virtual {v13, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->setNotification(I)V

    .line 3874
    :cond_40
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getCdmaEriText()Ljava/lang/String;

    move-result-object v0

    .line 3875
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mEriText:Ljava/lang/String;

    invoke-static {v3, v0}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v3

    const/4 v4, 0x1

    xor-int/2addr v3, v4

    .line 3876
    iput-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mEriText:Ljava/lang/String;

    if-nez v14, :cond_41

    .line 3880
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_42

    if-eqz v3, :cond_42

    .line 3881
    :cond_41
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateSpnDisplay()V

    :cond_42
    if-eqz v14, :cond_4d

    .line 3885
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getOperatorAlpha()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v0, v3}, Landroid/telephony/TelephonyManager;->setNetworkOperatorNameForPhone(ILjava/lang/String;)V

    .line 3886
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v0

    .line 3888
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v3

    if-nez v3, :cond_43

    .line 3890
    invoke-virtual {v13, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isInvalidOperatorNumeric(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_43

    .line 3891
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getCdmaSystemId()I

    move-result v3

    .line 3892
    invoke-virtual {v13, v0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->fixUnknownMcc(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v0

    .line 3896
    :cond_43
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v3

    invoke-virtual {v2, v3, v0}, Landroid/telephony/TelephonyManager;->setNetworkOperatorNumericForPhone(ILjava/lang/String;)V

    .line 3905
    invoke-virtual {v13, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isInvalidOperatorNumeric(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_44

    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3906
    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getDataNetworkType()I

    move-result v3

    const/16 v4, 0x12

    if-ne v3, v4, :cond_46

    .line 3907
    :cond_44
    invoke-interface/range {v22 .. v22}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_45
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_46

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/telephony/CellIdentity;

    .line 3908
    invoke-virtual {v4}, Landroid/telephony/CellIdentity;->getPlmn()Ljava/lang/String;

    move-result-object v9

    invoke-static {v9}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v9

    if-nez v9, :cond_45

    .line 3909
    invoke-virtual {v4}, Landroid/telephony/CellIdentity;->getPlmn()Ljava/lang/String;

    move-result-object v0

    .line 3915
    :cond_46
    invoke-virtual {v13, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->isInvalidOperatorNumeric(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_47

    .line 3916
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "localeOperator "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " is invalid"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v13, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3920
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mLocaleTracker:Lcom/android/internal/telephony/LocaleTracker;

    const-string v3, ""

    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/LocaleTracker;->updateOperatorNumeric(Ljava/lang/String;)V

    goto :goto_2b

    .line 3922
    :cond_47
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v3

    if-nez v3, :cond_48

    .line 3923
    invoke-virtual {v13, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->setOperatorIdd(Ljava/lang/String;)V

    .line 3925
    :cond_48
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mLocaleTracker:Lcom/android/internal/telephony/LocaleTracker;

    invoke-virtual {v3, v0}, Lcom/android/internal/telephony/LocaleTracker;->updateOperatorNumeric(Ljava/lang/String;)V

    .line 3928
    :goto_2b
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v0

    .line 3929
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v3

    if-eqz v3, :cond_49

    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v3

    goto :goto_2d

    .line 3930
    :cond_49
    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v3

    if-nez v3, :cond_4b

    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v3

    if-eqz v3, :cond_4a

    goto :goto_2c

    :cond_4a
    const/4 v3, 0x0

    goto :goto_2d

    :cond_4b
    :goto_2c
    const/4 v3, 0x1

    .line 3928
    :goto_2d
    invoke-virtual {v2, v0, v3}, Landroid/telephony/TelephonyManager;->setNetworkRoamingForPhone(IZ)V

    .line 3932
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v13, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->setRoamingType(Landroid/telephony/ServiceState;)V

    .line 3933
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Broadcasting ServiceState : "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v13, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3936
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v8, v0}, Landroid/telephony/ServiceState;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_4c

    .line 3937
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifyServiceStateChanged(Landroid/telephony/ServiceState;)V

    .line 3941
    :cond_4c
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    iget-object v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 3942
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-static {v2}, Landroid/provider/Telephony$ServiceStateTable;->getUriForSubscriptionId(I)Landroid/net/Uri;

    move-result-object v2

    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3943
    invoke-virtual {v13, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->getContentValuesForServiceState(Landroid/telephony/ServiceState;)Landroid/content/ContentValues;

    move-result-object v3

    .line 3942
    invoke-virtual {v0, v2, v3}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;

    .line 3945
    invoke-static {}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->getInstance()Lcom/android/internal/telephony/metrics/TelephonyMetrics;

    move-result-object v0

    iget-object v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v2

    iget-object v3, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v2, v3}, Lcom/android/internal/telephony/metrics/TelephonyMetrics;->writeServiceStateChanged(ILandroid/telephony/ServiceState;)V

    .line 3946
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getVoiceCallSessionStats()Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;

    move-result-object v0

    iget-object v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/metrics/VoiceCallSessionStats;->onServiceStateChanged(Landroid/telephony/ServiceState;)V

    .line 3947
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mServiceStateStats:Lcom/android/internal/telephony/metrics/ServiceStateStats;

    iget-object v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->onServiceStateChanged(Landroid/telephony/ServiceState;)V

    :cond_4d
    if-nez v1, :cond_4f

    if-eqz v5, :cond_4e

    goto :goto_2e

    :cond_4e
    const/4 v8, 0x0

    goto :goto_2f

    :cond_4f
    :goto_2e
    const/4 v8, 0x1

    :goto_2f
    if-eqz v6, :cond_50

    .line 3958
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/RegistrantList;

    .line 3959
    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    const/4 v15, 0x1

    goto :goto_30

    :cond_50
    move v15, v8

    :goto_30
    if-eqz v7, :cond_51

    .line 3967
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/SignalStrengthController;->notifySignalStrength()Z

    const/4 v8, 0x1

    goto :goto_31

    :cond_51
    const/4 v8, 0x0

    .line 3970
    :goto_31
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v0

    array-length v1, v0

    move v2, v8

    const/4 v8, 0x0

    :goto_32
    if-ge v8, v1, :cond_59

    aget v3, v0, v8

    .line 3971
    invoke-virtual {v11, v3}, Landroid/util/SparseBooleanArray;->get(I)Z

    move-result v4

    if-eqz v4, :cond_52

    .line 3973
    iget-object v2, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object v2

    invoke-virtual {v2}, Lcom/android/internal/telephony/SignalStrengthController;->notifySignalStrength()Z

    const/4 v2, 0x1

    .line 3976
    :cond_52
    invoke-virtual {v12, v3}, Landroid/util/SparseBooleanArray;->get(I)Z

    move-result v4

    if-nez v4, :cond_53

    .line 3977
    invoke-virtual {v11, v3}, Landroid/util/SparseBooleanArray;->get(I)Z

    move-result v4

    if-nez v4, :cond_53

    if-eqz v10, :cond_54

    .line 3981
    :cond_53
    iget-object v4, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v4}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v4

    invoke-virtual {v13, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->setDataNetworkTypeForPhone(I)V

    .line 3982
    invoke-virtual {v13, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->notifyDataRegStateRilRadioTechnologyChanged(I)V

    :cond_54
    move-object/from16 v4, v16

    .line 3985
    invoke-virtual {v4, v3}, Landroid/util/SparseBooleanArray;->get(I)Z

    move-result v5

    if-eqz v5, :cond_56

    .line 3987
    iget-object v5, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v5

    if-eqz v5, :cond_55

    .line 3988
    iget-object v5, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {v5, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v5}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_55
    move-object/from16 v5, v26

    const/4 v15, 0x1

    goto :goto_33

    :cond_56
    move-object/from16 v5, v26

    .line 3991
    :goto_33
    invoke-virtual {v5, v3}, Landroid/util/SparseBooleanArray;->get(I)Z

    move-result v6

    if-eqz v6, :cond_58

    .line 3993
    iget-object v6, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {v6, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v6

    if-eqz v6, :cond_57

    .line 3994
    iget-object v6, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {v6, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v3}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_57
    const/4 v15, 0x1

    :cond_58
    add-int/lit8 v8, v8, 0x1

    move-object/from16 v16, v4

    move-object/from16 v26, v5

    goto :goto_32

    :cond_59
    if-eqz v25, :cond_5a

    .line 4005
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/SignalStrengthController;->getSignalStrengthFromCi()V

    :cond_5a
    if-eqz v15, :cond_5b

    .line 4009
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->logAttachChange()V

    :cond_5b
    if-eqz v2, :cond_5c

    .line 4012
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->logRatChange()V

    :cond_5c
    if-nez v27, :cond_5d

    if-eqz v7, :cond_5e

    .line 4016
    :cond_5d
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->notifyVoiceRegStateRilRadioTechnologyChanged()V

    :cond_5e
    if-nez v20, :cond_5f

    if-nez v18, :cond_5f

    if-nez v32, :cond_5f

    if-eqz v34, :cond_60

    .line 4020
    :cond_5f
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->logRoamingChange()V

    :cond_60
    if-eqz v20, :cond_61

    .line 4024
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_61
    if-eqz v18, :cond_62

    .line 4028
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_62
    if-eqz v32, :cond_63

    .line 4032
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_63
    if-eqz v34, :cond_64

    .line 4036
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_64
    if-eqz v30, :cond_65

    .line 4040
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->notifyLocationChanged(Landroid/telephony/CellIdentity;)V

    :cond_65
    if-eqz v28, :cond_66

    .line 4044
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNrStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_66
    if-eqz v29, :cond_67

    .line 4048
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mNrFrequencyChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 4051
    :cond_67
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-eqz v0, :cond_69

    .line 4052
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v0

    iget-object v1, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getState()I

    move-result v1

    invoke-virtual {v13, v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->isGprsConsistent(II)Z

    move-result v0

    if-nez v0, :cond_68

    .line 4053
    iget-boolean v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mStartedGprsRegCheck:Z

    if-nez v0, :cond_69

    iget-boolean v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mReportedGprsNoReg:Z

    if-nez v0, :cond_69

    const/4 v0, 0x1

    .line 4054
    iput-boolean v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mStartedGprsRegCheck:Z

    .line 4056
    iget-object v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 4057
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const v1, 0xea60

    const-string v2, "gprs_register_check_period_ms"

    .line 4056
    invoke-static {v0, v2, v1}, Landroid/provider/Settings$Global;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result v0

    const/16 v1, 0x16

    .line 4060
    invoke-virtual {v13, v1}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    int-to-long v2, v0

    invoke-virtual {v13, v1, v2, v3}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    goto :goto_34

    :cond_68
    const/4 v0, 0x0

    .line 4064
    iput-boolean v0, v13, Lcom/android/internal/telephony/ServiceStateTracker;->mReportedGprsNoReg:Z

    :cond_69
    :goto_34
    return-void
.end method

.method protected pollStateInternal(Z)V
    .locals 7

    const/4 v0, 0x1

    new-array v1, v0, [I

    .line 3462
    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    .line 3465
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "pollState: modemTriggered="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", radioState="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v2}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3467
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v1}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v4, 0x2

    if-eqz v1, :cond_2

    if-eq v1, v4, :cond_0

    goto :goto_0

    .line 3471
    :cond_0
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p1, v4, v4}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p1

    .line 3474
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v1

    invoke-virtual {v0, v1, v3}, Landroid/telephony/ServiceState;->setOutOfService(ZZ)V

    if-eqz p1, :cond_1

    .line 3477
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, p1}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    .line 3479
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object p1

    invoke-virtual {p1}, Lcom/android/internal/telephony/SignalStrengthController;->setSignalStrengthDefaultValues()V

    .line 3480
    iput-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastNitzData:Lcom/android/internal/telephony/NitzData;

    .line 3481
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {p1}, Lcom/android/internal/telephony/NitzStateMachine;->handleNetworkUnavailable()V

    .line 3482
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateDone()V

    goto/16 :goto_2

    .line 3488
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1, v4, v4}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v1

    .line 3491
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v6}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v6

    invoke-virtual {v5, v6, v0}, Landroid/telephony/ServiceState;->setOutOfService(ZZ)V

    if-eqz v1, :cond_3

    .line 3494
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v5, v1}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    .line 3496
    :cond_3
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/SignalStrengthController;->setSignalStrengthDefaultValues()V

    .line 3497
    iput-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastNitzData:Lcom/android/internal/telephony/NitzData;

    .line 3498
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {v1}, Lcom/android/internal/telephony/NitzStateMachine;->handleNetworkUnavailable()V

    .line 3501
    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    if-nez v1, :cond_6

    if-nez p1, :cond_4

    const/16 p1, 0x12

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 3503
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v1

    if-eq p1, v1, :cond_4

    goto/16 :goto_1

    .line 3511
    :cond_4
    :goto_0
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    aget v1, p1, v3

    add-int/2addr v1, v0

    aput v1, p1, v3

    .line 3512
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v2, 0x7

    invoke-virtual {p0, v2, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-interface {v1, p1}, Lcom/android/internal/telephony/CommandsInterface;->getOperator(Landroid/os/Message;)V

    .line 3514
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    aget v1, p1, v3

    add-int/2addr v1, v0

    aput v1, p1, v3

    .line 3515
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegStateManagers:Landroid/util/SparseArray;

    invoke-virtual {p1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/NetworkRegistrationManager;

    const/4 v1, 0x5

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    .line 3517
    invoke-virtual {p0, v1, v2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v1

    .line 3516
    invoke-virtual {p1, v4, v1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->requestNetworkRegistrationInfo(ILandroid/os/Message;)V

    .line 3520
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    aget v1, p1, v3

    add-int/2addr v1, v0

    aput v1, p1, v3

    .line 3521
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegStateManagers:Landroid/util/SparseArray;

    invoke-virtual {p1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/NetworkRegistrationManager;

    const/4 v1, 0x4

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    .line 3523
    invoke-virtual {p0, v1, v2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v1

    .line 3522
    invoke-virtual {p1, v0, v1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->requestNetworkRegistrationInfo(ILandroid/os/Message;)V

    .line 3525
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegStateManagers:Landroid/util/SparseArray;

    invoke-virtual {p1, v4}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    if-eqz p1, :cond_5

    .line 3526
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    aget v1, p1, v3

    add-int/2addr v1, v0

    aput v1, p1, v3

    .line 3527
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRegStateManagers:Landroid/util/SparseArray;

    invoke-virtual {p1, v4}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/android/internal/telephony/NetworkRegistrationManager;

    const/4 v1, 0x6

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    .line 3529
    invoke-virtual {p0, v1, v2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v1

    .line 3528
    invoke-virtual {p1, v4, v1}, Lcom/android/internal/telephony/NetworkRegistrationManager;->requestNetworkRegistrationInfo(ILandroid/os/Message;)V

    .line 3533
    :cond_5
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result p1

    if-eqz p1, :cond_7

    .line 3534
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPollingContext:[I

    aget v1, p1, v3

    add-int/2addr v1, v0

    aput v1, p1, v3

    .line 3535
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0xe

    invoke-virtual {p0, v1, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->getNetworkSelectionMode(Landroid/os/Message;)V

    goto :goto_2

    .line 3504
    :cond_6
    :goto_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->pollStateDone()V

    :cond_7
    :goto_2
    return-void
.end method

.method public powerOffRadioSafely()V
    .locals 10

    .line 5161
    monitor-enter p0

    .line 5162
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    if-nez v0, :cond_b

    .line 5163
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    const/16 v1, 0x26

    const/16 v2, 0x31

    const/4 v3, 0x1

    if-eqz v0, :cond_1

    .line 5164
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAnyDataExisting:Z

    if-eqz v0, :cond_0

    .line 5166
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->mtkHangupAllCalls()V

    const-string v0, "powerOffRadioSafely: Tear down all data networks."

    .line 5168
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5169
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object v0

    const/4 v2, 0x3

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/data/DataNetworkController;->tearDownAllDataNetworks(I)V

    .line 5171
    sget-wide v4, Lcom/android/internal/telephony/ServiceStateTracker;->POWER_OFF_ALL_DATA_NETWORKS_DISCONNECTED_TIMEOUT:J

    invoke-virtual {p0, v1, v4, v5}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    goto :goto_0

    :cond_0
    const-string v0, "powerOffRadioSafely: No data is connected."

    .line 5174
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5175
    invoke-virtual {p0, v2}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    .line 5177
    :goto_0
    iput-boolean v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    .line 5178
    monitor-exit p0

    return-void

    .line 5180
    :cond_1
    invoke-static {}, Landroid/telephony/SubscriptionManager;->getDefaultDataSubscriptionId()I

    move-result v0

    .line 5183
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->areAllDataDisconnected()Z

    move-result v4

    const/4 v5, 0x0

    if-eqz v4, :cond_5

    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 5184
    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v4

    if-eq v0, v4, :cond_2

    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 5185
    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v4

    if-eq v0, v4, :cond_5

    .line 5186
    invoke-static {}, Lcom/android/internal/telephony/ProxyController;->getInstance()Lcom/android/internal/telephony/ProxyController;

    move-result-object v4

    invoke-virtual {v4, v0}, Lcom/android/internal/telephony/ProxyController;->areAllDataDisconnected(I)Z

    move-result v4

    if-eqz v4, :cond_5

    .line 5188
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v0

    array-length v1, v0

    :goto_1
    if-ge v5, v1, :cond_4

    aget v2, v0, v5

    .line 5189
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3, v2}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v3

    if-eqz v3, :cond_3

    .line 5190
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3, v2}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v2

    const-string v3, "radioTurnedOff"

    invoke-virtual {v2, v3}, Lcom/android/internal/telephony/dataconnection/DcTracker;->cleanUpAllConnections(Ljava/lang/String;)V

    :cond_3
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    :cond_4
    const-string v0, "powerOffRadioSafely: Data disconnected, turn off radio now."

    .line 5195
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5197
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->hangupAndPowerOff()V

    goto/16 :goto_3

    .line 5200
    :cond_5
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v4

    if-eqz v4, :cond_6

    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/GsmCdmaPhone;->isInCall()Z

    move-result v4

    if-eqz v4, :cond_6

    .line 5201
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget-object v4, v4, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v4, v4, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mRingingCall:Lcom/android/internal/telephony/GsmCdmaCall;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Call;->hangupIfAlive()V

    .line 5202
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget-object v4, v4, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v4, v4, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mBackgroundCall:Lcom/android/internal/telephony/GsmCdmaCall;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Call;->hangupIfAlive()V

    .line 5203
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget-object v4, v4, Lcom/android/internal/telephony/GsmCdmaPhone;->mCT:Lcom/android/internal/telephony/GsmCdmaCallTracker;

    iget-object v4, v4, Lcom/android/internal/telephony/GsmCdmaCallTracker;->mForegroundCall:Lcom/android/internal/telephony/GsmCdmaCall;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Call;->hangupIfAlive()V

    .line 5206
    :cond_6
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->mtkHangupAllImsCall()V

    .line 5208
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v4}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v4

    array-length v6, v4

    move v7, v5

    :goto_2
    if-ge v7, v6, :cond_8

    aget v8, v4, v7

    .line 5209
    iget-object v9, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v9, v8}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v9

    if-eqz v9, :cond_7

    .line 5210
    iget-object v9, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v9, v8}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v8

    const-string v9, "radioTurnedOff"

    invoke-virtual {v8, v9}, Lcom/android/internal/telephony/dataconnection/DcTracker;->cleanUpAllConnections(Ljava/lang/String;)V

    :cond_7
    add-int/lit8 v7, v7, 0x1

    goto :goto_2

    .line 5215
    :cond_8
    iget-object v4, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v4

    if-eq v0, v4, :cond_9

    .line 5216
    invoke-static {}, Lcom/android/internal/telephony/ProxyController;->getInstance()Lcom/android/internal/telephony/ProxyController;

    move-result-object v4

    invoke-virtual {v4, v0}, Lcom/android/internal/telephony/ProxyController;->areAllDataDisconnected(I)Z

    move-result v4

    if-nez v4, :cond_9

    const-string v4, "powerOffRadioSafely: Data is active on DDS (%d). Wait for all data disconnect"

    new-array v6, v3, [Ljava/lang/Object;

    .line 5219
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    aput-object v7, v6, v5

    .line 5218
    invoke-static {v4, v6}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5223
    invoke-static {}, Lcom/android/internal/telephony/ProxyController;->getInstance()Lcom/android/internal/telephony/ProxyController;

    move-result-object v4

    invoke-virtual {v4, v0, p0, v2}, Lcom/android/internal/telephony/ProxyController;->registerForAllDataDisconnected(ILandroid/os/Handler;I)V

    .line 5225
    iput-boolean v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    .line 5227
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->mtkPowerOffNonDdsPhone()Z

    move-result v0

    if-eqz v0, :cond_9

    .line 5228
    monitor-exit p0

    return-void

    .line 5232
    :cond_9
    invoke-static {p0}, Landroid/os/Message;->obtain(Landroid/os/Handler;)Landroid/os/Message;

    move-result-object v0

    .line 5233
    iput v1, v0, Landroid/os/Message;->what:I

    .line 5234
    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    add-int/2addr v1, v3

    iput v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    iput v1, v0, Landroid/os/Message;->arg1:I

    const-wide/16 v1, 0x7530

    .line 5235
    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    move-result v0

    if-eqz v0, :cond_a

    const-string v0, "powerOffRadioSafely: Wait up to 30s for data to isconnect, then turn off radio."

    .line 5237
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5240
    iput-boolean v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    goto :goto_3

    :cond_a
    const-string v0, "powerOffRadioSafely: Cannot send delayed Msg, turn off radio right away."

    .line 5242
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5244
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->hangupAndPowerOff()V

    .line 5245
    iput-boolean v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    .line 5249
    :cond_b
    :goto_3
    monitor-exit p0

    return-void

    :catchall_0
    move-exception v0

    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method protected processIwlanRegistrationInfo()V
    .locals 9

    .line 5786
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v0

    const/16 v1, 0x12

    const/4 v2, 0x2

    const/4 v3, 0x1

    if-nez v0, :cond_3

    const-string v0, "set service state as POWER_OFF"

    .line 5788
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5789
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 5790
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRilDataRadioTechnology()I

    move-result v0

    const-string v4, "pollStateDone: mNewSS = "

    const/4 v5, 0x0

    if-ne v1, v0, :cond_0

    .line 5791
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    const-string v0, "pollStateDone: reset iwlan RAT value"

    .line 5792
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    move v0, v3

    goto :goto_0

    :cond_0
    move v0, v5

    .line 5796
    :goto_0
    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v6}, Landroid/telephony/ServiceState;->getOperatorAlphaLong()Ljava/lang/String;

    move-result-object v6

    .line 5797
    iget-object v7, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    iget-object v8, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v8}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v8

    invoke-virtual {v7, v8, v3}, Landroid/telephony/ServiceState;->setOutOfService(ZZ)V

    if-eqz v0, :cond_2

    .line 5799
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v5}, Landroid/telephony/ServiceState;->setDataRegState(I)V

    .line 5800
    new-instance v0, Landroid/telephony/NetworkRegistrationInfo$Builder;

    invoke-direct {v0}, Landroid/telephony/NetworkRegistrationInfo$Builder;-><init>()V

    .line 5801
    invoke-virtual {v0, v2}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setTransportType(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v0

    .line 5802
    invoke-virtual {v0, v2}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setDomain(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v0

    .line 5803
    invoke-virtual {v0, v1}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setAccessNetworkTechnology(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v0

    .line 5804
    invoke-virtual {v0, v3}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setRegistrationState(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v0

    .line 5805
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo$Builder;->build()Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v0

    .line 5806
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v5, v0}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    .line 5807
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 5810
    new-instance v0, Landroid/telephony/NetworkRegistrationInfo$Builder;

    invoke-direct {v0}, Landroid/telephony/NetworkRegistrationInfo$Builder;-><init>()V

    .line 5811
    invoke-virtual {v0, v3}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setTransportType(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v0

    .line 5812
    invoke-virtual {v0, v2}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setDomain(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v0

    .line 5813
    invoke-virtual {v0, v1}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setAccessNetworkTechnology(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v0

    .line 5814
    invoke-virtual {v0, v3}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setRegistrationState(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v0

    .line 5815
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo$Builder;->build()Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v0

    .line 5816
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1, v0}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    .line 5818
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v6}, Landroid/telephony/ServiceState;->setOperatorAlphaLong(Ljava/lang/String;)V

    .line 5822
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v3}, Landroid/telephony/ServiceState;->setIwlanPreferred(Z)V

    .line 5823
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    :cond_2
    return-void

    .line 5835
    :cond_3
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v0

    if-eqz v0, :cond_4

    .line 5836
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0, v2, v3}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 5838
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v3

    if-ne v3, v1, :cond_4

    .line 5840
    new-instance v3, Landroid/telephony/NetworkRegistrationInfo$Builder;

    invoke-direct {v3}, Landroid/telephony/NetworkRegistrationInfo$Builder;-><init>()V

    .line 5841
    invoke-virtual {v3, v2}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setTransportType(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v3

    .line 5842
    invoke-virtual {v3, v2}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setDomain(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v2

    .line 5843
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getRegistrationState()I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setRegistrationState(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v2

    .line 5844
    invoke-virtual {v2, v1}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setAccessNetworkTechnology(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v1

    .line 5845
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getRejectCause()I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setRejectCause(I)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v1

    .line 5846
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->isEmergencyEnabled()Z

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setEmergencyOnly(Z)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v1

    .line 5847
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo;->getAvailableServices()Ljava/util/List;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/telephony/NetworkRegistrationInfo$Builder;->setAvailableServices(Ljava/util/List;)Landroid/telephony/NetworkRegistrationInfo$Builder;

    move-result-object v0

    .line 5848
    invoke-virtual {v0}, Landroid/telephony/NetworkRegistrationInfo$Builder;->build()Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v0

    .line 5849
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, v0}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    :cond_4
    return-void
.end method

.method public processPendingRadioPowerOffAfterDataOff()Z
    .locals 3

    .line 5258
    monitor-enter p0

    .line 5259
    :try_start_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    const-string v0, "Process pending request to turn radio off."

    .line 5260
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5261
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->hangupAndPowerOff()V

    .line 5262
    iget v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    const/4 v2, 0x1

    add-int/2addr v0, v2

    iput v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOffTag:I

    .line 5263
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingRadioPowerOffAfterDataOff:Z

    .line 5264
    monitor-exit p0

    return v2

    .line 5266
    :cond_0
    monitor-exit p0

    return v1

    :catchall_0
    move-exception v0

    .line 5267
    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public reRegisterNetwork(Landroid/os/Message;)V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 1110
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v1, 0x13

    .line 1111
    invoke-virtual {p0, v1, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p0

    .line 1110
    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->getAllowedNetworkTypesBitmap(Landroid/os/Message;)V

    return-void
.end method

.method protected regCodeIsRoaming(I)Z
    .locals 0

    const/4 p0, 0x5

    if-ne p0, p1, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method protected regCodeToServiceState(I)I
    .locals 1

    const/4 p0, 0x1

    if-eq p1, p0, :cond_0

    const/4 v0, 0x5

    if-eq p1, v0, :cond_0

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public registerForAirplaneModeChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    .line 5029
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAirplaneModeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/RegistrantList;->add(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public registerForAreaCodeChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 0

    .line 6204
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAreaCodeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public registerForBandwidthChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 6121
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 6122
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    return-void
.end method

.method public registerForCssIndicatorChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 6102
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 6103
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCssIndicatorChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    return-void
.end method

.method public registerForDataConnectionAttached(ILandroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 4903
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p2, p3, p4}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 4904
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    if-nez p2, :cond_0

    .line 4905
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    new-instance p3, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {p3}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    invoke-virtual {p2, p1, p3}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 4907
    :cond_0
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 4909
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    if-eqz p0, :cond_2

    const/4 p2, 0x2

    .line 4910
    invoke-virtual {p0, p2, p1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 4912
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result p0

    if-eqz p0, :cond_2

    .line 4913
    :cond_1
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_2
    return-void
.end method

.method public registerForDataConnectionDetached(ILandroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 4939
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p2, p3, p4}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 4940
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    if-nez p2, :cond_0

    .line 4941
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    new-instance p3, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {p3}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    invoke-virtual {p2, p1, p3}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 4943
    :cond_0
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 4945
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    if-eqz p0, :cond_1

    const/4 p2, 0x2

    .line 4946
    invoke-virtual {p0, p2, p1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 4948
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result p0

    if-nez p0, :cond_1

    .line 4949
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_1
    return-void
.end method

.method public registerForDataRegStateOrRatChanged(ILandroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 4997
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p2, p3, p4}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 4998
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRegStateOrRatChangedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    if-nez p2, :cond_0

    .line 4999
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRegStateOrRatChangedRegistrants:Landroid/util/SparseArray;

    new-instance p3, Lcom/android/internal/telephony/RegistrantList;

    invoke-direct {p3}, Lcom/android/internal/telephony/RegistrantList;-><init>()V

    invoke-virtual {p2, p1, p3}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 5001
    :cond_0
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRegStateOrRatChangedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p2, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 5002
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->getRegistrationInfo(I)Landroid/util/Pair;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 5004
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/Registrant;->notifyResult(Ljava/lang/Object;)V

    :cond_1
    return-void
.end method

.method public registerForDataRoamingOff(Landroid/os/Handler;ILjava/lang/Object;Z)V
    .locals 1

    .line 1087
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 1088
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    if-eqz p4, :cond_0

    .line 1090
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result p0

    if-nez p0, :cond_0

    .line 1091
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public registerForDataRoamingOn(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 1065
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 1066
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 1068
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result p0

    if-eqz p0, :cond_0

    .line 1069
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public registerForImsCapabilityChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 5124
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 5125
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsCapabilityChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    return-void
.end method

.method public registerForNetworkAttached(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 5048
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 5050
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNetworkAttachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 5051
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getState()I

    move-result p0

    if-nez p0, :cond_0

    .line 5052
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public registerForNetworkDetached(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 5067
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 5069
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNetworkDetachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 5070
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getState()I

    move-result p0

    if-eqz p0, :cond_0

    .line 5071
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public registerForNrFrequencyChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 6083
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 6084
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNrFrequencyChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    return-void
.end method

.method public registerForNrStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 6064
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 6065
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNrStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    return-void
.end method

.method public registerForPsRestrictedDisabled(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 5105
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 5106
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPsRestrictDisabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 5108
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RestrictedState;->isPsRestricted()Z

    move-result p0

    if-eqz p0, :cond_0

    .line 5109
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public registerForPsRestrictedEnabled(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 5086
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 5087
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPsRestrictEnabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 5089
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRestrictedState:Lcom/android/internal/telephony/RestrictedState;

    invoke-virtual {p0}, Lcom/android/internal/telephony/RestrictedState;->isPsRestricted()Z

    move-result p0

    if-eqz p0, :cond_0

    .line 5090
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public registerForServiceStateChanged(Landroid/os/Handler;I)V
    .locals 1

    .line 5143
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mServiceStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    const/4 v0, 0x0

    invoke-virtual {p0, p1, p2, v0}, Lcom/android/internal/telephony/RegistrantList;->addUnique(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public registerForSubscriptionInfoReady(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 5420
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 5421
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaForSubscriptionInfoReadyRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 5423
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->isMinInfoReady()Z

    move-result p0

    if-eqz p0, :cond_0

    .line 5424
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public registerForVoiceRegStateOrRatChanged(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 4976
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 4977
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRegStateOrRatChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 4978
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->notifyVoiceRegStateRilRadioTechnologyChanged()V

    return-void
.end method

.method public registerForVoiceRoamingOff(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 1044
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 1045
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 1047
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result p0

    if-nez p0, :cond_0

    .line 1048
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public registerForVoiceRoamingOn(Landroid/os/Handler;ILjava/lang/Object;)V
    .locals 1

    .line 1023
    new-instance v0, Lcom/android/internal/telephony/Registrant;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/Registrant;-><init>(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 1024
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/RegistrantList;->add(Lcom/android/internal/telephony/Registrant;)V

    .line 1026
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result p0

    if-eqz p0, :cond_0

    .line 1027
    invoke-virtual {v0}, Lcom/android/internal/telephony/Registrant;->notifyRegistrant()V

    :cond_0
    return-void
.end method

.method public requestAllCellInfo(Landroid/os/WorkSource;Landroid/os/Message;)V
    .locals 7

    .line 5372
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0}, Lcom/android/internal/telephony/CommandsInterface;->getRilVersion()I

    move-result v0

    const/16 v1, 0x8

    if-ge v0, v1, :cond_0

    .line 5373
    invoke-static {p2}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;)Landroid/os/AsyncResult;

    .line 5374
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    const-string p1, "SST.requestAllCellInfo(): not implemented"

    .line 5375
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    .line 5378
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingCellInfoRequests:Ljava/util/List;

    monitor-enter v0

    .line 5381
    :try_start_0
    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsPendingCellInfoRequest:Z

    if-eqz v1, :cond_2

    if-eqz p2, :cond_1

    .line 5382
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingCellInfoRequests:Ljava/util/List;

    invoke-interface {p0, p2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 5383
    :cond_1
    monitor-exit v0

    return-void

    .line 5387
    :cond_2
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v1

    .line 5388
    iget-wide v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoReqTime:J

    sub-long v3, v1, v3

    iget v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellInfoMinIntervalMs:I

    int-to-long v5, v5

    cmp-long v3, v3, v5

    if-gez v3, :cond_4

    if-eqz p2, :cond_3

    const-string p1, "SST.requestAllCellInfo(): return last, back to back calls"

    .line 5390
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 5391
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoList:Ljava/util/List;

    const/4 p1, 0x0

    invoke-static {p2, p0, p1}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 5392
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    .line 5394
    :cond_3
    monitor-exit v0

    return-void

    :cond_4
    if-eqz p2, :cond_5

    .line 5398
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPendingCellInfoRequests:Ljava/util/List;

    invoke-interface {v3, p2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 5400
    :cond_5
    iput-wide v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoReqTime:J

    const/4 p2, 0x1

    .line 5402
    iput-boolean p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsPendingCellInfoRequest:Z

    const/16 p2, 0x2b

    .line 5404
    invoke-virtual {p0, p2}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v1

    .line 5405
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v2, v1, p1}, Lcom/android/internal/telephony/CommandsInterface;->getCellInfoList(Landroid/os/Message;Landroid/os/WorkSource;)V

    .line 5409
    invoke-virtual {p0, p2}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object p1

    const-wide/16 v1, 0x7d0

    .line 5408
    invoke-virtual {p0, p1, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    .line 5410
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method public requestCellIdentity(Landroid/os/WorkSource;Landroid/os/Message;)V
    .locals 1

    .line 4579
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    .line 4580
    invoke-static {p2, v0, p0}, Landroid/os/AsyncResult;->forMessage(Landroid/os/Message;Ljava/lang/Object;Ljava/lang/Throwable;)Landroid/os/AsyncResult;

    .line 4581
    invoke-virtual {p2}, Landroid/os/Message;->sendToTarget()V

    return-void

    :cond_0
    const/16 v0, 0x38

    .line 4585
    invoke-virtual {p0, v0, p2}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p2

    .line 4586
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->requestAllCellInfo(Landroid/os/WorkSource;Landroid/os/Message;)V

    return-void
.end method

.method public requestShutdown()V
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 891
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    return-void

    .line 892
    :cond_0
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    const/4 v0, 0x0

    .line 893
    iput-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDesiredPowerState:Z

    .line 894
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->setPowerStateToDesired()V

    return-void
.end method

.method public setCellInfoMinInterval(I)V
    .locals 0

    .line 5356
    iput p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellInfoMinIntervalMs:I

    return-void
.end method

.method protected setDataNetworkTypeForPhone(I)V
    .locals 2

    .line 6158
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getUnitTestMode()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 6161
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "phone"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    .line 6163
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0, p1}, Landroid/telephony/TelephonyManager;->setDataNetworkTypeForPhone(II)V

    return-void
.end method

.method public setImsRegistrationState(Z)V
    .locals 2

    .line 3419
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setImsRegistrationState: {registered="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " mImsRegistrationOnOff="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistrationOnOff:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string/jumbo v1, "}"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3424
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistrationOnOff:Z

    if-eqz v0, :cond_1

    if-nez p1, :cond_1

    .line 3426
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getRadioPowerOffDelayTimeoutForImsRegistration()I

    move-result v0

    if-lez v0, :cond_0

    const/16 v0, 0x2d

    .line 3429
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    goto :goto_0

    :cond_0
    const-string v0, "setImsRegistrationState: EVENT_CHANGE_IMS_STATE not sent because power off delay for IMS deregistration is not enabled."

    .line 3431
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3435
    :cond_1
    :goto_0
    iput-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistrationOnOff:Z

    return-void
.end method

.method public setNotification(I)V
    .locals 16
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    move-object/from16 v0, p0

    move/from16 v1, p1

    .line 4680
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "setNotification: create notification "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 4682
    iget v2, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    invoke-static {v2}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v2

    if-nez v2, :cond_0

    .line 4684
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "cannot setNotification on invalid subid mSubId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    return-void

    .line 4687
    :cond_0
    iget-object v2, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 4689
    iget-object v3, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    iget-object v4, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 4690
    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v4

    invoke-virtual {v2}, Landroid/content/Context;->getOpPackageName()Ljava/lang/String;

    move-result-object v5

    .line 4691
    invoke-virtual {v2}, Landroid/content/Context;->getAttributionTag()Ljava/lang/String;

    move-result-object v6

    .line 4690
    invoke-virtual {v3, v4, v5, v6}, Lcom/android/internal/telephony/SubscriptionController;->getActiveSubscriptionInfo(ILjava/lang/String;Ljava/lang/String;)Landroid/telephony/SubscriptionInfo;

    move-result-object v3

    if-eqz v3, :cond_16

    .line 4694
    invoke-virtual {v3}, Landroid/telephony/SubscriptionInfo;->isOpportunistic()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-virtual {v3}, Landroid/telephony/SubscriptionInfo;->getGroupUuid()Landroid/os/ParcelUuid;

    move-result-object v3

    if-eqz v3, :cond_1

    goto/16 :goto_9

    .line 4700
    :cond_1
    invoke-virtual {v2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    const v4, 0x11101f4

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result v3

    if-nez v3, :cond_2

    const-string v1, "Ignore all the notifications"

    .line 4703
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    .line 4709
    :cond_2
    invoke-virtual/range {p0 .. p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v3

    const-string v4, "disable_voice_barring_notification_bool"

    const/4 v5, 0x0

    .line 4710
    invoke-virtual {v3, v4, v5}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result v4

    const/16 v6, 0x3ed

    const/16 v7, 0x3ee

    if-eqz v4, :cond_4

    const/16 v4, 0x3eb

    if-eq v1, v4, :cond_3

    if-eq v1, v6, :cond_3

    if-ne v1, v7, :cond_4

    :cond_3
    const-string v1, "Voice/emergency call barred notification disabled"

    .line 4715
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    :cond_4
    const-string v4, "carrier_auto_cancel_cs_notification"

    .line 4718
    invoke-virtual {v3, v4, v5}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    .line 4726
    iget-object v9, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v9}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v9

    const-string v10, "phone"

    .line 4727
    invoke-virtual {v9, v10}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Landroid/telephony/TelephonyManager;

    invoke-virtual {v9}, Landroid/telephony/TelephonyManager;->getPhoneCount()I

    move-result v9

    const/4 v10, 0x1

    if-le v9, v10, :cond_5

    move v9, v10

    goto :goto_0

    :cond_5
    move v9, v5

    .line 4728
    :goto_0
    iget-object v11, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubscriptionController:Lcom/android/internal/telephony/SubscriptionController;

    iget v12, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    invoke-virtual {v11, v12}, Lcom/android/internal/telephony/SubscriptionController;->getSlotIndex(I)I

    move-result v11

    add-int/2addr v11, v10

    const/16 v12, 0x7d2

    const/16 v14, 0x7d1

    const-string v15, ""

    const v4, 0x10400cd

    const v8, 0x10400cc

    if-eq v1, v6, :cond_e

    if-eq v1, v7, :cond_c

    if-eq v1, v14, :cond_9

    packed-switch v1, :pswitch_data_0

    move-object v3, v15

    :goto_1
    const/16 v4, 0x3e7

    :goto_2
    const v8, 0x108008a

    goto/16 :goto_4

    :pswitch_0
    const v3, 0x10400c8

    .line 4748
    invoke-virtual {v2, v3}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v15

    if-eqz v9, :cond_6

    new-array v3, v10, [Ljava/lang/Object;

    .line 4752
    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v3, v5

    .line 4750
    invoke-virtual {v2, v4, v3}, Landroid/content/Context;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    goto :goto_1

    .line 4753
    :cond_6
    invoke-virtual {v2, v8}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v3

    goto :goto_1

    :pswitch_1
    move-object v3, v15

    :goto_3
    const/16 v4, 0x378

    goto :goto_2

    .line 4732
    :pswitch_2
    invoke-static {}, Landroid/telephony/SubscriptionManager;->getDefaultDataSubscriptionId()I

    move-result v3

    int-to-long v13, v3

    .line 4733
    iget-object v3, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v3

    int-to-long v6, v3

    cmp-long v3, v13, v6

    if-eqz v3, :cond_7

    return-void

    :cond_7
    const v3, 0x10400c9

    .line 4737
    invoke-virtual {v2, v3}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v15

    if-eqz v9, :cond_8

    new-array v3, v10, [Ljava/lang/Object;

    .line 4741
    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v3, v5

    .line 4739
    invoke-virtual {v2, v4, v3}, Landroid/content/Context;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    goto :goto_3

    .line 4742
    :cond_8
    invoke-virtual {v2, v8}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v3

    goto :goto_3

    :cond_9
    const/16 v4, 0x6f

    .line 4776
    iget v6, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mRejectCode:I

    invoke-direct {v0, v6, v9}, Lcom/android/internal/telephony/ServiceStateTracker;->selectResourceForRejectCode(IZ)I

    move-result v6

    if-nez v6, :cond_b

    if-eqz v3, :cond_a

    move v1, v12

    move-object v3, v15

    goto :goto_2

    .line 4781
    :cond_a
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setNotification: mRejectCode="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mRejectCode:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " is not handled."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    return-void

    :cond_b
    const v8, 0x108088e

    new-array v3, v10, [Ljava/lang/Object;

    .line 4787
    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    aput-object v7, v3, v5

    invoke-virtual {v2, v6, v3}, Landroid/content/Context;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v15

    const/4 v3, 0x0

    goto :goto_4

    :cond_c
    const v3, 0x10400ca

    .line 4764
    invoke-virtual {v2, v3}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v15

    if-eqz v9, :cond_d

    new-array v3, v10, [Ljava/lang/Object;

    .line 4768
    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v3, v5

    .line 4766
    invoke-virtual {v2, v4, v3}, Landroid/content/Context;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    goto/16 :goto_1

    .line 4769
    :cond_d
    invoke-virtual {v2, v8}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v3

    goto/16 :goto_1

    :cond_e
    const v3, 0x10400cb

    .line 4756
    invoke-virtual {v2, v3}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v15

    if-eqz v9, :cond_f

    new-array v3, v10, [Ljava/lang/Object;

    .line 4760
    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v3, v5

    .line 4758
    invoke-virtual {v2, v4, v3}, Landroid/content/Context;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    goto/16 :goto_1

    .line 4761
    :cond_f
    invoke-virtual {v2, v8}, Landroid/content/Context;->getText(I)Ljava/lang/CharSequence;

    move-result-object v3

    goto/16 :goto_1

    .line 4794
    :goto_4
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "setNotification, create notification, notifyType: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, ", title: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v7, ", details: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v7, ", subId: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v7, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 4798
    new-instance v6, Landroid/app/Notification$Builder;

    invoke-direct {v6, v2}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;)V

    .line 4799
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v13

    invoke-virtual {v6, v13, v14}, Landroid/app/Notification$Builder;->setWhen(J)Landroid/app/Notification$Builder;

    move-result-object v6

    .line 4800
    invoke-virtual {v6, v10}, Landroid/app/Notification$Builder;->setAutoCancel(Z)Landroid/app/Notification$Builder;

    move-result-object v6

    .line 4801
    invoke-virtual {v6, v8}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object v6

    .line 4802
    invoke-virtual {v6, v15}, Landroid/app/Notification$Builder;->setTicker(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v6

    .line 4803
    invoke-virtual {v2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v7

    const v8, 0x106001c

    invoke-virtual {v7, v8}, Landroid/content/res/Resources;->getColor(I)I

    move-result v7

    invoke-virtual {v6, v7}, Landroid/app/Notification$Builder;->setColor(I)Landroid/app/Notification$Builder;

    move-result-object v6

    .line 4805
    invoke-virtual {v6, v15}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v6

    new-instance v7, Landroid/app/Notification$BigTextStyle;

    invoke-direct {v7}, Landroid/app/Notification$BigTextStyle;-><init>()V

    .line 4806
    invoke-virtual {v7, v3}, Landroid/app/Notification$BigTextStyle;->bigText(Ljava/lang/CharSequence;)Landroid/app/Notification$BigTextStyle;

    move-result-object v7

    invoke-virtual {v6, v7}, Landroid/app/Notification$Builder;->setStyle(Landroid/app/Notification$Style;)Landroid/app/Notification$Builder;

    move-result-object v6

    .line 4807
    invoke-virtual {v6, v3}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v3

    const-string v6, "alert"

    .line 4808
    invoke-virtual {v3, v6}, Landroid/app/Notification$Builder;->setChannelId(Ljava/lang/String;)Landroid/app/Notification$Builder;

    move-result-object v3

    .line 4809
    invoke-virtual {v3}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v3

    iput-object v3, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNotification:Landroid/app/Notification;

    const-string v3, "notification"

    .line 4812
    invoke-virtual {v2, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/app/NotificationManager;

    const/16 v3, 0x3ea

    if-eq v1, v3, :cond_14

    const/16 v3, 0x3ec

    if-eq v1, v3, :cond_14

    if-ne v1, v12, :cond_10

    goto :goto_7

    .line 4820
    :cond_10
    iget-object v3, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->isEmergencyOnly()Z

    move-result v3

    if-eqz v3, :cond_11

    const/16 v3, 0x3ee

    if-ne v1, v3, :cond_11

    goto :goto_5

    :cond_11
    const/16 v3, 0x7d1

    if-ne v1, v3, :cond_12

    :goto_5
    move v5, v10

    goto :goto_6

    .line 4826
    :cond_12
    iget-object v1, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getState()I

    move-result v1

    if-nez v1, :cond_13

    goto :goto_5

    :cond_13
    :goto_6
    if-eqz v5, :cond_15

    .line 4834
    iget v1, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNotification:Landroid/app/Notification;

    invoke-virtual {v2, v1, v4, v0}, Landroid/app/NotificationManager;->notify(Ljava/lang/String;ILandroid/app/Notification;)V

    goto :goto_8

    .line 4817
    :cond_14
    :goto_7
    iget v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    invoke-static {v0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0, v4}, Landroid/app/NotificationManager;->cancel(Ljava/lang/String;I)V

    :cond_15
    :goto_8
    return-void

    .line 4695
    :cond_16
    :goto_9
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "cannot setNotification on invisible subid mSubId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mSubId:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x3e9
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method protected setOperatorIdd(Ljava/lang/String;)V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 4259
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getUnitTestMode()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 4265
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHbpcdUtils:Lcom/android/internal/telephony/HbpcdUtils;

    const/4 v0, 0x0

    const/4 v1, 0x3

    .line 4266
    invoke-virtual {p1, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p1

    .line 4265
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/HbpcdUtils;->getIddByMcc(I)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 4267
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_1

    .line 4268
    invoke-static {p0}, Landroid/internal/telephony/sysprop/TelephonyProperties;->operator_idp_string(Ljava/lang/String;)V

    goto :goto_0

    :cond_1
    const-string p0, "+"

    .line 4271
    invoke-static {p0}, Landroid/internal/telephony/sysprop/TelephonyProperties;->operator_idp_string(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method protected setPhyCellInfoFromCellIdentity(Landroid/telephony/ServiceState;Landroid/telephony/CellIdentity;)V
    .locals 10

    if-nez p2, :cond_0

    const-string p1, "Could not set ServiceState channel number. CellIdentity null"

    .line 2600
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    .line 2605
    :cond_0
    invoke-virtual {p2}, Landroid/telephony/CellIdentity;->getChannelNumber()I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/telephony/ServiceState;->setChannelNumber(I)V

    .line 2610
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    invoke-static {v0, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->getPrimaryPhysicalChannelConfigForCell(Ljava/util/List;Landroid/telephony/CellIdentity;)Landroid/telephony/PhysicalChannelConfig;

    move-result-object v0

    .line 2612
    instance-of v1, p2, Landroid/telephony/CellIdentityLte;

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v4, 0x1

    if-eqz v1, :cond_7

    .line 2613
    check-cast p2, Landroid/telephony/CellIdentityLte;

    const-string v1, "Invalid LTE Bandwidth in RegistrationState, "

    if-eqz v0, :cond_3

    .line 2617
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    invoke-static {v5}, Lcom/android/internal/telephony/ServiceStateTracker;->getBandwidthsFromConfigs(Ljava/util/List;)[I

    move-result-object v5

    .line 2618
    array-length v6, v5

    move v7, v3

    :goto_0
    if-ge v7, v6, :cond_2

    aget v8, v5, v7

    .line 2619
    invoke-static {v8}, Lcom/android/internal/telephony/ServiceStateTracker;->isValidLteBandwidthKhz(I)Z

    move-result v9

    if-nez v9, :cond_1

    .line 2620
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    goto :goto_1

    :cond_1
    add-int/lit8 v7, v7, 0x1

    goto :goto_0

    :cond_2
    move-object v2, v5

    :cond_3
    :goto_1
    if-eqz v2, :cond_4

    .line 2638
    array-length v5, v2

    if-ne v5, v4, :cond_a

    .line 2639
    :cond_4
    invoke-virtual {p2}, Landroid/telephony/CellIdentityLte;->getBandwidth()I

    move-result p2

    .line 2640
    invoke-static {p2}, Lcom/android/internal/telephony/ServiceStateTracker;->isValidLteBandwidthKhz(I)Z

    move-result v5

    if-eqz v5, :cond_5

    new-array p0, v4, [I

    aput p2, p0, v3

    move-object v2, p0

    goto :goto_3

    :cond_5
    const v5, 0x7fffffff

    if-ne p2, v5, :cond_6

    goto :goto_3

    .line 2646
    :cond_6
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    goto :goto_3

    .line 2649
    :cond_7
    instance-of p2, p2, Landroid/telephony/CellIdentityNr;

    if-eqz p2, :cond_a

    if-eqz v0, :cond_a

    .line 2653
    iget-object p2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastPhysicalChannelConfigList:Ljava/util/List;

    invoke-static {p2}, Lcom/android/internal/telephony/ServiceStateTracker;->getBandwidthsFromConfigs(Ljava/util/List;)[I

    move-result-object p2

    .line 2654
    array-length v1, p2

    move v5, v3

    :goto_2
    if-ge v5, v1, :cond_9

    aget v6, p2, v5

    .line 2655
    invoke-static {v6}, Lcom/android/internal/telephony/ServiceStateTracker;->isValidNrBandwidthKhz(I)Z

    move-result v7

    if-nez v7, :cond_8

    .line 2656
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Invalid NR Bandwidth in RegistrationState, "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    goto :goto_3

    :cond_8
    add-int/lit8 v5, v5, 0x1

    goto :goto_2

    :cond_9
    move-object v2, p2

    :cond_a
    :goto_3
    if-nez v2, :cond_b

    if-eqz v0, :cond_b

    .line 2669
    invoke-virtual {v0}, Landroid/telephony/PhysicalChannelConfig;->getCellBandwidthDownlinkKhz()I

    move-result p0

    if-eqz p0, :cond_b

    new-array v2, v4, [I

    .line 2671
    invoke-virtual {v0}, Landroid/telephony/PhysicalChannelConfig;->getCellBandwidthDownlinkKhz()I

    move-result p0

    aput p0, v2, v3

    :cond_b
    if-eqz v2, :cond_c

    .line 2677
    invoke-virtual {p1, v2}, Landroid/telephony/ServiceState;->setCellBandwidths([I)V

    :cond_c
    return-void
.end method

.method protected setPowerStateToDesired()V
    .locals 1

    const/4 v0, 0x0

    .line 3196
    invoke-virtual {p0, v0, v0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->setPowerStateToDesired(ZZZ)V

    return-void
.end method

.method protected setPowerStateToDesired(ZZZ)V
    .locals 3

    .line 3202
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setPowerStateToDesired: mDeviceShuttingDown="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mDesiredPowerState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDesiredPowerState:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", getRadioState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 3204
    invoke-interface {v1}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", mRadioDisabledByCarrier="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioDisabledByCarrier:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", IMS reg state="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistrationOnOff:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", pending radio off="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x3e

    .line 3207
    invoke-virtual {p0, v1}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 3208
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3209
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 3212
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDesiredPowerState:Z

    if-eqz v0, :cond_0

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    if-eqz v1, :cond_0

    const-string p1, "setPowerStateToDesired powering on of radio failed because the device is powering off"

    .line 3213
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    :cond_0
    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz v0, :cond_2

    .line 3219
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioDisabledByCarrier:Z

    if-nez v0, :cond_2

    if-nez p3, :cond_1

    iget-object p3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 3220
    invoke-interface {p3}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result p3

    if-nez p3, :cond_2

    .line 3221
    :cond_1
    iget-object p3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p3, v2, p1, p2, v1}, Lcom/android/internal/telephony/CommandsInterface;->setRadioPower(ZZZLandroid/os/Message;)V

    goto :goto_1

    .line 3222
    :cond_2
    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDesiredPowerState:Z

    if-eqz p1, :cond_3

    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioDisabledByCarrier:Z

    if-eqz p1, :cond_5

    :cond_3
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p1}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result p1

    if-ne p1, v2, :cond_5

    .line 3225
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result p1

    if-nez p1, :cond_4

    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsRegistrationOnOff:Z

    if-eqz p1, :cond_4

    .line 3226
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getRadioPowerOffDelayTimeoutForImsRegistration()I

    move-result p1

    if-lez p1, :cond_4

    const-string p1, "setPowerStateToDesired: delaying power off until IMS dereg."

    .line 3227
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3228
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->startDelayRadioOffWaitingForImsDeregTimeout()V

    goto :goto_0

    :cond_4
    const-string p1, "setPowerStateToDesired: powerOffRadioSafely()"

    .line 3230
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3231
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->powerOffRadioSafely()V

    :goto_0
    return-void

    .line 3235
    :cond_5
    iget-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDeviceShuttingDown:Z

    if-eqz p1, :cond_6

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    .line 3236
    invoke-interface {p1}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result p1

    const/4 p2, 0x2

    if-eq p1, p2, :cond_6

    .line 3240
    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {p1, v1}, Lcom/android/internal/telephony/CommandsInterface;->requestShutdown(Landroid/os/Message;)V

    .line 3243
    :cond_6
    :goto_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->cancelDelayRadioOffWaitingForImsDeregTimeout()V

    .line 3244
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->cancelPendingRadioPowerOff()V

    return-void
.end method

.method public final setRadioPower(Z)V
    .locals 1

    const/4 v0, 0x0

    .line 1133
    invoke-virtual {p0, p1, v0, v0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->setRadioPower(ZZZZ)V

    return-void
.end method

.method public setRadioPower(ZZZZ)V
    .locals 6

    const/4 v5, 0x0

    move-object v0, p0

    move v1, p1

    move v2, p2

    move v3, p3

    move v4, p4

    .line 1143
    invoke-virtual/range {v0 .. v5}, Lcom/android/internal/telephony/ServiceStateTracker;->setRadioPowerForReason(ZZZZI)V

    return-void
.end method

.method public setRadioPowerForReason(ZZZZI)V
    .locals 3

    .line 1155
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setRadioPower power "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " forEmergencyCall "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " forceApply "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, " reason "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    if-eqz p1, :cond_1

    if-eqz p2, :cond_0

    .line 1160
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->clearAllRadioOffReasons()V

    goto :goto_0

    .line 1162
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerOffReasons:Ljava/util/Set;

    invoke-static {p5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    goto :goto_0

    .line 1165
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerOffReasons:Ljava/util/Set;

    invoke-static {p5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v2}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 1167
    :goto_0
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDesiredPowerState:Z

    if-ne p1, v0, :cond_2

    if-nez p4, :cond_2

    .line 1168
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "setRadioPower mDesiredPowerState is already "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, " Do nothing."

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    :cond_2
    if-eqz p1, :cond_3

    .line 1171
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerOffReasons:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_3

    .line 1172
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setRadioPowerForReason power: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, " forEmergencyCall= "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, " isSelectedPhoneForEmergencyCall: "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, "reason:"

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " will not power on the radio as it is powered off for the following reasons: "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioPowerOffReasons:Ljava/util/Set;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p1, "."

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    .line 1180
    :cond_3
    iput-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDesiredPowerState:Z

    .line 1181
    invoke-virtual {p0, p2, p3, p4}, Lcom/android/internal/telephony/ServiceStateTracker;->setPowerStateToDesired(ZZZ)V

    return-void
.end method

.method public setRadioPowerFromCarrier(Z)V
    .locals 2

    xor-int/lit8 p1, p1, 0x1

    .line 1191
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioDisabledByCarrier:Z

    if-ne v0, p1, :cond_0

    .line 1192
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setRadioPowerFromCarrier mRadioDisabledByCarrier is already "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p1, " Do nothing."

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    .line 1197
    :cond_0
    iput-boolean p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mRadioDisabledByCarrier:Z

    .line 1198
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->setPowerStateToDesired()V

    return-void
.end method

.method protected setRoamingOff()V
    .locals 2

    .line 2824
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/telephony/ServiceState;->setRoaming(Z)V

    .line 2825
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Landroid/telephony/ServiceState;->setCdmaEriIconIndex(I)V

    return-void
.end method

.method protected setRoamingOn()V
    .locals 2

    .line 2816
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/telephony/ServiceState;->setRoaming(Z)V

    .line 2817
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/telephony/ServiceState;->setCdmaEriIconIndex(I)V

    .line 2818
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, v1}, Landroid/telephony/ServiceState;->setCdmaEriIconMode(I)V

    return-void
.end method

.method protected setRoamingType(Landroid/telephony/ServiceState;)V
    .locals 9
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 5670
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-nez v0, :cond_0

    move v0, v2

    goto :goto_0

    :cond_0
    move v0, v1

    :goto_0
    const/4 v3, 0x2

    const/4 v4, 0x3

    if-eqz v0, :cond_7

    .line 5672
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v5

    if-eqz v5, :cond_6

    .line 5673
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v5}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v5

    if-eqz v5, :cond_2

    .line 5675
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->inSameCountry(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 5676
    invoke-virtual {p1, v3}, Landroid/telephony/ServiceState;->setVoiceRoamingType(I)V

    goto :goto_2

    .line 5679
    :cond_1
    invoke-virtual {p1, v4}, Landroid/telephony/ServiceState;->setVoiceRoamingType(I)V

    goto :goto_2

    .line 5684
    :cond_2
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v5

    invoke-virtual {v5}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    const v6, 0x1070031

    invoke-virtual {v5, v6}, Landroid/content/res/Resources;->getIntArray(I)[I

    move-result-object v5

    if-eqz v5, :cond_4

    .line 5687
    array-length v6, v5

    if-lez v6, :cond_4

    .line 5689
    invoke-virtual {p1, v3}, Landroid/telephony/ServiceState;->setVoiceRoamingType(I)V

    .line 5690
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getCdmaRoamingIndicator()I

    move-result v6

    move v7, v1

    .line 5691
    :goto_1
    array-length v8, v5

    if-ge v7, v8, :cond_7

    .line 5692
    aget v8, v5, v7

    if-ne v6, v8, :cond_3

    .line 5693
    invoke-virtual {p1, v4}, Landroid/telephony/ServiceState;->setVoiceRoamingType(I)V

    goto :goto_2

    :cond_3
    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    .line 5700
    :cond_4
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->inSameCountry(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_5

    .line 5701
    invoke-virtual {p1, v3}, Landroid/telephony/ServiceState;->setVoiceRoamingType(I)V

    goto :goto_2

    .line 5704
    :cond_5
    invoke-virtual {p1, v4}, Landroid/telephony/ServiceState;->setVoiceRoamingType(I)V

    goto :goto_2

    .line 5710
    :cond_6
    invoke-virtual {p1, v1}, Landroid/telephony/ServiceState;->setVoiceRoamingType(I)V

    .line 5714
    :cond_7
    :goto_2
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v5

    if-nez v5, :cond_8

    move v5, v2

    goto :goto_3

    :cond_8
    move v5, v1

    .line 5715
    :goto_3
    invoke-static {p1}, Lcom/android/internal/telephony/ServiceStateTracker;->getRilDataRadioTechnologyForWwan(Landroid/telephony/ServiceState;)I

    move-result v6

    if-eqz v5, :cond_10

    .line 5717
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v5

    if-nez v5, :cond_9

    .line 5718
    invoke-virtual {p1, v1}, Landroid/telephony/ServiceState;->setDataRoamingType(I)V

    goto :goto_4

    .line 5720
    :cond_9
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-eqz v1, :cond_c

    .line 5721
    invoke-static {v6}, Landroid/telephony/ServiceState;->isGsm(I)Z

    move-result p0

    if-eqz p0, :cond_b

    if-eqz v0, :cond_a

    .line 5725
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getVoiceRoamingType()I

    move-result p0

    .line 5724
    invoke-virtual {p1, p0}, Landroid/telephony/ServiceState;->setDataRoamingType(I)V

    goto :goto_4

    .line 5728
    :cond_a
    invoke-virtual {p1, v2}, Landroid/telephony/ServiceState;->setDataRoamingType(I)V

    goto :goto_4

    .line 5732
    :cond_b
    invoke-virtual {p1, v2}, Landroid/telephony/ServiceState;->setDataRoamingType(I)V

    goto :goto_4

    .line 5735
    :cond_c
    invoke-static {v6}, Landroid/telephony/ServiceState;->isCdma(I)Z

    move-result v1

    if-eqz v1, :cond_e

    if-eqz v0, :cond_d

    .line 5739
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getVoiceRoamingType()I

    move-result p0

    .line 5738
    invoke-virtual {p1, p0}, Landroid/telephony/ServiceState;->setDataRoamingType(I)V

    goto :goto_4

    .line 5743
    :cond_d
    invoke-virtual {p1, v2}, Landroid/telephony/ServiceState;->setDataRoamingType(I)V

    goto :goto_4

    .line 5747
    :cond_e
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->inSameCountry(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_f

    .line 5748
    invoke-virtual {p1, v3}, Landroid/telephony/ServiceState;->setDataRoamingType(I)V

    goto :goto_4

    .line 5750
    :cond_f
    invoke-virtual {p1, v4}, Landroid/telephony/ServiceState;->setDataRoamingType(I)V

    :cond_10
    :goto_4
    return-void
.end method

.method public setServiceStateStats(Lcom/android/internal/telephony/metrics/ServiceStateStats;)V
    .locals 0
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 6174
    iput-object p1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mServiceStateStats:Lcom/android/internal/telephony/metrics/ServiceStateStats;

    return-void
.end method

.method protected setTimeFromNITZString(Ljava/lang/String;JJ)V
    .locals 13

    move-object v0, p0

    move-wide v2, p2

    const-string v7, " dur="

    const-string v8, "NITZ: end="

    .line 4630
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v9

    .line 4632
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "NITZ: "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object v4, p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, ","

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v5, ", ageMs="

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-wide/from16 v5, p4

    invoke-virtual {v1, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v11, " start="

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v9, v10}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v11, " delay="

    invoke-virtual {v1, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sub-long v11, v9, v2

    invoke-virtual {v1, v11, v12}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v11, "SST"

    invoke-static {v11, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 4635
    invoke-static {p1}, Lcom/android/internal/telephony/NitzData;->parse(Ljava/lang/String;)Lcom/android/internal/telephony/NitzData;

    move-result-object v4

    .line 4636
    iput-object v4, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastNitzData:Lcom/android/internal/telephony/NitzData;

    if-eqz v4, :cond_0

    .line 4639
    :try_start_0
    new-instance v12, Lcom/android/internal/telephony/NitzSignal;

    move-object v1, v12

    move-wide v2, p2

    move-wide/from16 v5, p4

    invoke-direct/range {v1 .. v6}, Lcom/android/internal/telephony/NitzSignal;-><init>(JLcom/android/internal/telephony/NitzData;J)V

    .line 4640
    iget-object v0, v0, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {v0, v12}, Lcom/android/internal/telephony/NitzStateMachine;->handleNitzReceived(Lcom/android/internal/telephony/NitzSignal;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 4643
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    .line 4644
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sub-long/2addr v0, v9

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v11, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :catchall_0
    move-exception v0

    .line 4643
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v1

    .line 4644
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sub-long/2addr v1, v9

    invoke-virtual {v3, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v11, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 4646
    throw v0

    :cond_0
    :goto_0
    return-void
.end method

.method public shouldForceDisplayNoService()Z
    .locals 6

    .line 3181
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x107005a

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    .line 3183
    invoke-static {v0}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty([Ljava/lang/Object;)Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    return v2

    .line 3186
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLocaleTracker:Lcom/android/internal/telephony/LocaleTracker;

    invoke-virtual {v1}, Lcom/android/internal/telephony/LocaleTracker;->getLastKnownCountryIso()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownNetworkCountry:Ljava/lang/String;

    .line 3187
    array-length v1, v0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, v0, v3

    .line 3188
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownNetworkCountry:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_2
    return v2
.end method

.method protected startDelayRadioOffWaitingForImsDeregTimeout()V
    .locals 3

    const/16 v0, 0x3e

    .line 3280
    invoke-virtual {p0, v0}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string/jumbo v0, "startDelayRadioOffWaitingForImsDeregTimeout: timer exists, ignoring"

    .line 3281
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    :cond_0
    const-string/jumbo v1, "startDelayRadioOffWaitingForImsDeregTimeout: starting timer"

    .line 3284
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3286
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getRadioPowerOffDelayTimeoutForImsRegistration()I

    move-result v1

    int-to-long v1, v1

    .line 3285
    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendEmptyMessageDelayed(IJ)Z

    return-void
.end method

.method public unregisterForAirplaneModeChanged(Landroid/os/Handler;)V
    .locals 0

    .line 5038
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAirplaneModeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForAreaCodeChanged(Landroid/os/Handler;)V
    .locals 0

    .line 6212
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAreaCodeChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForBandwidthChanged(Landroid/os/Handler;)V
    .locals 0

    .line 6130
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mBandwidthChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForCssIndicatorChanged(Landroid/os/Handler;)V
    .locals 0

    .line 6111
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCssIndicatorChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForDataConnectionAttached(ILandroid/os/Handler;)V
    .locals 1

    .line 4925
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 4926
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAttachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    :cond_0
    return-void
.end method

.method public unregisterForDataConnectionDetached(ILandroid/os/Handler;)V
    .locals 1

    .line 4961
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 4962
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    :cond_0
    return-void
.end method

.method public unregisterForDataRegStateOrRatChanged(ILandroid/os/Handler;)V
    .locals 1

    .line 5015
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRegStateOrRatChangedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {v0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 5016
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRegStateOrRatChangedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {p0, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    :cond_0
    return-void
.end method

.method public unregisterForDataRoamingOff(Landroid/os/Handler;)V
    .locals 0

    .line 1096
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForDataRoamingOn(Landroid/os/Handler;)V
    .locals 0

    .line 1074
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForImsCapabilityChanged(Landroid/os/Handler;)V
    .locals 0

    .line 5133
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mImsCapabilityChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForNetworkAttached(Landroid/os/Handler;)V
    .locals 0

    .line 5057
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNetworkAttachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForNetworkDetached(Landroid/os/Handler;)V
    .locals 0

    .line 5076
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNetworkDetachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForNrFrequencyChanged(Landroid/os/Handler;)V
    .locals 0

    .line 6092
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNrFrequencyChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForNrStateChanged(Landroid/os/Handler;)V
    .locals 0

    .line 6073
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNrStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForPsRestrictedDisabled(Landroid/os/Handler;)V
    .locals 0

    .line 5114
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPsRestrictDisabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForPsRestrictedEnabled(Landroid/os/Handler;)V
    .locals 0

    .line 5095
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPsRestrictEnabledRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForServiceStateChanged(Landroid/os/Handler;)V
    .locals 0

    .line 5152
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mServiceStateChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForSubscriptionInfoReady(Landroid/os/Handler;)V
    .locals 0

    .line 5429
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaForSubscriptionInfoReadyRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForVoiceRegStateOrRatChanged(Landroid/os/Handler;)V
    .locals 0

    .line 4982
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRegStateOrRatChangedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForVoiceRoamingOff(Landroid/os/Handler;)V
    .locals 0

    .line 1053
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method public unregisterForVoiceRoamingOn(Landroid/os/Handler;)V
    .locals 0

    .line 1032
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRoamingOnRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/RegistrantList;->remove(Landroid/os/Handler;)V

    return-void
.end method

.method protected updateNrFrequencyRangeFromPhysicalChannelConfigs(Ljava/util/List;Landroid/telephony/ServiceState;)Z
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/PhysicalChannelConfig;",
            ">;",
            "Landroid/telephony/ServiceState;",
            ")Z"
        }
    .end annotation

    const/4 v0, 0x0

    if-eqz p1, :cond_1

    .line 2175
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/PhysicalChannelConfig;

    .line 2176
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->isNrPhysicalChannelConfig(Landroid/telephony/PhysicalChannelConfig;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->isInternetPhysicalChannelConfig(Landroid/telephony/PhysicalChannelConfig;)Z

    move-result v2

    if-eqz v2, :cond_0

    .line 2180
    invoke-virtual {v1}, Landroid/telephony/PhysicalChannelConfig;->getFrequencyRange()I

    move-result p0

    .line 2179
    invoke-static {v0, p0}, Landroid/telephony/ServiceState;->getBetterNRFrequencyRange(II)I

    move-result p0

    goto :goto_0

    :cond_1
    move p0, v0

    .line 2186
    :goto_0
    invoke-virtual {p2}, Landroid/telephony/ServiceState;->getNrFrequencyRange()I

    move-result p1

    if-eq p0, p1, :cond_2

    const/4 v0, 0x1

    .line 2187
    :cond_2
    invoke-virtual {p2, p0}, Landroid/telephony/ServiceState;->setNrFrequencyRange(I)V

    return v0
.end method

.method protected updateNrStateFromPhysicalChannelConfigs(Ljava/util/List;Landroid/telephony/ServiceState;)Z
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/PhysicalChannelConfig;",
            ">;",
            "Landroid/telephony/ServiceState;",
            ")Z"
        }
    .end annotation

    const/4 v0, 0x2

    const/4 v1, 0x1

    .line 2195
    invoke-virtual {p2, v0, v1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v2

    const/4 v3, 0x0

    if-eqz v2, :cond_5

    if-nez p1, :cond_0

    goto :goto_3

    .line 2200
    :cond_0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_1
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/telephony/PhysicalChannelConfig;

    .line 2201
    invoke-direct {p0, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->isNrPhysicalChannelConfig(Landroid/telephony/PhysicalChannelConfig;)Z

    move-result v5

    if-eqz v5, :cond_1

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/ServiceStateTracker;->isInternetPhysicalChannelConfig(Landroid/telephony/PhysicalChannelConfig;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 2202
    invoke-virtual {v4}, Landroid/telephony/PhysicalChannelConfig;->getConnectionStatus()I

    move-result v4

    if-ne v4, v0, :cond_1

    move p0, v1

    goto :goto_0

    :cond_2
    move p0, v3

    .line 2209
    :goto_0
    invoke-virtual {v2}, Landroid/telephony/NetworkRegistrationInfo;->getNrState()I

    move-result p1

    .line 2214
    invoke-virtual {v2}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result v0

    const/16 v4, 0xd

    if-ne v0, v4, :cond_3

    if-eqz p0, :cond_3

    const/4 p0, 0x3

    goto :goto_1

    .line 2218
    :cond_3
    invoke-virtual {v2}, Landroid/telephony/NetworkRegistrationInfo;->updateNrState()V

    .line 2219
    invoke-virtual {v2}, Landroid/telephony/NetworkRegistrationInfo;->getNrState()I

    move-result p0

    :goto_1
    if-eq p0, p1, :cond_4

    goto :goto_2

    :cond_4
    move v1, v3

    .line 2223
    :goto_2
    invoke-virtual {v2, p0}, Landroid/telephony/NetworkRegistrationInfo;->setNrState(I)V

    .line 2224
    invoke-virtual {p2, v2}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    return v1

    :cond_5
    :goto_3
    return v3
.end method

.method public updateOperatorNameForCellInfo(Ljava/util/List;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/CellInfo;",
            ">;)V"
        }
    .end annotation

    if-eqz p1, :cond_2

    .line 6013
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_1

    .line 6016
    :cond_0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_1
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/CellInfo;

    .line 6017
    invoke-virtual {v0}, Landroid/telephony/CellInfo;->isRegistered()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 6018
    invoke-virtual {v0}, Landroid/telephony/CellInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOperatorNameForCellIdentity(Landroid/telephony/CellIdentity;)V

    goto :goto_0

    :cond_2
    :goto_1
    return-void
.end method

.method protected updateOperatorNameForServiceState(Landroid/telephony/ServiceState;)V
    .locals 3

    if-nez p1, :cond_0

    return-void

    .line 5981
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaLong()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->filterOperatorNameByPattern(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 5982
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorAlphaShort()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->filterOperatorNameByPattern(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 5983
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v2

    .line 5980
    invoke-virtual {p1, v0, v1, v2}, Landroid/telephony/ServiceState;->setOperatorName(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 5986
    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfoList()Ljava/util/List;

    move-result-object v0

    const/4 v1, 0x0

    .line 5988
    :goto_0
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_2

    .line 5989
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_1

    .line 5991
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/NetworkRegistrationInfo;

    invoke-virtual {v2}, Landroid/telephony/NetworkRegistrationInfo;->getCellIdentity()Landroid/telephony/CellIdentity;

    move-result-object v2

    .line 5990
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOperatorNameForCellIdentity(Landroid/telephony/CellIdentity;)V

    .line 5992
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/NetworkRegistrationInfo;

    invoke-virtual {p1, v2}, Landroid/telephony/ServiceState;->addNetworkRegistrationInfo(Landroid/telephony/NetworkRegistrationInfo;)V

    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_2
    return-void
.end method

.method protected updateOperatorNameFromCarrierConfig()V
    .locals 3

    .line 2834
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRoaming()Z

    move-result v0

    if-nez v0, :cond_1

    .line 2835
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccPort(I)Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mUiccController:Lcom/android/internal/telephony/uicc/UiccController;

    .line 2836
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/uicc/UiccController;->getUiccPort(I)Lcom/android/internal/telephony/uicc/UiccPort;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccPort;->getOperatorBrandOverride()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    if-nez v0, :cond_1

    .line 2838
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    const-string v1, "cdma_home_registered_plmn_name_override_bool"

    .line 2839
    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, "cdma_home_registered_plmn_name_string"

    .line 2841
    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 2843
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "updateOperatorNameFromCarrierConfig: changing from "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 2844
    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getOperatorAlpha()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 2843
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2846
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v0, v0, v1}, Landroid/telephony/ServiceState;->setOperatorName(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    return-void
.end method

.method protected updateOtaspState()V
    .locals 3
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 1977
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getOtasp()I

    move-result v0

    .line 1978
    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurrentOtaspMode:I

    .line 1979
    iput v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurrentOtaspMode:I

    if-eq v1, v0, :cond_0

    .line 1983
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "updateOtaspState: call notifyOtaspChanged old otaspMode="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " new otaspMode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurrentOtaspMode:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 1986
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCurrentOtaspMode:I

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/Phone;->notifyOtaspChanged(I)V

    :cond_0
    return-void
.end method

.method protected updatePhoneObject()V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 1001
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x11101d6

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getBoolean(I)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 1004
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 1005
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    if-nez v0, :cond_2

    const-string/jumbo v0, "updatePhoneObject: Ignore update"

    .line 1007
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void

    .line 1010
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getRilVoiceRadioTechnology()I

    move-result p0

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->updatePhoneObject(I)V

    :cond_3
    return-void
.end method

.method public updatePhoneType()V
    .locals 7
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 795
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getVoiceRoaming()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 796
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 801
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 802
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDataRoamingOffRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 806
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    if-eqz v0, :cond_2

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    if-nez v0, :cond_2

    .line 807
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNetworkDetachedRegistrants:Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v0}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    .line 811
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_4

    aget v4, v0, v3

    .line 812
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    if-eqz v5, :cond_3

    const/4 v6, 0x2

    .line 813
    invoke-virtual {v5, v6, v4}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object v5

    if-eqz v5, :cond_3

    .line 815
    invoke-virtual {v5}, Landroid/telephony/NetworkRegistrationInfo;->isInService()Z

    move-result v5

    if-eqz v5, :cond_3

    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    .line 816
    invoke-virtual {v5, v4}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v5

    if-eqz v5, :cond_3

    .line 817
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mDetachedRegistrants:Landroid/util/SparseArray;

    invoke-virtual {v5, v4}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/android/internal/telephony/RegistrantList;

    invoke-virtual {v4}, Lcom/android/internal/telephony/RegistrantList;->notifyRegistrants()V

    :cond_3
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 822
    :cond_4
    new-instance v0, Landroid/telephony/ServiceState;

    invoke-direct {v0}, Landroid/telephony/ServiceState;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 823
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v1

    invoke-virtual {v0, v1, v2}, Landroid/telephony/ServiceState;->setOutOfService(ZZ)V

    .line 824
    new-instance v0, Landroid/telephony/ServiceState;

    invoke-direct {v0}, Landroid/telephony/ServiceState;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 825
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v1

    invoke-virtual {v0, v1, v2}, Landroid/telephony/ServiceState;->setOutOfService(ZZ)V

    const-wide/16 v0, 0x0

    .line 826
    iput-wide v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoReqTime:J

    const/4 v0, 0x0

    .line 827
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastCellInfoList:Ljava/util/List;

    .line 828
    iput-boolean v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mStartedGprsRegCheck:Z

    .line 829
    iput-boolean v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mReportedGprsNoReg:Z

    .line 830
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMdn:Ljava/lang/String;

    .line 831
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mMin:Ljava/lang/String;

    .line 832
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPrlVersion:Ljava/lang/String;

    .line 833
    iput-boolean v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsMinInfoReady:Z

    .line 834
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastNitzData:Lcom/android/internal/telephony/NitzData;

    .line 835
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNitzState:Lcom/android/internal/telephony/NitzStateMachine;

    invoke-interface {v1}, Lcom/android/internal/telephony/NitzStateMachine;->handleNetworkUnavailable()V

    .line 836
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCellIdentity:Landroid/telephony/CellIdentity;

    .line 837
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/SignalStrengthController;->setSignalStrengthDefaultValues()V

    .line 838
    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mLastKnownCellIdentity:Landroid/telephony/CellIdentity;

    .line 841
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->cancelPollState()V

    .line 843
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    if-eqz v1, :cond_6

    .line 845
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    if-eqz v0, :cond_5

    .line 846
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;->dispose(Landroid/os/Handler;)V

    .line 849
    :cond_5
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForCdmaPrlChanged(Landroid/os/Handler;)V

    .line 850
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForCdmaOtaProvision(Landroid/os/Handler;)V

    .line 851
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->unregisterForSimRecordsLoaded(Landroid/os/Handler;)V

    goto :goto_2

    .line 854
    :cond_6
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    const/16 v3, 0x10

    invoke-virtual {v1, p0, v3, v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->registerForSimRecordsLoaded(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 855
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v4, 0x27

    invoke-static {v1, v3, p0, v4, v0}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;->getInstance(Landroid/content/Context;Lcom/android/internal/telephony/CommandsInterface;Landroid/os/Handler;ILjava/lang/Object;)Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCdmaSSM:Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;

    .line 857
    invoke-virtual {v1}, Lcom/android/internal/telephony/cdma/CdmaSubscriptionSourceManager;->getCdmaSubscriptionSource()I

    move-result v1

    if-nez v1, :cond_7

    const/4 v1, 0x1

    goto :goto_1

    :cond_7
    move v1, v2

    :goto_1
    iput-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSubscriptionFromRuim:Z

    .line 860
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v3, 0x28

    invoke-interface {v1, p0, v3, v0}, Lcom/android/internal/telephony/CommandsInterface;->registerForCdmaPrlChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 861
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/16 v3, 0x25

    invoke-interface {v1, p0, v3, v0}, Lcom/android/internal/telephony/CommandsInterface;->registerForCdmaOtaProvision(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 863
    new-instance v0, Lcom/android/internal/telephony/HbpcdUtils;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/HbpcdUtils;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mHbpcdUtils:Lcom/android/internal/telephony/HbpcdUtils;

    .line 865
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOtaspState()V

    .line 870
    :goto_2
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->onUpdateIccAvailability()V

    .line 872
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->setDataNetworkTypeForPhone(I)V

    .line 877
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getSignalStrengthController()Lcom/android/internal/telephony/SignalStrengthController;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/SignalStrengthController;->getSignalStrengthFromCi()V

    const/16 v0, 0x32

    .line 878
    invoke-virtual {p0, v0}, Landroid/os/Handler;->obtainMessage(I)Landroid/os/Message;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 880
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->logPhoneTypeChange()V

    .line 883
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->notifyVoiceRegStateRilRadioTechnologyChanged()V

    .line 884
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mAccessNetworksManager:Lcom/android/internal/telephony/data/AccessNetworksManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getAvailableTransports()[I

    move-result-object v0

    array-length v1, v0

    :goto_3
    if-ge v2, v1, :cond_8

    aget v3, v0, v2

    .line 885
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->notifyDataRegStateRilRadioTechnologyChanged(I)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    :cond_8
    return-void
.end method

.method protected updateRoamingState()V
    .locals 7
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 2748
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    .line 2750
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v1

    const-string/jumbo v2, "updateRoamingState: carrier config override set roaming:"

    const-string/jumbo v3, "updateRoamingState: carrier config override always on home network"

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-eqz v1, :cond_7

    .line 2764
    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mGsmVoiceRoaming:Z

    if-nez v1, :cond_1

    iget-boolean v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mGsmDataRoaming:Z

    if-eqz v1, :cond_0

    goto :goto_0

    :cond_0
    move v1, v5

    goto :goto_1

    :cond_1
    :goto_0
    move v1, v4

    :goto_1
    if-eqz v1, :cond_3

    .line 2766
    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->isOperatorConsideredRoaming(Landroid/telephony/ServiceState;)Z

    move-result v6

    if-nez v6, :cond_3

    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2767
    invoke-direct {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->isSameNamedOperators(Landroid/telephony/ServiceState;)Z

    move-result v6

    if-nez v6, :cond_2

    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->isOperatorConsideredNonRoaming(Landroid/telephony/ServiceState;)Z

    move-result v6

    if-eqz v6, :cond_3

    .line 2768
    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v6, "updateRoamingState: resource override set non roaming.isSameNamedOperators="

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2769
    invoke-direct {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->isSameNamedOperators(Landroid/telephony/ServiceState;)Z

    move-result v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v6, ",isOperatorConsideredNonRoaming="

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2770
    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->isOperatorConsideredNonRoaming(Landroid/telephony/ServiceState;)Z

    move-result v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 2768
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    move v1, v5

    .line 2774
    :cond_3
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->alwaysOnHomeNetwork(Landroid/os/BaseBundle;)Z

    move-result v6

    if-eqz v6, :cond_4

    .line 2775
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    :goto_2
    move v4, v5

    goto :goto_3

    .line 2777
    :cond_4
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->isNonRoamingInGsmNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_5

    .line 2778
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateRoamingState: carrier config override set non roaming:"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2779
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2778
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto :goto_2

    .line 2781
    :cond_5
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->isRoamingInGsmNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 2782
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2783
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2782
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto :goto_3

    :cond_6
    move v4, v1

    .line 2787
    :goto_3
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, v4}, Landroid/telephony/ServiceState;->setRoaming(Z)V

    goto/16 :goto_6

    .line 2789
    :cond_7
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getCdmaSystemId()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    .line 2791
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->alwaysOnHomeNetwork(Landroid/os/BaseBundle;)Z

    move-result v6

    if-eqz v6, :cond_8

    .line 2792
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2793
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->setRoamingOff()V

    goto :goto_5

    .line 2794
    :cond_8
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->isNonRoamingInGsmNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z

    move-result v3

    const-string v6, ", "

    if-nez v3, :cond_b

    .line 2795
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->isNonRoamingInCdmaNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_9

    goto :goto_4

    .line 2799
    :cond_9
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v0, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->isRoamingInGsmNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_a

    .line 2800
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->isRoamingInCdmaNetwork(Landroid/os/BaseBundle;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_c

    .line 2801
    :cond_a
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2802
    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2801
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2803
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->setRoamingOn()V

    goto :goto_5

    .line 2796
    :cond_b
    :goto_4
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v2, "updateRoamingState: carrier config override set non-roaming:"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 2797
    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 2796
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2798
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->setRoamingOff()V

    .line 2806
    :cond_c
    :goto_5
    sget-boolean v0, Lcom/android/internal/telephony/util/TelephonyUtils;->IS_DEBUGGABLE:Z

    if-eqz v0, :cond_d

    const-string/jumbo v0, "telephony.test.forceRoaming"

    .line 2807
    invoke-static {v0, v5}, Landroid/os/SystemProperties;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_d

    .line 2808
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, v4}, Landroid/telephony/ServiceState;->setRoaming(Z)V

    :cond_d
    :goto_6
    return-void
.end method

.method public updateSpnDisplay()V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 2910
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    const-string v1, "enable_carrier_display_name_resolver_bool"

    .line 2911
    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 2912
    invoke-direct {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateSpnDisplayCdnr()V

    goto :goto_0

    .line 2914
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateSpnDisplayLegacy()V

    :goto_0
    return-void
.end method

.method protected updateSpnDisplayLegacy()V
    .locals 13

    const-string/jumbo v0, "updateSpnDisplayLegacy+"

    .line 2921
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 2932
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCombinedRegState(Landroid/telephony/ServiceState;)I

    move-result v0

    .line 2933
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v1

    const-string/jumbo v2, "wfc_spn_use_root_locale"

    const/4 v3, 0x0

    const/4 v4, 0x0

    if-eqz v1, :cond_6

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->isWifiCallingEnabled()Z

    move-result v1

    if-eqz v1, :cond_6

    if-nez v0, :cond_6

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    .line 2935
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getDataNetworkType()I

    move-result v1

    const/16 v5, 0x12

    if-ne v1, v5, :cond_6

    .line 2949
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v1

    const-string/jumbo v5, "wfc_spn_format_idx_int"

    .line 2951
    invoke-virtual {v1, v5}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v5

    const-string/jumbo v6, "wfc_data_spn_format_idx_int"

    .line 2952
    invoke-virtual {v1, v6}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v6

    const-string/jumbo v7, "wfc_flight_mode_spn_format_idx_int"

    .line 2954
    invoke-virtual {v1, v7}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v7

    .line 2957
    invoke-virtual {v1, v2}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    .line 2959
    iget-object v8, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v8}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v8

    iget-object v9, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 2960
    invoke-virtual {v9}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v9

    .line 2959
    invoke-static {v8, v9, v1}, Landroid/telephony/SubscriptionManager;->getResourcesForSubId(Landroid/content/Context;IZ)Landroid/content/res/Resources;

    move-result-object v1

    const v8, 0x10700f8

    .line 2961
    invoke-virtual {v1, v8}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v1

    if-ltz v5, :cond_0

    .line 2963
    array-length v8, v1

    if-lt v5, v8, :cond_1

    .line 2964
    :cond_0
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v9, "updateSpnDisplay: KEY_WFC_SPN_FORMAT_IDX_INT out of bounds: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    move v5, v4

    :cond_1
    if-ltz v6, :cond_2

    .line 2967
    array-length v8, v1

    if-lt v6, v8, :cond_3

    .line 2968
    :cond_2
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v9, "updateSpnDisplay: KEY_WFC_DATA_SPN_FORMAT_IDX_INT out of bounds: "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    move v6, v4

    :cond_3
    if-ltz v7, :cond_4

    .line 2972
    array-length v8, v1

    if-lt v7, v8, :cond_5

    :cond_4
    move v7, v5

    .line 2978
    :cond_5
    aget-object v5, v1, v5

    .line 2979
    aget-object v6, v1, v6

    .line 2980
    aget-object v1, v1, v7

    goto :goto_0

    :cond_6
    move-object v1, v3

    move-object v5, v1

    move-object v6, v5

    .line 2984
    :goto_0
    iget-object v7, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v7}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v7

    const/4 v8, 0x2

    if-eqz v7, :cond_9

    iget-object v7, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 2985
    invoke-virtual {v7}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v7

    if-eqz v7, :cond_9

    iget-object v7, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 2986
    invoke-virtual {v7}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v7

    invoke-virtual {v7}, Lcom/android/internal/telephony/Phone;->getImsRegistrationTech()I

    move-result v7

    if-ne v7, v8, :cond_9

    .line 2994
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v7

    const-string v9, "cross_sim_spn_format_int"

    .line 2996
    invoke-virtual {v7, v9}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v9

    .line 2998
    invoke-virtual {v7, v2}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v2

    .line 3000
    iget-object v7, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 3001
    invoke-virtual {v7}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v7

    iget-object v10, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 3002
    invoke-virtual {v10}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v10

    .line 3000
    invoke-static {v7, v10, v2}, Landroid/telephony/SubscriptionManager;->getResourcesForSubId(Landroid/content/Context;IZ)Landroid/content/res/Resources;

    move-result-object v2

    const v7, 0x10700c6

    .line 3003
    invoke-virtual {v2, v7}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v2

    if-ltz v9, :cond_7

    .line 3005
    array-length v7, v2

    if-lt v9, v7, :cond_8

    .line 3006
    :cond_7
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v10, "updateSpnDisplay: KEY_CROSS_SIM_SPN_FORMAT_INT out of bounds: "

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {p0, v7}, Lcom/android/internal/telephony/ServiceStateTracker;->loge(Ljava/lang/String;)V

    move v9, v4

    .line 3010
    :cond_8
    aget-object v2, v2, v9

    goto :goto_1

    :cond_9
    move-object v2, v3

    .line 3013
    :goto_1
    iget-object v7, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v7}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeGsm()Z

    move-result v7

    const-string v9, "\'"

    const v10, 0x10404e9

    const/4 v11, 0x1

    if-eqz v7, :cond_19

    .line 3033
    iget-object v7, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0, v7}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierNameDisplayBitmask(Landroid/telephony/ServiceState;)I

    move-result v7

    if-eq v0, v11, :cond_d

    if-ne v0, v8, :cond_a

    goto :goto_4

    :cond_a
    if-nez v0, :cond_c

    .line 3057
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getOperatorAlpha()Ljava/lang/String;

    move-result-object v0

    .line 3058
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v9

    if-nez v9, :cond_b

    and-int/lit8 v9, v7, 0x2

    if-ne v9, v8, :cond_b

    move v8, v11

    goto :goto_2

    :cond_b
    move v8, v4

    .line 3061
    :goto_2
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v10, "updateSpnDisplay: rawPlmn = "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {p0, v9}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    move v9, v8

    move v8, v4

    goto/16 :goto_7

    .line 3066
    :cond_c
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v8, "updateSpnDisplay: radio is off w/ showPlmn="

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v8, " plmn="

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    move-object v0, v3

    move v8, v4

    :goto_3
    move v9, v11

    goto :goto_7

    .line 3040
    :cond_d
    :goto_4
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->shouldForceDisplayNoService()Z

    move-result v0

    if-eqz v0, :cond_e

    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIsSimReady:Z

    if-nez v0, :cond_e

    move v0, v11

    goto :goto_5

    :cond_e
    move v0, v4

    :goto_5
    if-nez v0, :cond_f

    .line 3041
    invoke-static {}, Lcom/android/internal/telephony/Phone;->isEmergencyCallOnly()Z

    move-result v0

    if-eqz v0, :cond_f

    .line 3043
    invoke-static {}, Landroid/content/res/Resources;->getSystem()Landroid/content/res/Resources;

    move-result-object v0

    const v8, 0x1040350

    .line 3044
    invoke-virtual {v0, v8}, Landroid/content/res/Resources;->getText(I)Ljava/lang/CharSequence;

    move-result-object v0

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    move v8, v4

    goto :goto_6

    .line 3047
    :cond_f
    invoke-static {}, Landroid/content/res/Resources;->getSystem()Landroid/content/res/Resources;

    move-result-object v0

    .line 3048
    invoke-virtual {v0, v10}, Landroid/content/res/Resources;->getText(I)Ljava/lang/CharSequence;

    move-result-object v0

    .line 3050
    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    move v8, v11

    .line 3053
    :goto_6
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v12, "updateSpnDisplay: radio is on but out of service, set plmn=\'"

    invoke-virtual {v10, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {p0, v9}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto :goto_3

    .line 3074
    :goto_7
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceProviderName()Ljava/lang/String;

    move-result-object v10

    if-nez v8, :cond_10

    .line 3076
    invoke-static {v10}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v8

    if-nez v8, :cond_10

    and-int/2addr v7, v11

    if-ne v7, v11, :cond_10

    move v7, v11

    goto :goto_8

    :cond_10
    move v7, v4

    .line 3079
    :goto_8
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v12, "updateSpnDisplay: rawSpn = "

    invoke-virtual {v8, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {p0, v8}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 3080
    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v8

    const-string/jumbo v12, "wfc_carrier_name_override_by_pnn_bool"

    if-nez v8, :cond_13

    .line 3081
    invoke-static {v10}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_11

    .line 3084
    invoke-virtual {v10}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    new-array v3, v11, [Ljava/lang/Object;

    aput-object v1, v3, v4

    .line 3085
    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    move-object v3, v1

    move-object v10, v3

    :goto_9
    move v9, v4

    move v4, v11

    goto/16 :goto_f

    .line 3089
    :cond_11
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_18

    .line 3091
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 3092
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v1

    .line 3093
    iget-object v3, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v3, :cond_12

    invoke-virtual {v1, v12}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_12

    .line 3095
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/IccRecords;->getPnnHomeName()Ljava/lang/String;

    move-result-object v0

    :cond_12
    new-array v1, v11, [Ljava/lang/Object;

    aput-object v0, v1, v4

    .line 3097
    invoke-static {v2, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_b

    .line 3099
    :cond_13
    invoke-static {v10}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    const/4 v8, 0x3

    if-nez v2, :cond_15

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_15

    .line 3100
    invoke-static {v6}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_15

    .line 3105
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getState()I

    move-result v2

    if-ne v2, v8, :cond_14

    goto :goto_a

    :cond_14
    move-object v1, v5

    .line 3109
    :goto_a
    invoke-virtual {v10}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    new-array v3, v11, [Ljava/lang/Object;

    aput-object v2, v3, v4

    .line 3110
    invoke-static {v1, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    new-array v3, v11, [Ljava/lang/Object;

    aput-object v2, v3, v4

    .line 3111
    invoke-static {v6, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    move-object v3, v1

    move-object v10, v2

    goto :goto_9

    .line 3114
    :cond_15
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_17

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_17

    .line 3116
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 3118
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v1

    .line 3119
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    if-eqz v2, :cond_16

    invoke-virtual {v1, v12}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_16

    .line 3121
    iget-object v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mIccRecords:Lcom/android/internal/telephony/uicc/IccRecords;

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/IccRecords;->getPnnHomeName()Ljava/lang/String;

    move-result-object v0

    :cond_16
    new-array v1, v11, [Ljava/lang/Object;

    aput-object v0, v1, v4

    .line 3124
    invoke-static {v5, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_b

    .line 3125
    :cond_17
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getState()I

    move-result v1

    if-eq v1, v8, :cond_1f

    if-eqz v9, :cond_18

    .line 3126
    invoke-static {v10, v0}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_18

    goto/16 :goto_f

    :cond_18
    :goto_b
    move v4, v7

    move-object v3, v10

    goto/16 :goto_f

    .line 3132
    :cond_19
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getOperatorNameFromEri()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_1a

    .line 3133
    iget-object v2, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v2, v1}, Landroid/telephony/ServiceState;->setOperatorAlphaLong(Ljava/lang/String;)V

    .line 3136
    :cond_1a
    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->updateOperatorNameFromCarrierConfig()V

    .line 3139
    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getOperatorAlpha()Ljava/lang/String;

    move-result-object v1

    .line 3140
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v6, "updateSpnDisplay: cdma rawPlmn = "

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    if-eqz v1, :cond_1b

    move v2, v11

    goto :goto_c

    :cond_1b
    move v2, v4

    .line 3144
    :goto_c
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_1c

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_1c

    .line 3146
    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    new-array v6, v11, [Ljava/lang/Object;

    aput-object v1, v6, v4

    .line 3147
    invoke-static {v5, v6}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    goto :goto_d

    .line 3148
    :cond_1c
    iget-object v5, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-interface {v5}, Lcom/android/internal/telephony/CommandsInterface;->getRadioState()I

    move-result v5

    if-nez v5, :cond_1d

    .line 3152
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v6, "updateSpnDisplay: overwriting plmn from "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " to null as radio state is off"

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    move-object v1, v3

    :cond_1d
    :goto_d
    if-ne v0, v11, :cond_1e

    .line 3158
    invoke-static {}, Landroid/content/res/Resources;->getSystem()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0, v10}, Landroid/content/res/Resources;->getText(I)Ljava/lang/CharSequence;

    move-result-object v0

    .line 3159
    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    .line 3161
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v5, "updateSpnDisplay: radio is on but out of svc, set plmn=\'"

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    goto :goto_e

    :cond_1e
    move-object v0, v1

    :goto_e
    move v9, v2

    move-object v10, v3

    .line 3167
    :cond_1f
    :goto_f
    new-instance v1, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    invoke-direct {v1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;-><init>()V

    .line 3168
    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object v1

    .line 3169
    invoke-virtual {v1, v10}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setDataSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object v1

    .line 3170
    invoke-virtual {v1, v4}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowSpn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object v1

    .line 3171
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setPlmn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object v0

    .line 3172
    invoke-virtual {v0, v9}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowPlmn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object v0

    .line 3173
    invoke-virtual {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->build()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object v0

    .line 3167
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->notifySpnDisplayUpdate(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)V

    const-string/jumbo v0, "updateSpnDisplayLegacy-"

    .line 3174
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected useDataRegStateForDataOnlyDevices()V
    .locals 2
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 989
    iget-boolean v0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mVoiceCapable:Z

    if-nez v0, :cond_0

    .line 991
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "useDataRegStateForDataOnlyDevice: VoiceRegState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getState()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " DataRegState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    .line 992
    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 991
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ServiceStateTracker;->log(Ljava/lang/String;)V

    .line 995
    iget-object p0, p0, Lcom/android/internal/telephony/ServiceStateTracker;->mNewSS:Landroid/telephony/ServiceState;

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRegistrationState()I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/telephony/ServiceState;->setVoiceRegState(I)V

    :cond_0
    return-void
.end method
