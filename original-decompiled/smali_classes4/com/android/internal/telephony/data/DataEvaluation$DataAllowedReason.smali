.class public final enum Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;
.super Ljava/lang/Enum;
.source "DataEvaluation.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/data/DataEvaluation;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "DataAllowedReason"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

.field public static final enum EMERGENCY_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

.field public static final enum EMERGENCY_SUPL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

.field public static final enum MMS_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

.field public static final enum NONE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

.field public static final enum NORMAL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

.field public static final enum RESTRICTED_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

.field public static final enum UNMETERED_USAGE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;


# direct methods
.method static constructor <clinit>()V
    .locals 15

    .line 333
    new-instance v0, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    const-string v1, "NONE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->NONE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    .line 337
    new-instance v1, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    const-string v3, "NORMAL"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->NORMAL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    .line 342
    new-instance v3, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    const-string v5, "UNMETERED_USAGE"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->UNMETERED_USAGE:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    .line 346
    new-instance v5, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    const-string v7, "MMS_REQUEST"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->MMS_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    .line 350
    new-instance v7, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    const-string v9, "RESTRICTED_REQUEST"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->RESTRICTED_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    .line 354
    new-instance v9, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    const-string v11, "EMERGENCY_SUPL"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12}, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;-><init>(Ljava/lang/String;I)V

    sput-object v9, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->EMERGENCY_SUPL:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    .line 359
    new-instance v11, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    const-string v13, "EMERGENCY_REQUEST"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14}, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;-><init>(Ljava/lang/String;I)V

    sput-object v11, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->EMERGENCY_REQUEST:Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    const/4 v13, 0x7

    new-array v13, v13, [Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    aput-object v0, v13, v2

    aput-object v1, v13, v4

    aput-object v3, v13, v6

    aput-object v5, v13, v8

    aput-object v7, v13, v10

    aput-object v9, v13, v12

    aput-object v11, v13, v14

    .line 326
    sput-object v13, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->$VALUES:[Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 326
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;
    .locals 1

    .line 326
    const-class v0, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;
    .locals 1

    .line 326
    sget-object v0, Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->$VALUES:[Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/data/DataEvaluation$DataAllowedReason;

    return-object v0
.end method
