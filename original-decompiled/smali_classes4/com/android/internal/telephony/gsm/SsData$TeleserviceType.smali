.class public final enum Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;
.super Ljava/lang/Enum;
.source "SsData.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/gsm/SsData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "TeleserviceType"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

.field public static final enum SS_ALL_DATA_TELESERVICES:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

.field public static final enum SS_ALL_TELESERVICES_EXCEPT_SMS:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

.field public static final enum SS_ALL_TELESEVICES:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

.field public static final enum SS_ALL_TELE_AND_BEARER_SERVICES:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

.field public static final enum SS_SMS_SERVICES:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

.field public static final enum SS_TELEPHONY:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;


# direct methods
.method static constructor <clinit>()V
    .locals 13

    .line 95
    new-instance v0, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    const-string v1, "SS_ALL_TELE_AND_BEARER_SERVICES"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;->SS_ALL_TELE_AND_BEARER_SERVICES:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    .line 96
    new-instance v1, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    const-string v3, "SS_ALL_TELESEVICES"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;->SS_ALL_TELESEVICES:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    .line 97
    new-instance v3, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    const-string v5, "SS_TELEPHONY"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;->SS_TELEPHONY:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    .line 98
    new-instance v5, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    const-string v7, "SS_ALL_DATA_TELESERVICES"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;->SS_ALL_DATA_TELESERVICES:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    .line 99
    new-instance v7, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    const-string v9, "SS_SMS_SERVICES"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;->SS_SMS_SERVICES:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    .line 100
    new-instance v9, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    const-string v11, "SS_ALL_TELESERVICES_EXCEPT_SMS"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12}, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;-><init>(Ljava/lang/String;I)V

    sput-object v9, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;->SS_ALL_TELESERVICES_EXCEPT_SMS:Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    const/4 v11, 0x6

    new-array v11, v11, [Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    aput-object v0, v11, v2

    aput-object v1, v11, v4

    aput-object v3, v11, v6

    aput-object v5, v11, v8

    aput-object v7, v11, v10

    aput-object v9, v11, v12

    .line 94
    sput-object v11, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;->$VALUES:[Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 94
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;
    .locals 1

    .line 94
    const-class v0, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;
    .locals 1

    .line 94
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;->$VALUES:[Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/gsm/SsData$TeleserviceType;

    return-object v0
.end method
