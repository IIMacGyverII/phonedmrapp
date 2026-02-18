.class public final enum Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;
.super Ljava/lang/Enum;
.source "DataConnectionReasons.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "DataDisallowedReasonType"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum APN_NOT_CONNECTABLE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum CONCURRENT_VOICE_DATA_NOT_ALLOWED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum DATA_ALREADY_CONNECTED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum DATA_DISABLED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum DATA_IS_CONNECTING:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum DATA_IS_DISCONNECTING:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum DATA_SERVICE_NOT_READY:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum DATA_THROTTLED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum DEFAULT_DATA_UNSELECTED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum DISABLED_BY_QNS:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum INTERNAL_DATA_DISABLED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum INVALID_PHONE_STATE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum IN_ECBM:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum NOT_ATTACHED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum NOT_ON_NR:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum ON_IWLAN:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum ON_OTHER_TRANSPORT:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum PS_RESTRICTED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum RADIO_DISABLED_BY_CARRIER:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum ROAMING_DISABLED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum SIM_NOT_READY:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

.field public static final enum UNDESIRED_POWER_STATE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;


# instance fields
.field private mIsHardReason:Z


# direct methods
.method static constructor <clinit>()V
    .locals 26

    .line 114
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v1, "DATA_DISABLED"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2, v2}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->DATA_DISABLED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 116
    new-instance v1, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v3, "ROAMING_DISABLED"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4, v2}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v1, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->ROAMING_DISABLED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 118
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v5, "DEFAULT_DATA_UNSELECTED"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6, v2}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v3, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->DEFAULT_DATA_UNSELECTED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 121
    new-instance v5, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v7, "NOT_ATTACHED"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v5, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->NOT_ATTACHED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 122
    new-instance v7, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v9, "SIM_NOT_READY"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v7, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->SIM_NOT_READY:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 123
    new-instance v9, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v11, "INVALID_PHONE_STATE"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v9, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->INVALID_PHONE_STATE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 124
    new-instance v11, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v13, "CONCURRENT_VOICE_DATA_NOT_ALLOWED"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v11, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->CONCURRENT_VOICE_DATA_NOT_ALLOWED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 125
    new-instance v13, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v15, "PS_RESTRICTED"

    const/4 v14, 0x7

    invoke-direct {v13, v15, v14, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v13, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->PS_RESTRICTED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 126
    new-instance v15, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v14, "UNDESIRED_POWER_STATE"

    const/16 v12, 0x8

    invoke-direct {v15, v14, v12, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v15, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->UNDESIRED_POWER_STATE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 127
    new-instance v14, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v12, "INTERNAL_DATA_DISABLED"

    const/16 v10, 0x9

    invoke-direct {v14, v12, v10, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v14, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->INTERNAL_DATA_DISABLED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 128
    new-instance v12, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v10, "RADIO_DISABLED_BY_CARRIER"

    const/16 v8, 0xa

    invoke-direct {v12, v10, v8, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v12, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->RADIO_DISABLED_BY_CARRIER:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 130
    new-instance v10, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v8, "APN_NOT_CONNECTABLE"

    const/16 v6, 0xb

    invoke-direct {v10, v8, v6, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v10, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->APN_NOT_CONNECTABLE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 132
    new-instance v8, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v6, "DATA_IS_CONNECTING"

    const/16 v2, 0xc

    invoke-direct {v8, v6, v2, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v8, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->DATA_IS_CONNECTING:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 134
    new-instance v6, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v2, "DATA_IS_DISCONNECTING"

    move-object/from16 v17, v8

    const/16 v8, 0xd

    invoke-direct {v6, v2, v8, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v6, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->DATA_IS_DISCONNECTING:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 136
    new-instance v2, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v8, "DATA_ALREADY_CONNECTED"

    move-object/from16 v18, v6

    const/16 v6, 0xe

    invoke-direct {v2, v8, v6, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v2, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->DATA_ALREADY_CONNECTED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 138
    new-instance v8, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v6, "ON_IWLAN"

    move-object/from16 v19, v2

    const/16 v2, 0xf

    invoke-direct {v8, v6, v2, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v8, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->ON_IWLAN:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 140
    new-instance v6, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v2, "NOT_ON_NR"

    move-object/from16 v20, v8

    const/16 v8, 0x10

    invoke-direct {v6, v2, v8, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v6, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->NOT_ON_NR:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 142
    new-instance v2, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v8, "IN_ECBM"

    move-object/from16 v21, v6

    const/16 v6, 0x11

    invoke-direct {v2, v8, v6, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v2, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->IN_ECBM:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 144
    new-instance v8, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v6, "ON_OTHER_TRANSPORT"

    move-object/from16 v22, v2

    const/16 v2, 0x12

    invoke-direct {v8, v6, v2, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v8, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->ON_OTHER_TRANSPORT:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 146
    new-instance v6, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v2, "DATA_SERVICE_NOT_READY"

    move-object/from16 v23, v8

    const/16 v8, 0x13

    invoke-direct {v6, v2, v8, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v6, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->DATA_SERVICE_NOT_READY:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 149
    new-instance v2, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v8, "DISABLED_BY_QNS"

    move-object/from16 v24, v6

    const/16 v6, 0x14

    invoke-direct {v2, v8, v6, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v2, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->DISABLED_BY_QNS:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    .line 152
    new-instance v8, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const-string v6, "DATA_THROTTLED"

    move-object/from16 v25, v2

    const/16 v2, 0x15

    invoke-direct {v8, v6, v2, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;-><init>(Ljava/lang/String;IZ)V

    sput-object v8, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->DATA_THROTTLED:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const/16 v6, 0x16

    new-array v6, v6, [Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    const/16 v16, 0x0

    aput-object v0, v6, v16

    aput-object v1, v6, v4

    const/4 v0, 0x2

    aput-object v3, v6, v0

    const/4 v0, 0x3

    aput-object v5, v6, v0

    const/4 v0, 0x4

    aput-object v7, v6, v0

    const/4 v0, 0x5

    aput-object v9, v6, v0

    const/4 v0, 0x6

    aput-object v11, v6, v0

    const/4 v0, 0x7

    aput-object v13, v6, v0

    const/16 v0, 0x8

    aput-object v15, v6, v0

    const/16 v0, 0x9

    aput-object v14, v6, v0

    const/16 v0, 0xa

    aput-object v12, v6, v0

    const/16 v0, 0xb

    aput-object v10, v6, v0

    const/16 v0, 0xc

    aput-object v17, v6, v0

    const/16 v0, 0xd

    aput-object v18, v6, v0

    const/16 v0, 0xe

    aput-object v19, v6, v0

    const/16 v0, 0xf

    aput-object v20, v6, v0

    const/16 v0, 0x10

    aput-object v21, v6, v0

    const/16 v0, 0x11

    aput-object v22, v6, v0

    const/16 v0, 0x12

    aput-object v23, v6, v0

    const/16 v0, 0x13

    aput-object v24, v6, v0

    const/16 v0, 0x14

    aput-object v25, v6, v0

    aput-object v8, v6, v2

    .line 110
    sput-object v6, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->$VALUES:[Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;IZ)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(Z)V"
        }
    .end annotation

    .line 160
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 161
    iput-boolean p3, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->mIsHardReason:Z

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;
    .locals 1

    .line 110
    const-class v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;
    .locals 1

    .line 110
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->$VALUES:[Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;

    return-object v0
.end method


# virtual methods
.method isHardReason()Z
    .locals 0

    .line 157
    iget-boolean p0, p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataDisallowedReasonType;->mIsHardReason:Z

    return p0
.end method
