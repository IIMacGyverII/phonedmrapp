.class public final enum Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;
.super Ljava/lang/Enum;
.source "DataEvaluation.java"


# annotations
.annotation build Lcom/android/internal/annotations/VisibleForTesting;
.end annotation

.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataEvaluation;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "DataEvaluationReason"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum DATA_CONFIG_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum DATA_ENABLED_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum DATA_ENABLED_OVERRIDE_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum DATA_HANDOVER:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum DATA_NETWORK_CAPABILITIES_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum DATA_PROFILES_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum DATA_RESTRICTED_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum DATA_RETRY:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum DATA_SERVICE_STATE_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum EMERGENCY_CALL_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum EXTERNAL_QUERY:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum NEW_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum PREFERRED_TRANSPORT_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum RETRY_AFTER_DISCONNECTED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum ROAMING_ENABLED_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum SIM_LOADED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum SIM_REMOVAL:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum SINGLE_DATA_NETWORK_ARBITRATION:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum SLICE_CONFIG_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum TAC_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

.field public static final enum VOICE_CALL_ENDED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;


# direct methods
.method static constructor <clinit>()V
    .locals 24

    .line 198
    new-instance v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v1, "NEW_REQUEST"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->NEW_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 200
    new-instance v1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v3, "DATA_CONFIG_CHANGED"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_CONFIG_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 202
    new-instance v3, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v5, "SIM_LOADED"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->SIM_LOADED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 204
    new-instance v5, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v7, "SIM_REMOVAL"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->SIM_REMOVAL:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 206
    new-instance v7, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v9, "DATA_PROFILES_CHANGED"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_PROFILES_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 208
    new-instance v9, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v11, "DATA_SERVICE_STATE_CHANGED"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v9, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_SERVICE_STATE_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 210
    new-instance v11, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v13, "DATA_ENABLED_CHANGED"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v11, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_ENABLED_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 212
    new-instance v13, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v15, "DATA_ENABLED_OVERRIDE_CHANGED"

    const/4 v14, 0x7

    invoke-direct {v13, v15, v14}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v13, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_ENABLED_OVERRIDE_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 214
    new-instance v15, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v14, "ROAMING_ENABLED_CHANGED"

    const/16 v12, 0x8

    invoke-direct {v15, v14, v12}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v15, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->ROAMING_ENABLED_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 216
    new-instance v14, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v12, "VOICE_CALL_ENDED"

    const/16 v10, 0x9

    invoke-direct {v14, v12, v10}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v14, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->VOICE_CALL_ENDED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 218
    new-instance v12, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v10, "DATA_RESTRICTED_CHANGED"

    const/16 v8, 0xa

    invoke-direct {v12, v10, v8}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v12, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_RESTRICTED_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 220
    new-instance v10, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v8, "DATA_NETWORK_CAPABILITIES_CHANGED"

    const/16 v6, 0xb

    invoke-direct {v10, v8, v6}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v10, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_NETWORK_CAPABILITIES_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 222
    new-instance v8, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v6, "EMERGENCY_CALL_CHANGED"

    const/16 v4, 0xc

    invoke-direct {v8, v6, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v8, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->EMERGENCY_CALL_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 224
    new-instance v6, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v4, "RETRY_AFTER_DISCONNECTED"

    const/16 v2, 0xd

    invoke-direct {v6, v4, v2}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->RETRY_AFTER_DISCONNECTED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 226
    new-instance v4, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v2, "DATA_RETRY"

    move-object/from16 v17, v6

    const/16 v6, 0xe

    invoke-direct {v4, v2, v6}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_RETRY:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 228
    new-instance v2, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v6, "DATA_HANDOVER"

    move-object/from16 v18, v4

    const/16 v4, 0xf

    invoke-direct {v2, v6, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->DATA_HANDOVER:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 230
    new-instance v6, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v4, "PREFERRED_TRANSPORT_CHANGED"

    move-object/from16 v19, v2

    const/16 v2, 0x10

    invoke-direct {v6, v4, v2}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->PREFERRED_TRANSPORT_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 232
    new-instance v4, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v2, "SLICE_CONFIG_CHANGED"

    move-object/from16 v20, v6

    const/16 v6, 0x11

    invoke-direct {v4, v2, v6}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->SLICE_CONFIG_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 237
    new-instance v2, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v6, "SINGLE_DATA_NETWORK_ARBITRATION"

    move-object/from16 v21, v4

    const/16 v4, 0x12

    invoke-direct {v2, v6, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->SINGLE_DATA_NETWORK_ARBITRATION:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 239
    new-instance v6, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v4, "EXTERNAL_QUERY"

    move-object/from16 v22, v2

    const/16 v2, 0x13

    invoke-direct {v6, v4, v2}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v6, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->EXTERNAL_QUERY:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    .line 241
    new-instance v4, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const-string v2, "TAC_CHANGED"

    move-object/from16 v23, v6

    const/16 v6, 0x14

    invoke-direct {v4, v2, v6}, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;-><init>(Ljava/lang/String;I)V

    sput-object v4, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->TAC_CHANGED:Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const/16 v2, 0x15

    new-array v2, v2, [Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    const/16 v16, 0x0

    aput-object v0, v2, v16

    const/4 v0, 0x1

    aput-object v1, v2, v0

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

    aput-object v8, v2, v0

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

    aput-object v4, v2, v6

    .line 195
    sput-object v2, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->$VALUES:[Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 196
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;
    .locals 1

    .line 195
    const-class v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;
    .locals 1

    .line 195
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->$VALUES:[Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/data/DataEvaluation$DataEvaluationReason;

    return-object v0
.end method
