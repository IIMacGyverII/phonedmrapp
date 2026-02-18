.class final enum Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;
.super Ljava/lang/Enum;
.source "DataConnectionReasons.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/dataconnection/DataConnectionReasons;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4018
    name = "DataAllowedReasonType"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

.field public static final enum EMERGENCY_APN:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

.field public static final enum NONE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

.field public static final enum NORMAL:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

.field public static final enum RESTRICTED_REQUEST:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

.field public static final enum UNMETERED_APN:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;


# direct methods
.method static constructor <clinit>()V
    .locals 11

    .line 170
    new-instance v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    const-string v1, "NONE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->NONE:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    .line 171
    new-instance v1, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    const-string v3, "NORMAL"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->NORMAL:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    .line 172
    new-instance v3, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    const-string v5, "UNMETERED_APN"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->UNMETERED_APN:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    .line 173
    new-instance v5, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    const-string v7, "RESTRICTED_REQUEST"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->RESTRICTED_REQUEST:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    .line 174
    new-instance v7, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    const-string v9, "EMERGENCY_APN"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->EMERGENCY_APN:Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    const/4 v9, 0x5

    new-array v9, v9, [Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    aput-object v0, v9, v2

    aput-object v1, v9, v4

    aput-object v3, v9, v6

    aput-object v5, v9, v8

    aput-object v7, v9, v10

    .line 166
    sput-object v9, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->$VALUES:[Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 166
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;
    .locals 1

    .line 166
    const-class v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;
    .locals 1

    .line 166
    sget-object v0, Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->$VALUES:[Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/dataconnection/DataConnectionReasons$DataAllowedReasonType;

    return-object v0
.end method
