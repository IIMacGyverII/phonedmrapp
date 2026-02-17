.class public final enum Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;
.super Ljava/lang/Enum;
.source "DataEvaluation.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataEvaluation;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "DataDisallowedReason"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum CDMA_EMERGENCY_CALLBACK_MODE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum CONCURRENT_VOICE_DATA_NOT_ALLOWED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DATA_CONFIG_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DATA_DISABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DATA_NETWORK_TYPE_NOT_ALLOWED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DATA_PROFILE_INVALID:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DATA_PROFILE_NOT_PREFERRED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DATA_RESTRICTED_BY_NETWORK:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DATA_SERVICE_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DATA_SETTINGS_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DATA_THROTTLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum DEFAULT_DATA_UNSELECTED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum ILLEGAL_STATE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum MTK_FDN_ENABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum NOT_ALLOWED_BY_POLICY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum NOT_IN_SERVICE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum NO_SUITABLE_DATA_PROFILE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum ONLY_ALLOWED_SINGLE_NETWORK:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum PENDING_TEAR_DOWN_ALL:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum RADIO_DISABLED_BY_CARRIER:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum RADIO_POWER_OFF:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum RETRY_SCHEDULED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum ROAMING_DISABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum SIM_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

.field public static final enum VOPS_NOT_SUPPORTED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;


# instance fields
.field private final mIsHardReason:Z


