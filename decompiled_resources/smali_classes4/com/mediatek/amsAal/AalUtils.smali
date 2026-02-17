.class public final Lcom/mediatek/amsAal/AalUtils;
.super Ljava/lang/Object;
.source "AalUtils.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/mediatek/amsAal/AalUtils$AalIndex;,
        Lcom/mediatek/amsAal/AalUtils$AalConfig;
    }
.end annotation


# static fields
.field private static final AAL_DEFAULT_LEVEL:I = 0x80

.field private static final AAL_MAX_LEVEL:I = 0x100

.field private static final AAL_MIN_LEVEL:I = 0x0

.field public static final AAL_MODE_BALANCE:I = 0x1

.field public static final AAL_MODE_LOWPOWER:I = 0x2

.field public static final AAL_MODE_PERFORMANCE:I = 0x0

.field public static final AAL_MODE_SIZE:I = 0x3

.field private static final AAL_NULL_LEVEL:I = -0x1

.field private static final TAG:Ljava/lang/String; = "AalUtils"

.field private static sAalConfigXMLPath:Ljava/lang/String; = null

.field private static sDebug:Z = false

.field private static sEnabled:Z

.field private static sInstance:Lcom/mediatek/amsAal/AalUtils;

.field private static sIsAalSupported:Z


# instance fields
.field private mAalMode:I

.field private mConfig:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/mediatek/amsAal/AalUtils$AalIndex;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mCurrentConfig:Lcom/mediatek/amsAal/AalUtils$AalConfig;


# direct methods
.method static bridge synthetic -$$Nest$mmodeToString(Lcom/mediatek/amsAal/AalUtils;I)Ljava/lang/String;
    .locals 0

    invoke-direct {p0, p1}, Lcom/mediatek/amsAal/AalUtils;->modeToString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static constructor <clinit>()V
    .locals 2

    const-string v0, "ro.vendor.mtk_aal_support"

    .line 69
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "1"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    sput-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sIsAalSupported:Z

    if-eqz v0, :cond_0

    const-string v0, "persist.vendor.sys.mtk_app_aal_support"

    .line 71
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    sput-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sEnabled:Z

    const/4 v0, 0x0

    .line 77
    sput-object v0, Lcom/mediatek/amsAal/AalUtils;->sInstance:Lcom/mediatek/amsAal/AalUtils;

    const-string v0, "/system/etc/ams_aal_config.xml"

    .line 79
    sput-object v0, Lcom/mediatek/amsAal/AalUtils;->sAalConfigXMLPath:Ljava/lang/String;

    return-void
.end method

