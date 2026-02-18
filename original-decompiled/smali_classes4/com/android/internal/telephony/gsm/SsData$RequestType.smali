.class public final enum Lcom/android/internal/telephony/gsm/SsData$RequestType;
.super Ljava/lang/Enum;
.source "SsData.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/gsm/SsData;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "RequestType"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/gsm/SsData$RequestType;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/gsm/SsData$RequestType;

.field public static final enum SS_ACTIVATION:Lcom/android/internal/telephony/gsm/SsData$RequestType;

.field public static final enum SS_DEACTIVATION:Lcom/android/internal/telephony/gsm/SsData$RequestType;

.field public static final enum SS_ERASURE:Lcom/android/internal/telephony/gsm/SsData$RequestType;

.field public static final enum SS_INTERROGATION:Lcom/android/internal/telephony/gsm/SsData$RequestType;

.field public static final enum SS_REGISTRATION:Lcom/android/internal/telephony/gsm/SsData$RequestType;


# direct methods
.method static constructor <clinit>()V
    .locals 11

    .line 83
    new-instance v0, Lcom/android/internal/telephony/gsm/SsData$RequestType;

    const-string v1, "SS_ACTIVATION"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/gsm/SsData$RequestType;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/gsm/SsData$RequestType;->SS_ACTIVATION:Lcom/android/internal/telephony/gsm/SsData$RequestType;

    .line 84
    new-instance v1, Lcom/android/internal/telephony/gsm/SsData$RequestType;

    const-string v3, "SS_DEACTIVATION"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/gsm/SsData$RequestType;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/gsm/SsData$RequestType;->SS_DEACTIVATION:Lcom/android/internal/telephony/gsm/SsData$RequestType;

    .line 85
    new-instance v3, Lcom/android/internal/telephony/gsm/SsData$RequestType;

    const-string v5, "SS_INTERROGATION"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/gsm/SsData$RequestType;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/gsm/SsData$RequestType;->SS_INTERROGATION:Lcom/android/internal/telephony/gsm/SsData$RequestType;

    .line 86
    new-instance v5, Lcom/android/internal/telephony/gsm/SsData$RequestType;

    const-string v7, "SS_REGISTRATION"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/gsm/SsData$RequestType;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/gsm/SsData$RequestType;->SS_REGISTRATION:Lcom/android/internal/telephony/gsm/SsData$RequestType;

    .line 87
    new-instance v7, Lcom/android/internal/telephony/gsm/SsData$RequestType;

    const-string v9, "SS_ERASURE"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/gsm/SsData$RequestType;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/gsm/SsData$RequestType;->SS_ERASURE:Lcom/android/internal/telephony/gsm/SsData$RequestType;

    const/4 v9, 0x5

    new-array v9, v9, [Lcom/android/internal/telephony/gsm/SsData$RequestType;

    aput-object v0, v9, v2

    aput-object v1, v9, v4

    aput-object v3, v9, v6

    aput-object v5, v9, v8

    aput-object v7, v9, v10

    .line 82
    sput-object v9, Lcom/android/internal/telephony/gsm/SsData$RequestType;->$VALUES:[Lcom/android/internal/telephony/gsm/SsData$RequestType;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 82
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/gsm/SsData$RequestType;
    .locals 1

    .line 82
    const-class v0, Lcom/android/internal/telephony/gsm/SsData$RequestType;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/gsm/SsData$RequestType;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/gsm/SsData$RequestType;
    .locals 1

    .line 82
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$RequestType;->$VALUES:[Lcom/android/internal/telephony/gsm/SsData$RequestType;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/gsm/SsData$RequestType;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/gsm/SsData$RequestType;

    return-object v0
.end method


# virtual methods
.method public isTypeInterrogation()Z
    .locals 1

    .line 90
    sget-object v0, Lcom/android/internal/telephony/gsm/SsData$RequestType;->SS_INTERROGATION:Lcom/android/internal/telephony/gsm/SsData$RequestType;

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method