# direct methods
.method static constructor <clinit>()V
    .locals 28

    .line 249
    new-instance v0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v1, "DATA_DISABLED"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2, v2}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_DISABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 251
    new-instance v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v3, "ROAMING_DISABLED"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4, v2}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ROAMING_DISABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 253
    new-instance v3, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v5, "DEFAULT_DATA_UNSELECTED"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6, v2}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v3, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DEFAULT_DATA_UNSELECTED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 258
    new-instance v5, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v7, "MTK_FDN_ENABLED"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v5, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->MTK_FDN_ENABLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 260
    new-instance v7, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v9, "NOT_IN_SERVICE"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v7, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->NOT_IN_SERVICE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 262
    new-instance v9, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v11, "DATA_CONFIG_NOT_READY"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v9, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_CONFIG_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 264
    new-instance v11, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v13, "SIM_NOT_READY"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v11, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->SIM_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 266
    new-instance v13, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v15, "CONCURRENT_VOICE_DATA_NOT_ALLOWED"

    const/4 v14, 0x7

    invoke-direct {v13, v15, v14, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v13, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->CONCURRENT_VOICE_DATA_NOT_ALLOWED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 268
    new-instance v15, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v14, "DATA_RESTRICTED_BY_NETWORK"

    const/16 v12, 0x8

    invoke-direct {v15, v14, v12, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v15, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_RESTRICTED_BY_NETWORK:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 270
    new-instance v14, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v12, "RADIO_POWER_OFF"

    const/16 v10, 0x9

    invoke-direct {v14, v12, v10, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v14, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->RADIO_POWER_OFF:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 272
    new-instance v12, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v10, "PENDING_TEAR_DOWN_ALL"

    const/16 v8, 0xa

    invoke-direct {v12, v10, v8, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v12, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->PENDING_TEAR_DOWN_ALL:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 274
    new-instance v10, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v8, "RADIO_DISABLED_BY_CARRIER"

    const/16 v6, 0xb

    invoke-direct {v10, v8, v6, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v10, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->RADIO_DISABLED_BY_CARRIER:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 276
    new-instance v8, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v6, "DATA_SERVICE_NOT_READY"

    const/16 v2, 0xc

    invoke-direct {v8, v6, v2, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v8, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_SERVICE_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 278
    new-instance v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v2, "NO_SUITABLE_DATA_PROFILE"

    move-object/from16 v16, v8

    const/16 v8, 0xd

    invoke-direct {v6, v2, v8, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->NO_SUITABLE_DATA_PROFILE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 280
    new-instance v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v8, "DATA_NETWORK_TYPE_NOT_ALLOWED"

    move-object/from16 v17, v6

    const/16 v6, 0xe

    invoke-direct {v2, v8, v6, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_NETWORK_TYPE_NOT_ALLOWED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 282
    new-instance v8, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v6, "CDMA_EMERGENCY_CALLBACK_MODE"

    move-object/from16 v18, v2

    const/16 v2, 0xf

    invoke-direct {v8, v6, v2, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v8, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->CDMA_EMERGENCY_CALLBACK_MODE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 284
    new-instance v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v2, "RETRY_SCHEDULED"

    move-object/from16 v19, v8

    const/16 v8, 0x10

    invoke-direct {v6, v2, v8, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->RETRY_SCHEDULED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 286
    new-instance v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v8, "DATA_THROTTLED"

    move-object/from16 v20, v6

    const/16 v6, 0x11

    invoke-direct {v2, v8, v6, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_THROTTLED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 288
    new-instance v8, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v6, "DATA_PROFILE_INVALID"

    move-object/from16 v21, v2

    const/16 v2, 0x12

    invoke-direct {v8, v6, v2, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v8, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_PROFILE_INVALID:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 290
    new-instance v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v2, "DATA_PROFILE_NOT_PREFERRED"

    move-object/from16 v22, v8

    const/16 v8, 0x13

    invoke-direct {v6, v2, v8, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_PROFILE_NOT_PREFERRED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 292
    new-instance v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v8, "NOT_ALLOWED_BY_POLICY"

    move-object/from16 v23, v6

    const/16 v6, 0x14

    invoke-direct {v2, v8, v6, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->NOT_ALLOWED_BY_POLICY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 294
    new-instance v8, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v6, "ILLEGAL_STATE"

    move-object/from16 v24, v2

    const/16 v2, 0x15

    invoke-direct {v8, v6, v2, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v8, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ILLEGAL_STATE:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 296
    new-instance v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v2, "VOPS_NOT_SUPPORTED"

    move-object/from16 v25, v8

    const/16 v8, 0x16

    invoke-direct {v6, v2, v8, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->VOPS_NOT_SUPPORTED:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 298
    new-instance v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v8, "ONLY_ALLOWED_SINGLE_NETWORK"

    move-object/from16 v26, v6

    const/16 v6, 0x17

    invoke-direct {v2, v8, v6, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->ONLY_ALLOWED_SINGLE_NETWORK:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    .line 300
    new-instance v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const-string v8, "DATA_SETTINGS_NOT_READY"

    move-object/from16 v27, v2

    const/16 v2, 0x18

    invoke-direct {v6, v8, v2, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;-><init>(Ljava/lang/String;IZ)V

    sput-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->DATA_SETTINGS_NOT_READY:Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const/16 v2, 0x19

    new-array v2, v2, [Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    const/4 v8, 0x0

    aput-object v0, v2, v8

    aput-object v1, v2, v4

    const/4 v0, 0x2

    aput-object v3, v2, v0

    const/4 v0, 0x3

    aput-object v5, v2, v0

    const/4 v0, 0x4

    aput-object v7, v2, v0

    const/4 v0, 0x5

    aput-object v9, v2, v0

    const/4 v0, 0x6

    aput-object v11, v2, v0

    const/4 v0, 0x7

    aput-object v13, v2, v0

    const/16 v0, 0x8

    aput-object v15, v2, v0

    const/16 v0, 0x9

    aput-object v14, v2, v0

    const/16 v0, 0xa

    aput-object v12, v2, v0

    const/16 v0, 0xb

    aput-object v10, v2, v0

    const/16 v0, 0xc

    aput-object v16, v2, v0

    const/16 v0, 0xd

    aput-object v17, v2, v0

    const/16 v0, 0xe

    aput-object v18, v2, v0

    const/16 v0, 0xf

    aput-object v19, v2, v0

    const/16 v0, 0x10

    aput-object v20, v2, v0

    const/16 v0, 0x11

    aput-object v21, v2, v0

    const/16 v0, 0x12

    aput-object v22, v2, v0

    const/16 v0, 0x13

    aput-object v23, v2, v0

    const/16 v0, 0x14

    aput-object v24, v2, v0

    const/16 v0, 0x15

    aput-object v25, v2, v0

    const/16 v0, 0x16

    aput-object v26, v2, v0

    const/16 v0, 0x17

    aput-object v27, v2, v0

    const/16 v0, 0x18

    aput-object v6, v2, v0

    .line 245
    sput-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->$VALUES:[Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;IZ)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(Z)V"
        }
    .end annotation

    .line 318
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 319
    iput-boolean p3, p0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->mIsHardReason:Z

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;
    .locals 1

    .line 245
    const-class v0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;
    .locals 1

    .line 245
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->$VALUES:[Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;

    return-object v0
.end method


# virtual methods
.method public isHardReason()Z
    .locals 0

    .line 308
    iget-boolean p0, p0, Lcom/android/internal/telephony/data/DataEvaluation$DataDisallowedReason;->mIsHardReason:Z

    return p0
.end method
