.class public Lcom/android/internal/telephony/metrics/PersistAtomsStorage;
.super Ljava/lang/Object;
.source "PersistAtomsStorage.java"


# static fields
.field private static final FILENAME:Ljava/lang/String; = "persist_atoms.pb"

.field private static final SAVE_TO_FILE_DELAY_FOR_GET_MILLIS:I = 0x1f4

.field private static final SAVE_TO_FILE_DELAY_FOR_UPDATE_MILLIS:I = 0x7530

.field private static final TAG:Ljava/lang/String; = "PersistAtomsStorage"

.field private static final sRandom:Ljava/security/SecureRandom;


# instance fields
.field protected final mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private final mContext:Landroid/content/Context;

.field private final mHandler:Landroid/os/Handler;

.field private final mHandlerThread:Landroid/os/HandlerThread;

.field private final mMaxNumCarrierIdMismatches:I

.field private final mMaxNumCellularDataSwitches:I

.field private final mMaxNumCellularServiceStates:I

.field private final mMaxNumDataCallSessions:I

.field private final mMaxNumDedicatedBearerEventStats:I

.field private final mMaxNumDedicatedBearerListenerEventStats:I

.field private final mMaxNumGbaEventStats:I

.field private final mMaxNumImsRegistrationFeatureStats:I

.field private final mMaxNumImsRegistrationServiceDescStats:I

.field private final mMaxNumImsRegistrationStats:I

.field private final mMaxNumImsRegistrationTerminations:I

.field private final mMaxNumPresenceNotifyEventStats:I

.field private final mMaxNumRcsAcsProvisioningStats:I

.field private final mMaxNumRcsClientProvisioningStats:I

.field private final mMaxNumSipDelegateStats:I

.field private final mMaxNumSipMessageResponseStats:I

.field private final mMaxNumSipTransportFeatureTagStats:I

.field private final mMaxNumSipTransportSessionStats:I

.field private final mMaxNumSms:I

.field private final mMaxNumUceEventStats:I

.field private final mMaxNumVoiceCallSessions:I

.field protected mSaveImmediately:Z
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation
.end field

.field private mSaveRunnable:Ljava/lang/Runnable;

.field private final mVoiceCallRatTracker:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;


