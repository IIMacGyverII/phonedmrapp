.class public Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;
.super Landroid/telephony/ims/feature/MmTelFeature;
.source "MmTelFeatureCompatAdapter.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ImsRegistrationListenerBase;,
        Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ConfigListener;
    }
.end annotation


# static fields
.field public static final ACTION_IMS_INCOMING_CALL:Ljava/lang/String; = "com.android.ims.IMS_INCOMING_CALL"

.field public static final FEATURE_DISABLED:I = 0x0

.field public static final FEATURE_ENABLED:I = 0x1

.field public static final FEATURE_TYPE_UNKNOWN:I = -0x1

.field public static final FEATURE_TYPE_UT_OVER_LTE:I = 0x4

.field public static final FEATURE_TYPE_UT_OVER_WIFI:I = 0x5

.field public static final FEATURE_TYPE_VIDEO_OVER_LTE:I = 0x1

.field public static final FEATURE_TYPE_VIDEO_OVER_WIFI:I = 0x3

.field public static final FEATURE_TYPE_VOICE_OVER_LTE:I = 0x0

.field public static final FEATURE_TYPE_VOICE_OVER_WIFI:I = 0x2

.field public static final FEATURE_UNKNOWN:I = -0x1

.field private static final REG_TECH_TO_NET_TYPE:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/Integer;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static final TAG:Ljava/lang/String; = "MmTelFeatureCompat"

.field private static final WAIT_TIMEOUT_MS:I = 0x7d0


# instance fields
.field private final mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

.field private final mListener:Lcom/android/ims/internal/IImsRegistrationListener;

.field private mReceiver:Landroid/content/BroadcastReceiver;

.field private mRegCompatAdapter:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

.field private mSessionId:I


# direct methods
.method static bridge synthetic -$$Nest$fgetmCompatFeature(Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;)Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;
    .locals 0

    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmSessionId(Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;)I
    .locals 0

    iget p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mSessionId:I

    return p0
.end method

