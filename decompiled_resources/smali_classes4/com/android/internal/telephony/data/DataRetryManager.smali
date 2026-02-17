.class public Lcom/android/internal/telephony/data/DataRetryManager;
.super Landroid/os/Handler;
.source "DataRetryManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;,
        Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;,
        Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;,
        Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;,
        Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;,
        Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;,
        Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;,
        Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;,
        Lcom/android/internal/telephony/data/DataRetryManager$RetryResetReason;
    }
.end annotation


# static fields
.field private static final EVENT_CANCEL_PENDING_HANDOVER_RETRY:I = 0x7

.field private static final EVENT_DATA_CONFIG_UPDATED:I = 0x1

.field protected static final EVENT_DATA_HANDOVER_RETRY:I = 0x4

.field private static final EVENT_DATA_PROFILE_UNTHROTTLED:I = 0x6

.field protected static final EVENT_DATA_SETUP_RETRY:I = 0x3

.field private static final EVENT_MODEM_RESET:I = 0x9

.field private static final EVENT_RADIO_ON:I = 0x8

.field private static final EVENT_TAC_CHANGED:I = 0xa

.field private static final MAXIMUM_HISTORICAL_ENTRIES:I = 0x64

.field private static final RESET_REASON_DATA_CONFIG_CHANGED:I = 0x5

.field private static final RESET_REASON_DATA_PROFILES_CHANGED:I = 0x1

.field private static final RESET_REASON_DATA_SERVICE_BOUND:I = 0x4

.field public static final RESET_REASON_MODEM_RESTART:I = 0x3

.field private static final RESET_REASON_RADIO_ON:I = 0x2

.field private static final RESET_REASON_TAC_CHANGED:I = 0x6

.field private static final VDBG:Z = false


# instance fields
.field private final mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

.field private mDataHandoverRetryRuleList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;",
            ">;"
        }
    .end annotation
.end field

.field private final mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

.field private final mDataRetryEntries:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;",
            ">;"
        }
    .end annotation
.end field

.field private mDataRetryManagerCallbacks:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;",
            ">;"
        }
    .end annotation
.end field

.field private mDataServiceManagers:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/data/DataServiceManager;",
            ">;"
        }
    .end annotation
.end field

.field private mDataSetupRetryRuleList:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;",
            ">;"
        }
    .end annotation
.end field

.field protected final mDataThrottlingEntries:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;",
            ">;"
        }
    .end annotation
.end field

.field private final mLocalLog:Lcom/android/internal/telephony/LocalLog;

.field protected final mLogTag:Ljava/lang/String;

.field private final mPhone:Lcom/android/internal/telephony/Phone;

.field private final mRil:Lcom/android/internal/telephony/CommandsInterface;


