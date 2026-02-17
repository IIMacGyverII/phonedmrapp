.class public final enum Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;
.super Ljava/lang/Enum;
.source "PhoneInternalInterface.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/android/internal/telephony/PhoneInternalInterface;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "SuppService"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

.field public static final enum CONFERENCE:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

.field public static final enum HANGUP:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

.field public static final enum HOLD:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

.field public static final enum REJECT:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

.field public static final enum RESUME:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

.field public static final enum SEPARATE:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

.field public static final enum SWITCH:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

.field public static final enum TRANSFER:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

.field public static final enum UNKNOWN:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;


# direct methods
.method static constructor <clinit>()V
    .locals 16

    .line 73
    new-instance v0, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const-string v1, "UNKNOWN"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->UNKNOWN:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    new-instance v1, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const-string v3, "SWITCH"

    const/4 v4, 0x1

    invoke-direct {v1, v3, v4}, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;-><init>(Ljava/lang/String;I)V

    sput-object v1, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->SWITCH:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    new-instance v3, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const-string v5, "SEPARATE"

    const/4 v6, 0x2

    invoke-direct {v3, v5, v6}, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;-><init>(Ljava/lang/String;I)V

    sput-object v3, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->SEPARATE:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    new-instance v5, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const-string v7, "TRANSFER"

    const/4 v8, 0x3

    invoke-direct {v5, v7, v8}, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;-><init>(Ljava/lang/String;I)V

    sput-object v5, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->TRANSFER:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    new-instance v7, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const-string v9, "CONFERENCE"

    const/4 v10, 0x4

    invoke-direct {v7, v9, v10}, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;-><init>(Ljava/lang/String;I)V

    sput-object v7, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->CONFERENCE:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    new-instance v9, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const-string v11, "REJECT"

    const/4 v12, 0x5

    invoke-direct {v9, v11, v12}, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;-><init>(Ljava/lang/String;I)V

    sput-object v9, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->REJECT:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    new-instance v11, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const-string v13, "HANGUP"

    const/4 v14, 0x6

    invoke-direct {v11, v13, v14}, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;-><init>(Ljava/lang/String;I)V

    sput-object v11, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->HANGUP:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    new-instance v13, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const-string v15, "RESUME"

    const/4 v14, 0x7

    invoke-direct {v13, v15, v14}, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;-><init>(Ljava/lang/String;I)V

    sput-object v13, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->RESUME:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    new-instance v15, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const-string v14, "HOLD"

    const/16 v12, 0x8

    invoke-direct {v15, v14, v12}, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;-><init>(Ljava/lang/String;I)V

    sput-object v15, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->HOLD:Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    const/16 v14, 0x9

    new-array v14, v14, [Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    aput-object v0, v14, v2

    aput-object v1, v14, v4

    aput-object v3, v14, v6

    aput-object v5, v14, v8

    aput-object v7, v14, v10

    const/4 v0, 0x5

    aput-object v9, v14, v0

    const/4 v0, 0x6

    aput-object v11, v14, v0

    const/4 v0, 0x7

    aput-object v13, v14, v0

    aput-object v15, v14, v12

    .line 72
    sput-object v14, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->$VALUES:[Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 72
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;
    .locals 1

    .line 72
    const-class v0, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    return-object p0
.end method

.method public static values()[Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;
    .locals 1

    .line 72
    sget-object v0, Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->$VALUES:[Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    invoke-virtual {v0}, [Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/android/internal/telephony/PhoneInternalInterface$SuppService;

    return-object v0
.end method
