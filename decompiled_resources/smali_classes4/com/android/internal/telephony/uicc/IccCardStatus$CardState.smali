.class public final enum Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;
.super Ljava/lang/Enum;
.source "IccCardStatus.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/uicc/IccCardStatus;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "CardState"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

.field public static final enum CARDSTATE_ABSENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum CARDSTATE_ERROR:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum CARDSTATE_PRESENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
    .end annotation
.end field

.field public static final enum CARDSTATE_RESTRICTED:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;


# direct methods
.method static constructor <clinit>()V
    .locals 9

    .line 35
    new-instance v0, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    const-string v1, "CARDSTATE_ABSENT"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_ABSENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    .line 37
    new-instance v1, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    const-string v3, "CARDSTATE_PRESENT"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_PRESENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    .line 39
    new-instance v3, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    const-string v5, "CARDSTATE_ERROR"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_ERROR:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    .line 41
    new-instance v5, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    const-string v7, "CARDSTATE_RESTRICTED"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_RESTRICTED:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    const/4 v7, 0x4

    new-array v7, v7, [Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    aput-object v0, v7, v2

    aput-object v1, v7, v4

    aput-object v3, v7, v6

    aput-object v5, v7, v8

    .line 34
    sput-object v7, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->$VALUES:[Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 34
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;
    .locals 1

    .line 34
    const-class v0, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;
    .locals 1

    .line 34
    sget-object v0, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->$VALUES:[Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    return-object v0
.end method


# virtual methods
.method public isCardPresent()Z
    .locals 1
    .annotation build Landroid/compat/annotation/UnsupportedAppUsage;
        maxTargetSdk = 0x1e
        trackingBug = 0xa2d2051L
    .end annotation

    .line 45
    sget-object v0, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_PRESENT:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    if-eq p0, v0, :cond_1

    sget-object v0, Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;->CARDSTATE_RESTRICTED:Lcom/android/internal/telephony/uicc/IccCardStatus$CardState;

    if-ne p0, v0, :cond_0

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