# direct methods
.method public static synthetic $r8$lambda$-kKnAGbLVwKfaBalRpG_-aY7LDs(JLcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onDataProfileUnthrottled$14(JLcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$1LkgAoUJMzdlCHz82l8uwsCSWc0(Lcom/android/internal/telephony/data/DataRetryManager;IILjava/lang/Integer;)Landroid/telephony/data/ThrottleStatus;
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onDataProfileUnthrottled$19(IILjava/lang/Integer;)Landroid/telephony/data/ThrottleStatus;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$426vvrgEoe6Scgv-3vzh5LI03ro(Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$handleMessage$3(Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$7WIvNTwH64-6WJz2ta4Mea1TOps(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onDataProfileUnthrottled$16(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$9qeX16RoxSxQcnYhEhP19d-RaI8(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$handleMessage$0(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V

    return-void
.end method

.method public static synthetic $r8$lambda$AsR2WE65TN2gfQqbLq9H_uu9V7c(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onEvaluateDataHandoverRetry$6(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Dchee514g1nxDGVUbbFCFfyf2ME(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onReset$9(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Dj_8p2VYSs_73Els98LoMul6klY(JLjava/lang/String;ILcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onDataProfileUnthrottled$18(JLjava/lang/String;ILcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$DxWB0bn9zfvrTIulViY6ZEGnF04(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$isAnyHandoverRetryScheduled$26(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$I6Rtdfw-iwcCnwe2ERkmN68yHTI(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onEvaluateDataHandoverRetry$7(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Jm8PsZfmeydB_sVrd5wnUqh7KDQ(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Ljava/util/List;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$updateThrottleStatus$12(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Ljava/util/List;)V

    return-void
.end method

.method public static synthetic $r8$lambda$KZfGK4Zigmfu6HLLSkTl-VHbguc(Landroid/telephony/data/DataProfile;JILcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    invoke-static {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$isDataProfileThrottled$23(Landroid/telephony/data/DataProfile;JILcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$MCFBI-RBpFks_12R-dHSCtwnelM(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onReset$8(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$MaOdzn5MVCXbvIGnxJW_2GoQpOo(Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    invoke-static {p0}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onDataProfileUnthrottled$15(Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$QO49_gKZ0vFy4VZ_9hKxj9lcVxE(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Ljava/util/List;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onDataProfileUnthrottled$20(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Ljava/util/List;)V

    return-void
.end method

.method public static synthetic $r8$lambda$RlTE7_92uxTKbkQSNx1vNAmRFog(Ljava/util/List;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$updateThrottleStatus$13(Ljava/util/List;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$WMua22ajVKmZP5iK3KIvI8l8ZCo(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onDataProfileUnthrottled$17(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$a-CEndwerrz9qvE6s1sCV3WcWHY(Lcom/android/internal/telephony/data/DataRetryManager;IJILjava/lang/Integer;)Landroid/telephony/data/ThrottleStatus;
    .locals 0

    invoke-direct/range {p0 .. p5}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$updateThrottleStatus$11(IJILjava/lang/Integer;)Landroid/telephony/data/ThrottleStatus;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic $r8$lambda$bDYLktNtbzpcjIELt9aU26zKT2Q(Ljava/util/List;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onDataProfileUnthrottled$21(Ljava/util/List;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V

    return-void
.end method

.method public static synthetic $r8$lambda$bu8NUnjlZGfliIgNDaGWMV_pgj0(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$handleMessage$2(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V

    return-void
.end method

.method public static synthetic $r8$lambda$dkqA89n2EY1vl0EyWYMQjDRDfzc(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)Z
    .locals 0

    invoke-static {p0, p1, p2}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$isAnySetupRetryScheduled$22(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$pPi7bog3I7-Rzujw66Sm_TCVfAo(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onCancelPendingHandoverRetry$25(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$rJTIE3Xpjxjcmz7m-X6fU4nA1So(Lcom/android/internal/telephony/data/DataRetryManager;Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V
    .locals 0

    invoke-direct/range {p0 .. p6}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$evaluateDataSetupRetry$4(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V

    return-void
.end method

.method public static synthetic $r8$lambda$vwlqNp0fXQ9fbmRzH0pFXJBKJGw(Lcom/android/internal/telephony/data/DataRetryManager;Lcom/android/internal/telephony/data/DataNetwork;IJ)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$evaluateDataHandoverRetry$5(Lcom/android/internal/telephony/data/DataNetwork;IJ)V

    return-void
.end method

.method public static synthetic $r8$lambda$wAMlNFeiE7-SrxGc_ZsmYIyjEK0(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$updateThrottleStatus$10(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$wlfZb8GGTbHx_Je796TlF_mwXC8(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)Z
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$onCancelPendingHandoverRetry$24(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$zMuDJu502zGij7RvXw5L6AY3yKk(Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 0

    invoke-static {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->lambda$handleMessage$1(Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V

    return-void
.end method

.method public constructor <init>(Lcom/android/internal/telephony/Phone;Lcom/android/internal/telephony/data/DataNetworkController;Landroid/util/SparseArray;Landroid/os/Looper;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/android/internal/telephony/Phone;",
            "Lcom/android/internal/telephony/data/DataNetworkController;",
            "Landroid/util/SparseArray<",
            "Lcom/android/internal/telephony/data/DataServiceManager;",
            ">;",
            "Landroid/os/Looper;",
            "Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;",
            ")V"
        }
    .end annotation

    .line 925
    invoke-direct {p0, p4}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 147
    new-instance p4, Lcom/android/internal/telephony/LocalLog;

    const/16 v0, 0x80

    invoke-direct {p4, v0}, Lcom/android/internal/telephony/LocalLog;-><init>(I)V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    .line 153
    new-instance p4, Landroid/util/ArraySet;

    invoke-direct {p4}, Landroid/util/ArraySet;-><init>()V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryManagerCallbacks:Ljava/util/Set;

    .line 165
    new-instance p4, Ljava/util/ArrayList;

    invoke-direct {p4}, Ljava/util/ArrayList;-><init>()V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataSetupRetryRuleList:Ljava/util/List;

    .line 168
    new-instance p4, Ljava/util/ArrayList;

    invoke-direct {p4}, Ljava/util/ArrayList;-><init>()V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataHandoverRetryRuleList:Ljava/util/List;

    .line 171
    new-instance p4, Ljava/util/ArrayList;

    invoke-direct {p4}, Ljava/util/ArrayList;-><init>()V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    .line 178
    new-instance p4, Ljava/util/ArrayList;

    invoke-direct {p4}, Ljava/util/ArrayList;-><init>()V

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    .line 926
    iput-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 927
    iget-object p4, p1, Lcom/android/internal/telephony/Phone;->mCi:Lcom/android/internal/telephony/CommandsInterface;

    iput-object p4, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mRil:Lcom/android/internal/telephony/CommandsInterface;

    .line 928
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "DRM-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mLogTag:Ljava/lang/String;

    .line 929
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryManagerCallbacks:Ljava/util/Set;

    invoke-interface {v0, p5}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 931
    iput-object p3, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataServiceManagers:Landroid/util/SparseArray;

    .line 932
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataConfigManager()Lcom/android/internal/telephony/data/DataConfigManager;

    move-result-object p3

    iput-object p3, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    .line 933
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataNetworkController;->getDataProfileManager()Lcom/android/internal/telephony/data/DataProfileManager;

    move-result-object p5

    iput-object p5, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataProfileManager:Lcom/android/internal/telephony/data/DataProfileManager;

    const/4 v0, 0x1

    .line 934
    invoke-virtual {p3, p0, v0}, Lcom/android/internal/telephony/data/DataConfigManager;->registerForConfigUpdate(Landroid/os/Handler;I)V

    .line 936
    iget-object v1, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataServiceManagers:Landroid/util/SparseArray;

    invoke-virtual {v1, v0}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataServiceManager;

    const/4 v1, 0x6

    .line 937
    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->registerForApnUnthrottled(Landroid/os/Handler;I)V

    .line 938
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getAccessNetworksManager()Lcom/android/internal/telephony/data/AccessNetworksManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/AccessNetworksManager;->isInLegacyMode()Z

    move-result v0

    if-nez v0, :cond_0

    .line 939
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataServiceManagers:Landroid/util/SparseArray;

    const/4 v2, 0x2

    invoke-virtual {v0, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataServiceManager;

    .line 940
    invoke-virtual {v0, p0, v1}, Lcom/android/internal/telephony/data/DataServiceManager;->registerForApnUnthrottled(Landroid/os/Handler;I)V

    .line 942
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$1;

    new-instance v1, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda28;

    invoke-direct {v1, p0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda28;-><init>(Lcom/android/internal/telephony/data/DataRetryManager;)V

    invoke-direct {v0, p0, v1}, Lcom/android/internal/telephony/data/DataRetryManager$1;-><init>(Lcom/android/internal/telephony/data/DataRetryManager;Ljava/util/concurrent/Executor;)V

    invoke-virtual {p5, v0}, Lcom/android/internal/telephony/data/DataProfileManager;->registerCallback(Lcom/android/internal/telephony/data/DataProfileManager$DataProfileManagerCallback;)V

    .line 948
    new-instance p5, Lcom/android/internal/telephony/data/DataRetryManager$2;

    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda28;

    invoke-direct {v0, p0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda28;-><init>(Lcom/android/internal/telephony/data/DataRetryManager;)V

    invoke-direct {p5, p0, v0}, Lcom/android/internal/telephony/data/DataRetryManager$2;-><init>(Lcom/android/internal/telephony/data/DataRetryManager;Ljava/util/concurrent/Executor;)V

    invoke-virtual {p2, p5}, Lcom/android/internal/telephony/data/DataNetworkController;->registerDataNetworkControllerCallback(Lcom/android/internal/telephony/data/DataNetworkController$DataNetworkControllerCallback;)V

    const/16 p2, 0x8

    const/4 p5, 0x0

    .line 955
    invoke-interface {p4, p0, p2, p5}, Lcom/android/internal/telephony/CommandsInterface;->registerForOn(Landroid/os/Handler;ILjava/lang/Object;)V

    const/16 p2, 0x9

    .line 956
    invoke-interface {p4, p0, p2, p5}, Lcom/android/internal/telephony/CommandsInterface;->registerForModemReset(Landroid/os/Handler;ILjava/lang/Object;)V

    .line 958
    invoke-virtual {p3}, Lcom/android/internal/telephony/data/DataConfigManager;->shouldResetDataThrottlingWhenTacChanges()Z

    move-result p2

    if-eqz p2, :cond_1

    .line 959
    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getServiceStateTracker()Lcom/android/internal/telephony/ServiceStateTracker;

    move-result-object p1

    const/16 p2, 0xa

    invoke-virtual {p1, p0, p2, p5}, Lcom/android/internal/telephony/ServiceStateTracker;->registerForAreaCodeChanged(Landroid/os/Handler;ILjava/lang/Object;)V

    :cond_1
    return-void
.end method

.method private getRetryFailedCount(ILcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;)I
    .locals 6

    .line 1270
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    if-ltz v0, :cond_4

    .line 1271
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v3, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    instance-of v3, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    if-eqz v3, :cond_3

    .line 1272
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v3, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    .line 1274
    iget-object v4, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v4}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_0

    goto :goto_1

    .line 1278
    :cond_0
    iget v4, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->setupRetryType:I

    const/4 v5, 0x2

    if-ne v4, v5, :cond_3

    .line 1279
    iget-object v4, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v4}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_1

    const-string v3, "Invalid data retry entry detected"

    .line 1281
    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    .line 1282
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "mDataRetryEntries="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v5, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p0, v4}, Lcom/android/internal/telephony/data/DataRetryManager;->loge(Ljava/lang/String;)V

    const-string v4, "afeab78c-c0b0-49fc-a51f-f766814d7aa6"

    .line 1284
    invoke-static {v4}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v4

    iget-object v5, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1286
    invoke-virtual {v5}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v5

    .line 1283
    invoke-static {v4, v3, v5}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V

    goto :goto_1

    .line 1289
    :cond_1
    iget-object v4, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v4, v1}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {v4}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result v4

    if-ne v4, p1, :cond_3

    iget-object v4, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->appliedDataRetryRule:Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;

    .line 1291
    invoke-virtual {v4, p2}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_3

    .line 1292
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->getState()I

    move-result v4

    const/4 v5, 0x3

    if-eq v4, v5, :cond_4

    .line 1293
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->getState()I

    move-result v3

    const/4 v4, 0x4

    if-ne v3, v4, :cond_2

    goto :goto_2

    :cond_2
    add-int/lit8 v2, v2, 0x1

    :cond_3
    :goto_1
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    :cond_4
    :goto_2
    return v2
.end method

.method private getRetryFailedCount(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;)I
    .locals 5

    .line 1243
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    const/4 v1, 0x0

    :goto_0
    if-ltz v0, :cond_2

    .line 1244
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    instance-of v2, v2, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    if-eqz v2, :cond_1

    .line 1245
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    .line 1246
    iget-object v3, v2, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;->dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    if-ne v3, p1, :cond_1

    iget-object v3, v2, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->appliedDataRetryRule:Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;

    .line 1247
    invoke-virtual {p2, v3}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 1248
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->getState()I

    move-result v3

    const/4 v4, 0x3

    if-eq v3, v4, :cond_2

    .line 1249
    invoke-virtual {v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->getState()I

    move-result v2

    const/4 v3, 0x4

    if-ne v2, v3, :cond_0

    goto :goto_1

    :cond_0
    add-int/lit8 v1, v1, 0x1

    :cond_1
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    :cond_2
    :goto_1
    return v1
.end method

.method private synthetic lambda$evaluateDataHandoverRetry$5(Lcom/android/internal/telephony/data/DataNetwork;IJ)V
    .locals 0

    .line 1156
    invoke-direct {p0, p1, p2, p3, p4}, Lcom/android/internal/telephony/data/DataRetryManager;->onEvaluateDataHandoverRetry(Lcom/android/internal/telephony/data/DataNetwork;IJ)V

    return-void
.end method

.method private synthetic lambda$evaluateDataSetupRetry$4(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V
    .locals 0

    .line 1044
    invoke-direct/range {p0 .. p6}, Lcom/android/internal/telephony/data/DataRetryManager;->onEvaluateDataSetupRetry(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V

    return-void
.end method

.method private static synthetic lambda$handleMessage$0(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V
    .locals 0

    .line 975
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;->onDataNetworkSetupRetry(Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V

    return-void
.end method

.method private static synthetic lambda$handleMessage$1(Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 1

    .line 974
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda9;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda9;-><init>(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$handleMessage$2(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V
    .locals 0

    .line 982
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;->onDataNetworkHandoverRetry(Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V

    return-void
.end method

.method private static synthetic lambda$handleMessage$3(Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 1

    .line 981
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda27;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda27;-><init>(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$isAnyHandoverRetryScheduled$26(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)Z
    .locals 2

    .line 1589
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->getState()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    iget-object p1, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;->dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    if-ne p1, p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method private static synthetic lambda$isAnySetupRetryScheduled$22(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)Z
    .locals 2

    .line 1539
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->getState()I

    move-result v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    iget-object v0, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    .line 1540
    invoke-virtual {p0, v0}, Landroid/telephony/data/DataProfile;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    iget p0, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->transport:I

    if-ne p0, p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    return v1
.end method

.method private static synthetic lambda$isDataProfileThrottled$23(Landroid/telephony/data/DataProfile;JILcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 2

    .line 1555
    iget-object v0, p4, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {v0, p0}, Landroid/telephony/data/DataProfile;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    iget-wide v0, p4, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->expirationTimeMillis:J

    cmp-long p0, v0, p1

    if-lez p0, :cond_0

    iget p0, p4, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->transport:I

    if-ne p0, p3, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$onCancelPendingHandoverRetry$24(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)Z
    .locals 1

    .line 1574
    instance-of v0, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    if-eqz v0, :cond_0

    check-cast p1, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    iget-object p1, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;->dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$onCancelPendingHandoverRetry$25(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    .line 1576
    iget-object p1, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    if-ne p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$onDataProfileUnthrottled$14(JLcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 2

    .line 1406
    iget-wide v0, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->expirationTimeMillis:J

    cmp-long p0, v0, p0

    if-lez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static synthetic lambda$onDataProfileUnthrottled$15(Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    .line 1409
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

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

.method private static synthetic lambda$onDataProfileUnthrottled$16(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    .line 1410
    iget-object p1, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p1

    invoke-virtual {p1}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object p1

    .line 1411
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$onDataProfileUnthrottled$17(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    .line 1413
    iget-object p1, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object p1

    .line 1414
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getTrafficDescriptor()Landroid/telephony/data/TrafficDescriptor;

    move-result-object p0

    .line 1413
    invoke-static {p1, p0}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private static synthetic lambda$onDataProfileUnthrottled$18(JLjava/lang/String;ILcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 2

    .line 1420
    iget-wide v0, p4, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->expirationTimeMillis:J

    cmp-long p0, v0, p0

    if-lez p0, :cond_0

    iget-object p0, p4, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    .line 1421
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    if-eqz p0, :cond_0

    iget-object p0, p4, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    .line 1422
    invoke-virtual {p0}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p0

    invoke-virtual {p0}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    iget p0, p4, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->transport:I

    if-ne p0, p3, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private synthetic lambda$onDataProfileUnthrottled$19(IILjava/lang/Integer;)Landroid/telephony/data/ThrottleStatus;
    .locals 1

    .line 1449
    new-instance v0, Landroid/telephony/data/ThrottleStatus$Builder;

    invoke-direct {v0}, Landroid/telephony/data/ThrottleStatus$Builder;-><init>()V

    .line 1450
    invoke-virtual {p3}, Ljava/lang/Integer;->intValue()I

    move-result p3

    invoke-virtual {v0, p3}, Landroid/telephony/data/ThrottleStatus$Builder;->setApnType(I)Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p3

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1451
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {p3, p0}, Landroid/telephony/data/ThrottleStatus$Builder;->setSlotIndex(I)Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p0

    .line 1452
    invoke-virtual {p0}, Landroid/telephony/data/ThrottleStatus$Builder;->setNoThrottle()Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p0

    .line 1453
    invoke-virtual {p0, p1}, Landroid/telephony/data/ThrottleStatus$Builder;->setRetryType(I)Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p0

    .line 1454
    invoke-virtual {p0, p2}, Landroid/telephony/data/ThrottleStatus$Builder;->setTransportType(I)Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p0

    .line 1455
    invoke-virtual {p0}, Landroid/telephony/data/ThrottleStatus$Builder;->build()Landroid/telephony/data/ThrottleStatus;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$onDataProfileUnthrottled$20(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Ljava/util/List;)V
    .locals 0

    .line 1460
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;->onThrottleStatusChanged(Ljava/util/List;)V

    return-void
.end method

.method private static synthetic lambda$onDataProfileUnthrottled$21(Ljava/util/List;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 1

    .line 1459
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda22;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda22;-><init>(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Ljava/util/List;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onEvaluateDataHandoverRetry$6(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 0

    .line 1198
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;->onDataNetworkHandoverRetryStopped(Lcom/android/internal/telephony/data/DataNetwork;)V

    return-void
.end method

.method private static synthetic lambda$onEvaluateDataHandoverRetry$7(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 1

    .line 1197
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda0;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda0;-><init>(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Lcom/android/internal/telephony/data/DataNetwork;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static synthetic lambda$onReset$8(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)Z
    .locals 1

    .line 1221
    invoke-virtual {p0}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->getState()I

    move-result p0

    const/4 v0, 0x1

    if-ne p0, v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private static synthetic lambda$onReset$9(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V
    .locals 1

    const/4 v0, 0x4

    .line 1222
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->setState(I)V

    return-void
.end method

.method private static synthetic lambda$updateThrottleStatus$10(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;)Z
    .locals 0

    .line 1352
    iget-object p1, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    invoke-virtual {p0, p1}, Landroid/telephony/data/DataProfile;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private synthetic lambda$updateThrottleStatus$11(IJILjava/lang/Integer;)Landroid/telephony/data/ThrottleStatus;
    .locals 1

    .line 1366
    new-instance v0, Landroid/telephony/data/ThrottleStatus$Builder;

    invoke-direct {v0}, Landroid/telephony/data/ThrottleStatus$Builder;-><init>()V

    .line 1367
    invoke-virtual {p5}, Ljava/lang/Integer;->intValue()I

    move-result p5

    invoke-virtual {v0, p5}, Landroid/telephony/data/ThrottleStatus$Builder;->setApnType(I)Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p5

    .line 1368
    invoke-virtual {p5, p1}, Landroid/telephony/data/ThrottleStatus$Builder;->setRetryType(I)Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p1

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1369
    invoke-virtual {p0}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/telephony/data/ThrottleStatus$Builder;->setSlotIndex(I)Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p0

    .line 1370
    invoke-virtual {p0, p2, p3}, Landroid/telephony/data/ThrottleStatus$Builder;->setThrottleExpiryTimeMillis(J)Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p0

    .line 1371
    invoke-virtual {p0, p4}, Landroid/telephony/data/ThrottleStatus$Builder;->setTransportType(I)Landroid/telephony/data/ThrottleStatus$Builder;

    move-result-object p0

    .line 1372
    invoke-virtual {p0}, Landroid/telephony/data/ThrottleStatus$Builder;->build()Landroid/telephony/data/ThrottleStatus;

    move-result-object p0

    return-object p0
.end method

.method private static synthetic lambda$updateThrottleStatus$12(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Ljava/util/List;)V
    .locals 0

    .line 1377
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;->onThrottleStatusChanged(Ljava/util/List;)V

    return-void
.end method

.method private static synthetic lambda$updateThrottleStatus$13(Ljava/util/List;Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 1

    .line 1376
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda11;

    invoke-direct {v0, p1, p0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda11;-><init>(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;Ljava/util/List;)V

    invoke-virtual {p1, v0}, Lcom/android/internal/telephony/data/DataCallback;->invokeFromExecutor(Ljava/lang/Runnable;)V

    return-void
.end method

.method private onCancelPendingHandoverRetry(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 2

    .line 1574
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    new-instance v1, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda1;

    invoke-direct {v1, p1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda1;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    invoke-interface {v0, v1}, Ljava/util/List;->removeIf(Ljava/util/function/Predicate;)Z

    .line 1576
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda2;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda2;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    invoke-interface {p0, v0}, Ljava/util/List;->removeIf(Ljava/util/function/Predicate;)Z

    return-void
.end method

.method private onDataConfigUpdated()V
    .locals 2

    const/4 v0, 0x5

    .line 1021
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataRetryManager;->onReset(I)V

    .line 1022
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getDataSetupRetryRules()Ljava/util/List;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataSetupRetryRuleList:Ljava/util/List;

    .line 1023
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataConfigManager:Lcom/android/internal/telephony/data/DataConfigManager;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/DataConfigManager;->getDataHandoverRetryRules()Ljava/util/List;

    move-result-object v0

    iput-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataHandoverRetryRuleList:Ljava/util/List;

    .line 1024
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataConfigUpdated: mDataSetupRetryRuleList="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataSetupRetryRuleList:Ljava/util/List;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", mDataHandoverRetryRuleList="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataHandoverRetryRuleList:Ljava/util/List;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    return-void
.end method

.method private onDataProfileUnthrottled(Landroid/telephony/data/DataProfile;Ljava/lang/String;IZ)V
    .locals 7

    .line 1392
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onDataProfileUnthrottled: data profile="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", apn="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", transport="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1393
    invoke-static {p3}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", remove="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1392
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    .line 1396
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    .line 1397
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    if-eqz p1, :cond_1

    .line 1404
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onDataProfileUnthrottled: dataProfile="

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    .line 1405
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p2

    .line 1406
    new-instance v2, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda12;

    invoke-direct {v2, v0, v1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda12;-><init>(J)V

    invoke-interface {p2, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p2

    .line 1407
    invoke-virtual {p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1408
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda13;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda13;-><init>()V

    .line 1409
    invoke-interface {p2, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda14;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda14;-><init>(Landroid/telephony/data/DataProfile;)V

    .line 1410
    invoke-interface {p2, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p2

    .line 1413
    :cond_0
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda15;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda15;-><init>(Landroid/telephony/data/DataProfile;)V

    invoke-interface {p2, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 1416
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object p2

    invoke-interface {p1, p2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    move-object v2, p1

    check-cast v2, Ljava/util/List;

    goto :goto_0

    :cond_1
    if-eqz p2, :cond_2

    .line 1419
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v2, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda16;

    invoke-direct {v2, v0, v1, p2, p3}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda16;-><init>(JLjava/lang/String;I)V

    .line 1420
    invoke-interface {p1, v2}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    .line 1424
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object p2

    invoke-interface {p1, p2}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p1

    move-object v2, p1

    check-cast v2, Ljava/util/List;

    .line 1427
    :cond_2
    :goto_0
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_3

    const-string p1, "onDataProfileUnthrottled: Nothing to unthrottle."

    .line 1428
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    return-void

    .line 1433
    :cond_3
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    const/4 p2, 0x0

    const/4 v0, 0x0

    .line 1436
    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;

    iget v1, v1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->retryType:I

    const/4 v3, 0x1

    const/4 v4, 0x3

    const/4 v5, 0x2

    if-ne v1, v5, :cond_4

    .line 1437
    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;

    iget-object p2, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    move v0, v5

    goto :goto_1

    .line 1439
    :cond_4
    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;

    iget v1, v1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->retryType:I

    if-ne v1, v4, :cond_5

    .line 1440
    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;

    iget-object p2, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataNetwork;->getDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object p2

    move v0, v4

    goto :goto_1

    :cond_5
    move v0, v3

    :goto_1
    if-eqz p2, :cond_6

    .line 1447
    invoke-virtual {p2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v1

    if-eqz v1, :cond_6

    .line 1448
    invoke-virtual {p2}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object p2

    invoke-virtual {p2}, Landroid/telephony/data/ApnSetting;->getApnTypes()Ljava/util/List;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p2

    new-instance v1, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda17;

    invoke-direct {v1, p0, v0, p3}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda17;-><init>(Lcom/android/internal/telephony/data/DataRetryManager;II)V

    .line 1449
    invoke-interface {p2, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p2

    .line 1456
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object p3

    invoke-interface {p2, p3}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/util/Collection;

    .line 1448
    invoke-interface {p1, p2}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1459
    :cond_6
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryManagerCallbacks:Ljava/util/Set;

    new-instance p3, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda18;

    invoke-direct {p3, p1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda18;-><init>(Ljava/util/List;)V

    invoke-interface {p2, p3}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    .line 1462
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "onDataProfileUnthrottled: Removing the following throttling entries. "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    .line 1464
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_7
    :goto_2
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_9

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;

    .line 1465
    iget p3, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->retryType:I

    const-wide/16 v0, 0x0

    if-ne p3, v5, :cond_8

    .line 1467
    new-instance p3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    invoke-direct {p3}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;-><init>()V

    iget-object v6, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    .line 1468
    invoke-virtual {p3, v6}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setDataProfile(Landroid/telephony/data/DataProfile;)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p3

    iget v6, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->transport:I

    .line 1469
    invoke-virtual {p3, v6}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setTransport(I)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p3

    .line 1470
    invoke-virtual {p3, v3}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setSetupRetryType(I)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p3

    iget-object p2, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    .line 1471
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setNetworkRequestList(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p2

    .line 1472
    invoke-virtual {p2, v0, v1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->setRetryDelay(J)Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    .line 1473
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->build()Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    move-result-object p2

    .line 1467
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataRetryManager;->schedule(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V

    goto :goto_2

    :cond_8
    if-ne p3, v4, :cond_7

    .line 1475
    new-instance p3, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    invoke-direct {p3}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;-><init>()V

    iget-object p2, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataNetwork:Lcom/android/internal/telephony/data/DataNetwork;

    .line 1476
    invoke-virtual {p3, p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;->setDataNetwork(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    move-result-object p2

    .line 1477
    invoke-virtual {p2, v0, v1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->setRetryDelay(J)Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    .line 1478
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;->build()Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    move-result-object p2

    .line 1475
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataRetryManager;->schedule(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V

    goto :goto_2

    :cond_9
    if-eqz p4, :cond_a

    .line 1482
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    invoke-interface {p0, v2}, Ljava/util/List;->removeAll(Ljava/util/Collection;)Z

    :cond_a
    return-void
.end method

.method private onEvaluateDataHandoverRetry(Lcom/android/internal/telephony/data/DataNetwork;IJ)V
    .locals 9

    .line 1161
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onEvaluateDataHandoverRetry: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", cause="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1162
    invoke-static {p2}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", retryDelayMillis="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "ms"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1161
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    .line 1163
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getTransport()I

    move-result v0

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataUtils;->getTargetTransport(I)I

    move-result v6

    const-wide v0, 0x7fffffffffffffffL

    cmp-long v0, p3, v0

    if-eqz v0, :cond_5

    const-wide/32 v0, 0x7fffffff

    cmp-long v0, p3, v0

    if-nez v0, :cond_0

    goto/16 :goto_1

    :cond_0
    const-wide/16 v0, -0x1

    cmp-long v0, p3, v0

    if-eqz v0, :cond_1

    .line 1175
    new-instance p2, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    invoke-direct {p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;-><init>()V

    .line 1176
    invoke-virtual {p2, p3, p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->setRetryDelay(J)Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;

    move-result-object p2

    check-cast p2, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    .line 1177
    invoke-virtual {p2, p1}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;->setDataNetwork(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    move-result-object p2

    .line 1178
    invoke-virtual {p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;->build()Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    move-result-object p2

    .line 1180
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v2

    .line 1181
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getAttachedNetworkRequestList()Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    move-result-object v3

    const/4 v5, 0x3

    iget-wide v7, p2, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->retryElapsedTime:J

    move-object v1, p0

    move-object v4, p1

    .line 1180
    invoke-direct/range {v1 .. v8}, Lcom/android/internal/telephony/data/DataRetryManager;->updateThrottleStatus(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetwork;IIJ)V

    .line 1184
    invoke-direct {p0, p2}, Lcom/android/internal/telephony/data/DataRetryManager;->schedule(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V

    goto/16 :goto_2

    .line 1189
    :cond_1
    iget-object p3, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataHandoverRetryRuleList:Ljava/util/List;

    invoke-interface {p3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p3

    :cond_2
    :goto_0
    invoke-interface {p3}, Ljava/util/Iterator;->hasNext()Z

    move-result p4

    if-eqz p4, :cond_6

    invoke-interface {p3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p4

    check-cast p4, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;

    .line 1190
    invoke-virtual {p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;->getFailCauses()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_3

    .line 1191
    invoke-virtual {p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;->getFailCauses()Ljava/util/Set;

    move-result-object v0

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1192
    :cond_3
    invoke-direct {p0, p1, p4}, Lcom/android/internal/telephony/data/DataRetryManager;->getRetryFailedCount(Lcom/android/internal/telephony/data/DataNetwork;Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryRule;)I

    move-result v0

    .line 1193
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Found matching rule "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v2, ", failed count="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    .line 1194
    invoke-virtual {p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;->getMaxRetries()I

    move-result v1

    if-ne v0, v1, :cond_4

    .line 1195
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Data handover retry failed for "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p3, " times. Stopped handover retry."

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    .line 1197
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryManagerCallbacks:Ljava/util/Set;

    new-instance p2, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda26;

    invoke-direct {p2, p1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda26;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    invoke-interface {p0, p2}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void

    .line 1202
    :cond_4
    invoke-virtual {p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;->getRetryIntervalsMillis()Ljava/util/List;

    move-result-object v1

    .line 1204
    invoke-virtual {p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;->getRetryIntervalsMillis()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    add-int/lit8 v2, v2, -0x1

    .line 1203
    invoke-static {v0, v2}, Ljava/lang/Math;->min(II)I

    move-result v0

    .line 1202
    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    .line 1205
    new-instance v2, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    invoke-direct {v2}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;-><init>()V

    .line 1206
    invoke-virtual {v2, v0, v1}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->setRetryDelay(J)Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    .line 1207
    invoke-virtual {v0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;->setDataNetwork(Lcom/android/internal/telephony/data/DataNetwork;)Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    move-result-object v0

    .line 1208
    invoke-virtual {v0, p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->setAppliedRetryRule(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;)Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;

    move-result-object p4

    check-cast p4, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;

    .line 1209
    invoke-virtual {p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry$Builder;->build()Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    move-result-object p4

    .line 1205
    invoke-direct {p0, p4}, Lcom/android/internal/telephony/data/DataRetryManager;->schedule(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V

    goto/16 :goto_0

    .line 1165
    :cond_5
    :goto_1
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Network suggested never retry handover for "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p2}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    .line 1170
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getDataProfile()Landroid/telephony/data/DataProfile;

    move-result-object v2

    .line 1171
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/DataNetwork;->getAttachedNetworkRequestList()Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    move-result-object v3

    const/4 v5, 0x3

    const-wide v7, 0x7fffffffffffffffL

    move-object v1, p0

    move-object v4, p1

    .line 1170
    invoke-direct/range {v1 .. v8}, Lcom/android/internal/telephony/data/DataRetryManager;->updateThrottleStatus(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetwork;IIJ)V

    :cond_6
    :goto_2
    return-void
.end method

.method private onEvaluateDataSetupRetry(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V
    .locals 8

    .line 1051
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "onEvaluateDataSetupRetry: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, ", transport="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1052
    invoke-static {p2}, Landroid/telephony/AccessNetworkConstants;->transportTypeToString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", cause="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1053
    invoke-static {p4}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", retryDelayMillis="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p5, p6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, "ms, "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1051
    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    const-wide v0, 0x7fffffffffffffffL

    cmp-long v0, p5, v0

    if-eqz v0, :cond_8

    const-wide/32 v0, 0x7fffffff

    cmp-long v0, p5, v0

    if-nez v0, :cond_0

    goto/16 :goto_1

    :cond_0
    const-wide/16 v0, -0x1

    cmp-long v0, p5, v0

    const/4 v1, 0x1

    if-eqz v0, :cond_1

    .line 1068
    new-instance p4, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    invoke-direct {p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;-><init>()V

    .line 1069
    invoke-virtual {p4, p5, p6}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->setRetryDelay(J)Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;

    move-result-object p4

    check-cast p4, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    .line 1070
    invoke-virtual {p4, v1}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setSetupRetryType(I)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p4

    .line 1071
    invoke-virtual {p4, p3}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setNetworkRequestList(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p4

    .line 1072
    invoke-virtual {p4, p1}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setDataProfile(Landroid/telephony/data/DataProfile;)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p4

    .line 1073
    invoke-virtual {p4, p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setTransport(I)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p4

    .line 1074
    invoke-virtual {p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->build()Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    move-result-object p4

    const/4 v3, 0x0

    const/4 v4, 0x2

    .line 1075
    iget-wide v6, p4, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->retryElapsedTime:J

    move-object v0, p0

    move-object v1, p1

    move-object v2, p3

    move v5, p2

    invoke-direct/range {v0 .. v7}, Lcom/android/internal/telephony/data/DataRetryManager;->updateThrottleStatus(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetwork;IIJ)V

    .line 1078
    invoke-direct {p0, p4}, Lcom/android/internal/telephony/data/DataRetryManager;->schedule(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V

    goto/16 :goto_2

    .line 1081
    :cond_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p5, "mDataSetupRetryRuleList="

    invoke-virtual {p1, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p5, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataSetupRetryRuleList:Ljava/util/List;

    invoke-virtual {p1, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->logv(Ljava/lang/String;)V

    .line 1084
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p1}, Lcom/android/internal/telephony/Phone;->getContext()Landroid/content/Context;

    move-result-object p1

    iget-object p5, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {p5}, Lcom/android/internal/telephony/Phone;->getSubId()I

    move-result p5

    invoke-static {p1, p4, p5}, Landroid/telephony/DataFailCause;->isPermanentFailure(Landroid/content/Context;II)Z

    move-result p1

    if-eqz p1, :cond_2

    .line 1085
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "Stopped timer-based retry. cause="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p4}, Landroid/telephony/DataFailCause;->toString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    return-void

    .line 1091
    :cond_2
    invoke-static {p3}, Lcom/android/internal/telephony/data/DataUtils;->getGroupedNetworkRequestList(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Ljava/util/List;

    move-result-object p1

    .line 1092
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    const/4 p3, 0x0

    move p5, p3

    :cond_3
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p6

    if-eqz p6, :cond_7

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p6

    check-cast p6, Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    .line 1093
    invoke-virtual {p6, p3}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {v0}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result v0

    .line 1095
    iget-object v2, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataSetupRetryRuleList:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_4
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_3

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;

    .line 1096
    invoke-virtual {v3, v0, p4}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;->canBeMatched(II)Z

    move-result v4

    if-eqz v4, :cond_4

    .line 1099
    invoke-virtual {p6, p3}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object p5

    check-cast p5, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    .line 1098
    invoke-virtual {p0, p5, p2}, Lcom/android/internal/telephony/data/DataRetryManager;->isSimilarNetworkRequestRetryScheduled(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z

    move-result p5

    if-eqz p5, :cond_5

    .line 1100
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p6, p3}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p2, " already had similar retry scheduled."

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    return-void

    .line 1105
    :cond_5
    invoke-direct {p0, v0, v3}, Lcom/android/internal/telephony/data/DataRetryManager;->getRetryFailedCount(ILcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryRule;)I

    move-result p5

    .line 1106
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "For capability "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", found matching rule "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, ", failed count="

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    .line 1109
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;->getMaxRetries()I

    move-result v2

    if-ne p5, v2, :cond_6

    .line 1110
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "Data retry failed for "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, " times. Stopped timer-based data retry for "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1112
    invoke-static {v0}, Lcom/android/internal/telephony/data/DataUtils;->networkCapabilityToString(I)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, ". Condition-based retry will still happen when condition changes."

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 1110
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    return-void

    .line 1118
    :cond_6
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;->getRetryIntervalsMillis()Ljava/util/List;

    move-result-object v0

    .line 1120
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;->getRetryIntervalsMillis()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    sub-int/2addr v2, v1

    .line 1119
    invoke-static {p5, v2}, Ljava/lang/Math;->min(II)I

    move-result p5

    .line 1118
    invoke-interface {v0, p5}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p5

    check-cast p5, Ljava/lang/Long;

    invoke-virtual {p5}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    .line 1123
    new-instance p5, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    invoke-direct {p5}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;-><init>()V

    .line 1124
    invoke-virtual {p5, v4, v5}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->setRetryDelay(J)Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;

    move-result-object p5

    check-cast p5, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    .line 1125
    invoke-virtual {p5, v3}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;->setAppliedRetryRule(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryRule;)Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry$Builder;

    move-result-object p5

    check-cast p5, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    const/4 v0, 0x2

    .line 1126
    invoke-virtual {p5, v0}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setSetupRetryType(I)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p5

    .line 1127
    invoke-virtual {p5, p2}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setTransport(I)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p5

    .line 1128
    invoke-virtual {p5, p6}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->setNetworkRequestList(Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;)Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;

    move-result-object p5

    .line 1129
    invoke-virtual {p5}, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry$Builder;->build()Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    move-result-object p5

    .line 1123
    invoke-direct {p0, p5}, Lcom/android/internal/telephony/data/DataRetryManager;->schedule(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V

    move p5, v1

    goto/16 :goto_0

    :cond_7
    if-nez p5, :cond_9

    const-string p1, "onEvaluateDataSetupRetry: Did not match any retry rule. Stop timer-based retry."

    .line 1137
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    goto :goto_2

    .line 1059
    :cond_8
    :goto_1
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string p5, "Network suggested never retry for "

    invoke-virtual {p4, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p4

    invoke-virtual {p0, p4}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    const/4 v3, 0x0

    const/4 v4, 0x2

    const-wide v6, 0x7fffffffffffffffL

    move-object v0, p0

    move-object v1, p1

    move-object v2, p3

    move v5, p2

    .line 1064
    invoke-direct/range {v0 .. v7}, Lcom/android/internal/telephony/data/DataRetryManager;->updateThrottleStatus(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetwork;IIJ)V

    :cond_9
    :goto_2
    return-void
.end method

.method private static resetReasonToString(I)Ljava/lang/String;
    .locals 2

    packed-switch p0, :pswitch_data_0

    .line 1632
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "UNKNOWN("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :pswitch_0
    const-string p0, "TAC_CHANGED"

    return-object p0

    :pswitch_1
    const-string p0, "DATA_CONFIG_CHANGED"

    return-object p0

    :pswitch_2
    const-string p0, "DATA_SERVICE_BOUND"

    return-object p0

    :pswitch_3
    const-string p0, "MODEM_RESTART"

    return-object p0

    :pswitch_4
    const-string p0, "RADIO_ON"

    return-object p0

    :pswitch_5
    const-string p0, "DATA_PROFILES_CHANGED"

    return-object p0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private schedule(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;)V
    .locals 3

    .line 1310
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Scheduled data retry: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    .line 1311
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1312
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/16 v1, 0x64

    if-lt v0, v1, :cond_0

    .line 1314
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    const/4 v1, 0x0

    invoke-interface {v0, v1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 1321
    :cond_0
    instance-of v0, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    if-eqz v0, :cond_1

    const/4 v0, 0x3

    goto :goto_0

    :cond_1
    const/4 v0, 0x4

    :goto_0
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object v0

    iget-wide v1, p1, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->retryDelayMillis:J

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->sendMessageDelayed(Landroid/os/Message;J)Z

    return-void
.end method

.method private updateThrottleStatus(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetwork;IIJ)V
    .locals 15
    .param p4    # I
        .annotation build Landroid/telephony/data/ThrottleStatus$RetryType;
        .end annotation
    .end param

    move-object v6, p0

    .line 1344
    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;

    move-object v7, v0

    move-object/from16 v8, p1

    move-object/from16 v9, p2

    move-object/from16 v10, p3

    move/from16 v11, p5

    move/from16 v12, p4

    move-wide/from16 v13, p6

    invoke-direct/range {v7 .. v14}, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;-><init>(Landroid/telephony/data/DataProfile;Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;Lcom/android/internal/telephony/data/DataNetwork;IIJ)V

    .line 1346
    iget-object v1, v6, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    const/16 v2, 0x64

    if-lt v1, v2, :cond_0

    .line 1347
    iget-object v1, v6, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    const/4 v2, 0x0

    invoke-interface {v1, v2}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 1351
    :cond_0
    iget-object v1, v6, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    new-instance v2, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda19;

    move-object/from16 v3, p1

    invoke-direct {v2, v3}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda19;-><init>(Landroid/telephony/data/DataProfile;)V

    invoke-interface {v1, v2}, Ljava/util/List;->removeIf(Ljava/util/function/Predicate;)Z

    .line 1355
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Add throttling entry "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0, v1}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    .line 1356
    iget-object v1, v6, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    const-wide v0, 0x7fffffffffffffffL

    cmp-long v0, p6, v0

    if-nez v0, :cond_1

    const/4 v0, 0x1

    move v2, v0

    goto :goto_0

    :cond_1
    move/from16 v2, p4

    .line 1363
    :goto_0
    new-instance v7, Ljava/util/ArrayList;

    invoke-direct {v7}, Ljava/util/ArrayList;-><init>()V

    .line 1364
    invoke-virtual/range {p1 .. p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 1365
    invoke-virtual/range {p1 .. p1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v0

    invoke-virtual {v0}, Landroid/telephony/data/ApnSetting;->getApnTypes()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object v8

    new-instance v9, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;

    move-object v0, v9

    move-object v1, p0

    move-wide/from16 v3, p6

    move/from16 v5, p5

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda20;-><init>(Lcom/android/internal/telephony/data/DataRetryManager;IJI)V

    .line 1366
    invoke-interface {v8, v9}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object v0

    .line 1373
    invoke-static {}, Ljava/util/stream/Collectors;->toList()Ljava/util/stream/Collector;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/stream/Stream;->collect(Ljava/util/stream/Collector;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Collection;

    .line 1365
    invoke-interface {v7, v0}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 1376
    :cond_2
    iget-object v0, v6, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryManagerCallbacks:Ljava/util/Set;

    new-instance v1, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda21;

    invoke-direct {v1, v7}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda21;-><init>(Ljava/util/List;)V

    invoke-interface {v0, v1}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    return-void
.end method


# virtual methods
.method public cancelPendingHandoverRetry(Lcom/android/internal/telephony/data/DataNetwork;)V
    .locals 1

    const/4 v0, 0x7

    .line 1565
    invoke-virtual {p0, v0, p1}, Landroid/os/Handler;->obtainMessage(ILjava/lang/Object;)Landroid/os/Message;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    return-void
.end method

.method public dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V
    .locals 2

    .line 1677
    new-instance v0, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string v1, "  "

    invoke-direct {v0, p2, v1}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;-><init>(Ljava/io/Writer;Ljava/lang/String;)V

    .line 1678
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-class v1, Lcom/android/internal/telephony/data/DataRetryManager;

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "-"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    invoke-virtual {v1}, Lcom/android/internal/telephony/Phone;->getPhoneId()I

    move-result v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ":"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1679
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Data Setup Retry rules:"

    .line 1680
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1681
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1682
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataSetupRetryRuleList:Ljava/util/List;

    new-instance v1, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda4;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda4;-><init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V

    invoke-interface {p2, v1}, Ljava/util/List;->forEach(Ljava/util/function/Consumer;)V

    .line 1683
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Data Handover Retry rules:"

    .line 1684
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1685
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1686
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataHandoverRetryRuleList:Ljava/util/List;

    new-instance v1, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda5;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/data/DataConfigManager$$ExternalSyntheticLambda5;-><init>(Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;)V

    invoke-interface {p2, v1}, Ljava/util/List;->forEach(Ljava/util/function/Consumer;)V

    .line 1687
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Retry entries:"

    .line 1689
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1690
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1691
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_0
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;

    .line 1692
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/Object;)V

    goto :goto_0

    .line 1694
    :cond_0
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Throttling entries:"

    .line 1696
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1697
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1698
    iget-object p2, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p2

    :goto_1
    invoke-interface {p2}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;

    .line 1699
    invoke-virtual {v0, v1}, Ljava/io/PrintWriter;->println(Ljava/lang/Object;)V

    goto :goto_1

    .line 1701
    :cond_1
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    const-string p2, "Local logs:"

    .line 1703
    invoke-virtual {v0, p2}, Ljava/io/PrintWriter;->println(Ljava/lang/String;)V

    .line 1704
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->increaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1705
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1, v0, p3}, Lcom/android/internal/telephony/LocalLog;->dump(Ljava/io/FileDescriptor;Ljava/io/PrintWriter;[Ljava/lang/String;)V

    .line 1706
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    .line 1707
    invoke-virtual {v0}, Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;->decreaseIndent()Lcom/android/internal/telephony/AndroidUtilIndentingPrintWriter;

    return-void
.end method

.method public evaluateDataHandoverRetry(Lcom/android/internal/telephony/data/DataNetwork;IJ)V
    .locals 7

    .line 1156
    new-instance v6, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda3;

    move-object v0, v6

    move-object v1, p0

    move-object v2, p1

    move v3, p2

    move-wide v4, p3

    invoke-direct/range {v0 .. v5}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda3;-><init>(Lcom/android/internal/telephony/data/DataRetryManager;Lcom/android/internal/telephony/data/DataNetwork;IJ)V

    invoke-virtual {p0, v6}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public evaluateDataSetupRetry(Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V
    .locals 9

    .line 1044
    new-instance v8, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda10;

    move-object v0, v8

    move-object v1, p0

    move-object v2, p1

    move v3, p2

    move-object v4, p3

    move v5, p4

    move-wide v6, p5

    invoke-direct/range {v0 .. v7}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda10;-><init>(Lcom/android/internal/telephony/data/DataRetryManager;Landroid/telephony/data/DataProfile;ILcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;IJ)V

    invoke-virtual {p0, v8}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public handleMessage(Landroid/os/Message;)V
    .locals 4

    .line 967
    iget v0, p1, Landroid/os/Message;->what:I

    packed-switch v0, :pswitch_data_0

    .line 1013
    :pswitch_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Unexpected message "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget p1, p1, Landroid/os/Message;->what:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->loge(Ljava/lang/String;)V

    goto/16 :goto_1

    :pswitch_1
    const/4 p1, 0x6

    .line 994
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->onReset(I)V

    goto/16 :goto_1

    :pswitch_2
    const/4 p1, 0x3

    .line 991
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->onReset(I)V

    goto/16 :goto_1

    :pswitch_3
    const/4 p1, 0x2

    .line 988
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->onReset(I)V

    goto/16 :goto_1

    .line 1010
    :pswitch_4
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/DataNetwork;

    invoke-direct {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->onCancelPendingHandoverRetry(Lcom/android/internal/telephony/data/DataNetwork;)V

    goto/16 :goto_1

    .line 997
    :pswitch_5
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Landroid/os/AsyncResult;

    .line 998
    iget-object v0, p1, Landroid/os/AsyncResult;->userObj:Ljava/lang/Object;

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 1002
    iget-object p1, p1, Landroid/os/AsyncResult;->result:Ljava/lang/Object;

    instance-of v1, p1, Ljava/lang/String;

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    .line 1003
    check-cast p1, Ljava/lang/String;

    goto :goto_0

    .line 1004
    :cond_0
    instance-of v1, p1, Landroid/telephony/data/DataProfile;

    if-eqz v1, :cond_1

    .line 1005
    check-cast p1, Landroid/telephony/data/DataProfile;

    move-object v3, v2

    move-object v2, p1

    move-object p1, v3

    goto :goto_0

    :cond_1
    move-object p1, v2

    :goto_0
    const/4 v1, 0x1

    .line 1007
    invoke-direct {p0, v2, p1, v0, v1}, Lcom/android/internal/telephony/data/DataRetryManager;->onDataProfileUnthrottled(Landroid/telephony/data/DataProfile;Ljava/lang/String;IZ)V

    goto :goto_1

    .line 978
    :pswitch_6
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    .line 979
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 980
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 981
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryManagerCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda30;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda30;-><init>(Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    goto :goto_1

    .line 984
    :cond_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Handover was cancelled earlier. "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    goto :goto_1

    .line 972
    :pswitch_7
    iget-object p1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast p1, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    .line 973
    invoke-static {p1}, Ljava/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;

    .line 974
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryManagerCallbacks:Ljava/util/Set;

    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda29;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda29;-><init>(Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;)V

    invoke-interface {p0, v0}, Ljava/util/Set;->forEach(Ljava/util/function/Consumer;)V

    goto :goto_1

    .line 969
    :pswitch_8
    invoke-direct {p0}, Lcom/android/internal/telephony/data/DataRetryManager;->onDataConfigUpdated()V

    :goto_1
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_8
        :pswitch_0
        :pswitch_7
        :pswitch_6
        :pswitch_0
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method public isAnyHandoverRetryScheduled(Lcom/android/internal/telephony/data/DataNetwork;)Z
    .locals 2

    .line 1586
    const-class v0, Lcom/android/internal/telephony/data/DataRetryManager$DataHandoverRetryEntry;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    .line 1587
    new-instance v1, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda6;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda6;-><init>(Ljava/lang/Class;)V

    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 1588
    new-instance v1, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda24;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda24;-><init>(Ljava/lang/Class;)V

    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda25;

    invoke-direct {v0, p1}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda25;-><init>(Lcom/android/internal/telephony/data/DataNetwork;)V

    .line 1589
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0
.end method

.method public isAnySetupRetryScheduled(Landroid/telephony/data/DataProfile;I)Z
    .locals 2

    .line 1536
    const-class v0, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    .line 1537
    new-instance v1, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda6;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda6;-><init>(Ljava/lang/Class;)V

    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p0

    .line 1538
    new-instance v1, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda7;

    invoke-direct {v1, v0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda7;-><init>(Ljava/lang/Class;)V

    invoke-interface {p0, v1}, Ljava/util/stream/Stream;->map(Ljava/util/function/Function;)Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda8;

    invoke-direct {v0, p1, p2}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda8;-><init>(Landroid/telephony/data/DataProfile;I)V

    .line 1539
    invoke-interface {p0, v0}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0
.end method

.method public isDataProfileThrottled(Landroid/telephony/data/DataProfile;I)Z
    .locals 3

    .line 1553
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    .line 1554
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p0

    new-instance v2, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda23;

    invoke-direct {v2, p1, v0, v1, p2}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda23;-><init>(Landroid/telephony/data/DataProfile;JI)V

    invoke-interface {p0, v2}, Ljava/util/stream/Stream;->anyMatch(Ljava/util/function/Predicate;)Z

    move-result p0

    return p0
.end method

.method public isSimilarNetworkRequestRetryScheduled(Lcom/android/internal/telephony/data/TelephonyNetworkRequest;I)Z
    .locals 6

    .line 1496
    iget-object v0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    :goto_0
    const/4 v2, 0x0

    if-ltz v0, :cond_3

    .line 1497
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v3, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    instance-of v3, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    if-eqz v3, :cond_2

    .line 1498
    iget-object v3, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {v3, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;

    .line 1500
    iget-object v4, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v4}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_0

    goto :goto_1

    .line 1503
    :cond_0
    invoke-virtual {v3}, Lcom/android/internal/telephony/data/DataRetryManager$DataRetryEntry;->getState()I

    move-result v4

    if-ne v4, v1, :cond_2

    iget v4, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->setupRetryType:I

    const/4 v5, 0x2

    if-ne v4, v5, :cond_2

    .line 1506
    iget-object v4, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v4}, Ljava/util/LinkedList;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_1

    const-string v2, "Invalid data retry entry detected"

    .line 1508
    invoke-virtual {p0, v2}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    .line 1509
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "mDataRetryEntries="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p0, v3}, Lcom/android/internal/telephony/data/DataRetryManager;->loge(Ljava/lang/String;)V

    const-string v3, "781af571-f55d-476d-b510-7a5381f633dc"

    .line 1511
    invoke-static {v3}, Ljava/util/UUID;->fromString(Ljava/lang/String;)Ljava/util/UUID;

    move-result-object v3

    iget-object v4, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mPhone:Lcom/android/internal/telephony/Phone;

    .line 1513
    invoke-virtual {v4}, Lcom/android/internal/telephony/Phone;->getCarrierId()I

    move-result v4

    .line 1510
    invoke-static {v3, v2, v4}, Landroid/telephony/AnomalyReporter;->reportAnomaly(Ljava/util/UUID;Ljava/lang/String;I)V

    goto :goto_1

    .line 1516
    :cond_1
    iget-object v4, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->networkRequestList:Lcom/android/internal/telephony/data/DataNetworkController$NetworkRequestList;

    invoke-virtual {v4, v2}, Ljava/util/LinkedList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;

    invoke-virtual {v2}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result v2

    .line 1517
    invoke-virtual {p1}, Lcom/android/internal/telephony/data/TelephonyNetworkRequest;->getApnTypeNetworkCapability()I

    move-result v4

    if-ne v2, v4, :cond_2

    iget v2, v3, Lcom/android/internal/telephony/data/DataRetryManager$DataSetupRetryEntry;->transport:I

    if-ne v2, p2, :cond_2

    return v1

    :cond_2
    :goto_1
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    :cond_3
    return v2
.end method

.method protected log(Ljava/lang/String;)V
    .locals 0

    .line 1641
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected loge(Ljava/lang/String;)V
    .locals 0

    .line 1649
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mLogTag:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/android/telephony/Rlog;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method protected logl(Ljava/lang/String;)V
    .locals 0

    .line 1665
    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->log(Ljava/lang/String;)V

    .line 1666
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mLocalLog:Lcom/android/internal/telephony/LocalLog;

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/LocalLog;->log(Ljava/lang/String;)V

    return-void
.end method

.method protected logv(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method public onReset(I)V
    .locals 4
    .param p1    # I
        .annotation build Lcom/android/internal/telephony/data/DataRetryManager$RetryResetReason;
        .end annotation
    .end param

    .line 1217
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Remove all retry and throttling entries, reason="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/android/internal/telephony/data/DataRetryManager;->resetReasonToString(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Lcom/android/internal/telephony/data/DataRetryManager;->logl(Ljava/lang/String;)V

    const/4 p1, 0x3

    .line 1218
    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeMessages(I)V

    const/4 p1, 0x4

    .line 1219
    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeMessages(I)V

    .line 1220
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryEntries:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->stream()Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda4;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda4;-><init>()V

    .line 1221
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->filter(Ljava/util/function/Predicate;)Ljava/util/stream/Stream;

    move-result-object p1

    new-instance v0, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda5;

    invoke-direct {v0}, Lcom/android/internal/telephony/data/DataRetryManager$$ExternalSyntheticLambda5;-><init>()V

    .line 1222
    invoke-interface {p1, v0}, Ljava/util/stream/Stream;->forEach(Ljava/util/function/Consumer;)V

    .line 1223
    iget-object p1, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;

    .line 1224
    iget-object v1, v0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->dataProfile:Landroid/telephony/data/DataProfile;

    .line 1225
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    if-eqz v2, :cond_0

    .line 1226
    invoke-virtual {v1}, Landroid/telephony/data/DataProfile;->getApnSetting()Landroid/telephony/data/ApnSetting;

    move-result-object v2

    invoke-virtual {v2}, Landroid/telephony/data/ApnSetting;->getApnName()Ljava/lang/String;

    move-result-object v2

    goto :goto_1

    :cond_0
    const/4 v2, 0x0

    .line 1227
    :goto_1
    iget v0, v0, Lcom/android/internal/telephony/data/DataRetryManager$DataThrottlingEntry;->transport:I

    const/4 v3, 0x0

    invoke-direct {p0, v1, v2, v0, v3}, Lcom/android/internal/telephony/data/DataRetryManager;->onDataProfileUnthrottled(Landroid/telephony/data/DataProfile;Ljava/lang/String;IZ)V

    goto :goto_0

    .line 1229
    :cond_1
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataThrottlingEntries:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->clear()V

    return-void
.end method

.method public registerCallback(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 0

    .line 1599
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryManagerCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public unregisterCallback(Lcom/android/internal/telephony/data/DataRetryManager$DataRetryManagerCallback;)V
    .locals 0

    .line 1608
    iget-object p0, p0, Lcom/android/internal/telephony/data/DataRetryManager;->mDataRetryManagerCallbacks:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    return-void
.end method