.method constructor <init>()V
    .locals 3

    .line 87
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 73
    iput v0, p0, Lcom/mediatek/amsAal/AalUtils;->mAalMode:I

    .line 75
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lcom/mediatek/amsAal/AalUtils;->mConfig:Ljava/util/Map;

    const/4 v0, 0x0

    .line 85
    iput-object v0, p0, Lcom/mediatek/amsAal/AalUtils;->mCurrentConfig:Lcom/mediatek/amsAal/AalUtils$AalConfig;

    .line 88
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sIsAalSupported:Z

    const-string v1, "AalUtils"

    if-nez v0, :cond_1

    .line 89
    sget-boolean p0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p0, :cond_0

    const-string p0, "AAL is not supported"

    .line 90
    invoke-static {v1, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void

    .line 96
    :cond_1
    :try_start_0
    invoke-direct {p0}, Lcom/mediatek/amsAal/AalUtils;->parseXML()V
    :try_end_0
    .catch Lorg/xmlpull/v1/XmlPullParserException; {:try_start_0 .. :try_end_0} :catch_2
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 102
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "fail to parseXML, "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :catch_1
    move-exception p0

    .line 100
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "IOException fail to parseXML, "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :catch_2
    move-exception p0

    .line 98
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "XmlPullParserException fail to parseXML, "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    return-void
.end method

.method private dumpDebugUsageInternal()Ljava/lang/String;
    .locals 1

    .line 495
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "\nUsage:\n"

    .line 496
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "1. App-based AAL help:\n"

    .line 497
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "    adb shell dumpsys activity aal\n"

    .line 498
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "2. Dump App-based AAL settings:\n"

    .line 499
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "    adb shell dumpsys activity aal dump\n"

    .line 500
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "1. App-based AAL debug on:\n"

    .line 501
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "    adb shell dumpsys activity aal debugon\n"

    .line 502
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "1. App-based AAL debug off:\n"

    .line 503
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "    adb shell dumpsys activity aal debugoff\n"

    .line 504
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "3. Enable App-based AAL:\n"

    .line 505
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "    adb shell dumpsys activity aal on\n"

    .line 506
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "4. Disable App-based AAL:\n"

    .line 507
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "    adb shell dumpsys activity aal off\n"

    .line 508
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "5. Set App-based AAL mode:\n"

    .line 509
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "    adb shell dumpsys activity aal mode <mode>\n"

    .line 510
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "6. Set App-based AAL config for current mode:\n"

    .line 511
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "    adb shell dumpsys activity aal set <component> <value>\n"

    .line 512
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "7. Set App-based AAL config for the mode:\n"

    .line 513
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "    adb shell dumpsys activity aal set <component> <value> <mode>\n"

    .line 514
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 516
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private declared-synchronized dumpInternal()Ljava/lang/String;
    .locals 8

    monitor-enter p0

    .line 525
    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 526
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\nApp-based AAL Mode: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/amsAal/AalUtils;->mAalMode:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/mediatek/amsAal/AalUtils;->mAalMode:I

    invoke-direct {p0, v2}, Lcom/mediatek/amsAal/AalUtils;->modeToString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "), Supported: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v2, Lcom/mediatek/amsAal/AalUtils;->sIsAalSupported:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", Enabled: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v2, Lcom/mediatek/amsAal/AalUtils;->sEnabled:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, ", Debug: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v2, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 531
    iget-object v1, p0, Lcom/mediatek/amsAal/AalUtils;->mConfig:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const/4 v2, 0x1

    move v3, v2

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/mediatek/amsAal/AalUtils$AalIndex;

    .line 532
    iget-object v5, p0, Lcom/mediatek/amsAal/AalUtils;->mConfig:Ljava/util/Map;

    invoke-interface {v5, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/Integer;

    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I

    move-result v5

    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    .line 533
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "\n"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, ". "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, " - "

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_0
    if-ne v3, v2, :cond_1

    const-string v1, "\nThere is no App-based AAL configuration.\n"

    .line 537
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 538
    invoke-direct {p0}, Lcom/mediatek/amsAal/AalUtils;->dumpDebugUsageInternal()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 540
    :cond_1
    sget-boolean v1, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz v1, :cond_2

    const-string v1, "AalUtils"

    .line 541
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "dump config: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 544
    :cond_2
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method private ensureBacklightLevel(I)I
    .locals 3

    const-string p0, "Invalid AAL backlight level: "

    const-string v0, "AalUtils"

    if-gez p1, :cond_1

    .line 317
    sget-boolean v1, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz v1, :cond_0

    .line 318
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    const/4 p0, 0x0

    return p0

    :cond_1
    const/16 v1, 0x100

    if-le p1, v1, :cond_3

    .line 322
    sget-boolean v2, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz v2, :cond_2

    .line 323
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    return v1

    :cond_3
    return p1
.end method

.method private getAalConfig(Lcom/mediatek/amsAal/AalUtils$AalIndex;)Lcom/mediatek/amsAal/AalUtils$AalConfig;
    .locals 2

    .line 333
    iget-object v0, p0, Lcom/mediatek/amsAal/AalUtils;->mConfig:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 334
    iget-object v0, p0, Lcom/mediatek/amsAal/AalUtils;->mConfig:Ljava/util/Map;

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    goto :goto_0

    .line 336
    :cond_0
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz v0, :cond_1

    .line 337
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "No config for "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "AalUtils"

    invoke-static {v1, v0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_1
    const/4 v0, -0x1

    .line 340
    :goto_0
    new-instance v1, Lcom/mediatek/amsAal/AalUtils$AalConfig;

    invoke-virtual {p1}, Lcom/mediatek/amsAal/AalUtils$AalIndex;->getIndexName()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v1, p0, p1, v0}, Lcom/mediatek/amsAal/AalUtils$AalConfig;-><init>(Lcom/mediatek/amsAal/AalUtils;Ljava/lang/String;I)V

    return-object v1
.end method

.method public static getInstance()Lcom/mediatek/amsAal/AalUtils;
    .locals 1

    .line 125
    sget-object v0, Lcom/mediatek/amsAal/AalUtils;->sInstance:Lcom/mediatek/amsAal/AalUtils;

    if-nez v0, :cond_0

    .line 126
    new-instance v0, Lcom/mediatek/amsAal/AalUtils;

    invoke-direct {v0}, Lcom/mediatek/amsAal/AalUtils;-><init>()V

    sput-object v0, Lcom/mediatek/amsAal/AalUtils;->sInstance:Lcom/mediatek/amsAal/AalUtils;

    .line 128
    :cond_0
    sget-object v0, Lcom/mediatek/amsAal/AalUtils;->sInstance:Lcom/mediatek/amsAal/AalUtils;

    return-object v0
.end method

.method public static isSupported()Z
    .locals 2

    .line 112
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz v0, :cond_0

    .line 113
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isSupported = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/mediatek/amsAal/AalUtils;->sIsAalSupported:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "AalUtils"

    invoke-static {v1, v0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 115
    :cond_0
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sIsAalSupported:Z

    return v0
.end method

.method private modeToString(I)Ljava/lang/String;
    .locals 1

    if-eqz p1, :cond_2

    const/4 p0, 0x1

    if-eq p1, p0, :cond_1

    const/4 p0, 0x2

    if-eq p1, p0, :cond_0

    .line 354
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Unknown mode: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    const-string p0, "AAL_MODE_LOWPOWER"

    return-object p0

    :cond_1
    const-string p0, "AAL_MODE_BALANCE"

    return-object p0

    :cond_2
    const-string p0, "AAL_MODE_PERFORMANCE"

    return-object p0
.end method

.method private parseXML()V
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/xmlpull/v1/XmlPullParserException;,
            Ljava/io/IOException;
        }
    .end annotation

    .line 604
    new-instance v0, Ljava/io/File;

    sget-object v1, Lcom/mediatek/amsAal/AalUtils;->sAalConfigXMLPath:Ljava/lang/String;

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_1

    .line 605
    sget-boolean p0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p0, :cond_0

    .line 606
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "parseXML file not exists: "

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v0, Lcom/mediatek/amsAal/AalUtils;->sAalConfigXMLPath:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "AalUtils"

    invoke-static {v0, p0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void

    .line 610
    :cond_1
    new-instance v0, Ljava/io/FileReader;

    sget-object v1, Lcom/mediatek/amsAal/AalUtils;->sAalConfigXMLPath:Ljava/lang/String;

    invoke-direct {v0, v1}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V

    .line 611
    invoke-static {}, Landroid/util/Xml;->newPullParser()Lorg/xmlpull/v1/XmlPullParser;

    move-result-object v1

    .line 612
    invoke-interface {v1, v0}, Lorg/xmlpull/v1/XmlPullParser;->setInput(Ljava/io/Reader;)V

    .line 613
    invoke-interface {v1}, Lorg/xmlpull/v1/XmlPullParser;->getEventType()I

    move-result v2

    :goto_0
    const/4 v3, 0x1

    if-eq v2, v3, :cond_4

    const/4 v4, 0x2

    if-eq v2, v4, :cond_2

    goto :goto_1

    .line 619
    :cond_2
    invoke-interface {v1}, Lorg/xmlpull/v1/XmlPullParser;->getName()Ljava/lang/String;

    move-result-object v2

    const-string v5, "config"

    invoke-virtual {v2, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_3

    const/4 v2, 0x0

    .line 620
    invoke-interface {v1, v2}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(I)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v2

    .line 621
    invoke-interface {v1, v3}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(I)Ljava/lang/String;

    move-result-object v3

    .line 622
    invoke-interface {v1, v4}, Lorg/xmlpull/v1/XmlPullParser;->getAttributeValue(I)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    .line 623
    iget-object v5, p0, Lcom/mediatek/amsAal/AalUtils;->mConfig:Ljava/util/Map;

    new-instance v6, Lcom/mediatek/amsAal/AalUtils$AalIndex;

    invoke-direct {v6, p0, v2, v3}, Lcom/mediatek/amsAal/AalUtils$AalIndex;-><init>(Lcom/mediatek/amsAal/AalUtils;ILjava/lang/String;)V

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v5, v6, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 629
    :cond_3
    :goto_1
    invoke-interface {v1}, Lorg/xmlpull/v1/XmlPullParser;->next()I

    move-result v2

    goto :goto_0

    .line 632
    :cond_4
    invoke-virtual {v0}, Ljava/io/FileReader;->close()V

    return-void
.end method

.method private declared-synchronized setDebugInternal(Z)Ljava/lang/String;
    .locals 2

    monitor-enter p0

    .line 554
    :try_start_0
    sput-boolean p1, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    .line 555
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Set Debug: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private native setSmartBacklightStrength(I)V
.end method

.method private declared-synchronized setSmartBacklightTableInternal(Ljava/lang/String;I)Ljava/lang/String;
    .locals 1

    monitor-enter p0

    .line 566
    :try_start_0
    iget v0, p0, Lcom/mediatek/amsAal/AalUtils;->mAalMode:I

    invoke-direct {p0, p1, p2, v0}, Lcom/mediatek/amsAal/AalUtils;->setSmartBacklightTableInternal(Ljava/lang/String;II)Ljava/lang/String;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method private declared-synchronized setSmartBacklightTableInternal(Ljava/lang/String;II)Ljava/lang/String;
    .locals 2

    monitor-enter p0

    .line 578
    :try_start_0
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sEnabled:Z

    if-nez v0, :cond_1

    const-string p1, "AAL is not enabled"

    .line 580
    sget-boolean p2, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p2, :cond_0

    const-string p2, "AalUtils"

    .line 581
    invoke-static {p2, p1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 583
    :cond_0
    monitor-exit p0

    return-object p1

    :cond_1
    if-ltz p3, :cond_4

    const/4 v0, 0x3

    if-lt p3, v0, :cond_2

    goto :goto_0

    .line 594
    :cond_2
    :try_start_1
    new-instance v0, Lcom/mediatek/amsAal/AalUtils$AalIndex;

    invoke-direct {v0, p0, p3, p1}, Lcom/mediatek/amsAal/AalUtils$AalIndex;-><init>(Lcom/mediatek/amsAal/AalUtils;ILjava/lang/String;)V

    .line 595
    sget-boolean p1, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p1, :cond_3

    const-string p1, "AalUtils"

    .line 596
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setSmartBacklightTable("

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ") for "

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-static {p1, p3}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 598
    :cond_3
    iget-object p1, p0, Lcom/mediatek/amsAal/AalUtils;->mConfig:Ljava/util/Map;

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p3

    invoke-interface {p1, v0, p3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 600
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Set("

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, ") for "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    monitor-exit p0

    return-object p1

    .line 587
    :cond_4
    :goto_0
    :try_start_2
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "Unknown mode: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 588
    sget-boolean p2, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p2, :cond_5

    const-string p2, "AalUtils"

    .line 589
    invoke-static {p2, p1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 591
    :cond_5
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method


# virtual methods
.method public dump(Ljava/io/PrintWriter;[Ljava/lang/String;I)I
    .locals 5

    .line 440
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sIsAalSupported:Z

    if-eqz v0, :cond_a

    .line 441
    array-length v0, p2

    const/4 v1, 0x1

    if-gt v0, v1, :cond_0

    .line 442
    invoke-direct {p0}, Lcom/mediatek/amsAal/AalUtils;->dumpDebugUsageInternal()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto/16 :goto_1

    .line 444
    :cond_0
    aget-object v0, p2, p3

    const-string v2, "dump"

    .line 445
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const/4 v3, 0x2

    if-eqz v2, :cond_1

    array-length v2, p2

    if-ne v2, v3, :cond_1

    .line 446
    invoke-direct {p0}, Lcom/mediatek/amsAal/AalUtils;->dumpInternal()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto/16 :goto_1

    :cond_1
    const-string v2, "debugon"

    .line 447
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    array-length v2, p2

    if-ne v2, v3, :cond_2

    .line 448
    invoke-direct {p0, v1}, Lcom/mediatek/amsAal/AalUtils;->setDebugInternal(Z)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p0, "App-based AAL debug on"

    .line 449
    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto/16 :goto_1

    :cond_2
    const-string v2, "debugoff"

    .line 450
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const/4 v4, 0x0

    if-eqz v2, :cond_3

    array-length v2, p2

    if-ne v2, v3, :cond_3

    .line 451
    invoke-direct {p0, v4}, Lcom/mediatek/amsAal/AalUtils;->setDebugInternal(Z)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p0, "App-based AAL debug off"

    .line 452
    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto/16 :goto_1

    :cond_3
    const-string v2, "on"

    .line 453
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_4

    array-length v2, p2

    if-ne v2, v3, :cond_4

    .line 454
    invoke-virtual {p0, v1}, Lcom/mediatek/amsAal/AalUtils;->setEnabledInternal(Z)V

    const-string p0, "App-based AAL on"

    .line 455
    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto/16 :goto_1

    :cond_4
    const-string v2, "off"

    .line 456
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_5

    array-length v2, p2

    if-ne v2, v3, :cond_5

    .line 457
    invoke-virtual {p0, v4}, Lcom/mediatek/amsAal/AalUtils;->setEnabledInternal(Z)V

    const-string p0, "App-based AAL off"

    .line 458
    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_1

    :cond_5
    const-string v2, "mode"

    .line 459
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const-string v3, "Done"

    if-eqz v2, :cond_6

    array-length v2, p2

    const/4 v4, 0x3

    if-ne v2, v4, :cond_6

    add-int/lit8 p3, p3, 0x1

    .line 461
    aget-object p2, p2, p3

    invoke-static {p2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p2

    .line 462
    invoke-virtual {p0, p2}, Lcom/mediatek/amsAal/AalUtils;->setAalModeInternal(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 463
    invoke-virtual {p1, v3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_1

    :cond_6
    const-string v2, "set"

    .line 464
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9

    array-length v0, p2

    const/4 v2, 0x4

    if-eq v0, v2, :cond_7

    array-length v0, p2

    const/4 v4, 0x5

    if-ne v0, v4, :cond_9

    :cond_7
    add-int/lit8 p3, p3, 0x1

    .line 467
    aget-object v0, p2, p3

    add-int/2addr p3, v1

    .line 469
    aget-object v1, p2, p3

    invoke-static {v1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    .line 470
    array-length v4, p2

    if-ne v4, v2, :cond_8

    .line 471
    invoke-direct {p0, v0, v1}, Lcom/mediatek/amsAal/AalUtils;->setSmartBacklightTableInternal(Ljava/lang/String;I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_0

    :cond_8
    add-int/lit8 p3, p3, 0x1

    .line 474
    aget-object p2, p2, p3

    invoke-static {p2}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p2

    .line 475
    invoke-direct {p0, v0, v1, p2}, Lcom/mediatek/amsAal/AalUtils;->setSmartBacklightTableInternal(Ljava/lang/String;II)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 477
    :goto_0
    invoke-virtual {p1, v3}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_1

    .line 479
    :cond_9
    invoke-direct {p0}, Lcom/mediatek/amsAal/AalUtils;->dumpDebugUsageInternal()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_1

    :cond_a
    const-string p0, "Not support App-based AAL"

    .line 483
    invoke-virtual {p1, p0}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    :goto_1
    return p3
.end method

.method public onAfterActivityResumed(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    .line 300
    new-instance v0, Landroid/content/ComponentName;

    invoke-direct {v0, p1, p2}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Lcom/mediatek/amsAal/AalUtils;->setSmartBacklightInternal(Landroid/content/ComponentName;)V

    return-void
.end method

.method public onUpdateSleep(ZZ)V
    .locals 2

    .line 304
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz v0, :cond_0

    .line 305
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onUpdateSleep before="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, " after="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "AalUtils"

    invoke-static {v1, v0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    if-eq p1, p2, :cond_1

    const/4 p1, 0x1

    if-ne p2, p1, :cond_1

    const-string p1, "for sleep"

    .line 309
    invoke-virtual {p0, p1}, Lcom/mediatek/amsAal/AalUtils;->setDefaultSmartBacklightInternal(Ljava/lang/String;)V

    :cond_1
    return-void
.end method

.method public setAalMode(I)V
    .locals 1

    .line 137
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sIsAalSupported:Z

    if-nez v0, :cond_1

    .line 138
    sget-boolean p0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p0, :cond_0

    const-string p0, "AalUtils"

    const-string p1, "AAL is not supported"

    .line 139
    invoke-static {p0, p1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void

    .line 144
    :cond_1
    invoke-virtual {p0, p1}, Lcom/mediatek/amsAal/AalUtils;->setAalModeInternal(I)Ljava/lang/String;

    return-void
.end method

.method declared-synchronized setAalModeInternal(I)Ljava/lang/String;
    .locals 2

    monitor-enter p0

    .line 170
    :try_start_0
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sEnabled:Z

    if-nez v0, :cond_1

    const-string p1, "AAL is not enabled"

    .line 172
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz v0, :cond_0

    const-string v0, "AalUtils"

    .line 173
    invoke-static {v0, p1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 175
    :cond_0
    monitor-exit p0

    return-object p1

    :cond_1
    if-ltz p1, :cond_2

    const/4 v0, 0x3

    if-ge p1, v0, :cond_2

    .line 180
    :try_start_1
    iput p1, p0, Lcom/mediatek/amsAal/AalUtils;->mAalMode:I

    .line 181
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "setAalModeInternal "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/mediatek/amsAal/AalUtils;->mAalMode:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "("

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/mediatek/amsAal/AalUtils;->mAalMode:I

    invoke-direct {p0, v0}, Lcom/mediatek/amsAal/AalUtils;->modeToString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ")"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    goto :goto_0

    .line 183
    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "unknown mode "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 186
    :goto_0
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz v0, :cond_3

    const-string v0, "AalUtils"

    .line 187
    invoke-static {v0, p1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 189
    :cond_3
    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized setDefaultSmartBacklightInternal(Ljava/lang/String;)V
    .locals 4

    monitor-enter p0

    .line 278
    :try_start_0
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sEnabled:Z

    if-nez v0, :cond_1

    .line 279
    sget-boolean p1, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p1, :cond_0

    const-string p1, "AalUtils"

    const-string v0, "AAL is not enabled"

    .line 280
    invoke-static {p1, v0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 282
    :cond_0
    monitor-exit p0

    return-void

    .line 285
    :cond_1
    :try_start_1
    iget-object v0, p0, Lcom/mediatek/amsAal/AalUtils;->mCurrentConfig:Lcom/mediatek/amsAal/AalUtils$AalConfig;

    if-eqz v0, :cond_2

    iget v0, v0, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mLevel:I

    const/16 v1, 0x80

    if-eq v0, v1, :cond_2

    const-string v0, "AalUtils"

    .line 286
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "setSmartBacklightStrength(128) "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 287
    iget-object p1, p0, Lcom/mediatek/amsAal/AalUtils;->mCurrentConfig:Lcom/mediatek/amsAal/AalUtils$AalConfig;

    iput v1, p1, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mLevel:I

    const/4 v0, 0x0

    .line 288
    iput-object v0, p1, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mName:Ljava/lang/String;

    .line 289
    invoke-direct {p0, v1}, Lcom/mediatek/amsAal/AalUtils;->setSmartBacklightStrength(I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 291
    :cond_2
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public setEnabled(Z)V
    .locals 1

    .line 153
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sIsAalSupported:Z

    if-nez v0, :cond_1

    .line 154
    sget-boolean p0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p0, :cond_0

    const-string p0, "AalUtils"

    const-string p1, "AAL is not supported"

    .line 155
    invoke-static {p0, p1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void

    .line 160
    :cond_1
    invoke-virtual {p0, p1}, Lcom/mediatek/amsAal/AalUtils;->setEnabledInternal(Z)V

    return-void
.end method

.method public declared-synchronized setEnabledInternal(Z)V
    .locals 2

    monitor-enter p0

    .line 198
    :try_start_0
    sput-boolean p1, Lcom/mediatek/amsAal/AalUtils;->sEnabled:Z

    if-nez p1, :cond_0

    const-string p1, "disabled"

    .line 200
    invoke-virtual {p0, p1}, Lcom/mediatek/amsAal/AalUtils;->setDefaultSmartBacklightInternal(Ljava/lang/String;)V

    const-string p1, "persist.vendor.sys.mtk_app_aal_support"

    const-string v0, "0"

    .line 201
    invoke-static {p1, v0}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const-string p1, "persist.vendor.sys.mtk_app_aal_support"

    const-string v0, "1"

    .line 203
    invoke-static {p1, v0}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 206
    :goto_0
    sget-boolean p1, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p1, :cond_1

    const-string p1, "AalUtils"

    .line 207
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setEnabledInternal("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/mediatek/amsAal/AalUtils;->sEnabled:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ")"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 209
    :cond_1
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized setSmartBacklightInternal(Landroid/content/ComponentName;)V
    .locals 1

    monitor-enter p0

    .line 217
    :try_start_0
    iget v0, p0, Lcom/mediatek/amsAal/AalUtils;->mAalMode:I

    invoke-virtual {p0, p1, v0}, Lcom/mediatek/amsAal/AalUtils;->setSmartBacklightInternal(Landroid/content/ComponentName;I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 218
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method

.method public declared-synchronized setSmartBacklightInternal(Landroid/content/ComponentName;I)V
    .locals 5

    monitor-enter p0

    .line 227
    :try_start_0
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sEnabled:Z

    if-nez v0, :cond_1

    .line 228
    sget-boolean p1, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p1, :cond_0

    const-string p1, "AalUtils"

    const-string p2, "AAL is not enabled"

    .line 229
    invoke-static {p1, p2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 231
    :cond_0
    monitor-exit p0

    return-void

    :cond_1
    if-ltz p2, :cond_8

    const/4 v0, 0x3

    if-lt p2, v0, :cond_2

    goto/16 :goto_0

    .line 241
    :cond_2
    :try_start_1
    iget-object v0, p0, Lcom/mediatek/amsAal/AalUtils;->mCurrentConfig:Lcom/mediatek/amsAal/AalUtils$AalConfig;

    const/16 v1, 0x80

    if-nez v0, :cond_4

    .line 242
    sget-boolean v0, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz v0, :cond_3

    const-string v0, "AalUtils"

    const-string v2, "mCurrentConfig == null"

    .line 243
    invoke-static {v0, v2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 245
    :cond_3
    new-instance v0, Lcom/mediatek/amsAal/AalUtils$AalConfig;

    const/4 v2, 0x0

    invoke-direct {v0, p0, v2, v1}, Lcom/mediatek/amsAal/AalUtils$AalConfig;-><init>(Lcom/mediatek/amsAal/AalUtils;Ljava/lang/String;I)V

    iput-object v0, p0, Lcom/mediatek/amsAal/AalUtils;->mCurrentConfig:Lcom/mediatek/amsAal/AalUtils$AalConfig;

    .line 249
    :cond_4
    new-instance v0, Lcom/mediatek/amsAal/AalUtils$AalIndex;

    invoke-virtual {p1}, Landroid/content/ComponentName;->flattenToShortString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v0, p0, p2, v2}, Lcom/mediatek/amsAal/AalUtils$AalIndex;-><init>(Lcom/mediatek/amsAal/AalUtils;ILjava/lang/String;)V

    .line 250
    invoke-direct {p0, v0}, Lcom/mediatek/amsAal/AalUtils;->getAalConfig(Lcom/mediatek/amsAal/AalUtils$AalIndex;)Lcom/mediatek/amsAal/AalUtils$AalConfig;

    move-result-object v2

    .line 251
    iget v3, v2, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mLevel:I

    const/4 v4, -0x1

    if-ne v4, v3, :cond_5

    .line 252
    new-instance v0, Lcom/mediatek/amsAal/AalUtils$AalIndex;

    invoke-virtual {p1}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, p0, p2, p1}, Lcom/mediatek/amsAal/AalUtils$AalIndex;-><init>(Lcom/mediatek/amsAal/AalUtils;ILjava/lang/String;)V

    .line 253
    invoke-direct {p0, v0}, Lcom/mediatek/amsAal/AalUtils;->getAalConfig(Lcom/mediatek/amsAal/AalUtils$AalIndex;)Lcom/mediatek/amsAal/AalUtils$AalConfig;

    move-result-object v2

    .line 254
    iget p1, v2, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mLevel:I

    if-ne v4, p1, :cond_5

    .line 255
    iput v1, v2, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mLevel:I

    .line 259
    :cond_5
    iget p1, v2, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mLevel:I

    invoke-direct {p0, p1}, Lcom/mediatek/amsAal/AalUtils;->ensureBacklightLevel(I)I

    move-result p1

    .line 260
    sget-boolean p2, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p2, :cond_6

    const-string p2, "AalUtils"

    .line 261
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setSmartBacklight current level: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/mediatek/amsAal/AalUtils;->mCurrentConfig:Lcom/mediatek/amsAal/AalUtils$AalConfig;

    iget v2, v2, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mLevel:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " for "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {p2, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 264
    :cond_6
    iget-object p2, p0, Lcom/mediatek/amsAal/AalUtils;->mCurrentConfig:Lcom/mediatek/amsAal/AalUtils$AalConfig;

    iget p2, p2, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mLevel:I

    if-eq p2, p1, :cond_7

    const-string p2, "AalUtils"

    .line 265
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setSmartBacklightStrength("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, ") for "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {p2, v1}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 266
    iget-object p2, p0, Lcom/mediatek/amsAal/AalUtils;->mCurrentConfig:Lcom/mediatek/amsAal/AalUtils$AalConfig;

    iput p1, p2, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mLevel:I

    .line 267
    invoke-virtual {v0}, Lcom/mediatek/amsAal/AalUtils$AalIndex;->getIndexName()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p2, Lcom/mediatek/amsAal/AalUtils$AalConfig;->mName:Ljava/lang/String;

    .line 268
    invoke-direct {p0, p1}, Lcom/mediatek/amsAal/AalUtils;->setSmartBacklightStrength(I)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 270
    :cond_7
    monitor-exit p0

    return-void

    .line 235
    :cond_8
    :goto_0
    :try_start_2
    sget-boolean p1, Lcom/mediatek/amsAal/AalUtils;->sDebug:Z

    if-eqz p1, :cond_9

    const-string p1, "AalUtils"

    .line 236
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unknown mode: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p1, p2}, Landroid/util/Slog;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 238
    :cond_9
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit p0

    throw p1
.end method
