.class public Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;
.super Ljava/lang/Object;
.source "CarrierDisplayNameResolver.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;,
        Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;
    }
.end annotation


# static fields
.field private static final DBG:Z = true

.field private static final DEFAULT_CARRIER_DISPLAY_NAME_RULE:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;

.field private static final DEFAULT_CARRIER_NAME_DISPLAY_CONDITION_BITMASK:I = 0x0

.field private static final EF_SOURCE_PRIORITY:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private static final TAG:Ljava/lang/String; = "CDNR"


# instance fields
.field private final mCCManager:Landroid/telephony/CarrierConfigManager;

.field private mCarrierDisplayNameData:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

.field private final mContext:Landroid/content/Context;

.field private final mEf:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/cdnr/EfData;",
            ">;"
        }
    .end annotation
.end field

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field private final mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;


# direct methods
.method static constructor <clinit>()V
    .locals 5

    .line 74
    new-instance v0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;-><init>(I)V

    sput-object v0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->DEFAULT_CARRIER_DISPLAY_NAME_RULE:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;

    const/16 v0, 0xa

    new-array v2, v0, [Ljava/lang/Integer;

    const/4 v3, 0x2

    .line 91
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v1

    const/4 v1, 0x1

    .line 92
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v1

    .line 93
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v2, v3

    const/4 v0, 0x3

    .line 94
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v0

    const/4 v0, 0x4

    .line 95
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v0

    const/4 v0, 0x5

    .line 96
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v0

    const/4 v0, 0x6

    .line 97
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v0

    const/4 v0, 0x7

    .line 98
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v0

    const/16 v0, 0x8

    .line 99
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v0

    const/16 v0, 0x9

    .line 100
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v2, v0

    .line 90
    invoke-static {v2}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    sput-object v0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->EF_SOURCE_PRIORITY:Ljava/util/List;

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/GsmCdmaPhone;)V
    .locals 2

    .line 102
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 77
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    .line 103
    new-instance v0, Lcom/android/internal/telephony/LocalLog;

    const/16 v1, 0x20

    invoke-direct {v0, v1}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 104
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mContext:Landroid/content/Context;

    .line 105
    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    const-string p1, "carrier_config"

    .line 106
    invoke-virtual {v0, p1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/CarrierConfigManager;

    iput-object p1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mCCManager:Landroid/telephony/CarrierConfigManager;

    return-void
.end method

.method private getCarrierConfig()Landroid/os/PersistableBundle;
    .locals 1

    .line 236
    iget-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mCCManager:Landroid/telephony/CarrierConfigManager;

    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/telephony/CarrierConfigManager;->getConfigForSubId(I)Landroid/os/PersistableBundle;

    move-result-object p0

    if-nez p0, :cond_0

    .line 237
    invoke-static {}, Landroid/telephony/CarrierConfigManager;->getDefaultConfig()Landroid/os/PersistableBundle;

    move-result-object p0

    :cond_0
    return-object p0
.end method

.method private getCarrierDisplayNameFromCrossSimCallingOverride(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;
    .locals 7

    .line 391
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    const-string v1, "cross_sim_spn_format_int"

    .line 393
    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I

    move-result v1

    const-string/jumbo v2, "wfc_spn_use_root_locale"

    .line 395
    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    .line 397
    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 398
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v2

    iget-object v3, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 399
    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v3

    .line 397
    invoke-static {v2, v3, v0}, Landroid/telephony/SubscriptionManager;->getResourcesForSubId(Landroid/content/Context;IZ)Landroid/content/res/Resources;

    move-result-object v0

    const v2, 0x10700c6

    .line 400
    invoke-virtual {v0, v2}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v0

    const/4 v2, 0x0

    if-ltz v1, :cond_0

    .line 402
    array-length v3, v0

    if-lt v1, v3, :cond_1

    .line 403
    :cond_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "updateSpnDisplay: KEY_CROSS_SIM_SPN_FORMAT_INT out of bounds: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v3, "CDNR"

    invoke-static {v3, v1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    move v1, v2

    .line 407
    :cond_1
    aget-object v0, v0, v1

    .line 409
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getEfPnn()Ljava/util/List;

    move-result-object p0

    .line 410
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_2

    const-string p0, ""

    goto :goto_0

    :cond_2
    invoke-interface {p0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;

    invoke-static {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getPlmnNetworkName(Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;)Ljava/lang/String;

    move-result-object p0

    .line 412
    :goto_0
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getSpn()Ljava/lang/String;

    move-result-object v1

    .line 413
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_3

    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getPlmn()Ljava/lang/String;

    move-result-object v3

    goto :goto_1

    :cond_3
    move-object v3, p0

    :goto_1
    const/4 v4, 0x1

    new-array v5, v4, [Ljava/lang/Object;

    aput-object v1, v5, v2

    .line 414
    invoke-static {v0, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    new-array v6, v4, [Ljava/lang/Object;

    aput-object p0, v6, v2

    .line 415
    invoke-static {v0, v6}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    .line 416
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_4

    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_4

    .line 417
    new-instance p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;-><init>()V

    .line 418
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 419
    invoke-virtual {p0, v5}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setDataSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 420
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowSpn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 421
    invoke-virtual {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->build()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object p1

    goto :goto_2

    .line 422
    :cond_4
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_5

    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_5

    .line 423
    new-instance p1, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    invoke-direct {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;-><init>()V

    .line 424
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setPlmn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 425
    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowPlmn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 426
    invoke-virtual {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->build()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object p1

    :cond_5
    :goto_2
    return-object p1
.end method

.method private getCarrierDisplayNameFromEf()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;
    .locals 7

    .line 304
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getDisplayRule()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;

    move-result-object v0

    .line 306
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getOperatorAlpha()Ljava/lang/String;

    move-result-object v1

    .line 307
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object v2

    .line 309
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getEfSpn()Ljava/lang/String;

    move-result-object v3

    .line 312
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getEfOpl()Ljava/util/List;

    move-result-object v4

    .line 313
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getEfPnn()Ljava/util/List;

    move-result-object v5

    .line 316
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->isRoaming()Z

    move-result p0

    const/4 v6, 0x0

    if-eqz p0, :cond_0

    move-object p0, v1

    goto :goto_0

    .line 319
    :cond_0
    invoke-interface {v4}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_2

    .line 323
    invoke-interface {v5}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_1

    const-string p0, ""

    goto :goto_0

    :cond_1
    invoke-interface {v5, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;

    invoke-static {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getPlmnNetworkName(Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_2
    const/4 p0, 0x0

    .line 333
    :goto_0
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_4

    .line 334
    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_3

    move-object v1, v2

    :cond_3
    move-object p0, v1

    .line 338
    :cond_4
    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;->shouldShowSpn(Ljava/lang/String;)Z

    move-result v1

    .line 339
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_5

    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;->shouldShowPlmn(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_6

    :cond_5
    const/4 v6, 0x1

    .line 341
    :cond_6
    new-instance v0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    invoke-direct {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;-><init>()V

    .line 342
    invoke-virtual {v0, v3}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object v0

    .line 343
    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowSpn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object v0

    .line 344
    invoke-virtual {v0, p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setPlmn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 345
    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowPlmn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 346
    invoke-virtual {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->build()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object p0

    return-object p0
.end method

.method private getCarrierDisplayNameFromWifiCallingOverride(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;
    .locals 7

    .line 351
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    const-string/jumbo v1, "wfc_spn_use_root_locale"

    .line 352
    invoke-virtual {v0, v1}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v1

    .line 353
    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mContext:Landroid/content/Context;

    if-eqz v1, :cond_0

    .line 355
    invoke-virtual {v2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v1

    .line 356
    sget-object v2, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v1, v2}, Landroid/content/res/Configuration;->setLocale(Ljava/util/Locale;)V

    .line 358
    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mContext:Landroid/content/Context;

    invoke-virtual {v2, v1}, Landroid/content/Context;->createConfigurationContext(Landroid/content/res/Configuration;)Landroid/content/Context;

    move-result-object v2

    .line 360
    :cond_0
    invoke-virtual {v2}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const v2, 0x10700f8

    .line 361
    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v1

    .line 362
    new-instance v2, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;

    .line 363
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v3

    invoke-virtual {v3}, Landroid/telephony/ServiceState;->getState()I

    move-result v3

    const/4 v4, 0x3

    const/4 v5, 0x0

    const/4 v6, 0x1

    if-ne v3, v4, :cond_1

    move v3, v6

    goto :goto_0

    :cond_1
    move v3, v5

    :goto_0
    invoke-direct {v2, v0, v1, v3}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;-><init>(Landroid/os/PersistableBundle;[Ljava/lang/String;Z)V

    .line 366
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getSpn()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;->formatVoiceName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 367
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getSpn()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;->formatDataName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 368
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getEfPnn()Ljava/util/List;

    move-result-object p0

    .line 369
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_2

    const-string p0, ""

    goto :goto_1

    :cond_2
    invoke-interface {p0, v5}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;

    invoke-static {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getPlmnNetworkName(Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;)Ljava/lang/String;

    move-result-object p0

    .line 371
    :goto_1
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_3

    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getPlmn()Ljava/lang/String;

    move-result-object p0

    .line 370
    :cond_3
    invoke-virtual {v2, p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$WfcCarrierNameFormatter;->formatVoiceName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 374
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_4

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_4

    .line 375
    new-instance p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;-><init>()V

    .line 376
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 377
    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setDataSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 378
    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowSpn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 379
    invoke-virtual {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->build()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object p1

    goto :goto_2

    .line 380
    :cond_4
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_5

    .line 381
    new-instance p1, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    invoke-direct {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;-><init>()V

    .line 382
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setPlmn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 383
    invoke-virtual {p0, v6}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowPlmn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 384
    invoke-virtual {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->build()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object p1

    :cond_5
    :goto_2
    return-object p1
.end method

.method private getDisplayRule()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;
    .locals 4

    .line 243
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->isRoaming()Z

    move-result v0

    const/4 v1, 0x0

    .line 244
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v2}, Landroid/util/SparseArray;->size()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 245
    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {v2, v0}, Lcom/android/internal/telephony/cdnr/EfData;->getServiceProviderNameDisplayCondition(Z)I

    move-result v2

    const/4 v3, -0x1

    if-eq v2, v3, :cond_0

    .line 247
    new-instance v2, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;

    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    .line 248
    invoke-virtual {p0, v1}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {p0, v0}, Lcom/android/internal/telephony/cdnr/EfData;->getServiceProviderNameDisplayCondition(Z)I

    move-result p0

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;-><init>(I)V

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 251
    :cond_1
    sget-object p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->DEFAULT_CARRIER_DISPLAY_NAME_RULE:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver$CarrierDisplayNameConditionRule;

    return-object p0
.end method

.method private getEfOpl()Ljava/util/List;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/IccRecords$OperatorPlmnInfo;",
            ">;"
        }
    .end annotation

    const/4 v0, 0x0

    .line 276
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 277
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {v1}, Lcom/android/internal/telephony/cdnr/EfData;->getOperatorPlmnList()Ljava/util/List;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 278
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {p0}, Lcom/android/internal/telephony/cdnr/EfData;->getOperatorPlmnList()Ljava/util/List;

    move-result-object p0

    return-object p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 281
    :cond_1
    sget-object p0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object p0
.end method

.method private getEfPnn()Ljava/util/List;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;",
            ">;"
        }
    .end annotation

    const/4 v0, 0x0

    .line 286
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 287
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {v1}, Lcom/android/internal/telephony/cdnr/EfData;->getPlmnNetworkNameList()Ljava/util/List;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 288
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {p0}, Lcom/android/internal/telephony/cdnr/EfData;->getPlmnNetworkNameList()Ljava/util/List;

    move-result-object p0

    return-object p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 291
    :cond_1
    sget-object p0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object p0
.end method

.method private getEfSpdi()Ljava/util/List;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    const/4 v0, 0x0

    .line 256
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 257
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {v1}, Lcom/android/internal/telephony/cdnr/EfData;->getServiceProviderDisplayInformation()Ljava/util/List;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 258
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {p0}, Lcom/android/internal/telephony/cdnr/EfData;->getServiceProviderDisplayInformation()Ljava/util/List;

    move-result-object p0

    return-object p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 261
    :cond_1
    sget-object p0, Ljava/util/Collections;->EMPTY_LIST:Ljava/util/List;

    return-object p0
.end method

.method private getEfSpn()Ljava/lang/String;
    .locals 2

    const/4 v0, 0x0

    .line 266
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 267
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {v1}, Lcom/android/internal/telephony/cdnr/EfData;->getServiceProviderName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 268
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/cdnr/EfData;

    invoke-interface {p0}, Lcom/android/internal/telephony/cdnr/EfData;->getServiceProviderName()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_1
    const-string p0, ""

    return-object p0
.end method

.method private getOutOfServiceDisplayName(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;
    .locals 4

    .line 450
    iget-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getUiccCardApplication()Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 451
    invoke-virtual {v0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getUiccCardApplication()Lcom/android/internal/telephony/uicc/UiccCardApplication;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/uicc/UiccCardApplication;->getState()Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    move-result-object v0

    sget-object v3, Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;->APPSTATE_READY:Lcom/android/internal/telephony/uicc/IccCardApplicationStatus$AppState;

    if-ne v0, v3, :cond_0

    move v0, v2

    goto :goto_0

    :cond_0
    move v0, v1

    .line 452
    :goto_0
    iget-object v3, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    .line 453
    invoke-virtual {v3}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v3

    invoke-virtual {v3}, Lcom/android/internal/telephony/ServiceStateTracker;->shouldForceDisplayNoService()Z

    move-result v3

    if-eqz v3, :cond_1

    if-nez v0, :cond_1

    move v1, v2

    .line 454
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    .line 455
    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getState()I

    move-result v0

    const/4 v3, 0x3

    if-ne v0, v3, :cond_2

    if-nez v1, :cond_2

    .line 456
    invoke-static {}, Lcom/android/internal/telephony/Phone;->isEmergencyCallOnly()Z

    move-result v0

    if-nez v0, :cond_2

    const/4 p0, 0x0

    goto :goto_2

    :cond_2
    if-nez v1, :cond_4

    .line 458
    invoke-static {}, Lcom/android/internal/telephony/Phone;->isEmergencyCallOnly()Z

    move-result v0

    if-nez v0, :cond_3

    goto :goto_1

    .line 462
    :cond_3
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const v0, 0x1040350

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p0

    goto :goto_2

    .line 459
    :cond_4
    :goto_1
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const v0, 0x10404e9

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 465
    :goto_2
    new-instance v0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    invoke-direct {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;-><init>()V

    .line 466
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getSpn()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object v0

    .line 467
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->getDataSpn()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setDataSpn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object v0

    .line 468
    invoke-virtual {p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->shouldShowSpn()Z

    move-result p1

    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowSpn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p1

    .line 469
    invoke-virtual {p1, p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setPlmn(Ljava/lang/String;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 470
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->setShowPlmn(Z)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;

    move-result-object p0

    .line 471
    invoke-virtual {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData$Builder;->build()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object p0

    return-object p0
.end method

.method private static getPlmnNetworkName(Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;)Ljava/lang/String;
    .locals 2

    const-string v0, ""

    if-nez p0, :cond_0

    return-object v0

    .line 516
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->fullName:Ljava/lang/String;

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_1

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->fullName:Ljava/lang/String;

    return-object p0

    .line 517
    :cond_1
    iget-object v1, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->shortName:Ljava/lang/String;

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    iget-object p0, p0, Lcom/android/internal/telephony/uicc/IccRecords$PlmnNetworkName;->shortName:Ljava/lang/String;

    return-object p0

    :cond_2
    return-object v0
.end method

.method private getServiceState()Landroid/telephony/ServiceState;
    .locals 0

    .line 569
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p0

    invoke-virtual {p0}, Lcom/android/internal/telephony/ServiceStateTracker;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    return-object p0
.end method

.method private static getSourcePriority(I)I
    .locals 1

    .line 528
    sget-object v0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->EF_SOURCE_PRIORITY:Ljava/util/List;

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, p0}, Ljava/util/List;->indexOf(Ljava/lang/Object;)I

    move-result p0

    const/4 v0, -0x1

    if-ne p0, v0, :cond_0

    const p0, 0x7fffffff

    :cond_0
    return p0
.end method

.method private isRoaming()Z
    .locals 1

    .line 299
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getRoaming()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 300
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getEfSpdi()Ljava/util/List;

    move-result-object v0

    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object p0

    invoke-interface {v0, p0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private resolveCarrierDisplayName()V
    .locals 5

    .line 475
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getCarrierDisplayNameFromEf()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object v0

    .line 476
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "CarrierName from EF: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "CDNR"

    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 477
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v1

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getImsPhone()Lcom/android/internal/telephony/Phone;

    move-result-object v1

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getImsRegistrationTech()I

    move-result v1

    const/4 v3, 0x2

    if-ne v1, v3, :cond_0

    .line 479
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getCarrierDisplayNameFromCrossSimCallingOverride(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object v0

    .line 481
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "CarrierName override by Cross-SIM Calling "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 483
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/GsmCdmaPhone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object v1

    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v3

    invoke-virtual {v1, v3}, Lcom/android/internal/telephony/ServiceStateTracker;->getCombinedRegState(Landroid/telephony/ServiceState;)I

    move-result v1

    if-nez v1, :cond_2

    .line 485
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->isWifiCallingEnabled()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 486
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getCarrierDisplayNameFromWifiCallingOverride(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object v0

    .line 488
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "CarrierName override by wifi-calling "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 490
    :cond_1
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v1

    invoke-virtual {v1}, Landroid/telephony/ServiceState;->getState()I

    move-result v1

    const/4 v3, 0x3

    if-ne v1, v3, :cond_3

    .line 492
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getOutOfServiceDisplayName(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object v0

    .line 493
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Out of service carrierName (APM) "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 496
    :cond_2
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getOutOfServiceDisplayName(Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;)Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    move-result-object v0

    .line 497
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Out of service carrierName "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 500
    :cond_3
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mCarrierDisplayNameData:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    invoke-static {v1, v0}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_4

    .line 501
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    invoke-virtual {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;->toString()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v2, v3

    const-string v3, "ResolveCarrierDisplayName: %s"

    invoke-static {v3, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    .line 504
    :cond_4
    iput-object v0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mCarrierDisplayNameData:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    return-void
.end method


# virtual methods
.method public dump(Lcom/android/internal/telephony/IndentingPrintWriter;)V
    .locals 2

    const-string v0, "CDNR:"

    .line 222
    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 223
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 224
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "fields = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 225
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "carrierDisplayNameData = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mCarrierDisplayNameData:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 226
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    const-string v0, "CDNR local log:"

    .line 228
    invoke-virtual {p1, v0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 229
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    .line 230
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/PrintWriter;)V

    .line 231
    invoke-virtual {p1}, Lcom/android/internal/telephony/IndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/IndentingPrintWriter;

    return-void
.end method

.method public getCarrierDisplayNameData()Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;
    .locals 0

    .line 194
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->resolveCarrierDisplayName()V

    .line 195
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mCarrierDisplayNameData:Lcom/android/internal/telephony/cdnr/CarrierDisplayNameData;

    return-object p0
.end method

.method public toString()Ljava/lang/String;
    .locals 5

    .line 200
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v1, 0x0

    .line 201
    :goto_0
    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v2}, Landroid/util/SparseArray;->size()I

    move-result v2

    if-ge v1, v2, :cond_0

    .line 202
    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {v2, v1}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/cdnr/EfData;

    .line 203
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v4, "{spnDisplayCondition = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 204
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->isRoaming()Z

    move-result v4

    invoke-interface {v2, v4}, Lcom/android/internal/telephony/cdnr/EfData;->getServiceProviderNameDisplayCondition(Z)I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v4, ", spn = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 205
    invoke-interface {v2}, Lcom/android/internal/telephony/cdnr/EfData;->getServiceProviderName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", spdiList = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 206
    invoke-interface {v2}, Lcom/android/internal/telephony/cdnr/EfData;->getServiceProviderDisplayInformation()Ljava/util/List;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, ", pnnList = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 207
    invoke-interface {v2}, Lcom/android/internal/telephony/cdnr/EfData;->getPlmnNetworkNameList()Ljava/util/List;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, ", oplList = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 208
    invoke-interface {v2}, Lcom/android/internal/telephony/cdnr/EfData;->getOperatorPlmnList()Ljava/util/List;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, ", ehplmn = "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 209
    invoke-interface {v2}, Lcom/android/internal/telephony/cdnr/EfData;->getEhplmnList()Ljava/util/List;

    move-result-object v2

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string/jumbo v2, "}, "

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 203
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 212
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, ", roamingFromSS = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/ServiceState;->getRoaming()Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 213
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, ", registeredPLMN = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 214
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public updateEfForBrandOverride(Ljava/lang/String;)V
    .locals 3

    const/4 v0, 0x2

    .line 183
    invoke-static {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getSourcePriority(I)I

    move-result v0

    .line 184
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 185
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->remove(I)V

    goto :goto_0

    .line 187
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    new-instance v2, Lcom/android/internal/telephony/cdnr/BrandOverrideEfData;

    .line 188
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getOperatorNumeric()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v2, p1, p0}, Lcom/android/internal/telephony/cdnr/BrandOverrideEfData;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 187
    invoke-virtual {v1, v0, v2}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :goto_0
    return-void
.end method

.method public updateEfForEri(Ljava/lang/String;)V
    .locals 3

    .line 166
    invoke-direct {p0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getCarrierConfig()Landroid/os/PersistableBundle;

    move-result-object v0

    const/16 v1, 0xa

    .line 167
    invoke-static {v1}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getSourcePriority(I)I

    move-result v1

    .line 168
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_1

    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdma()Z

    move-result v2

    if-nez v2, :cond_0

    iget-object v2, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mPhone:Lcom/android/internal/telephony/GsmCdmaPhone;

    invoke-virtual {v2}, Lcom/android/internal/telephony/GsmCdmaPhone;->isPhoneTypeCdmaLte()Z

    move-result v2

    if-eqz v2, :cond_1

    :cond_0
    const-string v2, "allow_cdma_eri_bool"

    .line 169
    invoke-virtual {v0, v2}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 170
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    new-instance v0, Lcom/android/internal/telephony/cdnr/EriEfData;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/cdnr/EriEfData;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v1, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    goto :goto_0

    .line 172
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {p0, v1}, Landroid/util/SparseArray;->remove(I)V

    :goto_0
    return-void
.end method

.method public updateEfFromCarrierConfig(Landroid/os/PersistableBundle;)V
    .locals 2

    const/4 v0, 0x1

    .line 147
    invoke-static {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getSourcePriority(I)I

    move-result v0

    if-nez p1, :cond_0

    .line 149
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->remove(I)V

    goto :goto_0

    .line 151
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    new-instance v1, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;

    invoke-direct {v1, p1}, Lcom/android/internal/telephony/cdnr/CarrierConfigEfData;-><init>(Landroid/os/PersistableBundle;)V

    invoke-virtual {p0, v0, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :goto_0
    return-void
.end method

.method public updateEfFromRuim(Lcom/android/internal/telephony/uicc/RuimRecords;)V
    .locals 2

    const/4 v0, 0x6

    .line 117
    invoke-static {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getSourcePriority(I)I

    move-result v0

    if-nez p1, :cond_0

    .line 119
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->remove(I)V

    goto :goto_0

    .line 121
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    new-instance v1, Lcom/android/internal/telephony/cdnr/RuimEfData;

    invoke-direct {v1, p1}, Lcom/android/internal/telephony/cdnr/RuimEfData;-><init>(Lcom/android/internal/telephony/uicc/RuimRecords;)V

    invoke-virtual {p0, v0, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :goto_0
    return-void
.end method

.method public updateEfFromUsim(Lcom/android/internal/telephony/uicc/SIMRecords;)V
    .locals 2

    const/4 v0, 0x3

    .line 132
    invoke-static {v0}, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->getSourcePriority(I)I

    move-result v0

    if-nez p1, :cond_0

    .line 134
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    invoke-virtual {p0, v0}, Landroid/util/SparseArray;->remove(I)V

    goto :goto_0

    .line 136
    :cond_0
    iget-object p0, p0, Lcom/android/internal/telephony/cdnr/CarrierDisplayNameResolver;->mEf:Landroid/util/SparseArray;

    new-instance v1, Lcom/android/internal/telephony/cdnr/UsimEfData;

    invoke-direct {v1, p1}, Lcom/android/internal/telephony/cdnr/UsimEfData;-><init>(Lcom/android/internal/telephony/uicc/SIMRecords;)V

    invoke-virtual {p0, v0, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    :goto_0
    return-void
.end method
