.class public Lcom/android/internal/telephony/data/DataProfileManager;
.super Landroid/os/Handler;
.source "DataProfileManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;
    }
.end annotation


# static fields
.field private static final EVENT_APN_DATABASE_CHANGED:I = 0x2

.field protected static final EVENT_DATA_CONFIG_UPDATED:I = 0x1

.field protected static final EVENT_SIM_REFRESH:I = 0x3

.field private static final VDBG:Z = true


# instance fields
.field protected final mAllDataProfiles:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/telephony/data/DataProfile;",
            ">;"
        }
    .end annotation
.end field

.field protected final mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

.field protected final mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

.field protected final mDataProfileManagerCallbacks:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;",
            ">;"
        }
    .end annotation
.end field

.field protected mInitialAttachDataProfile:Landroid/telephony/data/DataProfile;

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field protected final mLogTag:Ljava/lang/String;

.field protected final mPhone:Lcom/android/internal/telephony/Phone;

.field protected mPreferredDataProfile:Landroid/telephony/data/DataProfile;

.field protected mPreferredDataProfileSetId:I

.field private final mWwanDataServiceManager:Lcom/android/internal/telephony/data/DataServiceManager;


# direct methods
.method public static synthetic $r8$lambda$4E4HndCKSTuhDtagf-R9tpfYvJ8(ILandroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$updateInitialAttachDataProfileAtModem$7(ILandroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$6_rt0E4NJCuvDZo5xC13ao25TRM(Lcom/android/internal/telephony/data/DataProfileManager;Landroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$getApnSettingForNetworkRequest$12(Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$6pNxHpyrdOtw1T5nDPU6WnUT4Ws(Ljava/lang/String;Landroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$getPreferredDataProfileFromConfig$5(Ljava/lang/String;Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$CYwPX0W-mY2zeKuj_x1hd11M9OI(Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$updateDataProfiles$3(Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$E_6IQCJiIV4qvc_uwX2BNOvcjE4(Landroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$updateDataProfiles$2(Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$KKLvhx9LywyTqXUhp-dSK5Ari6U(Lcom/android/internal/telephony/data/DataProfileManager;Landroid/telephony/data/DataProfile;)Ljava/lang/Boolean;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$getApnSettingForNetworkRequest$8(Landroid/telephony/data/DataProfile;)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$OUdzOeNwTIXC2IzovqgrSvlBAbA(ILandroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$getApnSettingForNetworkRequest$11(ILandroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$QgGgtr4eB7Jh93dHbGVoU_NFYo4(ILandroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$getPreferredDataProfileFromDb$4(ILandroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$QvzPI_xVj2YcxKB8afXPRmQNsQU(Lcom/android/internal/telephony/data/DataProfileManager;Landroid/telephony/data/DataProfile;Landroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$isDataProfileCompatible$14(Landroid/telephony/data/DataProfile;Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$YNTJR5QEOXUqqO5gFlmr2rWobGI(ILandroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$getApnSettingForNetworkRequest$9(ILandroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$bMYKs-045I-0QjRdKncn7nIOEjc(ILandroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$getApnSettingForNetworkRequest$10(ILandroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$f1nAi1CaQb9GHTcV8evWbfWrw1o(Landroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$updateDataProfiles$1(Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$f4zvW-jDwdEIRkYKkNyglM_RDwg(Lcom/android/internal/telephony/data/DataProfileManager;Landroid/telephony/data/DataProfile;)Ljava/lang/Boolean;
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$updateInitialAttachDataProfileAtModem$6(Landroid/telephony/data/DataProfile;)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$ioPulQvy3hDGmtPKSFO4gBcazF0(Landroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$isDataProfileCompatible$13(Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$zN5nYL1uSez3PTa_mumndSfo4YI(Landroid/telephony/data/DataProfile;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->lambda$updateDataProfiles$0(Landroid/telephony/data/DataProfile;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$monInternetDataNetworkConnected(Lcom/android/internal/telephony/data/DataProfileManager;Ljava/util/List;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->onInternetDataNetworkConnected(Ljava/util/List;)V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Lcom/android/internal/telephony/data/DataServiceManager;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)V
    .locals 2

    .line 144
    invoke-direct {p0, p4}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 80
    new-instance p4, Lcom/android/internal/telephony/LocalLog;

    const/16 v0, 0x80

    invoke-direct {p4, v0}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 96
    new-instance p4, Ljava/util/ArrayList;

    invoke-direct {p4}, Ljava/util/ArrayList;-><init>()V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    const/4 p4, 0x0

    .line 99
    iput-object p4, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mInitialAttachDataProfile:Landroid/telephony/data/DataProfile;

    .line 102
    iput-object p4, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfile:Landroid/telephony/data/DataProfile;

    const/4 p4, 0x0

    .line 105
    iput p4, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfileSetId:I

    .line 108
    new-instance p4, Landroid/util/ArraySet;

    invoke-direct {p4}, Landroid/util/ArraySet;-><init>()V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataProfileManagerCallbacks:Ljava/util/Set;

    .line 145
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 146
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DPM-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mLogTag:Ljava/lang/String;

    .line 147
    iput-object p2, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    .line 148
    iput-object p3, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mWwanDataServiceManager:Lcom/android/internal/telephony/data/DataServiceManager;

    .line 149
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataConfigManager()Lcom/android/internal/telephony/data/DataConfigManager;

    move-result-object p1

    iput-object p1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 150
    invoke-interface {p4, p5}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 151
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->registerAllEvents()V

    return-void
.end method

.method private getApnSettingForNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Landroid/telephony/data/ApnSetting;
    .locals 9

    const/4 v0, 0x1

    .line 678
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasAttribute(I)Z

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    const-string p1, "Network request does not have APN setting attribute."

    .line 680
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->loge(Ljava/lang/String;)V

    return-object v2

    .line 686
    :cond_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    .line 687
    new-instance v3, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda4;

    invoke-direct {v3, p1}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda4;-><init>(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;)V

    invoke-interface {v1, v3}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v3, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda5;

    invoke-direct {v3, p0}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/data/DataProfileManager;)V

    .line 691
    invoke-static {v3}, Ljava/util/Comparator;->comparing(Ljava/util/function/Function;)Ljava/util/Comparator;

    move-result-object v3

    new-instance v4, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda6;

    invoke-direct {v4}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda6;-><init>()V

    .line 692
    invoke-interface {v3, v4}, Ljava/util/Comparator;->thenComparingLong(Ljava/util/function/ToLongFunction;)Ljava/util/Comparator;

    move-result-object v3

    .line 691
    invoke-interface {v1, v3}, Ljava/util/stream/Stream;->sorted(Ljava/util/Comparator;)Ljava/util/stream/Stream;

    move-result-object v1

    .line 693
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v3

    invoke-interface {v1, v3}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/List;

    .line 694
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->isMtkImsDataSupport()Z

    move-result v3

    const/4 v4, 0x0

    if-eqz v3, :cond_1

    .line 695
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v3

    if-nez v3, :cond_1

    const/16 v3, 0xa

    .line 696
    invoke-virtual {p1, v3}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasCapability(I)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 697
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    new-instance p2, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {p2}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    const/16 v0, 0x200

    const-string v1, "DEFAULT EIMS"

    const-string v3, ""

    .line 698
    invoke-virtual {p0, v1, v3, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->buildMTKDefaultApnSetting(Ljava/lang/String;Ljava/lang/String;I)Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {p2, v0}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p2

    new-instance v0, Landroid/telephony/data/TrafficDescriptor;

    invoke-direct {v0, v3, v2}, Landroid/telephony/data/TrafficDescriptor;-><init>(Ljava/lang/String;[B)V

    .line 700
    invoke-virtual {p2, v0}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p2

    .line 701
    invoke-virtual {p2}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object p2

    .line 697
    invoke-interface {p1, p2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const-string p1, "For ECC w/o SIM requirement,Added default EIMS data profile."

    .line 702
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 703
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {p0, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/data/DataProfile;

    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    return-object p0

    .line 706
    :cond_1
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_2

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/telephony/data/DataProfile;

    .line 707
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Satisfied profile: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v7, ", last setup="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 708
    invoke-virtual {v5}, Landroid/telephony/data/DataProfile;->getLastSetupTimestamp()J

    move-result-wide v7

    invoke-static {v7, v8}, Lcom/android/internal/telephony/data/DataUtils;->elapsedTimeToString(J)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 707
    invoke-direct {p0, v5}, Lcom/android/internal/telephony/data/DataProfileManager;->logv(Ljava/lang/String;)V

    goto :goto_0

    .line 710
    :cond_2
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v3

    if-nez v3, :cond_3

    .line 711
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Can\'t find any data profile that can satisfy "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    return-object v2

    .line 716
    :cond_3
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->isMtkImsDataSupport()Z

    move-result v3

    if-eqz v3, :cond_6

    .line 717
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v3}, Lcom/android/internal/telephony/Phone;->getAccessNetworksManager()Lcom/android/internal/telephony/data/AccessNetworksManager;

    move-result-object v3

    .line 719
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result p1

    .line 718
    invoke-virtual {v3, p1}, Lcom/android/internal/telephony/data/AccessNetworksManager;->getPreferredTransportByNetworkCapability(I)I

    move-result p1

    if-ne p1, v0, :cond_4

    .line 721
    invoke-interface {v1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda7;

    invoke-direct {v0, p2}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda7;-><init>(I)V

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 726
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    move-object v1, p1

    check-cast v1, Ljava/util/List;

    goto :goto_1

    :cond_4
    const/4 v0, 0x2

    if-ne p1, v0, :cond_5

    .line 728
    invoke-interface {v1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda8;

    invoke-direct {v0, p2}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda8;-><init>(I)V

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 733
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    move-object v1, p1

    check-cast v1, Ljava/util/List;

    .line 735
    :cond_5
    :goto_1
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_2
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_7

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/data/DataProfile;

    .line 736
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "The final available profile: "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    goto :goto_2

    .line 739
    :cond_6
    invoke-interface {v1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda9;

    invoke-direct {v0, p2}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda9;-><init>(I)V

    .line 740
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 742
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    move-object v1, p1

    check-cast v1, Ljava/util/List;

    .line 744
    :cond_7
    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result p1

    if-nez p1, :cond_8

    .line 745
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Can\'t find any data profile for network type "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 746
    invoke-static {p2}, Landroid/telephony/TelephonyManager;->getNetworkTypeName(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 745
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    return-object v2

    .line 751
    :cond_8
    invoke-interface {v1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance p2, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda10;

    invoke-direct {p2, p0}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda10;-><init>(Lcom/android/internal/telephony/data/DataProfileManager;)V

    .line 752
    invoke-interface {p1, p2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 756
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object p2

    invoke-interface {p1, p2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/List;

    .line 757
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p2

    if-nez p2, :cond_9

    .line 758
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "Can\'t find any data profile has APN set id matched. mPreferredDataProfileSetId="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p2, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfileSetId:I

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    return-object v2

    .line 763
    :cond_9
    invoke-interface {p1, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/data/DataProfile;

    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    return-object p0
.end method

.method private getPreferredDataProfileFromConfig()Landroid/telephony/data/DataProfile;
    .locals 3

    .line 450
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getDefaultPreferredApn()Ljava/lang/String;

    move-result-object v0

    .line 451
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    .line 452
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v1, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda1;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda1;-><init>(Ljava/lang/String;)V

    .line 453
    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 455
    invoke-interface {p0}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object p0

    .line 456
    invoke-virtual {p0, v2}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/data/DataProfile;

    return-object p0

    :cond_0
    return-object v2
.end method

.method private getPreferredDataProfileFromDb()Landroid/telephony/data/DataProfile;
    .locals 7

    .line 424
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    sget-object v0, Landroid/provider/Telephony$Carriers;->PREFERRED_APN_URI:Landroid/net/Uri;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 426
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v2

    .line 425
    invoke-static {v0, v2}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const-string v6, "name ASC"

    .line 424
    invoke-virtual/range {v1 .. v6}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 430
    invoke-interface {v0}, Landroid/database/Cursor;->getCount()I

    move-result v2

    if-lez v2, :cond_0

    .line 431
    invoke-interface {v0}, Landroid/database/Cursor;->moveToFirst()Z

    const-string v2, "_id"

    .line 432
    invoke-interface {v0, v2}, Landroid/database/Cursor;->getColumnIndexOrThrow(Ljava/lang/String;)I

    move-result v2

    invoke-interface {v0, v2}, Landroid/database/Cursor;->getInt(I)I

    move-result v2

    .line 433
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v3

    new-instance v4, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda0;

    invoke-direct {v4, v2}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda0;-><init>(I)V

    .line 434
    invoke-interface {v3, v4}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v2

    .line 436
    invoke-interface {v2}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object v2

    .line 437
    invoke-virtual {v2, v1}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/data/DataProfile;

    .line 439
    :cond_0
    invoke-interface {v0}, Landroid/database/Cursor;->close()V

    .line 441
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getPreferredDataProfileFromDb: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    return-object v1
.end method

.method private isMtkImsDataSupport()Z
    .locals 1

    const-string p0, "ro.vendor.mtk_telephony_add_on_policy"

    const-string v0, "0"

    .line 968
    invoke-static {p0, v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_1

    const-string p0, "ro.mtk.ims.data.feature_support"

    .line 969
    invoke-static {p0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "1"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

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

.method private static synthetic lambda$getApnSettingForNetworkRequest$10(ILandroid/telephony/data/DataProfile;)Z
    .locals 1

    .line 728
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 729
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/telephony/data/ApnSetting;->canSupportNetworkType(I)Z

    move-result v0

    if-nez v0, :cond_0

    const/16 v0, 0xa

    .line 730
    invoke-virtual {p1, v0}, Landroid/telephony/data/DataProfile;->canSatisfy(I)Z

    move-result v0

    if-eqz v0, :cond_1

    if-nez p0, :cond_1

    .line 732
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    const/16 p1, 0x12

    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting;->canSupportNetworkType(I)Z

    move-result p0

    if-eqz p0, :cond_1

    :cond_0
    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$getApnSettingForNetworkRequest$11(ILandroid/telephony/data/DataProfile;)Z
    .locals 1

    .line 740
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 741
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    invoke-virtual {p1, p0}, Landroid/telephony/data/ApnSetting;->canSupportNetworkType(I)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$getApnSettingForNetworkRequest$12(Landroid/telephony/data/DataProfile;)Z
    .locals 2

    .line 752
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 753
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getApnSetId()I

    move-result v0

    const/4 v1, -0x1

    if-eq v0, v1, :cond_0

    .line 755
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getApnSetId()I

    move-result p1

    iget p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfileSetId:I

    if-ne p1, p0, :cond_1

    :cond_0
    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$getApnSettingForNetworkRequest$8(Landroid/telephony/data/DataProfile;)Ljava/lang/Boolean;
    .locals 0

    .line 691
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p1, p0}, Landroid/telephony/data/DataProfile;->equals(Ljava/lang/Object;)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$getApnSettingForNetworkRequest$9(ILandroid/telephony/data/DataProfile;)Z
    .locals 1

    .line 721
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 722
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/telephony/data/ApnSetting;->canSupportNetworkType(I)Z

    move-result v0

    if-nez v0, :cond_0

    const/16 v0, 0xa

    .line 723
    invoke-virtual {p1, v0}, Landroid/telephony/data/DataProfile;->canSatisfy(I)Z

    move-result v0

    if-eqz v0, :cond_1

    if-nez p0, :cond_1

    .line 725
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    const/16 p1, 0xd

    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting;->canSupportNetworkType(I)Z

    move-result p0

    if-eqz p0, :cond_1

    :cond_0
    const/4 p0, 0x1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$getPreferredDataProfileFromConfig$5(Ljava/lang/String;Landroid/telephony/data/DataProfile;)Z
    .locals 1

    .line 453
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 454
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object p1

    .line 453
    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$getPreferredDataProfileFromDb$4(ILandroid/telephony/data/DataProfile;)Z
    .locals 1

    .line 434
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 435
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getId()I

    move-result p1

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$isDataProfileCompatible$13(Landroid/telephony/data/DataProfile;)Z
    .locals 0

    .line 941
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$isDataProfileCompatible$14(Landroid/telephony/data/DataProfile;Landroid/telephony/data/DataProfile;)Z
    .locals 0

    .line 942
    invoke-virtual {p2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p2

    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 943
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRoamingFromRegistration()Z

    move-result p0

    .line 942
    invoke-virtual {p2, p1, p0}, Landroid/telephony/data/ApnSetting;->equals(Ljava/lang/Object;Z)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$updateDataProfiles$0(Landroid/telephony/data/DataProfile;)Z
    .locals 1

    const/16 v0, 0x1d

    .line 270
    invoke-virtual {p0, v0}, Landroid/telephony/data/DataProfile;->canSatisfy(I)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$updateDataProfiles$1(Landroid/telephony/data/DataProfile;)Z
    .locals 1

    const/4 v0, 0x4

    .line 283
    invoke-virtual {p0, v0}, Landroid/telephony/data/DataProfile;->canSatisfy(I)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$updateDataProfiles$2(Landroid/telephony/data/DataProfile;)Z
    .locals 1

    const/16 v0, 0xa

    .line 306
    invoke-virtual {p0, v0}, Landroid/telephony/data/DataProfile;->canSatisfy(I)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$updateDataProfiles$3(Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)V
    .locals 1

    .line 354
    invoke-static {p0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda18;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda18;-><init>(Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)V

    .line 353
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$updateInitialAttachDataProfileAtModem$6(Landroid/telephony/data/DataProfile;)Ljava/lang/Boolean;
    .locals 0

    .line 533
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p1, p0}, Landroid/telephony/data/DataProfile;->equals(Ljava/lang/Object;)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$updateInitialAttachDataProfileAtModem$7(ILandroid/telephony/data/DataProfile;)Z
    .locals 0

    .line 538
    invoke-static {p0}, Lcom/android/internal/telephony/data/DataUtils;->apnTypeToNetworkCapability(I)I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/telephony/data/DataProfile;->canSatisfy(I)Z

    move-result p0

    return p0
.end method

.method private log(Ljava/lang/String;)V
    .locals 0

    .line 977
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private loge(Ljava/lang/String;)V
    .locals 0

    .line 985
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private logv(Ljava/lang/String;)V
    .locals 0

    .line 993
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->v(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static mergeDataProfiles(Landroid/telephony/data/DataProfile;Landroid/telephony/data/DataProfile;)Landroid/telephony/data/DataProfile;
    .locals 4

    .line 846
    invoke-static {p0}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 847
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 850
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v0

    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v1

    invoke-static {v0, v1}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return-object v1

    .line 853
    :cond_0
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_e

    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-nez v0, :cond_1

    goto/16 :goto_a

    .line 856
    :cond_1
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/telephony/data/ApnSetting;->similar(Landroid/telephony/data/ApnSetting;)Z

    move-result v0

    if-nez v0, :cond_2

    return-object v1

    .line 859
    :cond_2
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    .line 860
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    .line 861
    new-instance v1, Landroid/telephony/data/ApnSetting$Builder;

    invoke-direct {v1}, Landroid/telephony/data/ApnSetting$Builder;-><init>()V

    .line 865
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getId()I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setId(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 866
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getEntryName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setEntryName(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    const/16 v2, 0x11

    .line 867
    invoke-virtual {p1, v2}, Landroid/telephony/data/ApnSetting;->canHandleType(I)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 868
    invoke-virtual {v0, v2}, Landroid/telephony/data/ApnSetting;->canHandleType(I)Z

    move-result v2

    if-nez v2, :cond_3

    .line 869
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getId()I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setId(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 870
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getEntryName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setEntryName(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    .line 874
    :cond_3
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getProxyAddressAsString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_4

    .line 875
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getProxyAddressAsString()Ljava/lang/String;

    move-result-object v2

    goto :goto_0

    :cond_4
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getProxyAddressAsString()Ljava/lang/String;

    move-result-object v2

    .line 874
    :goto_0
    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setProxyAddress(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    .line 876
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getProxyPort()I

    move-result v2

    const/4 v3, -0x1

    if-ne v2, v3, :cond_5

    .line 877
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getProxyPort()I

    move-result v2

    goto :goto_1

    :cond_5
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getProxyPort()I

    move-result v2

    .line 876
    :goto_1
    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setProxyPort(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 878
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMmsc()Landroid/net/Uri;

    move-result-object v2

    if-nez v2, :cond_6

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getMmsc()Landroid/net/Uri;

    move-result-object v2

    goto :goto_2

    :cond_6
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMmsc()Landroid/net/Uri;

    move-result-object v2

    :goto_2
    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setMmsc(Landroid/net/Uri;)Landroid/telephony/data/ApnSetting$Builder;

    .line 879
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMmsProxyAddressAsString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_7

    .line 880
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getMmsProxyAddressAsString()Ljava/lang/String;

    move-result-object v2

    goto :goto_3

    :cond_7
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMmsProxyAddressAsString()Ljava/lang/String;

    move-result-object v2

    .line 879
    :goto_3
    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setMmsProxyAddress(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    .line 881
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMmsProxyPort()I

    move-result v2

    if-ne v2, v3, :cond_8

    .line 882
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getMmsProxyPort()I

    move-result v2

    goto :goto_4

    :cond_8
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMmsProxyPort()I

    move-result v2

    .line 881
    :goto_4
    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setMmsProxyPort(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 883
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getUser()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_9

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getUser()Ljava/lang/String;

    move-result-object v2

    goto :goto_5

    :cond_9
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getUser()Ljava/lang/String;

    move-result-object v2

    :goto_5
    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setUser(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    .line 884
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getPassword()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_a

    .line 885
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getPassword()Ljava/lang/String;

    move-result-object v2

    goto :goto_6

    :cond_a
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getPassword()Ljava/lang/String;

    move-result-object v2

    .line 884
    :goto_6
    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setPassword(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    .line 886
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getAuthType()I

    move-result v2

    if-ne v2, v3, :cond_b

    .line 887
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getAuthType()I

    move-result v2

    goto :goto_7

    :cond_b
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getAuthType()I

    move-result v2

    .line 886
    :goto_7
    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setAuthType(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 888
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getApnTypeBitmask()I

    move-result v2

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getApnTypeBitmask()I

    move-result v3

    or-int/2addr v2, v3

    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setApnTypeBitmask(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 889
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMtuV4()I

    move-result v2

    if-gtz v2, :cond_c

    .line 890
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getMtuV4()I

    move-result v2

    goto :goto_8

    :cond_c
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMtuV4()I

    move-result v2

    .line 889
    :goto_8
    invoke-virtual {v1, v2}, Landroid/telephony/data/ApnSetting$Builder;->setMtuV4(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 891
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMtuV6()I

    move-result v2

    if-gtz v2, :cond_d

    .line 892
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getMtuV6()I

    move-result p1

    goto :goto_9

    :cond_d
    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getMtuV6()I

    move-result p1

    .line 891
    :goto_9
    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setMtuV6(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 896
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setApnName(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    .line 897
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getProtocol()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setProtocol(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 898
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getRoamingProtocol()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setRoamingProtocol(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 899
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->isEnabled()Z

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setCarrierEnabled(Z)Landroid/telephony/data/ApnSetting$Builder;

    .line 900
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getNetworkTypeBitmask()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setNetworkTypeBitmask(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 901
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getLingeringNetworkTypeBitmask()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Landroid/telephony/data/ApnSetting$Builder;->setLingeringNetworkTypeBitmask(J)Landroid/telephony/data/ApnSetting$Builder;

    .line 902
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getProfileId()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setProfileId(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 903
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->isPersistent()Z

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setPersistent(Z)Landroid/telephony/data/ApnSetting$Builder;

    .line 904
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getMaxConns()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setMaxConns(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 905
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getWaitTime()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setWaitTime(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 906
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getMaxConnsTime()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setMaxConnsTime(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 907
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getMvnoType()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setMvnoType(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 908
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getMvnoMatchData()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setMvnoMatchData(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    .line 909
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getApnSetId()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setApnSetId(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 910
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getCarrierId()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setCarrierId(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 911
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getSkip464Xlat()I

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setSkip464Xlat(I)Landroid/telephony/data/ApnSetting$Builder;

    .line 912
    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->isAlwaysOn()Z

    move-result p1

    invoke-virtual {v1, p1}, Landroid/telephony/data/ApnSetting$Builder;->setAlwaysOn(Z)Landroid/telephony/data/ApnSetting$Builder;

    .line 914
    new-instance p1, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {p1}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    .line 915
    invoke-virtual {v1}, Landroid/telephony/data/ApnSetting$Builder;->build()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p1

    .line 916
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p0

    .line 917
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object p0

    return-object p0

    :cond_e
    :goto_a
    return-object v1
.end method

.method private onDataConfigUpdated()V
    .locals 1

    const-string v0, "Update data profiles due to config updated."

    .line 201
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 202
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->updateDataProfiles()V

    return-void
.end method

.method private onInternetDataNetworkConnected(Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/data/DataProfile;",
            ">;)V"
        }
    .end annotation

    .line 405
    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda6;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda6;-><init>()V

    .line 406
    invoke-static {v0}, Ljava/util/Comparator;->comparingLong(Ljava/util/function/ToLongFunction;)Ljava/util/Comparator;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Comparator;->reversed()Ljava/util/Comparator;

    move-result-object v0

    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->max(Ljava/util/Comparator;)Ljava/util/Optional;

    move-result-object p1

    const/4 v0, 0x0

    .line 407
    invoke-virtual {p1, v0}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/telephony/data/DataProfile;

    if-eqz p1, :cond_0

    .line 410
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->isDataProfilePreferred(Landroid/telephony/data/DataProfile;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 414
    :cond_0
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->setPreferredDataProfile(Landroid/telephony/data/DataProfile;)V

    .line 415
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->updateDataProfiles()V

    return-void
.end method

.method private setPreferredDataProfile(Landroid/telephony/data/DataProfile;)V
    .locals 3

    .line 468
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "setPreferredDataProfile: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 470
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    int-to-long v0, v0

    invoke-static {v0, v1}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v0

    .line 471
    sget-object v1, Landroid/provider/Telephony$Carriers;->PREFERRED_APN_URI:Landroid/net/Uri;

    invoke-static {v1, v0}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 472
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    const/4 v1, 0x0

    .line 473
    invoke-virtual {p0, v0, v1, v1}, Landroid/content/ContentResolver;->delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I

    if-eqz p1, :cond_0

    .line 475
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 476
    new-instance v1, Landroid/content/ContentValues;

    invoke-direct {v1}, Landroid/content/ContentValues;-><init>()V

    .line 479
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getId()I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    const-string v2, "apn_id"

    invoke-virtual {v1, v2, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 480
    invoke-virtual {p0, v0, v1}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;

    :cond_0
    return-void
.end method


# virtual methods
.method protected buildDefaultApnSetting(Ljava/lang/String;Ljava/lang/String;I)Landroid/telephony/data/ApnSetting;
    .locals 0

    .line 579
    new-instance p0, Landroid/telephony/data/ApnSetting$Builder;

    invoke-direct {p0}, Landroid/telephony/data/ApnSetting$Builder;-><init>()V

    .line 580
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setEntryName(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    const/4 p1, 0x2

    .line 581
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setProtocol(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    .line 582
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setRoamingProtocol(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    .line 583
    invoke-virtual {p0, p2}, Landroid/telephony/data/ApnSetting$Builder;->setApnName(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    .line 584
    invoke-virtual {p0, p3}, Landroid/telephony/data/ApnSetting$Builder;->setApnTypeBitmask(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    const/4 p1, 0x1

    .line 585
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setCarrierEnabled(Z)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    const/4 p1, -0x1

    .line 586
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setApnSetId(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    .line 587
    invoke-virtual {p0}, Landroid/telephony/data/ApnSetting$Builder;->build()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    return-object p0
.end method

.method protected buildMTKDefaultApnSetting(Ljava/lang/String;Ljava/lang/String;I)Landroid/telephony/data/ApnSetting;
    .locals 0

    .line 592
    new-instance p0, Landroid/telephony/data/ApnSetting$Builder;

    invoke-direct {p0}, Landroid/telephony/data/ApnSetting$Builder;-><init>()V

    .line 593
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setEntryName(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    const/4 p1, 0x2

    .line 594
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setProtocol(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    .line 595
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setRoamingProtocol(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    .line 596
    invoke-virtual {p0, p2}, Landroid/telephony/data/ApnSetting$Builder;->setApnName(Ljava/lang/String;)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    .line 597
    invoke-virtual {p0, p3}, Landroid/telephony/data/ApnSetting$Builder;->setApnTypeBitmask(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    const/4 p1, 0x1

    .line 598
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setCarrierEnabled(Z)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    const/4 p1, -0x1

    .line 599
    invoke-virtual {p0, p1}, Landroid/telephony/data/ApnSetting$Builder;->setApnSetId(I)Landroid/telephony/data/ApnSetting$Builder;

    move-result-object p0

    .line 600
    invoke-virtual {p0}, Landroid/telephony/data/ApnSetting$Builder;->buildWithoutCheck()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    return-object p0
.end method

.method protected dedupeDataProfiles(Ljava/util/List;)V
    .locals 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/telephony/data/DataProfile;",
            ">;)V"
        }
    .end annotation

    const/4 v0, 0x0

    .line 814
    :goto_0
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    if-ge v0, v1, :cond_2

    .line 815
    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/data/DataProfile;

    add-int/lit8 v2, v0, 0x1

    move v3, v2

    .line 817
    :goto_1
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v4

    if-ge v3, v4, :cond_1

    .line 818
    invoke-interface {p1, v3}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/telephony/data/DataProfile;

    .line 819
    invoke-static {v1, v4}, Lcom/android/internal/telephony/data/DataProfileManager;->mergeDataProfiles(Landroid/telephony/data/DataProfile;Landroid/telephony/data/DataProfile;)Landroid/telephony/data/DataProfile;

    move-result-object v5

    if-eqz v5, :cond_0

    .line 821
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Created a merged profile "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v7, " from "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v7, " and "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 823
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Merging data profiles will not be supported anymore. Please directly configure the merged profile "

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v6, " in the APN config."

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataProfileManager;->loge(Ljava/lang/String;)V

    .line 826
    invoke-interface {p1, v0, v5}, Ljava/util/List;->set(ILjava/lang/Object;)Ljava/lang/Object;

    .line 827
    invoke-interface {p1, v3}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    goto :goto_1

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_1
    move v0, v2

    goto :goto_0

    :cond_2
    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 5

    .line 1013
    new-instance v0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 1014
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-class v1, Lcom/android/internal/telephony/data/DataProfileManager;

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "-"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1015
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Data profiles for the current carrier:"

    .line 1017
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1018
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1019
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/data/DataProfile;

    .line 1020
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->print(Ljava/lang/Object;)V

    .line 1021
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, ", last setup time: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1022
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getLastSetupTimestamp()J

    move-result-wide v3

    .line 1021
    invoke-static {v3, v4}, Lcom/android/internal/telephony/data/DataUtils;->elapsedTimeToString(J)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    goto :goto_0

    .line 1024
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1026
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Preferred data profile="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1027
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Preferred data profile from db="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->getPreferredDataProfileFromDb()Landroid/telephony/data/DataProfile;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1028
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Preferred data profile from config="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->getPreferredDataProfileFromConfig()Landroid/telephony/data/DataProfile;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1029
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Preferred data profile set id="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfileSetId:I

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1030
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Initial attach data profile="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mInitialAttachDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1031
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "isTetheringDataProfileExisting="

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0xd

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataProfileManager;->isTetheringDataProfileExisting(I)Z

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    const-string p2, "Local logs:"

    .line 1034
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1035
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1036
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1037
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1038
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-void
.end method

.method public getDataProfileForNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Landroid/telephony/data/DataProfile;
    .locals 4

    const/4 v0, 0x1

    .line 613
    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasAttribute(I)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 615
    invoke-direct {p0, p1, p2}, Lcom/android/internal/telephony/data/DataProfileManager;->getApnSettingForNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Landroid/telephony/data/ApnSetting;

    move-result-object p2

    goto :goto_0

    :cond_0
    move-object p2, v1

    .line 618
    :goto_0
    new-instance v0, Landroid/telephony/data/TrafficDescriptor$Builder;

    invoke-direct {v0}, Landroid/telephony/data/TrafficDescriptor$Builder;-><init>()V

    const/4 v2, 0x2

    .line 619
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasAttribute(I)Z

    move-result v2

    if-eqz v2, :cond_1

    if-eqz p2, :cond_1

    .line 622
    invoke-virtual {p2}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/telephony/data/TrafficDescriptor$Builder;->setDataNetworkName(Ljava/lang/String;)Landroid/telephony/data/TrafficDescriptor$Builder;

    :cond_1
    const/4 v2, 0x4

    .line 626
    invoke-virtual {p1, v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->hasAttribute(I)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 628
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getOsAppId()Landroid/telephony/data/TrafficDescriptor$OsAppId;

    move-result-object v2

    if-eqz v2, :cond_2

    .line 630
    invoke-virtual {v2}, Landroid/telephony/data/TrafficDescriptor$OsAppId;->getBytes()[B

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/telephony/data/TrafficDescriptor$Builder;->setOsAppId([B)Landroid/telephony/data/TrafficDescriptor$Builder;

    .line 636
    :cond_2
    :try_start_0
    invoke-virtual {v0}, Landroid/telephony/data/TrafficDescriptor$Builder;->build()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    .line 646
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_3
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/data/DataProfile;

    .line 647
    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v3

    invoke-static {p2, v3}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 648
    invoke-virtual {v2}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/telephony/data/TrafficDescriptor;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_3

    return-object v2

    .line 656
    :cond_4
    new-instance v1, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {v1}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    if-eqz p2, :cond_5

    .line 658
    invoke-virtual {v1, p2}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    .line 662
    :cond_5
    invoke-virtual {v1, v0}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    .line 664
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object p2

    .line 665
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Created data profile "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " for "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    return-object p2

    .line 639
    :catch_0
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "Unable to find a data profile for "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    return-object v1
.end method

.method protected getEnterpriseDataProfile()Landroid/telephony/data/DataProfile;
    .locals 7

    .line 213
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    sget-object v2, Landroid/provider/Telephony$Carriers;->DPC_URI:Landroid/net/Uri;

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    invoke-virtual/range {v1 .. v6}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    const-string v0, "Cannot access APN database through telephony provider."

    .line 216
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->loge(Ljava/lang/String;)V

    return-object v1

    :cond_0
    move-object p0, v1

    .line 221
    :cond_1
    invoke-interface {v0}, Landroid/database/Cursor;->moveToNext()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 222
    invoke-static {v0}, Landroid/telephony/data/ApnSetting;->makeApnSetting(Landroid/database/Cursor;)Landroid/telephony/data/ApnSetting;

    move-result-object v2

    if-eqz v2, :cond_1

    .line 224
    new-instance p0, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {p0}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    .line 225
    invoke-virtual {p0, v2}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p0

    new-instance v3, Landroid/telephony/data/TrafficDescriptor;

    .line 226
    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v3, v2, v1}, Landroid/telephony/data/TrafficDescriptor;-><init>(Ljava/lang/String;[B)V

    invoke-virtual {p0, v3}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p0

    const/4 v2, 0x0

    .line 227
    invoke-virtual {p0, v2}, Landroid/telephony/data/DataProfile$Builder;->setPreferred(Z)Landroid/telephony/data/DataProfile$Builder;

    move-result-object p0

    .line 228
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object p0

    const/16 v2, 0x1d

    .line 229
    invoke-virtual {p0, v2}, Landroid/telephony/data/DataProfile;->canSatisfy(I)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 234
    :cond_2
    invoke-interface {v0}, Landroid/database/Cursor;->close()V

    return-object p0
.end method

.method protected getPreferredDataProfileSetId()I
    .locals 7

    .line 364
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    sget-object v0, Landroid/provider/Telephony$Carriers;->PREFERRED_APN_SET_URI:Landroid/net/Uri;

    iget-object v2, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 366
    invoke-virtual {v2}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v2

    .line 365
    invoke-static {v0, v2}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    const-string v0, "apn_set_id"

    filled-new-array {v0}, [Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    invoke-virtual/range {v1 .. v6}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    const-string v0, "getPreferredDataProfileSetId: cursor is null"

    .line 372
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    return v2

    .line 377
    :cond_0
    invoke-interface {v1}, Landroid/database/Cursor;->getCount()I

    move-result v3

    const/4 v4, 0x1

    if-ge v3, v4, :cond_1

    const-string v0, "getPreferredDataProfileSetId: no APNs found"

    .line 378
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->loge(Ljava/lang/String;)V

    goto :goto_0

    .line 381
    :cond_1
    invoke-interface {v1}, Landroid/database/Cursor;->moveToFirst()Z

    .line 382
    invoke-interface {v1, v0}, Landroid/database/Cursor;->getColumnIndexOrThrow(Ljava/lang/String;)I

    move-result p0

    invoke-interface {v1, p0}, Landroid/database/Cursor;->getInt(I)I

    move-result v2

    .line 385
    :goto_0
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    return v2
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 2

    .line 179
    iget v0, p1, Landroid/os/Message;->what:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_2

    const/4 v1, 0x2

    if-eq v0, v1, :cond_1

    const/4 v1, 0x3

    if-eq v0, v1, :cond_0

    .line 192
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected event "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->loge(Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const-string p1, "Update data profiles due to SIM refresh."

    .line 184
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 185
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->updateDataProfiles()V

    goto :goto_0

    :cond_1
    const-string p1, "Update data profiles due to APN db updated."

    .line 188
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 189
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->updateDataProfiles()V

    goto :goto_0

    .line 181
    :cond_2
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->onDataConfigUpdated()V

    :goto_0
    return-void
.end method

.method public isAnyPreferredDataProfileExisting()Z
    .locals 1

    .line 803
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/data/DataProfile;

    .line 804
    invoke-virtual {v0}, Landroid/telephony/data/DataProfile;->isPreferred()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method public isDataProfileCompatible(Landroid/telephony/data/DataProfile;)Z
    .locals 2

    if-nez p1, :cond_0

    const/4 p0, 0x0

    return p0

    .line 933
    :cond_0
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-nez v0, :cond_1

    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object v0

    if-eqz v0, :cond_1

    const/4 p0, 0x1

    return p0

    .line 940
    :cond_1
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda16;

    invoke-direct {v1}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda16;-><init>()V

    .line 941
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda17;

    invoke-direct {v1, p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda17;-><init>(Lcom/android/internal/telephony/data/DataProfileManager;Landroid/telephony/data/DataProfile;)V

    .line 942
    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0
.end method

.method public isDataProfilePreferred(Landroid/telephony/data/DataProfile;)Z
    .locals 0

    .line 773
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p1, p0}, Landroid/telephony/data/DataProfile;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method public isTetheringDataProfileExisting(I)Z
    .locals 4

    .line 785
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->isTetheringProfileDisabledForRoaming()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 786
    invoke-interface {v0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/ServiceState;->getDataRoaming()Z

    move-result v0

    if-eqz v0, :cond_0

    return v1

    .line 790
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    new-instance v2, Landroid/net/NetworkRequest$Builder;

    invoke-direct {v2}, Landroid/net/NetworkRequest$Builder;-><init>()V

    const/4 v3, 0x2

    .line 792
    invoke-virtual {v2, v3}, Landroid/net/NetworkRequest$Builder;->addCapability(I)Landroid/net/NetworkRequest$Builder;

    move-result-object v2

    .line 793
    invoke-virtual {v2}, Landroid/net/NetworkRequest$Builder;->build()Landroid/net/NetworkRequest;

    move-result-object v2

    iget-object v3, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-direct {v0, v2, v3}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;-><init>(Landroid/net/NetworkRequest;Lcom/android/internal/telephony/Phone;)V

    .line 794
    invoke-virtual {p0, v0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->getDataProfileForNetworkRequest(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Landroid/telephony/data/DataProfile;

    move-result-object p0

    if-eqz p0, :cond_1

    const/4 v1, 0x1

    :cond_1
    return v1
.end method

.method protected logl(Ljava/lang/String;)V
    .locals 0

    .line 1001
    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 1002
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected registerAllEvents()V
    .locals 4

    .line 158
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataNetworkController:Lcom/android/internal/telephony/data/DataNetworkController;

    new-instance v1, Lcom/android/internal/telephony/data/DataProfileManager$1;

    new-instance v2, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda11;

    invoke-direct {v2, p0}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda11;-><init>(Lcom/android/internal/telephony/data/DataProfileManager;)V

    invoke-direct {v1, p0, v2}, Lcom/android/internal/telephony/data/DataProfileManager$1;-><init>(Lcom/android/internal/telephony/data/DataProfileManager;Ljava/util/concurrent/Executor;)V

    invoke-virtual {v0, v1}, Lcom/android/internal/telephony/data/DataNetworkController;->registerDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    .line 165
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    const/4 v1, 0x1

    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/data/DataConfigManager;->registerForConfigUpdate(Landroid/os/Handler;I)V

    .line 166
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    sget-object v2, Landroid/provider/Telephony$Carriers;->CONTENT_URI:Landroid/net/Uri;

    new-instance v3, Lcom/android/internal/telephony/data/DataProfileManager$2;

    invoke-direct {v3, p0, p0}, Lcom/android/internal/telephony/data/DataProfileManager$2;-><init>(Lcom/android/internal/telephony/data/DataProfileManager;Landroid/os/Handler;)V

    invoke-virtual {v0, v2, v1, v3}, Landroid/content/ContentResolver;->registerContentObserver(Landroid/net/Uri;ZLandroid/database/ContentObserver;)V

    .line 174
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    iget-object v0, v0, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    const/4 v1, 0x3

    const/4 v2, 0x0

    invoke-interface {v0, p0, v1, v2}, Lcom/android/internal/telephony/CommandsInterface;->registerForIccRefresh(Landroid/os/Handler;ILjava/lang/Object;)V

    return-void
.end method

.method public registerCallback(Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)V
    .locals 0

    .line 952
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataProfileManagerCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public unregisterCallback(Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)V
    .locals 0

    .line 961
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataProfileManagerCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    return-void
.end method

.method protected updateDataProfiles()V
    .locals 10

    .line 242
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 243
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->isConfigCarrierSpecific()Z

    move-result v1

    const/4 v2, 0x0

    const/4 v3, 0x0

    if-eqz v1, :cond_2

    .line 244
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    sget-object v1, Landroid/provider/Telephony$Carriers;->SIM_APN_URI:Landroid/net/Uri;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "filtered/subId/"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 246
    invoke-virtual {v6}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 245
    invoke-static {v1, v5}, Landroid/net/Uri;->withAppendedPath(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const-string v9, "_id"

    .line 244
    invoke-virtual/range {v4 .. v9}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    if-nez v1, :cond_0

    const-string v0, "Cannot access APN database through telephony provider."

    .line 248
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->loge(Ljava/lang/String;)V

    return-void

    .line 252
    :cond_0
    :goto_0
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result v4

    if-eqz v4, :cond_1

    .line 253
    invoke-static {v1}, Landroid/telephony/data/ApnSetting;->makeApnSetting(Landroid/database/Cursor;)Landroid/telephony/data/ApnSetting;

    move-result-object v4

    if-eqz v4, :cond_0

    .line 255
    new-instance v5, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {v5}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    .line 256
    invoke-virtual {v5, v4}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v5

    new-instance v6, Landroid/telephony/data/TrafficDescriptor;

    .line 257
    invoke-virtual {v4}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v4

    invoke-direct {v6, v4, v3}, Landroid/telephony/data/TrafficDescriptor;-><init>(Ljava/lang/String;[B)V

    invoke-virtual {v5, v6}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v4

    .line 258
    invoke-virtual {v4, v2}, Landroid/telephony/data/DataProfile$Builder;->setPreferred(Z)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v4

    .line 259
    invoke-virtual {v4}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object v4

    .line 260
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 261
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Added "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    goto :goto_0

    .line 264
    :cond_1
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 269
    :cond_2
    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v4, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda12;

    invoke-direct {v4}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda12;-><init>()V

    .line 270
    invoke-interface {v1, v4}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v1

    .line 271
    invoke-interface {v1}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object v1

    .line 272
    invoke-virtual {v1, v3}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/data/DataProfile;

    if-nez v1, :cond_3

    .line 274
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->getEnterpriseDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v1

    if-eqz v1, :cond_3

    .line 276
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 277
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Added enterprise profile "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 282
    :cond_3
    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v4, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda13;

    invoke-direct {v4}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda13;-><init>()V

    .line 283
    invoke-interface {v1, v4}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v1

    .line 284
    invoke-interface {v1}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object v1

    .line 285
    invoke-virtual {v1, v3}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/data/DataProfile;

    if-nez v1, :cond_5

    .line 287
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->isMtkImsDataSupport()Z

    move-result v1

    const/16 v4, 0x40

    const-string v5, "DEFAULT IMS"

    const-string v6, "ims"

    if-eqz v1, :cond_4

    .line 288
    new-instance v1, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {v1}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    .line 289
    invoke-virtual {p0, v5, v6, v4}, Lcom/android/internal/telephony/data/DataProfileManager;->buildMTKDefaultApnSetting(Ljava/lang/String;Ljava/lang/String;I)Landroid/telephony/data/ApnSetting;

    move-result-object v4

    invoke-virtual {v1, v4}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    new-instance v4, Landroid/telephony/data/TrafficDescriptor;

    invoke-direct {v4, v6, v3}, Landroid/telephony/data/TrafficDescriptor;-><init>(Ljava/lang/String;[B)V

    .line 291
    invoke-virtual {v1, v4}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    .line 292
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object v1

    .line 288
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const-string v1, "Added default MTK IMS data profile."

    .line 293
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    goto :goto_1

    .line 295
    :cond_4
    new-instance v1, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {v1}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    .line 296
    invoke-virtual {p0, v5, v6, v4}, Lcom/android/internal/telephony/data/DataProfileManager;->buildDefaultApnSetting(Ljava/lang/String;Ljava/lang/String;I)Landroid/telephony/data/ApnSetting;

    move-result-object v4

    invoke-virtual {v1, v4}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    new-instance v4, Landroid/telephony/data/TrafficDescriptor;

    invoke-direct {v4, v6, v3}, Landroid/telephony/data/TrafficDescriptor;-><init>(Ljava/lang/String;[B)V

    .line 298
    invoke-virtual {v1, v4}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    .line 299
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object v1

    .line 295
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const-string v1, "Added default IMS data profile."

    .line 300
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 305
    :cond_5
    :goto_1
    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v1

    new-instance v4, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda14;

    invoke-direct {v4}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda14;-><init>()V

    .line 306
    invoke-interface {v1, v4}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v1

    .line 307
    invoke-interface {v1}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object v1

    .line 308
    invoke-virtual {v1, v3}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/telephony/data/DataProfile;

    if-nez v1, :cond_7

    .line 310
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->isMtkImsDataSupport()Z

    move-result v1

    const/16 v4, 0x200

    const-string v5, "DEFAULT EIMS"

    if-eqz v1, :cond_6

    .line 311
    new-instance v1, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {v1}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    const-string v6, ""

    .line 312
    invoke-virtual {p0, v5, v6, v4}, Lcom/android/internal/telephony/data/DataProfileManager;->buildMTKDefaultApnSetting(Ljava/lang/String;Ljava/lang/String;I)Landroid/telephony/data/ApnSetting;

    move-result-object v4

    invoke-virtual {v1, v4}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    new-instance v4, Landroid/telephony/data/TrafficDescriptor;

    invoke-direct {v4, v6, v3}, Landroid/telephony/data/TrafficDescriptor;-><init>(Ljava/lang/String;[B)V

    .line 314
    invoke-virtual {v1, v4}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    .line 315
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object v1

    .line 311
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const-string v1, "Added default MTK EIMS data profile."

    .line 316
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    goto :goto_2

    .line 318
    :cond_6
    new-instance v1, Landroid/telephony/data/DataProfile$Builder;

    invoke-direct {v1}, Landroid/telephony/data/DataProfile$Builder;-><init>()V

    const-string/jumbo v6, "sos"

    .line 319
    invoke-virtual {p0, v5, v6, v4}, Lcom/android/internal/telephony/data/DataProfileManager;->buildDefaultApnSetting(Ljava/lang/String;Ljava/lang/String;I)Landroid/telephony/data/ApnSetting;

    move-result-object v4

    invoke-virtual {v1, v4}, Landroid/telephony/data/DataProfile$Builder;->setApnSetting(Landroid/telephony/data/ApnSetting;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    new-instance v4, Landroid/telephony/data/TrafficDescriptor;

    invoke-direct {v4, v6, v3}, Landroid/telephony/data/TrafficDescriptor;-><init>(Ljava/lang/String;[B)V

    .line 321
    invoke-virtual {v1, v4}, Landroid/telephony/data/DataProfile$Builder;->setTrafficDescriptor(Landroid/telephony/data/TrafficDescriptor;)Landroid/telephony/data/DataProfile$Builder;

    move-result-object v1

    .line 322
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile$Builder;->build()Landroid/telephony/data/DataProfile;

    move-result-object v1

    .line 318
    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const-string v1, "Added default EIMS data profile."

    .line 323
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 327
    :cond_7
    :goto_2
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->dedupeDataProfiles(Ljava/util/List;)V

    .line 329
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Found "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, " data profiles. profiles = "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 332
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v3

    const/4 v4, 0x1

    if-ne v1, v3, :cond_8

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->containsAll(Ljava/util/Collection;)Z

    move-result v1

    if-nez v1, :cond_9

    :cond_8
    const-string v1, "Data profiles changed."

    .line 333
    invoke-direct {p0, v1}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 334
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->clear()V

    .line 335
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    move v2, v4

    .line 340
    :cond_9
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->updatePreferredDataProfile()Z

    move-result v0

    or-int/2addr v0, v2

    .line 342
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->getPreferredDataProfileSetId()I

    move-result v1

    .line 343
    iget v2, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfileSetId:I

    if-eq v1, v2, :cond_a

    .line 344
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Changed preferred data profile set id to "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->logl(Ljava/lang/String;)V

    .line 345
    iput v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfileSetId:I

    goto :goto_3

    :cond_a
    move v4, v0

    .line 349
    :goto_3
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->updateDataProfilesAtModem()V

    .line 350
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->updateInitialAttachDataProfileAtModem()V

    if-eqz v4, :cond_b

    .line 353
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataProfileManagerCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda15;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda15;-><init>()V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    :cond_b
    return-void
.end method

.method protected updateDataProfilesAtModem()V
    .locals 3

    .line 564
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string/jumbo v1, "updateDataProfilesAtModem: set "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " data profiles."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->log(Ljava/lang/String;)V

    .line 565
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mWwanDataServiceManager:Lcom/android/internal/telephony/data/DataServiceManager;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 566
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRoamingFromRegistration()Z

    move-result p0

    const/4 v2, 0x0

    .line 565
    invoke-virtual {v0, v1, p0, v2}, Lcom/android/internal/telephony/data/DataServiceManager;->setDataProfile(Ljava/util/List;ZLandroid/os/Message;)V

    return-void
.end method

.method protected updateInitialAttachDataProfileAtModem()V
    .locals 6

    .line 532
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v0

    new-instance v1, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/DataProfileManager;)V

    .line 533
    invoke-static {v1}, Ljava/util/Comparator;->comparing(Ljava/util/function/Function;)Ljava/util/Comparator;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->sorted(Ljava/util/Comparator;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 534
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/List;

    .line 536
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v1}, Lcom/android/internal/telephony/data/DataConfigManager;->getAllowedInitialAttachApnTypes()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const/4 v2, 0x0

    move-object v3, v2

    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    .line 537
    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v4

    new-instance v5, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda3;

    invoke-direct {v5, v3}, Lcom/android/internal/telephony/data/DataProfileManager$$ExternalSyntheticLambda3;-><init>(I)V

    .line 538
    invoke-interface {v4, v5}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object v3

    .line 539
    invoke-interface {v3}, Ljava/util/stream/Stream;->findFirst()Ljava/util/Optional;

    move-result-object v3

    .line 540
    invoke-virtual {v3, v2}, Ljava/util/Optional;->orElse(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/data/DataProfile;

    if-eqz v3, :cond_0

    .line 547
    :cond_1
    iput-object v3, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mInitialAttachDataProfile:Landroid/telephony/data/DataProfile;

    .line 548
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Initial attach data profile updated as "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mInitialAttachDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->logl(Ljava/lang/String;)V

    .line 551
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mInitialAttachDataProfile:Landroid/telephony/data/DataProfile;

    if-eqz v0, :cond_2

    .line 552
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mWwanDataServiceManager:Lcom/android/internal/telephony/data/DataServiceManager;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 553
    invoke-interface {p0}, Lcom/android/internal/telephony/PhoneInternalInterface;->getServiceState()Landroid/telephony/ServiceState;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/ServiceState;->getDataRoamingFromRegistration()Z

    move-result p0

    .line 552
    invoke-virtual {v1, v0, p0, v2}, Lcom/android/internal/telephony/data/DataServiceManager;->setInitialAttachApn(Landroid/telephony/data/DataProfile;ZLandroid/os/Message;)V

    :cond_2
    return-void
.end method

.method protected updatePreferredDataProfile()Z
    .locals 4

    .line 492
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v0}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result v0

    invoke-static {v0}, Landroid/telephony/SubscriptionManager;->isValidSubscriptionId(I)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 493
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->getPreferredDataProfileFromDb()Landroid/telephony/data/DataProfile;

    move-result-object v0

    if-nez v0, :cond_1

    .line 495
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataProfileManager;->getPreferredDataProfileFromConfig()Landroid/telephony/data/DataProfile;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 498
    invoke-direct {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->setPreferredDataProfile(Landroid/telephony/data/DataProfile;)V

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 505
    :cond_1
    :goto_0
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mAllDataProfiles:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_1
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/data/DataProfile;

    .line 506
    invoke-virtual {v2, v0}, Landroid/telephony/data/DataProfile;->equals(Ljava/lang/Object;)Z

    move-result v3

    invoke-virtual {v2, v3}, Landroid/telephony/data/DataProfile;->setPreferred(Z)V

    goto :goto_1

    .line 509
    :cond_2
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfile:Landroid/telephony/data/DataProfile;

    invoke-static {v1, v0}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_3

    .line 510
    iput-object v0, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfile:Landroid/telephony/data/DataProfile;

    .line 512
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Changed preferred data profile to "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataProfileManager;->mPreferredDataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->logl(Ljava/lang/String;)V

    const/4 p0, 0x1

    return p0

    :cond_3
    const/4 p0, 0x0

    return p0
.end method