# direct methods
.method public static synthetic $r8$lambda$4BVQT5-38NQX1IMyXV8-vtavycg([Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;II)I
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->lambda$findItemToEvict$5([Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;II)I

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$5mOxrR3mWQ4kCQwyoDIF3Hq5NiU(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->lambda$getImsRegistrationTerminations$3(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)V

    return-void
.end method

.method public static synthetic $r8$lambda$KlVFBof4GmASDhBrIo3B-_Zxgwg(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->lambda$getCellularServiceStates$0(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)V

    return-void
.end method

.method public static synthetic $r8$lambda$V9pJ8N5oSmn8ESdiDUUexv1LwEI([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;II)I
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->lambda$findItemToEvict$7([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;II)I

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$ZRyRGTSsthPAgtgyQJW_Y8kxnd4([Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;I)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->lambda$findItemToEvict$8([Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;I)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$aPt_CfuNpBIvX5IsT-bjUMqDCUU(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->lambda$getCellularDataServiceSwitches$1(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V

    return-void
.end method

.method public static synthetic $r8$lambda$beg8vKap5vIyMyQafY0KoQO_AEI(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->lambda$getImsRegistrationStats$2(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)V

    return-void
.end method

.method public static synthetic $r8$lambda$p1lEBHi1on_Q29o23MH2KHnuQ0E([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;II)I
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->lambda$findItemToEvict$6([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;II)I

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$yD_UIplaoG44Dx7TcrdcN2lGunI([Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;II)I
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->lambda$findItemToEvict$4([Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;II)I

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$msaveAtomsToFileNow(Lcom/android/internal/telephony/metrics/PersistAtomsStorage;)V
    .locals 0

    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFileNow()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 170
    new-instance v0, Ljava/security/SecureRandom;

    invoke-direct {v0}, Ljava/security/SecureRandom;-><init>()V

    sput-object v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sRandom:Ljava/security/SecureRandom;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 4

    .line 180
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 172
    new-instance v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$1;-><init>(Lcom/android/internal/telephony/metrics/PersistAtomsStorage;)V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mSaveRunnable:Ljava/lang/Runnable;

    .line 181
    iput-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mContext:Landroid/content/Context;

    .line 183
    invoke-virtual {p1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p1

    const-string v0, "android.hardware.ram.low"

    invoke-virtual {p1, v0}, Landroid/content/pm/PackageManager;->hasSystemFeature(Ljava/lang/String;)Z

    move-result p1

    const/16 v0, 0xf

    const/16 v1, 0xa

    if-eqz p1, :cond_0

    .line 184
    sget-object p1, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->TAG:Ljava/lang/String;

    const-string v2, "Low RAM device"

    invoke-static {p1, v2}, Lcom/android/telephony/Rlog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 185
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumVoiceCallSessions:I

    const/4 p1, 0x5

    .line 186
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSms:I

    const/16 v2, 0x8

    .line 187
    iput v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCarrierIdMismatches:I

    .line 188
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDataCallSessions:I

    .line 189
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCellularServiceStates:I

    .line 190
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCellularDataSwitches:I

    .line 191
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationStats:I

    .line 192
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationTerminations:I

    .line 193
    iput v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationFeatureStats:I

    .line 194
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumRcsClientProvisioningStats:I

    .line 195
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumRcsAcsProvisioningStats:I

    .line 196
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipMessageResponseStats:I

    .line 197
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipTransportSessionStats:I

    .line 198
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipDelegateStats:I

    .line 199
    iput v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipTransportFeatureTagStats:I

    .line 200
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDedicatedBearerListenerEventStats:I

    .line 201
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDedicatedBearerEventStats:I

    .line 202
    iput v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationServiceDescStats:I

    .line 203
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumUceEventStats:I

    .line 204
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumPresenceNotifyEventStats:I

    .line 205
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumGbaEventStats:I

    goto :goto_0

    :cond_0
    const/16 p1, 0x32

    .line 207
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumVoiceCallSessions:I

    const/16 v2, 0x19

    .line 208
    iput v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSms:I

    const/16 v3, 0x28

    .line 209
    iput v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCarrierIdMismatches:I

    .line 210
    iput v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDataCallSessions:I

    .line 211
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCellularServiceStates:I

    .line 212
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCellularDataSwitches:I

    .line 213
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationStats:I

    .line 214
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationTerminations:I

    .line 215
    iput v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationFeatureStats:I

    .line 216
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumRcsClientProvisioningStats:I

    .line 217
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumRcsAcsProvisioningStats:I

    .line 218
    iput v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipMessageResponseStats:I

    .line 219
    iput v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipTransportSessionStats:I

    .line 220
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipDelegateStats:I

    .line 221
    iput v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipTransportFeatureTagStats:I

    .line 222
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDedicatedBearerListenerEventStats:I

    .line 223
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDedicatedBearerEventStats:I

    .line 224
    iput v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationServiceDescStats:I

    .line 225
    iput v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumUceEventStats:I

    .line 226
    iput p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumPresenceNotifyEventStats:I

    .line 227
    iput v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumGbaEventStats:I

    .line 230
    :goto_0
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->loadAtomsFromFile()Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    .line 231
    iget-object p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsage:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    invoke-static {p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->fromProto([Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;)Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mVoiceCallRatTracker:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    .line 233
    new-instance p1, Landroid/os/HandlerThread;

    const-string v0, "PersistAtomsThread"

    invoke-direct {p1, v0}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mHandlerThread:Landroid/os/HandlerThread;

    .line 234
    invoke-virtual {p1}, Landroid/os/HandlerThread;->start()V

    .line 235
    new-instance v0, Landroid/os/Handler;

    invoke-virtual {p1}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object p1

    invoke-direct {v0, p1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mHandler:Landroid/os/Handler;

    const/4 p1, 0x0

    .line 236
    iput-boolean p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mSaveImmediately:Z

    return-void
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;
    .locals 5

    .line 1291
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdMismatch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1292
    iget-object v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mccMnc:Ljava/lang/String;

    iget-object v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->mccMnc:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    iget-object v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->gid1:Ljava/lang/String;

    iget-object v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->gid1:Ljava/lang/String;

    .line 1293
    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    iget-object v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->spn:Ljava/lang/String;

    iget-object v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->spn:Ljava/lang/String;

    .line 1294
    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    iget-object v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->pnn:Ljava/lang/String;

    iget-object v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;->pnn:Ljava/lang/String;

    .line 1295
    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;
    .locals 5

    .line 1274
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1275
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->ratFrom:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->ratFrom:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->ratTo:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->ratTo:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->simSlotIndex:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->simSlotIndex:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->isMultiSim:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->isMultiSim:Z

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->carrierId:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;
    .locals 5

    .line 1253
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceState:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1254
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRat:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRat:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRat:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRoamingType:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->voiceRoamingType:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRoamingType:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->dataRoamingType:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEndc:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEndc:Z

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->simSlotIndex:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->simSlotIndex:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isMultiSim:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isMultiSim:Z

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->carrierId:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEmergencyOnly:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->isEmergencyOnly:Z

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;)Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;
    .locals 5

    .line 1540
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1541
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->slotId:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->successful:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->successful:Z

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->failedReason:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->failedReason:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;
    .locals 5

    .line 1384
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1385
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->ratAtEnd:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->ratAtEnd:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->qci:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->qci:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->bearerState:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->bearerState:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->localConnectionInfoReceived:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->localConnectionInfoReceived:Z

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->remoteConnectionInfoReceived:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->remoteConnectionInfoReceived:Z

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->hasListeners:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->hasListeners:Z

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;
    .locals 5

    .line 1366
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1367
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->ratAtEnd:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->ratAtEnd:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->qci:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->qci:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->dedicatedBearerEstablished:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->dedicatedBearerEstablished:Z

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;
    .locals 5

    .line 1405
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1406
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->featureTagName:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->featureTagName:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->registrationTech:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->registrationTech:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;
    .locals 5

    .line 1489
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1490
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->serviceIdName:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->serviceIdName:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->serviceIdVersion:F

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->serviceIdVersion:F

    cmpl-float v3, v3, v4

    if-nez v3, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->registrationTech:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->registrationTech:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;
    .locals 5

    .line 1307
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1308
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->simSlotIndex:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->simSlotIndex:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->rat:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->rat:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;
    .locals 5

    .line 1322
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTermination:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1323
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->carrierId:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->isMultiSim:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->isMultiSim:Z

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->ratAtEnd:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->ratAtEnd:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->setupFailed:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->setupFailed:Z

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->reasonCode:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->reasonCode:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->extraCode:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->extraCode:I

    if-ne v3, v4, :cond_0

    iget-object v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->extraMessage:Ljava/lang/String;

    iget-object v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->extraMessage:Ljava/lang/String;

    .line 1329
    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;
    .locals 5

    .line 1341
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1342
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->capability:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->capability:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;)Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;
    .locals 5

    .line 1524
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1525
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->reason:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->reason:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->contentBodyReceived:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->contentBodyReceived:Z

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;
    .locals 5

    .line 1436
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1437
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->responseCode:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->responseCode:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->responseType:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->responseType:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->isSingleRegistrationEnabled:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->isSingleRegistrationEnabled:Z

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;
    .locals 5

    .line 1421
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1422
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->event:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->event:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;)Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;
    .locals 5

    .line 1453
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponse:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1454
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageMethod:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageMethod:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageResponse:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageResponse:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageDirection:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->sipMessageDirection:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->messageError:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->messageError:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;
    .locals 5

    .line 1557
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1558
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->featureTagName:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->featureTagName:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->sipTransportDeregisteredReason:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->sipTransportDeregisteredReason:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->sipTransportDeniedReason:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->sipTransportDeniedReason:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;)Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;
    .locals 5

    .line 1471
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1472
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sessionMethod:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sessionMethod:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sipMessageDirection:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sipMessageDirection:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sipResponse:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sipResponse:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private find(Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;
    .locals 5

    .line 1506
    iget-object p0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    .line 1507
    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->carrierId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->carrierId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->slotId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->slotId:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->type:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->type:I

    if-ne v3, v4, :cond_0

    iget-boolean v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->successful:Z

    iget-boolean v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->successful:Z

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->commandCode:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->commandCode:I

    if-ne v3, v4, :cond_0

    iget v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->networkResponse:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->networkResponse:I

    if-ne v3, v4, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private findIndex(Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)I
    .locals 3

    const/4 v0, 0x0

    .line 1354
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    array-length v2, v1

    if-ge v0, v2, :cond_1

    .line 1355
    aget-object v1, v1, v0

    iget v1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->dimension:I

    iget v2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->dimension:I

    if-ne v1, v2, :cond_0

    return v0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method private static findItemToEvict([Ljava/lang/Object;)I
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">([TT;)I"
        }
    .end annotation

    .line 1592
    instance-of v0, p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 1594
    check-cast p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    .line 1595
    array-length v0, p0

    invoke-static {v1, v0}, Ljava/util/stream/IntStream;->range(II)Ljava/util/stream/IntStream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda3;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda3;-><init>([Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)V

    .line 1596
    invoke-interface {v0, v1}, Ljava/util/stream/IntStream;->reduce(Ljava/util/function/IntBinaryOperator;)Ljava/util/OptionalInt;

    move-result-object p0

    .line 1597
    invoke-virtual {p0}, Ljava/util/OptionalInt;->getAsInt()I

    move-result p0

    return p0

    .line 1600
    :cond_0
    instance-of v0, p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    if-eqz v0, :cond_1

    .line 1602
    check-cast p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    .line 1603
    array-length v0, p0

    invoke-static {v1, v0}, Ljava/util/stream/IntStream;->range(II)Ljava/util/stream/IntStream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda4;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda4;-><init>([Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V

    .line 1604
    invoke-interface {v0, v1}, Ljava/util/stream/IntStream;->reduce(Ljava/util/function/IntBinaryOperator;)Ljava/util/OptionalInt;

    move-result-object p0

    .line 1605
    invoke-virtual {p0}, Ljava/util/OptionalInt;->getAsInt()I

    move-result p0

    return p0

    .line 1608
    :cond_1
    instance-of v0, p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    if-eqz v0, :cond_2

    .line 1610
    check-cast p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    .line 1611
    array-length v0, p0

    invoke-static {v1, v0}, Ljava/util/stream/IntStream;->range(II)Ljava/util/stream/IntStream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda5;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda5;-><init>([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)V

    .line 1612
    invoke-interface {v0, v1}, Ljava/util/stream/IntStream;->reduce(Ljava/util/function/IntBinaryOperator;)Ljava/util/OptionalInt;

    move-result-object p0

    .line 1613
    invoke-virtual {p0}, Ljava/util/OptionalInt;->getAsInt()I

    move-result p0

    return p0

    .line 1616
    :cond_2
    instance-of v0, p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    if-eqz v0, :cond_3

    .line 1618
    check-cast p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    .line 1619
    array-length v0, p0

    invoke-static {v1, v0}, Ljava/util/stream/IntStream;->range(II)Ljava/util/stream/IntStream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda6;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda6;-><init>([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)V

    .line 1620
    invoke-interface {v0, v1}, Ljava/util/stream/IntStream;->reduce(Ljava/util/function/IntBinaryOperator;)Ljava/util/OptionalInt;

    move-result-object p0

    .line 1621
    invoke-virtual {p0}, Ljava/util/OptionalInt;->getAsInt()I

    move-result p0

    return p0

    .line 1624
    :cond_3
    instance-of v0, p0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    if-eqz v0, :cond_4

    .line 1626
    move-object v0, p0

    check-cast v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    .line 1627
    array-length v2, v0

    invoke-static {v1, v2}, Ljava/util/stream/IntStream;->range(II)Ljava/util/stream/IntStream;

    move-result-object v1

    new-instance v2, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda7;

    invoke-direct {v2, v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda7;-><init>([Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V

    .line 1628
    invoke-interface {v1, v2}, Ljava/util/stream/IntStream;->filter(Ljava/util/function/IntPredicate;)Ljava/util/stream/IntStream;

    move-result-object v0

    .line 1629
    invoke-interface {v0}, Ljava/util/stream/IntStream;->toArray()[I

    move-result-object v0

    .line 1630
    array-length v1, v0

    if-lez v1, :cond_4

    .line 1631
    sget-object p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sRandom:Ljava/security/SecureRandom;

    array-length v1, v0

    invoke-virtual {p0, v1}, Ljava/security/SecureRandom;->nextInt(I)I

    move-result p0

    aget p0, v0, p0

    return p0

    .line 1637
    :cond_4
    sget-object v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sRandom:Ljava/security/SecureRandom;

    array-length p0, p0

    invoke-virtual {v0, p0}, Ljava/security/SecureRandom;->nextInt(I)I

    move-result p0

    return p0
.end method

.method private static insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">([TT;TT;I)[TT;"
        }
    .end annotation

    .line 1574
    array-length v0, p0

    const/4 v1, 0x1

    add-int/2addr v0, v1

    const/4 v2, 0x0

    if-le v0, p2, :cond_0

    move v3, v1

    goto :goto_0

    :cond_0
    move v3, v2

    :goto_0
    if-eqz v3, :cond_1

    goto :goto_1

    :cond_1
    move p2, v0

    .line 1576
    :goto_1
    invoke-static {p0, p2}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p2

    if-ne v0, v1, :cond_2

    .line 1578
    aput-object p1, p2, v2

    goto :goto_2

    :cond_2
    if-eqz v3, :cond_3

    .line 1580
    invoke-static {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->findItemToEvict([Ljava/lang/Object;)I

    move-result p0

    aput-object p1, p2, p0

    goto :goto_2

    .line 1583
    :cond_3
    sget-object p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sRandom:Ljava/security/SecureRandom;

    invoke-virtual {p0, v0}, Ljava/security/SecureRandom;->nextInt(I)I

    move-result p0

    sub-int/2addr v0, v1

    .line 1584
    aget-object v1, p2, p0

    aput-object v1, p2, v0

    .line 1585
    aput-object p1, p2, p0

    :goto_2
    return-object p2
.end method

.method private static synthetic lambda$findItemToEvict$4([Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;II)I
    .locals 4

    .line 1596
    aget-object v0, p0, p1

    iget-wide v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->lastUsedMillis:J

    aget-object p0, p0, p2

    iget-wide v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->lastUsedMillis:J

    cmp-long p0, v0, v2

    if-gez p0, :cond_0

    goto :goto_0

    :cond_0
    move p1, p2

    :goto_0
    return p1
.end method

.method private static synthetic lambda$findItemToEvict$5([Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;II)I
    .locals 4

    .line 1604
    aget-object v0, p0, p1

    iget-wide v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->lastUsedMillis:J

    aget-object p0, p0, p2

    iget-wide v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->lastUsedMillis:J

    cmp-long p0, v0, v2

    if-gez p0, :cond_0

    goto :goto_0

    :cond_0
    move p1, p2

    :goto_0
    return p1
.end method

.method private static synthetic lambda$findItemToEvict$6([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;II)I
    .locals 4

    .line 1612
    aget-object v0, p0, p1

    iget-wide v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->lastUsedMillis:J

    aget-object p0, p0, p2

    iget-wide v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->lastUsedMillis:J

    cmp-long p0, v0, v2

    if-gez p0, :cond_0

    goto :goto_0

    :cond_0
    move p1, p2

    :goto_0
    return p1
.end method

.method private static synthetic lambda$findItemToEvict$7([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;II)I
    .locals 4

    .line 1620
    aget-object v0, p0, p1

    iget-wide v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->lastUsedMillis:J

    aget-object p0, p0, p2

    iget-wide v2, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->lastUsedMillis:J

    cmp-long p0, v0, v2

    if-gez p0, :cond_0

    goto :goto_0

    :cond_0
    move p1, p2

    :goto_0
    return p1
.end method

.method private static synthetic lambda$findItemToEvict$8([Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;I)Z
    .locals 0

    .line 1628
    aget-object p0, p0, p1

    iget-boolean p0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;->isEmergency:Z

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private static synthetic lambda$getCellularDataServiceSwitches$1(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V
    .locals 2

    const-wide/16 v0, 0x0

    .line 725
    iput-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->lastUsedMillis:J

    return-void
.end method

.method private static synthetic lambda$getCellularServiceStates$0(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)V
    .locals 2

    const-wide/16 v0, 0x0

    .line 704
    iput-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->lastUsedMillis:J

    return-void
.end method

.method private static synthetic lambda$getImsRegistrationStats$2(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)V
    .locals 2

    const-wide/16 v0, 0x0

    .line 745
    iput-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->lastUsedMillis:J

    return-void
.end method

.method private static synthetic lambda$getImsRegistrationTerminations$3(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)V
    .locals 2

    const-wide/16 v0, 0x0

    .line 766
    iput-wide v0, p0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->lastUsedMillis:J

    return-void
.end method

.method private loadAtomsFromFile()Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;
    .locals 4

    .line 1048
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mContext:Landroid/content/Context;

    const-string v1, "persist_atoms.pb"

    .line 1050
    invoke-virtual {v0, v1}, Landroid/content/Context;->getFileStreamPath(Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object v0

    invoke-static {v0}, Ljava/nio/file/Files;->readAllBytes(Ljava/nio/file/Path;)[B

    move-result-object v0

    .line 1049
    invoke-static {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->parseFrom([B)Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    move-result-object v0

    .line 1053
    sget-object v1, Landroid/os/Build;->FINGERPRINT:Ljava/lang/String;

    iget-object v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->buildFingerprint:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 1054
    sget-object v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->TAG:Ljava/lang/String;

    const-string v1, "Build changed"

    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1055
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->makeNewPersistAtoms()Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    move-result-object p0

    return-object p0

    .line 1058
    :cond_0
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsage:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    .line 1059
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsage:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    .line 1060
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumVoiceCallSessions:I

    .line 1061
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    .line 1065
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSms:I

    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    .line 1066
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSms:I

    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    .line 1067
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdMismatch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCarrierIdMismatches:I

    .line 1068
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdMismatch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    .line 1072
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDataCallSessions:I

    .line 1073
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    .line 1077
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceState:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCellularServiceStates:I

    .line 1078
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceState:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    .line 1082
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCellularDataSwitches:I

    .line 1083
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    .line 1087
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationStats:I

    .line 1088
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    .line 1092
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTermination:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationTerminations:I

    .line 1093
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTermination:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    .line 1097
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    .line 1098
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    .line 1099
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationFeatureStats:I

    .line 1100
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    .line 1104
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumRcsClientProvisioningStats:I

    .line 1105
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    .line 1109
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumRcsAcsProvisioningStats:I

    .line 1110
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    .line 1114
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipDelegateStats:I

    .line 1115
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    .line 1119
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipTransportFeatureTagStats:I

    .line 1120
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    .line 1124
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponse:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipMessageResponseStats:I

    .line 1125
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponse:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    .line 1129
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipTransportSessionStats:I

    .line 1130
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    .line 1134
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDedicatedBearerListenerEventStats:I

    .line 1135
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    .line 1139
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDedicatedBearerEventStats:I

    .line 1140
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    .line 1144
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationServiceDescStats:I

    .line 1145
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    .line 1149
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumUceEventStats:I

    .line 1150
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    .line 1154
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumPresenceNotifyEventStats:I

    .line 1155
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    .line 1159
    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    const-class v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    iget v3, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumGbaEventStats:I

    .line 1160
    invoke-direct {p0, v1, v2, v3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    .line 1166
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsagePullTimestampMillis:J

    .line 1167
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsagePullTimestampMillis:J

    .line 1168
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSessionPullTimestampMillis:J

    .line 1169
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSessionPullTimestampMillis:J

    .line 1170
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSmsPullTimestampMillis:J

    .line 1171
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSmsPullTimestampMillis:J

    .line 1172
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSmsPullTimestampMillis:J

    .line 1173
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSmsPullTimestampMillis:J

    .line 1174
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSessionPullTimestampMillis:J

    .line 1175
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSessionPullTimestampMillis:J

    .line 1176
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceStatePullTimestampMillis:J

    .line 1177
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceStatePullTimestampMillis:J

    .line 1178
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitchPullTimestampMillis:J

    .line 1179
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitchPullTimestampMillis:J

    .line 1180
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStatsPullTimestampMillis:J

    .line 1181
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStatsPullTimestampMillis:J

    .line 1182
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTerminationPullTimestampMillis:J

    .line 1183
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTerminationPullTimestampMillis:J

    .line 1184
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2PullTimestampMillis:J

    .line 1185
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2PullTimestampMillis:J

    .line 1186
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStatsPullTimestampMillis:J

    .line 1187
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStatsPullTimestampMillis:J

    .line 1188
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStatsPullTimestampMillis:J

    .line 1189
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStatsPullTimestampMillis:J

    .line 1190
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStatsPullTimestampMillis:J

    .line 1191
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStatsPullTimestampMillis:J

    .line 1192
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStatsPullTimestampMillis:J

    .line 1193
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStatsPullTimestampMillis:J

    .line 1194
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStatsPullTimestampMillis:J

    .line 1195
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStatsPullTimestampMillis:J

    .line 1196
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponsePullTimestampMillis:J

    .line 1197
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponsePullTimestampMillis:J

    .line 1198
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSessionPullTimestampMillis:J

    .line 1199
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSessionPullTimestampMillis:J

    .line 1200
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEventPullTimestampMillis:J

    .line 1201
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEventPullTimestampMillis:J

    .line 1202
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEventPullTimestampMillis:J

    .line 1203
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEventPullTimestampMillis:J

    .line 1204
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStatsPullTimestampMillis:J

    .line 1205
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStatsPullTimestampMillis:J

    .line 1206
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStatsPullTimestampMillis:J

    .line 1207
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStatsPullTimestampMillis:J

    .line 1208
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEventPullTimestampMillis:J

    .line 1209
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEventPullTimestampMillis:J

    .line 1210
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEventPullTimestampMillis:J

    .line 1211
    invoke-direct {p0, v1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeTimestamp(J)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEventPullTimestampMillis:J
    :try_end_0
    .catch Ljava/nio/file/NoSuchFileException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/NullPointerException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    move-exception v0

    .line 1217
    sget-object v1, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->TAG:Ljava/lang/String;

    const-string v2, "cannot load/parse PersistAtoms"

    invoke-static {v1, v2, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0

    .line 1215
    :catch_1
    sget-object v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->TAG:Ljava/lang/String;

    const-string v1, "PersistAtoms file not found"

    invoke-static {v0, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1219
    :goto_0
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->makeNewPersistAtoms()Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    move-result-object p0

    return-object p0
.end method

.method private makeNewPersistAtoms()Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;
    .locals 3

    .line 1696
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;-><init>()V

    .line 1698
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v1

    .line 1699
    sget-object p0, Landroid/os/Build;->FINGERPRINT:Ljava/lang/String;

    iput-object p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->buildFingerprint:Ljava/lang/String;

    .line 1700
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsagePullTimestampMillis:J

    .line 1701
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSessionPullTimestampMillis:J

    .line 1702
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSmsPullTimestampMillis:J

    .line 1703
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSmsPullTimestampMillis:J

    const/4 p0, -0x1

    .line 1704
    iput p0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdTableVersion:I

    .line 1705
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSessionPullTimestampMillis:J

    .line 1706
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceStatePullTimestampMillis:J

    .line 1707
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitchPullTimestampMillis:J

    .line 1708
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStatsPullTimestampMillis:J

    .line 1709
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTerminationPullTimestampMillis:J

    .line 1710
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsPullTimestampMillis:J

    .line 1711
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2PullTimestampMillis:J

    .line 1712
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStatsPullTimestampMillis:J

    .line 1713
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStatsPullTimestampMillis:J

    .line 1714
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStatsPullTimestampMillis:J

    .line 1715
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStatsPullTimestampMillis:J

    .line 1716
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStatsPullTimestampMillis:J

    .line 1717
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponsePullTimestampMillis:J

    .line 1718
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSessionPullTimestampMillis:J

    .line 1719
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEventPullTimestampMillis:J

    .line 1720
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEventPullTimestampMillis:J

    .line 1721
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStatsPullTimestampMillis:J

    .line 1722
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStatsPullTimestampMillis:J

    .line 1723
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEventPullTimestampMillis:J

    .line 1724
    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEventPullTimestampMillis:J

    .line 1726
    sget-object p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->TAG:Ljava/lang/String;

    const-string v1, "created new PersistAtoms"

    invoke-static {p0, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v0
.end method

.method private normalizeData([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;
    .locals 4

    const/4 v0, 0x0

    .line 1665
    :goto_0
    array-length v1, p1

    if-ge v0, v1, :cond_0

    .line 1666
    aget-object v1, p1, v0

    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->registeredMillis:J

    .line 1667
    invoke-direct {p0, v2, v3, p2, p3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeDurationTo24H(JJ)J

    move-result-wide v2

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->registeredMillis:J

    .line 1668
    aget-object v1, p1, v0

    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceCapableMillis:J

    .line 1669
    invoke-direct {p0, v2, v3, p2, p3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeDurationTo24H(JJ)J

    move-result-wide v2

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceCapableMillis:J

    .line 1670
    aget-object v1, p1, v0

    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceAvailableMillis:J

    .line 1671
    invoke-direct {p0, v2, v3, p2, p3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeDurationTo24H(JJ)J

    move-result-wide v2

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceAvailableMillis:J

    .line 1672
    aget-object v1, p1, v0

    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsCapableMillis:J

    .line 1673
    invoke-direct {p0, v2, v3, p2, p3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeDurationTo24H(JJ)J

    move-result-wide v2

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsCapableMillis:J

    .line 1674
    aget-object v1, p1, v0

    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsAvailableMillis:J

    .line 1675
    invoke-direct {p0, v2, v3, p2, p3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeDurationTo24H(JJ)J

    move-result-wide v2

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsAvailableMillis:J

    .line 1676
    aget-object v1, p1, v0

    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoCapableMillis:J

    .line 1677
    invoke-direct {p0, v2, v3, p2, p3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeDurationTo24H(JJ)J

    move-result-wide v2

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoCapableMillis:J

    .line 1678
    aget-object v1, p1, v0

    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoAvailableMillis:J

    .line 1679
    invoke-direct {p0, v2, v3, p2, p3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeDurationTo24H(JJ)J

    move-result-wide v2

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoAvailableMillis:J

    .line 1680
    aget-object v1, p1, v0

    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utCapableMillis:J

    .line 1681
    invoke-direct {p0, v2, v3, p2, p3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeDurationTo24H(JJ)J

    move-result-wide v2

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utCapableMillis:J

    .line 1682
    aget-object v1, p1, v0

    iget-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utAvailableMillis:J

    .line 1683
    invoke-direct {p0, v2, v3, p2, p3}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeDurationTo24H(JJ)J

    move-result-wide v2

    iput-wide v2, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utAvailableMillis:J

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-object p1
.end method

.method private normalizeDurationTo24H(JJ)J
    .locals 4

    const-wide/16 v0, 0x3e8

    cmp-long p0, p3, v0

    if-gez p0, :cond_0

    const-wide/16 p3, 0x1

    goto :goto_0

    .line 1690
    :cond_0
    div-long/2addr p3, v0

    .line 1691
    :goto_0
    div-long/2addr p1, v0

    const-wide/32 v2, 0x15180

    mul-long/2addr p1, v2

    div-long/2addr p1, p3

    mul-long/2addr p1, v0

    return-wide p1
.end method

.method private sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;)[Ljava/lang/Object;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">([TT;",
            "Ljava/lang/Class<",
            "TT;>;)[TT;"
        }
    .end annotation

    .line 1642
    invoke-static {p1, p2}, Lcom/android/internal/util/ArrayUtils;->emptyIfNull([Ljava/lang/Object;Ljava/lang/Class;)[Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;I)[Ljava/lang/Object;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">([TT;",
            "Ljava/lang/Class<",
            "TT;>;I)[TT;"
        }
    .end annotation

    .line 1647
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->sanitizeAtoms([Ljava/lang/Object;Ljava/lang/Class;)[Ljava/lang/Object;

    move-result-object p0

    .line 1648
    array-length p1, p0

    if-le p1, p3, :cond_0

    .line 1649
    invoke-static {p0, p3}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p0

    :cond_0
    return-object p0
.end method

.method private sanitizeTimestamp(J)J
    .locals 2

    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    if-gtz v0, :cond_0

    .line 1656
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    :cond_0
    return-wide p1
.end method

.method private saveAtomsToFile(I)V
    .locals 4

    if-lez p1, :cond_0

    .line 1229
    iget-boolean v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mSaveImmediately:Z

    if-nez v0, :cond_0

    .line 1230
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mSaveRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1231
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mSaveRunnable:Ljava/lang/Runnable;

    int-to-long v2, p1

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 1236
    :cond_0
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFileNow()V

    return-void
.end method

.method private declared-synchronized saveAtomsToFileNow()V
    .locals 3

    monitor-enter p0

    .line 1241
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mContext:Landroid/content/Context;

    const-string v1, "persist_atoms.pb"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->openFileOutput(Ljava/lang/String;I)Ljava/io/FileOutputStream;

    move-result-object v0
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    .line 1242
    :try_start_1
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    invoke-static {v1}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toByteArray(Lcom/android/internal/telephony/protobuf/nano/MessageNano;)[B

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/io/FileOutputStream;->write([B)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1243
    :try_start_2
    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    goto :goto_1

    :catchall_0
    move-exception v1

    if-eqz v0, :cond_0

    .line 1241
    :try_start_3
    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    goto :goto_0

    :catchall_1
    move-exception v0

    :try_start_4
    invoke-virtual {v1, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_0
    :goto_0
    throw v1
    :try_end_4
    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_2

    :catchall_2
    move-exception v0

    goto :goto_2

    :catch_0
    move-exception v0

    .line 1244
    :try_start_5
    sget-object v1, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->TAG:Ljava/lang/String;

    const-string v2, "cannot save PersistAtoms"

    invoke-static {v1, v2, v0}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_2

    .line 1246
    :goto_1
    monitor-exit p0

    return-void

    :goto_2
    monitor-exit p0

    throw v0
.end method


# virtual methods
.method public declared-synchronized addCarrierIdMismatch(Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;)Z
    .locals 6

    monitor-enter p0

    .line 338
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 339
    monitor-exit p0

    return v1

    .line 343
    :cond_0
    :try_start_1
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdMismatch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    array-length v3, v2

    iget v4, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCarrierIdMismatches:I

    const/4 v5, 0x1

    if-ne v3, v4, :cond_1

    sub-int/2addr v4, v5

    .line 344
    invoke-static {v2, v5, v2, v1, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 350
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdMismatch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    iget v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCarrierIdMismatches:I

    sub-int/2addr v1, v5

    aput-object p1, v0, v1

    goto :goto_0

    .line 352
    :cond_1
    array-length v1, v2

    add-int/2addr v1, v5

    .line 353
    invoke-static {v2, v1}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v2

    check-cast v2, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    iput-object v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdMismatch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    .line 354
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdMismatch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CarrierIdMismatch;

    sub-int/2addr v1, v5

    aput-object p1, v0, v1

    :goto_0
    const/16 p1, 0x7530

    .line 356
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 357
    monitor-exit p0

    return v5

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addCellularServiceStateAndCellularDataServiceSwitch(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)V
    .locals 5

    monitor-enter p0

    .line 285
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 287
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->totalTimeMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->totalTimeMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->totalTimeMillis:J

    .line 288
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->lastUsedMillis:J

    goto :goto_0

    .line 290
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iput-wide v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;->lastUsedMillis:J

    .line 291
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceState:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCellularServiceStates:I

    .line 292
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceState:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    :goto_0
    if-eqz p2, :cond_2

    .line 297
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;)Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    move-result-object p1

    if-eqz p1, :cond_1

    .line 299
    iget v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->switchCount:I

    iget p2, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->switchCount:I

    add-int/2addr v0, p2

    iput v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->switchCount:I

    .line 300
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iput-wide v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->lastUsedMillis:J

    goto :goto_1

    .line 302
    :cond_1
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iput-wide v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;->lastUsedMillis:J

    .line 303
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    iget v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumCellularDataSwitches:I

    .line 304
    invoke-static {v0, p2, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p2

    check-cast p2, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    iput-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    :cond_2
    :goto_1
    const/16 p1, 0x7530

    .line 311
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 312
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addCompleteSipTransportSession(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;)V
    .locals 3

    monitor-enter p0

    .line 509
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;)Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 511
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sessionCount:I

    add-int/lit8 v1, v1, 0x1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->sessionCount:I

    .line 512
    iget-boolean p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->isEndedGracefully:Z

    if-eqz p1, :cond_1

    .line 513
    iget p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->endedGracefullyCount:I

    add-int/lit8 p1, p1, 0x1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;->endedGracefullyCount:I

    goto :goto_0

    .line 516
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipTransportSessionStats:I

    .line 517
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    :cond_1
    :goto_0
    const/16 p1, 0x7530

    .line 520
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 521
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addDataCallSession(Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)V
    .locals 7

    monitor-enter p0

    .line 316
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->findIndex(Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;)I

    move-result v0

    if-ltz v0, :cond_0

    .line 318
    iget-object v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    aget-object v2, v1, v0

    .line 319
    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    iget-wide v5, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    add-long/2addr v3, v5

    iput-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->ratSwitchCount:J

    .line 320
    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->durationMinutes:J

    iget-wide v5, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->durationMinutes:J

    add-long/2addr v3, v5

    iput-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->durationMinutes:J

    .line 321
    aput-object p1, v1, v0

    goto :goto_0

    .line 323
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDataCallSessions:I

    .line 324
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    :goto_0
    const/16 p1, 0x7530

    .line 327
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 328
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addGbaEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;)V
    .locals 3

    monitor-enter p0

    .line 594
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;)Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 596
    iget p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->count:I

    add-int/lit8 p1, p1, 0x1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;->count:I

    goto :goto_0

    .line 598
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumGbaEventStats:I

    .line 599
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    :goto_0
    const/16 p1, 0x7530

    .line 601
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 602
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addImsDedicatedBearerEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;)V
    .locals 3

    monitor-enter p0

    .line 539
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 541
    iget p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->count:I

    add-int/lit8 p1, p1, 0x1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;->count:I

    goto :goto_0

    .line 543
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDedicatedBearerEventStats:I

    .line 544
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    :goto_0
    const/16 p1, 0x7530

    .line 547
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 548
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addImsDedicatedBearerListenerEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;)V
    .locals 3

    monitor-enter p0

    .line 526
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 528
    iget p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->eventCount:I

    add-int/lit8 p1, p1, 0x1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;->eventCount:I

    goto :goto_0

    .line 530
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumDedicatedBearerListenerEventStats:I

    .line 531
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    :goto_0
    const/16 p1, 0x7530

    .line 534
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 535
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addImsRegistrationFeatureTagStats(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;)V
    .locals 5

    monitor-enter p0

    .line 435
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 437
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->registeredMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->registeredMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;->registeredMillis:J

    goto :goto_0

    .line 439
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationFeatureStats:I

    .line 440
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    :goto_0
    const/16 p1, 0x7530

    .line 443
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 444
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addImsRegistrationServiceDescStats(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;)V
    .locals 5

    monitor-enter p0

    .line 553
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 555
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->publishedMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->publishedMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;->publishedMillis:J

    goto :goto_0

    .line 557
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationServiceDescStats:I

    .line 558
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    :goto_0
    const/16 p1, 0x7530

    .line 561
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 562
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addImsRegistrationStats(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)V
    .locals 5

    monitor-enter p0

    .line 362
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 364
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->registeredMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->registeredMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->registeredMillis:J

    .line 365
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceCapableMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceCapableMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceCapableMillis:J

    .line 366
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceAvailableMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceAvailableMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->voiceAvailableMillis:J

    .line 367
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsCapableMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsCapableMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsCapableMillis:J

    .line 368
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsAvailableMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsAvailableMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->smsAvailableMillis:J

    .line 369
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoCapableMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoCapableMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoCapableMillis:J

    .line 370
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoAvailableMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoAvailableMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->videoAvailableMillis:J

    .line 371
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utCapableMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utCapableMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utCapableMillis:J

    .line 372
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utAvailableMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utAvailableMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->utAvailableMillis:J

    .line 373
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->lastUsedMillis:J

    goto :goto_0

    .line 375
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iput-wide v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;->lastUsedMillis:J

    .line 376
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationStats:I

    .line 377
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    :goto_0
    const/16 p1, 0x7530

    .line 380
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 381
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addImsRegistrationTermination(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)V
    .locals 3

    monitor-enter p0

    .line 385
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;)Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 387
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->count:I

    iget p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->count:I

    add-int/2addr v1, p1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->count:I

    .line 388
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v1

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->lastUsedMillis:J

    goto :goto_0

    .line 390
    :cond_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iput-wide v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;->lastUsedMillis:J

    .line 391
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTermination:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumImsRegistrationTerminations:I

    .line 392
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTermination:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    :goto_0
    const/16 p1, 0x7530

    .line 397
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 398
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addIncomingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;)V
    .locals 3

    monitor-enter p0

    .line 257
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSms:I

    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    const/16 v0, 0x7530

    .line 258
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V

    .line 261
    sget-object v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Add new incoming SMS atom: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 262
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addNetworkRequestsV2(Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)V
    .locals 3

    monitor-enter p0

    .line 417
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;)Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 419
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->requestCount:I

    iget p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->requestCount:I

    add-int/2addr v1, p1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->requestCount:I

    goto :goto_0

    .line 421
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    invoke-direct {v0}, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;-><init>()V

    .line 422
    iget v1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->capability:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->capability:I

    .line 423
    iget v1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->carrierId:I

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->carrierId:I

    .line 424
    iget p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->requestCount:I

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;->requestCount:I

    .line 425
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    array-length v2, v1

    add-int/lit8 v2, v2, 0x1

    .line 426
    invoke-static {v1, v2}, Ljava/util/Arrays;->copyOf([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    iput-object v1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    .line 427
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    add-int/lit8 v2, v2, -0x1

    aput-object v0, p1, v2

    :goto_0
    const/16 p1, 0x7530

    .line 429
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 430
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addOutgoingSms(Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;)V
    .locals 8

    monitor-enter p0

    .line 269
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v0, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 270
    iget-wide v4, v3, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->messageId:J

    iget-wide v6, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->messageId:J

    cmp-long v4, v4, v6

    if-nez v4, :cond_0

    iget v3, v3, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->retryId:I

    iget v4, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->retryId:I

    if-lt v3, v4, :cond_0

    add-int/lit8 v3, v3, 0x1

    .line 271
    iput v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;->retryId:I

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 275
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSms:I

    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    const/16 v0, 0x7530

    .line 276
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V

    .line 279
    sget-object v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Add new outgoing SMS atom: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 280
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addPresenceNotifyEvent(Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;)V
    .locals 3

    monitor-enter p0

    .line 578
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;)Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 580
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->rcsCapsCount:I

    iget v2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->rcsCapsCount:I

    add-int/2addr v1, v2

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->rcsCapsCount:I

    .line 581
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->mmtelCapsCount:I

    iget v2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->mmtelCapsCount:I

    add-int/2addr v1, v2

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->mmtelCapsCount:I

    .line 582
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->noCapsCount:I

    iget v2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->noCapsCount:I

    add-int/2addr v1, v2

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->noCapsCount:I

    .line 583
    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->count:I

    iget p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->count:I

    add-int/2addr v1, p1

    iput v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;->count:I

    goto :goto_0

    .line 585
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumPresenceNotifyEventStats:I

    .line 586
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    :goto_0
    const/16 p1, 0x7530

    .line 589
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 590
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addRcsAcsProvisioningStats(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;)V
    .locals 5

    monitor-enter p0

    .line 461
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    move-result-object v0

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    .line 463
    iget v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->count:I

    add-int/2addr v2, v1

    iput v2, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->count:I

    .line 464
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->stateTimerMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->stateTimerMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->stateTimerMillis:J

    goto :goto_0

    .line 467
    :cond_0
    iput v1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;->count:I

    .line 468
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumRcsAcsProvisioningStats:I

    .line 469
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    :goto_0
    const/16 p1, 0x7530

    .line 472
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 473
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addRcsClientProvisioningStats(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;)V
    .locals 3

    monitor-enter p0

    .line 448
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 450
    iget p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->count:I

    add-int/lit8 p1, p1, 0x1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;->count:I

    goto :goto_0

    .line 452
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumRcsClientProvisioningStats:I

    .line 453
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    :goto_0
    const/16 p1, 0x7530

    .line 456
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 457
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addSipDelegateStats(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;)V
    .locals 3

    monitor-enter p0

    .line 477
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipDelegateStats:I

    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    const/16 p1, 0x7530

    .line 479
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 480
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addSipMessageResponse(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;)V
    .locals 3

    monitor-enter p0

    .line 497
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;)Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 499
    iget p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->count:I

    add-int/lit8 p1, p1, 0x1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;->count:I

    goto :goto_0

    .line 501
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponse:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipMessageResponseStats:I

    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponse:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    :goto_0
    const/16 p1, 0x7530

    .line 504
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 505
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addSipTransportFeatureTagStats(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;)V
    .locals 5

    monitor-enter p0

    .line 484
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 486
    iget-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->associatedMillis:J

    iget-wide v3, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->associatedMillis:J

    add-long/2addr v1, v3

    iput-wide v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;->associatedMillis:J

    goto :goto_0

    .line 488
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumSipTransportFeatureTagStats:I

    .line 489
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    :goto_0
    const/16 p1, 0x7530

    .line 492
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 493
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addUceEventStats(Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;)V
    .locals 3

    monitor-enter p0

    .line 566
    :try_start_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->find(Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;)Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 568
    iget p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->count:I

    add-int/lit8 p1, p1, 0x1

    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;->count:I

    goto :goto_0

    .line 570
    :cond_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumUceEventStats:I

    .line 571
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    iput-object p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    :goto_0
    const/16 p1, 0x7530

    .line 573
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 574
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addVoiceCallRatUsage(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;)V
    .locals 1

    monitor-enter p0

    .line 250
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mVoiceCallRatTracker:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->mergeWith(Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;)Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    .line 251
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mVoiceCallRatTracker:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    invoke-virtual {v0}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->toProto()[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    move-result-object v0

    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsage:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    const/16 p1, 0x7530

    .line 252
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 253
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized addVoiceCallSession(Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;)V
    .locals 3

    monitor-enter p0

    .line 241
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    iget v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mMaxNumVoiceCallSessions:I

    .line 242
    invoke-static {v1, p1, v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->insertAtRandomPlace([Ljava/lang/Object;Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    iput-object v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    const/16 v0, 0x7530

    .line 243
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V

    .line 245
    sget-object v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Add new voice call session: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/protobuf/nano/MessageNano;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 246
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public flushAtoms()V
    .locals 2

    .line 1039
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mSaveRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1040
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mSaveRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1041
    invoke-direct {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFileNow()V

    :cond_0
    return-void
.end method

.method public declared-synchronized getCellularDataServiceSwitches(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;
    .locals 5

    monitor-enter p0

    .line 720
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitchPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 722
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitchPullTimestampMillis:J

    .line 723
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    .line 724
    invoke-static {p1}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda1;

    invoke-direct {v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda1;-><init>()V

    .line 725
    invoke-interface {p2, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 726
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    iput-object v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularDataServiceSwitch:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularDataServiceSwitch;

    const/16 p2, 0x1f4

    .line 727
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 728
    monitor-exit p0

    return-object p1

    :cond_0
    const/4 p1, 0x0

    .line 730
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getCellularServiceStates(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;
    .locals 5

    monitor-enter p0

    .line 700
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceStatePullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 702
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceStatePullTimestampMillis:J

    .line 703
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceState:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    .line 704
    invoke-static {p1}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda2;

    invoke-direct {v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda2;-><init>()V

    invoke-interface {p2, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 705
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    iput-object v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->cellularServiceState:[Lcom/android/internal/telephony/nano/PersistAtomsProto$CellularServiceState;

    const/16 p2, 0x1f4

    .line 706
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 707
    monitor-exit p0

    return-object p1

    :cond_0
    const/4 p1, 0x0

    .line 709
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getDataCallSessions(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;
    .locals 5

    monitor-enter p0

    .line 679
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSessionPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_1

    .line 680
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSessionPullTimestampMillis:J

    .line 681
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    const/4 v0, 0x0

    new-array v1, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    .line 682
    iput-object v1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->dataCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;

    const/16 p1, 0x1f4

    .line 683
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V

    .line 684
    array-length p1, p2

    :goto_0
    if-ge v0, p1, :cond_0

    aget-object v1, p2, v0

    .line 686
    iget-object v1, v1, Lcom/android/internal/telephony/nano/PersistAtomsProto$DataCallSession;->handoverFailureCauses:[I

    invoke-static {v1}, Ljava/util/Arrays;->sort([I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 688
    :cond_0
    monitor-exit p0

    return-object p2

    :cond_1
    const/4 p1, 0x0

    .line 690
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getGbaEvent(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;
    .locals 5

    monitor-enter p0

    .line 1026
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEventPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 1027
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEventPullTimestampMillis:J

    .line 1028
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    .line 1029
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->gbaEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$GbaEvent;

    const/16 p1, 0x1f4

    .line 1030
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1031
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 1033
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getImsDedicatedBearerEvent(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;
    .locals 5

    monitor-enter p0

    .line 952
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEventPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 954
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEventPullTimestampMillis:J

    .line 955
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    .line 957
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerEvent;

    const/16 p1, 0x1f4

    .line 958
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 959
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 961
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getImsDedicatedBearerListenerEvent(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;
    .locals 5

    monitor-enter p0

    .line 932
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEventPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 934
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEventPullTimestampMillis:J

    .line 935
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    .line 937
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsDedicatedBearerListenerEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsDedicatedBearerListenerEvent;

    const/16 p1, 0x1f4

    .line 938
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 939
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 941
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getImsRegistrationFeatureTagStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;
    .locals 5

    monitor-enter p0

    .line 799
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStatsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 801
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStatsPullTimestampMillis:J

    .line 802
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    .line 804
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationFeatureTagStats;

    const/16 p1, 0x1f4

    .line 805
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 806
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 808
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getImsRegistrationServiceDescStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;
    .locals 5

    monitor-enter p0

    .line 972
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStatsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 974
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStatsPullTimestampMillis:J

    .line 975
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    .line 977
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationServiceDescStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationServiceDescStats;

    const/16 p1, 0x1f4

    .line 978
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 979
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 981
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getImsRegistrationStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;
    .locals 5

    monitor-enter p0

    .line 741
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStatsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 743
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStatsPullTimestampMillis:J

    .line 744
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    .line 745
    invoke-static {p1}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v2, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda8;

    invoke-direct {v2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda8;-><init>()V

    invoke-interface {p2, v2}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 746
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    const/4 v2, 0x0

    new-array v2, v2, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    iput-object v2, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    const/16 p2, 0x1f4

    .line 747
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V

    .line 748
    invoke-direct {p0, p1, v0, v1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->normalizeData([Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationStats;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object p1

    :cond_0
    const/4 p1, 0x0

    .line 750
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getImsRegistrationTerminations(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;
    .locals 5

    monitor-enter p0

    .line 761
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTerminationPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 763
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTerminationPullTimestampMillis:J

    .line 764
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTermination:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    .line 765
    invoke-static {p1}, Ljava/util/Arrays;->stream([Ljava/lang/Object;)Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage$$ExternalSyntheticLambda0;-><init>()V

    .line 766
    invoke-interface {p2, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 767
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    iput-object v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->imsRegistrationTermination:[Lcom/android/internal/telephony/nano/PersistAtomsProto$ImsRegistrationTermination;

    const/16 p2, 0x1f4

    .line 768
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 769
    monitor-exit p0

    return-object p1

    :cond_0
    const/4 p1, 0x0

    .line 771
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getIncomingSms(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;
    .locals 5

    monitor-enter p0

    .line 645
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSmsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 646
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSmsPullTimestampMillis:J

    .line 647
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    .line 648
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->incomingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$IncomingSms;

    const/16 p1, 0x1f4

    .line 649
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 650
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 652
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getNetworkRequestsV2(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;
    .locals 5

    monitor-enter p0

    .line 781
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2PullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 782
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2PullTimestampMillis:J

    .line 783
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    .line 784
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->networkRequestsV2:[Lcom/android/internal/telephony/nano/PersistAtomsProto$NetworkRequestsV2;

    const/16 p1, 0x1f4

    .line 785
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 786
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 788
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getOutgoingSms(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;
    .locals 5

    monitor-enter p0

    .line 662
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSmsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 663
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSmsPullTimestampMillis:J

    .line 664
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    .line 665
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->outgoingSms:[Lcom/android/internal/telephony/nano/PersistAtomsProto$OutgoingSms;

    const/16 p1, 0x1f4

    .line 666
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 667
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 669
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getPresenceNotifyEvent(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;
    .locals 5

    monitor-enter p0

    .line 1008
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEventPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 1010
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEventPullTimestampMillis:J

    .line 1011
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    .line 1012
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->presenceNotifyEvent:[Lcom/android/internal/telephony/nano/PersistAtomsProto$PresenceNotifyEvent;

    const/16 p1, 0x1f4

    .line 1013
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1014
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 1016
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getRcsAcsProvisioningStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;
    .locals 5

    monitor-enter p0

    .line 838
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStatsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 840
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStatsPullTimestampMillis:J

    .line 841
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    .line 842
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsAcsProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsAcsProvisioningStats;

    const/16 p1, 0x1f4

    .line 843
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 844
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 846
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getRcsClientProvisioningStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;
    .locals 5

    monitor-enter p0

    .line 819
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStatsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 821
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStatsPullTimestampMillis:J

    .line 822
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    .line 823
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->rcsClientProvisioningStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$RcsClientProvisioningStats;

    const/16 p1, 0x1f4

    .line 824
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 825
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 827
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getSipDelegateStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;
    .locals 5

    monitor-enter p0

    .line 856
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStatsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 858
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStatsPullTimestampMillis:J

    .line 859
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    .line 860
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipDelegateStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipDelegateStats;

    const/16 p1, 0x1f4

    .line 861
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 862
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 864
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getSipMessageResponse(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;
    .locals 5

    monitor-enter p0

    .line 893
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponsePullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 895
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponsePullTimestampMillis:J

    .line 896
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponse:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    .line 898
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipMessageResponse:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipMessageResponse;

    const/16 p1, 0x1f4

    .line 899
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 900
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 902
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getSipTransportFeatureTagStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;
    .locals 5

    monitor-enter p0

    .line 875
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStatsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 877
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStatsPullTimestampMillis:J

    .line 878
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    .line 879
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportFeatureTagStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportFeatureTagStats;

    const/16 p1, 0x1f4

    .line 880
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 881
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 883
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getSipTransportSession(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;
    .locals 5

    monitor-enter p0

    .line 912
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSessionPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 914
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSessionPullTimestampMillis:J

    .line 915
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    .line 917
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->sipTransportSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$SipTransportSession;

    const/16 p1, 0x1f4

    .line 918
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 919
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 921
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getUceEventStats(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;
    .locals 5

    monitor-enter p0

    .line 991
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStatsPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 992
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStatsPullTimestampMillis:J

    .line 993
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    .line 994
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->uceEventStats:[Lcom/android/internal/telephony/nano/PersistAtomsProto$UceEventStats;

    const/16 p1, 0x1f4

    .line 995
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 996
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 998
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getVoiceCallRatUsages(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;
    .locals 5

    monitor-enter p0

    .line 627
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsagePullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 628
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsagePullTimestampMillis:J

    .line 629
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p1, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsage:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    .line 630
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mVoiceCallRatTracker:Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;

    invoke-virtual {p2}, Lcom/android/internal/telephony/metrics/VoiceCallRatTracker;->clear()V

    .line 631
    iget-object p2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    iput-object v0, p2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallRatUsage:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallRatUsage;

    const/16 p2, 0x1f4

    .line 632
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 633
    monitor-exit p0

    return-object p1

    :cond_0
    const/4 p1, 0x0

    .line 635
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized getVoiceCallSessions(J)[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;
    .locals 5

    monitor-enter p0

    .line 610
    :try_start_0
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide v0

    iget-object v2, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-wide v3, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSessionPullTimestampMillis:J

    sub-long/2addr v0, v3

    cmp-long p1, v0, p1

    if-lez p1, :cond_0

    .line 611
    invoke-virtual {p0}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->getWallTimeMillis()J

    move-result-wide p1

    iput-wide p1, v2, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSessionPullTimestampMillis:J

    .line 612
    iget-object p1, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget-object p2, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    const/4 v0, 0x0

    new-array v0, v0, [Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    .line 613
    iput-object v0, p1, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->voiceCallSession:[Lcom/android/internal/telephony/nano/PersistAtomsProto$VoiceCallSession;

    const/16 p1, 0x1f4

    .line 614
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 615
    monitor-exit p0

    return-object p2

    :cond_0
    const/4 p1, 0x0

    .line 617
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method protected getWallTimeMillis()J
    .locals 2
    .annotation build Lcom/android/internal/annotations/VisibleForTesting;
    .end annotation

    .line 1733
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    return-wide v0
.end method

.method public declared-synchronized setCarrierIdTableVersion(I)Z
    .locals 2

    monitor-enter p0

    .line 406
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->mAtoms:Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;

    iget v1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdTableVersion:I

    if-ge v1, p1, :cond_0

    .line 407
    iput p1, v0, Lcom/android/internal/telephony/nano/PersistAtomsProto$PersistAtoms;->carrierIdTableVersion:I

    const/16 p1, 0x7530

    .line 408
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/metrics/PersistAtomsStorage;->saveAtomsToFile(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 p1, 0x1

    .line 409
    monitor-exit p0

    return p1

    :cond_0
    const/4 p1, 0x0

    .line 411
    monitor-exit p0

    return p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