.method static bridge synthetic -$$Nest$mconvertCapabilities(Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;[I)Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->convertCapabilities([I)Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;

    move-result-object p0

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 4

    .line 61
    new-instance v0, Ljava/util/HashMap;

    const/4 v1, 0x2

    invoke-direct {v0, v1}, Ljava/util/HashMap;-><init>(I)V

    sput-object v0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->REG_TECH_TO_NET_TYPE:Ljava/util/Map;

    const/4 v2, 0x3

    .line 64
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/16 v3, 0x14

    .line 65
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 64
    invoke-interface {v0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const/4 v2, 0x0

    .line 66
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/16 v3, 0xd

    .line 67
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 66
    invoke-interface {v0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const/4 v2, 0x1

    .line 68
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    const/16 v3, 0x12

    .line 69
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 68
    invoke-interface {v0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 70
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;ILcom/android/internal/telephony/ims/MmTelInterfaceAdapter;)V
    .locals 1

    .line 289
    invoke-direct {p0}, Landroid/telephony/ims/feature/MmTelFeature;-><init>()V

    const/4 v0, -0x1

    .line 59
    iput v0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mSessionId:I

    .line 139
    new-instance v0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$1;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$1;-><init>(Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mListener:Lcom/android/ims/internal/IImsRegistrationListener;

    .line 269
    new-instance v0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$2;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$2;-><init>(Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;)V

    iput-object v0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mReceiver:Landroid/content/BroadcastReceiver;

    .line 290
    invoke-virtual {p0, p1, p2}, Landroid/telephony/ims/feature/MmTelFeature;->initialize(Landroid/content/Context;I)V

    .line 291
    iput-object p3, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    return-void
.end method

.method private convertCapabilities([I)Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;
    .locals 5

    .line 489
    array-length p0, p1

    new-array p0, p0, [Z

    const/4 v0, 0x0

    move v1, v0

    :goto_0
    const/4 v2, 0x5

    const/4 v3, 0x1

    if-gt v1, v2, :cond_2

    .line 491
    array-length v4, p1

    if-ge v1, v4, :cond_2

    .line 492
    aget v2, p1, v1

    if-ne v2, v1, :cond_0

    .line 493
    aput-boolean v3, p0, v1

    goto :goto_1

    :cond_0
    const/4 v3, -0x1

    if-ne v2, v3, :cond_1

    .line 496
    aput-boolean v0, p0, v1

    :cond_1
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 499
    :cond_2
    new-instance p1, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;

    invoke-direct {p1}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;-><init>()V

    .line 500
    aget-boolean v0, p0, v0

    const/4 v1, 0x2

    if-nez v0, :cond_3

    aget-boolean v0, p0, v1

    if-eqz v0, :cond_4

    .line 503
    :cond_3
    invoke-virtual {p1, v3}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;->addCapabilities(I)V

    .line 505
    :cond_4
    aget-boolean v0, p0, v3

    if-nez v0, :cond_5

    const/4 v0, 0x3

    aget-boolean v0, p0, v0

    if-eqz v0, :cond_6

    .line 508
    :cond_5
    invoke-virtual {p1, v1}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;->addCapabilities(I)V

    :cond_6
    const/4 v0, 0x4

    .line 510
    aget-boolean v1, p0, v0

    if-nez v1, :cond_7

    aget-boolean p0, p0, v2

    if-eqz p0, :cond_8

    .line 513
    :cond_7
    invoke-virtual {p1, v0}, Landroid/telephony/ims/feature/MmTelFeature$MmTelCapabilities;->addCapabilities(I)V

    .line 515
    :cond_8
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "convertCapabilities - capabilities: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "MmTelFeatureCompat"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object p1
.end method

.method private convertCapability(II)I
    .locals 3

    const/4 p0, 0x4

    const/4 v0, 0x2

    const/4 v1, 0x1

    const/4 v2, -0x1

    if-nez p2, :cond_3

    if-eq p1, v1, :cond_1

    if-eq p1, v0, :cond_0

    if-eq p1, p0, :cond_2

    move p0, v2

    goto :goto_0

    :cond_0
    move p0, v1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :cond_2
    :goto_0
    move v0, p0

    goto :goto_2

    :cond_3
    if-ne p2, v1, :cond_6

    if-eq p1, v1, :cond_7

    if-eq p1, v0, :cond_5

    if-eq p1, p0, :cond_4

    goto :goto_1

    :cond_4
    const/4 v0, 0x5

    goto :goto_2

    :cond_5
    const/4 v0, 0x3

    goto :goto_2

    :cond_6
    :goto_1
    move v0, v2

    :cond_7
    :goto_2
    return v0
.end method

.method private createIncomingCallPendingIntent()Landroid/app/PendingIntent;
    .locals 3

    .line 520
    new-instance v0, Landroid/content/Intent;

    const-string v1, "com.android.ims.IMS_INCOMING_CALL"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "com.android.phone"

    .line 521
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    .line 522
    iget-object p0, p0, Landroid/telephony/ims/feature/MmTelFeature;->mContext:Landroid/content/Context;

    const/4 v1, 0x0

    const/high16 v2, 0xa000000

    invoke-static {p0, v1, v0, v2}, Landroid/app/PendingIntent;->getBroadcast(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method public addRegistrationAdapter(Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 485
    iput-object p1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mRegCompatAdapter:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    return-void
.end method

.method public changeEnabledCapabilities(Landroid/telephony/ims/feature/CapabilityChangeRequest;Landroid/telephony/ims/feature/ImsFeature$CapabilityCallbackProxy;)V
    .locals 18

    move-object/from16 v0, p0

    const-string v8, "MmTelFeatureCompat"

    if-nez p1, :cond_0

    return-void

    .line 329
    :cond_0
    :try_start_0
    iget-object v1, v0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {v1}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->getConfigInterface()Lcom/android/ims/internal/IImsConfig;

    move-result-object v9

    .line 331
    invoke-virtual/range {p1 .. p1}, Landroid/telephony/ims/feature/CapabilityChangeRequest;->getCapabilitiesToDisable()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v10

    :goto_0
    invoke-interface {v10}, Ljava/util/Iterator;->hasNext()Z

    move-result v1
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    const-string v13, " radioTech: "

    const-string v14, "changeEnabledCapabilities - cap: "

    const/4 v15, -0x1

    const/4 v7, 0x1

    if-eqz v1, :cond_1

    :try_start_1
    invoke-interface {v10}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    move-object/from16 v16, v1

    check-cast v16, Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;

    .line 332
    new-instance v6, Ljava/util/concurrent/CountDownLatch;

    invoke-direct {v6, v7}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 333
    invoke-virtual/range {v16 .. v16}, Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;->getCapability()I

    move-result v1

    invoke-virtual/range {v16 .. v16}, Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;->getRadioTech()I

    move-result v2

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->convertCapability(II)I

    move-result v7

    .line 334
    sget-object v1, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->REG_TECH_TO_NET_TYPE:Ljava/util/Map;

    invoke-virtual/range {v16 .. v16}, Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;->getRadioTech()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 335
    invoke-static {v15}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 334
    invoke-interface {v1, v2, v3}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v15

    .line 336
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v15}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " disabled"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v8, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v13, 0x0

    .line 338
    new-instance v14, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$4;

    move-object v1, v14

    move-object/from16 v2, p0

    move v3, v7

    move v4, v15

    move-object v5, v6

    move-object/from16 v17, v6

    move-object/from16 v6, p2

    move v11, v7

    move-object/from16 v7, v16

    invoke-direct/range {v1 .. v7}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$4;-><init>(Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;IILjava/util/concurrent/CountDownLatch;Landroid/telephony/ims/feature/ImsFeature$CapabilityCallbackProxy;Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;)V

    invoke-interface {v9, v11, v15, v13, v14}, Lcom/android/ims/internal/IImsConfig;->setFeatureValue(IIILcom/android/ims/ImsConfigListener;)V

    .line 353
    sget-object v1, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    move-object/from16 v2, v17

    const-wide/16 v3, 0x7d0

    invoke-virtual {v2, v3, v4, v1}, Ljava/util/concurrent/CountDownLatch;->await(JLjava/util/concurrent/TimeUnit;)Z

    goto :goto_0

    .line 356
    :cond_1
    invoke-virtual/range {p1 .. p1}, Landroid/telephony/ims/feature/CapabilityChangeRequest;->getCapabilitiesToEnable()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v10

    :goto_1
    invoke-interface {v10}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v10}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    move-object v11, v1

    check-cast v11, Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;

    .line 357
    new-instance v12, Ljava/util/concurrent/CountDownLatch;

    invoke-direct {v12, v7}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    .line 358
    invoke-virtual {v11}, Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;->getCapability()I

    move-result v1

    invoke-virtual {v11}, Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;->getRadioTech()I

    move-result v2

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->convertCapability(II)I

    move-result v6

    .line 359
    sget-object v1, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->REG_TECH_TO_NET_TYPE:Ljava/util/Map;

    invoke-virtual {v11}, Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;->getRadioTech()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 360
    invoke-static {v15}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 359
    invoke-interface {v1, v2, v3}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v5

    .line 361
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " enabled"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v8, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 363
    new-instance v4, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$5;

    move-object v1, v4

    move-object/from16 v2, p0

    move v3, v6

    move-object v15, v4

    move v4, v5

    move v0, v5

    move-object v5, v12

    move-object/from16 p1, v10

    move v10, v6

    move-object/from16 v6, p2

    move-object/from16 v17, v13

    move v13, v7

    move-object v7, v11

    invoke-direct/range {v1 .. v7}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$5;-><init>(Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;IILjava/util/concurrent/CountDownLatch;Landroid/telephony/ims/feature/ImsFeature$CapabilityCallbackProxy;Landroid/telephony/ims/feature/CapabilityChangeRequest$CapabilityPair;)V

    invoke-interface {v9, v10, v0, v13, v15}, Lcom/android/ims/internal/IImsConfig;->setFeatureValue(IIILcom/android/ims/ImsConfigListener;)V

    .line 378
    sget-object v0, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v1, 0x7d0

    invoke-virtual {v12, v1, v2, v0}, Ljava/util/concurrent/CountDownLatch;->await(JLjava/util/concurrent/TimeUnit;)Z
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_0

    move-object/from16 v0, p0

    move-object/from16 v10, p1

    move v7, v13

    move-object/from16 v13, v17

    const/4 v15, -0x1

    goto :goto_1

    :catch_0
    move-exception v0

    .line 381
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "changeEnabledCapabilities: Error processing: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v8, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    return-void
.end method

.method public createCallProfile(II)Landroid/telephony/ims/ImsCallProfile;
    .locals 1

    .line 388
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    iget p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mSessionId:I

    invoke-virtual {v0, p0, p1, p2}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->createCallProfile(III)Landroid/telephony/ims/ImsCallProfile;

    move-result-object p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 390
    new-instance p1, Ljava/lang/RuntimeException;

    invoke-virtual {p0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-direct {p1, p0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public createCallSessionInterface(Landroid/telephony/ims/ImsCallProfile;)Lcom/android/ims/internal/IImsCallSession;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 397
    iget-object v0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    iget p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mSessionId:I

    invoke-virtual {v0, p0, p1}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->createCallSession(ILandroid/telephony/ims/ImsCallProfile;)Lcom/android/ims/internal/IImsCallSession;

    move-result-object p0

    return-object p0
.end method

.method public disableIms()V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 471
    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->turnOffIms()V

    return-void
.end method

.method public enableIms()V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 467
    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->turnOnIms()V

    return-void
.end method

.method public getEcbmInterface()Lcom/android/ims/internal/IImsEcbm;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 407
    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->getEcbmInterface()Lcom/android/ims/internal/IImsEcbm;

    move-result-object p0

    return-object p0
.end method

.method public getFeatureState()I
    .locals 1

    .line 418
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->getFeatureState()I

    move-result p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    :catch_0
    move-exception p0

    .line 420
    new-instance v0, Ljava/lang/RuntimeException;

    invoke-virtual {p0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public getMultiEndpointInterface()Lcom/android/ims/internal/IImsMultiEndpoint;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 412
    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->getMultiEndpointInterface()Lcom/android/ims/internal/IImsMultiEndpoint;

    move-result-object p0

    return-object p0
.end method

.method public getOldConfigInterface()Lcom/android/ims/internal/IImsConfig;
    .locals 2

    .line 476
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->getConfigInterface()Lcom/android/ims/internal/IImsConfig;

    move-result-object p0
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    :catch_0
    move-exception p0

    .line 478
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "getOldConfigInterface(): "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "MmTelFeatureCompat"

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p0, 0x0

    return-object p0
.end method

.method public getUtInterface()Lcom/android/ims/internal/IImsUt;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 402
    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->getUtInterface()Lcom/android/ims/internal/IImsUt;

    move-result-object p0

    return-object p0
.end method

.method public onFeatureReady()V
    .locals 5

    const-string v0, "MmTelFeatureCompat"

    const-string v1, "onFeatureReady called!"

    .line 451
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 454
    new-instance v1, Landroid/content/IntentFilter;

    const-string v2, "com.android.ims.IMS_INCOMING_CALL"

    invoke-direct {v1, v2}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    .line 455
    iget-object v2, p0, Landroid/telephony/ims/feature/MmTelFeature;->mContext:Landroid/content/Context;

    iget-object v3, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v2, v3, v1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 457
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-direct {p0}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->createIncomingCallPendingIntent()Landroid/app/PendingIntent;

    move-result-object v2

    new-instance v3, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ImsRegistrationListenerBase;

    const/4 v4, 0x0

    invoke-direct {v3, p0, v4}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ImsRegistrationListenerBase;-><init>(Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$ImsRegistrationListenerBase-IA;)V

    invoke-virtual {v1, v2, v3}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->startSession(Landroid/app/PendingIntent;Lcom/android/ims/internal/IImsRegistrationListener;)I

    move-result v1

    iput v1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mSessionId:I

    .line 459
    iget-object v1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    iget-object v2, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mListener:Lcom/android/ims/internal/IImsRegistrationListener;

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->addRegistrationListener(Lcom/android/ims/internal/IImsRegistrationListener;)V

    .line 460
    iget-object v1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mRegCompatAdapter:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    invoke-virtual {p0}, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;->getRegistrationListener()Lcom/android/ims/internal/IImsRegistrationListener;

    move-result-object p0

    invoke-virtual {v1, p0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->addRegistrationListener(Lcom/android/ims/internal/IImsRegistrationListener;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 462
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Couldn\'t start compat feature: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method public onFeatureRemoved()V
    .locals 2

    .line 436
    iget-object v0, p0, Landroid/telephony/ims/feature/MmTelFeature;->mContext:Landroid/content/Context;

    iget-object v1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mReceiver:Landroid/content/BroadcastReceiver;

    invoke-virtual {v0, v1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V

    .line 438
    :try_start_0
    iget-object v0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    iget v1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mSessionId:I

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->endSession(I)V

    .line 439
    iget-object v0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    iget-object v1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mListener:Lcom/android/ims/internal/IImsRegistrationListener;

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->removeRegistrationListener(Lcom/android/ims/internal/IImsRegistrationListener;)V

    .line 440
    iget-object v0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mRegCompatAdapter:Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;

    if-eqz v0, :cond_0

    .line 441
    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    .line 442
    invoke-virtual {v0}, Lcom/android/internal/telephony/ims/ImsRegistrationCompatAdapter;->getRegistrationListener()Lcom/android/ims/internal/IImsRegistrationListener;

    move-result-object v0

    .line 441
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->removeRegistrationListener(Lcom/android/ims/internal/IImsRegistrationListener;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 445
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onFeatureRemoved: Couldn\'t end session: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "MmTelFeatureCompat"

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    :goto_0
    return-void
.end method

.method public queryCapabilityConfiguration(II)Z
    .locals 13

    const-string v0, "MmTelFeatureCompat"

    .line 296
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->convertCapability(II)I

    move-result p1

    .line 298
    new-instance v7, Ljava/util/concurrent/CountDownLatch;

    const/4 v8, 0x1

    invoke-direct {v7, v8}, Ljava/util/concurrent/CountDownLatch;-><init>(I)V

    new-array v9, v8, [I

    const/4 v10, 0x0

    const/4 v1, -0x1

    aput v1, v9, v10

    .line 301
    sget-object v2, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->REG_TECH_TO_NET_TYPE:Ljava/util/Map;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    .line 302
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    .line 301
    invoke-interface {v2, p2, v1}, Ljava/util/Map;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    .line 304
    :try_start_0
    iget-object v1, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {v1}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->getConfigInterface()Lcom/android/ims/internal/IImsConfig;

    move-result-object v11

    new-instance v12, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$3;

    move-object v1, v12

    move-object v2, p0

    move v3, p1

    move v4, p2

    move-object v5, v7

    move-object v6, v9

    invoke-direct/range {v1 .. v6}, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter$3;-><init>(Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;IILjava/util/concurrent/CountDownLatch;[I)V

    invoke-interface {v11, p1, p2, v12}, Lcom/android/ims/internal/IImsConfig;->getFeatureValue(IILcom/android/ims/ImsConfigListener;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const-string p0, "queryCapabilityConfiguration"

    .line 312
    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    const-wide/16 p0, 0x7d0

    .line 315
    :try_start_1
    sget-object p2, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    invoke-virtual {v7, p0, p1, p2}, Ljava/util/concurrent/CountDownLatch;->await(JLjava/util/concurrent/TimeUnit;)Z
    :try_end_1
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_1
    move-exception p0

    .line 317
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "queryCapabilityConfiguration - error waiting: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/InterruptedException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :goto_1
    aget p0, v9, v10

    if-ne p0, v8, :cond_0

    goto :goto_2

    :cond_0
    move v8, v10

    :goto_2
    return v8
.end method

.method public setUiTtyMode(ILandroid/os/Message;)V
    .locals 0

    .line 427
    :try_start_0
    iget-object p0, p0, Lcom/android/internal/telephony/ims/MmTelFeatureCompatAdapter;->mCompatFeature:Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;

    invoke-virtual {p0, p1, p2}, Lcom/android/internal/telephony/ims/MmTelInterfaceAdapter;->setUiTTYMode(ILandroid/os/Message;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p0

    .line 429
    new-instance p1, Ljava/lang/RuntimeException;

    invoke-virtual {p0}, Landroid/os/RemoteException;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-direct {p1, p0}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
