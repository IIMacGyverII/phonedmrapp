.class public Lcom/android/internal/telephony/NetworkTypeController;
.super Lcom/android/internal/telephony/StateMachine;
.source "NetworkTypeController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;,
        Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;,
        Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;,
        Lcom/android/internal/telephony/NetworkTypeController$IdleState;,
        Lcom/android/internal/telephony/NetworkTypeController$LegacyState;,
        Lcom/android/internal/telephony/NetworkTypeController$DefaultState;
    }
.end annotation


# static fields
.field private static final ALL_STATES:[Ljava/lang/String;

.field private static final DBG:Z = true

.field private static final EVENT_BANDWIDTH_CHANGED:I = 0xf

.field private static final EVENT_CARRIER_CONFIG_CHANGED:I = 0x7

.field protected static final EVENT_DATA_RAT_CHANGED:I = 0x2

.field private static final EVENT_DEVICE_IDLE_MODE_CHANGED:I = 0x11

.field private static final EVENT_INITIALIZE:I = 0xc

.field private static final EVENT_NR_FREQUENCY_CHANGED:I = 0x4

.field private static final EVENT_NR_STATE_CHANGED:I = 0x3

.field private static final EVENT_PCO_DATA_CHANGED:I = 0xe

.field private static final EVENT_PHYSICAL_CHANNEL_CONFIG_CHANGED:I = 0xd

.field private static final EVENT_PHYSICAL_CHANNEL_CONFIG_NOTIF_CHANGED:I = 0x6

.field private static final EVENT_PHYSICAL_LINK_STATUS_CHANGED:I = 0x5

.field private static final EVENT_PREFERRED_NETWORK_MODE_CHANGED:I = 0xb

.field private static final EVENT_PRIMARY_TIMER_EXPIRED:I = 0x8

.field public static final EVENT_QUIT:I = 0x1

.field private static final EVENT_RADIO_OFF_OR_UNAVAILABLE:I = 0xa

.field private static final EVENT_SECONDARY_TIMER_EXPIRED:I = 0x9

.field public static final EVENT_UPDATE:I = 0x0

.field private static final EVENT_UPDATE_NR_ADVANCED_STATE:I = 0x10

.field private static final ICON_5G:Ljava/lang/String; = "5g"

.field private static final ICON_5G_PLUS:Ljava/lang/String; = "5g_plus"

.field private static final STATE_ANY:Ljava/lang/String; = "any"

.field private static final STATE_CONNECTED:Ljava/lang/String; = "connected"

.field private static final STATE_CONNECTED_NR_ADVANCED:Ljava/lang/String; = "connected_mmwave"

.field private static final STATE_LEGACY:Ljava/lang/String; = "legacy"

.field private static final STATE_NOT_RESTRICTED_RRC_CON:Ljava/lang/String; = "not_restricted_rrc_con"

.field private static final STATE_NOT_RESTRICTED_RRC_IDLE:Ljava/lang/String; = "not_restricted_rrc_idle"

.field private static final STATE_RESTRICTED:Ljava/lang/String; = "restricted"

.field private static final TAG:Ljava/lang/String; = "NetworkTypeController"

.field private static final sEvents:[Ljava/lang/String;


# instance fields
.field protected mAdditionalNrAdvancedBandsList:[I

.field private final mDefaultState:Lcom/android/internal/telephony/NetworkTypeController$DefaultState;

.field private final mDisplayInfoController:Lcom/android/internal/telephony/DisplayInfoController;

.field private mEnableNrAdvancedWhileRoaming:Z

.field private final mIdleState:Lcom/android/internal/telephony/NetworkTypeController$IdleState;

.field private final mIntentReceiver:Landroid/content/BroadcastReceiver;

.field private mIsDeviceIdleMode:Z

.field private mIsNrAdvancedAllowedByPco:Z

.field private mIsPhysicalChannelConfig16Supported:Z

.field private mIsPhysicalChannelConfigOn:Z

.field private mIsPrimaryTimerActive:Z

.field private mIsSecondaryTimerActive:Z

.field private mIsTimerResetEnabledForLegacyStateRRCIdle:Z

.field private mIsUsingUserDataForRrcDetection:Z

.field private final mLegacyState:Lcom/android/internal/telephony/NetworkTypeController$LegacyState;

.field private final mLteConnectedState:Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;

.field private mLteEnhancedPattern:Ljava/lang/String;

.field private mLtePlusThresholdBandwidth:I

.field private mNrAdvancedCapablePcoId:I

.field private mNrAdvancedThresholdBandwidth:I

.field private final mNrConnectedState:Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;

.field private mOverrideNetworkType:I

.field private mOverrideTimerRules:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;",
            ">;"
        }
    .end annotation
.end field

.field protected final mPhone:Lcom/android/internal/telephony/Phone;

.field private mPhysicalLinkStatus:I

.field private mPreviousState:Ljava/lang/String;

.field private mPrimaryTimerState:Ljava/lang/String;

.field private mSecondaryTimerState:Ljava/lang/String;


# direct methods
.method static bridge synthetic -$$Nest$fgetmIdleState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$IdleState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIdleState:Lcom/android/internal/telephony/NetworkTypeController$IdleState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmIsDeviceIdleMode(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsDeviceIdleMode:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmIsPhysicalChannelConfigOn(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfigOn:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmIsPrimaryTimerActive(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmIsSecondaryTimerActive(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmIsTimerResetEnabledForLegacyStateRRCIdle(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    iget-boolean p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsTimerResetEnabledForLegacyStateRRCIdle:Z

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmLegacyState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$LegacyState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLegacyState:Lcom/android/internal/telephony/NetworkTypeController$LegacyState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmLteConnectedState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteConnectedState:Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmNrAdvancedCapablePcoId(Lcom/android/internal/telephony/NetworkTypeController;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedCapablePcoId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$fgetmNrConnectedState(Lcom/android/internal/telephony/NetworkTypeController;)Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrConnectedState:Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmPrimaryTimerState(Lcom/android/internal/telephony/NetworkTypeController;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPrimaryTimerState:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSecondaryTimerState(Lcom/android/internal/telephony/NetworkTypeController;)Ljava/lang/String;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mSecondaryTimerState:Ljava/lang/String;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputmIsDeviceIdleMode(Lcom/android/internal/telephony/NetworkTypeController;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsDeviceIdleMode:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmIsNrAdvancedAllowedByPco(Lcom/android/internal/telephony/NetworkTypeController;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsNrAdvancedAllowedByPco:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmIsPhysicalChannelConfigOn(Lcom/android/internal/telephony/NetworkTypeController;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfigOn:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmIsSecondaryTimerActive(Lcom/android/internal/telephony/NetworkTypeController;Z)V
    .locals 0

    iput-boolean p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmPhysicalLinkStatus(Lcom/android/internal/telephony/NetworkTypeController;I)V
    .locals 0

    iput p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhysicalLinkStatus:I

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmPreviousState(Lcom/android/internal/telephony/NetworkTypeController;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputmSecondaryTimerState(Lcom/android/internal/telephony/NetworkTypeController;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mSecondaryTimerState:Ljava/lang/String;

    return-void
.end method

.method static bridge synthetic -$$Nest$mgetDataNetworkType(Lcom/android/internal/telephony/NetworkTypeController;)I
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getDataNetworkType()I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mgetEventName(Lcom/android/internal/telephony/NetworkTypeController;I)Ljava/lang/String;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkTypeController;->getEventName(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static bridge synthetic -$$Nest$mgetPhysicalLinkStatusFromPhysicalChannelConfig(Lcom/android/internal/telephony/NetworkTypeController;)I
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getPhysicalLinkStatusFromPhysicalChannelConfig()I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misLte(Lcom/android/internal/telephony/NetworkTypeController;I)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkTypeController;->isLte(I)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misNrAdvanced(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrAdvanced()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misNrConnected(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrConnected()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misNrNotRestricted(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrNotRestricted()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misNrRestricted(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrRestricted()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misPhysicalLinkActive(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isPhysicalLinkActive()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$misUsingPhysicalChannelConfigForRrcDetection(Lcom/android/internal/telephony/NetworkTypeController;)Z
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isUsingPhysicalChannelConfigForRrcDetection()Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$mparseCarrierConfigs(Lcom/android/internal/telephony/NetworkTypeController;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->parseCarrierConfigs()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mresetAllTimers(Lcom/android/internal/telephony/NetworkTypeController;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->resetAllTimers()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtransitionToCurrentState(Lcom/android/internal/telephony/NetworkTypeController;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->transitionToCurrentState()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtransitionWithSecondaryTimerTo(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/IState;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkTypeController;->transitionWithSecondaryTimerTo(Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mtransitionWithTimerTo(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/IState;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/NetworkTypeController;->transitionWithTimerTo(Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mupdateTimers(Lcom/android/internal/telephony/NetworkTypeController;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->updateTimers()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 6

    const-string v0, "connected_mmwave"

    const-string v1, "connected"

    const-string v2, "not_restricted_rrc_idle"

    const-string v3, "not_restricted_rrc_con"

    const-string v4, "restricted"

    const-string v5, "legacy"

    .line 82
    filled-new-array/range {v0 .. v5}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/NetworkTypeController;->ALL_STATES:[Ljava/lang/String;

    const/16 v0, 0x12

    new-array v0, v0, [Ljava/lang/String;

    .line 109
    sput-object v0, Lcom/android/internal/telephony/NetworkTypeController;->sEvents:[Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "EVENT_UPDATE"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "EVENT_QUIT"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "EVENT_DATA_RAT_CHANGED"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "EVENT_NR_STATE_CHANGED"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "EVENT_NR_FREQUENCY_CHANGED"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, "EVENT_PHYSICAL_LINK_STATUS_CHANGED"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "EVENT_PHYSICAL_CHANNEL_CONFIG_NOTIF_CHANGED"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "EVENT_CARRIER_CONFIG_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "EVENT_PRIMARY_TIMER_EXPIRED"

    aput-object v2, v0, v1

    const/16 v1, 0x9

    const-string v2, "EVENT_SECONDARY_TIMER_EXPIRED"

    aput-object v2, v0, v1

    const/16 v1, 0xa

    const-string v2, "EVENT_RADIO_OFF_OR_UNAVAILABLE"

    aput-object v2, v0, v1

    const/16 v1, 0xb

    const-string v2, "EVENT_PREFERRED_NETWORK_MODE_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0xc

    const-string v2, "EVENT_INITIALIZE"

    aput-object v2, v0, v1

    const/16 v1, 0xd

    const-string v2, "EVENT_PHYSICAL_CHANNEL_CONFIG_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0xe

    const-string v2, "EVENT_PCO_DATA_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0xf

    const-string v2, "EVENT_BANDWIDTH_CHANGED"

    aput-object v2, v0, v1

    const/16 v1, 0x10

    const-string v2, "EVENT_UPDATE_NR_ADVANCED_STATE"

    aput-object v2, v0, v1

    const/16 v1, 0x11

    const-string v2, "EVENT_DEVICE_IDLE_MODE_CHANGED"

    aput-object v2, v0, v1

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/DisplayInfoController;)V
    .locals 8

    const-string v0, "NetworkTypeController"

    .line 185
    invoke-direct {p0, v0, p2}, Lcom/android/internal/telephony/StateMachine;-><init>(Ljava/lang/String;Landroid/os/Handler;)V

    .line 136
    new-instance v0, Lcom/android/internal/telephony/NetworkTypeController$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/NetworkTypeController$1;-><init>(Lcom/android/internal/telephony/NetworkTypeController;)V

    iput-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    .line 155
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideTimerRules:Ljava/util/Map;

    const-string v0, ""

    .line 156
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteEnhancedPattern:Ljava/lang/String;

    const/4 v0, 0x0

    .line 172
    iput-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsNrAdvancedAllowedByPco:Z

    .line 173
    iput v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedCapablePcoId:I

    .line 174
    iput-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsUsingUserDataForRrcDetection:Z

    const/4 v1, 0x1

    .line 175
    iput-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mEnableNrAdvancedWhileRoaming:Z

    .line 176
    iput-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsDeviceIdleMode:Z

    .line 652
    new-instance v2, Lcom/android/internal/telephony/NetworkTypeController$DefaultState;

    const/4 v3, 0x0

    invoke-direct {v2, p0, v3}, Lcom/android/internal/telephony/NetworkTypeController$DefaultState;-><init>(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/NetworkTypeController$DefaultState-IA;)V

    iput-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mDefaultState:Lcom/android/internal/telephony/NetworkTypeController$DefaultState;

    .line 748
    new-instance v4, Lcom/android/internal/telephony/NetworkTypeController$LegacyState;

    invoke-direct {v4, p0, v3}, Lcom/android/internal/telephony/NetworkTypeController$LegacyState;-><init>(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/NetworkTypeController$LegacyState-IA;)V

    iput-object v4, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLegacyState:Lcom/android/internal/telephony/NetworkTypeController$LegacyState;

    .line 832
    new-instance v5, Lcom/android/internal/telephony/NetworkTypeController$IdleState;

    invoke-direct {v5, p0, v3}, Lcom/android/internal/telephony/NetworkTypeController$IdleState;-><init>(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/NetworkTypeController$IdleState-IA;)V

    iput-object v5, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIdleState:Lcom/android/internal/telephony/NetworkTypeController$IdleState;

    .line 916
    new-instance v6, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;

    invoke-direct {v6, p0, v3}, Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;-><init>(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState-IA;)V

    iput-object v6, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteConnectedState:Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;

    .line 1043
    new-instance v7, Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;

    invoke-direct {v7, p0, v3}, Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;-><init>(Lcom/android/internal/telephony/NetworkTypeController;Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState-IA;)V

    iput-object v7, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrConnectedState:Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;

    .line 186
    iput-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 187
    iput-object p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mDisplayInfoController:Lcom/android/internal/telephony/DisplayInfoController;

    .line 188
    iput v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideNetworkType:I

    .line 189
    iput-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfigOn:Z

    .line 190
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;)V

    .line 191
    invoke-virtual {p0, v4, v2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 192
    invoke-virtual {p0, v5, v2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 193
    invoke-virtual {p0, v6, v2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 194
    invoke-virtual {p0, v7, v2}, Lcom/android/internal/telephony/StateMachine;->addState(Lcom/android/internal/telephony/State;Lcom/android/internal/telephony/State;)V

    .line 195
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/StateMachine;->setInitialState(Lcom/android/internal/telephony/State;)V

    .line 196
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->start()V

    const/16 p1, 0xc

    .line 197
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->sendMessage(I)V

    return-void
.end method

.method private createTimerRules(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 16

    move-object/from16 v0, p0

    .line 356
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    .line 357
    invoke-static/range {p1 .. p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    const/4 v3, 0x3

    const/4 v4, 0x2

    const-string v5, ","

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-nez v2, :cond_3

    .line 359
    invoke-virtual/range {p1 .. p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    array-length v8, v2

    move v9, v7

    :goto_0
    if-ge v9, v8, :cond_3

    aget-object v10, v2, v9

    .line 360
    invoke-virtual {v10}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v11

    const-string v12, ":"

    invoke-virtual {v11, v12}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v11

    .line 361
    array-length v12, v11

    if-eq v12, v4, :cond_0

    .line 362
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Invalid 5G icon configuration, config = "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Lcom/android/internal/telephony/NetworkTypeController;->loge(Ljava/lang/String;)V

    goto :goto_2

    .line 366
    :cond_0
    aget-object v10, v11, v6

    const-string v12, "5g"

    invoke-virtual {v10, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_1

    move v10, v3

    goto :goto_1

    .line 368
    :cond_1
    aget-object v10, v11, v6

    const-string v12, "5g_plus"

    invoke-virtual {v10, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_2

    const/4 v10, 0x5

    goto :goto_1

    .line 371
    :cond_2
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Invalid 5G icon = "

    invoke-virtual {v10, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    aget-object v12, v11, v6

    invoke-virtual {v10, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v0, v10}, Lcom/android/internal/telephony/NetworkTypeController;->loge(Ljava/lang/String;)V

    move v10, v7

    .line 373
    :goto_1
    aget-object v11, v11, v7

    new-instance v12, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;

    invoke-direct {v12, v11, v10}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;-><init>(Ljava/lang/String;I)V

    invoke-interface {v1, v11, v12}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_2
    add-int/lit8 v9, v9, 0x1

    goto :goto_0

    .line 377
    :cond_3
    sget-object v2, Lcom/android/internal/telephony/NetworkTypeController;->ALL_STATES:[Ljava/lang/String;

    array-length v8, v2

    move v9, v7

    :goto_3
    if-ge v9, v8, :cond_5

    aget-object v10, v2, v9

    .line 378
    invoke-interface {v1, v10}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v11

    if-nez v11, :cond_4

    .line 379
    new-instance v11, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;

    invoke-direct {v11, v10, v7}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;-><init>(Ljava/lang/String;I)V

    invoke-interface {v1, v10, v11}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_4
    add-int/lit8 v9, v9, 0x1

    goto :goto_3

    .line 384
    :cond_5
    invoke-static/range {p2 .. p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    const-string v8, "any"

    const-string v9, ";"

    if-nez v2, :cond_9

    .line 386
    invoke-virtual/range {p2 .. p2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v9}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    array-length v10, v2

    move v11, v7

    :goto_4
    if-ge v11, v10, :cond_9

    aget-object v12, v2, v11

    .line 387
    invoke-virtual {v12}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v13, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v13

    .line 388
    array-length v14, v13

    if-eq v14, v3, :cond_6

    .line 389
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    const-string v14, "Invalid 5G icon timer configuration, config = "

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v0, v12}, Lcom/android/internal/telephony/NetworkTypeController;->loge(Ljava/lang/String;)V

    goto :goto_6

    .line 394
    :cond_6
    :try_start_0
    aget-object v12, v13, v4

    invoke-static {v12}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v12
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    .line 398
    aget-object v14, v13, v7

    invoke-virtual {v14, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v14

    if-eqz v14, :cond_7

    .line 399
    sget-object v14, Lcom/android/internal/telephony/NetworkTypeController;->ALL_STATES:[Ljava/lang/String;

    array-length v15, v14

    move v4, v7

    :goto_5
    if-ge v4, v15, :cond_8

    aget-object v3, v14, v4

    .line 400
    invoke-interface {v1, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;

    .line 401
    aget-object v7, v13, v6

    invoke-virtual {v3, v7, v12}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;->addTimer(Ljava/lang/String;I)V

    add-int/lit8 v4, v4, 0x1

    const/4 v3, 0x3

    const/4 v7, 0x0

    goto :goto_5

    :cond_7
    move v3, v7

    .line 404
    aget-object v4, v13, v3

    invoke-interface {v1, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;

    .line 405
    aget-object v4, v13, v6

    invoke-virtual {v3, v4, v12}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;->addTimer(Ljava/lang/String;I)V

    :catch_0
    :cond_8
    :goto_6
    add-int/lit8 v11, v11, 0x1

    const/4 v3, 0x3

    const/4 v4, 0x2

    const/4 v7, 0x0

    goto :goto_4

    .line 410
    :cond_9
    invoke-static/range {p3 .. p3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_d

    .line 412
    invoke-virtual/range {p3 .. p3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, v9}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    array-length v3, v2

    const/4 v4, 0x0

    :goto_7
    if-ge v4, v3, :cond_d

    aget-object v7, v2, v4

    .line 413
    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v9

    .line 414
    array-length v10, v9

    const/4 v11, 0x3

    if-eq v10, v11, :cond_b

    .line 416
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    const-string v10, "Invalid 5G icon secondary timer configuration, config = "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v0, v7}, Lcom/android/internal/telephony/NetworkTypeController;->loge(Ljava/lang/String;)V

    :catch_1
    :cond_a
    const/4 v7, 0x0

    goto :goto_9

    :cond_b
    const/4 v7, 0x2

    .line 422
    :try_start_1
    aget-object v10, v9, v7

    invoke-static {v10}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v10
    :try_end_1
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_1} :catch_1

    const/4 v12, 0x0

    .line 426
    aget-object v13, v9, v12

    invoke-virtual {v13, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v12

    if-eqz v12, :cond_c

    .line 427
    sget-object v12, Lcom/android/internal/telephony/NetworkTypeController;->ALL_STATES:[Ljava/lang/String;

    array-length v13, v12

    const/4 v14, 0x0

    :goto_8
    if-ge v14, v13, :cond_a

    aget-object v15, v12, v14

    .line 428
    invoke-interface {v1, v15}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;

    .line 429
    aget-object v7, v9, v6

    invoke-virtual {v15, v7, v10}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;->addSecondaryTimer(Ljava/lang/String;I)V

    add-int/lit8 v14, v14, 0x1

    const/4 v7, 0x2

    goto :goto_8

    :cond_c
    const/4 v7, 0x0

    .line 432
    aget-object v12, v9, v7

    invoke-interface {v1, v12}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;

    .line 433
    aget-object v9, v9, v6

    invoke-virtual {v12, v9, v10}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;->addSecondaryTimer(Ljava/lang/String;I)V

    :goto_9
    add-int/lit8 v4, v4, 0x1

    goto :goto_7

    .line 438
    :cond_d
    iput-object v1, v0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideTimerRules:Ljava/util/Map;

    .line 439
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mOverrideTimerRules: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, v0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideTimerRules:Ljava/util/Map;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    return-void
.end method

.method private getDataNetworkType()I
    .locals 2

    .line 1324
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    const/4 v0, 0x2

    const/4 v1, 0x1

    invoke-virtual {p0, v0, v1}, Landroid/telephony/ServiceState;->getNetworkRegistrationInfo(II)Landroid/telephony/NetworkRegistrationInfo;

    move-result-object p0

    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    .line 1327
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/NetworkRegistrationInfo;->getAccessNetworkTechnology()I

    move-result p0

    :goto_0
    return p0
.end method

.method private getEventName(I)Ljava/lang/String;
    .locals 0

    .line 1332
    :try_start_0
    sget-object p0, Lcom/android/internal/telephony/NetworkTypeController;->sEvents:[Ljava/lang/String;

    aget-object p0, p0, p1
    :try_end_0
    .catch Ljava/lang/ArrayIndexOutOfBoundsException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    const-string p0, "EVENT_NOT_DEFINED"

    return-object p0
.end method

.method private getLteDisplayType()I
    .locals 2

    .line 519
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getDataNetworkType()I

    move-result v0

    const/16 v1, 0x13

    if-eq v0, v1, :cond_0

    .line 522
    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isUsingLteCarrierAggregation()Z

    move-result v0

    if-eqz v0, :cond_1

    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 523
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getCellBandwidths()[I

    move-result-object v0

    invoke-static {v0}, Ljava/util/stream/IntStream;->of([I)Ljava/util/stream/IntStream;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/stream/IntStream;->sum()I

    move-result v0

    iget v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLtePlusThresholdBandwidth:I

    if-le v0, v1, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    .line 527
    :goto_0
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isLteEnhancedAvailable()Z

    move-result p0

    if-eqz p0, :cond_2

    const/4 v0, 0x2

    :cond_2
    return v0
.end method

.method private getNrDisplayType(Z)I
    .locals 4

    .line 479
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCachedAllowedNetworkTypesBitmask()I

    move-result v0

    int-to-long v0, v0

    const-wide/32 v2, 0x80000

    and-long/2addr v0, v2

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 484
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const-string v2, "connected_mmwave"

    if-eqz p1, :cond_1

    .line 486
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrAdvanced()Z

    move-result p1

    if-eqz p1, :cond_7

    .line 487
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 490
    :cond_1
    iget-object p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/ServiceState;->getNrState()I

    move-result p1

    const/4 v3, 0x1

    if-eq p1, v3, :cond_6

    const/4 v3, 0x2

    if-eq p1, v3, :cond_4

    const/4 v3, 0x3

    if-eq p1, v3, :cond_2

    goto :goto_1

    .line 492
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrAdvanced()Z

    move-result p1

    if-eqz p1, :cond_3

    .line 493
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_3
    const-string p1, "connected"

    .line 495
    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 498
    :cond_4
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isPhysicalLinkActive()Z

    move-result p1

    if-eqz p1, :cond_5

    const-string p1, "not_restricted_rrc_con"

    goto :goto_0

    :cond_5
    const-string p1, "not_restricted_rrc_idle"

    :goto_0
    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    :cond_6
    const-string p1, "restricted"

    .line 502
    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 507
    :cond_7
    :goto_1
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_8
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_9

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 508
    iget-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideTimerRules:Ljava/util/Map;

    invoke-interface {v2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;

    if-eqz v0, :cond_8

    .line 509
    iget v0, v0, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;->mOverrideType:I

    if-eqz v0, :cond_8

    return v0

    :cond_9
    return v1
.end method

.method private getPhysicalLinkStatusFromPhysicalChannelConfig()I
    .locals 0

    .line 1317
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1318
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getPhysicalChannelConfigList()Ljava/util/List;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 1319
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x2

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method private isLte(I)Z
    .locals 0

    const/16 p0, 0xd

    if-eq p1, p0, :cond_1

    const/16 p0, 0x13

    if-ne p1, p0, :cond_0

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

.method private isLteEnhancedAvailable()Z
    .locals 7

    .line 534
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteEnhancedPattern:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    return v1

    .line 537
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteEnhancedPattern:Ljava/lang/String;

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    const/4 v2, 0x2

    new-array v3, v2, [Ljava/lang/String;

    .line 538
    iget-object v4, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v4}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v4

    invoke-virtual {v4}, Landroid/telephony/ServiceState;->getOperatorAlphaLongRaw()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v3, v1

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 539
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getOperatorAlphaShortRaw()Ljava/lang/String;

    move-result-object p0

    const/4 v4, 0x1

    aput-object p0, v3, v4

    move p0, v1

    :goto_0
    if-ge p0, v2, :cond_2

    .line 538
    aget-object v5, v3, p0

    .line 540
    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_1

    .line 541
    invoke-virtual {v0, v5}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v5

    .line 542
    invoke-virtual {v5}, Ljava/util/regex/Matcher;->find()Z

    move-result v5

    if-eqz v5, :cond_1

    return v4

    :cond_1
    add-int/lit8 p0, p0, 0x1

    goto :goto_0

    :cond_2
    return v1
.end method

.method private isNrAdvanced()Z
    .locals 3

    .line 1261
    iget v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedCapablePcoId:I

    const/4 v1, 0x0

    if-lez v0, :cond_0

    iget-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsNrAdvancedAllowedByPco:Z

    if-nez v0, :cond_0

    return v1

    .line 1267
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mEnableNrAdvancedWhileRoaming:Z

    if-nez v0, :cond_1

    return v1

    .line 1273
    :cond_1
    iget v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedThresholdBandwidth:I

    if-lez v0, :cond_2

    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1274
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getCellBandwidths()[I

    move-result-object v0

    invoke-static {v0}, Ljava/util/stream/IntStream;->of([I)Ljava/util/stream/IntStream;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/stream/IntStream;->sum()I

    move-result v0

    iget v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedThresholdBandwidth:I

    if-ge v0, v2, :cond_2

    return v1

    .line 1281
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrMmwave()Z

    move-result v0

    if-nez v0, :cond_3

    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isAdditionalNrAdvancedBand()Z

    move-result p0

    if-eqz p0, :cond_4

    :cond_3
    const/4 v1, 0x1

    :cond_4
    return v1
.end method

.method private isNrConnected()Z
    .locals 1

    .line 1242
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

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

.method private isNrMmwave()Z
    .locals 1

    .line 1285
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getNrFrequencyRange()I

    move-result p0

    const/4 v0, 0x4

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isNrNotRestricted()Z
    .locals 1

    .line 1246
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getNrState()I

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

.method private isNrRestricted()Z
    .locals 1

    .line 1251
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getNrState()I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private isPhysicalLinkActive()Z
    .locals 1

    .line 1313
    iget p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhysicalLinkStatus:I

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private isUsingPhysicalChannelConfigForRrcDetection()Z
    .locals 1

    .line 1339
    iget-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfig16Supported:Z

    if-eqz v0, :cond_0

    iget-boolean p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsUsingUserDataForRrcDetection:Z

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private parseCarrierConfigs()V
    .locals 13

    .line 263
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    const-string v1, "5g_icon_configuration_string"

    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 265
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v2

    const-string v3, "5g_icon_display_grace_period_string"

    invoke-virtual {v2, v3}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 267
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v4

    const-string v5, "5g_icon_display_secondary_grace_period_string"

    invoke-virtual {v4, v5}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 269
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v6

    const-string/jumbo v7, "show_carrier_data_icon_pattern_string"

    invoke-virtual {v6, v7}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    iput-object v6, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteEnhancedPattern:Ljava/lang/String;

    .line 272
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v6

    const-string v8, "nr_timers_reset_if_non_endc_and_rrc_idle_bool"

    invoke-virtual {v6, v8}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v6

    iput-boolean v6, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsTimerResetEnabledForLegacyStateRRCIdle:Z

    .line 274
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v6

    const-string v9, "lte_plus_threshold_bandwidth_khz_int"

    invoke-virtual {v6, v9}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v6

    iput v6, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLtePlusThresholdBandwidth:I

    .line 276
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v6

    const-string v10, "nr_advanced_threshold_bandwidth_khz_int"

    invoke-virtual {v6, v10}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v6

    iput v6, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedThresholdBandwidth:I

    .line 278
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object v6

    const-string v11, "enable_nr_advanced_for_roaming_bool"

    invoke-virtual {v6, v11}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v6

    iput-boolean v6, p0, Lcom/android/internal/telephony/NetworkTypeController;->mEnableNrAdvancedWhileRoaming:Z

    .line 281
    iget-object v6, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v6}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v6

    const-string v12, "carrier_config"

    .line 282
    invoke-virtual {v6, v12}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Landroid/telephony/CarrierConfigManager;

    if-eqz v6, :cond_7

    .line 284
    iget-object v12, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v12}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v12

    invoke-virtual {v6, v12}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object v6

    if-eqz v6, :cond_7

    .line 286
    invoke-virtual {v6, v1}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    if-eqz v12, :cond_0

    .line 287
    invoke-virtual {v6, v1}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 290
    :cond_0
    invoke-virtual {v6, v3}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 292
    invoke-virtual {v6, v3}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 295
    :cond_1
    invoke-virtual {v6, v5}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_2

    .line 297
    invoke-virtual {v6, v5}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 300
    :cond_2
    invoke-virtual {v6, v7}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_3

    .line 302
    invoke-virtual {v6, v7}, Landroid/os/PersistableBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteEnhancedPattern:Ljava/lang/String;

    .line 305
    :cond_3
    invoke-virtual {v6, v8}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    iput-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsTimerResetEnabledForLegacyStateRRCIdle:Z

    .line 307
    iget v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLtePlusThresholdBandwidth:I

    invoke-virtual {v6, v9, v1}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;I)I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLtePlusThresholdBandwidth:I

    .line 310
    iget v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedThresholdBandwidth:I

    invoke-virtual {v6, v10, v1}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;I)I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedThresholdBandwidth:I

    const-string v1, "additional_nr_advanced_bands_int_array"

    .line 313
    invoke-virtual {v6, v1}, Landroid/os/PersistableBundle;->getIntArray(Ljava/lang/String;)[I

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mAdditionalNrAdvancedBandsList:[I

    const-string v1, "nr_advanced_capable_pco_id_int"

    .line 315
    invoke-virtual {v6, v1}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedCapablePcoId:I

    if-lez v1, :cond_4

    .line 317
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v1

    if-eqz v1, :cond_4

    .line 318
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object v1

    new-instance v3, Lcom/android/internal/telephony/NetworkTypeController$2;

    .line 319
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v5

    invoke-static {v5}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v7, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;

    invoke-direct {v7, v5}, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;-><init>(Landroid/os/Handler;)V

    invoke-direct {v3, p0, v7}, Lcom/android/internal/telephony/NetworkTypeController$2;-><init>(Lcom/android/internal/telephony/NetworkTypeController;Ljava/util/concurrent/Executor;)V

    .line 318
    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->registerDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    .line 329
    :cond_4
    invoke-virtual {v6, v11}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    iput-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mEnableNrAdvancedWhileRoaming:Z

    const-string v1, "lte_endc_using_user_data_for_rrc_detection_bool"

    .line 331
    invoke-virtual {v6, v1}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    iput-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsUsingUserDataForRrcDetection:Z

    .line 333
    iget-boolean v3, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfig16Supported:Z

    if-eqz v3, :cond_5

    if-eqz v1, :cond_7

    .line 334
    :cond_5
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v1

    if-eqz v1, :cond_6

    .line 335
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getDataNetworkController()Lcom/android/internal/telephony/data/DataNetworkController;

    move-result-object v1

    new-instance v3, Lcom/android/internal/telephony/NetworkTypeController$3;

    .line 336
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v5

    invoke-static {v5}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v6, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;

    invoke-direct {v6, v5}, Landroidx/emoji2/text/ConcurrencyHelpers$$ExternalSyntheticLambda1;-><init>(Landroid/os/Handler;)V

    invoke-direct {v3, p0, v6}, Lcom/android/internal/telephony/NetworkTypeController$3;-><init>(Lcom/android/internal/telephony/NetworkTypeController;Ljava/util/concurrent/Executor;)V

    .line 335
    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/data/DataNetworkController;->registerDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    goto :goto_0

    .line 345
    :cond_6
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    const/4 v3, 0x1

    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/Phone;->getDcTracker(I)Lcom/android/internal/telephony/dataconnection/DcTracker;

    move-result-object v1

    .line 346
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v3

    const/4 v5, 0x5

    invoke-virtual {v1, v3, v5}, Lcom/android/internal/telephony/dataconnection/DcTracker;->registerForPhysicalLinkStatusChanged(Landroid/os/Handler;I)V

    .line 352
    :cond_7
    :goto_0
    invoke-direct {p0, v0, v2, v4}, Lcom/android/internal/telephony/NetworkTypeController;->createTimerRules(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private resetAllTimers()V
    .locals 1

    const/16 v0, 0x8

    .line 1151
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    const/16 v0, 0x9

    .line 1152
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    const/4 v0, 0x0

    .line 1153
    iput-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    .line 1154
    iput-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    const-string v0, ""

    .line 1155
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPrimaryTimerState:Ljava/lang/String;

    .line 1156
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mSecondaryTimerState:Ljava/lang/String;

    return-void
.end method

.method private transitionToCurrentState()V
    .locals 2

    .line 1080
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getDataNetworkType()I

    move-result v0

    const/16 v1, 0x14

    if-eq v0, v1, :cond_4

    .line 1082
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrConnected()Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_1

    .line 1085
    :cond_0
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkTypeController;->isLte(I)Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrNotRestricted()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1086
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isPhysicalLinkActive()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1087
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteConnectedState:Lcom/android/internal/telephony/NetworkTypeController$LteConnectedState;

    const-string v1, "not_restricted_rrc_con"

    .line 1088
    iput-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    goto :goto_3

    .line 1090
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIdleState:Lcom/android/internal/telephony/NetworkTypeController$IdleState;

    const-string v1, "not_restricted_rrc_idle"

    .line 1091
    iput-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    goto :goto_3

    .line 1094
    :cond_2
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLegacyState:Lcom/android/internal/telephony/NetworkTypeController$LegacyState;

    .line 1095
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrRestricted()Z

    move-result v1

    if-eqz v1, :cond_3

    const-string v1, "restricted"

    goto :goto_0

    :cond_3
    const-string v1, "legacy"

    :goto_0
    iput-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    goto :goto_3

    .line 1083
    :cond_4
    :goto_1
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrConnectedState:Lcom/android/internal/telephony/NetworkTypeController$NrConnectedState;

    .line 1084
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrAdvanced()Z

    move-result v1

    if-eqz v1, :cond_5

    const-string v1, "connected_mmwave"

    goto :goto_2

    :cond_5
    const-string v1, "connected"

    :goto_2
    iput-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    .line 1097
    :goto_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_6

    .line 1098
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    goto :goto_4

    .line 1100
    :cond_6
    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkTypeController;->updateOverrideNetworkType()V

    :goto_4
    return-void
.end method

.method private transitionWithSecondaryTimerTo(Lcom/android/internal/telephony/IState;)V
    .locals 5

    .line 1061
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    invoke-interface {v0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object v0

    .line 1062
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideTimerRules:Ljava/util/Map;

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPrimaryTimerState:Ljava/lang/String;

    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;

    .line 1064
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Transition with secondary timer from "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " to "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1065
    invoke-interface {p1}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 1064
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 1067
    iget-boolean v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsDeviceIdleMode:Z

    if-nez v2, :cond_0

    if-eqz v1, :cond_0

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;->getSecondaryTimer(Ljava/lang/String;)I

    move-result v2

    if-lez v2, :cond_0

    .line 1068
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;->getSecondaryTimer(Ljava/lang/String;)I

    move-result v1

    .line 1069
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, "s secondary timer started for state: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 1070
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mSecondaryTimerState:Ljava/lang/String;

    .line 1071
    iput-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    const/4 v0, 0x1

    .line 1072
    iput-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    const/16 v0, 0x9

    int-to-long v1, v1

    const-wide/16 v3, 0x3e8

    mul-long/2addr v1, v3

    .line 1073
    invoke-virtual {p0, v0, p1, v1, v2}, Lcom/android/internal/telephony/StateMachine;->sendMessageDelayed(ILjava/lang/Object;J)V

    :cond_0
    const/4 p1, 0x0

    .line 1075
    iput-boolean p1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    .line 1076
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method private transitionWithTimerTo(Lcom/android/internal/telephony/IState;)V
    .locals 6

    .line 1046
    invoke-interface {p1}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object v0

    .line 1047
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Transition with primary timer from "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " to "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 1048
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideTimerRules:Ljava/util/Map;

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;

    .line 1049
    iget-boolean v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsDeviceIdleMode:Z

    if-nez v2, :cond_0

    if-eqz v1, :cond_0

    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;->getTimer(Ljava/lang/String;)I

    move-result v2

    if-lez v2, :cond_0

    .line 1050
    invoke-virtual {v1, v0}, Lcom/android/internal/telephony/NetworkTypeController$OverrideTimerRule;->getTimer(Ljava/lang/String;)I

    move-result v0

    .line 1051
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "s primary timer started for state: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 1052
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    iput-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPrimaryTimerState:Ljava/lang/String;

    .line 1053
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v1

    invoke-interface {v1}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    const/4 v1, 0x1

    .line 1054
    iput-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    const/16 v1, 0x8

    int-to-long v2, v0

    const-wide/16 v4, 0x3e8

    mul-long/2addr v2, v4

    .line 1055
    invoke-virtual {p0, v1, p1, v2, v3}, Lcom/android/internal/telephony/StateMachine;->sendMessageDelayed(ILjava/lang/Object;J)V

    .line 1057
    :cond_0
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/StateMachine;->transitionTo(Lcom/android/internal/telephony/IState;)V

    return-void
.end method

.method private updateTimers()V
    .locals 5

    .line 1105
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCachedAllowedNetworkTypesBitmask()I

    move-result v0

    int-to-long v0, v0

    const-wide/32 v2, 0x80000

    and-long/2addr v0, v2

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-nez v0, :cond_0

    const-string v0, "Reset timers since NR is not allowed."

    .line 1107
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 1108
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->resetAllTimers()V

    return-void

    .line 1112
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getCurrentState()Lcom/android/internal/telephony/IState;

    move-result-object v0

    invoke-interface {v0}, Lcom/android/internal/telephony/IState;->getName()Ljava/lang/String;

    move-result-object v0

    .line 1114
    iget-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    const-string v2, ""

    const/4 v3, 0x0

    if-eqz v1, :cond_1

    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getOverrideNetworkType()I

    move-result v1

    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getCurrentOverrideNetworkType()I

    move-result v4

    if-ne v1, v4, :cond_1

    .line 1117
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Remove primary timer since icon of primary state and current icon equal: "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPrimaryTimerState:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    const/16 v1, 0x8

    .line 1120
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    .line 1121
    iput-boolean v3, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    .line 1122
    iput-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPrimaryTimerState:Ljava/lang/String;

    .line 1125
    :cond_1
    iget-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mSecondaryTimerState:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    .line 1128
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Remove secondary timer since current state ("

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ") is no longer secondary timer state ("

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/NetworkTypeController;->mSecondaryTimerState:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ")."

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    const/16 v1, 0x9

    .line 1131
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/StateMachine;->removeMessages(I)V

    .line 1132
    iput-boolean v3, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    .line 1133
    iput-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mSecondaryTimerState:Ljava/lang/String;

    .line 1136
    :cond_2
    iget-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    if-nez v1, :cond_3

    iget-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    if-eqz v1, :cond_5

    :cond_3
    const-string v1, "connected_mmwave"

    .line 1137
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, "Reset timers since state is NR_ADVANCED."

    .line 1138
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 1139
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->resetAllTimers()V

    .line 1142
    :cond_4
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getDataNetworkType()I

    move-result v0

    .line 1143
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkTypeController;->isLte(I)Z

    move-result v1

    if-nez v1, :cond_5

    const/16 v1, 0x14

    if-eq v0, v1, :cond_5

    const-string v0, "Reset timers since 2G and 3G don\'t need NR timers."

    .line 1144
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    .line 1145
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->resetAllTimers()V

    :cond_5
    return-void
.end method


# virtual methods
.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 1365
    new-instance v0, Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v1, " "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/IndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    const-string p2, "NetworkTypeController: "

    .line 1366
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 1367
    invoke-super {p0, p1, v0, p3}, Lcom/android/internal/telephony/StateMachine;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1368
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    .line 1369
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1370
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mSubId="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1371
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mOverrideTimerRules="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideTimerRules:Ljava/util/Map;

    invoke-virtual {p2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1372
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mLteEnhancedPattern="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteEnhancedPattern:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1373
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mIsPhysicalChannelConfigOn="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfigOn:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1374
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mIsPrimaryTimerActive="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1375
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mIsSecondaryTimerActive="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1376
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mIsTimerRestEnabledForLegacyStateRRCIdle="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsTimerResetEnabledForLegacyStateRRCIdle:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1378
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mLtePlusThresholdBandwidth="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLtePlusThresholdBandwidth:I

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1379
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mNrAdvancedThresholdBandwidth="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedThresholdBandwidth:I

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1380
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mPrimaryTimerState="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPrimaryTimerState:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1381
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mSecondaryTimerState="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mSecondaryTimerState:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1382
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mPreviousState="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1383
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mPhysicalLinkStatus="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhysicalLinkStatus:I

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1384
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mAdditionalNrAdvancedBandsList="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mAdditionalNrAdvancedBandsList:[I

    .line 1385
    invoke-static {p2}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1384
    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1386
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mIsPhysicalChannelConfig16Supported="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfig16Supported:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1387
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mIsNrAdvancedAllowedByPco="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsNrAdvancedAllowedByPco:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1388
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mNrAdvancedCapablePcoId="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mNrAdvancedCapablePcoId:I

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1389
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mIsUsingUserDataForRrcDetection="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsUsingUserDataForRrcDetection:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1390
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mEnableNrAdvancedWhileRoaming="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mEnableNrAdvancedWhileRoaming:Z

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1391
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "mIsDeviceIdleMode="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsDeviceIdleMode:Z

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1392
    invoke-virtual {v0}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 1393
    invoke-virtual {v0}, Ljava/io/PrintWriter;->flush()V

    return-void
.end method

.method protected getCurrentOverrideNetworkType()I
    .locals 5

    .line 457
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getDataNetworkType()I

    move-result v0

    .line 458
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkTypeController;->isLte(I)Z

    move-result v1

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 459
    invoke-interface {v1}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getNrState()I

    move-result v1

    if-eqz v1, :cond_0

    move v1, v2

    goto :goto_0

    :cond_0
    move v1, v3

    :goto_0
    const/16 v4, 0x14

    if-ne v0, v4, :cond_1

    goto :goto_1

    :cond_1
    move v2, v3

    .line 463
    :goto_1
    iget-boolean v4, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfigOn:Z

    if-eqz v4, :cond_3

    if-nez v1, :cond_2

    if-eqz v2, :cond_3

    .line 465
    :cond_2
    invoke-direct {p0, v2}, Lcom/android/internal/telephony/NetworkTypeController;->getNrDisplayType(Z)I

    move-result v3

    if-nez v3, :cond_4

    if-nez v2, :cond_4

    .line 468
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getLteDisplayType()I

    move-result v3

    goto :goto_2

    .line 470
    :cond_3
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/NetworkTypeController;->isLte(I)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 472
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getLteDisplayType()I

    move-result v3

    :cond_4
    :goto_2
    return v3
.end method

.method public getOverrideNetworkType()I
    .locals 0

    .line 205
    iget p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideNetworkType:I

    return p0
.end method

.method public is5GHysteresisActive()Z
    .locals 1

    .line 213
    iget-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    if-nez v0, :cond_1

    iget-boolean p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

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

.method protected isAdditionalNrAdvancedBand()Z
    .locals 5

    .line 1292
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1293
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/ServiceStateTracker;->getPhysicalChannelConfigList()Ljava/util/List;

    move-result-object v0

    .line 1294
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mAdditionalNrAdvancedBandsList:[I

    invoke-static {v1}, Lcom/android/internal/telephony/util/ArrayUtils;->isEmpty([I)Z

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_2

    if-nez v0, :cond_0

    goto :goto_0

    .line 1298
    :cond_0
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/PhysicalChannelConfig;

    .line 1299
    invoke-virtual {v1}, Landroid/telephony/PhysicalChannelConfig;->getNetworkType()I

    move-result v3

    const/16 v4, 0x14

    if-ne v3, v4, :cond_1

    iget-object v3, p0, Lcom/android/internal/telephony/NetworkTypeController;->mAdditionalNrAdvancedBandsList:[I

    .line 1300
    invoke-virtual {v1}, Landroid/telephony/PhysicalChannelConfig;->getBand()I

    move-result v1

    invoke-static {v3, v1}, Lcom/android/internal/telephony/util/ArrayUtils;->contains([II)Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_2
    :goto_0
    return v2
.end method

.method protected isUsingLteCarrierAggregation()Z
    .locals 0

    .line 1415
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->isUsingCarrierAggregation()Z

    move-result p0

    return p0
.end method

.method protected log(Ljava/lang/String;)V
    .locals 2

    .line 1343
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "] "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "NetworkTypeController"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 2

    .line 1347
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "["

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "] "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "NetworkTypeController"

    invoke-static {p1, p0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected mtkNeedUpdateNRStateForLegacyState()Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method protected registerForAllEvents()V
    .locals 5

    .line 218
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const/16 v2, 0xa

    const/4 v3, 0x0

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/Phone;->registerForRadioOffOrNotAvailable(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 220
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const/16 v2, 0xb

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/Phone;->registerForPreferredNetworkTypeChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 222
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const/16 v2, 0xd

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/Phone;->registerForPhysicalChannelConfig(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 224
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    .line 225
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const/4 v2, 0x1

    const/4 v4, 0x2

    .line 224
    invoke-virtual {v0, v2, v1, v4, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForDataRegStateOrRatChanged(ILandroid/os/Handler;ILjava/lang/Object;)V

    .line 227
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    .line 228
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const/16 v2, 0xf

    .line 227
    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForBandwidthChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 229
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Landroid/telephony/TelephonyManager;

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    const-string v1, "CAPABILITY_PHYSICAL_CHANNEL_CONFIG_1_6_SUPPORTED"

    .line 230
    invoke-virtual {v0, v1}, Landroid/telephony/TelephonyManager;->isRadioInterfaceCapabilitySupported(Ljava/lang/String;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfig16Supported:Z

    .line 232
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const/4 v2, 0x3

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForNrStateChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 234
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const/4 v2, 0x4

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForNrFrequencyChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 236
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDeviceStateMonitor()Lcom/android/internal/telephony/DeviceStateMonitor;

    move-result-object v0

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const/4 v2, 0x6

    invoke-virtual {v0, v1, v2, v3}, Lcom/android/internal/telephony/DeviceStateMonitor;->registerForPhysicalChannelConfigNotifChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 238
    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    const-string v1, "android.telephony.action.CARRIER_CONFIG_CHANGED"

    .line 239
    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v1, "android.os.action.DEVICE_IDLE_MODE_CHANGED"

    .line 240
    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 241
    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    iget-object v2, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    iget-object v4, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1, v2, v0, v3, v4}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;

    .line 242
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-nez v0, :cond_0

    .line 243
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object p0

    const/16 v1, 0xe

    invoke-interface {v0, p0, v1, v3}, Lcom/android/internal/telephony/CommandsInterface;->registerForPcoData(Landroid/os/Handler;ILjava/lang/Object;)V

    :cond_0
    return-void
.end method

.method public toString()Ljava/lang/String;
    .locals 2

    .line 1352
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "mOverrideTimerRules="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideTimerRules:Ljava/util/Map;

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mLteEnhancedPattern="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mLteEnhancedPattern:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mIsPhysicalChannelConfigOn="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPhysicalChannelConfigOn:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mIsPrimaryTimerActive="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mIsSecondaryTimerActive="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", mPrimaryTimerState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPrimaryTimerState:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mSecondaryTimerState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mSecondaryTimerState:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mPreviousState="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPreviousState:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", mIsNrAdvanced="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1360
    invoke-direct {p0}, Lcom/android/internal/telephony/NetworkTypeController;->isNrAdvanced()Z

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method protected unRegisterForAllEvents()V
    .locals 3

    .line 249
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/Phone;->unregisterForRadioOffOrNotAvailable(Landroid/os/Handler;)V

    .line 250
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/Phone;->unregisterForPreferredNetworkTypeChanged(Landroid/os/Handler;)V

    .line 251
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    .line 252
    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    const/4 v2, 0x1

    .line 251
    invoke-virtual {v0, v2, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForDataRegStateOrRatChanged(ILandroid/os/Handler;)V

    .line 253
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForNrStateChanged(Landroid/os/Handler;)V

    .line 254
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v0

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ServiceStateTracker;->unregisterForNrFrequencyChanged(Landroid/os/Handler;)V

    .line 255
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getDeviceStateMonitor()Lcom/android/internal/telephony/DeviceStateMonitor;

    move-result-object v0

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/DeviceStateMonitor;->unregisterForPhysicalChannelConfigNotifChanged(Landroid/os/Handler;)V

    .line 256
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object v1, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIntentReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 257
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    if-nez v0, :cond_0

    .line 258
    iget-object v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    invoke-virtual {p0}, Lcom/android/internal/telephony/StateMachine;->getHandler()Landroid/os/Handler;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/android/internal/telephony/CommandsInterface;->unregisterForPcoData(Landroid/os/Handler;)V

    :cond_0
    return-void
.end method

.method protected updateOverrideNetworkType()V
    .locals 1

    .line 445
    iget-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsPrimaryTimerActive:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mIsSecondaryTimerActive:Z

    if-eqz v0, :cond_0

    goto :goto_0

    .line 449
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/NetworkTypeController;->getCurrentOverrideNetworkType()I

    move-result v0

    iput v0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mOverrideNetworkType:I

    .line 450
    iget-object p0, p0, Lcom/android/internal/telephony/NetworkTypeController;->mDisplayInfoController:Lcom/android/internal/telephony/DisplayInfoController;

    invoke-virtual {p0}, Lcom/android/internal/telephony/DisplayInfoController;->updateTelephonyDisplayInfo()V

    return-void

    :cond_1
    :goto_0
    const-string v0, "Skip updating override network type since timer is active."

    .line 446
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/NetworkTypeController;->log(Ljava/lang/String;)V

    return-void
.end method
