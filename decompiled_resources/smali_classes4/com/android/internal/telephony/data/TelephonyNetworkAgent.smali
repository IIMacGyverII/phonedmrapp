.class public Lcom/android/internal/telephony/data/TelephonyNetworkAgent;
.super Landroid/net/NetworkAgent;
.source "TelephonyNetworkAgent.java"

# interfaces
.implements Lcom/android/internal/telephony/data/NotifyQosSessionInterface;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;
    }
.end annotation


# instance fields
.field private mAbandoned:Z

.field private final mDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

.field private final mId:I

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mLogTag:Ljava/lang/String;

.field private final mNetworkAgentConfig:Landroid/net/NetworkAgentConfig;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mTelephonyNetworkAgentCallbacks:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$1IlNeBSxo0hYY3I5_9TZgWKwxCY(ILandroid/net/QosFilter;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onQosCallbackRegistered$7(ILandroid/net/QosFilter;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$71pZ_J20okMi88r696r11vOK3hc(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;I)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onQosCallbackUnregistered$8(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$AkLaMozFSnjTRGvNIYK_re6wPX8(ILandroid/net/Uri;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onValidationStatus$1(ILandroid/net/Uri;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$B0AnUcqWsKkPkYqcFU43MsRcPCc(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V
    .locals 0

    invoke-static {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onStartSocketKeepalive$2(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V

    return-void
.end method

.method public static synthetic $r8$lambda$JdM4-2weuMyEkQpRxAnStfPKPio(ILcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onQosCallbackUnregistered$9(ILcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$PfrBMkDHPadZFUrTfDmR1t_zmos(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;I)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onStopSocketKeepalive$4(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$SrgdSea-zfmdgm6UTgAbGf6s2ZQ(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILandroid/net/Uri;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onValidationStatus$0(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILandroid/net/Uri;)V

    return-void
.end method

.method public static synthetic $r8$lambda$VJBd8S55mkJ9ECJrI2elvsMUbdU(ILcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onStopSocketKeepalive$5(ILcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$dTUmVto6q5aGXhzPoGKgSCitKv8(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILandroid/net/QosFilter;)V
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onQosCallbackRegistered$6(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILandroid/net/QosFilter;)V

    return-void
.end method

.method public static synthetic $r8$lambda$pwncpDVIggbmXQ2CaqgMvv-ddP4(ILjava/time/Duration;Landroid/net/KeepalivePacketData;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 0

    invoke-static {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->lambda$onStartSocketKeepalive$3(ILjava/time/Duration;Landroid/net/KeepalivePacketData;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataNetwork;Landroid/net/NetworkScore;Landroid/net/NetworkAgentConfig;Landroid/net/NetworkProvider;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 10

    move-object v9, p0

    .line 155
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    .line 156
    invoke-virtual {p3}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v4

    invoke-virtual {p3}, Lcom/android/internal/telephony/data/DataNetwork;->getLinkProperties()Landroid/net/LinkProperties;

    move-result-object v5

    const-string v3, "TelephonyNetworkAgent"

    move-object v0, p0

    move-object v2, p2

    move-object v6, p4

    move-object v7, p5

    move-object/from16 v8, p6

    .line 155
    invoke-direct/range {v0 .. v8}, Landroid/net/NetworkAgent;-><init>(Landroid/content/Context;Landroid/os/Looper;Ljava/lang/String;Landroid/net/NetworkCapabilities;Landroid/net/LinkProperties;Landroid/net/NetworkScore;Landroid/net/NetworkAgentConfig;Landroid/net/NetworkProvider;)V

    .line 52
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x80

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, v9, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    const/4 v0, 0x0

    .line 67
    iput-boolean v0, v9, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mAbandoned:Z

    .line 73
    new-instance v0, Landroid/util/ArraySet;

    invoke-direct {v0}, Landroid/util/ArraySet;-><init>()V

    iput-object v0, v9, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mTelephonyNetworkAgentCallbacks:Ljava/util/Set;

    .line 158
    invoke-virtual {p0}, Landroid/net/NetworkAgent;->register()Landroid/net/Network;

    move-object v1, p3

    .line 159
    iput-object v1, v9, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    move-object v2, p5

    .line 160
    iput-object v2, v9, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mNetworkAgentConfig:Landroid/net/NetworkAgentConfig;

    move-object/from16 v2, p7

    .line 161
    invoke-interface {v0, v2}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    move-object v0, p1

    .line 162
    iput-object v0, v9, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 163
    invoke-virtual {p0}, Landroid/net/NetworkAgent;->getNetwork()Landroid/net/Network;

    move-result-object v0

    invoke-virtual {v0}, Landroid/net/Network;->getNetId()I

    move-result v0

    iput v0, v9, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mId:I

    .line 164
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "TNA-"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, v9, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mLogTag:Ljava/lang/String;

    .line 166
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "TelephonyNetworkAgent created, nc="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 167
    invoke-virtual {p3}, Lcom/android/internal/telephony/data/DataNetwork;->getNetworkCapabilities()Landroid/net/NetworkCapabilities;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", score="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object v1, p4

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 166
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static synthetic lambda$onQosCallbackRegistered$6(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILandroid/net/QosFilter;)V
    .locals 0

    .line 270
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;->onQosCallbackRegistered(ILandroid/net/QosFilter;)V

    return-void
.end method

.method private static synthetic lambda$onQosCallbackRegistered$7(ILandroid/net/QosFilter;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 1

    .line 269
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda6;

    invoke-direct {v0, p2, p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda6;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILandroid/net/QosFilter;)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onQosCallbackUnregistered$8(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;I)V
    .locals 0

    .line 288
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;->onQosCallbackUnregistered(I)V

    return-void
.end method

.method private static synthetic lambda$onQosCallbackUnregistered$9(ILcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 1

    .line 287
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda5;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;I)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onStartSocketKeepalive$2(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V
    .locals 0

    .line 238
    invoke-virtual {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;->onStartSocketKeepalive(ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V

    return-void
.end method

.method private static synthetic lambda$onStartSocketKeepalive$3(ILjava/time/Duration;Landroid/net/KeepalivePacketData;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 1

    .line 237
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda7;

    invoke-direct {v0, p3, p0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda7;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V

    invoke-virtual {p3, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onStopSocketKeepalive$4(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;I)V
    .locals 0

    .line 254
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;->onStopSocketKeepalive(I)V

    return-void
.end method

.method private static synthetic lambda$onStopSocketKeepalive$5(ILcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 1

    .line 253
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda0;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;I)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onValidationStatus$0(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILandroid/net/Uri;)V
    .locals 0

    .line 208
    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;->onValidationStatus(ILandroid/net/Uri;)V

    return-void
.end method

.method private static synthetic lambda$onValidationStatus$1(ILandroid/net/Uri;Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 1

    .line 207
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda3;

    invoke-direct {v0, p2, p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;ILandroid/net/Uri;)V

    invoke-virtual {p2, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 365
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private logl(Ljava/lang/String;)V
    .locals 0

    .line 373
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->log(Ljava/lang/String;)V

    .line 374
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method


# virtual methods
.method public abandon()V
    .locals 1

    const/4 v0, 0x1

    .line 330
    iput-boolean v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mAbandoned:Z

    .line 331
    invoke-virtual {p0}, Landroid/net/NetworkAgent;->unregister()V

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 385
    new-instance v0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 386
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mLogTag:Ljava/lang/String;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 387
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Local logs:"

    .line 388
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 389
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 390
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 391
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 392
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-void
.end method

.method public getId()I
    .locals 0

    .line 187
    iget p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mId:I

    return p0
.end method

.method protected log(Ljava/lang/String;)V
    .locals 0

    .line 357
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public notifyQosSessionAvailable(IILandroid/net/QosSessionAttributes;)V
    .locals 0

    .line 304
    invoke-super {p0, p1, p2, p3}, Landroid/net/NetworkAgent;->sendQosSessionAvailable(IILandroid/net/QosSessionAttributes;)V

    return-void
.end method

.method public notifyQosSessionLost(III)V
    .locals 0

    .line 319
    invoke-super {p0, p1, p2, p3}, Landroid/net/NetworkAgent;->sendQosSessionLost(III)V

    return-void
.end method

.method public onBandwidthUpdateRequested()V
    .locals 1

    const-string v0, "onBandwidthUpdateRequested: RIL.pullLceData is not supported anymore."

    .line 218
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->loge(Ljava/lang/String;)V

    return-void
.end method

.method public onNetworkUnwanted()V
    .locals 1

    .line 175
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mAbandoned:Z

    if-eqz v0, :cond_0

    const-string v0, "The agent is already abandoned. Ignored onNetworkUnwanted."

    .line 176
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->log(Ljava/lang/String;)V

    return-void

    .line 180
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mDataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataNetwork;->tearDown(I)V

    return-void
.end method

.method public onQosCallbackRegistered(ILandroid/net/QosFilter;)V
    .locals 1

    .line 265
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mAbandoned:Z

    if-eqz v0, :cond_0

    const-string p1, "The agent is already abandoned. Ignored onQosCallbackRegistered."

    .line 266
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->log(Ljava/lang/String;)V

    return-void

    .line 269
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mTelephonyNetworkAgentCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda9;

    invoke-direct {v0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda9;-><init>(ILandroid/net/QosFilter;)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public onQosCallbackUnregistered(I)V
    .locals 1

    .line 283
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mAbandoned:Z

    if-eqz v0, :cond_0

    const-string p1, "The agent is already abandoned. Ignored onQosCallbackUnregistered."

    .line 284
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->log(Ljava/lang/String;)V

    return-void

    .line 287
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mTelephonyNetworkAgentCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda1;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda1;-><init>(I)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public onStartSocketKeepalive(ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V
    .locals 1

    .line 233
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mAbandoned:Z

    if-eqz v0, :cond_0

    const-string p1, "The agent is already abandoned. Ignored onStartSocketKeepalive."

    .line 234
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->log(Ljava/lang/String;)V

    return-void

    .line 237
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mTelephonyNetworkAgentCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda4;

    invoke-direct {v0, p1, p2, p3}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda4;-><init>(ILjava/time/Duration;Landroid/net/KeepalivePacketData;)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public onStopSocketKeepalive(I)V
    .locals 1

    .line 249
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mAbandoned:Z

    if-eqz v0, :cond_0

    const-string p1, "The agent is already abandoned. Ignored onStopSocketKeepalive."

    .line 250
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->log(Ljava/lang/String;)V

    return-void

    .line 253
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mTelephonyNetworkAgentCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda2;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda2;-><init>(I)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public onValidationStatus(ILandroid/net/Uri;)V
    .locals 1

    .line 203
    iget-boolean v0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mAbandoned:Z

    if-eqz v0, :cond_0

    const-string p1, "The agent is already abandoned. Ignored onValidationStatus."

    .line 204
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->log(Ljava/lang/String;)V

    return-void

    .line 207
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mTelephonyNetworkAgentCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda8;

    invoke-direct {v0, p1, p2}, Lcom/android/internal/telephony/data/TelephonyNetworkAgent$$ExternalSyntheticLambda8;-><init>(ILandroid/net/Uri;)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method

.method public registerCallback(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 0

    .line 340
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mTelephonyNetworkAgentCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public unregisterCallback(Lcom/android/internal/telephony/data/TelephonyNetworkAgent$TelephonyNetworkAgentCallback;)V
    .locals 0

    .line 349
    iget-object p0, p0, Lcom/android/internal/telephony/data/TelephonyNetworkAgent;->mTelephonyNetworkAgentCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    return-void
.end method
