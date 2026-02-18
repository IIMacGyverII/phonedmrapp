.class public final enum Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;
.super Ljava/lang/Enum;
.source "ImsPhoneCallTracker.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x401c
    name = "HoldSwapState"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

.field public static final enum HOLDING_TO_ANSWER_INCOMING:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

.field public static final enum HOLDING_TO_DIAL_OUTGOING:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

.field public static final enum INACTIVE:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

.field public static final enum PENDING_RESUME_FOREGROUND_AFTER_FAILURE:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

.field public static final enum PENDING_RESUME_FOREGROUND_AFTER_HOLD:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

.field public static final enum PENDING_SINGLE_CALL_HOLD:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

.field public static final enum PENDING_SINGLE_CALL_UNHOLD:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

.field public static final enum SWAPPING_ACTIVE_AND_HELD:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;


# direct methods
.method static constructor <clinit>()V
    .locals 16

    .line 506
    new-instance v0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    const-string v1, "INACTIVE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->INACTIVE:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    .line 508
    new-instance v1, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    const-string v3, "PENDING_SINGLE_CALL_HOLD"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->PENDING_SINGLE_CALL_HOLD:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    .line 510
    new-instance v3, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    const-string v5, "PENDING_SINGLE_CALL_UNHOLD"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->PENDING_SINGLE_CALL_UNHOLD:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    .line 512
    new-instance v5, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    const-string v7, "SWAPPING_ACTIVE_AND_HELD"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->SWAPPING_ACTIVE_AND_HELD:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    .line 514
    new-instance v7, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    const-string v9, "HOLDING_TO_ANSWER_INCOMING"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->HOLDING_TO_ANSWER_INCOMING:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    .line 516
    new-instance v9, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    const-string v11, "PENDING_RESUME_FOREGROUND_AFTER_FAILURE"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;-><init>(Ljava/lang/String;I)V

    sput-object v9, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->PENDING_RESUME_FOREGROUND_AFTER_FAILURE:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    .line 518
    new-instance v11, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    const-string v13, "HOLDING_TO_DIAL_OUTGOING"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;-><init>(Ljava/lang/String;I)V

    sput-object v11, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->HOLDING_TO_DIAL_OUTGOING:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    .line 520
    new-instance v13, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    const-string v15, "PENDING_RESUME_FOREGROUND_AFTER_HOLD"

    const/4 v14, 0x7

    invoke-direct {v13, v15, v14}, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;-><init>(Ljava/lang/String;I)V

    sput-object v13, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->PENDING_RESUME_FOREGROUND_AFTER_HOLD:Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    const/16 v15, 0x8

    new-array v15, v15, [Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    aput-object v0, v15, v2

    aput-object v1, v15, v4

    aput-object v3, v15, v6

    aput-object v5, v15, v8

    aput-object v7, v15, v10

    aput-object v9, v15, v12

    const/4 v0, 0x6

    aput-object v11, v15, v0

    aput-object v13, v15, v14

    .line 504
    sput-object v15, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->$VALUES:[Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 504
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;
    .locals 1

    .line 504
    const-class v0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;
    .locals 1

    .line 504
    sget-object v0, Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->$VALUES:[Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/imsphone/ImsPhoneCallTracker$HoldSwapState;

    return-object v0
.end method
