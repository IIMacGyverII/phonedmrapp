.class public Lcom/android/internal/telephony/metrics/MetricsCollector;
.super Ljava/lang/Object;
.source "MetricsCollector.java"

# interfaces
.implements Landroid/app/StatsManager$StatsPullAtomCallback;


# static fields
.field private static final DBG:Z = false

.field private static final DURATION_BUCKET_MILLIS:J = 0x493e0L

.field private static final MIN_CALLS_PER_BUCKET:J = 0x5L

.field private static final MIN_COOLDOWN_MILLIS:J = 0x4ef6d80L

.field private static final POLICY_PULL_DAILY:Landroid/app/StatsManager$PullAtomMetadata;

.field private static final TAG:Ljava/lang/String;

.field private static final sRandom:Ljava/util/Random;


# instance fields
.field private final mAirplaneModeStats:Lcom/android/internal/telephony/metrics/AirplaneModeStats;

.field private final mOngoingDataCallStats:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/metrics/DataCallSessionStats;",
            ">;"
        }
    .end annotation
.end field

.field private final mStatsManager:Landroid/app/StatsManager;

.field private final mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;


# direct methods
.method public static synthetic $r8$lambda$3i1txjwUqApQZ6xnzGHZvb65tDE(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullCellularServiceState$8(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)V

    return-void
.end method

.method public static synthetic $r8$lambda$62YNYd8A6z6XkWb8MmSVTVwTSjk(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullPresenceNotifyEvent$23(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;)V

    return-void
.end method

.method public static synthetic $r8$lambda$7EndRFHqTeKi_3dP4Fc9GMhl4Z8(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullCellularDataServiceSwitch$7(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V

    return-void
.end method

.method public static synthetic $r8$lambda$8uwxuwiwv8NBwoDH3unrAqH3V6s(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullGbaEvent$24(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;)V

    return-void
.end method

.method public static synthetic $r8$lambda$EZl8eClSJsKg7bbwAnoMNjC0u8c(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullSipTransportSession$18(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;)V

    return-void
.end method

.method public static synthetic $r8$lambda$EiIvGyrHLrBvry-J4_W4uRazkTI(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullTelephonyNetworkRequestsV2$11(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Ixz_EYhdji-oTmtrqGb6IpmCGQ4(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullOutgoingSms$5(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;)V

    return-void
.end method

.method public static synthetic $r8$lambda$JHZMk6n6u2wfQM16WZEfGv4hahA(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullUceEventStats$22(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;)V

    return-void
.end method

.method public static synthetic $r8$lambda$TlGB4_g2nz01u0loq_WBIHXIaBg(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullImsRegistrationServiceDescStats$21(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;)V

    return-void
.end method

.method public static synthetic $r8$lambda$VcVeOAZ1Z1V2pSd6dMx7opf1vqw(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)J
    .locals 2

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullVoiceCallRatUsages$0(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)J

    move-result-wide v0

    return-wide v0
.end method

.method public static synthetic $r8$lambda$Xbzt89skyBY3kKI8XaF97FllJIo(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullImsRegistrationStats$9(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)V

    return-void
.end method

.method public static synthetic $r8$lambda$ZZoIiFopPD6RatQmvOK_ndknJLg(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullVoiceCallSessions$3(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V

    return-void
.end method

.method public static synthetic $r8$lambda$_QS-wcCPEGsxvpo8R5eJqD8l2uY(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullSipMessageResponse$17(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;)V

    return-void
.end method

.method public static synthetic $r8$lambda$fMS-SDmyxBP91NpVpwTDESOlEAo(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullImsDedicatedBearerListenerEvent$19(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;)V

    return-void
.end method

.method public static synthetic $r8$lambda$gH2yOQ9vEPCYQy-oix7fehtZDTg(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullVoiceCallRatUsages$2(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)V

    return-void
.end method

.method public static synthetic $r8$lambda$nIW-u-jmDFo2ynQPlcVOxRvrmA8(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullRcsAcsProvisioningStats$14(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;)V

    return-void
.end method

.method public static synthetic $r8$lambda$qNIvzk3VBDBeJznry98J4nL2C8Y(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullRcsClientProvisioningStats$13(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;)V

    return-void
.end method

.method public static synthetic $r8$lambda$qNyx2a44TW5YRcxdeu9HOeDDcaY(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullImsDedicatedBearerEvent$20(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;)V

    return-void
.end method

.method public static synthetic $r8$lambda$r6FbOoHs4Aw6BzoUTCdSLAFDJJc(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullImsRegistrationFeatureTagStats$12(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;)V

    return-void
.end method

.method public static synthetic $r8$lambda$v-F0Myc4UDJIM5eMC8slp8MzV94(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullSipDelegateStats$15(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;)V

    return-void
.end method

.method public static synthetic $r8$lambda$vGDGWY5X76__sdp71USzoWpyrJw(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullImsRegistrationTermination$10(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)V

    return-void
.end method

.method public static synthetic $r8$lambda$vnyK5Wc5U79Bv7gcSX7XmOcLB1U(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullDataCallSession$6(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)V

    return-void
.end method

.method public static synthetic $r8$lambda$x8RtDQuztiWKB5d7b_x4im5UxyA(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullSipTransportFeatureTagStats$16(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;)V

    return-void
.end method

.method public static synthetic $r8$lambda$xi2tr438c0ArfZgaZ_4aSOb6C9c(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullVoiceCallRatUsages$1(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$yEWBbYEKfZzWOtKQ7XVVcvV6XZk(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->lambda$pullIncomingSms$4(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 102
    const-class v0, Lcom/android/internal/telephony/metrics/MetricsCollector;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    .line 127
    new-instance v0, Landroid/app/StatsManager$PullAtomMetadata$Builder;

    invoke-direct {v0}, Landroid/app/StatsManager$PullAtomMetadata$Builder;-><init>()V

    const-wide/32 v1, 0x4ef6d80

    .line 129
    invoke-virtual {v0, v1, v2}, Landroid/app/StatsManager$PullAtomMetadata$Builder;->setCoolDownMillis(J)Landroid/app/StatsManager$PullAtomMetadata$Builder;

    move-result-object v0

    .line 130
    invoke-virtual {v0}, Landroid/app/StatsManager$PullAtomMetadata$Builder;->build()Landroid/app/StatsManager$PullAtomMetadata;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/metrics/MetricsCollector;->POLICY_PULL_DAILY:Landroid/app/StatsManager$PullAtomMetadata;

    .line 136
    new-instance v0, Ljava/util/Random;

    invoke-direct {v0}, Ljava/util/Random;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/metrics/MetricsCollector;->sRandom:Ljava/util/Random;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 139
    new-instance v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;-><init>(Landroid/content/Context;)V

    invoke-direct {p0, p1, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;-><init>(Landroid/content/Context;Lcom/android/internal/telephony/metrics/PersistAtomsStorage;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Lcom/android/internal/telephony/metrics/PersistAtomsStorage;)V
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 145
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 135
    invoke-static {}, Ljava/util/concurrent/ConcurrentHashMap;->newKeySet()Ljava/util/concurrent/ConcurrentHashMap$KeySetView;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mOngoingDataCallStats:Ljava/util/Set;

    .line 146
    iput-object p2, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-string/jumbo p2, "stats"

    .line 147
    invoke-virtual {p1, p2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/app/StatsManager;

    iput-object p2, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStatsManager:Landroid/app/StatsManager;

    if-eqz p2, :cond_0

    const/16 p2, 0x276b

    .line 149
    sget-object v0, Lcom/android/internal/telephony/metrics/MetricsCollector;->POLICY_PULL_DAILY:Landroid/app/StatsManager$PullAtomMetadata;

    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x276a

    .line 150
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x275e

    const/4 v1, 0x0

    .line 151
    invoke-direct {p0, p2, v1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x275f

    .line 152
    invoke-direct {p0, p2, v1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x275d

    .line 153
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x275c

    .line 154
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x2766

    .line 155
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x2767

    .line 156
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x2768

    .line 157
    invoke-direct {p0, p2, v1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x2769

    .line 158
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x276e

    .line 159
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x276d

    .line 160
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x27a9

    .line 161
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x2795

    .line 162
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x2796

    .line 163
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x2797

    .line 164
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x2798

    .line 165
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x2799

    .line 166
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x279a

    .line 167
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x279b

    .line 168
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x27aa

    .line 169
    invoke-direct {p0, p2, v1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x279c

    .line 170
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x279d

    .line 171
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x279e

    .line 172
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x279f

    .line 173
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x27a0

    .line 174
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x27a1

    .line 175
    invoke-direct {p0, p2, v0}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    const/16 p2, 0x27a2

    .line 176
    invoke-direct {p0, p2, v1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V

    .line 178
    sget-object p2, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string v0, "registered"

    invoke-static {p2, v0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 180
    :cond_0
    sget-object p2, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string v0, "could not get StatsManager, atoms not registered"

    invoke-static {p2, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 183
    :goto_0
    new-instance p2, Lcom/android/internal/telephony/metrics/AirplaneModeStats;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/metrics/AirplaneModeStats;-><init>(Landroid/content/Context;)V

    iput-object p2, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mAirplaneModeStats:Lcom/android/internal/telephony/metrics/AirplaneModeStats;

    return-void
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)Landroid/util/StatsEvent;
    .locals 7

    .line 699
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->ratFrom:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->ratTo:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->simSlotIndex:I

    iget-boolean v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->isMultiSim:Z

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->carrierId:I

    iget v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->switchCount:I

    const/16 v0, 0x276b

    invoke-static/range {v0 .. v6}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIZII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)Landroid/util/StatsEvent;
    .locals 13

    .line 710
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRat:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRoamingType:I

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRoamingType:I

    iget-boolean v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEndc:Z

    iget v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->simSlotIndex:I

    iget-boolean v7, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isMultiSim:Z

    iget v8, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->carrierId:I

    iget-wide v9, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->totalTimeMillis:J

    const-wide/32 v11, 0x493e0

    .line 720
    invoke-static {v9, v10, v11, v12}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v9

    const-wide/16 v11, 0x3e8

    div-long/2addr v9, v11

    long-to-int v9, v9

    iget-boolean v10, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEmergencyOnly:Z

    const/16 v0, 0x276a

    .line 710
    invoke-static/range {v0 .. v10}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIZIZIIZ)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)Landroid/util/StatsEvent;
    .locals 27

    move-object/from16 v0, p0

    .line 812
    iget v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->dimension:I

    iget-boolean v3, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isMultiSim:Z

    iget-boolean v4, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isEsim:Z

    iget v6, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->apnTypeBitmask:I

    iget v7, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->carrierId:I

    iget-boolean v8, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isRoaming:Z

    iget v9, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratAtEnd:I

    iget-boolean v10, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->oosAtEnd:Z

    iget-wide v11, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    iget-boolean v13, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->isOpportunistic:Z

    iget v14, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ipType:I

    iget-boolean v15, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->setupFailed:Z

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->failureCause:I

    move/from16 v16, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->suggestedRetryMillis:I

    move/from16 v17, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->deactivateReason:I

    move/from16 v18, v1

    move/from16 v24, v2

    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->durationMinutes:J

    move/from16 v25, v3

    move/from16 v26, v4

    const-wide/16 v3, 0x5

    .line 830
    invoke-static {v1, v2, v3, v4}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v19

    iget-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ongoing:Z

    move/from16 v21, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->bandAtEnd:I

    move/from16 v22, v1

    iget-object v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->handoverFailureCauses:[I

    move-object/from16 v23, v0

    const/16 v1, 0x2769

    const/4 v5, 0x0

    move/from16 v2, v24

    move/from16 v3, v25

    move/from16 v4, v26

    .line 812
    invoke-static/range {v1 .. v23}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIZZIIIZIZJZIZIIIJZI[I)Landroid/util/StatsEvent;

    move-result-object v0

    return-object v0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;)Landroid/util/StatsEvent;
    .locals 6

    .line 1016
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->slotId:I

    iget-boolean v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->successful:Z

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->failedReason:I

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->count:I

    const/16 v0, 0x27a1

    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIZII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;)Landroid/util/StatsEvent;
    .locals 10

    .line 966
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->ratAtEnd:I

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->qci:I

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->bearerState:I

    iget-boolean v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->localConnectionInfoReceived:Z

    iget-boolean v7, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->remoteConnectionInfoReceived:Z

    iget-boolean v8, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->hasListeners:Z

    iget v9, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->count:I

    const/16 v0, 0x279d

    invoke-static/range {v0 .. v9}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIIZZZI)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;)Landroid/util/StatsEvent;
    .locals 7

    .line 955
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->ratAtEnd:I

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->qci:I

    iget-boolean v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->dedicatedBearerEstablished:Z

    iget v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->eventCount:I

    const/16 v0, 0x279c

    invoke-static/range {v0 .. v6}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIZI)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;)Landroid/util/StatsEvent;
    .locals 9

    .line 879
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->featureTagName:I

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->registrationTech:I

    iget-wide v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->registeredMillis:J

    const-wide/32 v7, 0x493e0

    .line 885
    invoke-static {v5, v6, v7, v8}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v5

    const-wide/16 v7, 0x3e8

    div-long/2addr v5, v7

    long-to-int v5, v5

    const/16 v0, 0x2795

    .line 879
    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;)Landroid/util/StatsEvent;
    .locals 10

    .line 980
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->serviceIdName:I

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->serviceIdVersion:F

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->registrationTech:I

    iget-wide v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->publishedMillis:J

    const-wide/32 v8, 0x493e0

    .line 987
    invoke-static {v6, v7, v8, v9}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v6

    const-wide/16 v8, 0x3e8

    div-long/2addr v6, v8

    long-to-int v6, v6

    const/16 v0, 0x279e

    .line 980
    invoke-static/range {v0 .. v6}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIFII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)Landroid/util/StatsEvent;
    .locals 18

    move-object/from16 v0, p0

    .line 837
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->carrierId:I

    iget v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->simSlotIndex:I

    iget v3, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->rat:I

    iget-wide v4, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->registeredMillis:J

    const-wide/32 v6, 0x493e0

    .line 842
    invoke-static {v4, v5, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v4

    const-wide/16 v8, 0x3e8

    div-long/2addr v4, v8

    long-to-int v4, v4

    iget-wide v10, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceCapableMillis:J

    .line 843
    invoke-static {v10, v11, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v10

    div-long/2addr v10, v8

    long-to-int v5, v10

    iget-wide v10, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceAvailableMillis:J

    .line 845
    invoke-static {v10, v11, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v10

    div-long/2addr v10, v8

    long-to-int v10, v10

    iget-wide v11, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsCapableMillis:J

    .line 847
    invoke-static {v11, v12, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v11

    div-long/2addr v11, v8

    long-to-int v11, v11

    iget-wide v12, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsAvailableMillis:J

    .line 848
    invoke-static {v12, v13, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v12

    div-long/2addr v12, v8

    long-to-int v12, v12

    iget-wide v13, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoCapableMillis:J

    .line 849
    invoke-static {v13, v14, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v13

    div-long/2addr v13, v8

    long-to-int v13, v13

    iget-wide v14, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoAvailableMillis:J

    .line 851
    invoke-static {v14, v15, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v14

    div-long/2addr v14, v8

    long-to-int v14, v14

    move/from16 v16, v14

    iget-wide v14, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utCapableMillis:J

    .line 853
    invoke-static {v14, v15, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v14

    div-long/2addr v14, v8

    long-to-int v14, v14

    move/from16 v17, v14

    iget-wide v14, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utAvailableMillis:J

    .line 854
    invoke-static {v14, v15, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v6

    div-long/2addr v6, v8

    long-to-int v14, v6

    const/16 v0, 0x276e

    move v6, v10

    move v7, v11

    move v8, v12

    move v9, v13

    move/from16 v10, v16

    move/from16 v11, v17

    move v12, v14

    .line 837
    invoke-static/range {v0 .. v12}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIIIIIIIII)Landroid/util/StatsEvent;

    move-result-object v0

    return-object v0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)Landroid/util/StatsEvent;
    .locals 9

    .line 858
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->carrierId:I

    iget-boolean v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->isMultiSim:Z

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->ratAtEnd:I

    iget-boolean v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->setupFailed:Z

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->reasonCode:I

    iget v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->extraCode:I

    iget-object v7, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->extraMessage:Ljava/lang/String;

    iget v8, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->count:I

    const/16 v0, 0x276d

    invoke-static/range {v0 .. v8}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIZIZIILjava/lang/String;I)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)Landroid/util/StatsEvent;
    .locals 16

    move-object/from16 v0, p0

    .line 774
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsFormat:I

    iget v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsTech:I

    iget v3, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->rat:I

    iget v4, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->smsType:I

    iget v5, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->totalParts:I

    iget v6, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->receivedParts:I

    iget-boolean v7, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->blocked:Z

    iget v8, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->error:I

    iget-boolean v9, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->isRoaming:Z

    iget v10, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->simSlotIndex:I

    iget-boolean v11, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->isMultiSim:Z

    iget-boolean v12, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->isEsim:Z

    iget v13, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->carrierId:I

    iget-wide v14, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;->messageId:J

    const/16 v0, 0x2766

    invoke-static/range {v0 .. v15}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIIIZIZIZZIJ)Landroid/util/StatsEvent;

    move-result-object v0

    return-object v0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)Landroid/util/StatsEvent;
    .locals 3

    .line 871
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->carrierId:I

    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->capability:I

    iget p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->requestCount:I

    const/16 v2, 0x27a9

    invoke-static {v2, v0, v1, p0}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;)Landroid/util/StatsEvent;
    .locals 18

    move-object/from16 v0, p0

    .line 793
    iget v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->smsFormat:I

    iget v3, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->smsTech:I

    iget v4, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->rat:I

    iget v5, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->sendResult:I

    iget v6, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->errorCode:I

    iget-boolean v7, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->isRoaming:Z

    iget-boolean v8, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->isFromDefaultApp:Z

    iget v9, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->simSlotIndex:I

    iget-boolean v10, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->isMultiSim:Z

    iget-boolean v11, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->isEsim:Z

    iget v12, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->carrierId:I

    iget-wide v13, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->messageId:J

    iget v15, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->retryId:I

    iget-wide v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->intervalMillis:J

    move-wide/from16 v16, v0

    const/16 v1, 0x2767

    invoke-static/range {v1 .. v17}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIIZZIZZIJIJ)Landroid/util/StatsEvent;

    move-result-object v0

    return-object v0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;)Landroid/util/StatsEvent;
    .locals 9

    .line 1003
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->reason:I

    iget-boolean v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->contentBodyReceived:Z

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->rcsCapsCount:I

    iget v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->mmtelCapsCount:I

    iget v7, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->noCapsCount:I

    iget v8, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->count:I

    const/16 v0, 0x27a0

    invoke-static/range {v0 .. v8}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIZIIII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;)Landroid/util/StatsEvent;
    .locals 11

    .line 898
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->responseCode:I

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->responseType:I

    iget-boolean v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->isSingleRegistrationEnabled:Z

    iget v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->count:I

    iget-wide v7, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->stateTimerMillis:J

    const-wide/32 v9, 0x493e0

    .line 906
    invoke-static {v7, v8, v9, v10}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v7

    const-wide/16 v9, 0x3e8

    div-long/2addr v7, v9

    long-to-int v7, v7

    const/16 v0, 0x2797

    .line 898
    invoke-static/range {v0 .. v7}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIZII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;)Landroid/util/StatsEvent;
    .locals 4

    .line 889
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->carrierId:I

    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->slotId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->event:I

    iget p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->count:I

    const/16 v3, 0x2796

    invoke-static {v3, v0, v1, v2, p0}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;)Landroid/util/StatsEvent;
    .locals 8

    .line 910
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->dimension:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->carrierId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->slotId:I

    iget-wide v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->uptimeMillis:J

    const-wide/32 v6, 0x493e0

    .line 915
    invoke-static {v4, v5, v6, v7}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v4

    const-wide/16 v6, 0x3e8

    div-long/2addr v4, v6

    long-to-int v4, v4

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;->destroyReason:I

    const/16 v0, 0x2798

    .line 910
    invoke-static/range {v0 .. v5}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;)Landroid/util/StatsEvent;
    .locals 8

    .line 931
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageMethod:I

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageResponse:I

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageDirection:I

    iget v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->messageError:I

    iget v7, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->count:I

    const/16 v0, 0x279a

    invoke-static/range {v0 .. v7}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIIII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;)Landroid/util/StatsEvent;
    .locals 10

    .line 920
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->featureTagName:I

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->sipTransportDeniedReason:I

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->sipTransportDeregisteredReason:I

    iget-wide v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->associatedMillis:J

    const-wide/32 v8, 0x493e0

    .line 927
    invoke-static {v6, v7, v8, v9}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v6

    const-wide/16 v8, 0x3e8

    div-long/2addr v6, v8

    long-to-int v6, v6

    const/16 v0, 0x2799

    .line 920
    invoke-static/range {v0 .. v6}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;)Landroid/util/StatsEvent;
    .locals 8

    .line 943
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sessionMethod:I

    iget v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sipMessageDirection:I

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sipResponse:I

    iget v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sessionCount:I

    iget v7, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->endedGracefullyCount:I

    const/16 v0, 0x279b

    invoke-static/range {v0 .. v7}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIIII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;)Landroid/util/StatsEvent;
    .locals 8

    .line 991
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->slotId:I

    iget v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->type:I

    iget-boolean v4, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->successful:Z

    iget v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->commandCode:I

    iget v6, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->networkResponse:I

    iget v7, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->count:I

    const/16 v0, 0x279f

    invoke-static/range {v0 .. v7}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIZIII)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Landroid/util/StatsEvent;
    .locals 7

    .line 725
    iget v1, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->carrierId:I

    iget v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->rat:I

    iget-wide v3, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->totalDurationMillis:J

    const-wide/32 v5, 0x493e0

    .line 729
    invoke-static {v3, v4, v5, v6}, Lcom/android/internal/telephony/metrics/MetricsCollector;->round(JJ)J

    move-result-wide v3

    const-wide/16 v5, 0x3e8

    div-long/2addr v3, v5

    iget-wide v5, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->callCount:J

    const/16 v0, 0x275d

    .line 725
    invoke-static/range {v0 .. v6}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIJJ)Landroid/util/StatsEvent;

    move-result-object p0

    return-object p0
.end method

.method private static buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)Landroid/util/StatsEvent;
    .locals 40

    move-object/from16 v0, p0

    .line 734
    iget v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtStart:I

    iget v3, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bearerAtEnd:I

    iget v4, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->direction:I

    iget v5, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDuration:I

    iget-boolean v6, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupFailed:Z

    iget v7, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectReasonCode:I

    iget v8, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraCode:I

    iget-object v9, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->disconnectExtraMessage:Ljava/lang/String;

    iget v10, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtStart:I

    iget v11, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtEnd:I

    iget-wide v12, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratSwitchCount:J

    iget-wide v14, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->codecBitmask:J

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtStart:I

    move/from16 v16, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->concurrentCallCountAtEnd:I

    move/from16 v17, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->simSlotIndex:I

    move/from16 v18, v1

    iget-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiSim:Z

    move/from16 v19, v1

    iget-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEsim:Z

    move/from16 v20, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->carrierId:I

    move/from16 v21, v1

    iget-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCompleted:Z

    move/from16 v22, v1

    move/from16 v39, v2

    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccFailureCount:J

    move-wide/from16 v23, v1

    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->srvccCancellationCount:J

    move-wide/from16 v25, v1

    iget-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->rttEnabled:Z

    move/from16 v27, v1

    iget-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEmergency:Z

    move/from16 v28, v1

    iget-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isRoaming:Z

    move/from16 v29, v1

    sget-object v1, Lcom/android/internal/telephony/metrics/MetricsCollector;->sRandom:Ljava/util/Random;

    .line 761
    invoke-virtual {v1}, Ljava/util/Random;->nextInt()I

    move-result v30

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->signalStrengthAtEnd:I

    move/from16 v31, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->bandAtEnd:I

    move/from16 v32, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->setupDurationMillis:I

    move/from16 v33, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->mainCodecQuality:I

    move/from16 v34, v1

    iget-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->videoEnabled:Z

    move/from16 v35, v1

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->ratAtConnected:I

    move/from16 v36, v1

    iget-boolean v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isMultiparty:Z

    move/from16 v37, v1

    iget v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->callDuration:I

    move/from16 v38, v0

    const/16 v1, 0x275c

    move/from16 v2, v39

    .line 734
    invoke-static/range {v1 .. v38}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIZIILjava/lang/String;IIJJIIIZZIZJJZZZIIIIIZIZI)Landroid/util/StatsEvent;

    move-result-object v0

    return-object v0
.end method

.method private static getPhonesIfAny()[Lcom/android/internal/telephony/Phone;
    .locals 1

    .line 1028
    :try_start_0
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/Phone;

    return-object v0
.end method

.method private static synthetic lambda$pullCellularDataServiceSwitch$7(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V
    .locals 0

    .line 404
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullCellularServiceState$8(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)V
    .locals 0

    .line 423
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullDataCallSession$6(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)V
    .locals 0

    .line 390
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullGbaEvent$24(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;)V
    .locals 0

    .line 654
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullImsDedicatedBearerEvent$20(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;)V
    .locals 0

    .line 604
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullImsDedicatedBearerListenerEvent$19(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;)V
    .locals 0

    .line 591
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullImsRegistrationFeatureTagStats$12(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;)V
    .locals 0

    .line 496
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullImsRegistrationServiceDescStats$21(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;)V
    .locals 0

    .line 618
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullImsRegistrationStats$9(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)V
    .locals 0

    .line 444
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullImsRegistrationTermination$10(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)V
    .locals 0

    .line 458
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullIncomingSms$4(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V
    .locals 0

    .line 361
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullOutgoingSms$5(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;)V
    .locals 0

    .line 373
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullPresenceNotifyEvent$23(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;)V
    .locals 0

    .line 642
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullRcsAcsProvisioningStats$14(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;)V
    .locals 0

    .line 524
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullRcsClientProvisioningStats$13(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;)V
    .locals 0

    .line 509
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullSipDelegateStats$15(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;)V
    .locals 0

    .line 537
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullSipMessageResponse$17(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;)V
    .locals 0

    .line 565
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullSipTransportFeatureTagStats$16(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;)V
    .locals 0

    .line 552
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullSipTransportSession$18(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;)V
    .locals 0

    .line 578
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullTelephonyNetworkRequestsV2$11(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)V
    .locals 0

    .line 470
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullUceEventStats$22(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;)V
    .locals 0

    .line 630
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullVoiceCallRatUsages$0(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)J
    .locals 4

    .line 330
    iget v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->carrierId:I

    int-to-long v0, v0

    const/16 v2, 0x20

    shl-long/2addr v0, v2

    iget p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->rat:I

    int-to-long v2, p0

    or-long/2addr v0, v2

    return-wide v0
.end method

.method private static synthetic lambda$pullVoiceCallRatUsages$1(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Z
    .locals 4

    .line 331
    iget-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;->callCount:J

    const-wide/16 v2, 0x5

    cmp-long p0, v0, v2

    if-ltz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$pullVoiceCallRatUsages$2(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)V
    .locals 0

    .line 332
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static synthetic lambda$pullVoiceCallSessions$3(Ljava/util/List;Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V
    .locals 0

    .line 349
    invoke-static {p1}, Lcom/android/internal/telephony/metrics/MetricsCollector;->buildStatsEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)Landroid/util/StatsEvent;

    move-result-object p1

    invoke-interface {p0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static pullCarrierIdTableVersion(Ljava/util/List;)I
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 311
    invoke-static {}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getPhonesIfAny()[Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 312
    array-length v1, v0

    if-nez v1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 v1, 0x0

    .line 317
    aget-object v0, v0, v1

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getCarrierIdListVersion()I

    move-result v0

    const/16 v2, 0x2768

    .line 318
    invoke-static {v2, v0}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(II)Landroid/util/StatsEvent;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return v1
.end method

.method private pullCellularDataServiceSwitch(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 399
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 400
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getCellularDataServiceSwitches(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 403
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda7;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda7;-><init>(Ljava/util/List;)V

    .line 404
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 407
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "CELLULAR_DATA_SERVICE_SWITCH pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullCellularServiceState(Ljava/util/List;)I
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 414
    invoke-static {}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getPhonesIfAny()[Lcom/android/internal/telephony/Phone;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_0

    aget-object v4, v0, v3

    .line 415
    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v4

    invoke-virtual {v4}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceStateStats()Lcom/android/internal/telephony/metrics/ServiceStateStats;

    move-result-object v4

    invoke-virtual {v4}, Lcom/android/internal/telephony/metrics/ServiceStateStats;->conclude()V

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 418
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 419
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getCellularServiceStates(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 422
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda4;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda4;-><init>(Ljava/util/List;)V

    .line 423
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    return v2

    .line 426
    :cond_1
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "CELLULAR_SERVICE_STATE pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullDataCallSession(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 383
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mOngoingDataCallStats:Ljava/util/Set;

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/metrics/DataCallSessionStats;

    .line 384
    invoke-virtual {v1}, Lcom/android/internal/telephony/metrics/DataCallSessionStats;->conclude()V

    goto :goto_0

    .line 387
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getDataCallSessions(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    move-result-object p0

    if-eqz p0, :cond_1

    .line 389
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda14;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda14;-><init>(Ljava/util/List;)V

    .line 390
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 393
    :cond_1
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "DATA_CALL_SESSION pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private static pullDeviceTelephonyProperties(Ljava/util/List;)I
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 479
    invoke-static {}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getPhonesIfAny()[Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 480
    array-length v1, v0

    if-nez v1, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/16 v1, 0x27aa

    const/4 v2, 0x0

    .line 484
    aget-object v0, v0, v2

    .line 485
    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->isUsingNewDataStack()Z

    move-result v0

    .line 484
    invoke-static {v1, v0}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IZ)Landroid/util/StatsEvent;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return v2
.end method

.method private pullGbaEvent(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 651
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getGbaEvent(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 653
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda3;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda3;-><init>(Ljava/util/List;)V

    .line 654
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 657
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "GBA_EVENT pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullImsDedicatedBearerEvent(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 600
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 601
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getImsDedicatedBearerEvent(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 603
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda2;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda2;-><init>(Ljava/util/List;)V

    .line 604
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 607
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "IMS_DEDICATED_BEARER_EVENT pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullImsDedicatedBearerListenerEvent(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 587
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 588
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getImsDedicatedBearerListenerEvent(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 590
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda11;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda11;-><init>(Ljava/util/List;)V

    .line 591
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 594
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "IMS_DEDICATED_BEARER_LISTENER_EVENT pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullImsRegistrationFeatureTagStats(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 490
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/RcsStats;->onFlushIncompleteImsRegistrationFeatureTagStats()V

    .line 492
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 493
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getImsRegistrationFeatureTagStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 495
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda1;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda1;-><init>(Ljava/util/List;)V

    .line 496
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 499
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "IMS_REGISTRATION_FEATURE_TAG_STATS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullImsRegistrationServiceDescStats(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 613
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/RcsStats;->onFlushIncompleteImsRegistrationServiceDescStats()V

    .line 614
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 615
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getImsRegistrationServiceDescStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 617
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda24;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda24;-><init>(Ljava/util/List;)V

    .line 618
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 621
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "IMS_REGISTRATION_SERVICE_DESC_STATS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullImsRegistrationStats(Ljava/util/List;)I
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 433
    invoke-static {}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getPhonesIfAny()[Lcom/android/internal/telephony/Phone;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_1

    aget-object v4, v0, v3

    .line 434
    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v4

    check-cast v4, Lcom/android/internal/telephony/imsphone/ImsPhone;

    if-eqz v4, :cond_0

    .line 436
    invoke-virtual {v4}, Lcom/android/internal/telephony/imsphone/ImsPhone;->getImsStats()Lcom/android/internal/telephony/metrics/ImsStats;

    move-result-object v4

    invoke-virtual {v4}, Lcom/android/internal/telephony/metrics/ImsStats;->conclude()V

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 440
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getImsRegistrationStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    move-result-object p0

    if-eqz p0, :cond_2

    .line 443
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda16;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda16;-><init>(Ljava/util/List;)V

    .line 444
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    return v2

    .line 447
    :cond_2
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "IMS_REGISTRATION_STATS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullImsRegistrationTermination(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 453
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 454
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getImsRegistrationTerminations(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 457
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda19;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda19;-><init>(Ljava/util/List;)V

    .line 458
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 461
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "IMS_REGISTRATION_TERMINATION pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullIncomingSms(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 358
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getIncomingSms(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 361
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda20;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda20;-><init>(Ljava/util/List;)V

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 364
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "INCOMING_SMS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullOutgoingSms(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 370
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getOutgoingSms(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 373
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda18;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda18;-><init>(Ljava/util/List;)V

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 376
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "OUTGOING_SMS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullPerSimStatus(Ljava/util/List;)I
    .locals 25
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 664
    invoke-static {}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getPhonesIfAny()[Lcom/android/internal/telephony/Phone;

    move-result-object v0

    array-length v1, v0

    const/4 v3, 0x1

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v1, :cond_1

    aget-object v5, v0, v4

    .line 665
    invoke-static {v5}, Lcom/android/internal/telephony/metrics/PerSimStatus;->getCurrentState(Lcom/android/internal/telephony/Phone;)Lcom/android/internal/telephony/metrics/PerSimStatus;

    move-result-object v6

    if-nez v6, :cond_0

    move-object/from16 v5, p1

    goto :goto_1

    :cond_0
    const/16 v7, 0x27a2

    .line 671
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v8

    iget v9, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->carrierId:I

    iget v10, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->phoneNumberSourceUicc:I

    iget v11, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->phoneNumberSourceCarrier:I

    iget v12, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->phoneNumberSourceIms:I

    iget-boolean v13, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->advancedCallingSettingEnabled:Z

    iget-boolean v14, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->voWiFiSettingEnabled:Z

    iget v15, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->voWiFiModeSetting:I

    iget v3, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->voWiFiRoamingModeSetting:I

    move/from16 v16, v3

    iget-boolean v3, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->vtSettingEnabled:Z

    move/from16 v17, v3

    iget-boolean v3, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->dataRoamingEnabled:Z

    move/from16 v18, v3

    iget-wide v2, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->preferredNetworkType:J

    move-wide/from16 v19, v2

    iget-boolean v2, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->disabled2g:Z

    move/from16 v21, v2

    iget-boolean v2, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->pin1Enabled:Z

    move/from16 v22, v2

    iget v2, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->minimumVoltageClass:I

    move/from16 v23, v2

    iget v2, v6, Lcom/android/internal/telephony/metrics/PerSimStatus;->userModifiedApnTypes:I

    move/from16 v24, v2

    .line 669
    invoke-static/range {v7 .. v24}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIIIIIZZIIZZJZZII)Landroid/util/StatsEvent;

    move-result-object v2

    move-object/from16 v5, p1

    .line 687
    invoke-interface {v5, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const/4 v3, 0x0

    :goto_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_1
    return v3
.end method

.method private pullPresenceNotifyEvent(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 639
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getPresenceNotifyEvent(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 641
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda12;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda12;-><init>(Ljava/util/List;)V

    .line 642
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 645
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "PRESENCE_NOTIFY_EVENT pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullRcsAcsProvisioningStats(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 518
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/RcsStats;->onFlushIncompleteRcsAcsProvisioningStats()V

    .line 520
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 521
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getRcsAcsProvisioningStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 523
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda13;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda13;-><init>(Ljava/util/List;)V

    .line 524
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 527
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "RCS_ACS_PROVISIONING_STATS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullRcsClientProvisioningStats(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 505
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 506
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getRcsClientProvisioningStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 508
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda6;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda6;-><init>(Ljava/util/List;)V

    .line 509
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 512
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "RCS_CLIENT_PROVISIONING_STATS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private static pullSimSlotState(Ljava/util/List;)I
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 279
    :try_start_0
    invoke-static {}, Lcom/android/internal/telephony/metrics/SimSlotState;->getCurrentState()Lcom/android/internal/telephony/metrics/SimSlotState;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    const/16 v1, 0x275e

    .line 285
    iget v2, v0, Lcom/android/internal/telephony/metrics/SimSlotState;->numActiveSlots:I

    iget v3, v0, Lcom/android/internal/telephony/metrics/SimSlotState;->numActiveSims:I

    iget v0, v0, Lcom/android/internal/telephony/metrics/SimSlotState;->numActiveEsims:I

    .line 286
    invoke-static {v1, v2, v3, v0}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IIII)Landroid/util/StatsEvent;

    move-result-object v0

    .line 285
    invoke-interface {p0, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const/4 p0, 0x0

    return p0

    :catch_0
    const/4 p0, 0x1

    return p0
.end method

.method private pullSipDelegateStats(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 533
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 534
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getSipDelegateStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 536
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda5;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda5;-><init>(Ljava/util/List;)V

    .line 537
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 540
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "SIP_DELEGATE_STATS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullSipMessageResponse(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 561
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 562
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getSipMessageResponse(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 564
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda10;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda10;-><init>(Ljava/util/List;)V

    .line 565
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 568
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "RCS_SIP_MESSAGE_RESPONSE pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullSipTransportFeatureTagStats(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 546
    invoke-static {}, Lcom/android/internal/telephony/metrics/RcsStats;->getInstance()Lcom/android/internal/telephony/metrics/RcsStats;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/RcsStats;->concludeSipTransportFeatureTagsStat()V

    .line 548
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 549
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getSipTransportFeatureTagStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 551
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda0;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda0;-><init>(Ljava/util/List;)V

    .line 552
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 555
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "SIP_DELEGATE_STATS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullSipTransportSession(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 574
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    .line 575
    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getSipTransportSession(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 577
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda9;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda9;-><init>(Ljava/util/List;)V

    .line 578
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 581
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "RCS_SIP_TRANSPORT_SESSION pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private static pullSupportedRadioAccessFamily(Ljava/util/List;)I
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 295
    invoke-static {}, Lcom/android/internal/telephony/metrics/MetricsCollector;->getPhonesIfAny()[Lcom/android/internal/telephony/Phone;

    move-result-object v0

    .line 296
    array-length v0, v0

    if-nez v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const-wide/16 v0, 0x0

    .line 302
    invoke-static {}, Lcom/android/internal/telephony/PhoneFactory;->getPhones()[Lcom/android/internal/telephony/Phone;

    move-result-object v2

    array-length v3, v2

    const/4 v4, 0x0

    move v5, v4

    :goto_0
    if-ge v5, v3, :cond_1

    aget-object v6, v2, v5

    .line 303
    invoke-virtual {v6}, Lcom/android/internal/telephony/Phone;->getRadioAccessFamily()I

    move-result v6

    int-to-long v6, v6

    or-long/2addr v0, v6

    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    :cond_1
    const/16 v2, 0x275f

    .line 306
    invoke-static {v2, v0, v1}, Lcom/android/internal/telephony/TelephonyStatsLog;->buildStatsEvent(IJ)Landroid/util/StatsEvent;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return v4
.end method

.method private pullTelephonyNetworkRequestsV2(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 467
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getNetworkRequestsV2(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 469
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda8;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda8;-><init>(Ljava/util/List;)V

    .line 470
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 473
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "TELEPHONY_NETWORK_REQUESTS_V2 pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullUceEventStats(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 627
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getUceEventStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 629
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda15;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda15;-><init>(Ljava/util/List;)V

    .line 630
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 633
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "UCE_EVENT_STATS pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private pullVoiceCallRatUsages(Ljava/util/List;)I
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 324
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getVoiceCallRatUsages(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    move-result-object p0

    const/4 v0, 0x1

    if-eqz p0, :cond_0

    .line 327
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda21;

    invoke-direct {v2}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda21;-><init>()V

    .line 329
    invoke-static {v2}, Ljava/util/Comparator;->comparingLong(Ljava/util/function/ToLongFunction;)Ljava/util/Comparator;

    move-result-object v2

    .line 328
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->sorted(Ljava/util/Comparator;)Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda22;

    invoke-direct {v2}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda22;-><init>()V

    .line 331
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda23;

    invoke-direct {v2, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda23;-><init>(Ljava/util/List;)V

    .line 332
    invoke-interface {v1, v2}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 333
    sget-object v1, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/Object;

    .line 337
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const/4 v3, 0x0

    aput-object p1, v2, v3

    array-length p0, p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    aput-object p0, v2, v0

    const-string p0, "%d out of %d VOICE_CALL_RAT_USAGE pulled"

    .line 335
    invoke-static {p0, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    .line 333
    invoke-static {v1, p0}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return v3

    .line 340
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "VOICE_CALL_RAT_USAGE pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    return v0
.end method

.method private pullVoiceCallSessions(Ljava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    .line 346
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    const-wide/32 v0, 0x4ef6d80

    invoke-virtual {p0, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getVoiceCallSessions(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 349
    invoke-static {p0}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda17;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/metrics/MetricsCollector$$ExternalSyntheticLambda17;-><init>(Ljava/util/List;)V

    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    const/4 p0, 0x0

    return p0

    .line 352
    :cond_0
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const-string p1, "VOICE_CALL_SESSION pull too frequent, skipping"

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x1

    return p0
.end method

.method private registerAtom(ILandroid/app/StatsManager$PullAtomMetadata;)V
    .locals 2

    .line 695
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStatsManager:Landroid/app/StatsManager;

    sget-object v1, Lcom/android/internal/util/ConcurrentUtils;->DIRECT_EXECUTOR:Ljava/util/concurrent/Executor;

    invoke-virtual {v0, p1, p2, v1, p0}, Landroid/app/StatsManager;->setPullAtomCallback(ILandroid/app/StatsManager$PullAtomMetadata;Ljava/util/concurrent/Executor;Landroid/app/StatsManager$StatsPullAtomCallback;)V

    return-void
.end method

.method private static round(JJ)J
    .locals 2

    const-wide/16 v0, 0x0

    cmp-long v0, p2, v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const-wide/16 v0, 0x2

    .line 1037
    div-long v0, p2, v0

    add-long/2addr p0, v0

    div-long/2addr p0, p2

    mul-long/2addr p0, p2

    :goto_0
    return-wide p0
.end method


# virtual methods
.method public getAtomsStorage()Lcom/android/internal/telephony/metrics/PersistAtomsStorage;
    .locals 0

    .line 260
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mStorage:Lcom/android/internal/telephony/metrics/PersistAtomsStorage;

    return-object p0
.end method

.method public onPullAtom(ILjava/util/List;)I
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(I",
            "Ljava/util/List<",
            "Landroid/util/StatsEvent;",
            ">;)I"
        }
    .end annotation

    const/16 v0, 0x276d

    if-eq p1, v0, :cond_3

    const/16 v0, 0x276e

    if-eq p1, v0, :cond_2

    const/16 v0, 0x27a9

    if-eq p1, v0, :cond_1

    const/16 v0, 0x27aa

    if-eq p1, v0, :cond_0

    packed-switch p1, :pswitch_data_0

    packed-switch p1, :pswitch_data_1

    packed-switch p1, :pswitch_data_2

    .line 253
    sget-object p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->TAG:Ljava/lang/String;

    const/4 p2, 0x1

    new-array v0, p2, [Ljava/lang/Object;

    const/4 v1, 0x0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    aput-object p1, v0, v1

    const-string/jumbo p1, "unexpected atom ID %d"

    invoke-static {p1, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return p2

    .line 251
    :pswitch_0
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullPerSimStatus(Ljava/util/List;)I

    move-result p0

    return p0

    .line 249
    :pswitch_1
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullGbaEvent(Ljava/util/List;)I

    move-result p0

    return p0

    .line 247
    :pswitch_2
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullPresenceNotifyEvent(Ljava/util/List;)I

    move-result p0

    return p0

    .line 245
    :pswitch_3
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullUceEventStats(Ljava/util/List;)I

    move-result p0

    return p0

    .line 243
    :pswitch_4
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullImsRegistrationServiceDescStats(Ljava/util/List;)I

    move-result p0

    return p0

    .line 241
    :pswitch_5
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullImsDedicatedBearerEvent(Ljava/util/List;)I

    move-result p0

    return p0

    .line 239
    :pswitch_6
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullImsDedicatedBearerListenerEvent(Ljava/util/List;)I

    move-result p0

    return p0

    .line 237
    :pswitch_7
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullSipTransportSession(Ljava/util/List;)I

    move-result p0

    return p0

    .line 235
    :pswitch_8
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullSipMessageResponse(Ljava/util/List;)I

    move-result p0

    return p0

    .line 233
    :pswitch_9
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullSipTransportFeatureTagStats(Ljava/util/List;)I

    move-result p0

    return p0

    .line 231
    :pswitch_a
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullSipDelegateStats(Ljava/util/List;)I

    move-result p0

    return p0

    .line 229
    :pswitch_b
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullRcsAcsProvisioningStats(Ljava/util/List;)I

    move-result p0

    return p0

    .line 227
    :pswitch_c
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullRcsClientProvisioningStats(Ljava/util/List;)I

    move-result p0

    return p0

    .line 225
    :pswitch_d
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullImsRegistrationFeatureTagStats(Ljava/util/List;)I

    move-result p0

    return p0

    .line 197
    :pswitch_e
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullCellularDataServiceSwitch(Ljava/util/List;)I

    move-result p0

    return p0

    .line 199
    :pswitch_f
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullCellularServiceState(Ljava/util/List;)I

    move-result p0

    return p0

    .line 215
    :pswitch_10
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullDataCallSession(Ljava/util/List;)I

    move-result p0

    return p0

    .line 213
    :pswitch_11
    invoke-static {p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullCarrierIdTableVersion(Ljava/util/List;)I

    move-result p0

    return p0

    .line 211
    :pswitch_12
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullOutgoingSms(Ljava/util/List;)I

    move-result p0

    return p0

    .line 209
    :pswitch_13
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullIncomingSms(Ljava/util/List;)I

    move-result p0

    return p0

    .line 203
    :pswitch_14
    invoke-static {p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullSupportedRadioAccessFamily(Ljava/util/List;)I

    move-result p0

    return p0

    .line 201
    :pswitch_15
    invoke-static {p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullSimSlotState(Ljava/util/List;)I

    move-result p0

    return p0

    .line 205
    :pswitch_16
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullVoiceCallRatUsages(Ljava/util/List;)I

    move-result p0

    return p0

    .line 207
    :pswitch_17
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullVoiceCallSessions(Ljava/util/List;)I

    move-result p0

    return p0

    .line 223
    :cond_0
    invoke-static {p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullDeviceTelephonyProperties(Ljava/util/List;)I

    move-result p0

    return p0

    .line 221
    :cond_1
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullTelephonyNetworkRequestsV2(Ljava/util/List;)I

    move-result p0

    return p0

    .line 217
    :cond_2
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullImsRegistrationStats(Ljava/util/List;)I

    move-result p0

    return p0

    .line 219
    :cond_3
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/MetricsCollector;->pullImsRegistrationTermination(Ljava/util/List;)I

    move-result p0

    return p0

    :pswitch_data_0
    .packed-switch 0x275c
        :pswitch_17
        :pswitch_16
        :pswitch_15
        :pswitch_14
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x2766
        :pswitch_13
        :pswitch_12
        :pswitch_11
        :pswitch_10
        :pswitch_f
        :pswitch_e
    .end packed-switch

    :pswitch_data_2
    .packed-switch 0x2795
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

.method public registerOngoingDataCallStat(Lcom/android/internal/telephony/metrics/DataCallSessionStats;)V
    .locals 0

    .line 268
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mOngoingDataCallStats:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public unregisterOngoingDataCallStat(Lcom/android/internal/telephony/metrics/DataCallSessionStats;)V
    .locals 0

    .line 273
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/MetricsCollector;->mOngoingDataCallStats:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    return-void
.end method
